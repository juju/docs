Title: Getting started with Juju and LXD
TODO:  Warning: Ubuntu release versions hardcoded
       General review required (exact commands and their output especially)
       Subnet in the walkthrough and the example/screenshots do not correspond
       Some command output is CLI and some is via Desktop terminal

# Getting started with Juju and LXD

This guide will get you started quickly with Juju by setting up everything you
need on a single [Ubuntu 16.04 LTS][Xenial-download] (Xenial) system. It does
so by having Juju machines based on fast and secure containers, by way of
[LXD][lxd-upstream].

Using LXD with Juju provides an experience very similar, if not identical, to
any other Juju backing-cloud, including the large public clouds such as AWS.

Finally, because it is very easy to set up and uses minimal resources, a Juju &
LXD combination is an efficient way to develop, test, and replicate software
deployments. LXD is an essential tool for every Juju operator.

These instructions will deliver the best-possible experience with Juju. They
will have you use a recent version of LXD as well as a modern filesystem upon
which to run the containers: [ZFS][ZFS-wiki].

## Install the software

**Juju** is installed, as a snap, with the following command:

```bash
sudo snap install juju --classic
```

**LXD** should come from the 'xenial-backports' repository. This will ensure a
recent (and supported) version is used:

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

## Groups

In order to use LXD, the system user that will act as the Juju operator must be
a member of the 'lxd' group. This may already be the case, but you can confirm
this by running the command:

```bash
groups
```

If 'lxd' is absent from the group listing you will need to get the user (here
user 'ubuntu') added to the group:

```bash
sudo adduser ubuntu lxd
```

Once that user logs in they should be good to go. If the user in question is
the one issuing the above command (i.e. the admin user is 'ubuntu') then that
user need just refresh their groups with:

```bash
newgrp lxd
```

LXD automatically configures a random subnet for the containers to use. In the
event that it conflicts with an existing subnet some intervention will be
required on your part. See [LXD initialisation][lxd-initialisation] for
guidance.

## LXD initialisation

LXD includes an interactive initialisation which includes setting up
a ZFS pool and appropriate networking for your LXD containers. To start this
process, enter:

```bash
sudo lxd init
```

You will be asked several questions to configure LXD for use. Pressing Enter
will accept the default answer (provided in square brackets).

```no-highlight
Name of the storage backend to use (dir or zfs) [default=zfs]:
Create a new ZFS pool (yes/no) [default=yes]?
Name of the new ZFS pool [default=lxd]:
Would you like to use an existing block device (yes/no) [default=no]?
Size in GB of the new loop device (1GB minimum) [default=10GB]: 20
Would you like LXD to be available over the network (yes/no) [default=no]?
Do you want to configure the LXD bridge (yes/no) [default=yes]?
```

The bridge network will then be configured via a second round of questions.
Except in the case where the randomly chosen subnet may conflict with an
existing one in your local environment, it is fine to accept all the default
answers. IPv6 networking (the last question) is not required for Juju.

^# Walkthrough of network configuration

   In order for networking to be established between containers and Juju, you
   need to set up a bridge device.

   !["step 1"](./media/juju-lxd-config001.png)

   The default name for the bridge device is `lxdbr0`. This name _must_ be used
   for Juju to be able to connect to the containers.

   !["step 2"](./media/juju-lxd-config002.png)

   Juju will expect an IPv4 network space for the containers, so you should
   enable this.

   !["step 3"](./media/juju-lxd-config003.png)

   The default address is chosen randomly in the 10.x.x.x space. You do not
   need to change this unless it conflicts with another subnet you know is on
   your network.

   !["step 4"](./media/juju-lxd-config004.png)

   You need to enter a [CIDR](https://tools.ietf.org/html/rfc4632) mask value.
   The default of 24 gives you a possible 254 addresses for the subnet.

   !["step 5"](./media/juju-lxd-config005.png)

   You can now specify the start of the DHCP address range...

   !["step 6"](./media/juju-lxd-config006.png)

   And the end address of the range...

   !["step 7"](./media/juju-lxd-config007.png)

   You can also specify the total number of DHCP clients to accept.

   !["step 8"](./media/juju-lxd-config008.png)

   Finally for IPv4, enable Network Address Translation (NAT) to allow the
   containers to communicate with the outside world.

   !["step 9"](./media/juju-lxd-config009.png)

   You can continue to set up a similar IPv6 bridge device, but this is not
   necessary for Juju.

   !["step 10"](./media/juju-lxd-config010.png)

!!! Note:
    LXD adds iptables (firewall) rules to allow traffic to the
    subnet/bridge it created. If you subsequently add/change firewall settings
    (e.g. with `ufw`), ensure that such changes have not interfered with Juju's
    ability to communicate with LXD. Juju requires inbound traffic for TCP port
    8443 from the LXD subnet.

## Create a controller

Before you can start deploying applications, Juju needs to create a
controller. The controller manages both the state and events for your models
that host the applications.

The `juju bootstrap` command is used to create the controller. The command
expects a name (for referencing this controller) and a cloud to use. The LXD
'cloud' is known as 'localhost' to Juju.

For our localhost cloud, we will create a controller called 'lxd-test':

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
'lxd-test' listed.

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models Machines    HA  Version
lxd-test*   default  admin  superuser  localhost/localhost       2        1  none  2.2.2
```

A newly-created controller has two models: The 'controller' model, which should
be used only for internal Juju management, and a 'default' model, which is
ready for actual use. The controller model can only be removed by destroying
the controller itself.

The following command shows the currently active controller, model, and user:

```bash
juju whoami
```

In our example, the output should look like this:

```no-highlight
Controller:  lxd-test
Model:       default
User:        admin
```

## Deploy applications

You are now ready to deploy applications from among the hundreds included in
the [Juju charm store][charm store]. It is a good idea to test your new model.
How about a MediaWiki site?

```bash
juju deploy cs:bundle/wiki-simple
```

This will fetch a 'bundle' from the Juju store. A bundle is a pre-packaged set
of applications, in this case 'MediaWiki', and a database to run it
with. Juju will install both applications and leveraging the relation in the
model between them, configures the wiki to use the newly created database
instance. This is part of the magic of Juju: it isn't just about deploying
software, Juju also knows how applications coordinate together.

Installing shouldn't take long. You can check on how far Juju has got by
running the command:

```bash
juju status
```

When the applications have been installed, the output of the above command will
look something like this:

![juju status](./media/tut-lxd-wiki-simple-status.png)

There is a lot of useful information there! The important parts for now are
the 'App' section, which shows that MediaWiki and MySQL are installed, and the
'Unit' section, which shows the IP addresses allocated to each. These addresses
correspond to the subnet we created for LXD earlier on.

From the status output, we can see that the IP address for the MediaWiki
site we have created is 10.248.243.29. Point your browser to that address
to see the site.

![juju status](./media/tut-lxd-wiki-simple-browser.png)

Congratulations, you have just deployed an application with Juju!

!!! Note:
    The easiest way to remove all the applications in a model and start afresh
    is to destroy the model (`juju destroy-model`) and then create a new one
    (`juju add-model`).

## Next Steps

Now that you have configured Juju to work with a local LXD cloud, you can
develop, test, and experiment with applications with speed, ease, and without
additional public cloud costs.

We suggest you continue your journey by discovering:

 - [Add controllers for additional clouds][tut-cloud].
 - [Share your model with other users][share]


 <!-- LINKS -->

[LXD-upstream]: https://linuxcontainers.org/lxd/ "LXD upstream"
[Xenial-download]: http://www.ubuntu.com/download/ "Xenial download"
[ZFS-wiki]: https://wiki.ubuntu.com/ZFS "ZFS Ubuntu wiki"
[charm store]: https://jujucharms.com "Juju Charm Store"
[charms]: ./charms.html
[clouds]: ./clouds.html  "Configuring Juju Clouds"
[concepts]: ./juju-concepts.html "Juju concepts"
[keygen]: ./getting-started-keygen-win.html "How to generate an SSH key with Windows"
[long-term-support]: https://wiki.ubuntu.com/LTS "Long Term Support"
[share]: ./tut-users.html
[tut-cloud]: ./tut-google.html
[lxd-initialisation]: ./clouds-lxd-resources.html#lxd-initialisation
