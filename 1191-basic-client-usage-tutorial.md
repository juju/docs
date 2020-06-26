<!--
Todo:
- Warning: Ubuntu release versions hardcoded
- Include links to planned tutorials (tutorial-bundles.md, tutorial-constraints.md)
-->

The goal of this tutorial is to give new Juju administrators a solid introduction to the command line client. In so doing, several important concepts are introduced. It also discusses the use of command prefixes and aliases. Further reading suggestions are included at the end.

<h2 id="heading--prerequisites">Prerequisites</h2>

The following prerequisites are assumed as a starting point for this tutorial:

- You're using Ubuntu 18.04 LTS (Bionic).
- Juju (stable snap channel) is installed. See the [Installing Juju](/t/installing-juju/1164) page.
- You have chosen a backing cloud and have created a controller for it. Refer to the [Clouds](/t/clouds/1100) page to get started with a cloud and controller.

This guide uses LXD (`v.3.9`) as a backing cloud due to its accessibility and low resource usage. Choose a local LXD cloud if you're not sure what to use (see [Using LXD with Juju](/t/using-lxd-with-juju/1093)).

<h2 id="heading--command-prefixes-and-aliases">Command prefixes and aliases</h2>

As you gain more experience with the client, you will discover a common set of command prefixes: `add-`, `create-`, `destroy-`, `get-`, `list-`, `remove-`, `set-`, and `show-`.

Generally their meanings are self-evident but some require explanation. A good example of this are the `destroy-` and `remove-` prefixes, such as in the commands `destroy-model` and `remove-user`. These two prefixes differ in terms of severity. Basically, `destroy-` indicates a destructive action that is difficult to reverse whereas `remove-` does not.

There is a `kill-` prefix but it is reserved for a single command: `kill-controller`. The latter differs from `destroy-controller` in that it has the ability to terminate the controller machine directly via the cloud provider, without cleaning up any machines that may be running in workload models.

The `list-` prefix can often be omitted as there is usually a corresponding command alias available. For instance, `clouds` can be used instead of `list-clouds`. The list of aliases can be obtained in this way:

```text
juju help commands | grep Alias
```

The `show-` prefix is used to drill down into an object to reveal details. It is akin to the verb "describe".

<h2 id="heading--fundamental-commands">Fundamental commands</h2>

Juju has several dozen commands. In this section, we'll cover the basic ones.

<h3 id="heading--listing-initial-information">Listing initial information</h3>

List the controller:

```text
juju controllers
```

This will return a list of all the controllers known to your Juju client. Below, we have a controller named 'lxd':

```text
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
lxd*        default  admin  superuser  localhost/localhost       2         1  none  2.5.0
```

A newly-created controller has two models: The 'controller' model, which should be used only for internal Juju management, and a 'default' model, which is ready for actual use.

Confirm the above by listing all the models in the currently active controller:

```text
juju models
```

Our example's output:

```text
Controller: lxd

Model       Cloud/Region         Status     Machines  Access  Last connection
controller  localhost/localhost  available         1  admin   just now
default*    localhost/localhost  available         2  admin   2019-02-02
```

The default output uses a "friendly timestamp" (e.g. "a few seconds ago", "just now"). To get an actual timestamp use option `--exact-time`.

To see the currently active controller, model, and user:

``` text
juju whoami
```

Our example:

``` text
Controller:  lxd
Model:       default
User:        admin
```

<h3 id="heading--deploying-an-application">Deploying an application</h3>

Applications are contained within models and are installed via *charms*. By default, charms are downloaded from the online [Charm Store](https://jujucharms.com) during deployment.

To deploy a charm, such as 'redis', in the currently active model:

``` text
juju deploy redis
```

This results in an identically-named application ("redis") to be installed on a newly-created machine within the backing cloud. You can assign a custom name to the application by specifying that name as an argument:

``` text
juju deploy redis datastore
```

<h3 id="heading--adding-a-model">Adding a model</h3>

To create a model, named 'alpha', in the currently active controller:

``` text
juju add-model alpha
```

By default, when a model is created the currently active model becomes the new model.

<h3 id="heading--changing-models">Changing models</h3>

To manually change to a different model, say the original 'default' model:

``` text
juju switch default
```

<h3 id="heading--adding-a-machine">Adding a machine</h3>

To request that two machines be created that are devoid of an application:

``` text
juju add-machine -m alpha -n 2
```

Here we've used the `-m` option to explicitly select a model (i.e. we don't want the currently active model, which at this time is 'default').

<h3 id="heading--listing-machines">Listing machines</h3>

To change context to model 'alpha' and then list the model's machines:

``` text
juju switch alpha
juju machines
```

Our example:

``` text
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.243.67.116  juju-ded876-0  bionic      Running
1        started  10.243.67.53   juju-ded876-1  bionic      Running
```

<h3 id="heading--deploying-to-a-lxd-container">Deploying to a LXD container</h3>

To deploy 'apache2' to a new LXD container on existing machine '0':

``` text
juju deploy apache2 --to lxd:0
```

It's not necessary to explicitly target an existing machine in order to deploy a charm upon on. To deploy 'mongodb' on the second available machine ('1'):

``` text
juju deploy mongodb
```

<h3 id="heading--scaling-up-an-application">Scaling up an application</h3>

To scale out the 'apache2' application by creating another instantiation (*unit*) of it on a new machine:

``` text
juju add-unit apache2
```

Like the `add-machine` command, the `-n` option is available if multiple units are desired.

<h3 id="heading--viewing-the-model-status">Viewing the model status</h3>

The `status` command is one that you'll use often. It gives live information for a given model.

``` text
juju status
```

Our example currently shows:

``` text
Model  Controller  Cloud/Region         Version  SLA          Timestamp
alpha  lxd         localhost/localhost  2.5.0    unsupported  21:28:33Z

App      Version  Status   Scale  Charm    Store       Rev  OS      Notes
apache2           unknown      2  apache2  jujucharms   26  ubuntu  
mongodb  3.6.3    active       1  mongodb  jujucharms   52  ubuntu  

Unit        Workload  Agent  Machine  Public address  Ports                     Message
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

The **top** section mentions basic information such as the names of the current model and controller ('alpha' and 'lxd' respectively), followed by the cloud name ('localhost'), what version of Juju the model is running, whether Juju is being used in a third-party context (see [Managed solutions](/t/managed-solutions/1132)), and finally, the timestamp of the current controller.

The **App** section contains information at the application level. It is closely related to the providence of an application's charm. The 'Scale' tells us how many units exist for an application while the 'Rev' column shows the charm's revision number.

The **Unit** section contains information at the unit level. It lists them, along with information that is passed back from the *unit agent*. An application's `leader` unit is denoted by an asterisk. The type of data available is very charm-specific. For instance, the 'unknown' workload message for the apache2 units is not necessarily a bad thing. It's just that the associated charm was not written to give something more insightful.

The **Machine** section contains information at the machine level. It lists machines by their ID (e.g. '0/lxd/0' or just '1'). The 'Inst id' is the instance id of the machine that gets passed to the cloud provider as the instance name.

Notice how the `machines` command output is a subset of the `status` command output.

<h3 id="heading--inspecting-the-logs">Inspecting the logs</h3>

Juju logs are inspected on a per-model basis using a specific utility.

To view (tail) the logs of the 'alpha' model:

```text
juju debug-log -m alpha
```

There are a number of ways to configure the behaviour of the `debug-log` command.

<h3 id="heading--connecting-to-a-machine-via-ssh">Connecting to a machine via SSH</h3>

The system user who created the controller (`bootstrap` command) will automatically have SSH access to all machines in the original two default models ('controller' and 'default') and any models they create afterwards.

To connect to a machine simply refer to the machine ID (from the `machines` command). Here we connect to machine '1' in the current model:

```text
juju ssh 1
```

This command will always get you to the controller machine:

```text
juju ssh -m controller 0
```

To connect to a machine by referring to its corresponding unit:

```text
juju ssh mysql/3
```

Remote SSH commands work as expected (but the `run` command is favoured for this purpose instead; see next section):

```text
juju ssh 1 lsb_release -c
```

To copy files to and from units use the `scp` command. Here we copy a file from machine '2' to the current working directory on the client:

```text
juju scp 2:/var/log/syslog .
```

See [Machine authentication](/t/machine-authentication/1146) for more information on using the SSH protocol with Juju.

<h3 id="heading--running-commands-on-a-machine">Running commands on a machine</h3>

The `run` command can be used to inspect or do work on applications, units, or machines. Commands for applications or units are executed in a hook context.

To run `uname -a` on every unit:

```text
juju run "uname -a" --all
```

To run `uptime` on some units:

```text
juju run "uptime" --machine=2
juju run "uptime" --application=mysql
```

Use quotes with complex commands. Here we're using unit notation:

```text
juju run --unit hadoop-master/0 "sudo -u hdfs /usr/lib/hadoop/terasort.sh"
```

Since `v.2.5.2` an application leader can be targeted. To run `hostname` on the leader of application 'ubuntu':

```text
juju run --unit ubuntu/leader hostname
```

[note]
When using the `--application` option with the `run` command the command will run on every application unit. When using the `--machine` option, the command is run as the `root` user on the remote machine.
[/note]

<h3 id="heading--removing-an-application">Removing an application</h3>

To remove the 'apache2' application, including all units, along with associated machines (provided they are not hosting another application's units).

```text
juju remove-application apache2
```

<h3 id="heading--removing-a-unit">Removing a unit</h3>

To remove just a single unit, such as 'apache2/1':

```text
juju remove-unit apache2/1
```

Like the `remove-application` command, this command will also remove the machine if it is now devoid of units.

<h3 id="heading--removing-a-machine">Removing a machine</h3>

To remove the machine whose ID is '1':

``` text
juju remove-machine 1
```

As a safety precaution, a machine cannot be removed if it is hosting a unit. Either remove all of its units first or, as a last resort, use the `--force` option.

<h3 id="heading--destroying-a-model">Destroying a model</h3>

Destroying a model is a quick way to remove all applications and machines within that model. Begin anew with the creation of a new one.

To destroy the model called 'alpha':

``` text
juju destroy-model alpha
```

<h3 id="heading--destroying-a-controller">Destroying a controller</h3>

When a controller is destroyed, all its models, applications, and machines are as well.

To destroy the controller called 'lxd':

``` text
juju destroy-controller lxd
```

<h2 id="heading--next-steps">Next steps</h2>

Based on the material covered in this tutorial, we suggest the following for further reading:

- [Concepts and terms](/t/concepts-and-terms/1144)
- [Deploying applications](/t/deploying-applications/1062)
- [Juju logs](/t/juju-logs/1184)
- [Machine authentication](/t/machine-authentication/1146)
- [Removing things](/t/removing-things/1063)
