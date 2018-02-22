Title: Adding a manual cloud
       Critical: Review required (reconcile with add-cloud on clouds.md)

# Using a "Manual" cloud

Juju caters for the
case where you may not be able to access a more traditional cloud in a
straightforward way; maybe you can't create additional instances, or perhaps
your cloud is really a collection of disparate hardware.

Whatever the case, as long as Juju can log into these machines they can be used
as part of a Juju cloud. It won't be _quite_ the same as using a standard cloud
- without the ability to create new instances when they are desired, you will
be missing out on some of the Juju magic. You can still deploy and manage
applications though, with a bit of extra effort.

## Prerequisites for using a manual cloud:

  - You will need at least two machines
  - The machines must already have Ubuntu or CentOS installed
  - They must be running SSH ([see notes below for CentOS](#additional-centos-notes))
  - You will need a login with sudo privileges on all machines
  - All machines must be able to communicate with each other over the network

## Add a Manual cloud

Use the interactive `add-cloud` command to add your Manual cloud to Juju's list
of clouds. See the 'Manual' entry under
[Specifying additional clouds][clouds__specifying-additional-clouds] for
guidance.

## Bootstrapping the cloud

As with other clouds, Juju needs to create a controller to manage models and
other instances in the cloud. Bootstrapping is the same as for 'regular'
clouds, except in this case, after the cloud type you should supply the network
address of the machine you wish to use as the controller:

```bash
juju bootstrap manual/192.168.1.128 mycloud
```

Note that it is also possible to use the other common bootstrap parameters here
([see 'bootstrap' in the command reference][commands]).

## Adding machines to the cloud

The `bootstrap` command creates the controller and initial models that Juju
uses. Deploying applications will require additional machines to be made
available though. The more conventional Juju cloud types can create machines
automatically, but in the case of a manual cloud you will have to specify these
resources.

This is done by using the `add-machine` command in Juju. This will install the
default series on a given resource, and prepare it for
deploying applications.

For example, if you have a machine with the IP address 192.168.1.129, you could
add it to your manual cloud with the command:

```bash
juju add-machine ssh:ubuntu@192.168.1.129
```

In this case, assuming SSH is available and there is a user called 'ubuntu' on
that machine, you will be prompted for a password. As the preparation requires
sudo privileges on the remote machine, you will be asked for the password once
again as the installer initialises.

The process should not take too long, and you will see messages on the screen as
the various stages progress. Once the command has returned, you can check
the machine is available by running:

```bash
juju status
```

## Deploying

Usually Juju will create machines as it needs them. By default, using a charm
to deploy an application will automatically create a machine first and then
deploy the new application.

With a manual cloud, you need to create your machines in advance, so Juju will
need to know which of the machines you wish to target when you deploy a charm
(or scale out). This can be done with the use of the
[placement directives][placement]: you need to use the
'--to' option to specify the destination, which is either a machine or a
container on a machine:

```bash
juju deploy wordpress --to 0
```
...will deploy WordPress on the first machine you added.

## Additional notes

There are some additional things to note when using the Manual provider:

 - Machines are known to the model Juju is using. If you destroy the model and
   create a new one, you will have to add the machines again to the new model.
 - To improve performance, consider running a local APT proxy (see also
   [configuring a model][models-config]).

## Additional CentOS notes

By default, CentOS doesn't install SSH, which is required for Juju to access 
the machine. In order to prepare a CentOS system to be used as a manual cloud,
you will also need to install OpenSSH. 

Run the following commands as the root user on the target CentOS system:

```bash
yum install sudo openssh-server redhat-lsb-core
systemctl start sshd
mkdir ~/.ssh
chmod 700 ~/.ssh
```

Now from the machine where the Juju client will be used, run the following 
command to copy a public SSH key to the CentOS system:


```
scp ~/.ssh/id_rsa.pub  root@192.168.1.129:.ssh/authorized_keys
```
...substituting the IP address for your CentOS machine in the above.

It is now possible to use the [`add-machine`](#adding-machines-to-the-cloud)
or [`bootstrap`](#bootstrapping-the-cloud) commands from Juju.

!!! Note: 
    Also check that there is a root password set for the CentOS machine 
    to avoid prompts which may hinder automated SSH operations.

[models-config]: ./models-config.html
[placement]: ./charms-deploying.html#deploying-to-specific-machines-and-containers
[commands]: ./commands.html
[clouds__specifying-additional-clouds]: ./clouds.html#specifying-additional-clouds
