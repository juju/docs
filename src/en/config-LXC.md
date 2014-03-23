# Configuring for LXC

## Prerequisites

The LXC local provider enables you to run Juju on a single system like your
local computer or a single server. This way you can simply evaluate the software
or service configurations, develop your own charms or run a single server
system.

If you're not already using the stable release PPA you can make sure you've
added it:

    sudo apt-add-repository ppa:juju/stable
    sudo apt-get update

Then you can install the local provider, the commands depend on the Juju version
you are using:

### For Ubuntu versions newer than 12.04:

    sudo apt-get install juju-local

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

    juju init
    juju switch local

This will generate a file, `environments.yaml` (if it doesn't already exist),
which will live in your `~/.juju/` directory (and will create the directory if
it doesn't already exist).

!!__Note:__ If you have an existing configuration, you can use `juju generate-
config --show` to output the new config file, then copy and paste relevant areas
in a text editor etc.

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

!!__Note: __If you are using encrypted home directories you have to set
`$JUJU_HOME` or `root-dir` to point to a location __outside__ your home
directory.

## Bootstrapping and Destroying

The usage of LXC Linux Containers enforces that bootstrapping and destroying of
an environment are done as __root__. All other operations can be executed as
non-root. E.g.

    sudo juju bootstrap
    juju deploy mysql

Once you're ready to tear down, issue the destroy environment command:

    sudo juju destroy-environment

!!__Note:__ If you are running a firewall such as __ufw__, it may interfere with
the correct operation of Juju using LXC containers and might need to be halted.

## Caveats

There are several special circumstances tied to the local provider, given it's
development focused nature. These are outlined below.

### juju debug-log

There is currently a [bug](https://launchpad.net/bugs/1202682) which prevents
`juju debug-log` from working as expected. However, the logs for juju are still
available for review outside of `juju debug-log`. First, find out what the name
of your environment is by running `juju switch`. If you're using the default
`environments.yaml` you'll find this be `local`. All log files for the local
provider are stored in `~/.juju/<environment>/log`, as such you can duplicate
the functionality of `juju debug-log` using the following (assuming your current
environment is "local"):

    tail -f ~/.juju/local/log/unit-*.log

### juju ssh

While `juju ssh` does work if you supply it a unit (eg: `mysql/0`) the command
does not work with machine numbers at this time (`juju ssh 1`). To access a unit
via ssh make sure to use its corresponding unit name not the machine number.
