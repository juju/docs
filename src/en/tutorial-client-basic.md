Title: Basic client usage - tutorial
TODO:  Warning: Ubuntu release versions hardcoded
       Include 'Next steps' and link to planned tutorials (tutorial-bundles.md, tutorial-constraints.md)

# Basic client usage - tutorial

The goal of this tutorial is to give new Juju users a taste of what it's like
to use the command line client.

## Prerequisites

The following prerequisites are assumed as a starting point for this tutorial:

 - You're using Ubuntu 18.04 LTS (Bionic).
 - Juju (stable snap channel) is installed. See the [Installing Juju][install]
   page.
 - You have chosen a backing cloud and have created a controller for it. Refer
   to the [Clouds][clouds] page to get started with a cloud and controller.
 
This guide uses LXD (`v.3.9`) as a backing cloud due to its accessibility and
low resource usage. Choose a local LXD cloud if you're not sure what to use
(see [Using LXD with Juju][clouds-lxd]).

## Listing initial information

List the controller:

```bash
juju controllers
```

This will return a list of all the controllers known to your Juju client. Here,
a controller named 'lxd' is listed:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
lxd*        default  admin  superuser  localhost/localhost       2         1  none  2.5.0
```

A newly-created controller has two models: The 'controller' model, which should
be used only for internal Juju management, and a 'default' model, which is
ready for actual use.

Confirm the above by listing all the models in the currently active controller:

```bash
juju models
```

Our example's output:

```no-highlight
Controller: lxd

Model       Cloud/Region         Status     Machines  Access  Last connection
controller  localhost/localhost  available         1  admin   just now
default*    localhost/localhost  available         2  admin   2019-02-02
```

To see the currently active controller, model, and user:

```bash
juju whoami
```

Our example:

```no-highlight
Controller:  lxd
Model:       default
User:        admin
```

## Deploying an application

Applications are contained within models and are installed via *charms*. By
default, charms are downloaded from the online [Charm Store][charm-store]
during deployment.

To deploy a charm, such as 'redis', in the currently active model:

```bash
juju deploy redis
```

This causes a similarly-named application ("redis") to be installed on a
newly-created machine within the backing cloud.

## Adding a model

To create a model, named 'alpha', in the currently active controller:

```bash
juju add-model alpha
```

By default, when a model is created the currently active model becomes the new
model.

## Changing models

To manually change to a different model, say the original 'default' model:

```bash
juju switch default
```

## Adding a machine

To request that machine be created that is devoid of an application:

```bash
juju add-machine -m alpha -n 2
```

Here we've used the `-m` option to explicitly select a model (i.e. we don't
want the currently active model, which at this time is 'default').

## Listing machines

To change context to model 'alpha' and then list the model's machines:

```bash
juju switch alpha
juju machines
```

Our example:

```no-highlight
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.243.67.116  juju-ded876-0  bionic      Running
1        started  10.243.67.53   juju-ded876-1  bionic      Running
```

## Deploying to a LXD container

To deploy 'apache2' to a new LXD container on existing machine '0':

```bash
juju deploy apache2 --to lxd:0
```

It's not necessary to explicitly target an existing machine in order to deploy
a charm upon on. To deploy 'mongodb' on the second available machine ('1'):

```bash
juju deploy mongodb
```

## Scaling up an application

To scale out the 'apache2' application by creating one more instantiation
(*units*) of it on a new machine:

```bash
juju add-unit -n 1 apache2
```

## Viewing the model status

The `status` command is one that you'll use often. It gives current information
for a given model.

```bash
juju status
```

Our example currently shows:

```no-highlight
Model  Controller  Cloud/Region         Version  SLA          Timestamp
alpha  lxd         localhost/localhost  2.5.0    unsupported  21:28:33Z

App      Version  Status   Scale  Charm    Store       Rev  OS      Notes
apache2           unknown      2  apache2  jujucharms   26  ubuntu  
mongodb  3.6.3    active       1  mongodb  jujucharms   52  ubuntu  

Unit        Workload  Agent  Machine  Public address  Ports 				    Message
apache2/0*  unknown   idle   0/lxd/0  10.72.88.191                                             
apache2/1   unknown   idle   2        10.243.67.141                                            
mongodb/0*  active    idle   1        10.243.67.53 27017/tcp,27019/tcp,27021/tcp,28017/tcp  Unit is ready

Machine  State    DNS            Inst id              Series  AZ  Message
0        started  10.243.67.116  juju-ded876-0        bionic      Running
0/lxd/0  started  10.72.88.191   juju-ded876-0-lxd-0  bionic      Container started
1        started  10.243.67.53   juju-ded876-1        bionic      Running
2        started  10.243.67.141  juju-ded876-2        bionic      Running
```

Note that the `machines` command output is a subset of the `status` command
output.

## Inspecting the logs

Juju logs are inspected on a per-model basis using a specific utility.

To view (tail) the logs of the 'alpha' model:

```bash
juju debug-log -m alpha
```

There are a number of ways to configure the behaviour of the `debug-log`
command.

## Connecting to a machine via SSH

The system user who created the controller (`bootstrap` command) will
automatically have SSH access to all machines in the original two default
models ('controller' and 'default') and any models they create afterwards.

To connect to a machine simply refer to the machine ID (from the `machines`
command). Here we connect to machine '1' in the current model:

```bash
juju ssh 1
```

This command will always get you to the controller machine:

```bash
juju ssh -m controller 0
```

## Removing an application

To remove the 'apache2' application, including all instantiations, along with
its associated machines (provided they are not hosting another application's
units).

```bash
juju remove-application apache2
```

## Removing a machine

```bash
juju remove-machine ??
```

## Destroying a model

Removing a model is a quick way to remove all applications and machines
within that model. Begin anew with the creation of a new one.

To destroy the model called 'alpha':

```bash
juju destroy-model alpha
```

## Destroying a controller

When a controller is destroyed, all its models, applications, and machines are
as well.

To destroy the controller called 'lxd':

```bash
juju destroy-controller lxd
```

## Next steps

At this point, we suggest delving into the conceptual world of Juju. Consider
the following pages:

 - [Concepts and terms][concepts]
 - [Controllers][controllers]
 - [Models][models]
 - [Client][client]
 - [Charms][charms]
 - [Juju logs][troubleshooting-logs]
 - [Machine authentication][machine-auth]


<!-- LINKS -->

[clouds-lxd]: ./clouds-lxd.md
[charm-store]: https://jujucharms.com
[install]: ./reference-install.md
[controllers]: ./controllers.md
[clouds]: ./clouds.md
[models]: ./models.md
[client]: ./client.md
[charms]: ./charms.md
[concepts]: ./juju-concepts.md
[troubleshooting-logs]: ./troubleshooting-logs.md
[machine-auth]: ./machine-auth.md
