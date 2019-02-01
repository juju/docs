Title: Basic client usage - tutorial
TODO:  Warning: Ubuntu release versions hardcoded
       tutorials at the bottom may get renamed

# Basic client usage - tutorial

This guide will get you started quickly with Juju by setting up everything you
need on a single [Ubuntu 18.04 LTS][bionic-download] (Bionic) system. It does
so by having Juju machines based on fast and secure containers, by way of
[LXD][lxd-upstream].

Using LXD with Juju provides an experience very similar to any other backing
cloud. In addition, because it is very easy to set up and uses minimal
resources, a Juju & LXD combination is an efficient way to develop, test, and
replicate software deployments. 

!!! Important:
    We'll be removing the LXD deb package and replacing it with the snap. Find
    another system for this tutorial if LXD is already in use.

## Software

Install Juju and LXD. Then remove the LXD deb package:

```bash
sudo snap install juju --classic
sudo snap install lxd
sudo apt purge liblxc1 lxcfs lxd lxd-client
```

## User group

Ideally, the system user that will act as the Juju operator should be a member
of the 'lxd' user group. Ensure that this is the case (below we assume this
user is 'john'):

```bash
sudo adduser john lxd
```

The user will now be in the 'lxd' group when they next log in. If the intended
Juju operator is the current user all that's needed is a group membership
refresh:

```bash
newgrp lxd
```

To confirm the active group membership for the current user:

```bash
groups
```

## LXD initialisation

LXD has an optional interactive initialisation method and it's what we'll use
here. Among other things, this process will both set up storage (ZFS) and the
containers' subnet. We'll choose to have networking auto-configured (answer
'auto') as a subnet will be chosen such that it will not conflict with an
existing one.

Begin by entering:

```bash
lxd init
```

The session below is what was used in this guide. Note that pressing Enter (a
null answer) will accept the default answer (provided in square brackets).

```no-highlight
Would you like to use LXD clustering? (yes/no) [default=no]: 
Do you want to configure a new storage pool? (yes/no) [default=yes]: 
Name of the new storage pool [default=default]: 
Name of the storage backend to use (btrfs, ceph, dir, lvm, zfs) [default=zfs]: 
Create a new ZFS pool? (yes/no) [default=yes]: 
Would you like to use an existing block device? (yes/no) [default=no]: 
Size in GB of the new loop device (1GB minimum) [default=15GB]: 
Would you like to connect to a MAAS server? (yes/no) [default=no]: 
Would you like to create a new local network bridge? (yes/no) [default=yes]: 
What should the new bridge be called? [default=lxdbr0]: 
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: 
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: none
Would you like LXD to be available over the network? (yes/no) [default=no]: 
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] 
would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

LXD is now configured to work with Juju.

IPv6 was disabled (answer 'none') because Juju does not support it at this
time.

The (IPv4) subnet can be derived from the bridge's address:

```bash
lxc network get lxdbr0 ipv4.address
```

Our example gives:

```no-highlight
10.238.229.1/24
```

So the subnet address is **10.238.229.0/24**.

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

Create a controller with the `bootstrap` command by supplying the cloud name
and, optionally, a controller name. The local LXD cloud is known as 'localhost'
and we'll call our controller 'lxd'. The command therefore becomes:

```bash
juju bootstrap localhost lxd
```

This may take a few minutes as LXD must download an image to use for the new
LXD container. A cache will be used for subsequent containers.

The container will also run Bionic, the current default for any Juju
controller.

Once the process has completed you can check that the controller has been
created:

```bash
juju controllers
```

This will return a list of all the controllers known to your Juju client. You
can see our 'lxd' listed:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
lxd-test*   default  admin  superuser  localhost/localhost       2         1  none  2.4.3
```

A newly-created controller has two models: The 'controller' model, which should
be used only for internal Juju management, and a 'default' model, which is
ready for actual use.

The following command shows the currently active controller, model, and user:

```bash
juju whoami
```

Our example gives the following output:

```no-highlight
Controller:  lxd
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

This will download a *bundle* from the Charm Store. A bundle is a pre-packaged
set of applications, in this case 'MediaWiki' and a database to run it with.
These will be installed and configured to work together. Sweet.

You can check on how far Juju has got by running the `status` command:

```bash
juju status
```

Once finished, the output will look something like this:

```no-highlight
Model    Controller  Cloud/Region         Version  SLA          Timestamp
default  lxd-test    localhost/localhost  2.4.3    unsupported  00:21:29Z

App    Version  Status   Scale  Charm      Store       Rev  OS      Notes
mysql           unknown      1  mysql      jujucharms   55  ubuntu  
wiki            unknown      1  mediawiki  jujucharms    5  ubuntu  

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/0*  unknown   idle   0        10.216.208.85   3306/tcp  
wiki/0*   unknown   idle   1        10.216.208.9    80/tcp    

Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.216.208.85  juju-2bfd31-0  trusty      Running
1        started  10.216.208.9   juju-2bfd31-1  trusty      Running
```

There is a lot of information there! The important parts for now are the 'App'
section, which shows that MediaWiki and MySQL are installed, and the 'Unit'
section, which shows the IP addresses allocated to each. These addresses
correspond to the subnet that was created for LXD earlier on.

From the above output, we can see that the IP address for the MediaWiki site is
10.216.208.9. Point your browser to that address to access the site:

![wiki in browser](https://assets.ubuntu.com/v1/a9092b3b-tut-lxd-wiki-simple-browser-3.png)

Congratulations, you have just deployed a database-driven MediaWiki site with
Juju!

!!! Positive "Pro tip":
    Removing the model (`juju destroy-model`) is a quick way to remove all the
    applications and machines in that model. Then begin again by creating a new
    one (`juju add-model`).

## Next steps

To continue your journey with Juju we suggest the following topics:

 - [Multi-user cloud][tut-users]


<!-- LINKS -->

[lxd-upstream]: https://linuxcontainers.org/lxd/
[bionic-download]: http://www.ubuntu.com/download/
[zfs-wiki]: https://wiki.ubuntu.com/ZFS
[charm-store]: https://jujucharms.com
[charms]: ./charms.md
[clouds]: ./clouds.md
[tut-users]: ./tut-users.md
