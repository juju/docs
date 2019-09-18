<!--
Todo:
- warning: ubuntu code names hardcoded
- bug tracking: https://bugs.launchpad.net/juju/+bug/1797399
- bug tracking: https://bugs.launchpad.net/juju/+bug/1797388
-->
Starting with Juju `v.2.5.0`, to upgrade the series of a machine, the `upgrade-series` command is used.

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

<h2 id="heading--upgrading-a-controller-machine">Upgrading a controller machine</h2>

At this time Juju does not support the series upgrade of a controller. A new controller will be needed, after which a migration of models from the old controller to the new one must be performed.

Create the new controller now. Here, we're using AWS and have called the new controller 'aws-new':

``` text
juju bootstrap aws aws-new
```

The controller itself will be deployed using Ubuntu 18.04 LTS (Bionic). Use option `bootstrap-series` to select something else.

Now migrate existing models by following the [Migrating models](/t/migrating-models/1152) page.

To ensure that all new machines will run the new series (like the controller, we'll use 'bionic') set the default series at the model level. For each migrated model:

``` text
juju model-config -m <model name> default-series=bionic
```

Destroy the old controller when done:

``` text
juju destroy-controller aws-old
```

<!-- LINKS -->
