<!--
Todo:
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1779917
- QUESTION: Will Manual work if sudo is used on CentOS? Does root on Ubuntu work?
-->

The purpose of the Manual cloud is to cater to the situation where you have machines (of any nature) at your disposal and you want to create a backing cloud out of them. If this collection of machines is composed solely of bare metal you might opt for a [MAAS cloud](/t/using-maas-with-juju/1094) but note that such machines would also require [IPMI hardware](https://docs.maas.io/en/nodes-power-types) and a MAAS infrastructure. The Manual cloud can therefore both make use of a collection of disparate hardware as well as of machines of varying natures (bare metal or virtual), all without any extra overhead/infrastructure.

<h2 id="heading--limitations">Limitations</h2>

With any other cloud, the Juju client can trigger the creation of a backing machine (e.g. a cloud instance) as they become necessary. In addition, the client can also cause charms to be deployed automatically onto those newly-created machines. However, with a Manual cloud the machines must pre-exist and they must also be specifically targeted during charm deployment.

[note]
A MAAS cloud must also have pre-existing backing machines. However, Juju, by default, can deploy charms onto those machines, or add a machine to its pool of managed machines, without any extra effort.
[/note]

<h2 id="heading--prerequisites">Prerequisites</h2>

The following conditions must be met:

- At least two machines are needed (one for the controller and one to deploy charms to).
- The machines must have Ubuntu (or CentOS) installed.
- The machines must be contactable over SSH (either by password or public key) using a user account with root privileges. On Ubuntu, `sudo` rights will suffice if this provides root access.
- The machines must be able to `ping` each other.

<h2 id="heading--overview">Overview</h2>

A Manual cloud is initiated through the use of the `add-cloud` command. In this step you specify an arbitrary cloud name, the intended controller (IP address or hostname), and what user account the Juju client will attempt to contact over SSH.

As usual, a controller is created with the `bootstrap` command and refers to the cloud name.

Your collection of machines (minus the controller machine) *must* be added to Juju by means of the `add-machine` command. A machine is specified by means of its IP address.

[note type="caution"]
A Manual cloud requires at least one machine to be added.
[/note]

Finally, to deploy a charm the `deploy` command is used as normal. However, a machine *must* be targeted. This is accomplished with the `--to` option in conjunction with the machine ID.

<h2 id="heading--adding-a-manual-cloud">Adding a Manual cloud</h2>

Use the interactive `add-cloud` command to add your Manual cloud to Juju's list of clouds. You will need to supply a name you wish to call your cloud, the IP address (or hostname) for the machine you intend to use as a controller, and what remote user account to connect to over SSH (prepend 'user@' to the address/hostname).

To interactively add a cloud definition to the local client cache:

``` text
juju add-cloud
```

Example user session:

``` text
Cloud Types
  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: manual

Enter a name for your manual cloud: mymanual

Enter the controller's hostname or IP address: noah@10.143.211.93

Cloud "mymanual" successfully added
You may bootstrap with 'juju bootstrap mymanual'
```

We've called the new cloud 'mymanual', used an IP address of 10.143.211.93 for the intended controller, and a user account of 'noah' to connect to. Since the 'root' user was not used, the machine is probably running Ubuntu.

Confirm the addition of the cloud with the `clouds --local` command (just `clouds` on versions prior to `v.2.6.0`).

<h2 id="heading--adding-credentials">Adding credentials</h2>

Credentials should already have been set up via SSH. Nothing to do!

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'mymanual':

``` text
juju bootstrap mymanual manual-controller
```

Above, the name given to the new controller is 'manual-controller'. The machine that will be allocated to run the controller on is the one specified during the `add-cloud` step. In our example it is the machine with address 10.143.211.93.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--adding-machines-to-a-manual-cloud">Adding machines to a Manual cloud</h2>

To add the machine with an IP address (and user) of bob@10.55.60.93 to the 'default' model in the Manual cloud (whose controller was named 'manual-controller'):

``` text
juju add-machine ssh:bob@10.55.60.93
```

Unless you're using passphraseless public key authentication, you may be prompted for a password a few times. The process takes a couple of minutes.

Once the command has returned, you can check that the machine is available:

``` text
juju machines
```

Sample output:

``` text
Machine  State    DNS          Inst id             Series  AZ  Message
0        started  10.55.60.93  manual:10.55.60.93  xenial      Manually provisioned machine
```

<h2 id="heading--deploying-a-charm-in-a-manual-cloud">Deploying a charm in a Manual cloud</h2>

To deploy WordPress onto the machine we need to declare the ID (of '0') of the machine:

``` text
juju deploy wordpress --to 0
```

See [Deploying to specific machines](/t/deploying-applications-advanced/1061#heading--deploying-to-specific-machines) for more information on targeting certain machines.

<h2 id="heading--additional-manual-cloud-notes">Additional Manual cloud notes</h2>

The following notes are pertinent to the Manual cloud:

-   Juju machines are always managed on a per-model basis. With a Manual cloud the `add-machine` process will need to be repeated if the model hosting those machines is destroyed.
-   To improve the performance of provisioning newly-added machines consider running an APT proxy or an APT mirror. See [Offline mode strategies](/t/offline-mode-strategies/1071).

<h2 id="heading--additional-centos-notes">Additional CentOS notes</h2>

One of the requirements for the Manual cloud is that SSH is running on the participating machines, but for CentOS this may not be the case. To install SSH run the following commands as the root user on the CentOS system:

``` text
yum install sudo openssh-server redhat-lsb-core
systemctl start sshd
```

Since you will be connecting to the root account during the `add-machine` step, also ensure that there is a root password set on the CentOS machine.

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
