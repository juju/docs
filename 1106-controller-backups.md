<!--
Todo:
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771433
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771426
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771202
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771673
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771657
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771674
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1771821
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1773468 (CRITICAL)
-->

A backup of a controller enables one to re-establish the configuration and state of a controller. It does **not** influence workload instances on the backing cloud. That is, if such an instance is terminated directly in the cloud then a controller restore cannot re-create it.

This page will cover the following topics:

-   Creating a backup
-   Managing backups
-   Restoring from a backup
-   High availability considerations

[note]
Data backups can also be made of the Juju client. See the [Juju client](/t/client/1083#backups) page for guidance.
[/note]

<h2 id="heading--the-juju-controller">The Juju controller</h2>

Juju provides commands for recovering a controller in case of breakage or in the case where the controller no longer exists.

The current state is held within the 'controller' model. Therefore, all backup commands need to operate within that model explicitly or by ensuring the current model is the 'controller' model. In the examples provided below, both the controller name and the model name are expressed explicitly (e.g. `-m aws:controller`). Due to the delicate nature of data backups, this method is highly recommended.

<h3 id="heading--creating-a-backup">Creating a backup</h3>

The `create-backup` command is used to create a backup. It does so by generating an archive and downloading it to the Juju client system as a 'tar.gz' file (a *local* backup). If the `--keep-copy` option is used then a copy of the archive will also remain on the controller (a *remote* backup). With the aid of the `--no-download` option a local backup can be prevented, but since the archive must be kept somewhere, this option implies `--keep-copy`.

The name of the backup is composed of the creation time (in UTC) and a unique identifier.

The below examples assume the existence of the following controllers (output to `juju controllers`):

``` text
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws         default  admin  superuser  aws/us-east-1             2         1  none  2.3.7  
lxd*        default  admin  superuser  localhost/localhost       2         1  none  2.3.7
```

To create a backup of the 'aws' controller:

``` text
juju create-backup -m aws:controller
```

Sample output:

``` text
20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
downloading to juju-backup-20180515-191942.tar.gz
```

From the name of the archive we see that the backup was made on May 15, 2018 at 19:19:42 UTC.

[note type="caution"]
Archive filenames do not include the associated controller name. Care should therefore be taken when archiving from multiple controllers. To specify a custom name use the `--filename` option. This option does not affect the remote archive name.
[/note]

To create a backup of the 'lxd' controller while both using a custom filename and adding an optional note:

``` text
juju create-backup -m lxd:controller --filename juju-backup-lxd-20180515-193724.tar.gz "fresh lxd controller"
```

The optional note is exposed via the `show-backup` command detailed below.

[note]
A backup of a fresh (empty) environment, regardless of cloud type, is approximately 56 MiB in size.
[/note]

<h3 id="heading--managing-backups">Managing backups</h3>

The following commands are available for managing backups (apart from restoring):

-   `backups`
-   `show-backup`
-   `download-backup`
-   `upload-backup`
-   `remove-backup`

<h4 id="heading--juju-backups">`juju backups`</h4>

The `backups` command displays the names of all remote backups for a given controller. For instance, to see all remotely stored backups for the 'lxd' controller:

``` text
juju backups -m lxd:controller
```

Sample output:

``` text
20180515-193724.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
20180515-195557.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

<h3 id="heading--juju-show-backup">`juju show-backup`</h3>

The `show-backup` command provides a metadata record for a specific remote backup (identified via the `backups` command). For example, to query a backup stored on the 'lxd' controller:

``` text
juju show-backup -m lxd:controller 20180515-195557.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

Sample output:

``` text
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

The `started` time is the most pertinent of the various timestamps. It refers to the time the backup was created.

<h4 id="heading--juju-download-backup">`juju download-backup`</h4>

The `download-backup` command downloads a specific remote backup (again, identified via the `backups` command). Here, we download a backup that is stored on the 'aws' controller:

``` text
juju download-backup -m aws:controller 20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
```

<h4 id="heading--juju-upload-backup">`juju upload-backup`</h4>

The `upload-backup` command uploads a specific local backup to a controller. For example:

``` text
juju upload-backup -m lxd:controller juju-backup-20180515-193724.tar.gz
```

[note]
It is not possible to upload a file that is equivalent to a backup stored remotely. The process will be cancelled and an error message will be printed.
[/note]

<h4 id="heading--juju-remove-backup">`juju remove-backup`</h4>

The `remove-backup` command removes a specific remote backup from a controller. For instance:

``` text
juju remove-backup -m aws:controller 20180515-191942.7e45250b-637a-4dc9-8389-c6aa70100cd6
```

To clean up any possible remote backups the `--keep-latest` option can be used. This option instructs Juju to remove all remote backups with the exception of the most recently created one:

``` text
juju remove-backup -m aws:controller --keep-latest
```

<h3 id="heading--restoring-from-a-backup">Restoring from a backup</h3>

To revert the state of an environment to a previous time the `restore-backup` command is used.

[note type="caution"]
The restore process does not validate that a backup archive corresponds to the controller it was created from. Make sure you do not overwrite a controller with the wrong backup.
[/note]

This command requires the use of the `--id` option when referring to a remote backup:

``` text
juju restore-backup -m lxd:controller --id 20180515-193724.9c6a3650-2957-489a-8f0c-6c3b5ce2e055
```

To apply a local backup the `--file` option must be used:

``` text
juju restore-backup -m lxd:controller --file juju-backup-lxd-20180515-193724.tar.gz
```

[note]
It is not possible to restore using a local backup that is equivalent to a remote backup. The process will be cancelled and an error message will be printed. The remote backup should just be used instead.
[/note]

<h2 id="heading--high-availability-considerations">High availability considerations</h2>

Although [Controller high availability](/t/controller-high-availability/1110) makes for a more robust (and load balanced) Juju infrastructure, it should not replace the need for data backups. It does, however, make the prospect of restoring from backup less likely, since as long as one controller cluster member remains operational, the others can be replaced via the `enable-ha` command. A restore in an HA scenario therefore only becomes necessary when *all* controllers have failed. However, if a restore *is* applied to a cluster with active members all reachable controllers will naturally have their data overwritten.

<h3 id="heading--restoring-to-a-cluster">Restoring to a cluster</h3>

It is not possible at this time to restore while HA is enabled.

To restore to an HA cluster one needs to first remove HA (by removing all but one of the controller machines) and then perform a restore operation. HA may then be re-enabled afterwards.

For example, consider a three-member cluster with machines '0', '1', and '2' in the 'controller' model and where a backup of the cluster was previously made (`aws-ha3.tar.gz`).

Here, we begin by removing machines '1' and '2' but you can remove any two:

``` text
juju remove-machine -m aws:controller 1 2
```

Now wait until Juju reports that it is in a non-HA state. This is indicated by the text 'none' under the 'HA' column in the output to the `controllers` command:

``` text
juju controllers
```

Sample output:

``` text
Controller  Model    User   Access     Cloud/Region   Models  Machines    HA  Version
aws*        default  admin  superuser  aws/us-east-1       3         2  none 2.4-rc1
```

There should now be only a single machine listed in the output to `juju machines -m aws:controller`.

We can now restore:

``` text
juju restore-backup -m aws:controller --file aws-ha3.tar.gz
```

After a while the two removed machines will reappear but in a 'down' state:

``` text
Machine  State    DNS            Inst id              Series  AZ          Message
0        started  54.80.251.128  i-0095fa21cda2b3b9c  xenial  us-east-1a  running
1        down     54.224.33.191  i-08105aeb4e04a26e2  xenial  us-east-1a  running
2        down     54.92.240.15   i-0e6417bf06d36498b  xenial  us-east-1c  running
```

Remove them by force:

``` text
juju remove-machine -m aws:controller 1 2 --force
```

You can now re-enable HA if desired:

``` text
juju enable-ha -c aws
```

See [Controller high availability](/t/controller-high-availability/1110) for guidance on using the `enable-ha` command.

<h3 id="heading--restoring-due-to-complete-cluster-failure">Restoring due to complete cluster failure</h3>

In the advent that all controllers are unresponsive the following steps should be taken:

1.  Remove the cluster
2.  Create a pristine controller
3.  Perform a data restore
4.  Enable HA

To demonstrate this, consider an initial AWS-based controller named 'aws-ha3-1' with three cluster members. The new controller will be called 'aws-ha3-2':

``` text
juju kill-controller aws-ha3-1
juju bootstrap aws aws-ha3-2
juju restore-backup -m aws-ha3-2:controller --file backup.tar.gz
juju enable-ha -m aws-ha3-2:controller -n 3
```

[note]
Section [Recovering from controller failure](/t/controller-high-availability/1110#heading--recovering-from-controller-failure) details how to deal with a partially degraded cluster.
[/note]

<!-- LINKS -->
