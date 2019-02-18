Title: Basic client usage - tutorial
TODO:  Warning: Ubuntu release versions hardcoded
       Include links to planned tutorials (tutorial-bundles.md, tutorial-constraints.md)

# Basic client usage - tutorial

The goal of this tutorial is to give new Juju operators a solid introduction to
the command line client. In so doing, several important concepts are
introduced. It also discusses the use of command prefixes and aliases. Further
reading suggestions are included at the end.

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

## Command prefixes and aliases

As you gain more experience with the client, you will discover a common set of
command prefixes: `add-`, `create-`, `destroy-`, `get-`, `list-`, `remove-`,
`set-`, and `show-`.

Generally their meanings are self-evident but some require explanation. A good
example of this are the `destroy-` and `remove-` prefixes, such as in the
commands `destroy-model` and `remove-user`. These two prefixes differ in terms
of severity. Basically, `destroy-` indicates a destructive action that is
difficult to reverse whereas `remove-` does not.

There is a `kill-` prefix but it is reserved for a single command:
`kill-controller`. The latter differs from `destroy-controller` in that it has
the ability to terminate the controller machine directly via the cloud
provider, without cleaning up any machines that may be running in workload
models.

The `list-` prefix can often be omitted as there is usually a corresponding
command alias available. For instance, `clouds` can be used instead of
`list-clouds`. The list of aliases can be obtained in this way:

```bash
juju help commands | grep Alias
```

The `show-` prefix is used to drill down into an object to reveal details. It
is akin to the verb "describe".

## Fundamental commands

Juju makes available to the operator a wide variety of commands. In this
section, we'll cover the basic ones. 

### Listing initial information

List the controller:

```bash
juju controllers
```

This will return a list of all the controllers known to your Juju client.
Below, we have a controller named 'lxd':

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

### Deploying an application

Applications are contained within models and are installed via *charms*. By
default, charms are downloaded from the online [Charm Store][charm-store]
during deployment.

To deploy a charm, such as 'redis', in the currently active model:

```bash
juju deploy redis
```

This results in an identically-named application ("redis") to be installed on a
newly-created machine within the backing cloud. You can assign a custom name to
the application by specifying that name as an argument:

```bash
juju deploy redis datastore
```

### Adding a model

To create a model, named 'alpha', in the currently active controller:

```bash
juju add-model alpha
```

By default, when a model is created the currently active model becomes the new
model.

### Changing models

To manually change to a different model, say the original 'default' model:

```bash
juju switch default
```

### Adding a machine

To request that two machines be created that are devoid of an application:

```bash
juju add-machine -m alpha -n 2
```

Here we've used the `-m` option to explicitly select a model (i.e. we don't
want the currently active model, which at this time is 'default').

### Listing machines

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

### Deploying to a LXD container

To deploy 'apache2' to a new LXD container on existing machine '0':

```bash
juju deploy apache2 --to lxd:0
```

It's not necessary to explicitly target an existing machine in order to deploy
a charm upon on. To deploy 'mongodb' on the second available machine ('1'):

```bash
juju deploy mongodb
```

### Scaling up an application

To scale out the 'apache2' application by creating another instantiation
(*unit*) of it on a new machine:

```bash
juju add-unit apache2
```

Like the `add-machine` command, the `-n` option is available if multiple units
are desired.

### Viewing the model status

The `status` command is one that you'll use often. It gives live information
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

The output is broken up into four sections.

The **top** section mentions basic information such as the names of the current
model and controller ('alpha' and 'lxd' respectively), followed by the cloud
name ('localhost'), what version of Juju the model is running, whether Juju is
being used in a third-party context (see [Managed solutions][experts-sla]), and
finally, the timestamp of the current controller.

The **App** section contains information at the application level. It is
closely related to the providence of an application's charm. The 'Scale' tells
us how many units exist for an application while the 'Rev' column shows the
charm's revision number.

The **Unit** section contains information at the unit level. It lists them,
along with information that is passed back from the *unit agent*. The type of
data available is is very charm-specific. For instance, the 'unknown' workload
message for the apache2 units is not necessarily a bad thing. It's just that
the associated charm was not written to give something more insightful.

The **Machine** section contains information at the machine level. It lists
machines by their ID (e.g. '0/lxd/0' or just '1'). The 'Inst id' is the
instance id of the machine that gets passed to the cloud provider as the
instance name.

Notice how the `machines` command output is a subset of the `status` command
output.

### Inspecting the logs

Juju logs are inspected on a per-model basis using a specific utility.

To view (tail) the logs of the 'alpha' model:

```bash
juju debug-log -m alpha
```

There are a number of ways to configure the behaviour of the `debug-log`
command.

### Connecting to a machine via SSH

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

### Removing an application

To remove the 'apache2' application, including all units, along with associated
machines (provided they are not hosting another application's units).

```bash
juju remove-application apache2
```

### Removing a unit

To remove just a single unit, such as 'apache2/1':

```bash
juju remove-unit apache2/1
```

Like the `remove-application` command, this command will also remove the
machine if it is now devoid of units.

### Removing a machine

To remove the machine whose ID is '1':

```bash
juju remove-machine 1
```

As a safety precaution, a machine cannot be removed if it is hosting a unit.
Either remove all of its units first or, as a last resort, use the `--force`
option.

### Destroying a model

Destroying a model is a quick way to remove all applications and machines
within that model. Begin anew with the creation of a new one.

To destroy the model called 'alpha':

```bash
juju destroy-model alpha
```

### Destroying a controller

When a controller is destroyed, all its models, applications, and machines are
as well.

To destroy the controller called 'lxd':

```bash
juju destroy-controller lxd
```

## Next steps

Based on the material covered in this tutorial, we suggest the following for
further reading:

 - [Concepts and terms][concepts]
 - [Deploying applications][charms-deploying]
 - [Juju logs][troubleshooting-logs]
 - [Machine authentication][machine-auth]
 - [Removing things][charms-destroy]

<!-- LINKS -->

[clouds-lxd]: ./clouds-lxd.md
[charm-store]: https://jujucharms.com
[install]: ./reference-install.md
[clouds]: ./clouds.md
[concepts]: ./juju-concepts.md
[charms-deploying]: ./charms-deploying.md
[troubleshooting-logs]: ./troubleshooting-logs.md
[machine-auth]: ./machine-auth.md
[charms-destroy]: ./charms-destroy.md
[experts-sla]: ./experts-sla.md
