# Backup and Restore of the Juju State-Server

Juju provides commands for recovering the juju state-server (bootstrap
node) in case of failure.  They allow you to get a backup of the state-
server as an archive file.  The backup file contains the state-server
configuration, keys, and environment data.  Then, if the state-server or
its host machine later fails, you can create a new state-server from the
backup file.

## Backup

Use the `create` command to create a new backup file:

```bash
juju backups create [-e ENV] [--quiet] [--filename=FILENAME | --no-download]
```

The `create` command creates an archive file for the state-server in an
environment, along with metadata about that file.  By default the current
environment is used.  It may be explicitly identified by the -e option
or the `JUJU_ENV` shell env variable.

As a convenience, the state-server stores both the file and the
metadata.  However, the state-server may not be available when you need
access to the archive.  So it is up to you to keep a local copy of any
backup archive you may need later.  By default `juju backups create`
will download the new backup file, though you can use the --no-download
option to disable this.

If the --filename option is not provided to `create` then the backup
archive is downloaded with a default name that incorporates the date and
time, like `juju-backup-20140403-1408.tar.gz`.  The filename is printed
once the backup completes.  Unless the --quiet option is used, the backup
metadata is also printed.

Examples:

```bash
juju backups create -e my-env
JUJU_ENV=my-env juju backups create
juju switch my-env
juju backups create
juju backups create --filename backup-19.tgz
```


## Restore

Use the `restore` command to replace an environment's state-server with
a new one based on a backup archive:

```bash
juju backups restore [--constraints CONSTRAINTS] [-e ENV] FILENAME
```

The `restore` command creates a new juju state-server instance using the
data from the backup file.  This happens in the current environment (the
default) or the named environment if provided.  As with the normal
bootstrap command, any constraints you provide are applied to the new
state-server.

`restore` updates the existing instances in the environment to recognise
the new state-server.  The command ensures the old state-server is not
running before it creates the replacement.  Note that this command will
not bring an existing state-server to a previous state, but instead
creates a replacement.

Examples:

```bash
juju backups restore juju-backup-20140403-1408.tar.gz
juju backups restore -e my-env backup-19.tgz
```

## HA (High Availability)

As stated by [Juju HA](juju-ha.html) High Availability in general terms means that a Juju environment has 3 or more (up to 7) redundant state servers. 

The contemplated case for HA backup/restore is when you have lost all your state servers and need to recover a basic setup in order to be able to perform ensure availability again

### Backups on HA

When you perform a `backup` on a juju installation that has multiple redundant state-servers,
the initial state-server will be chosen to backup from.

As an example, the following environment has 3 active state-servers :

```bash
juju status -v
environment: juju
machines:
  "0":
    agent-state: started
    agent-version: 1.21.1
    dns-name: 10.5.0.61
    instance-id: 225fbf72-f753-4fa0-bbf4-e925dd6581a9
    instance-state: ACTIVE
    series: trusty
    hardware: arch=amd64 cpu-cores=1 mem=1024M root-disk=20480M
    state-server-member-status: has-vote
  "1":
    agent-state: started
    agent-version: 1.21.1
    dns-name: 10.5.0.62
    instance-id: 3c75f984-7282-4913-9d20-00332af5464f
    instance-state: ACTIVE
    series: trusty
    hardware: arch=amd64 cpu-cores=1 mem=1024M root-disk=20480M
    state-server-member-status: has-vote
  "2":
    agent-state: started
    agent-version: 1.21.1
    dns-name: 10.5.0.63
    instance-id: e483e28c-de0c-407f-be6c-f4363fe57edf
    instance-state: ACTIVE
    series: trusty
    hardware: arch=amd64 cpu-cores=1 mem=1024M root-disk=20480M
    state-server-member-status: has-vote
services: {}
```

Performing a backup on this environment, will be based on the first state-server machine (0):

```bash
juju backup 
Connecting to machine 0
Warning: Permanently added '10.5.0.64' (ECDSA) to the list of known hosts.
```

The before mentioned command will generate a tarball file containing all
the required information for restoring.


### Restoring on HA

Please note that a restore must take place when you have lost all your redundant
state-servers. If that is not the case , just issuing an `juju ensure-availability` will be enough to create
a new state-server replica on your environment.

For performing a `restore`, the only check performed by the utility is to make sure that the initial
state-server is not up. 

**CAUTION**: Please make sure to only run restore in the case where you no longer have any
working state-servers . Otherwise restore will take them off-

Please make sure to specify the environment to recover and the path to the file
generated by the juju backup:

```bash
juju restore -e juju juju-backup-20150210-1352.tgz
extracted credentials from backup file
re-bootstrapping environment
Bootstrapping environment "juju"
Starting new instance for initial state server
Launching instance
 - 7642836a-571e-4c7e-8a11-e6d2645bc7c8
Installing Juju agent on bootstrap instance
Waiting for address
Attempting to connect to 10.5.0.64:22
[...]
Bootstrapping Juju machine agent
Starting Juju machine agent (jujud-machine-0)
Bootstrap complete
connecting to newly bootstrapped instance
restoring bootstrap machine
copying backup file to bootstrap host
updating bootstrap machine
restored bootstrap machine
opening state
updating all machines
```

Once this step is completed, you have a single state-server running. To recover
the rest of the state-servers replicas, please perform

```bash
juju ensure-availability -n 3
```

This will create the remaining state-servers based on the restored one.
