# Backup and Restore of the Juju State-Server

Juju provides `backup` and `restore` commands to recover the juju state-server
(bootstrap node) in case of failure. The juju backup command creates a archive
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

The 'HA' case:

HA is a work in progress, for the moment we have a basic support which is an
extension of the regular backup functionality.
Please read carefully before attempting backup/restore on an HA environment.

The contemplated case for HA backup/restore is when you have lost all your state
servers and require to recover a basic setup in order to be able to perform
ensure availability again.
When backing up an HA enabled install, back-up will use the initial state-server
 and, in case of running restore, the only check performed is to make sure 
that same initial state-server is not up.
BEWARE, only run restore in the case where you no longer have working
State Servers since otherwise this will take them out of line and possibly
cripple your environment
