Title: Using storage with Juju charms
TODO: LXC/local caveat needs editing or removing
      Storage commands need more examples/usage

# Using Juju Storage

Many applications require access to a storage resource of some form. Juju charms
can declare what storage requirements they have, and these can be allocated when
the charm is deployed. Charms may declare several types of storage requirement
(e.g. for persistent storage and an additional cache) so that resources can be
allocated at a more granular level.

Juju has the [`juju storage`](./commands.html#storage) command and
subcommands to create and manage storage resources. All commands and
subcommands accept the “--help” flag for usage and help information.

```bash
juju storage --help
juju add-storage
juju show-storage
juju create-storage-pool
juju storage-pools
```

## Deploying a charm with storage requirements

For this document, we will use a charm which has been modified to support
storage:
[https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk](https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk).

### Preparing storage

By default, charms with storage requirements will allocate those resources on
the root filesystem of the unit where they are deployed. To make use of
additional storage resources, Juju needs to know what they are. Some providers
(e.g. EC2) support generic default storage pools (see the documentation on
[provider support](#provider-support)), but in the case of no default support or
a desire to be more specific, use the `juju storage pool create` subcommand to
create storage.

```bash
juju create-storage-pool loopy loop size=100M
juju create-storage-pool rooty rootfs size=100M
juju create-storage-pool tempy tmpfs size=100M
```
```no-highlight
juju storage-pools
loopy:
  provider: loop
  attrs:
    size: 100M
rooty:
  provider: rootfs
  attrs:
    size: 100M
tempy:
  provider: tmpfs
  attrs:
    size: 100M
```

#### Placement

If the storage provider supports dynamically adding storage to a machine, then 
an application/unit deployed with storage may be placed on an existing machine.
Not all providers support dynamic storage; for example, MAAS provides an
interface to physical hardware.

### Provider support

All environment providers support the following storage providers:

- [loop](https://en.wikipedia.org/wiki/Loop_device)

    block-type, creates a file in the agent data-dir and attaches a loop device
    to it. See the
    [Known limitations](#known-limitations) section
    below for a comment on using the loop storage with the local/LXC provider.

- [rootfs](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)

    filesystem-type, creates a sub-directory in the agent's data-dir for the
    unit/charm to use.

- [tmpfs](https://en.wikipedia.org/wiki/Tmpfs)

    filesystem-type, creates a temporary file storage facility that appears as
    a mounted file system but is stored in volatile memory.

Additionally, native storage providers exist for the several major cloud
providers, described below.

#### EC2/EBS (ebs)

The EC2/EBS provider currently supports the following pool configuration
attributes:

- volume-type

    specifies the EBS volume type to create. You can use either the EBS volume
    type names, or synonyms defined by Juju (in parentheses): gp2 (ssd), io1
    (provisioned-iops), standard (magnetic). By default, magnetic/standard
    volumes will be created. An 'ebs-ssd' pool is created in all EC2
    environments, which defaults the volume type to ssd/gp2 instead.

- iops

    the number of IOPS for provisioned-iops volume types. There are
    restrictions on minimum and maximum IOPS, as a ratio of the size of
    volumes; see [Provisioned IOPS (SSD) Volumes](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html#EBSVolumeTypes_piops)
    for more information.

- encrypted

    true|false, indicating whether or not to encrypt volumes created by the pool.

For information regarding EBS volume types, see 
[the EBS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html).

#### OpenStack/Cinder (cinder)

The OpenStack/Cinder provider does not currently have any specific 
configuration options.

OpenStack defaults to using Cinder for additional specified storage,
so it is possible to use cinder storage like this:

```bash
juju deploy cs:~axwalk/postgresql --storage data=10G
```

which will create a 10G Cinder volume. Or if you wish to be more specific:

```bash
juju deploy cs:~axwalk/postgresql --storage data=cinder,10G
```

will achieve the same result.

#### MAAS (maas)

MAAS 1.8+ contains support for discovering information about machines' disks,
and an API for acquiring nodes with specified disk parameters. Juju's MAAS
provider has an integrated "maas" storage provider. This storage provider is
static-only; it is currently only possible to deploy charms requiring block
storage to a new machine in MAAS, and not to an existing machine.

The MAAS provider currently has a single configuration attribute:

- tags

    a comma-separated list of tags to match on the disks in MAAS. For example,
    you might tag some disks as "fast"; you can then create a storage pool in
    Juju that will draw from the disks with those tags.

#### Microsoft Azure (azure)

The Microsoft Azure provider does not currently have any storage configuration.

#### Google Compute Engine (gce)

The Google Compute Engine provider does not currently have any storage
configuration.


### Deploying with storage constraints

A charm which requires storage will have the default storage (unit filesystem)
allocated for it automatically. Constraints can be used, when deploying an
application, to override the default requirements.

The constraints can specify the type/pool, size and count, of the storage
required. At least one of the constraints must be specified, but otherwise they
are all optional.

If pool is not specified, then Juju will select the default storage provider for
the current environment (e.g. cinder for openstack, ebs for ec2, loop for
local). If size is not specified, then Juju will use the minimum size specified
in the charm's storage metadata, or 1GiB if the metadata does not specify. If
count is not specified, then Juju will create a single instance of the store.

```bash
juju deploy <charm> --storage <label>=<pool>,<size>,count
```

For example, to deploy the postgresql service and have it use the unit’s local
filesystem for 10 gibibytes of storage for its ‘data’ storage requirement:

```bash
juju deploy cs:~axwalk/postgresql --storage data=rootfs,10G
```

We can also deploy using a local loop device

```bash
juju deploy cs:~axwalk/postgresql --storage data=loop,5G
```

If the size is omitted...

```bash
juju deploy cs:~axwalk/postgresql --storage data=rootfs
```

Juju will use a default size of 1GiB, unless the charm itself has specified a
minimum value, in which case that will be used.

When deploying on a provider which supplies storage, the supported storage pool
types may be used in addition to ‘loop’ and ‘rootfs’. For example, on using
Amazon’s EC2 provider, we can make use of the default ‘ebs’ storage pool

```bash
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G
```

Cloud providers may support more than one type of storage. For example, in the
case of EC2, we can also make use of the ebd-ssd pool, which is SSD-based
storage, and hence faster and better for some storage requirements.

```bash
juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd
```

We can also merely specify the size, in which case Juju will use the default
pool for the selected environment. E.g.:

```bash
juju deploy cs:~axwalk/postgresql --storage data=10G
```

Which, on the EC2 provider, will create a 10
[gibibyte](https://en.wikipedia.org/wiki/Gibibyte) volume in the ‘ebs’ pool.

Charms may declare multiple types of storage, in which case they may all be
specified using the constraint, or some or all can be omitted to accept the
default values:

```bash
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G cache=ebs-ssd
```

### Deployment Example

There is a modified version of the PostgreSQL charm using the storage feature.
You can find the branch at
[cs:~axwalk/postgresql](https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk).

Here is how you can go about using the storage feature. Start by deploying a
charm that defines a storage unit.

```no-highlight
juju deploy cs:~axwalk/postgresql pg-rootfs
juju deploy cs:~axwalk/postgresql --storage data=loop,1G pg-loop
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G pg-magnetic
juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd,10G pg-ssd
juju storage pool create ebs-iops ebs volume-type=provisioned-iops iops=300
juju deploy cs:~axwalk/postgresql --storage data=ebs-iops,10G pg-iops
sleep $SOME_TIME
juju storage
```

Output:  

```no-highlight
[Storage]
UNIT          ID     LOCATION  STATUS   PERSISTENT
pg-iops/0     data/4           pending  false
pg-loop/0     data/1 /srv/data attached false
pg-magnetic/0 data/2 /srv/data attached false
pg-rootfs/0   data/0 /srv/data attached false
pg-ssd/0      data/3 /srv/data attached false
```

### Upgrading with storage constraints

When updating a charm with the [upgrade-charm][upgrade-charm] command,
default storage constraints will be preserved unless new constraints have been
added to the updated charm. 

For example, if an update to the PostgreSQL charm adds a requirement for
pgdata and pgdata doesn't currently exist, the update will automatically
create a rootfs pgdata storage instance for each unit. 

As with the `deploy` command, constraints can be specified when updating
by adding the '--storage' argument:

```bash
juju upgrade-charm postgresql --storage pgdata=10G
```

### Known limitations

- Currently LXD (localhost) does not support mounting loopback devices 
  for storage.

### More information

If you are interested in more information on how to create a charm that uses
the storage feature read
[writing charms that use storage](./developer-storage.html).

[model-config]: ./models-config.html#list-of-model-keys
[upgrade-charm]: ./commands.html#upgrade-charm
