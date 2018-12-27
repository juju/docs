Title: Controller backups
TODO:  Bug tracking: https://bugs.launchpad.net/juju/+bug/1771433
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771426
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771202
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771673
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771657
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771674
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771821
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1773468 (CRITICAL)

# Controller backups

A backup of a controller enables one to re-establish the configuration and
state of a controller. It does **not** influence workload instances on the
backing cloud. That is, if such an instance is terminated directly in the cloud
then a controller restore cannot re-create it.

This page will cover the following topics:

 - Creating a backup
 - Managing backups
 - Restoring from a backup
 - High availability considerations

!!! Note:
    Data backups can also be made of the Juju client. See the
    [Juju client][client-backups] page for guidance.

## The Juju controller

Juju provides commands for recovering a controller in case of breakage or in
the case where the controller no longer exists.

The current state is held within the 'controller' model. Therefore, all backup
commands need to operate within that model explicitly or by ensuring the
current model is the 'controller' model. In the examples provided below, both
the controller name and the model name are expressed explicitly (e.g.
`-m aws:controller`). Due to the delicate nature of data backups, this method
is highly recommended.

### Creating a backup

The `create-backup` command is used to create a backup. It does so by
generating an archive and downloading it to the Juju client system as a
'tar.gz' file (a *local* backup). If the `--keep-copy` option is used then a
copy of the archive will also remain on the controller (a *remote* backup).
With the aid of the `--no-download` option a local backup can be prevented, but
since the archive must be kept somewhere, this option implies `--keep-copy`.

The name of the backup is composed of the creation time (in UTC) and a unique
identifier.

The below examples assume the existence of the following controllers (output to
`juju controllers`):

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws         default  admin  superuser  aws/us-east-1             2         1  none  2.3.7  
lxd*        default  admin  superuser  localhost/localhost       2         1  none  2.3.7
```

To create a backup of the 'aws' controller:

```bash
juju create-backup -m aws:controller
```

Sample output:

```no-highlight
20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
downloading to juju-backup-20180515-191942.tar.gz
```

From the name of the archive we see that the backup was made on May 15, 2018 at
19:19:42 UTC.

!!! Warning:
    Archive filenames do not include the associated controller name. Care
    should therefore be taken when archiving from multiple controllers. To
    specify a custom name use the `--filename` option. This option does not
    affect the remote archive name.

To create a backup of the 'lxd' controller while both using a custom filename
and adding an optional note:

```bash
juju create-backup -m lxd:controller --filename juju-backup-lxd-20180515-193724.tar.gz "fresh lxd controller"
```

The optional note is exposed via the `show-backup` command detailed below.

!!! Note:
    A backup of a fresh (empty) environment, regardless of cloud type, is
    approximately 56 MiB in size.

### Managing backups

The following commands are available for managing backups (apart from
restoring):

 - `backups`
 - `show-backup`
 - `download-backup`
 - `upload-backup`
 - `remove-backup`

#### `juju backups`

The `backups` command displays the names of all remote backups for a given
controller. For instance, to see all remotely stored backups for the 'lxd'
controller:

```bash
juju backups -m lxd:controller
```

Sample output:

```no-highlight
20180515-193724.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
20180515-195557.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

### `juju show-backup`

The `show-backup` command provides a metadata record for a specific remote
backup (identified via the `backups` command). For example, to query a backup
stored on the 'lxd' controller:

```bash
juju show-backup -m lxd:controller 20180515-195557.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

Sample output:

```no-highlight
backup ID:       "20180515-193724.9c6a3650-2957-489a-8f0c-6c3b5ce2e055"
checksum:        "pmxx7bCwtZVV+KM48YKz5w6Boc0="
checksum format: "SHA-1, base64 encoded"
size (B):        58605244
stored:          2018-05-15 19:40:28 +0000 UTC
started:         2018-05-15 19:37:24 +0000 UTC
finished:        2018-05-15 19:37:41 +0000 UTC
notes:           "fresh lxd controller"
model ID:        "9c6a3650-2957-489a-8f0c-6c3b5ce2e055"
machine ID:      "0"
created on host: "juju-e2e055-0"
juju version:    2.3.7
```

The `started` time is the most pertinent of the various timestamps. It refers
to the time the backup was created.

#### `juju download-backup`

The `download-backup` command downloads a specific remote backup (again,
identified via the `backups` command). Here, we download a backup that is
stored on the 'aws' controller:

```bash
juju download-backup -m aws:controller 20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
```

#### `juju upload-backup`

The `upload-backup` command uploads a specific local backup to a controller.
For example:

```bash
juju upload-backup -m lxd:controller juju-backup-20180515-193724.tar.gz
```

!!! Note:
    It is not possible to upload a file that is equivalent to a backup stored
    remotely. The process will be cancelled and an error message will be
    printed.

#### `juju remove-backup`

The `remove-backup` command removes a specific remote backup from a controller.
For instance:

```bash
juju remove-backup -m aws:controller 20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
```

To clean up any possible remote backups the `--keep-latest` option can be used.
This option instructs Juju to remove all remote backups with the exception of
the most recently created one:

```bash
juju remove-backup -m aws:controller --keep-latest
```

### Restoring from a backup

To revert the state of an environment to a previous time the `restore-backup`
command is used.

!!! Warning:
    The restore process does not validate that a backup archive corresponds to
    the controller it was created from. Make sure you do not overwrite a
    controller with the wrong backup.

This command requires the use of the `--id` option when referring to a remote
backup:

```bash 
juju restore-backup -m lxd:controller --id 20180515-193724.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

To apply a local backup the `--file` option must be used:

```bash
juju restore-backup -m lxd:controller --file juju-backup-lxd-20180515-193724.tar.gz
```

!!! Note:
    It is not possible to restore using a local backup that is equivalent to a
    remote backup. The process will be cancelled and an error message will be
    printed. The remote backup should just be used instead.

## High availability considerations

Although [Controller high availability][controllers-ha] makes for a more robust
(and load balanced) Juju infrastructure, it should not replace the need for
data backups. It does, however, make the prospect of restoring from backup less
likely, since as long as one controller cluster member remains operational, the
others can be replaced via the `enable-ha` command. A restore in an HA scenario
therefore only becomes necessary when *all* controllers have failed. However,
if a restore *is* applied to a cluster with active members all reachable
controllers will naturally have their data overwritten.

### Restoring to a cluster

It is not possible at this time to restore while HA is enabled.

To restore to an HA cluster one needs to first remove HA (by removing all but
one of the controller machines) and then perform a restore operation.
HA may then be re-enabled afterwards.

For example, consider a three-member cluster with machines '0', '1', and '2' in
the 'controller' model and where a backup of the cluster was previously made
(`aws-ha3.tar.gz`).

Here, we begin by removing machines '1' and '2' but you can remove any two:

```bash
juju remove-machine -m aws:controller 1 2
```

Now wait until Juju reports that it is in a non-HA state. This is indicated by
the text 'none' under the 'HA' column in the output to the `controllers`
command:

```bash
juju controllers
```

Sample output:

```no-highlight
Controller  Model    User   Access     Cloud/Region   Models  Machines    HA  Version
aws*        default  admin  superuser  aws/us-east-1       3         2  none 2.4-rc1
```

There should now be only a single machine listed in the output to
`juju machines -m aws:controller`.

We can now restore:

```bash 
juju restore-backup -m aws:controller --file aws-ha3.tar.gz
```

After a while the two removed machines will reappear but in a 'down' state:

```no-highlight
Machine  State    DNS            Inst id              Series  AZ          Message
0        started  54.80.251.128  i-0095fa21cda2b3b9c  xenial  us-east-1a  running
1        down     54.224.33.191  i-08105aeb4e04a26e2  xenial  us-east-1a  running
2        down     54.92.240.15   i-0e6417bf06d36498b  xenial  us-east-1c  running
```

Remove them by force:

```bash
juju remove-machine -m aws:controller 1 2 --force
```

You can now re-enable HA if desired:

```bash
juju enable-ha -c aws
```

See [Controller high availability][controllers-ha] for guidance on using the
`enable-ha` command.

### Restoring due to complete cluster failure

In the advent that all controllers are unresponsive the following steps should
be taken:

 1. Remove the cluster
 1. Create a pristine controller
 1. Perform a data restore
 1. Enable HA

To demonstrate this, consider an initial AWS-based controller named 'aws-ha3-1'
with three cluster members. The new controller will be called 'aws-ha3-2':

```bash
juju kill-controller aws-ha3-1
juju bootstrap aws aws-ha3-2
juju restore-backup -m aws-ha3-2:controller --file backup.tar.gz
juju enable-ha -m aws-ha3-2:controller -n 3
```

!!! Note:
    Section [Recovering from controller failure][recovering-ha-failure] details
    how to deal with a partially degraded cluster.


<!-- LINKS -->

[controllers-ha]: ./controllers-ha.html
[client-backups]: ./client.html#backups
[reference-constraints]: ./reference-constraints.html
[recovering-ha-failure]: ./controllers-ha.html#recovering-from-controller-failure
[controllers-ha]: ./controllers-ha.md
