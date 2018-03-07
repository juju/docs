Title: Getting started with Juju and LXD
TODO:  Warning: Ubuntu release versions hardcoded
       Remove 10 uneeded image files in master (juju-lxd-config*.png)
       Remove 1 uneeded image file in master (tut-lxd-wiki-simple-status.png)

# Getting started with Juju and LXD

This guide will get you started quickly with Juju by setting up everything you
need on a single [Ubuntu 16.04 LTS][Xenial-download] (Xenial) system. It does
so by having Juju machines based on fast and secure containers, by way of
[LXD][lxd-upstream].

Using LXD with Juju provides an experience very similar to any other Juju
backing-cloud, including the large public clouds such as AWS. In addition,
because it is very easy to set up and uses minimal resources, a Juju & LXD
combination is an efficient way to develop, test, and replicate software
deployments. LXD has become an essential tool for every Juju operator.

These instructions will deliver the best-possible experience with Juju. They
will have you use the most recent stable version of LXD as well as a modern
filesystem upon which to run the containers: [ZFS][ZFS-wiki].

## Install the software

**Juju** is installed, as a snap, with the following command:

```bash
sudo snap install juju --classic
```

**LXD** should come from the 'xenial-backports' repository to ensure a recent
(and supported) version is used:

```bash
sudo apt install -t xenial-backports lxd
```

!!! Note:
    Installing LXD in this way will update LXD if it is already present on your
    system.

**ZFS** is installed like so:

```bash
sudo apt install zfsutils-linux
```

## User group

In order to use LXD, the system user that will act as the Juju operator must be
a member of the 'lxd' user group. Ensure that this is the case (below we assume
this user is 'john'):

```bash
sudo adduser john lxd
```

The user will be in the 'lxd' group when they next log in. If the intended Juju
operator is the current user all that's needed is a group membership refresh:

```bash
newgrp lxd
```

You can confirm the active group membership for the current user by running the
command:

```bash
groups
```

## LXD initialisation

LXD comes with an interactive initialisation that will both set up ZFS and
offer to configure what subnet the containers should use. Choosing to
auto-configure networking is a safe choice as a subnet will be intelligently
chosen such that it will not conflict with an existing local one.

Begin the process by entering:

```bash
sudo lxd init
```

The answers below are what were used to write this guide. Note that pressing
Enter (a null answer below) will accept the default answer (provided in square
brackets).

```no-highlight
Do you want to configure a new storage pool (yes/no) [default=yes]?
Name of the new storage pool [default=default]: lxd
Name of the storage backend to use (dir, btrfs, lvm, zfs) [default=zfs]:
Create a new ZFS pool (yes/no) [default=yes]?
Would you like to use an existing block device (yes/no) [default=no]?
Size in GB of the new loop device (1GB minimum) [default=15GB]: 20
Would you like LXD to be available over the network (yes/no) [default=no]?
Would you like stale cached images to be updated automatically (yes/no) [default=yes]?
Would you like to create a new network bridge (yes/no) [default=yes]?
What should the new bridge be called [default=lxdbr0]?
What IPv4 address should be used (CIDR subnet notation, "auto" or "none") [default=auto]?
What IPv6 address should be used (CIDR subnet notation, "auto" or "none") [default=auto]? none
```

LXD is now configured to work with Juju.

The (IPv4) subnet can be derived from the bridge's address:

```bash
lxc network get lxdbr0 ipv4.address
```

Our example gives:

```no-highlight
10.145.230.1/24
```

So the subnet address is **10.145.230.0/24**.

!!! Note:
    LXD adds iptables (firewall) rules to allow traffic to the subnet/bridge it
    created. If you subsequently add/change firewall settings (e.g. with
    `ufw`), ensure that such changes have not interfered with Juju's ability to
    communicate with LXD. Juju requires inbound traffic for TCP port 8443 from
    the LXD subnet.

## Create a controller

A controller is needed before you can start deploying applications. The
controller manages both the state and events for your models that host the
applications.

Create a controller with the `juju bootstrap` command by supplying the cloud
type and, optionally, a controller name. The LXD cloud type is known as
'localhost' and we'll give our controller the name of 'lxd-test'. The command
therefore becomes:

```bash
juju bootstrap localhost lxd-test
```

This may take a few minutes as LXD must download an image for Xenial. A cache
will be used for subsequent containers.

Once the process has completed you can check that the controller has been
created:

```bash
juju controllers
```

This will return a list of the controllers known to Juju. You can see our
'lxd-test' listed:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
lxd-test*   default  admin  superuser  localhost/localhost       2         1  none  2.3.4
```

A newly-created controller has two models: The 'controller' model, which should
be used only for internal Juju management, and a 'default' model, which is
ready for actual use. The controller model can only be removed by destroying
the controller itself.

The following command shows the currently active controller, model, and user:

```bash
juju whoami
```

Our example gives the following output:

```no-highlight
Controller:  lxd-test
Model:       default
User:        admin
```

## Deploy applications

You are now ready to deploy applications from among the hundreds included in
the Juju [Charm Store][charm-store]. It is a good idea to test your new model.
How about a MediaWiki site?

```bash
juju deploy wiki-simple
```

This will fetch a *bundle* from the Charm Store. A bundle is a pre-packaged set
of applications, in this case 'MediaWiki', and a database to run it with. Juju
will install both applications and leveraging the relation in the model between
them, configures the wiki to use the newly created database instance. This is
part of the magic of Juju: it isn't just about deploying software, Juju also
knows how applications coordinate together.

Installing shouldn't take long. You can check on how far Juju has got by
running the command:

```bash
juju status
```

When the applications have been installed, the output of the above command will
look something like this:

```no-highlight
[200~Model    Controller  Cloud/Region         Version  SLA
default  lxd-test    localhost/localhost  2.3.4    unsupported

App    Version  Status   Scale  Charm      Store       Rev  OS      Notes
mysql           unknown      1  mysql      jujucharms   55  ubuntu
wiki            unknown      1  mediawiki  jujucharms    5  ubuntu

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/0*  unknown   idle   0        10.145.230.70   3306/tcp
wiki/0*   unknown   idle   1        10.145.230.132  80/tcp

Machine  State    DNS             Inst id        Series  AZ  Message
0        started  10.145.230.70   juju-220ad6-0  trusty      Running
1        started  10.145.230.132  juju-220ad6-1  trusty      Running

Relation provider  Requirer       Interface  Type     Message
mysql:cluster      mysql:cluster  mysql-ha   peer
Mysql:db           wiki:db        mysql      regular
```

There is a lot of useful information there! The important parts for now are the
'App' section, which shows that MediaWiki and MySQL are installed, and the
'Unit' section, which shows the IP addresses allocated to each. These addresses
correspond to the subnet that was created for LXD earlier on.

From the above output, we can see that the IP address for the MediaWiki site is
10.145.230.132. Point your browser to that address to see the site.

![wiki in browser](./media/tut-lxd-wiki-simple-browser-2.png)

Congratulations, you have just deployed an application with Juju!

!!! Note:
    The easiest way to remove all the applications in a model and start afresh
    is to destroy the model (`juju destroy-model`) and then create a new one
    (`juju add-model`).

## Next Steps

Now that you have configured Juju to work with a local LXD cloud, you can
develop, test, and experiment with applications with speed, ease, and without
incurring public cloud costs.

We suggest you continue your journey by discovering:

 - [Add controllers for additional clouds][tut-cloud]
 - [Share your model with other users][share]


<!-- LINKS -->

[LXD-upstream]: https://linuxcontainers.org/lxd/ "LXD upstream"
[Xenial-download]: http://www.ubuntu.com/download/ "Xenial download"
[ZFS-wiki]: https://wiki.ubuntu.com/ZFS "ZFS Ubuntu wiki"
[charm-store]: https://jujucharms.com "Juju Charm Store"
[charms]: ./charms.html
[clouds]: ./clouds.html  "Configuring Juju Clouds"
[concepts]: ./juju-concepts.html "Juju concepts"
[keygen]: ./getting-started-keygen-win.html "How to generate an SSH key with Windows"
[long-term-support]: https://wiki.ubuntu.com/LTS "Long Term Support"
[share]: ./tut-users.html
[tut-cloud]: ./tut-google.html
