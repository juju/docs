# Backup and Restore of the Juju State-Server

Juju provides commands for recovering the juju state-server (bootstrap
node) in case of failure.  They allow you to get a backup of the state-
server as an archive file.  The backup file contains the state-server
configuration, keys, and environment data.  Then, if the state-server or
its host machine later fails, you can create a new state-server from the
backup file.

## backup

Use the `create` command to create a new backup file:

`juju backups create [-e ENV] [--quiet] [--filename=FILENAME | --no-download]`

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

```shell
juju backups create -e my-env
JUJU_ENV=my-env juju backups create
juju switch my-env
juju backups create
juju backups create --filename backup-19.tgz
```

## restore

Use the `restore` command to replace an environment's state-server with
a new one based on a backup archive:

`juju backups restore [--constraints CONSTRAINTS] [-e ENV] FILENAME`

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

```shell
juju backups restore juju-backup-20140403-1408.tar.gz
juju backups restore -e my-env backup-19.tgz
```

## HA (High Availability)

HA is a work in progress, for the moment we have basic support which is
an extension of the regular backup functionality.  Please read carefully
before attempting backup/restore on an HA environment.

The contemplated case for HA backup/restore is when you have lost all
your state servers and need to recover a basic setup in order to be
able to perform ensure availability again.  When backing up an HA-
enabled install, `backup` will use the initial state-server.  For
`restore`, the only check performed is to make sure that same initial
state-server is not up.

BEWARE, only run restore in the case where you no longer have any
working state-servers (under HA).  Otherwise restore will take them off-
line and possibly cripple your environment.
