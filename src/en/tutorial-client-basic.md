Title: Basic client usage - tutorial
TODO:  Warning: Ubuntu release versions hardcoded
       tutorials at the bottom may get renamed

# Basic client usage - tutorial

The goal of this tutorial is to give new Juju users a taste of what it's like
to use the command line client. It uses [LXD][lxd-upstream] as the backing
cloud due to it easy accessibility and low resource usage.

!!! Important:
    We'll be removing the LXD deb package and replacing it with the snap.
    Either find another system for this tutorial if LXD is already in use or
    follow the included instructions to migrate existing containers.

## Pre-requisites

The following criteria are assumed:

 - You're using Ubuntu 18.04 LTS (Bionic).
 - Juju (stable snap channel) is installed. See the [Installing Juju][install]
   page.
 - LXD is either not in use **or** you are willing to migrate existing
   containers to the snap.

## Installing LXD

On Ubuntu, LXD is normally installed by default as an APT (deb) package. We
recommend a transition to the snap package.

!!! Important:
    When transitioning to the snap, any possibly existing containers will need
    to be migrated over. See [Using the LXD snap][lxd-snap] for instructions.

Below, we add the snap and remove the deb:

```bash
sudo snap install lxd
sudo apt purge liblxc1 lxcfs lxd lxd-client
```

In order to use LXD, the system user who will act as the Juju operator must be
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

You can confirm the active group membership for the current user in this way:

```bash
groups
```

## LXD configuration

To quickly configure LXD for general use and disable IPv6 (Juju does not
support it):

```bash
lxd init --auto
lxc network set lxdbr0 ipv6.address none
```

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
lxd*        default  admin  superuser  localhost/localhost       2         1  none  2.5.0
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
[charm-store]: https://jujucharms.com
[charms]: ./charms.md
[tut-users]: ./tut-users.md
