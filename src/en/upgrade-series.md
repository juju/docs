Title: Updating a machine series

# Updating a machine series

Starting with Juju `v.2.5.0`, to upgrade the series of a machine, be it a
workload or controller machine, the `upgrade-series` command is used.

Here is an overview of the process:

 1. The user initiates the upgrade.
    1. The machine is removed from the pool of available machines in the sense
       that charms can not be deployed upon it.
    1. A minimum amount of the machine's software is upgraded and some changes 
       internal to Juju are made. 
    1. All units on the machine are taken into account.
    1. At the end of this step, from Juju's standpoint, the machine is now
       running the target operating system.
 1. The user manually performs the upgrade of the operating system and makes
    any other necessary changes. This should be accompanied by a maintenance
    window managed by the user.
 1. The user informs Juju that the machine has been successfully upgraded. The
    machine is reinserted into the machine pool.

!!! Important:
    At no time does Juju take any action to prevent the machine from servicing
    workload client requests.

In the examples that follow, the machine in question has an ID of '1' and we'll
be moving from Ubuntu 16.04 LTS (Xenial) to Ubuntu 18.04 LTS (Bionic).
    
## Initiating the upgrade

You initiate the upgrade with the `prepare` sub-command, the machine ID, and
the target series:

```bash
juju upgrade-series prepare 1 bionic
```

You will be asked to confirm the procedure. To avoid this prompt use the
`--agree` option.

On workload machines, deployed charms will be inspected for a
'pre-series-upgrade' hook. If such a hook exists, it will be run. 

## Upgrading the operating system

One important step in upgrading the operating system is the upgrade of all
software packages. Apply the standard `do-release-upgrade` command to the
machine via SSH:

```bash
juju ssh 1 do-release-upgrade
```

As a resource, use the [Ubuntu Server Guide][serverguide-upgrade]. Also be sure
to read the [Release Notes][ubuntu-releases] of the target version.

Make any other required changes now, before moving on to the next step.

## Completing the upgrade

You should now verify that the machine has been successfully upgraded. Once
that's done, tell Juju that the machine is ready:

```bash
juju upgrade-series complete 1
```

On workload machines, deployed charms will be inspected for a
'post-series-upgrade' hook. If such a hook exists, it will be run. 

You're done. The machine is now fully upgraded and is an active Juju machine.


<!-- LINKS -->

[serverguide-upgrade]: https://help.ubuntu.com/lts/serverguide/installing-upgrading.html
[ubuntu-releases]: https://wiki.ubuntu.com/Releases
