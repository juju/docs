Title: Using storage with Juju charms

# Using Juju Storage

Many applications require access to a storage resource of some form. Juju charms
can declare what storage requirements they have, and these can be allocated when
the charm is deployed. Charms may declare several types of storage requirement
(e.g. for persistent storage and an additional cache) so that resources can be
allocated at a more granular level.

Juju has storage-related commands for creating, destroying, listing, and managing
attachments to application units.

[`add-storage`](./commands.html#add-storage)
: Adds unit storage dynamically.

[`attach-storage`](./commands.html#attach-storage)
: Attaches existing storage to a unit.

[`create-storage-pool`](./commands.html#create-storage-pool)
: Create or define a storage pool.

[`detach-storage`](./commands.html#detach-storage)
: Detaches storage from units.

[`show-storage`](./commands.html#show-storage)
: Shows the details of a single, specified storage instance.

[`storage`](./commands.html#storage) (also 'list-storage')
: Lists details of all storage instances in the model.

[`storage-pools`](./commands.html#storage-pools) (also 'list-storage-pools')
: List storage pools.

[`remove-storage`](./commands.html#remove-storage)
: Removes storage from the model.

## Deploying a charm with storage requirements

For this document, our examples will focus on the [PostgreSQL charm](https://jujucharms.com/postgresql/)
which uses the Juju Storage feature to store the database contents separately from
the root filesystem.

### Deploying with storage constraints

When deploying a charm with additional storage requirements, you can control
several properties of how the storage will be allocated:

- the "pool" from which to allocate the storage; pools are described below,
  but for now you can think of them as the class of storage, such as magnetic
  or SSD;
- the number of volumes/filesystems to allocate;
- the size of each volume/filesystem.

When deploying the application, you control these properties by specifying
"storage constraints" via the `--storage` flag of [`juju deploy`](./commands.html#deploy).
If you specify no storage constraints at all, then Juju will place the storage
on the root filesystem.

```bash
juju deploy <charm> --storage <label>=<pool>,<size>,count
```

If you specify some constraints, but not others, then Juju will select defaults
for the others:

- if unspecified, the number of storage instances will be the minimum
  number required by the charm, or 1 if the storage is optional;
- if unspecified, the size of the storage will be taken from the charm's
  minimum storage size, or 1GiB if the charm does not specify a minimum.
- if unspecified, the default pool for the model/cloud provider will
  be used. e.g. "ebs" for AWS, "cinder" for OpenStack.

```bash
# Deploy one instance of 100GiB for postgresql's pgdata storage,
# using the model/cloud provider's default storage pool. For AWS,
# this means using the "ebs" storage pool.
juju deploy postgresql --storage pgdata=100G

# Deploy one instance of 100GiB for postgresql's pgdata storage,
# using the "ebs-ssd" storage pool. This allows you to take
# advantage of cloud-specific storage options.
juju deploy postgresql --storage pgdata=100G,ebs-ssd
```

The `--storage` flag may be specified multiple times, to support
specifying constraints for multiple stores. For example, the [Ceph OSD](https://jujucharms.com/ceph-osd/)
charm supports two stores: osd-devices, and osd-journals. You can
specify constraints for these separately:

```bash
# Deploy Ceph OSD, with 3x100GiB volumes per unit for
# data storage, and 1x10G per unit for journaling.
juju deploy ceph-osd --storage osd-devices=3,100G --storage osd-journals=10G
```

### Storage pools

You can list the storage pools available for use with the `juju storage-pools`
command. This will list the predefined storage pools, and any custom ones that
you create using the `juju create-storage-pool` command.

```bash
juju storage-pools
```

When run in a new AWS model, this produces the following output:

```no-highlight
Name     Provider  Attrs
ebs      ebs       
ebs-ssd  ebs       volume-type=ssd
loop     loop      
rootfs   rootfs    
tmpfs    tmpfs     
```

These are just the pre-defined storage pools. Depending on the storage provider,
you can create additional, custom, storage pools. For example, the "ebs"
storage provider supports several configuration attributes: "volume-type"
(volume type, i.e. magnetic, ssd, or provisioned-iops; "encrypted" (whether
or not disk encryption should be used); and "iops" (IOPS per GiB). For example,
you can create a storage pool that allocates provisioned IOPS volumes, with
a ratio of 30 IOPS per GiB:

```bash
juju create-storage-pool iops ebs volume-type=provisioned-iops iops=30
```

Using this, you can provision a 3000 IOPS volume (100GiB x 30IOPS/GiB):

```bash
juju deploy postgresql --storage pgdata=iops,100G
```

### Dynamic storage

Most storage can be dynamically added to and removed from a machine. For example,
EBS volumes can be dynamically created and attached to an existing EC2 instance,
so long as they are in the same availability zone. For dynamic storage, you can
use the dynamic storage management commands:

- add-storage, to allocate additional storage instances to a unit;
- attach-storage, to attach existing storage to a unit;
- detach-storage, to detach storage from a unit;
- remove-storage, to remove storage from the model.

Some other storage, such as MAAS's disks, cannot be dynamically added or removed.
In the case of MAAS disks, they are physically part of the same machine; they are
&mdash; at least to Juju &mdash; inseparable. For these types of storage, you can
only request the storage at deployment time; and then it will be removed along with
the machine, when the machine is removed from the model.

When deploying an application or unit that requires storage, using machine
placement (i.e. `--to`) requires that the assigned storage be dynamic. Juju will
return an error if you try to deploy a unit to an existing machine, while also
attempting to allocate static storage.

Providers may also impose certain restrictions when attaching storage. For
example, as described above, attaching an EBS volume to an EC2 instance requires
that they be within the same availability zone. If you try to use `juju attach-storage`
to attach an EBS volume to a unit whose machine lies within a different
availability zone, Juju will return an error.

#### Adding and detaching storage

Assuming the storage provider supports it, storage can be dynamically added to
a unit using `juju add-storage`:

```bash
# Create a new 100GiB EBS volume, and attach it to postgresql/0 as its pgdata
# storage.
juju add-storage postgresql/0 pgdata=ebs,100G
```

Juju will take care creating the storage so that it will be attachable to the
unit's machine; for example, in AWS, the EBS volume will be created in the same
availability zone as the instance.

Charms can specify a maximum number of storage instances, e.g. postgresql can
have at most one instance of pgdata. If you try to add more than the charm
allows, Juju will return an error.

Dynamic storage can be detached from units dynamically, using the
`juju detach-storage` command mentioned above:

```bash
# Detach the storage pgdata/0 from the unit postgresql/0.
juju detach-storage postgresql/0 pgdata/0
```

Charms can define a minimum, as well as maximum number, of storage instances.
As mentioned, the postgresql charm specifies a minimum of zero, and maximum
of one, for pgdata. Other charms may require exactly one, or an arbitrary
range. In any case, if detaching storage from a unit would bring the total
number of storage instances below the minimum, Juju will return an error.

#### Persistence

Detaching storage from a unit does not destroy the storage. When you remove
a unit from the model, and the unit has dynamic storage attached, Juju will
detach the storage but leave it in the model. This enables the storage to be
attached to another unit using `juju attach-storage`, or to a new unit using
the `--attach-storage` flag of `juju deploy` or `juju add-unit`:

```bash
# Attach the existing storage pgdata/0 to the existing unit postgresql/1.
juju attach-storage postgresql/1 pgdata/0

# Deploy the postgresql charm, attaching the existing storage pgdata/0 to
# the new unit. The "--attach-storage" and "-n" flags cannot be used together.
juju deploy postgresql --attach-storage pgdata/0

# Add a new unit of the postgresql application, attaching the existing storage
# pgdata/0 to the new unit. The "--attach-storage" and "-n" flags cannot be
# used together.
juju add-unit postgresql --attach-storage pgdata/0
```

Alternatively, detached storage can be destroyed and removed from the model using
`juju remove-storage`:

```bash
juju remove-storage pgdata/0
```

Storage is currently tied to a single model, which means it is not currently
possible to reuse storage from one model or controller in another. When you
destroy the model, or controller, the storage will be destroyed. Support for
releasing storage from a model, and enlisting it into another, is planned for
a future release.

### Upgrading applications with new storage

When updating a charm with the [juju upgrade-charm](./commands.html#upgrade-charm)
command, the existing storage constraints specified at deployment time will be
preserved. It is possible to change the storage constraints and define
new ones by passing the `--storage` flag to `juju upgrade-charm`. This may
be necessary when upgrading to a revision of a charm that introduces
new, required, storage.

For example, if the pgdata storage did not exist in revision 1 of the postgresql
charm, and were introduced in revision 2: when upgrading from revision 1 to
revision 2, you could inform Juju of how to allocate the new storage by specifying
the storage constraints to `juju upgrade-charm`:

```bash
juju upgrade-charm postgresql --storage pgdata=10G
```

If you were to run `juju upgrade-charm` without specifying the constraints,
rootfs would be used as described in the section on deploying with storage
constraints.

## Storage Providers

### Common storage providers

There are several cloud-independent storage providers, which are available
to all types of models:

- [loop](https://en.wikipedia.org/wiki/Loop_device)

    block-type, creates a file on the unit's root filesystem, associates
    a loop device with it. The loop device is provided to the charm.

- [rootfs](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)

    filesystem-type, creates a sub-directory on the unit's root filesystem
    for the unit/charm to use.

- [tmpfs](https://en.wikipedia.org/wiki/Tmpfs)

    filesystem-type, creates a temporary file storage facility that appears as
    a mounted file system but is stored in volatile memory.

Loop devices require extra configuration to be used within LXD. For that,
please refer to [Loop devices and LXD](#loop-devices-and-lxd).

### AWS/EBS (ebs)

AWS models have access to the "ebs" storage provider. The EBS storage provider
currently supports the following pool configuration attributes:

- **volume-type**

    specifies the EBS volume type to create. You can use either the EBS volume
    type names, or synonyms defined by Juju (in parentheses): gp2 (ssd), io1
    (provisioned-iops), standard (magnetic). By default, magnetic/standard
    volumes will be created. An 'ebs-ssd' pool is created in all EC2
    environments, which defaults the volume type to ssd/gp2 instead.

- **iops**

    the number of IOPS for provisioned-iops volume types. There are
    restrictions on minimum and maximum IOPS, as a ratio of the size of
    volumes; see [Provisioned IOPS (SSD) Volumes](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html#EBSVolumeTypes_piops) for more information.

- **encrypted**

    true|false, indicating whether or not to encrypt volumes created by the pool.

For convenience, the AWS provider registers two predefined pools:
"ebs" (magnetic volumes), and "ebs-ssd" (SSD volumes).

For information regarding EBS volume types, see 
[the EBS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html).

### OpenStack/Cinder (cinder)

OpenStack models have access to the "cinder" storage provider. The Cinder
provider does not currently have any specific configuration options.

### MAAS (maas)

MAAS 1.8+ contains support for discovering information about machines' disks,
and an API for acquiring nodes with specified disk parameters. Juju's MAAS
provider has an integrated "maas" storage provider. This storage provider is
static-only; it is only possible to deploy charms using "maas" storage to a
new machine in MAAS, and not to an existing machine, as described in the
section on dynamic storage.

The MAAS provider currently has a single configuration attribute:

- **tags**

    a comma-separated list of tags to match on the disks in MAAS. For example,
    you might tag some disks as "fast"; you can then create a storage pool in
    Juju that will draw from the disks with those tags.

### Microsoft Azure (azure)

Azure models have access to the "azure" storage provider. The Azure storage
provider does not currently have any storage configuration.

The Microsoft Azure provider does not currently have any storage configuration.

### Google Compute Engine (gce)

Google models have access to the "gce" storage provider. The GCE storage
provider does not currently have any storage configuration.

### Oracle Compute Cloud (oracle)

Oracle models have access to the "oracle" storage provider. The Oracle storage
provider currently supports a single pool configuration attribute:

- **volume-type**

    default|latency, the volume type. Use "latency" for low-latency, high IOPS
    requirements, and "default" otherwise.

For convenience, the Oracle provider registers two predefined pools:
"oracle" (using the default volume type), and "oracle-latency"
(using the latency volume type).

#### Loop devices and LXD

LXD (localhost) does not officially support attaching loopback devices for
storage out of the box. However, with some configuration you can make this
work.

Each container uses the "default" LXD profile, but also uses a model-specific
profile with the name juju-<model-name>. Editing a profile will affect all of
the containers using it, so you can add loop devices to all LXD containers by
editing the default profile, or you can scope it to a model.

To add loop devices to your container, add loop device entries to the default
or model-specific profile, with `lxc profile edit <profile>`, like this:

```yaml
...
devices:
  loop-control:
    major: "10"
    minor: "237"
    path: /dev/loop-control
    type: unix-char
  loop0:
    major: "7"
    minor: "0"
    path: /dev/loop0
    type: unix-block
  loop1:
    major: "7"
    minor: "1"
    path: /dev/loop1
    type: unix-block
...
  loop9:
    major: "7"
    minor: "9"
    path: /dev/loop9
    type: unix-block
```

The above is enough to expose the loop devices into the container, and for the
container to acquire one of them using "losetup". It is not yet enough to enable
the container to mount filesystems on the loop devices. For that, the simplest
thing to do is to make the container privileged by adding:

```yaml
config:
  security.privileged: "true"
```

## More information

If you are interested in more information on how to create a charm that uses
the storage feature read
[writing charms that use storage](./developer-storage.html).

