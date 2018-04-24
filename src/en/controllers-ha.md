Title: Controller high availability

# Controller high availability

To ensure the high availability of deployed applications, the controller must
itself be highly available. This necessitates the creation of additional
controllers, all of which naturally reside within the 'controller' model. The
initial controller becomes known as the *master* and automatic failover occurs
should it lose connectivity with its application units.

See [Application high availability][application-ha] for the application side of
things.

## Overview

The number of controllers must be an odd number to allow the master to be
"voted in" amongst its peers and, due to limitations of the underlying database
in an HA context, that number cannot exceed seven. This means that a controller
HA cluster can only have three, five, or seven members.

Controller HA is managed with the `juju enable-ha` command. It does this by
ensuring that the cluster has the requisite number of controllers present. By
default, this number is three but the `-n` switch can be used to change that.
Therefore, this command is used to both enable HA as well as compensate for any
missing controllers, as would be the case if HA was previously enabled but one
or more controllers was subsequently removed.

## Enabling controller HA

To enable controller HA simply invoke the `enable-ha` command:

```bash
juju enable-ha
```

Since a specific number of cluster machines was not requested the default of
three is used. We would therefore expect two new controllers to appear. Indeed,
the output to the above command reflects this:

```no-highlight
maintaining machines: 0
adding machines: 1, 2
```

We can also query for machines in the 'controller' model:

```bash
juju machines -m controller
```

The output should show two new machines being provisioned:

```no-highlight
Machine  State    DNS             Inst id              Series  AZ          Message
0        started  54.224.128.201  i-0d257845b1b3db358  xenial  us-east-1a  running
1        pending  54.80.183.224   i-01361ff249b902310  xenial  us-east-1a  running
2        pending  184.73.48.166   i-0d5d2c324057aa859  xenial  us-east-1c  running
```

Invoking `juju enable-ha` again would have no effect since three controllers
are already present.

## Removing machines from the cluster

It is possible to remove a machine from the cluster at any time. This is done
by removing it from the model: with the `remove-machine` command.

Using the example in the previous section, this is how we would remove the
machine with an ID of '1':

```bash
juju remove-machine -m controller 1
```

!!! Note:
    The `enable-ha` command cannot be used to remove machines from the cluster.

## Adding machines to the cluster

Use the `enable-ha` command to get the controllers back to the desired number.

In our ongoing example, our original 3-member cluster now has two machines. We
can bring it back to three by issuing `juju enable-ha` but we would do the
following if we decided to make it a 7-member cluster instead:

```bash
juju enable-ha -n 7
```

This would cause five controllers (2 + 5 = 7) to be spawned.

## Viewing controller HA information

Information on controller HA can be obtained from the `show-controller`
command:

```bash
juju show-controller
```

Partial output for our 7-member cluster is listed here:

```no-highlight
 ...
 ...
 controller-machines:
    "0":
      instance-id: i-0d257845b1b3db358
      ha-status: ha-enabled
    "2":
      instance-id: i-0d5d2c324057aa859
      ha-status: ha-enabled
    "3":
      instance-id: i-0db142ab98fde25b3
      ha-status: ha-enabled
    "4":
      instance-id: i-00fb0c0af5951adda
      ha-status: ha-enabled
    "5":
      instance-id: i-0582442cff0d3f5b4
      ha-status: ha-enabled
    "6":
      instance-id: i-0b8792cc9923f90c4
      ha-status: ha-enabled
    "7":
      instance-id: i-07ddf1cb50f49e230
      ha-status: ha-enabled
  models:
    controller:
      uuid: adfd3ab4-521a-481d-82b4-a23d089d8a64
      machine-count: 7
      core-count: 7
  ...
  ...
```

Here, `machine-count` is the total number of machines in model 'controller' and
`core-count` is the number of controller machines.

If a machine is removed then this would reduce the cluster to a 6-member
cluster. An even-numbered cluster cannot properly function and so one of the
controllers will randomly become dormant and will have its `ha-status` change
from 'ha-enabled' to 'ha-pending'. The output will look like this (machine '6'
was removed):

```no-highlight
 controller-machines:
    "0":
      instance-id: i-0d257845b1b3db358
      ha-status: ha-enabled
    "2":
      instance-id: i-0d5d2c324057aa859
      ha-status: ha-pending
    "3":
      instance-id: i-0db142ab98fde25b3
      ha-status: ha-enabled
    "4":
      instance-id: i-00fb0c0af5951adda
      ha-status: ha-enabled
    "5":
      instance-id: i-0582442cff0d3f5b4
      ha-status: ha-enabled
    "7":
      instance-id: i-07ddf1cb50f49e230
      ha-status: ha-enabled
  models:
    controller:
      uuid: adfd3ab4-521a-481d-82b4-a23d089d8a64
      machine-count: 6
      core-count: 6
```

Clearly, machine '2' has become dormant. Meaning the cluster is now "5 out of
6" or just "5/6". This conclusion is more readily visible by looking at the
output to the `juju controllers` command:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws*        default  admin  superuser  aws/us-east-1             2         6   5/6  2.4-beta2
```

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

## Controller HA and logging

All Juju machines send their logs to a controller in the HA cluster. Each
controller, in turn, sends those logs to a MongoDB database which is
synchronized across controllers. The user reads logging information with the
`juju debug-log` command as normal. See [Juju logs][logs].


<!-- LINKS -->

[application-ha]: ./charms-ha.html
[logs]: ./troubleshooting-logs.html
