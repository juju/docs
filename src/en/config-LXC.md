Title: Configuring for LXC


# Configuring for LXC


## Prerequisites

The LXC local provider enables multiple Juju-deployed services with a single
operating system. This easily makes available a number options: evaluation of
Juju; evaluation of the software being deployed, experimentation with various
service configurations; and charm development.

Begin by adding the Juju stable release PPA:

```bash
sudo apt-add-repository ppa:juju/stable
sudo apt-get update
```

You can then install the local provider, the commands depend on the Juju version
you are using:

### For Ubuntu versions newer than 12.04:

```bash
sudo apt-get install juju-local
```

### For 12.04 LTS users only:

Because the provider requires a more recent version of LXC, and thus the kernel,
that was originally shipped with 12.04, we will install kernel 3.13 from the
[LTS Hardware Enablement Stack](https://wiki.ubuntu.com/Kernel/LTSEnablementStack):

```bash
sudo apt-get install juju-local linux-image-generic-lts-trusty linux-headers-generic-lts-trusty
```

You will need to reboot into the new kernel in order to use Juju with the local
provider.

If you're not running Ubuntu please consult your operating system distribution's
documentation for instructions on installing the LXC userspace tools and the
MongoDB server. Juju requires a MongoDB server built with SSL support.


## Configuration

Start by generating a generic configuration file for Juju and then switching to
the local provider:

```bash
juju generate-config
juju switch local
```

This will generate a file, `environments.yaml` (if it doesn't already exist),
which will live, on Ubuntu, in your `~/.juju/` directory (and will create the
directory if it doesn't already exist).

**Note:** If you have an existing configuration, you can use
`juju generate-config --show` to output the new config file, then copy and
paste relevant areas in a text editor etc.

The generic configuration sections generated for the local provider will look
something like this and will normally work out of the box (no need to edit):

```yaml
## https://jujucharms.com/get-started/local/
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
```

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
    type: local
    api-port: 17072
    state-port: 37018
    storage-port: 8041
```

**Note:** If your home directory is encrypted you cannot point `$JUJU_HOME` or
`root-dir` to a location within it. Use locations **outside** of it.


## Bootstrapping and Destroying

The usage of LXC containers requires **root** privileges for some steps and
Juju will prompt for your password if needed. Juju cannot be run under sudo
because it needs to manage permission as the real user.

**Note:** If you are running iptables (firewall) or even an iptables frontend
such as `ufw`, the LXC local provider might not work properly. Troubleshoot
accordingly or stop the firewall altogether.

If you have used the local provider in the past when it required `sudo`, you may
need to manually clean up some files that are still owned by root. If your local
environment is named "local" then there may be a local.jenv owned by root in the
JUJU_HOME directory (~/.juju). After the local environment is destroyed, you can
remove the file like this:

```bash
sudo rm ~/.juju/environments/local.jenv
```


## Fast LXC creation

The local provider can use lxc-clone to create the containers used as machines.
This feature is controlled by the `lxc-clone` option in environments.yaml. The
default is "true" for Trusty and above, and "false" for earlier Ubuntu releases.

You can try to use lxc-clone on earlier releases, and it may well work, but it
is not a supported feature. You can enable lxc-clone in environments.yaml like
this:

```yaml
local:
    type: local
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
    type: local
    lxc-clone-aufs: true
```

When using clone, the first machine to be created will create a "template"
machine that is used as the basis for the clones. This will be called
`juju-<series>-template`, so for a precise image, the name is
`juju-precise-template`. Do not modify or start this image while a local
provider environment is running because you cannot clone a running lxc machine.


## Juju caching for LXC images

Starting with Juju 1.22, the first time a host (local or remote) needs a LXC
image it will be downloaded from http://cloud-images.ubuntu.com and cached on
the state server (MongoDB). The same image will be copied to the host's
filesystem (/var/cache/lxc) if LXC host caching is enabled (the default).

This means that the external retrieval of images is done once per environment,
and not once per machine which is the normal behaviour for LXC.

### Use of cached images

Once the Juju LXC cache, and optionally the LXC host cache, is populated:

- Juju will supply its cached image to a new (non-local) machine that needs it
  for its own containers.
- When Juju creates a (local) container, that container will use the LXC host
  cached image (if enabled). Otherwise it will use the Juju cached image.

### Notes on Juju image caching

**Specific to the Local Provider**  

- It is independent of image cloning ('lxc-clone'), which is enabled by
  default.
- Future development work will allow Juju to automatically download new images
  when they become available.

**General**  

- It applies to all provider types. 
- It is only available to hosts installed with 1.22 (or greater); not upgraded
  to that level.

### Commands

The 'cached-images' command can list and delete cached LXC images stored in the
Juju environment. The 'list' and 'delete' subcommands support '--arch' and
'--series' options to filter the result.

Examples:

To see all cached images:

```bash
juju cached-images list
```

To see just the amd64 trusty image:

```bash
juju cached-images list --series trusty --arch amd64
```

To delete the amd64 trusty image:

```bash
juju cached-images delete --kind lxc --series trusty --arch amd64
```

See 'juju cached-images list --help' and 'juju cached-images delete --help' for
more details.

### Issues

Juju cached LXC images do not return to the cache once deleted (due to host
caching). See
[LP bug #1483987](https://bugs.launchpad.net/juju-core/+bug/1483987).

### Ensuring a fresh cache

Due to the interaction of both the Juju cache and the LXC host cache, in
addition to the above issue, to ensure stale images are not being used it is
recommended to simply flush both caches together and on a regular basis:

For the Juju cache, as shown previously:

```bash
juju cached-images delete --kind lxc --series trusty --arch amd64
```

For the LXC host cache:

```bash
sudo rm -r /var/cache/lxc/cloud-trusty
```

Do not forget to also remove the source clone image (template) if lxc-clone is
enabled (the default):

```bash
sudo lxc-destroy -n juju-trusty-lxc-template
```


## LXC Containers within KVM guests

You can also use Juju to create KVM guests within which are placed LXC
containers. See [Configuring for KVM](./config-KVM.html#lxc-containers-within-a-kvm-guest).
