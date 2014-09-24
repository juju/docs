# Juju High Availability
As of Juju 1.20, juju supports high availability for its state server.

High Availability in general terms means that we have 3 or more (up to 7) 
Juju state machines, with failover possible to another of the other machines
should something happen to the current master.

This is an overview of how it works:

### Mongo

Juju's High Availability (HA) mode is tightly integrated and dependent on
MongoDB.  Juju stores all its data about the environment in a MongoDB database.
MongoDB has an HA implementation that connects multiple mongoDB databases in a
cluster called a [replicaset](http://docs.mongodb.org/manual/replication/).  The
mongo replicaset has a 1:1 relation to Juju state servers, and the master of
the replicaset is the master of the Juju state servers.

### Ensure availability

To turn on HA mode for Juju, there is an `ensure-availabiity` command. By
default this sets the desired number of state machines in the environment to 3.
There is an optional `-n` parameter which can set this number higher.

As said above, there is a 1:1 relationship between the number of state machines
and the number of mongo instances. Due to this, the number of state machines
must be an odd number to prevent ties during voting for master, and the number
cannot exceed 7, because of limits in mongo.  In practice, this means the
possibilities are 3, 5 or 7 state machines.
 
Currently the number of state machines can be increased using the -n flag on 
`juju ensure-availability`, but not decreased. The only way to decrease the
number of machines is to create a backup of your environment and then restore
the backup to a new environment, which will start you with a single state server.

### When State Servers Fail

Juju does not automatically re-spawn state machines if one or more fail.
However, if you are already in HA mode, you can recover from state machine failure
by manually running `juju ensure-availability`, as long as more than half the
original number of machines are still running.  This will cause Juju to create
new state servers for each of the
failed state servers, and add them to the HA replicaset.  It will also mark the
failed servers for removal.  Note that it can take some time for this process to
complete (on the order of 30 seconds to 20 minutes depending on a lot of
variables like the load on the machines, the amount of data in the database, etc).

If fewer than half of the original state servers are still running, you cannot
recover through the ensure-availability command, because the mongo servers do
not have a quorum with which to elect a new master.  In this case, you must
restore from a previous backup.

When you run ensure-availability, the command will report the changes that it 
made to the system's desired model, which will shortly be reflected in reality.
