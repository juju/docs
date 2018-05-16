Title: Controller backups
TODO:  Bug tracking: https://bugs.launchpad.net/juju/+bug/1771433
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771426
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771399
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1771202
  
# Controller backups

Data backups can be made of the Juju client and the Juju controller. This page
concerns itself with the controller aspect only. For information on client
backups see the [Juju client][client-backups] page.

A backup of a controller enables ones to fully re-establish the configuration
and state of a controller (and all its associated models/applications). A
controller backup should therefore be seen as more of an environment backup.

<!-- It does not influence the instances on the backing cloud -->

This page will cover the following topics:

 - Creating a backup
 - Managing backups
 - Restoring from a backup
 - High availability considerations

## The Juju controller

Juju provides commands for recovering a controller in case of breakage or in
the case where the controller ceases to exist, whether by accidental or
deliberate means.

The current state is held within the 'controller' model. Therefore, all backup
commands need to operate within that model, either by using the `-m` (model)
option, or by ensuring the current model is the 'controller' model.

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
    When storing backups from multiple controllers the default filenames do not
    reflect their associated controller, making it hard to distinguish among
    them. The `--filename` option allows one to specify a custom name for the
    file. This does not affect the remote archive name.
    
To create a backup of the 'lxd' controller while both adding an optional note
and using a custom filename:

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

!!! Important:
    It is not possible to upload a file that corresponds to a backup stored
    remotely. The process will be cancelled and an error message will be
    printed.

#### `juju remove-backup`

The `remove-backup` command removes a specific remote backup from a controller.
For instance:

```bash
juju remove-backup -m aws:controller 20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
```

### Restoring from a backup

To revert the state on an environment to a previous time the `restore-backup`
command is used. This command requires the use of the `--id` option:

```bash 
juju restore-backup --id=20180515-193724.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

To use a local backup instead:

```bash
juju restore-backup --file=juju-backup-lxd-20180515-193724.tar.gz
```

!!! Important:
    It is not possible to restore using a local backup (`--file`) that
    corresponds to a backup stored remotely. The process will be cancelled and
    an error message will be printed. The remote backup should just be used
    instead.

If the controller no longer exists, a new one can be created during the restore
process with the use of the `-b` option. Naturally, this use case requires the
use of a local backup:

```bash
juju restore-backup -b --file=backup.tar.gz
```

It is also possible to specify constraints for the new controller with the aid
of the `--constraints` option:

```bash
juju restore-backup -b --constraints mem=4G --file=backup.tar.gz
```

The [Reference: Juju constraints][reference-constraints] page contains more
information on constraints.

## High availability considerations

Although [Controller high availability][controllers-ha] makes for a more robust
(and load balanced) Juju infrastructure, it should not replace the need for
data backups. It does, however, make the prospect of restoring from backup less
likely, since as long as one controller cluster member remains, the others can
be replaced via the `enable-ha` command. The use case for HA backup & restore
is when *all* controllers have failed.

When you perform a backup in an HA context, the initial controller will be
chosen to perform the backup.

For performing a `restore-backup`, the only check performed by the utility is 
to make sure that the initial controller is not up. 

!!! Warning: 
    If your Juju environment still contains an existing controller, restoring a
    backup will overwrite its data or remove them.

To restore an initial bootstrap environment, the procedure is the same as for 
non-HA environments:

```bash
juju restore-backup  -b --file=backup.tar.gz
```

Once this step is completed, you will have a single controller running. Read 
[Controller high availability][controllers-ha] for how to re-enable HA.


<!-- LINKS -->

[controllers-ha]: ./controllers-ha.html
[client-backups]: ./client.html#backups
[reference-constraints]: ./reference-constraints.html
