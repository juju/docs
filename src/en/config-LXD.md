Title: Juju LXD local provider  
TODO: 


# Configuring for LXD

Here we provide an overview for the creation of a controller for LXD
(see [Controllers](./controllers.html)). If your objective is instead
to create a LXD model please see [Defining a model](./models-creating.html).

Unlike other providers, with LXD, Juju does not need to be supplied with any
information regarding configuration or credentials. This makes it extremely
easy to start using LXD with Juju.

!!! Note: Do not confuse command `lxc` with the binary shipped with traditional
LXC. All the latter's binaries are of the form `lxc-<subcommand>`. The `lxc`
binary actually comes from the `lxd-client` package.


## Prerequisites

LXD currently works only on Ubuntu 15.10 (Wily) and Ubuntu 16.04 (Xenial). For
15.10, perform these additional steps:

```bash
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get update
sudo apt-get install lxd
newgrp lxd
```

LXD is pre-installed on 16.04 cloud images. Users of regular Xenial ISOs will
need to install it:

```bash
sudo apt-get install lxd
newgrp lxd
```


## Alternate backing file-system

LXD can optionally use an alternative file-system for containers. We recommend
using ZFS for the best experience. To use ZFS with LXD enter these commands:

```bash
sudo apt-get install zfsutils-linux
sudo mkdir /var/lib/zfs
sudo truncate -s 32G /var/lib/zfs/lxd.img
sudo zpool create lxd /var/lib/zfs/lxd.img
sudo lxd init --auto --storage-backend zfs --storage-pool lxd
```

Above we allocated 32GB of space to a sparse file. Consider using a fast block
device if available.


## Create controller

It is time to create the controller for LXD. Below, we call it 'lxd-xenial':

```bash
juju bootstrap --config default-series=xenial lxd-xenial lxd
```

!!! Note: The 'default-series' option was used because, at time of writing,
Xenial was not officially released. LXD defaults to the most recent LTS
release.

This will result in the controller being visible with the LXC client:

```bash
lxc list
```

![bootstrap machine 0 in LXC CLI](./media/config-lxd_cli-machine_0.png)

See more examples of [Creating a controller](./controllers-creating.html).


## Next steps

Typically, workload services are deployed on additional models (i.e. other
than the initial 'admin' model). There is a 'default' model created when
a controller is created but we recommend creatiing specially-named ones
instead. See [Creating a model](./models-creating.html).


## LXD and images

LXD is image based: all LXD containers come from images and any LXD daemon
instance (also called a "remote") can serve images. When LXD is installed a
locally-running remote is provided (Unix domain socket) and the client is
configured to talk to it (named 'local'). The client is also configured to talk
to several other, non-local, ones (named 'ubuntu', 'ubuntu-daily', and
'images').

An image is identified by its fingerprint (SHA-256 hash), and can be tagged
with multiple aliases. Juju looks for images with aliases in the format
ubuntu-&lt;codename&gt;, for instance 'ubuntu-trusty' or 'ubuntu-xenial'.

For any image-related command, an image is specified by its alias or by its
fingerprint. Both are shown in image lists. An image's filename is its *full
fingerprint* while an image list displays its *partial fingerprint*. Either
type of fingerprint can be used to refer to images.

Juju pulls official cloud images from the 'ubuntu' remote
(http://cloud-images.ubuntu.com) and creates the necessary alias. Any
subsequent requests will be satisfied by the LXD cache (`/var/lib/lxd/images`).
Cached images can be seen with `lxc image list`:

![lxc image list after importing](./media/image_list-imported_image-reduced70.png)

Image cache expiration and image synchronization mechanisms are built-in.


## Logs

LXD itself logs to `/var/log/lxd/lxd.log` and Juju machines created via the
LXD local provider log to `/var/log/lxd/juju-{uuid}-machine-{#}`. However,
the standard way to view logs is with the `juju debug-log` command. See
[Viewing logs](./troubleshooting-logs.html) for more details.

<!---
Including this table is confusing and not really appropriate for Juju docs.
Still, it's such a nice table that I could not delete it. (pmatulis)

## Useful client commands

There are many client commands available. Some common ones, including those covered
above, are given below.

<style> table td{text-align:left;}</style>

| client commands                               | meaning                            |
|-----------------------------------------------|------------------------------------|
`lxc launch`					| creates an LXD container
`lxc list`	                             	| lists all LXD containers
`lxc delete`					| deletes an LXD container
`lxc remote list`				| lists remotes
`lxc info`					| displays status of localhost
`lxc info <container>`				| displays status of container
`lxc config show <container>`			| displays config of container
`lxc image info <alias or fingerprint>`		| displays status of image
`lxc exec <container> <executable>`		| runs program on container
`lxc exec <container> /bin/bash`		| spawns shell on container
`lxc file pull <container></path/to/file> .`	| copies file from container
`lxc file push </path/to/file> <container>/`  	| copies file to container
`lxc stop <container>`				| stops container
`lxc image alias delete <alias>`		| deletes image alias
`lxc image alias create <alias> <fingerprint>`	| creates image alias
-->


## Additional notes

Although not Juju-related, see `lxc --help` for more on LXD client usage and
`lxd --help` for assistance with the daemon. See upstream documentation for
how to
[configure the lxd daemon and containers](https://github.com/lxc/lxd/blob/master/doc/configuration.md)
.

See [General configuration options](https://jujucharms.com/docs/stable/config-general)
for additional and advanced customization of your environment.
