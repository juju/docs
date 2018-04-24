Title: Controller high availability

# Controller high availability

To ensure the high availability of deployed applications, the controller must
itself be highly available. This necessitates the creation of additional
controllers, all of which naturally reside within the 'controller' model. The
initial controller becomes known as the *master* and automatic failover occurs
should it lose connectivity with its cluster peers.

See [Application high availability][application-ha] for the application side of
things.

## Overview

The number of controllers must be an odd number to allow the master to be
"voted in" amongst its peers. A cluster with an even number of members will
cause a random member to become inactive. This latter system will become a "hot
standby" and automatically become active should some other member fail.

Furthermore, due to limitations of the underlying database in an HA context,
that number cannot exceed seven. This means that a cluster can only have three,
five, or seven members.

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
Machine  State    DNS            Inst id              Series  AZ          Message
0        started  54.166.164.0   i-04790c2414e4c8e80  xenial  us-east-1a  running
1        pending  54.145.192.13  i-071660e9ce3c3cee5  xenial  us-east-1c  running
2        pending  54.80.176.66   i-0b36284d1ebb816cf  xenial  us-east-1a  running
```

Invoking `juju enable-ha` again would have no effect since three controllers
are already present.

Refreshing the list of controllers with `juju controllers --refresh` displays
an HA level of 3:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws-ha*     default  admin  superuser  aws/us-east-1             2         3     3  2.4-beta2
```

## Removing machines from the cluster

It is possible to remove a machine from the cluster at any time. Typical reasons for
doing this are:

 - A controller is misbehaving and your intention is to replace it with another
   one.
 - You've decided that your current level of HA is not necessary and you wish
   to decrease it.
     - If the removal of a controller will result in an **even** number of
       systems then one will act as a "hot standby".
     - If the removal of a controller will result in an **odd** number of
       systems then each one will actively participate in the cluster.

A controller is removed from the cluster by removing its machine from the
model (`juju remove-machine`).

Using the example in the previous section, this is how we would remove machine
'1':

```bash
juju remove-machine -m controller 1
```

The output to `juju controllers --refresh` now becomes:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws-ha*     default  admin  superuser  aws/us-east-1             2         2   1/2  2.4-beta2
```

<!-- State how a hot standby differ from multiple participating members.  -->
There is now only a single active controller (and one standby) in his cluster
(i.e. one out of two are active). Note that this situation should be rectified
as soon as possible.

!!! Note:
    The `enable-ha` command cannot be used to remove machines from the cluster.

## Adding machines to the cluster

Use the `enable-ha` command to achieve the desired number of controllers (i.e.
HA level).

In our ongoing example, our original 3-member cluster now has two machines. We
can bring it back to three by issuing `juju enable-ha` again but we would do
the following if we decided to make it a 5-member cluster instead:

```bash
juju enable-ha -n 5
```

This would cause three controllers (2 + 3 = 5) to be spawned.

The output to `juju controllers --refresh` now becomes:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws-ha*     default  admin  superuser  aws/us-east-1             2         5     5  2.4-beta2
```

## Viewing extended controller HA information

Extended information on controller HA can be obtained from the
`show-controller` command:

```bash
juju show-controller
```

Partial output for our 5-member cluster is listed here:

```no-highlight
 ...
 ...
 controller-machines:
    "0":
      instance-id: i-04790c2414e4c8e80
      ha-status: ha-enabled
    "2":
      instance-id: i-0b36284d1ebb816cf
      ha-status: ha-enabled
    "3":
      instance-id: i-09ff42ba5fb9429b0
      ha-status: ha-enabled
    "4":
      instance-id: i-098222dad56cbe9a0
      ha-status: ha-enabled
    "5":
      instance-id: i-0613fb1fa8346de8a
      ha-status: ha-enabled
  models:
    controller:
      uuid: e8c4d910-8818-4a8a-8839-25766a1875d3
      machine-count: 5
      core-count: 5
  ...
  ...
```

Here, `machine-count` is the total number of machines in model 'controller' and
`core-count` is the number of controller machines. The key `ha-status` shows
'ha-enabled' if a member is active and 'ha-pending' if it is in hot standby
mode.

## Recovering from controller failure

In the advent of failed controllers, new controllers are not automatically
re-spawned nor are failed ones removed. However, as long as more than half of
the original number of cluster members remain available manual recovery is
straightforward:

 1. Remove bad controllers (as described [above][#removing-controllers]).
 1. Add new controllers (as described [above][#adding-controllers]).

!!! Important:
    Controllers must be removed prior to the addition of new ones because the
    `enable-ha` command does not check for failure. It simply ensures the
    total number of members are present.

You must restore from backups in the unfortunate case where there are an
insufficient number of working controllers present. See
[Backing up and restoring Juju][juju-backups] for how that works.

A controller is considered failed if it enters the 'down' state. This can be
monitored by applying the `status` command to the 'controller' model:

```bash
juju status -m controller
```

This output shows that the controller running on machine '3' has lost
connectivity with the rest of the cluster:

```no-highlight
Machine  State    DNS             Inst id              Series  AZ          Message
0        started  54.166.164.0    i-04790c2414e4c8e80  xenial  us-east-1a  running
2        started  54.80.176.66    i-0b36284d1ebb816cf  xenial  us-east-1a  running
3        down     54.157.161.147  i-09ff42ba5fb9429b0  xenial  us-east-1e  running
4        started  54.227.91.241   i-098222dad56cbe9a0  xenial  us-east-1d  running
5        started  174.129.90.47   i-0613fb1fa8346de8a  xenial  us-east-1c  running
```

However, the 'HA' column in the output to `juju controllers --refresh` still
says '5', as before:

```no-highlight
Controller  Model    User   Access     Cloud/Region         Models  Machines    HA  Version
aws-ha*     default  admin  superuser  aws/us-east-1             2         5     5  2.4-beta2
```

To recover from this degraded cluster you would do:

```bash
juju remove-machine -m controller 3
juju enable-ha -n 5
```

## Controller HA and logging

All Juju machines send their logs to a controller in the HA cluster. Each
controller, in turn, sends those logs to a MongoDB database which is
synchronized across controllers. The user reads logging information with the
`juju debug-log` command as normal. See [Juju logs][logs].


<!-- LINKS -->

[application-ha]: ./charms-ha.html
[logs]: ./troubleshooting-logs.html
[juju-backups]: ./controllers-backup.html
[#removing-controllers]: #removing-machines-from-the-cluster
[#adding-controllers]: #adding-machines-to-the-cluster
