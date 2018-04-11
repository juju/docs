Title: Update the series of a controller or machine
TODO:  Warning: Juju versions hardcoded

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

## Upgrading a machine

For the purpose of this guide, a unit '0' of application 'ghost' which resides
on machine '1' will be used. The series will be updated from 'trusty' to
'xenial'.

### Prerequisites

  1. Controller admin privileges
  1. All the charms deployed on the machine must support the new series.

### Recommended method

First, for every application, specify the new series:

```bash
juju update-series ghost xenial
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

### When there are resource constraints

In some cloud environments, there may not be the resources to update via
`juju add-unit` and `juju remove-unit`.

!!! Note:
    This method should be approached with caution. After the series is updated
    on an existing machine, the unit agent may not restart cleanly depending on
    software dependencies (e.g. software installed with `pip` may need to be
    installed in a new location or an application's version was updated
    without intent).

#### First step

Let Juju know what series should be used for future units added. If you are
using version 2.3 or later: `juju update-series ghost xenial`

If you are using a version prior to 2.3 follow the instructions for
[updating an application's series][app-update].

#### Do the update on existing machines

Follow the [Ubuntu Server Guide][serverguide-upgrade] on upgrading a Ubuntu
release. Be sure to read the [Release Notes][ubuntu-releases] of the target
version.

Log in to the machine with `juju ssh ghost/0`.

If asked during the upgrade, it's recommended to keep currently-installed
versions of configuration files.

#### Check that Juju services are running

On each machine, there is a machine service agent and, for each running unit, a
unit service agent. To check that they restarted properly after the upgrade:

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

##### Restarting Juju services when moving from Ubuntu 14.04 LTS (Trusty) to Ubuntu 16.04 LTS (Xenial)

If upgrading from Trusty to Xenial, transitioning the jujud service files from
[upstart to systemd][systemd] will also be necessary.

On Trusty, the files will be in /etc/init: `/etc/init/jujud-machine-1.conf`.

Make directories for new systemd config files:

```bash
sudo mkdir -p /var/lib/juju/init/jujud-machine-1
```

Create `exec-start.sh` and jujud service files for the machine agent.

`/var/lib/juju/init/jujud-machine-1/exec-start.sh`:

```no-highlight
#!/usr/bin/env bash

# Set up logging.
touch '/var/log/juju/machine-1.log'
chown syslog:syslog '/var/log/juju/machine-1.log'
chmod 0600 '/var/log/juju/machine-1.log'
exec >> '/var/log/juju/machine-1.log'
exec 2>&1

# Run the script.
'/var/lib/juju/tools/machine-1/jujud' machine --data-dir '/var/lib/juju' --machine-id 1 --debug
```

`/var/lib/juju/init/jujud-machine-1/jujud-machine-1.service`:

```no-highlight
[Unit]
Description=juju agent for machine-1
After=syslog.target
After=network.target
After=systemd-user-sessions.service

[Service]
Environment=""
LimitNOFILE=20000
ExecStart=/var/lib/juju/init/jujud-machine-1/exec-start.sh
Restart=on-failure
TimeoutSec=300

[Install]
WantedBy=multi-user.target
```

Change permissions on `exec-start.sh`: 

```bash
sudo chmod 755 /var/lib/juju/init/jujud-machine-1/exec-start.sh
```

Create a symbolic link from `jujud-machine-1.service` to `/etc/systemd/system`:

```bash
sudo ln -s /var/lib/juju/init/jujud-machine-1/jujud-machine-1.service /etc/systemd/system/
```

Configure the machine service to restart at boot time:

```bash
sudo ln -s /var/lib/juju/init/jujud-machine-1/jujud-machine-1.service /etc/systemd/system/multi-user.target.wants/jujud-machine-1.service
```

Restart the service: 

```bash
sudo systemctl start jujud-machine-1.service
```

Once started the machine agent will write the systemd files for the unit agents
and start them.

#### Last step

Let Juju know what series the machines are currently using. If you are using
version 2.3 or later: 

```bash
juju update-series 1 xenial
```

If you are using a version prior to 2.3 follow the instructions for
[updating an machine's series][mach-update].


<!-- LINKS -->

[models-migrate]: ./models-migrate.html
[app-update]: https://jujucharms.com/docs/2.2/howto-applicationupdateseries
[mach-update]: https://jujucharms.com/docs/2.2/howto-machineupdateseries
[serverguide-upgrade]: https://help.ubuntu.com/lts/serverguide/installing-upgrading.html
[ubuntu-releases]: https://wiki.ubuntu.com/Releases
[systemd]: https://wiki.ubuntu.com/SystemdForUpstartUsers
