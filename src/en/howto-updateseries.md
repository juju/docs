Title: Update the series of a juju controller or workload.

# Update the series of a juju controller or workload.

## Overview

Periodically it's necessary to update the operating system version, or series,
of existing workloads. This guide will cover how to do so in a Juju environment.

For the purpose of this guide, a unit 0 of ghost will be used which resides
on machine 1. The series will be updated from Ubuntu trusty to xenial.

## Updating a Juju controller.

### Prerequisites

  1. Admin privilages to the controller.
  2. An available instance resource in the controller's cloud.

### Recommended method.

Bootstrap a new controller specifying the series you'd like to use, e.g.
`juju bootstrap --config default-series=zesty` then use [`juju migrate`][migrate]
to transfer your models to the new Juju controller. Destroy the old
controller when done.

If you plan to update the series of the entire Juju environment, it's
recommended to set the `default-series` of each model to the new series.
This lets juju know, unless otherwise specified, to deploy new applications
with the new series.

```bash
juju switch <model>
juju model-config default-series=xenial
```

!!! Note:
    It is recommended not to updated the series of a Juju controller in situ.

## Updating a Juju workload or machine.

Below are steps to update a simple configuration

## Prerequisites

  1. Verify that the charm for the applications on the given machine support
  the series you wish to update to.
  2. Admin privilages to the controller where the model lives.

### Recommended method.

If it's possible to add new instances in the cloud juju is bootstrapped to,
and using juju version 2.3 or later:

First let juju know what series to use for the application moving forward with
`juju update-series ghost xenial`. Then add a new unit of the application to
replace each existing unit and remove the existing units of the application.

```bash
juju add-unit ghost
juju remove-unit ghost/0
```

If you are using a version prior to 2.3 follow the instructions for
[updating an application's series][app-update] before adding and removing
units.

### When there are resource constraints.

In some cloud environments, there may not be the resources to update via
`juju add-unit` and `juju remove-unit`.

!!! Note:
    This method should be approached with caution. After the series is updated
on an existing juju machine, the unit agent may not restart cleanly depending on
software dependencies. E.g. pip installed software may need to be installed
in a new location. Or the applications' version was updated without intent.

#### First step

Let juju know what series should be used for future units added. If you are
using verion 2.3 or later: `juju update-series ghost xenial`

If you are using a version prior to 2.3 follow the instructions for
[updating an application's series][app-update].

#### Prepare to update existing machines.

Stop the juju services running on the target machine.

```bash
juju ssh ghost/0
sudo systemctl stop jujud-unit-ghost-0.service
sudo systemctl stop jujud-machine-1.service
```
or
```bash
juju ssh ghost/0
sudo stop jujud-unit-ghost-0.service
sudo stop jujud-machine-1.service
```

#### Do the update on existing machines.

Follow the documentation on how to update a machine including reading any
release notes.

[do-release-upgrade command for Ubuntu][upgrade]

Login to the machine is done with `juju ssh ghost/0`

If asked during the upgrade, it's recommended to keep currently-installed
versions of configuration files and reboot once the upgrade is complete.


#### Have juju update agent data on the newly updated unit

This step will update the agent data on the newly updated unit appropriately for the
new series and restart the juju agents.

```bash
juju ssh ghost/0 -- sudo juju-updateseries --from-series trusty --to-series xenial --start-agents
```


#### Check that juju services are running

On each machine, there is a juju machine service running as well as a juju
unit service for each unit on the machine.  To check that they restarted after
the upgrade:

```bash
sudo systemctl status jujud*
```
```no-highlight
● jujud-unit-ghost-0.service - juju unit agent for ghost/0
   Loaded: loaded (/var/lib/juju/init/jujud-unit-ghost-0/jujud-unit-ghost-0.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2017-10-04 22:07:13 UTC; 2min 39s ago
...
● jujud-machine-1.service - juju agent for machine-1
   Loaded: loaded (/var/lib/juju/init/jujud-machine-1/jujud-machine-1.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2017-10-04 22:07:13 UTC; 2min 39s ago
```


#### Last step

Let juju know what series the machines are currently using. If you are using
verion 2.3 or later:
```bash
juju update-series 1 xenial
```

If you are using a version prior to 2.3 follow the instructions for
[updating an machine's series][mach-update].

### Caveats and Gotchas

#### When the python version has changed between series

If the all of following are true:

  1. you are updating the series of an existing machine

  2. the version of python has changed in the new series

  3. the charm uses pip to install packages

It will be necessary to force the unit to install python packages the new
version by running the following command on the unit before restarting unit's
service:

```bash
sudo rm /var/lib/juju/agents/unit*/charm/wheelhouse/.bootstrapped
```

[migrate]: ./models-migrate.html
[app-update]: https://jujucharms.com/docs/2.2/howto-applicationupdateseries
[mach-update]: https://jujucharms.com/docs/2.2/howto-machineupdateseries
[upgrade]: https://help.ubuntu.com/lts/serverguide/installing-upgrading.html
[systemd]: https://wiki.ubuntu.com/SystemdForUpstartUsers
