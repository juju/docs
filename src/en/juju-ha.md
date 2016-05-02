Title: Juju High Availability  
TODO: Remove citation of HA logging bug when fixed (section: 'HA and logging')


# High Availability

Juju High Availability (HA) means that a Juju environment has 3 or more (up to
7) state servers (bootstrap nodes) one of which is the *master*. Automatic
failover occurs should the master lose connectivity.


## Juju HA and MongoDB

Juju HA is tightly integrated with the MongoDB database since that is where all
environment data is stored. The MongoDB software has a native HA implementation
and this is what Juju HA uses. A MongoDB cluster is called a
[replica set](http://docs.mongodb.org/manual/replication/) and, in the context
of Juju HA, i) each of its members corresponds to a different Juju state server
and ii) the MongoDB replica set master corresponds to the Juju state server master.

The number of state servers must be an odd number to prevent ties during voting
for master, and the number of state servers cannot exceed 7, due to MongoDB
limitations. This means a Juju HA cluster can have 3, 5 or 7 state servers.


## Activating and modifying HA

Juju HA is activated and modified with the `juju ensure-availability` command.
As will be shown in the next section, it is also used to recover from failed
state servers.

When activating HA, by default, this command sets the number of state
servers in the environment to 3. The optional `-n` switch can modify this 
number.

When modifying HA, the `-n` switch can be used to increase the number of state
servers. The only way to decrease is to create a backup of your environment
and then restore the backup to a new environment, which starts with a single
state server. You can then increase to the desired number.

Whenever you run ensure-availability, the command will report the changes it
intends to make, which will shortly be implemented.

For complete syntax, see the [command reference page](./commands.html#ensure-availability
).


## Recovering from state server failure

In the advent of failed state servers, Juju does not automatically re-spawn new
state servers nor remove the failed ones. However, as long as more than half of
the original number of state servers remain available you can manually recover.
The process is detailed below.

1. Run `juju ensure-availability`.
1. Verify that the output of `juju status` shows a value of `has-vote` for the
   `state-server-member-status` attribute for each new server and a value of
   `no-vote` for each old server. Once confirmed, the new servers are fully
   operational as cluster members and the old servers have been demoted (no longer
   part of HA). This process can take between 30 seconds to 20 minutes depending
   on machine resources and Juju data volume.
1. Run `juju ensure-availability` again to have Juju no longer consider the
   old machines as state servers. The `state-server-member-status` attribute
   should disappear from these machines.
1. Use the `juju remove-machine` command to remove the old machines entirely.

You cannot repair the cluster as outlined above if fewer than half of the
original state servers remain available because the MongoDB replica set will not
have the quorum necessary to elect a new master. You must restore from backups
in this case.


## HA and logging

All Juju machines send their logs to a controller in the HA cluster. Each
controller, in turn, sends those logs to a MongoDB database which is
synchronized across controllers. The user reads logging information with the
`juju debug-log` command as normal. See
[Viewing logs](./troubleshooting-logs.html).
