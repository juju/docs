Title: Upgrading Juju software


# Upgrading Juju software

A Juju topology can be divided into two main parts:

- Juju client
- Juju model (usually several)

The software in each of the above are installed and upgraded differently.

The software for the client, which is responsible for issuing commands to
manage Juju models, is overseen by the OS package management system.  The
software for the models, which house machines Juju creates, is managed by Juju
itself. This section is primarily devoted to describing the procedure for
upgrading this model software.


## Upgrading the client software

The client software is managed by the OS package management system. With Ubuntu
this is APT. To upgrade the client, therefore, it is a matter of:

```bash
sudo apt-get update
sudo apt-get install juju
```

For more installation information and what versions are available, see
[the releases page](reference-releases.html).
 

## Upgrading the model software

The model software consists of *Juju agents*. These are pieces of software that
run on each machine Juju creates, including controllers.

Overview:

- An upgrade is applied to agents running on all machines across a model.
- During the upgrade, an algorithm will select a version to upgrade to if a
  version is not specified.
- Juju machines request the new software version from the controller. If the
  latter's cache cannot satisfy the request the controller will attempt a
  download from the internet.
- Backups are recommended prior to upgrading the server software. See
  [Backup and restore](./controllers-backup.html).

See [Notes on upgrading Juju software](./models-upgrade-notes.html)
for upgrading details, including what to do when the controller lacks internet
access.

## The upgrade-juju command

The `juju upgrade-juju` command initiates the upgrade. This will cause all Juju
agents to be restarted. Before proceeding, ensure the model is in good working
order (`juju status`).

Examples:

Upgrade the model by allowing the version to be auto-selected:

```bash
juju upgrade-juju
```

Upgrade the model by specifying the version:

```bash
juju upgrade-juju --agent-version 2.0.3
```

Track the progress with:

```bash
watch -n3 "juju status --format=tabular"
```

For complete syntax, see the
[command reference page](./commands.html#upgrade-juju). The `juju help
upgrade-juju` command also provides reminders and more examples.

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
troubleshooting. See
[Troubleshooting environment upgrades](./troubleshooting-upgrade.html).
