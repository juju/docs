Title: Using LXD as a cloud

# Using LXD as a cloud

Choosing LXD as the backing cloud for Juju is an efficient way to experiment
with Juju. It is also very quick to set up. With lightweight containers acting
as Juju machines, even a moderately powerful laptop can create useful models,
or serve as a platform to develop your own charms.

## Software prerequisites

Both LXD and Juju will be needed on the host system.

LXD is installed by default on all stable Ubuntu releases with the exception of
Ubuntu 14.04 LTS. On all other releases it is installed as an APT package.
However, it is recommended to manage LXD via snaps as this is now the best
supported method for LXD. Doing so on Ubuntu 16.04 LTS (and greater) will
entail the removal of the APT package.

For instructions on installing Juju, see [Getting the latest Juju][install].
Then follow the instructions below for installing LXD, based on your chosen
Ubuntu release.

### Ubuntu 14.04 LTS

On Ubuntu 14.04 LTS (Trusty), ensure that `snapd` is installed prior to
installing `lxd`.

```bash
sudo apt install snapd
sudo snap install lxd
```

!!! Note:
    A reboot will be needed after having installed `snapd` on Trusty since a
    new kernel (4.4.0 series) will be installed as a dependency.

### Ubuntu 16.04 LTS and greater

As mentioned, if using Ubuntu 16.04 LTS (and greater) it is recommended that
you replace the LXD APT package with the LXD snap. Note that `snapd` should be
installed by default on these releases.

!!! Warning:
    Only replace the LXD APT package with the LXD snap if you are not currently
    using LXD. Using both simulatenously may be possible but is not supported.

To replace the APT package with the snap:

```bash
sudo apt purge lxd
sudo snap install lxd
```

## Alternate backing file-system

LXD can optionally use an alternative file-system for containers. ZFS is
recommended for the best experience:

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

Above we allocated 32GB of space to a sparse file. Consider using a fast block
device if available.

## Create a controller

The Juju controller for LXD (the 'localhost' cloud) can now be created. Below,
we call it 'lxd':

```bash
juju bootstrap localhost lxd
```

The controller's underlying container can be listed with the LXD client:

```bash
lxc list
```

Sample output:

```no-highlight
+---------------+---------+-----------------------+------+------------+-----------+
|     NAME      |  STATE  |         IPV4          | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+-----------------------+------+------------+-----------+
| juju-669cb0-0 | RUNNING | 10.154.173.181 (eth0) |      | PERSISTENT | 0         |
+---------------+---------+-----------------------+------+------------+-----------+
```

See more examples of [Creating a controller][controllers-creating].

## Additional LXD resources

[Additional LXD resources][clouds-lxd-resources] provides more LXD-specific
information:

 - LXD and images
 - Remote LXD user credentials
 - LXD logs
 - Useful LXD client commands 
 - Further LXD help and reading

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[install]: ./reference-install.html
[models]: ./models.html
[charms]: ./charms.html
[controllers]: ./controllers.html
[controllers-creating]: ./controllers-creating.html
[logs]: ./troubleshooting-logs.html
[models-add]: ./models-adding.html
[credentials]: ./credentials.html
[clouds-lxd-resources]: ./clouds-lxd-resources.html
