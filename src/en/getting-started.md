Title: Getting started with Juju 2.0
Todo: remove ppa/devel after release

# Getting started with Juju 2.0

The instructions here will get you up and running and deliver the best-possible
experience. At the moment, that means using the very latest release of 
Ubuntu, [16.04LTS(Xenial)](http://cdimage.ubuntu.com/releases/16.04/).

If you are using a different OS, please read the 
[general install instructions here](./getting-started-general.html).

To get the best experience, as well as Juju, this guide will also set up:
   
   - LXD - a hypervisor for LXC, providing fast, secure containers.
   - ZFS - a combined filesystem/LVM which gives great performance.

Both the above are provided with Ubuntu 16.04LTS.

# Install the software

Run the following commands to install the required software:

```no-highlight  
  sudo add-apt-repository ppa:juju/devel
  sudo apt update
  sudo apt install zfsutils-linux
  sudo apt install lxd
  sudo apt install juju2
```

# Prepare ZFS

Using ZFS we can create sparse backing-storage for any of the containers which
LXD creates for Juju. You can create this storage anywhere (e.g. the fastest
drive you have). This example creates a 50G file to use:

```no-highlight
sudo mkdir /var/lib/zfs
sudo truncate -s 50G /var/lib/zfs/lxd.img
sudo zpool create lxd /var/lib/zfs/lxd.img
```

As this is sparse storage, it won't actually take up disk space until it is 
actually being used. You can check the file has been added to a ZFS pool with 
the following command:
  
```no-highlight
sudo zpool status
```

This should indicate that the newly created pool is 'ONLINE' and ready.

# Initialise LXD

Now we need to tell LXD about this storage

```bash
sudo lxd init --auto --storage-backend zfs --storage-pool lxd
newgrp - 
```

To have the group changes take effect, you will now need to logout of your
current session and log in once again, or execute the following in your shell:
  
```no-highlight
su -l $USER
```
# Create a controller

Juju needs to create a controller instance in the cloud to manage the models
you create. We use the `juju bootstrap` command to create that controller. For 
use with our LXD 'cloud', we will create a new controller called 'lxd-test':

```bash
juju bootstrap --config default-series=xenial lxd-test lxd
```

This may take a few minutes as initially, LXD needs to download an image for 
Xenial. 

Once the process has completed, Juju now has a controller. You can check this:

```bash
juju list-controllers 
```
...will return a list of the controllers known to Juju, which at the moment is
the one we just created:
  
```no-highlight
CONTROLLER       MODEL    USER         SERVER
local.lxd-test*  default  admin@local  10.0.3.124:17070
```

# Create a model

Before we deploy any services, we will create a model. A model in Juju is like a 
workspace where you can deploy and relate the services you want. A controller 
can create many models, and as you will see, Juju is able to share selected 
models with other users too. For now we will create a new model called 'test':

```bash
juju create-model test
```

The model is now created. Each time you create a new model, control is 
automatically switched to that model. You can find out which model you are 
currently using with the `juju switch` command:

```bash 
juju switch
```
...will return model and controller we are currently using:

```no-highlight
local.lxd-test:test
```
# Deploy!

Juju is now ready to deploy any services from the hundreds included in the
[https://jujucharms.com](juju charm store). It is a good idea to test your new 
model. How about a Mediawiki site?

```bash
juju deploy mediawiki-single
```
This will fetch a 'bundle' from the Juju store. A bundle is a pre-packaged set
of services, in this case the 'Mediawiki' service, and a database to run it 
with. Juju will install both these services and add a relation between them - 
this is part of the magic of Juju: it isn't just about deploying services, Juju 
also knows how to connect them together.

Installing shouldn't take long. You can check on how far Juju has got by running
the command:
 
```bash
juju status
```
When the services have been installed the output to the above command will look
something like this:

![juju status](./media/juju-mediawiki-status.png)

There is quite a lot of information there but the important parts for now are 
the [Services] section, which show that Mediawiki and MySQL are installed, and
the [Units] section, which crucially shows the IP addresses allocated to them.

By default, Juju is secure - you won't be able to connect to any services 
unless they are specifically exposed. This adjusts the relevant firewall 
controls (on any cloud, not just LXD) to allow external access. To make
our Mediawiki visible, we run the command:

```bash
juju expose mediawiki
```

From the status output, we can see that the Mediawiki service is running on 
10.0.3.60 (your IP may vary). If we open up Firefox now and point it at that 
address, you should see the site running.

!["mediawiki site"](./media/juju-mediawiki-site.png)

Congratulations, you have just deployed a service with Juju!

!!! Note: To remove all the services in the model you just created, it is 
often quickest to destroy the model with the command 'juju destroy-model test` 
and then create a new model.


## Next Steps

Now you have a Juju-powered cloud, it is time to explore the amazing things you
can do with it! 

We suggest you take the time to read the following:
  

  - [Clouds][clouds] goes into detail about configuring other clouds, including the 
    public clouds like Azure, AWS, Google Compute Engine and Rackspace.
  - [Charms/Services][charms] - find out how to construct complicated workloads 
    in next to no time.


[clouds]: ./clouds.html  "Configuring Juju Clouds"
[charm store]: https://jujucharms.com "Juju Charm Store"
[releases]: reference-releases.html 
[keygen]: ./getting-started-keygen-win.html "How to generate an SSH key with Windows"
[concepts]: ./juju-concepts.html "Juju concepts"
[charms]: ./charms-intro.html
