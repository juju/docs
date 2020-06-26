<!--
Todo:
- warning: ubuntu code names hardcoded
- bug tracking: https://bugs.launchpad.net/juju/+bug/1797399
- bug tracking: https://bugs.launchpad.net/juju/+bug/1797388
-->

Upgrading the operating system running on each of the machines is a multi-step process. Each of the operating systems must be upgraded, then each of the charms. We use the term "series" to refer to the OS version code listed by `juju status`. 

## Page contents

- <a href="#app-or-model">Upgrading an application's series or a model's series</a>
- <a href="#machine">Upgrading a machine's series</a>
- <a href="#controller">Upgrading the controller's series</a>

<h2 id="app-or-model"> Upgrading an application's series or a model's series</h2>

To upgrade an application's series, upgrade each the machines hosting its units. Every machine needs to be upgraded individually. Likewise, to upgrade a model's series, perform the upgrade steps on each of its machines.

Update the model's configuration to prefer the new series for newly-deployed charms: 

```plain
juju model-config -m <model> default-series=<series>
```

<h2 id="heading--upgrading-a-workload-machine"><h2 id="machine">Upgrading a machine's series</h2></h2>

An overview of the series upgrade process:

- For each machine `m`:
-- Execute `juju upgrade-series <m> prepare <new-series>`
-- Upgrade the operating system. For Ubuntu-based machines, this involves executing `do-upgrade-series` 
-- Execute `juju upgrade-series <m> complete`

[note status="Clustered application?"]
If your application relies on maintaining a quorum of a minimum number of nodes, add more units before running `juju upgrade-series`.
[/note]


Let's start with a base model that deploys AMQP implementation [RabbitMQ][] with the [`rabbitmq-server`](https://jaas.ai/rabbitmq-server/) charm.

[RabbitMQ]: https://www.rabbitmq.com/

```bash
$ juju add-model testing
$ juju deploy rabbitmq-server -n 3 --series xenial
$ juju config rabbitmq-server min-cluster-size=3
```

### Preparation

As RabbitMQ will cease to function if one of its nodes becomes unavailable due to an upgrade, we can temporarily add more capacity:

```bash
$ juju add-unit -n 2 rabbitmq-server
```

### Initiate upgrade series

Now we indicate to Juju that we're intending on upgrading the series of the machines.  

```plain
$ juju upgrade-series 0 prepare bionic
WARNING: This command will mark machine "0" as being upgraded to series "bionic".
This operation cannot be reverted or canceled once started.
Units running on the machine will also be upgraded. These units include:
  rabbitmq-server/0

Leadership for the following applications will be pinned and not
subject to change until the "complete" command is run:
  rabbitmq-server

Continue [y/N]? y
```

Answering `y` at this point initiates the upgrade process.

```plain
machine-0 started upgrade series from "xenial" to "bionic"
rabbitmq-server/0 pre-series-upgrade hook running
rabbitmq-server/0 pre-series-upgrade completed
machine-0 binaries and service files written

Juju is now ready for the series to be updated.
Perform any manual steps required along with "do-release-upgrade".
When ready, run the following to complete the upgrade series process:

juju upgrade-series 0 complete
```


<h3 id="heading--upgrading-the-operating-system">Upgrading the operating system</h3>

One important step in upgrading the operating system is the upgrade of all software packages. To do this on Ubuntu-based machines, log in to the machine via SSH and execute the `do-release-upgrade` command:

``` text
juju ssh 0
$ do-release-upgrade
```

This step typically requires interaction. The upgrade process may need assistance to indicate how to handle changed configuration files, for example.

### Mark the series upgrade as complete

Juju now needs to run the "complete" phase of the `upgrade-series` command. This gives charms the chance to execute any code that they need to when the operating system changes.

``` text
juju upgrade-series 0 complete
```

### Repeat steps for other machines

Upgrade the series of any other machines. In this example, machines `1` and `2` require upgrading. 

### Remove any units needed for upgrade

If necessary, remove any units created to maintain a quorum should be removed:

```
juju remove-unit rabbitmq-server/3
juju remove-unit rabbitmq-server/4
```

<!--





Machines are upgraded to a new  a with the `juju upgrade-series` command.

The `upgrade-series` command does not support upgrading a controller. An error will be emitted if you attempt to do so. See below section [Upgrading a controller machine](#heading--upgrading-a-controller-machine) for how to do that using an alternate method.

<h2 id="heading--upgrading-a-workload-machine">Upgrading a workload machine</h2>

Here is an overview of the process:

1.  The user initiates the upgrade.
    1.  The machine is no longer available for charm deployments or for hosting new containers.
    2.  Juju prepares the machine for the upcoming OS upgrade.
    3.  All units on the machine are taken into account.
2.  The user manually performs the upgrade of the operating system and makes any other necessary changes. This should be accompanied by a maintenance window managed by the user.
3.  The user informs Juju that the machine has been successfully upgraded. The machine becomes available for charm deployments.

At no time does Juju take any action to prevent the machine from servicing workload client requests.

In the examples that follow, the machine in question has an ID of '1', has one unit of 'apache2' deployed, and will be upgraded from Ubuntu 16.04 LTS (Xenial) to Ubuntu 18.04 LTS (Bionic).

<h3 id="heading--initiating-the-upgrade">Initiating the upgrade</h3>

You initiate the upgrade with the machine ID, the `prepare` sub-command, and the target series:

``` text
juju upgrade-series 1 prepare bionic
```

You will be asked to confirm the procedure. Use the `-y` option to avoid this prompt.

Then output will be shown, such as:

``` text
machine-1 started upgrade series from "xenial" to "bionic"
apache2/1 pre-series-upgrade hook running
apache2/1 pre-series-upgrade hook not found, skipping
machine-1 binaries and service files written

Juju is now ready for the series to be updated.
Perform any manual steps required along with "do-release-upgrade".
When ready, run the following to complete the upgrade series process:

juju upgrade-series 1 complete
```

All charms associated with the machine must support the target series in order for the command to complete successfully. An error will be emitted otherwise. There is a `--force` option available but it should be used with caution.

The deployed charms will be inspected for a 'pre-series-upgrade' hook. If such a hook exists, it will be run. In our example, such a hook was not found in the charm.

A machine in "prepare mode" will be noted as such in the output to the `status` (or `machines`) command:

``` text
Machine  State    DNS            Inst id        Series  AZ  Message
1        started  10.116.98.194  juju-573842-0  xenial      Series upgrade: prepare completed
```

<h3 id="heading--upgrading-the-operating-system">Upgrading the operating system</h3>

One important step in upgrading the operating system is the upgrade of all software packages. To do this, log in to the machine via SSH and apply the standard `do-release-upgrade` command:

``` text
juju ssh 1
$ do-release-upgrade
```

As a resource, use the [Ubuntu Server Guide](https://help.ubuntu.com/lts/serverguide/installing-upgrading.html). Also be sure to read the [Release Notes](https://wiki.ubuntu.com/Releases) of the target version.

Make any other required changes now, before moving on to the next step.

<h3 id="heading--completing-the-upgrade">Completing the upgrade</h3>

You should now verify that the machine has been successfully upgraded. Once that's done, tell Juju that the machine is ready:

``` text
juju upgrade-series 1 complete
```

Sample output:

``` text
machine-1 complete phase started
machine-1 started unit agents after series upgrade
apache2/0 post-series-upgrade hook running
apache2/0 post-series-upgrade hook not found, skipping
machine-1 series upgrade complete

Upgrade series for machine "1" has successfully completed
```

Deployed charms will be inspected for a 'post-series-upgrade' hook. If such a hook exists, it will be run. In our example, such a hook was not found in the charm.

You're done. The machine is now fully upgraded and is an active Juju machine.

-->
<h2 id="heading--upgrading-a-controller-machine"><h2 id="controller">Upgrading a controller machine</h2></h2>

To "upgrade" the series of a controller, create a new controller using the preferred series then migrate to it and delete the old controller:

### Create a new controller

Create the new controller with the `juju bootstrap` command. Here, we're using AWS and have called the new controller 'aws-new':

``` text
juju bootstrap aws aws-new --bootstrap-series=<series>
```

### Migrate models to the new controller

Now migrate your existing models by following the [Migrating models](/t/migrating-models/1152) page.

To ensure that all new machines will run the new series (like the controller, we'll use 'bionic') set the default series at the model level. For each migrated model:

``` text
juju model-config -m <model name> default-series=<series>
```


### Destroy the old controller

Destroy the old controller when done:

``` text
juju destroy-controller aws-old
```

<!-- LINKS -->
