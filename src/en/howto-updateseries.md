Title: Update the series of a controller or machine
TODO:  Warning: Juju versions hardcoded
       Should eventually remove the two "prior to 2.3" Notes

# Update the series of a controller or machine

It may sometimes be necessary to upgrade the operating system version (i.e.
series) of the controller and/or the machines.

## Upgrading a controller

### Prerequisites

  1. Controller admin privileges
  1. An available instance resource in the controller's cloud

### Recommended method

At this time there is no way to update the series of a controller. A new
controller will be needed, after which a migration of models from the old
controller to the new one must be performed.

Create the new controller now. A series can be explicitly set for all
newly-created models (if desired):

```bash
juju bootstrap --config default-series=<series> <cloud name>
```

The controller itself will be deployed using the latest LTS Ubuntu release. Use
option `bootstrap-series` to select something else.

Now migrate existing models by following the [Migrating models][models-migrate]
page.

To ensure that all new machines will run the new series set the default series
at the model level. For each migrated model:

```bash
juju model-config -m <model name> default-series=<series>
```

Destroy the old controller when done.

Note that the series running on any existing Juju machines have not yet been
affected (see next section).

## Upgrading a machine/unit

For the purpose of this guide, a unit '0' of application 'ghost' which resides
on machine '1' will be used. The series will be updated from 'trusty' to
'xenial'.

### Prerequisites

  1. Controller admin privileges
  1. All the charms deployed on the machine must support the new series.

### Recommended method

First, for every application, specify the new series:

```bash
juju set-series ghost xenial
```

Then add a new unit of the application to replace each existing unit and remove
the old units:

```bash
juju add-unit ghost
juju remove-unit ghost/0
```

If you are using a version prior to 2.3 follow the instructions for
[updating an application's series][app-update] before adding and removing
units.

You are now done.

### Alternative method

In some cloud environments, there may not be the resources to update using the
above recommended method. Instead we need to upgrade the existing machine
manually and update the agent data, as shown here:

!!! Negative "Warning":
    This method should be approached with caution. After the series is updated
    on an existing machine, the unit agent may not restart cleanly depending on
    software dependencies (e.g. software installed with `pip` may need to be
    installed in a new location or an application's version was updated
    without intent).

#### Update series for new units

!!! Note:
    If you are using a version of Juju prior to 2.3 follow the instructions for
    [updating an application's series][app-update].

Let Juju know what series should be used for any new units of the application:

```bash
juju set-series ghost xenial
```

#### Upgrade the existing machine

!!! Note:
    If you are using a version prior to 2.3 follow the instructions for
    [updating an machine's series][mach-update].

Start by logging in to the machine:

```bash
juju ssh ghost/0
```

Then follow the [Ubuntu Server Guide][serverguide-upgrade] on upgrading an
Ubuntu release. Be sure to read the [Release Notes][ubuntu-releases] of the
target version.

If asked during the upgrade, it's recommended to keep currently-installed
versions of configuration files.

#### Update agent data on the upgraded machine

!!! Negative "Warning":
    If the Python version has changed between the two series **and** the charm
    uses `pip` to install packages then it will be necessary to force the unit
    to install the new Python packages by running the following command on the
    unit's machine prior to restarting the unit's service:
    `sudo rm /var/lib/juju/agents/unit*/charm/wheelhouse/.bootstrapped` .

Update the agent data on the newly updated machine/unit appropriate for the new
series and restart the agents:

```bash
juju ssh ghost/0 -- sudo juju-updateseries --from-series trusty --to-series xenial --start-agents
```

#### Verify the agents are running

On every machine, there is a machine service agent and, for each running unit,
a unit service agent. To check that they restarted properly after the upgrade:

```bash
sudo systemctl status jujud*
```

Sample output:

```no-highlight
● jujud-unit-ghost-0.service - juju unit agent for ghost/0
   Loaded: loaded (/var/lib/juju/init/jujud-unit-ghost-0/jujud-unit-ghost-0.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2017-10-04 22:07:13 UTC; 2min 39s ago

● jujud-machine-1.service - juju agent for machine-1
   Loaded: loaded (/var/lib/juju/init/jujud-machine-1/jujud-machine-1.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2017-10-04 22:07:13 UTC; 2min 39s ago
```

#### Let Juju know of the upgraded machines and agents

Once all machines and agents have been updated we need to inform Juju of this
fact. Here we refer to our example machine with an ID of '1':

```bash
juju set-series 1 xenial
```


<!-- LINKS -->

[models-migrate]: ./models-migrate.html
[app-update]: https://jujucharms.com/docs/2.2/howto-applicationupdateseries
[mach-update]: https://jujucharms.com/docs/2.2/howto-machineupdateseries
[serverguide-upgrade]: https://help.ubuntu.com/lts/serverguide/installing-upgrading.html
[ubuntu-releases]: https://wiki.ubuntu.com/Releases
[systemd]: https://wiki.ubuntu.com/SystemdForUpstartUsers
