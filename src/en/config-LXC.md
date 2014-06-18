# Configuring for LXC

## Prerequisites

The LXC local provider enables you to run Juju on a single system like your
local computer or a single server. This way you can simply evaluate the software
or service configurations, develop your own charms or run a single server system.

If you're not already using the stable release PPA you can make sure you've
added it:

    sudo apt-add-repository ppa:juju/stable
    sudo apt-get update

Then you can install the local provider, the commands depend on the Juju version
you are using:

### For Ubuntu versions newer than 12.04:

    sudo apt-get install juju-local juju-quickstart

### For 12.04 LTS users only:

Due to needing newer versions of LXC the local provider does require a newer
kernel than the released version of 12.04. Therefore we install Linux 3.8 from
the [LTS Hardware Enablement
Stack](https://wiki.ubuntu.com/Kernel/LTSEnablementStack):

    sudo apt-get install juju-local linux-image-generic-lts-raring linux-headers-generic-lts-raring

You will need to reboot into the new kernel in order to use Juju with the local
provider.

If you're not running Ubuntu please consult your operating system distribution's
documentation for instructions on installing the LXC userspace tools and the
MongoDB server. Juju requires a MongoDB server built with SSL support.

## Configuration

You should start by generating a generic configuration file for Juju and then
switching to the local provider by using the command:

    juju quickstart

Then select "automatically create and bootstrap a local environment" and hit
enter.

**Note:** If you have an existing configuration, you can use
`juju generate-config --show` to output the new config file, then copy and
paste relevant areas in a text editor etc.

The generic configuration sections generated for the local provider will look
something like this, though Juju will generate this automatically you usually
don't need to edit it:

    ## https://juju.ubuntu.com/get-started/local/
    local:
        type: local
        admin-secret: 772b9471131c6b5883475e3908156d32
        # Override the directory that is used for the storage files and database.
        # The default location is $JUJU_HOME.
        # $JUJU_HOME defaults to ~/.juju
        # root-dir: ~/.juju/local
        # Override the storage port if you have multiple local providers, or if the
        # default port is used by another program.
        # storage-port: 8040
        # Override the shared storage port if you have multiple local providers,
        # or if the default port is used by another program.
        # shared-storage-port: 8041

Running Juju with this configuration the storage files and the database will be
located in the directory specified by the environment variable `$JUJU_HOME`,
which defaults to `~/.juju/`. By uncommenting and setting `root-dir` this
location can be changed as well as the ports of the storage and the shared
storage. This may be useful in the case of multiple parallel running local
providers or conflicts with other programs on your system.

**Note:** If you are using encrypted home directories you have to set
`$JUJU_HOME` or `root-dir` to point to a location **outside** your home
directory.

## Bootstrapping and Destroying

The usage of LXC Linux Containers requires **root** privileges for some steps.
Juju will prompt for your password if needed. Juju cannot be run under sudo
because it needs to manage permission as the real user.

**Note:** If you are running a firewall such as **ufw**, it may interfere with
the correct operation of Juju using LXC containers and might need to be halted.

If you have used the local provider in the past when it required `sudo`, you may
need to manually clean up some files that are still owned by root. If your local
environment is named "local" then there may be a local.jenv owned by root in the
JUJU_HOME directory (~/.juju). After the local environment is destroyed, you can
remove the file like this:

    sudo rm ~/.juju/environments/local.jenv

## Fast LXC creation

The local provider can use lxc-clone to create the containers used as machines.
This feature is controlled by the `lxc-clone` option in environments.yaml. The
default is "true" for Trusty and above, and "false" for earlier Ubuntu releases.

You can try to use lxc-clone on earlier releases, but it is not a supported. It
may well work. You can enable lxc-clone in environments.yaml thusly:

    local:
        type: local
        lxc-clone: true

The local provider is btrfs-aware. If your LXC directory is on a btrfs
filesystem, the clones use snapshots and are much faster to create and take up
much less space. There is also support for using aufs as a backing-store for the
LXC clones, but there are some situations where aufs doesn’t entirely behave as
intuitively as one might expect, so this must be turned on explicitly in
`environments.yaml`.

    local:
        type: local
        lxc-clone-aufs: true

When using clone, the first machine to be created will create a "template"
machine that is used as the basis for the clones. This will be called
`juju-<series>-template`, so for a precise image, the name is
`juju-precise-template`. Do not modify or start this image while a local
provider environment is running because you cannot clone a running lxc machine.
