Title: Getting started with Juju 2.0
TODO:  Bug check, LP#1619971


# Getting started with Juju 2.0

These instructions will get you up and running and deliver the best-possible
experience with Juju. At the moment, that means using the latest release of
Ubuntu: [16.04 LTS (Xenial)][Xenial-download]. 

See the [general Getting Started page][getting-started-general] if you're using
something other than Xenial.

Apart from Juju, the following technologies will be used:
   
- [LXD][LXD-upstream]: a hypervisor for LXC, providing fast, secure containers.
- [ZFS][ZFS-wiki]: a highly performant and feature-rich filesystem and logical volume manager.

[Xenial-download]: http://www.ubuntu.com/download/ "Xenial download"
[getting-started-general]: ./getting-started-general.html "general Getting Started"
[LXD-upstream]: https://linuxcontainers.org/lxd/ "LXD upstream"
[ZFS-wiki]: https://wiki.ubuntu.com/ZFS "ZFS Ubuntu wiki"


## Install the software

Begin by installing the required software:

*TBD add the PPA so that we don't hit the cache image and other known issues due to the outdated beta in Xenial until it's updated*

```no-highlight
sudo apt-add-repository -y ppa:juju/devel
sudo apt update
sudo apt install juju zfsutils-linux
```

## Groups and LXD initialisation 

Firstly, in order to use LXD, your user must be a member of the `lxd` group.
This should already be the case but you can confirm this by running the `groups` command.
command:

Sample output is provided below:

```no-highlight
$ groups
lxd adm cdrom sudo dip plugdev lpadmin sambashare ubuntu
```

If `lxd` is absent you should refresh group
membership with:

```bash
newgrp lxd
```

Secondly, LXD includes an interactive initialisation which includes setting up
a ZFS pool and appropriate networking for your LXD containers. To start this
process, enter:

```bash
sudo lxd init
```

You will be asked several questions. In the example below, LXD will i) create a
ZFS pool, ii) refrain from putting the pool on a separate block device,
iii) refrain from listening over the network, and iv) trigger the setup of a
bridge network (required for Juju).

Pressing Enter will accept the default answer (provided in square
brackets). Only one answer in the below example uses a non-default value.
 
!!! Note: Make sure there is sufficient free space on your host to accomodate
the requested pool size.

```no-highlight
Name of the storage backend to use (dir or zfs) [default=zfs]: 
Create a new ZFS pool (yes/no) [default=yes]? 
Name of the new ZFS pool [default=lxd]:
Would you like to use an existing block device (yes/no) [default=no]? 
Size in GB of the new loop device (1GB minimum) [default=10GB]: 32
Would you like LXD to be available over the network (yes/no) [default=no]? 
Do you want to configure the LXD bridge (yes/no) [default=yes]?
```

The bridge network will then be configured via a second round of questions.
Except in the case where the randomly chosen subnet may conflict with an
existing one in your local environment, it is fine to accept all the default
answers. In particular, IPv6 networking is not required (the last question).

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
   
   You can now specify the start address for DHCP...
   
   !["step 6"](./media/juju-lxd-config006.png)
   
   And the end address...
   
   !["step 7"](./media/juju-lxd-config007.png)
   
   You can also specify the total number of DHCP clients to accept.
   
   !["step 8"](./media/juju-lxd-config008.png)
   
   Finally for IPv4, enable Network Address Translation to allow the
   containers to communicate with the outside world.
   
   !["step 9"](./media/juju-lxd-config009.png)
   
   You can continue to set up a similar IPv6 bridge device, but this is not 
   necessary for Juju.
   
   !["step 10"](./media/juju-lxd-config010.png)
   
LXD is now configured to work with Juju.

!!! Note: LXD adds iptables (firewall) rules to allow traffic to the
subnet/bridge it created. If you subsequently add/change firewall settings
(e.g. with `ufw`), ensure that such changes have not interfered the containers ability to
communicate across the network.

## Create a controller

Juju needs a controller instance to manage your models and the `juju bootstrap`
command is used to create one. This command expects a name (for referencing this 
controller) and a cloud to use. The LXD 'cloud' is known as 'localhost' to Juju.

For our LXD localhost cloud, we will create a controller called 'lxd-test':

```bash
juju bootstrap lxd-test localhost
```

This may take a few minutes as LXD must download an image for Xenial. A cache
will be used for subsequent containers.


Once the process has completed you can check that the controller has been
created:

```bash
juju list-controllers 
```

This will return a list of the controllers known to Juju, which at the moment is
the one we just created:
  
```no-highlight
CONTROLLER  MODEL    USER         ACCESS+    CLOUD/REGION         MODELS+ MACHINES+  VERSION+
lxd-test*   default  admin@local  superuser  localhost/localhost        2 	  1  2.0-beta18  

+ these are the last known values, run with --refresh to see the latest information.
```

A newly-created controller has two models: The 'controller' model, which should
be used only by Juju for internal management, and a 'default' model, which is
ready for use.

The following command shows the currently active controller, model, and user:

```bash 
juju whoami
```

Our example provides this output:

```no-highlight
Controller:  lxd-test
Model:       default
User:        admin@local
```

!!! Note: In the output we see that user 'admin' is a local user. Future
functionality may include remotely authenticated users.


## Deploy

Juju is now ready to deploy applications from among the hundreds included in
the [Juju charm store][charm store]. It is a good idea to test your new model.
How about a Mediawiki site?

```bash
juju deploy wiki-simple
```

This will fetch a 'bundle' from the Juju store. A bundle is a pre-packaged set
of applications, in this case 'Mediawiki', and a database to run it 
with. Juju will install both applications and add a relation between them - 
this is part of the magic of Juju: it isn't just about deploying software, Juju 
also knows how to connect it all together.

You can check on how far Juju has got by running the command:
 
```bash
juju status
```

When the applications have been installed, the output to the above command will
look something like this:

![juju status](./media/juju-mediawiki-status.png)

There is a lot of useful information there! The important parts for now are
the APP section, which shows that Mediawiki (shortened to 'wiki') and MySQL are
installed, and the UNIT section, which shows the IP addresses allocated to
each. These addresses correspond to the subnet we created for LXD earlier on.

Regarding security, applications running on a public cloud are not accessible
until a change is made on that cloud's firewall. Juju will do this for you via
the `juju expose <application>` command (here, our application is 'wiki'). Yet
we are not using a public cloud in this example and LXD traffic is not locked
down by default so there is nothing for Juju to unblock/expose.

The IP address we're interested in is 10.255.47.112. Point your browser at that
address to see the site:

!["mediawiki site"](./media/juju-mediawiki-site.png)

Congratulations, you have just deployed an application with Juju!

!!! Note: To remove all the applications in the model you just created, it is 
often quickest to destroy the model with the command 
`juju destroy-model default` and then [create a new model][models].


## Next Steps

Now that you have a Juju-powered cloud, it is time to explore the amazing
things you can do with it! 

We suggest you take the time to read the following:

- [Clouds][clouds] goes into detail about configuring other clouds, including
  the public clouds like Azure, AWS and Google Compute Engine.
- [Models][models] - Learn how to create, destroy and manage models.
- [Charms & Applications][charms] - find out how to construct complicated 
  workloads in next to no time.


[clouds]: ./clouds.html  "Configuring Juju Clouds"
[charm store]: https://jujucharms.com "Juju Charm Store"
[releases]: reference-releases.html 
[keygen]: ./getting-started-keygen-win.html "How to generate an SSH key with Windows"
[concepts]: ./juju-concepts.html "Juju concepts"
[charms]: ./charms.html
[models]: ./models.html
