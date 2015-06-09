# Juju High Availability

As of version 1.20, Juju supports high availability for its state server.

High Availability in general terms means that a Juju environment has 3 or more
(up to 7) redundant state servers. One of these is the master with automatic
failover occurring should something happen to the master.

This section describes how Juju's high availability features works.

### MongoDB

Juju's High Availability (HA) mode is tightly integrated and dependent on
MongoDB.  Juju stores all its data about the environment in a MongoDB database.
MongoDB has an HA implementation that connects multiple MongoDB databases in a
cluster called a [replicaset](http://docs.mongodb.org/manual/replication/).  The
replicaset has a 1:1 relation to Juju state servers, and the master of the
replicaset is the master of the Juju state servers.

### Ensure Availability

Juju's HA mode is turned on using the `juju ensure-availability` command. By
default this sets the desired number of state machines in the environment to 3.
There is an optional `-n` parameter which can be used to set this number higher.

As stated above, there is a 1:1 relationship between the number of state
machines and the number of MongoDB instances. This means that the number of
state machines must be an odd number to prevent ties during voting for master,
and the number of state servers cannot exceed 7, due to MongoDB limits.  In
practice, this means the possibilities are 3, 5 or 7 state machines.
 
Currently the number of state machines can be increased using the -n flag on
`juju ensure-availability`, but not decreased. The only way to decrease the
number of machines is to create a backup of your environment and then restore
the backup to a new environment, which starts with a single state server.

Whenever you run ensure-availability, the command will report the changes that
it made to the system's desired model, which will shortly be reflected in
reality.

### When State Servers Fail

Juju does not automatically re-spawn state machines if one or more fail.
However, if an environment is already in HA mode, you can recover from state
machine failure by manually re-running `juju ensure-availability`. This can be
done as long as more than half the original number of machines are still
running.

The process to recovering when state servers have failed is:

* Run `juju ensure-availability`. New state servers will be created to replace
  the dead ones.
* After some time the new state servers will be ready and the dead state servers
  will be removed from Juju's set of high availability state servers. This will
  take on the order of 30 seconds to 20 minutes depending on variables like the
  load on the machines and the amount of Juju configuration data to
  replicate. In the output from `juju status` the new state servers will have a
  `state-server-member-status` value of `has-vote` and the dead state servers
  will have `no-vote`. At this point, the state servers in the environment are
  fully-redundant again.
* To have Juju not treat the dead state server machines as state servers any
  more, run `juju ensure-availability` again. The `state-server-member-status`
  attribute will disappear from these machines in the `juju status` output.
* The dead state server hosts can now be completely removed from Juju's
  configuration by using `juju remove-machine`.
  
If fewer than half of the original state servers are still running, you cannot
recover by using the ensure-availability command because the MongoDB replicaset
does not have a quorum with which to elect a new master.  In this case, you must
restore from a previous backup.
