Title: Getting started with Juju 2.0
TODO: Mediawiki status needs new screenshot when status has been updated in Juju

# Getting started with Juju 2.0

The instructions here will get you up and running and deliver the best-possible
experience. At the moment, that means using the very latest release of 
Ubuntu, [16.04LTS (Xenial)](http://www.ubuntu.com/download/).

If you are using a different OS, please read the 
[general install instructions here](./getting-started-general.html).

To get the best experience, as well as Juju, this guide will also set up:
   
- LXD - a hypervisor for LXC, providing fast, secure containers.
- ZFS - a combined filesystem/LVM which gives great performance.

Both the above are provided with Ubuntu 16.04LTS.


## Install the software

Run the following commands to install the required software:

```no-highlight
sudo apt update
sudo apt install juju-2.0 zfsutils-linux
```

## Initialise LXD

In order to use LXD, your user must be in the 'lxd' group. All system users are
automatically added to this group, but you may need to refresh the current 
session. You can confirm your user is part of this group by running the command:

```bash
groups
```
This should indicate the user is a member of the lxd group, amongst others (your
groups may vary from these):

```no-highlight
lxd adm cdrom sudo dip plugdev lpadmin sambashare ubuntu
```

If the `lxd` group is not present, you can refresh group membership with the 
command:
  
```bash
newgrp lxd
```

LXD includes an interactive initialisation which will also set up a ZFS pool 
to use and configures networking for your containers. To start this process, 
enter:

```bash
sudo lxd init
```

You will be prompted for various options. As an example, to configure LXD to 
create a new 32GB ZFS pool to use, called 'lxd-pool', and set up a bridge 
network (required for Juju), your session would look like this:
 
```no-highlight
Name of the storage backend to use (dir or zfs): zfs
Create a new ZFS pool (yes/no)? yes
Name of the new ZFS pool: lxd-pool
Would you like to use an existing block device (yes/no)? no
Size in GB of the new loop device (1GB minimum): 32
Would you like LXD to be available over the network (yes/no)? no
Do you want to configure the LXD bridge (yes/no)? yes
```

The last question will initiate a series of dialogues to configure the bridge 
device and subnet. Except in the case the subnet may clash with existing 
networks, it is okay to accept the defaults on all dialogues (though it is not
required to configure IPv6 networking).

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
   
   Finally for IPv4, you should turn on Network Address Translation to enable
   the contianers to communicate fully.
   
   !["step 9"](./media/juju-lxd-config009.png)
   
   You can continue to set up a similar IPv6 bridge device, but this is not 
   required for Juju.
   
   !["step 10"](./media/juju-lxd-config010.png)
   
Now LXD is configured to create containers for Juju.

## Create a controller

Juju needs a controller instance to manage your models and the `juju bootstrap`
command is used to create one. For use with our LXD "cloud", we
will make a controller called 'lxd-test':

```bash
juju bootstrap lxd-test lxd
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
CONTROLLER       MODEL    USER         SERVER
local.lxd-test*  default  admin@local  10.0.3.124:17070
```

Notice that the prefix 'local.' is added to the controller name we specified.

A newly-created controller has two models: The 'controller' model,
which should be used only by Juju for internal management, and a 'default'
model, which is ready for actual use.

The following command shows the currently active controller and model:

```bash 
juju switch
```

In our example, the output should look like this:

```no-highlight
local.lxd-test:default
```

The format is 'controller:model'.


## Deploy

Juju is now ready to deploy any applications from the hundreds included in the
[juju charm store](https://jujucharms.com). It is a good idea to test your new 
model. How about a Mediawiki site?

```bash
juju deploy wiki-simple
```
This will fetch a 'bundle' from the Juju store. A bundle is a pre-packaged set
of applications, in this case 'Mediawiki', and a database to run it 
with. Juju will install both applications and add a relation between them - 
this is part of the magic of Juju: it isn't just about deploying software, Juju 
also knows how to connect it all together.

Installing shouldn't take long. You can check on how far Juju has got by running
the command:
 
```bash
juju status
```
When the applications have been installed, the output to the above command will
look something like this:

![juju status](./media/juju-mediawiki-status.png)

There is quite a lot of information there but the important parts for now are 
the [Applications] section, which show that Mediawiki and MySQL are installed, 
and
the [Units] section, which crucially shows the IP addresses allocated to them.

By default, Juju is secure - you won't be able to connect to any applications 
unless they are specifically exposed. This adjusts the relevant firewall 
controls (on any cloud, not just LXD) to allow external access. To make
our Mediawiki visible, we run the command:

```bash
juju expose mediawiki
```

From the status output, we can see that Mediawiki is running on 
10.0.3.60 (your IP may vary). If we open up Firefox now and point it at that 
address, you should see the site running.

!["mediawiki site"](./media/juju-mediawiki-site.png)

Congratulations, you have just deployed an application with Juju!

!!! Note: To remove all the applications in the model you just created, it is 
often quickest to destroy the model with the command 
'juju destroy-model default` and then [create a new model][models].


## Next Steps

Now that you have a Juju-powered cloud, it is time to explore the amazing
things you can do with it! 

We suggest you take the time to read the following:

- [Clouds][clouds] goes into detail about configuring other clouds, including
  the public clouds like Azure, AWS, Google Compute Engine and Rackspace.
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
