Title: Using the Manual cloud with Juju
TODO:  Bug tracking: https://bugs.launchpad.net/juju/+bug/1779917
       QUESTION: Will Manual work if sudo is used on CentOS? Does root on Ubuntu work?

# Using the Manual cloud with Juju

The purpose of the Manual cloud is to cater to the situation where you have
machines (of any nature) at your disposal and you want to create a backing
cloud out of them. If this collection of machines is composed solely of bare
metal you might opt for a MAAS cloud but note that such machines would also
require IPMI hardware and a MAAS infrastructure. The Manual cloud can therefore
both make use of a collection of disparate hardware as well as of machines of
varying natures (bare metal or virtual), all without any extra
overhead/infrastructure.

## Limitations

With any other cloud, the Juju client can trigger the creation of a backing
machine (e.g. a cloud instance) as they become necessary. In addition, the
client can also cause charms to be deployed automatically onto those
newly-created machines. However, with a Manual cloud the machines must
pre-exist and they must also be specifically targeted during charm deployment.

!!! Note:
    A MAAS cloud must also have pre-existing backing machines. However, Juju,
    by default, can deploy charms onto those machines, or add a machine to its
    pool of managed machines, without any extra effort.

## Prerequisites

The following conditions must be met:

 - At least two machines are needed (one for the controller and one to deploy
   charms to).
 - The machines must have Ubuntu (or CentOS) installed.
 - The machines must be contactable over SSH using a user account with root
   privileges. On Ubuntu, `sudo` rights will suffice if this provides root
   access.
 - The machines must be able to `ping` each other.

## Overview

A Manual cloud is initiated through the use of the `add-cloud` command. In this
step you specify an arbitrary cloud name, the intended controller (IP address
or hostname), and what user account the Juju client will attempt to contact
over SSH.

As usual, a controller is created with the `bootstrap` command and refers to
the cloud name.

Your collection of machines (minus the controller machine) *must* be added to
Juju by means of the `add-machine` command. A machine is specified by means of
its IP address.

!!! Important:
    A Manual cloud requires at least one machine to be added.

Finally, to deploy a charm the `deploy` command is used as normal. However, a
machine *must* be targeted. This latter is accomplished with the `--to` option
in conjunction with the machine ID.

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

You are now ready to create a Juju controller for cloud 'mymanual':

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

To add the machine with an IP address (and user) of bob@10.55.60.93 to the
'default' model in the Manual cloud (whose controller was named
'manual-controller'):

```bash
juju add-machine -m manual-controller:default ssh:bob@10.55.60.93
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

To deploy WordPress onto the machine we added previously its ID (of '0') is
made use of:

```bash
juju deploy -m manual-controller:default wordpress --to 0
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
