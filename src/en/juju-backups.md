Title: Back up and restore Juju  

# Backing up And Restoring Juju

It is always a good idea to keep backups, and it is possible to back up both the 
Juju client environment and the Juju state server (bootstrap node) to be able to 
reconnect to running cloud environments. Both the backing up and restore procedures
for each are detailed below.

## The Juju client

It is easy to forget that your client environment needs to be backed up. Aside 
from things like the 'environments.yaml' file, which you may be able to 
recreate, it contains unique files such as Juju's SSH keys, which are vital to 
be able to connect to a running instance. In order to also save any additional
configuration files (such as '.jenv' files for running environments, or
credentials) it is usually best to simply back up the entire Juju directory
(`~/.juju`).

!!! Note: On Windows systems, the Juju directory is in a different place
 (usually `C:\Users\<username>\AppData\Roaming\Juju`. Also, although `tar` is 
available for Windows, you may prefer to use a more Windows-centric backup 
application.

### Backup ~/.juju

As the Juju directory is simply just another directory on your filesystem, you 
may wish to include it in any regular backup procedure you already have. For a 
simple backup on an Ubuntu system, you can just use `tar` to create an archive 
of the directory:

```bash
cd ~
tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .juju 
```

This command datestamps the created file for easy identification, you may of
course, call it what you wish.

If you have used the local provider, you will need to run the command as a 
superuser:

```bash
cd ~
sudo tar -cpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz .juju 
```

This is because the local provider makes use of superuser privileges, and
consequently some of the files belong to 'root' and cannot be read by a normal
user. You will also find that the backup archives are substantially bigger. 
As the local provider stores everything in '~/.juju', you are effectively 
backing up the entire local environment also. If you aren't concerned about the 
local user, you can omit the local provider files by supplying the 
```--exclude-path=``` switch as many times as necessary and specifying the name 
of your local environment(s):

```bash
sudo tar -cvpzf juju-client-$(date "+%Y%m%d-%H%M%S").tar.gz --exclude=.juju/local --exclude=.juju/local2 .juju 
```

!!! Note: As mentioned previously, the files in this backup include the keys 
Juju uses to connect to running environments. Anybody who has access to this 
backup will be able to connect to and control your environments, so a further 
step of encrypting this backup file may be advisable.
 
### Restoring ~/.juju 

For Ubuntu, restoring your Juju client settings and environments is a simple 
matter of extracting the archive you created above.

```
cd ~
tar xzf juju-yymmdd-hhmmss.tar.gz 
```

!!! Note: This command will extract the contents of the archive and overwrite any 
existing files in the Juju directory. Please be sure that this is what you want!


In the case of any local environment, this will also be restored providing the 
actual service itself (LXC) has remained running.

## The Juju state server (bootstrap node)

Juju provides commands for recovering the Juju state server (bootstrap
node) in case of failure. The included commands allow you to create, restore and 
manage backup files containing the state server
configuration, keys, and environment data. If the state server or
its host machine later fails, you can create a new state server from the
backup file. For environments with "High availability" enabled, also see the 
[relevant sections below](#ha-(high-availability))

### Creating a backup file

Use the `create` command to create a new backup file:

```bash
juju backups create [-e ENV] [--quiet ] [--filename=FILENAME | --no-download]
```

The `create` command creates an archive file for the state server in an
environment, along with metadata about that file.  By default the current
environment is used. It may be explicitly identified by the -e option
or the `JUJU_ENV` shell environment variable.

As a convenience, the state server stores both the file and the
metadata (use `juju backups list` to see stored files), however, it is up to the
user to download and safely store these files for when they are needed. 
By default `juju backups create` will download the new backup file, though you
can use the --no-download option to disable this.

If the --filename option is not provided to `create` then the backup
archive is downloaded with a default name that incorporates the date and
time, such as `juju-backup-20151103-1408.tar.gz`. The filename is displayed
once the backup completes.  Unless the --quiet option is used, the backup
metadata is also output.

Examples:

```bash
juju backups create 
juju backups create --no-download
juju backups create -e my-env
juju backups create --filename backup-19.tgz
```

Note that creating a backup may take a long time.


### Managing Backups

Each time a backup is created, it is also stored on the state-server for
safekeeping, along with associated metadata giving it a unique id value and a 
timestamp. This means that you can manage backups from whatever client you can
connect from, and fetch previous backups if the originally downloaded file has
gone astray. For managing backups, the `juju backups` command has an additional 
set of subcommands:

### juju backups list    

usage: `juju backups list [--brief]`

The `list` subcommand will display all the backups currently available on the 
state server. There are two options for the output:

```bash
juju backups list
```
will display a complete list of all backup metadata for all the available 
backups. As such, it can output a lot of data, so you may consider using 
the `--brief` switch on the command, which will return just a list of the 
backup ID values:

```bash
juju backups list --brief
```

should return something like:

```bash
20150910-150614.f41b1639-09b3-4eb7-8fbf-0927558cdf44
20150911-192138.f41b1639-09b3-4eb7-8fbf-0927558cdf44
20150912-100824.f41b1639-09b3-4eb7-8fbf-0927558cdf44
20150914-160331.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```

The appended alphanumeric string is not actually random gibberish, but is 
an identifier for the instance the backup was created on. This information 
is not normally useful to the end user, but it does help give all backup 
files a unique name.

### juju backups download 

usage: `juju backups download [options] <ID>`

The `download` command will fetch the backup specified from the environment 
and download it for local storage. If the `--filename` switch is not used, the
backup is downloaded to the current directory and the filename used (derived 
from a timestamp and the ID) is output to the console. 

Examples:

```bash
juju backups download 20150914-150614.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```
will return:

```bash
juju-backup-20150914-150614.f41b1639-09b3-4eb7-8fbf-0927558cdf44.tar.gz
```


### juju backups info  

usage: `juju backups info [options] <ID>`
  
This command outputs the complete metadata record for the specified backup.
For example:

```bash
juju backups info 20150914-150614.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```

will result in output such as:

```no-highlight
backup ID:       "20150914-150614.f41b1639-09b3-4eb7-8fbf-0927558cdf44"
checksum:        "gECSwsOc2QtVG2RNrzk1bzCb+JU="
checksum format: "SHA-1, base64 encoded"
size (B):        32583286
stored:          2015-09-14 15:06:30 +0000 UTC
started:         2015-09-14 15:06:14.433210757 +0000 UTC
finished:        2015-09-14 15:06:23.634473665 +0000 UTC
notes:           ""
environment ID:  "f41b1639-09b3-4eb7-8fbf-0927558cdf44"
machine ID:      "0"
created on host: "juju-f41b1639-09b3-4eb7-8fbf-0927558cdf44-machine-0"
juju version:    1.24.5
20150914-150614.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```




### juju backups remove  
usage: `juju backups remove [options] <ID>`

If you wish to remove a particular backup file from the state server (perhaps to
save space!), you can use the remove subcommand with the appropriate ID:

```bash 
juju backups remove 20150914-160331.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```
After a short time, you should see a confirmation:

```bash
successfully removed: 20150914-160331.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```


### juju backups upload  
usage: `juju backups upload [options] <filename>`

As well as downloading backups from the Juju state server, it is also possible
to upload them. This can be useful either to break up the process of restoring from 
a backup (upload the file, then restore using the ID), or in the case where backups
have been removed from the state server.

By default, this command will return the new ID for the uploaded backup file. It 
is possible to return instead the complete metadata (using `--verbose`), or 
nothing at all (using `--quiet`) 

Examples:

```bash
juju backups upload mybackup.tar.gz
juju backups upload juju-backup-20150817-122042.tar.gz --quiet
juju backups upload juju-backup-20150817-122042.tar.gz --verbose
```

The metadata of uploaded files will reflect the time it was stored, but should
also determine the correct dates for when the backup was started/completed.

!!! Note: The filename you use to store local backups does not matter, but the 
uploaded file is expected to be a gzipped tar file (e.g. a `.tgz` or `.tar.gz` 
file)

### juju backups help 

You can get usage information from any of the backup commands by running:

```bash
juju backups help <command>
```

### Restoring from a backup

usage: `juju backups restore --id=<ID> | --file=<filname> [-b] [--constraints=<string>]`

If the state server for the environment is still operational it can be restored
from one of the stored backups by specifying the ID:

```bash 
juju backups restore --id=20150914-160331.f41b1639-09b3-4eb7-8fbf-0927558cdf44
```

It is also possible to restore from a local backup file by instead specifying
the filename. This will then be uploaded to the state server and used to restore
it:

```bash
juju backups restore --file=juju-backup-23.tgz
```
In the case that the original state server no longer exists, it is possible to 
re-bootstrap the environment and restore the backup to the new state-server. To 
do this, use the '-b' switch:

```bash
juju backups restore  -b --file=juju-backup-23.tgz
```

In this case it is also possible to specify constraints for the newly created
bootstrap node, for example:

```bash
juju backups restore  -b --constraints="mem=4G" --file=juju-backup-23.tgz
```

Read the [constraints reference page](./reference-constraints.html) for more
information on the constraints which may be used.

## HA (High Availability)

As stated in [the Juju HA documentation](./juju-ha.html), High Availability in
general terms means that a Juju environment has 3 or more (up to 7) redundant
state servers. In the normal course of operation, having multiple, redundant 
state servers means that requiring a backup is less likely. As long as one of 
the original state servers remains, the others can be replaced by simply
running the `juju ensure-availability` command again.

The contemplated case for HA backup/restore is when you have lost all your state
servers and need to recover a basic setup in order to be able to perform the 
`ensure availability` step again.

### Backups on HA

When you perform a `backup` on a Juju installation which has multiple redundant 
state-servers, the initial state-server will be chosen to perform the backup.

As an example, the following environment has 3 active state-servers. Running the command:

```bash
juju status
```

... will return something similar to:

```no-highlight
environment: jujutest
machines:
  "0":
    agent-state: started
    agent-version: 1.24.5
    dns-name: 50.16.32.73
    instance-id: i-a4fc2707
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=100 mem=1740M root-disk=8192M availability-zone=us-east-1a
    state-server-member-status: has-vote
  "1":
    agent-state: started
    agent-version: 1.24.5
    dns-name: 54.234.198.218
    instance-id: i-a7814672
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=100 mem=1740M root-disk=8192M availability-zone=us-east-1b
    state-server-member-status: has-vote
  "2":
    agent-state: started
    agent-version: 1.24.5
    dns-name: 54.196.44.204
    instance-id: i-2b1db88b
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=100 mem=1740M root-disk=8192M availability-zone=us-east-1c
    state-server-member-status: has-vote
...

```

Performing a backup on this environment, will be based on the first state-server,
_machine 0_:

```bash
juju backups create
```
...should return:

```no-highlight
backup ID:       "20150907-154511.19f1b8b2-29cc-43de-866d-48ef88cf2f17"
checksum:        "9NttJ4ELrA9XBlBFBX0ToxmrlNM="
checksum format: "SHA-1, base64 encoded"
size (B):        33013934
stored:          2015-09-07 15:45:59 +0000 UTC
started:         2015-09-07 15:45:11.831515387 +0000 UTC
finished:        2015-09-07 15:45:48.842386549 +0000 UTC
notes:           ""
environment ID:  "19f1b8b2-29cc-43de-866d-48ef88cf2f17"
machine ID:      "0"
created on host: "ip-10-180-194-91"
juju version:    1.24.5
20150907-154511.19f1b8b2-29cc-43de-866d-48ef88cf2f17
downloading to juju-backup-20150907-154511.tar.gz

```

As with backing up a non-HA environment, the backup file is stored on the state
server and automatically downloaded, or you can specify further options 
as [stated above](#creating-a-backup-file).

### Restoring on HA

Please note that a restore must take place when you have lost all your redundant
state-servers. If that is not the case, simply issuing the 
`juju ensure-availability` command will be enough to create
a new state-server replica on your environment.

For performing a `restore`, the only check performed by the utility is to make
sure that the initial state-server is not up. 

!!! WARNING: If your Juju environment still contains existing state servers, 
restoring a backup will overwrite their data or remove them.

To restore an initial bootstrap environment, the procedure is the same as for 
non-HA environments:

```bash
juju backups restore  -b --file=juju-backup-23.tgz
```

Once this step is completed, you will have a single state-server running. To
recover the rest of the state-server replicas, all that remains is to reissue
the command: 

```bash
juju ensure-availability -n 3
```

This will create additional state-servers based on the restored one.


