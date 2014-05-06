# Backup and Restore of the Juju State-Server

Juju provides `backup` and `restore` commands to recover the juju state-server
(bootstrap node) in case or failure. The juju backup command creates a archive
of the state-server’s configuration, keys, and environment data. If the state-
server or its host machine failes, a new state-server can be created from the
backup file.

The `backup` command creates an dated archive of the current environment's
state-server. An archive like "juju-backup-20140403-1408.tgz" is created by this
command.

    juju switch my-env
    juju backup

Unlike most juju commands, `backup` does not accept the -e option to specific
the environment. You must `switch` to the environment or specify the envronment
name in the `JUJU_ENV` shell env variable.

    JUJU_ENV=my-env juju backup

The juju `restore` command creates a new juju state-server instance using the
data from the backup file. It updates the existing instances in the environment
to recognise the new state-server. The command ensures the environment's state-
server is not running before it creates the replacement.

    juju restore -e my-env juju-backup-20140403-1408.tgz

As with the normal bootstrap command, you can pass --constraints to setup the
new state-server.
