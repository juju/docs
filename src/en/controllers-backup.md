Title: Controller backups
TODO:  Bug tracking: https://bugs.launchpad.net/juju/+bug/1771433
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771426
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771202
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771673
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771657
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771674
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771821

# Controller backups

A backup of a controller enables one to re-establish the configuration and
state of a controller. It does **not** influence workload instances on the
backing cloud. That is, if such an instance is terminated directly in the cloud
then a controller restore cannot re-create it. However, as we'll see, a restore
does have the ability to re-create a controller instance.

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
generating an archive on the controller (a *remote* backup), and unless the
`--no-download` option is used, it will also be downloaded to the Juju client
system as a 'tar.gz' file (a *local* backup). The name of the backup is
composed of the creation time (in UTC) and a unique identifier.

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

 - `juju backups`
 - `juju show-backup`
 - `juju download-backup`
 - `juju upload-backup`
 - `juju remove-backup`

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

If the controller no longer exists, a new one can be created during the restore
process with the use of the `-b` option. Naturally, this scenario calls for
the use of a local backup:

```bash
juju restore-backup -m lxd:controller -b --file backup.tar.gz
```

!!! Important:
    A controller cannot be re-created if the original one was removed via the
    `destroy-controller`, `kill-controller`, or `unregister` commands. This is
    due to re-creation being dependent upon the client's awareness of the
    controller, which is something that the aforementioned commands erase.

It is also possible to specify constraints for the new controller with the aid
of the `--constraints` option:

```bash
juju restore-backup -m lxd:controller -b --constraints mem=4G --file backup.tar.gz
```

See [Reference: Juju constraints][reference-constraints] for more information
on constraints.

## High availability considerations

Although [Controller high availability][controllers-ha] makes for a more robust
(and load balanced) Juju infrastructure, it should not replace the need for
data backups. It does, however, make the prospect of restoring from backup less
likely, since as long as one controller cluster member remains operational, the
others can be replaced via the `enable-ha` command. A restore in an HA scenario
therefore only becomes necessary when *all* controllers have failed. However,
if a restore *is* applied to a cluster with active members all reachable
controllers will naturally have their data overwritten.

Section [Recovering from controller failure][recovering-ha-failure] details how
to deal with a partially degraded cluster. In the advent that all controllers
are unresponsive the following steps should be taken:

 1. Remove the cluster
 1. Create a pristine controller
 1. Perform a data restore
 1. Enable HA

To demonstrate this, consider an AWS-based controller named 'aws-ha3-1' with
three cluster members (numbered 0 through 2). Upon restore it assumes the name
of 'aws-ha3-2':

```bash
juju kill-controller aws-ha3-1
juju bootstrap aws aws-ha3-2
juju restore-backup -m aws-ha3-2:controller --file backup.tar.gz
juju enable-ha -m aws-ha3-2:controller -n 3
```


<!-- LINKS -->

[controllers-ha]: ./controllers-ha.html
[client-backups]: ./client.html#backups
[reference-constraints]: ./reference-constraints.html
[recovering-ha-failure]: ./controllers-ha.html#recovering-from-controller-failure
