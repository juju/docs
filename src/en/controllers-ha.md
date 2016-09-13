Title: Juju High Availability  
TODO: Remove citation of HA logging bug when fixed (section: 'HA and logging')

# High availability

To ensure the high availability of deployed applications, the Juju controller
must itself be highly available. This is accomplished by activating 'highly
available' mode which ensures 3 or more (up to 7) controllers (per cloud) are
available, one of which is the *master*.  Automatic failover occurs should the
master lose connectivity.


## Juju HA and MongoDB

Juju HA is tightly integrated with the MongoDB database since that is where all
environment data is stored. The MongoDB software has a native HA implementation
and this is what Juju HA uses. A MongoDB cluster is called a
[replica set](http://docs.mongodb.org/manual/replication/) and, in the context
of Juju HA, i) each of its members corresponds to a different controller
and ii) the MongoDB replica set master corresponds to the controller master.

The number of controllers must be an odd number to prevent ties during voting
for master, and the number of controllers cannot exceed 7, due to MongoDB
limitations. This means a Juju HA cluster can have 3, 5 or 7 controllers.


## Activating and modifying HA

Juju HA is activated and modified with the `juju enable-ha` command.
As will be shown in the next section, it is also used to recover from failed
controllers.

When activating HA, by default, this command sets the level of controller
redundancy in the environment to 3. The optional `-n` switch can modify this
number.

When modifying HA, the `-n` switch can be used to increase the number of
redundant controllers. The only way to decrease is to create a backup of your
environment and then restore the backup to a new environment, which starts with
a single controller. You can then increase to the desired number.

Whenever you run enable-ha, the command will report the changes it
intends to make, which will shortly be implemented.

For complete syntax, see the
[command reference page](./commands.html#ensure-availability).


## Recovering from controller failure

In the advent of failed controllers, Juju does not automatically re-spawn new
controllers nor remove the failed ones. However, as long as more than half of
the original number of controllers remain available you can manually recover.
The process is detailed below.

1. Run `juju enable-ha`.
1. Verify that the output of `juju status` shows a value of `has-vote` for 
   the `controller-member-status` attribute for each new server and a value of
   `no-vote` for each old server. Once confirmed, the new servers are fully
   operational as cluster members and the old servers have been demoted (no longer
   part of HA). This process can take between 30 seconds to 20 minutes depending
   on machine resources and Juju data volume.
1. Use the `juju remove-machine` command to remove the old machines entirely.

You cannot repair the cluster as outlined above if fewer than half of the
original controllers remain available because the MongoDB replica set will not
have the quorum necessary to elect a new master. You must restore from backups
in this case.


## HA and logging

All Juju machines send their logs to a controller in the HA cluster. Each
controller, in turn, sends those logs to a MongoDB database which is
synchronized across controllers. The user reads logging information with the
`juju debug-log` command as normal. See
[Viewing logs](./troubleshooting-logs.html).
