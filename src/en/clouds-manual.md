Title: Using the Manual cloud with Juju
TODO:  Bug tracking: https://bugs.launchpad.net/juju/+bug/1779917
       QUESTION: Does sudo on CentOS work? Does root on Ubuntu work?

# Using the Manual cloud with Juju

Juju caters for the case where you may not be able to access a traditional
cloud; maybe you can't create additional instances on an existing cloud; or
perhaps your cloud is really a collection of disparate hardware.

Whatever the case, as long as Juju can log into these machines they can be used
as a backing cloud for Juju. It won't be _quite_ the same as using a standard cloud
- without the ability to create new instances when they are desired, you will
be missing out on some of the Juju magic. You can still deploy and manage
applications though, with a bit of extra effort.

## Prerequisites

 - At least two machines are needed (one for the controller and one to deploy
   charms to).
 - The machines must have Ubuntu (or CentOS) installed.
 - The machines must be contactable over SSH using a user account with root
   privileges. On Ubuntu, `sudo` rights will suffice if this provides root
   access.
 - The machines must be able to contact each other over the network.

## Adding a Manual cloud

Use the interactive `add-cloud` command to add your Manual cloud to Juju's list
of clouds:

```bash
juju add-cloud
```

Example user session:

```no-highlight
       Cloud Types
        maas
        manual
        openstack
        oracle
        vsphere
      
      Select cloud type: manual
      
      Enter a name for your manual cloud: mymanual
      
      Enter the controller's hostname or IP address: noah@10.143.211.93
      
      Cloud "mymanual" successfully added
      You may bootstrap with 'juju bootstrap mymanual'
```

We've called the new cloud 'mymanual', used an IP address of 10.143.211.93 for
the intended controller, and a user account of 'noah' to connect to. Since the
'root' user was not used, the machine is probably running Ubuntu.

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud        Regions  Default          Type        Description
.
.
.
mymanual           0                   manual 
```

## Adding credentials

Credentials should already have been set up via SSH. Nothing to do!

## Creating a controller

You are now ready to create a Juju controller for cloud 'mymanul':

```bash
juju bootstrap mymanual manual-controller
```

Above, the name given to the new controller is 'manual-controller'. The
machine that will be allocated to run the controller on is the one specified
during the `add-cloud` step. In our example it is the machine with address
10.143.211.93.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## Adding machines to a Manual cloud

All the other cloud types provision machines automatically when the client
requests a machine to be added but in the case of the Manual cloud these
machines need to be pre-existing and added manually.

!!! Important:
    A Manual cloud requires at least one machine to be added.

For example, to add the machine with an IP address of 10.55.60.93 to the
'default' model in the Manual cloud (whose controller was named
'manual-controller'):

```bash
juju add-machine -m manual-controller:default ssh:noah@10.55.60.93
```

Unless you're using passphraseless public key authentication, you may be
prompted for a password a few times. The process takes a couple of minutes.

Once the command has returned, you can check that the machine is available:

```bash
juju machines -m manual-controller:default
```

Sample output:

```no-highlight
Machine  State    DNS          Inst id             Series  AZ  Message
0        started  10.55.60.93  manual:10.55.60.93  xenial      Manually provisioned machine
```

## Deploying a charm in a Manual cloud

All the other cloud types, by default, automatically provision a machine during
the charm deployment step but in the case of the Manual cloud the machine needs
to be pre-existing (and added using the `add-machine` process).

The pre-existing machine is targeted by means of the `--to` option. For
example, here we deploy WordPress on the machine '0' we added previously:

```bash
juju deploy wordpress --to 0
```

See [Deploying to specific machines][deploying-to-specific-machines] for more
information on targeting certain machines.

## Additional Manual cloud notes

The following notes are pertinent to the Manual cloud:

 - Juju machines are always managed on a per-model basis. With a Manual cloud
   the `add-machine` process will need to be repeated if the model hosting
   those machines is destroyed.
 - To improve the performance of provisioning newly-added machines consider
   running an APT proxy or an APT mirror. See
   [Offline mode strategies][charms-offline-strategies].

## Additional CentOS notes

One of the requirements for the Manual cloud is that SSH is running on the
participating machines, but for CentOS this may not be the case. To install SSH
run the following commands as the root user on the CentOS system:

```bash
yum install sudo openssh-server redhat-lsb-core
systemctl start sshd
```

Since you will be connecting to the root account during the `add-machine` step,
also ensure that there is a root password set on the CentOS machine.

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[models]: ./models.md
[charms]: ./charms.md
[charms-offline-strategies]: charms-offline-strategies.md
[deploying-to-specific-machines]: ./charms-deploying-advanced.md#deploying-to-specific-machines
[controllers-creating]: ./controllers-creating.md
