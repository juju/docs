Title: Back up and restore Juju  
TODO:  Actual backup restore command needs to be tested
  
  
# Backing Up and Restoring Juju

It is always a good idea to keep backups, and it is possible to back up both 
the Juju client environment and any Juju controllers to be able to reconnect
to running cloud environments. Both the backing up and restore procedures 
for each are detailed below.

## The Juju client

It is easy to forget that your client environment needs to be backed up. Aside 
from things like the 'credentials.yaml' file, which you may be able to 
recreate, it contains unique files such as Juju's SSH keys, which are vital to 
be able to connect to a running instance. In order to also save any additional
configuration files (such as the files used by running models) it is usually 
best to simply back up the entire Juju directory (`~/.local/share/juju`).

!!! Note: On Windows systems, the Juju directory is in a different place
 (usually `C:\Users\<username>\AppData\Roaming\Juju`. Also, although `tar` is 
available for Windows, you may prefer to use a more Windows-centric backup 
application.

### A simple backup of the Juju client directory

As the Juju directory is simply just another directory on your filesystem, you 
may wish to include it in any regular backup procedure you already have. For a 
simple backup on an Ubuntu system, you can just use `tar` to create an archive 
of the directory:

```bash
cd ~
tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .local/share/juju 
```

This command datestamps the created file for easy identification. You may, of
course, call it what you wish. 

!!! Note: As mentioned previously, the files in this backup include the keys 
Juju uses to connect to running environments. Anybody who has access to this 
backup will be able to connect to and use your controllers/models, so a 
further step of encrypting this backup file may be advisable.
 
### Restoring ~/.local/share/juju

For Ubuntu, restoring your Juju client settings is a simple matter of
extracting the archive you created above.

```bash
cd ~
tar xzf juju-yymmdd-hhmmss.tar.gz 
```

!!! Note: This command will extract the contents of the archive and overwrite 
any existing files in the Juju directory. Please be sure that this is what you 
want!


## The Juju controller

Juju provides commands for recovering a controller in case of failure. The
current state is held within the 'controller' model. Therefore, all backup 
commands need to operate within that model, either by using the 
'--model controller' argument with each command, or by ensuring you're within
the 'controller' model prior to using a backup command
(i.e.`juju switch controller`). In addition, if there are mulitple cloud
environments, and thus multiple controllers, ensure you are operating on the
proper controller. The backup commands allow you to create, restore and manage
backup files containing the controller configuration, keys, and environment
data. If the controller or its host machine later fails, you can recreate the
controller from the backup file. For environments with high availability
enabled, see [the relevant section below](#ha-(high-availability)). 

### Creating a backup file

Use the `create-backup` command to create a new backup file:

```bash
juju create-backup [--filename=FILENAME] [-m | --model] [--no-download]
```

The `create-backup` command generates an archive file for the current
environment, along with metadata about that file. Unless you issue the
`--no-download` argument, the archive will be both stored on your controller
and downloaded to your client as a 'tar.gz' file.

The backup name combines the date and time of a backup with a unique model 
identifier. The downloaded filename can be changed by using the `--filename` 
argument, but this won't change the name of the backup on the server.

Examples:

```bash
juju create-backup -m controller
juju switch controller; juju create-backup
juju create-backup --filename backup.tar.gz
```
Note that creating a backup may take a long time.

### Managing Backups

As each backup is stored on the controller, you can manage backups from 
whatever client you can connect from, and fetch previous backups if the 
originally downloaded file has gone astray. You can use the following commands
to manage and restore your backups:

### juju backups    

usage: `juju backups [-m | --model]`

The `list-backups` command will display the names of all the backups currently 
available on the controller. 

```bash
juju backups
```
The output will look something like the following:

```bash
20160428-172122.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
20160429-083238.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
20160429-091444.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
20160429-091622.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```

The appended alphanumeric string is not actually random gibberish, but is 
a model identifier for the instance the backup was created on. This 
information is not normally useful to the end user, but it does help give all 
backup files a unique name.

### juju download-backup

usage: `juju download-backup  [--filename=FILENAME] [-m | --model] <ID>`

The `download-backup` command will fetch the backup specified from the 
environment and download it for local storage. The `<ID>` is the identifier for 
the backup, as shown in the output of the `create-backup` and `list-backups` 
commands. If the `--filename` argument is used, the backup is downloaded to 
the current directory using the name from the argument.

Examples:

```bash
juju download-backup 20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```
will return the following file:

```bash
juju-backup-20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4.tar.gz
```

Using `--filename` to change the name of the download:

```bash
juju download-backup --filename backup.tar.gz 
20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```

will return:

```bash
backup.tar.gz
```

### juju show-backup 

usage: `juju show-backup [-m | --model] <ID>`
  
This command outputs the complete metadata record for the specified backup.

For example:

```bash
juju show-backup 20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```

will result in output such as:

```no-highlight
backup ID:       "20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4"
checksum:        "7ChuK/4IWCzd4XysP9j0UMFRCL8="
checksum format: "SHA-1, base64 encoded"
size (B):        45565185
stored:          2016-04-29 09:20:59 +0000 UTC
started:         2016-04-29 09:20:34 +0000 UTC
finished:        2016-04-29 09:20:50 +0000 UTC
notes:           ""
model ID:        "e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4"
machine ID:      "0"
created on host: "juju-e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4-machine-0"
juju version:    2.0
```

### juju remove-backup  
usage: `juju remove-backup [-m | --model] <ID>`

If you wish to remove a particular backup file from the controller (perhaps 
to save space!), you can use the `remove-backup` command with the appropriate 
ID:

```bash 
juju remove-backup 20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```
After a short time, you should see a confirmation:

```bash
successfully removed: 20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```


### juju upload-backup  
usage: `juju upload-backup [-m | --model] <filename>`

As well as downloading backups from the controller, it is also possible
to upload them. This can be useful either to break up the process of restoring 
from a backup (upload the file, then restore using the ID), or in the case 
where backups have been removed from the state server. On completion, the 
command will return all the metadata for the uploaded backup file. 

Examples:

```bash
juju upload-backup backup.tar.gz
```
will result in output such as:

```no-highlight
backup ID:       "20160429-092034.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4"
checksum:        "7ChuK/4IWCzd4XysP9j0UMFRCL8="
checksum format: "SHA-1, base64 encoded"
size (B):        45565185
stored:          2016-04-29 10:46:22 +0000 UTC
started:         2016-04-29 09:20:34 +0000 UTC
finished:        2016-04-29 10:32:35 +0000 UTC
notes:           ""
model ID:        "e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4"
machine ID:      "0"
created on host: "juju-e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4-machine-0"
juju version:    2.0
```

The metadata of uploaded files will reflect the time it was stored, but should
also determine the correct date and time for when the backup was 
started/completed. It's this date and time that's used to name the backup on 
the controller.

!!! Note: The filename you use to store local backups does not matter, but the 
uploaded file is expected to be a gzipped tar file (e.g. a `.tgz` or `.tar.gz` 
file)

### Restoring from a backup

usage: `juju restore-backup --id=<ID> | --file=<filname> [-b] [-m | --model] 
[--upload-tools] [--constraints=<string>]`

If the controller is still operational it can be restored from one of the
stored backups by specifying the ID:

```bash 
juju restore-backup --id=20160429-091622.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
```

It is also possible to restore from a local backup file by instead specifying
the filename. This will then be uploaded to the controller and used to 
restore it:

```bash
juju restore-backup --file=backup.tar.gz
```
In the case that the original controller no longer exists, it is possible to 
re-bootstrap the environment and restore the backup to the new controller. 
To do this, use the '-b' switch:

```bash
juju restore-backup -b --file=backup.tar.gz
```
When re-bootstrapping, you can upload a local version of the tools with the 
`--upload-tools` argument, just as you might with the original bootstrap 
procedure. It is also possible to specify constraints for the newly created 
bootstrap node, for example:

```bash
juju restore-backup -b --constraints="mem=4G" --file=backup.tar.gz
```
Read the [constraints reference page](./reference-constraints.html) for more
information on the constraints which may be used.

## HA (High Availability)

As stated in [Juju HA](./controllers-ha.html), high availability, in general
terms, indicates that a Juju environment has 3 or more (up to 7) redundant
controllers. In the normal course of operation, this means that requiring a
backup is less likely. As long as one of the original controller remains, the
others can be replaced by simply running the `juju enable-ha` command again.

The contemplated case for HA backup/restore is when you have lost all your
controllers and need to recover a basic setup in order to be able to perform
the `juju enable-ha` step again.

### Backups on HA

When you perform a backup on a Juju installation which has multiple redundant 
controllers, the initial controller will be chosen to perform the backup.

As an example, the following environment has 3 active controllers. Running 
the command:

```bash
juju status
```

... will return something similar to:

```no-highlight
[Services] 
NAME       STATUS EXPOSED CHARM 

[Units] 
ID      WORKLOAD-STATUS JUJU-STATUS VERSION MACHINE PORTS PUBLIC-ADDRESS MESSAGE 

[Machines] 
ID         STATE   DNS          INS-ID                               SERIES AZ 
  
0          started 10.55.61.153 f9bcfde5-a071-4892-aa05-16212256a125 trusty nova 
1          started 10.55.61.86  899bd5c0-7b00-4ae5-bf09-fab206bf9b43 trusty nova 
2          started 10.55.61.89  7d997259-31e5-4390-a14d-2d054685e2cd trusty nova 
```

Performing a backup on this environment, will be based on the first 
controller,
_machine 0_:

```bash
juju create-backup
```
...should return:

```no-highlight
20160429-124813.e94566bc-d02d-4a14-8ec2-e2dbed2f2ec4
downloading to juju-backup-20160429-124813.tar.gz
```

As with backing up a non-HA environment, the backup file is stored on the 
controller and automatically downloaded, or you can specify further options
as [stated above](#creating-a-backup-file).

### Restoring on HA

Please note that a restore must take place when you have lost all your 
redundant controllers. If that is not the case, simply issuing the
`juju enable-ha` command will be enough to create a new controller replica on 
your environment.

For performing a `restore-backup`, the only check performed by the utility is 
to make sure that the initial controller is not up. 

!!! WARNING: If your Juju environment still contains an existing controller, 
restoring a backup will overwrite its data or remove them.

To restore an initial bootstrap environment, the procedure is the same as for 
non-HA environments:

```bash
juju restore-backup  -b --file=backup.tar.gz
```

Once this step is completed, you will have a single controller running. To
recover the rest of the controller replicas, all that remains is to reissue
the command: 

```bash
juju enable-ha -n 3
```

This will create additional controllers based on the restored one.


