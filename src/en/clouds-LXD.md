Title: Using LXD with Juju
TODO:  Warning: Ubuntu release versions hardcoded
       2.5 release will demand significant reword: LXD can be used remotely
       Warning: Troubleshoot Trusty; bootstrap only works with the lxd snap
       (and only if it is installed w/o the lxd deb being installed first)
table_of_contents: True

# Using LXD with Juju

Choosing [LXD][ubuntu-lxd] as the backing cloud for Juju is an efficient way to
experiment with Juju. It is also very quick to set up. With lightweight
containers acting as Juju machines, even a moderately powerful laptop can
create useful models, or serve as a platform to develop your own charms. Make
sure you have enough local space for the containers though.

A tutorial is available on this same topic:
[Getting started with Juju and LXD][tut-lxd].

!!! Note:
    Work is currently underway that will allow Juju to connect to remote LXD
    hosts.

## Software prerequisites

Both LXD and Juju will be needed on the host system.

LXD is installed by default (by Ubuntu package) on all supported Ubuntu
releases with the exception of Ubuntu 14.04 LTS. However, the snap install
method will soon become the preferred way to install LXD. See
[Using the LXD snap][lxd-snap] for how to do this.

Install Juju now (see the [Installing Juju][install] page).

Then follow the instructions below for installing LXD based on your chosen
Ubuntu release.

### Ubuntu 14.04 LTS

On Trusty, install LXD from the 'trusty-backports' pocket. This will ensure a
recent (and supported) version is used:

```bash
sudo apt install -t trusty-backports lxd
```

!!! Note:
    It's been reported that the snap install works significantly better on
    Trusty than what's available in the Ubuntu archive.

### Ubuntu 16.04 LTS

On Xenial, install LXD from the 'xenial-backports' pocket. This will ensure a
recent (and supported) version is used:

```bash
sudo apt install -t xenial-backports lxd 
```

!!! Note:
    Installing LXD in this way will update LXD if it is already present on your
    system.

### Ubuntu 16.10 and greater

On these releases, install LXD in the usual way:

```bash
sudo apt install lxd
```

## User group

In order to use LXD, the system user who will act as the Juju operator must be
a member of the 'lxd' user group. Ensure that this is the case (below we assume
this user is 'john'):

```bash
sudo adduser john lxd
```

The user will be in the 'lxd' group when they next log in. If the intended Juju
operator is the current user all that's needed is a group membership refresh:

```bash
newgrp lxd
```

You can confirm the active group membership for the current user by running the
command:

```bash
groups
```

## Alternate backing file-system

LXD can use various file-systems for its containers. Below we show how to
implement ZFS, as it provides the best experience.

!!! Note:
    ZFS is not supported on Ubuntu 14.04 LTS.
    
Proceed as follows:

```bash
sudo apt install zfsutils-linux
sudo mkdir /var/lib/zfs
sudo truncate -s 32G /var/lib/zfs/lxd.img
sudo zpool create lxd /var/lib/zfs/lxd.img
sudo lxd init --auto --storage-backend zfs --storage-pool lxd
```

Above we allocated 32GB of space to a sparse file.

Notes:

 - If possible, put `/var/lib/zfs` on a fast storage device (e.g. SSD).
 - The installed ZFS utilities can be used to query the pool (e.g.
   `sudo zpool list -v lxd`).

## Creating a controller

The Juju controller for LXD (the 'localhost' cloud) can now be created. Below,
we call it 'lxd':

```bash
juju bootstrap localhost lxd
```

View the new controller machine like this:

```bash
juju machines -m controller
```

This example yields the following output:

```no-highlight
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.103.91.114  juju-b14348-0  xenial      Running
```

The controller's underlying container can be listed with the LXD client:

```bash
lxc list
```

Output:

```no-highlight
---------------+---------+----------------------+------+------------+-----------+
|     NAME      |  STATE  |         IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+----------------------+------+------------+-----------+
| juju-b14348-0 | RUNNING | 10.103.91.114 (eth0) |      | PERSISTENT | 0         |
+---------------+---------+----------------------+------+------------+-----------+
```

## LXD specific features

Here is a list of noteworthy LXD specific features and differences:

 - Constraints (`v.2.4.1`) are applied differently than they are with other
   cloud types.  Essentially, they are interpreted as maximums instead of
   minimums. See [Constraints and the LXD cloud][charms-constraints-lxd] for
   details.

 - LXD clustering is supported (`v.2.4.0`). See
   [Additional LXD resources][clouds-lxd-resources] for details.

## Additional LXD resources

[Additional LXD resources][clouds-lxd-resources] provides more LXD-specific
information.

## Next steps

A controller is created with two models - the 'controller' model, which should
be reserved for Juju's internal operations, and a model named 'default', which
can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[tut-lxd]: ./tut-lxd.md
[install]: ./reference-install.md
[controllers]: ./controllers.md
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
[models-add]: ./models-adding.md
[credentials]: ./credentials.md
[clouds-lxd-resources]: ./clouds-lxd-resources.md
[lxd-snap]: ./clouds-lxd-resources.md#using-the-lxd-snap
[ubuntu-lxd]: http://www.ubuntu.com/cloud/lxd
[charms-constraints-lxd]: ./charms-constraints.md#constraints-and-the-lxd-cloud
