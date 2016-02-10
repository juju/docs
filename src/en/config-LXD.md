Title: Juju LXD local provider  
TODO: Confirm iptables troubleshooting rationale; add details  


# Overview

The LXD local provider is the most efficient and featureful way to use Juju
locally on Ubuntu. It leverages [LXD](https://linuxcontainers.org/lxd/) to
enable multiple Juju-deployed services within a single operating system.
Immediate uses include:

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
LXD itself (this document is ultimately about running LXD with Juju) it does
so assuming you are setting up LXD for the first time.

!!! Note: If you are running iptables (firewall) or even an iptables frontend
such as `ufw`, the LXD local provider might not work properly. Troubleshoot
accordingly or stop the firewall altogether.


# Prerequisites and installation of Juju and LXD

 - The LXD local provider will not work on Ubuntu 12.04 LTS (Precise) and
   backporting to Ubuntu 14.04 LTS (Trusty) is incomplete.

 - Ubuntu 15.10 (Wily) or Ubuntu 16.04 LTS (Xenial) is needed.

 - The LXD stable PPA is needed on Ubuntu 15.10 (Wily).

 - The Juju devel PPA (may change) is needed.

 - Container migration (copying/moving) requires a modern version of the
   *criu* binary and a 4.4 Linux kernel (Xenial).

Proceed to install the software.

On Wily, add this:

```bash
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
```

Proceed with the rest:

```bash
sudo apt-add-repository -y ppa:juju/devel
sudo apt-get update
sudo apt-get install juju-local lxd
```

Now either log out and log in again to get your group membership refreshed, or use:

```bash
newgrp lxd
```


# Images

With standalone LXD, images are available via either a local or network-based
store. These can be called a local image store *remote*, a **local remote**, or a
networked image store remote, a **non-local remote**. Juju, however, only
supports local remotes at this time. Images stored on them must also have the
names (aliases) in the format `ubuntu-<codename>` such as 'ubuntu-trusty' and
'ubuntu-xenial'.

The first time an image is needed the store will supply it and any subsequent
requests will be satisfied by the LXD cache. In this way, a store is solicited
once per environment for any given image, and not once per machine (LXC host)
which is the normal behaviour for LXC. There is a also an image sync mechanism.

For any image-related command, an image is specified by its alias or by its
*fingerprint*. Both are shown in image lists (explained later). A cached
image's filename is its *full fingerprint*. The fingerprint shown in an image
list is its *partial fingerprint* (the beginning portion of the cached image's
filename). Either type of fingerprint can be used to refer to images.


## Import an image into the local remote

Import a 64bit Trusty image, tag it to be synced, and create the alias:

```bash
lxd-images import ubuntu trusty amd64 --sync --alias ubuntu-trusty
```

This sort of invocation will pull official Ubuntu cloud images from
http://cloud-images.ubuntu.com.

Once any given image is imported it is cached at
`/var/lib/lxd/images` and shows up with `lxc image list`:

![lxc image list after importing](./media/image_list-imported_image-reduced70.png)

To sync, run:

```bash
lxd-images sync
```

By default, the above is managed via cron (`/etc/cron.hourly/lxd`).


# LXD test

Although the objective here is to have Juju launch containers as it needs them,
as a test for your LXD installation, you should manually launch one now (here
called 'ubuntu-trusty-64-test').

We refer to the alias created during importation.

```bash
lxc launch ubuntu-trusty ubuntu-trusty-64-test
```

List all containers and then remove the test container:

```bash
lxc list
lxc delete ubuntu-trusty-64-test
```

!!! Note: Do not confuse command `lxc` with the binary shipped with traditional
LXC. All the latter's binaries are of the form `lxc-<subcommand>`. The `lxc`
binary actually comes from the `lxd-client` package.


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

LXD itself logs to `/var/log/lxd/lxd.log` and Juju machines created via the
LXD local provider log to `/var/log/lxd/juju-{uuid}-machine-{#}`. However,
the standard way to view logs is with the `juju debug-log` command. See
[Viewing logs](./troubleshooting-logs.html) for more details.


# Other useful commands

There are many commands available. Some common ones not yet covered
are given below.

<style> table td{text-align:left;}</style>

| client commands                               | meaning                            |
|----------------------------------------------|-----------------------------------|
`lxc remote list`				| list remotes
`lxc info`					| displays status of localhost
`lxc info <container>`				| displays status of container
`lxc config show <container>`			| displays config of container
`lxc image info <alias or fingerprint>`		| displays status of image
`lxc exec <container> <executable>`		| run prgram on container
`lxc exec <container> /bin/bash`		| spawn shell on container
`lxc file pull <container></path/to/file> .` 	| copy file from container
`lxc file push </path/to/file> <container>/` 	| copy file to container
`lxc stop <container>`				| stop container
`lxc image alias delete <alias>`		| delete image alias
`lxc image alias create <alias> <fingerprint>`	| create image alias

See upstream documentation for more on the
[lxc command line tool](https://github.com/lxc/lxd/blob/master/specs/command-line-user-experience.md)
and how to
[configure the lxd daemon and containers](https://github.com/lxc/lxd/blob/master/specs/configuration.md).
