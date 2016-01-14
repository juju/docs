Title: LXD local provider


# Overview

The LXD local provider is the most efficient and featureful way to use Juju
locally on Ubuntu. It enables multiple Juju-deployed services within a single
operating system, making available a number options:

 - Evaluation of Juju
 - Evaluation of deployed software
 - Experimentation with various service configurations
 - Charm development

It is a replacement for the traditional LXC local provider and has some
notable differences:

 - The state server is no longeer localhost but just another LXC container.
   The benefits of keeping installed software/files isolated in a container far
   outweigh the extra time needed to create this container.
 - Due to the above, superuser privileges (sudo) are no longer required.
 - There is no more "Juju cache" for images. LXD now has its own cache
   (`/var/lib/lxd/images`) which is separate from the traditional LXC cache
   (`/var/cache/lxc`).

Although this document does provide enough information to get you running with
generic LXD (this document is ultimately about running LXD with Juju) it does
so assuming you are setting up LXD for the first time.

**Note:** If you are running iptables (firewall) or even an iptables frontend
such as `ufw`, the LXD local provider might not work properly. Troubleshoot
accordingly or stop the firewall altogether.

See [linuxcontainers.org/lxd](https://linuxcontainers.org/lxd/) for more on LXD
itself.


# Prerequisites and installation of Juju and LXD

 - The LXD local provider will not work on Ubuntu 12.04 LTS and backporting to
   Ubuntu 14.04 LTS is incomplete.

 - Ubuntu 15.10 (Wily) or Ubuntu 16.04 LTS (Xenial) is needed.

 - The LXD stable PPA and the Juju devel PPA (may change) are needed.

 - Container migration (copying/moving) requires a modern version of the
   *criu* binary and a 4.4 Linux kernel (Xenial).

Proceed to install the software:

```bash
sudo apt-add-repository -y ppa:juju/devel
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get update
sudo apt-get install juju-local lxd
```

Now either log out and log in again to get your group membership refreshed, or use:

```bash
newgrp lxd
```


# Images

Images need to be made available to LXD via either a local or network-based
store. These can be called a local remote image store - **local remote** or a
networked remote image store - **networked remote**. For Juju, they must have
the names (aliases) in the format `ubuntu-<codename>` such as 'ubuntu-trusty'
and 'ubuntu-xenial'.

The first time an image is needed the image store will supply it and any
subsequent requests will be satisfied by the LXD cache. In this way, a store is
sollicited once per environment for any given image, and not once per machine
(LXC host) which is the normal behaviour for LXC.

NEEDS REDOING:
Note that although there is a sync mechanism for images, the LXC host cache
needs to be managed separately. See [below](#ensuring-fresh-images) for
refreshing the LXC host cache.

For any image-related command, an image is specified by its alias or by its
*fingerprint*. Both are shown in image lists (explained later). The beginning
of a cached image's filename is comprised of its fingerprint.


## Networked image store remote

Read this if you using a networked image store remote.

Public image servers are becoming available and there is one at
[images.linuxcontainers.org](http://images.linuxcontainers.org). Using such a
server avoids the necessity of downloading and maintaining images locally.
Images on the above particular server are refreshed regularly and the images
themselves are paired down LXC images (not standard cloud images). Suchlike
features may be different on another server.

Add a remote image server (called 'remote-store') and list its images:

```bash
lxc remote add remote-store images.linuxcontainers.org
lxc image list remote-store:
```

For all operations, the local server is assumed in the absence of the remote
server's name plus the addition of a colon (`remote-store:`).

**Note:** Do not confuse command `lxc` with the binary shipped with traditional
LXC. All the latter's binaries are of the form `lxc-<subcommand>`. The `lxc`
binary actually comes from the `lxd-client` package.

Once any given image is used to create a container the image is cached at
`/var/lib/lxd/images` and shows up with `lxc image list` (no longer the
networked remote):

IMAGE


## Local image store remote

Read this if you using a local image store remote.

Import a 64bit Trusty image, tag it to be synced, and create the alias:

```bash
lxd-images import ubuntu trusty amd64 --sync --alias ubuntu-trusty
```

To sync, run:

```bash
lxd-images sync
```

By default the above is managed via cron with `/etc/default/lxd` and
`/var/cron.d/hourly/lxd` (see
[GH #1347020](https://github.com/lxc/lxc/issues/764)).

Once any given image is imported it is cached at
`/var/lib/lxd/images` and shows up with `lxc image list`:

IMAGE

# LXD test

Although the objective here is to have Juju launch containers as it needs them,
as a test for your LXD installation, you should manually launch one now (here
called 'ubuntu-trusty-64-test'):


## If using a networked remote

Here, the image alias on the networked server is 'ubuntu/trusty/amd64',

```bash
lxc launch remote-store:ubuntu/trusty/amd64 ubuntu-trusty-64-test
```

There will be no alias for the cached image of the networked remote. Create the
required one (`ubuntu-<codename>`) (assuming a partial fingerprint of
`53b79865a0b4`):

```bash
lxc image alias create ubuntu-trusty 53b79865a0b4
```


## If using a local remote

Here, the image alias we made during importation is 'ubuntu-trusty':

```bash
lxc launch ubuntu-trusty ubuntu-trusty-64-test
```

List all containers and then remove the test container:

```bash
lxc list
lxc delete ubuntu-trusty-64-test
```


# Configure and bootstrap

If this is a new Juju install then you do not yet have a
`~/.juju/environments.yaml` file. Create one with

```bash
juju generate-config
```

If it does exist (but it was created with an older version of Juju), first move
it out of the way (back it up) and *then* generate a new one. Alternatively,
you can output a generic file to screen (STDOUT) and paste the lxd parts into
your existing file:

```bash
juju generate-config --show
```

The file should now contain a section for the LXD local provider. The minimum
active lines for this section are:

```yaml
   lxd:
        type: lxd
```

For the alpha2 version of Juju (will change), you must specify the
'--upload-tools' flag when bootstrapping an environment that will use Trusty
images. This is because, currently, most of Juju's charms are for Trusty, and
the agent-tools for Trusty don't yet have LXD support compiled in.

Switch to the LXD environment and bootstrap it:

```bash
juju switch lxd
juju bootstrap --upload-tools
```


# Logs

Looks like we log to `/var/log/lxd/juju-{uuid}-machine-#/ ?
Is `/var/log/lxd/lxd.log` important? 

need to be root to poke around in here? normal?


# Other useful LXD commands

lxc remote list

lxc info ubuntu-container

lxc exec ubuntu-container /bin/bash

lxc file pull ubuntu-container/path/to/file .

lxc file push /path/to/file ubuntu-container/

lxc stop ubuntu-container

===========

Using Juju with this configuration, the storage files and the database will be
located in the directory specified by the environment variable `$JUJU_HOME`,
which defaults to `~/.juju/`. By uncommenting and setting `root-dir` this
location can be changed as well as the ports of the storage and the shared
storage. This may be useful if you want to run multiple local providers
simultaneously or to deal with possible conflicts with other programs on your
system.

Ensure all local providers are using different ports. The default port numbers
for `api-port`, `state-port`, and `storage-port` are 17071, 37017, and 8040
respectively. Also, the name of each provider is arbitrary. For instance:


```yaml
# another local environment
another-local:
    type: lxd
    api-port: 17072
    state-port: 37018
    storage-port: 8041
```

**Note:** If your home directory is encrypted you cannot point `$JUJU_HOME` or
`root-dir` to a location within it. Use locations **outside** of it.


## Fast LXC creation

The LXD local provider can use lxc-clone to create the containers used as machines.
This feature is controlled by the `lxc-clone` option in environments.yaml. The
default is "true" for Trusty and above, and "false" for earlier Ubuntu releases.

You can try to use lxc-clone on earlier releases, and it may well work, but it
is not a supported feature. You can enable lxc-clone in environments.yaml like
this:

```yaml
local:
    type: lxd
    lxc-clone: true
```

The local provider is btrfs-aware. If your LXC directory is on a btrfs
filesystem, the clones use btrfs snapshots and are much faster to create and
take up much less space. There is also support for using aufs as a
backing-store for the LXC clones, but there are some situations where aufs
doesn’t entirely behave as intuitively as one might expect, so this must be
turned on explicitly in `environments.yaml`.

```yaml
local:
    type: lxd
    lxc-clone-aufs: true
```

When using clone, the first machine to be created will create a "template"
machine that is used as the basis for the clones. This will be called
`juju-<series>-template`, so for a precise image, the name is
`juju-precise-template`. Do not modify or start this image while a local
provider environment is running because you cannot clone a running LXC machine.

Newly provisioned machines on the Local Provider have package upgrades disabled
by default. This, again, is to accelerate provisioning. To allow automatic
software upgrades to occur you will need to configure accordingly. See
[General config options](./config-general.html#local-provider).


### Commands

There is a cornucopia of commands available. Examples of the common ones are show below.

The 'lxc image list' command lists available images  and delete cached LXC images stored in the
Juju environment. The 'list' and 'delete' subcommands support '--arch' and
'--series' options to filter the result.

Examples:

To see all available images:

```bash

```

To see just the amd64 trusty image:

```bash

```

To delete the amd64 trusty image:

```bash

```

See 'juju cached-images list --help' and 'juju cached-images delete --help' for
more details.

### Ensuring fresh images

In addition to tagging local images with `sync`, to ensure stale images are not being used
you need to also flush the LXC host cache on a regular basis:

```bash
sudo rm -r /var/cache/lxc/cloud-trusty
```

Do not forget to also remove the source clone image (template) if lxc-clone is
enabled (the default):

```bash
sudo lxc-destroy -n juju-trusty-lxc-template
```


## LXC containers within KVM guests

You can also use Juju to create KVM guests within which are placed LXC
containers. See [Configuring for KVM](./config-KVM.html#lxc-containers-within-a-kvm-guest).
