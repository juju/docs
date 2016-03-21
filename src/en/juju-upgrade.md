Title: Upgrading Juju software  


# Upgrading Juju software

At the highest level, a Juju topology can be divided into two main parts:

- Juju client
- Juju environment (possibly several)

The software at each of the above are managed differently.

The software for the client, which is responsible for administring all Juju
services in every environment, is managed by the OS package management system.
The software for the environment, which consists of the state server (bootstrap
node) and Juju machines/services, is managed by Juju itself. This section is
primarily devoted to describing the procedure for upgrading this environment
software.


## Upgrading the client software

The client software is managed by the OS package management system. With Ubuntu
this is APT. To upgrade the client, therefore, it is a matter of:

```bash
sudo apt-get update
sudo apt-get install juju-core
```

For more installation information and what versions are available, see
[the releases page](reference-releases.html).
 
## Terminology - the software running in a Juju environment

Several terms are in circulation that are used to denote the environment software:

- Juju tools
- Juju agent
- The daemon/binary, *jujud*

!!! Note: This guide will call "the software running in an environment" the
**server software**.


## Upgrading the server software

Overview:

- The server software is a single binary (`jujud`) that runs on every Juju
  machine and for every Juju unit. This typically results in multiple binaries
  per machine. Support for a single binary is in development.
- The upgrade is initiated via the `upgrade-juju` command, discussed below.
- In the advent that the state server is without internet access, the client
  will first supply the software to the state server's cache via the
  `sync-tools` command, discussed below.
- During the upgrade invocation, an algorithm will be used that will select a
  version to upgrade to if a version (`--version`) is not specified.
- Juju machines request the determined/requested software version from the
  state server. If the latter's cache cannot satisfy the request it will
  attempt a download from the internet.
- Backups are recommended prior to upgrading the server software. See
  [Backup and restore](./juju-backup-restore.html).

### Server software and related components

In general, the upgrade of the server software is independent of the following:

- Client software

    Although client and server software are independent, an upgrade of the server
    software is an opportune time to first upgrade the client software.

- Juju charms

    Juju charms and server software versions are meant to be orthogonal to one
    another so there is no necessity to upgrade charms before or after an
    upgrade of the server software.

- Running workloads

    Workloads running are independent of Juju so a downtime maintenance window
    is not normally required in order to perform an upgrade.

### Version nomenclature and the auto-selection algorithm

A version is denoted by:

`major.minor.patch`

For instance: `1.25.1`

!!! Note: Odd minor numbers no longer denote development versions. Instead, tags
such as 'alpha', 'beta', etc are used.

When not specifying a version to upgrade to (`--version`) an algorithm will be
used to auto-select a version.

Rules:

1. If the server major version matches the client major version, the version
   selected is minor+1. If such a minor version is not available then the next
   patch version is chosen.

1. If the server major version does not match the client major version, the
   version selected is that of the client version.

To demonstrate, let the available online versions be: 1.23, 1.24, 1.25, 1.25.1,
2.1, and 2.2. This gives:

- client 1.24, server 1.22 -> upgrade to 1.23
- client 2.1, server 1.22 -> upgrade to 2.1
- client 1.24, server 1.25 -> upgrade to 1.25.1

The online server software is found here:

- stable: https://streams.canonical.com/juju/tools/releases/
- devel: https://streams.canonical.com/juju/tools/devel/

### The sync-tools command

This pertains to the lack of internet connectivity for the state server.

If the state server cannot contact the above URLs then the client, which
presumably does have access, will need to download and transfer the software
to the state server prior to requesting an upgrade. This is accomplished with
the `sync-tools` command.

Examples:

Transfer the server software (auto-selected) to the state server:

```bash
juju sync-tools
```

Transfer the specified server software (all patch versions of 1.23) to the
state server:

```bash
juju sync-tools --version 1.23 --debug
```

!!! Note: the `sync-tools --version` command only accepts `major[.minor]`
("e.g. use '1.24' not '1.24.5').

For complete syntax, see the [command reference page](./commands.html#sync-tools)
or by running `juju help sync-tools`.

### The upgrade-juju command

The `upgrade-juju` command initiates the upgrade of the server software. This
will cause all Juju agents to be restarted. Before proceeding, ensure the
environment is in good working order (`juju status`).

Examples:

Upgrade the environment by allowing the version to be auto-selected:

```bash
juju upgrade-juju --debug
```

Upgrade the environment by specifying the version:

```bash
juju upgrade-juju --version 1.25.1 --debug
```

Track the progress with

```bash
watch -n3 "juju status --format tabular"
```

For complete syntax, see the [command reference page](./commands.html#upgrade-juju)
or by running `juju help upgrade-juju`.

!!! Warning: The `--upload-tools` option should be not be used by the end user.


## Verifying the upgrade

The verification of a successful upgrade is obtained by:

```bash
juju status
```

If this command does not complete properly or if there are errors displayed in
its output then proceed to the next section.


## Troubleshooting the upgrade

An upgrade of server software that does not lead to 100% success will require
troubleshooting. See [Troubleshooting environment upgrades](./troubleshooting-upgrade.html).
