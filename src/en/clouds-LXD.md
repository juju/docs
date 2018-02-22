Title: Juju LXD local provider

# Using LXD as a cloud

LXD provides a fast, powerful, self-contained and largely configuration-free
way to experiment with Juju. Using lightweight LXC containers as instances,
even a moderately powerful laptop can create useful models, or serve as
a development platform for your own charms.

## Prerequisites

Juju's support for LXD currently works only with Ubuntu 16.04 (Xenial).

Install LXD:

```bash
sudo apt install lxd
newgrp lxd
```

## Alternate backing file-system

LXD can optionally use an alternative file-system for containers. We recommend
using ZFS for the best experience. To use ZFS with LXD enter these commands:

```bash
sudo apt install zfsutils-linux
sudo mkdir /var/lib/zfs
sudo truncate -s 32G /var/lib/zfs/lxd.img
sudo zpool create lxd /var/lib/zfs/lxd.img
sudo lxd init --auto --storage-backend zfs --storage-pool lxd
```

Above we allocated 32GB of space to a sparse file. Consider using a fast block
device if available.

## Create a controller (bootstrap)

It is time to create the controller for LXD. Below, we call it 'lxd-xenial':

```bash
juju bootstrap lxd lxd-test
```

This will result in the controller being visible with the LXC client:

```bash
lxc list
```

```no-highlight
+---------------+---------+-----------------------+------+------------+-----------+
|     NAME      |  STATE  |         IPV4          | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+-----------------------+------+------------+-----------+
| juju-669cb0-0 | RUNNING | 10.154.173.181 (eth0) |      | PERSISTENT | 0         |
+---------------+---------+-----------------------+------+------------+-----------+
```

See more examples of [Creating a controller][controllers-creating].

## Additional LXD resources

See [Additional LXD resources][clouds-lxd-resources] for detailed LXD-specific
information:

 - LXD and images
 - Remote LXD user credentials
 - LXD logs
 - Useful LXD client commands 
 - Further LXD help and reading

## Next steps

A controller is created with two models - the 'controller' model which
should be reserved for Juju's operations, and a model named 'default'
for deploying user workloads.

 - [More information on models][models]
 - [Using Charms to deploy applications][charms]


<!-- LINKS -->

[models]: ./models.html
[charms]: ./charms.html
[controllers]: ./controllers.html
[controllers-creating]: ./controllers-creating.html
[lxd-upstream]: https://github.com/lxc/lxd/blob/master/doc/configuration.md
[logs]: ./troubleshooting-logs.html
[models-add]: ./models-adding.html
[credentials]: ./credentials.html
[clouds-lxd-resources]: ./clouds-lxd-resources.html
