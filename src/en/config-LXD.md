Title: LXD local provider


# Overview

The LXD local provider is the most efficient and featureful way to use Juju
locally on Ubuntu and is a replacement for the traditional LXC local provider.
Although the latter is backwards compatible with modern Juju releases users are
encouraged to switch over as this may change at any time.

The LXD local provider enables multiple Juju-deployed services with a single
operating system. This easily makes available a number options: evaluation of
Juju; evaluation of the software being deployed, experimentation with various
service configurations; and charm development.

With LXD, the state server is not the localhost (as it was with the LXC local
provider) but just another LXC container. This allows you to regard your local
environment as a traditional Juju environment. For instance, you can test
Juju high-availability without the need for a cloud provider.

This document does provide enough information to get you running with generic
LXD (this document is ultimately about running LXD with Juju) but it does so
assuming you are settting up LXD for the first time.

See [linuxcontainers.org/lxd](https://linuxcontainers.org/lxd/) for more on LXD
itself.


# Prerequisites and installation of Juju and LXD

 - The LXD local provider will not work on Ubuntu 12.04 LTS and backporting to
   Ubuntu 14.04 LTS is incomplete.

 - Ubuntu 15.10 (Wily) or Ubuntu 16.04 LTS (Xenial) is needed.

 - The LXD stable PPA and the Juju devel PPA (may change) are needed.

 - Container migration (copying/moving) requires a modern version of the
   *criu* binary and a 4.4 Linux kernel (Xenial).

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

Images need to be available to LXD using either a local or remote store. For
Ubuntu, they must have the names (aliases) in the format `ubuntu-<codename>`
such as 'ubuntu-trusty' and 'ubuntu-xenial'.

Each Ubuntu image is approximately 120-155 MB in size.

Note that although there is a sync mechanism for images, the LXC host cache,
enabled by default, needs to be managed separately. See
[below](#ensuring-fresh-images) for refreshing the LXC host cache.

For any operation, images are specified by their alias or by their
*fingerprint*. Both are shown in image lists (shown later).


## Remote image store

Read this if you using a remote image store.

Image servers for LXD are becoming available and there is a public one at
[images.linuxcontainers.org](http://images.linuxcontainers.org). Using such a
server avoids the necessity of downloading and maintaining images locally.
Images on this particular server are refreshed regularly.

Add a remote image server (called 'remote-store') and list its images:

```bash
lxc remote add remote-store images.linuxcontainers.org
lxc image list remote-store:
```

**Note:** For all operations, the local server is assumed in the absence of the
remote server's name plus the addition of a colon (`remote-store:`).


## Local image store

Read this if you using a local image store.

Local images are located under `/var/lib/lxd/images`.

Import a 64bit Trusty image, tag it to be synced, and create the alias:

```bash
lxd-images import ubuntu trusty amd64 --sync --alias ubuntu-trusty
```

List all local images:

```bash
lxc image list
```

To sync, regularly run (via cron):


```bash
lxc-images sync
```


# LXD test

Although the objective here is to have Juju launch containers as it needs them,
as a test for your LXD installation, you should manually launch one now (here
called 'ubuntu-trusty-64-test'):

If using a remote store (here, image alias is 'ubuntu/trusty/amd64'):

```bash
lxc launch remote-store:ubuntu/trusty/amd64 ubuntu-trusty-64-test
```

If using a Local store:

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

lxc info ubuntu-test

lxc exec ubuntu-test /bin/bash

lxc file pull ubuntu-32/path/to/file .

lxc file push /path/to/file ubuntu-32/

lxc stop ubuntu-test

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


## Bootstrapping and destroying

The usage of LXC containers with LXD does **not** require root privileges.

**Note:** If you are running iptables (firewall) or even an iptables frontend
such as `ufw`, the LXD local provider might not work properly. Troubleshoot
accordingly or stop the firewall altogether.


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


## Caching of LXC images

Starting with Juju 1.22 and prior to Juju 2.0, the first time a host (local or
remote) needs a LXC image it will be downloaded from
http://cloud-images.ubuntu.com and cached on the state server (MongoDB). The
same image will be copied to the host's filesystem (/var/cache/lxc) if LXC host
caching is enabled (the default).

This meant that the external retrieval of images is done once per environment,
and not once per machine which is the normal behaviour for LXC.

With the advent of Juju 2.0 and LXD there is no more "Juju cache". Images are
now stored either locally or on a remote server and used for the initial
container. LXC host caching continues to be available for subsequent usages.

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
