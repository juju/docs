Title: Using storage with Juju charms

# Using Juju Storage

Certain applications can benefit from advanced storage configurations and if a
charm exists for such an application Juju can declare such requirements during
deploy time.

The level of sophistication is limited by the charm; a charm may support
multiple storage options (e.g. persistent storage, additional cache). All this
allows the user to allocate resources at a granular level with the goal of
optimizing the application's functioning.

## Storage management

Outside of application deployment, Juju also has a wide array of storage
management abilities. Related commands are listed below, along with a brief
description of each.

[`add-storage`][commands-add-storage]
: Adds unit storage dynamically.

[`attach-storage`][commands-attach-storage]
: Attaches existing storage to a unit.

[`create-storage-pool`][commands-create-storage-pool]
: Creates or defines a storage pool.

[`detach-storage`][commands-detach-storage]
: Detaches storage from a unit.

[`show-storage`][commands-show-storage]
: Shows the details of a specific storage instance.

[`storage`][commands-storage]
: Lists details of all storage instances in the model.

[`storage-pools`][commands-storage-pools]
: Lists storage pools.

[`remove-storage`][commands-remove-storage]
: Removes storage from the model.

## Deploying a charm with storage options

The advanced storage features of Juju naturally depend upon charms that have
storage options. This document will focus on the
[PostgreSQL charm][postgresql-charm] which uses these features to store the
database contents separately from the root filesystem.

### Storage constraints

Several properties are used to dictate how storage is allocated:

- 'pool': class of storage (e.g. magnetic, SSD)
- 'size': size of each volume/filesystem
- 'count': number of volumes/filesystems

These properties are specified as constraints via the `juju deploy` command's
`--storage` flag:

```bash
juju deploy <charm> --storage <label>=<pool>,<size>,<count>
```

Notes:

- `label` is a string taken from the charm itself. It encapsulates a specific
  storage option/feature.
- `--storage` may be specified multiple times, to support multiple labels.

If at least one constraint is specified the following defaults come into
effect:

- 'pool' = the default pool of the given cloud (e.g. 'ebs' for AWS, 'cinder'
  for OpenStack) or model
- 'size' = taken from the charm's minimum storage size, or 1GiB if the charm
  does not specify a minimum
- 'count' = the minimum number required by the charm, or '1' if the storage is
  optional

In the absence of any storage constraints, the storage will be on the root
filesystem.

### Examples

Deploy PostgreSQL with one instance (count) of 100GiB, via the charm's 'pgdata'
storage label, using the cloud's (or model's) default storage pool:

```bash
juju deploy postgresql --storage pgdata=100G
```

Deploy PostgreSQL with one instance (count) of 100GiB, via the charm's 'pgdata'
storage label, using the 'ebs-ssd' storage pool:

```bash
juju deploy postgresql --storage pgdata=ebs-ssd,100G
```

Deploy Ceph OSD with 3x100GiB volumes per unit for data storage, and 1x10GiB
per unit for journalling:

```bash
juju deploy ceph-osd --storage osd-devices=100G,3 --storage osd-journals=10G
```

See the [Ceph OSD charm][ceph-charm] used above.

### Storage pools

Use the `juju storage-pools` command to list the predefined storage pools as
well as any custom ones that may have been created with the `juju
create-storage-pool` command:

```bash
juju storage-pools
```

Here is sample output for a newly-added AWS model:

```no-highlight
Name     Provider  Attrs
ebs      ebs       
ebs-ssd  ebs       volume-type=ssd
loop     loop      
rootfs   rootfs    
tmpfs    tmpfs     
```

Depending on the storage provider, custom storage pools can be created. For
example, the 'ebs' storage provider supports several configuration attributes:

- 'volume-type': volume type (i.e. magnetic, ssd, or provisioned-iops)
- 'encrypted': enable/disable disk encryption
- 'iops': IOPS per GiB

For example, here we provision a 3000 IOPS volume (100GiB x 30IOPS/GiB) by
first creating a custom storage pool and then using it with PostgreSQL:

```bash
juju create-storage-pool iops ebs volume-type=provisioned-iops iops=30
juju deploy postgresql --storage pgdata=iops,100G
```

### Dynamic storage

Most storage can be dynamically added to, and removed from, a machine. For
example, EBS volumes can be created and attached to EC2 instances, as long as
they are in the same availability zone.

Some types of storage, however, cannot be dynamically managed. For instance,
Juju cannot disassociate MAAS disks from their respective MAAS nodes. These
types of static storage can only be requested at deployment time and will
be removed when the machine is removed from the model.

When deploying an application or unit that requires storage, using machine
placement (i.e. `--to`) requires that the assigned storage be dynamic. Juju will
return an error if you try to deploy a unit to an existing machine, while also
attempting to allocate static storage.

Cloud providers may also impose certain restrictions when attaching storage.
For example, as described above, attaching an EBS volume to an EC2 instance
requires that they both reside within the same availability zone. If this is
not the case, Juju will return an error.

#### Adding and detaching storage

Assuming the storage provider supports it, storage can be created and
dynamically attached to a unit using `juju add-storage`.

For example, to create a 100GiB EBS volume and attach it to unit 'postgresql/0'
as its pgdata storage:

```bash
juju add-storage postgresql/0 pgdata=ebs,100G
```

Juju will ensure the storage is allowed to attach to the unit's machine. In the
above example, the EBS volume was created in the same availability zone as the
instance (a requirement).

Charms can specify a maximum number of storage instances. In the case of the
postgresql charm, a maximum of one is allowed for 'pgdata'. If an attempt is
made to exceed it, Juju will return an error.

Dynamic storage can be detached from units using `juju detach-storage`.

For example, to detach storage 'pgdata/0' from unit 'postgresql/0':

```bash
juju detach-storage postgresql/0 pgdata/0
```

Charms can also define a minimum number of storage instances. The postgresql
charm specifies a minimum of zero for 'pgdata' whereas another charm may specify
a different number. In any case, if detaching storage from a unit would bring
the total number of storage instances below the minimum, Juju will return an
error.

#### Persistence

Detaching storage from a unit does not destroy the storage. When a unit is
removed from the model, and the unit has dynamic storage attached, Juju will
detach the storage but leave it intact at the model level. This enables the
storage to be re-attached to another unit using `juju attach-storage`, or to a
new unit using the `--attach-storage` flag of `juju deploy` or `juju add-unit`:

Detached storage can be destroyed and removed from the model using `juju remove-storage`.

##### Examples

Attach existing storage 'pgdata/0' to existing unit 'postgresql/1':

```bash
juju attach-storage postgresql/1 pgdata/0
```

Deploy the postgresql charm, attaching existing storage 'pgdata/0' to the new
unit:

```bash
juju deploy postgresql --attach-storage pgdata/0
```

!!! Note:
    The `--attach-storage` and `-n` flags cannot be used together.

Add a new unit of the postgresql application, attaching existing storage
'pgdata/0' to the new unit:

```bash
juju add-unit postgresql --attach-storage pgdata/0
```

Destroy already detached storage 'pgdate/0' (remove it from the model):

```bash
juju remove-storage pgdata/0
```

If an attempt is made to remove storage that is currently in use (i.e. it is
attached) Juju will return an error.

### Cross-model storage

Storage management is currently restricted to a single model, which means it is
not possible to reuse storage from one model/controller in another. Also, when
a model/controller is removed, all associated storage will be destroyed.
Support for releasing storage from a model, and enlisting it into another, is
planned for a future release.

### Upgrading charms

When upgrading a charm with the [juju upgrade-charm][commands-upgrade-charm]
command, the existing storage constraints specified at deployment time will be
preserved.

It is also possible to change the storage constraints and define new ones by
passing the `--storage` flag to `juju upgrade-charm`. For example, if the
'pgdata' storage option did not exist in revision 1 of the postgresql charm,
but was introduced in revision 2, when upgrading (from 1 to 2) you could do:

```bash
juju upgrade-charm postgresql --storage pgdata=10G
```

If such a constraint was not provided, 'rootfs' would be used as described in the
section on deploying with storage constraints.

!!! Warning:
    Specifying new constraints may be necessary when upgrading to a revision of
    a charm that introduces new, required, storage options.

## Storage Providers

### Generic storage providers

There are several cloud-independent storage providers, which are available
to all types of models:

- [loop][generic-storage-loop]

    Block-type, creates a file on the unit's root filesystem, associates
    a loop device with it. The loop device is provided to the charm.

- [rootfs][generic-storage-rootfs]

    Filesystem-type, creates a sub-directory on the unit's root filesystem
    for the unit/charm to use.

- [tmpfs][generic-storage-tmpfs]

    Filesystem-type, creates a temporary file storage facility that appears as
    a mounted file system but is stored in volatile memory.

Loop devices require extra configuration to be used within LXD. For that,
please refer to [Loop devices and LXD][anchor__loop-devices-and-lxd] (below).

### AWS/EBS (ebs)

AWS-based models have access to the 'ebs' storage provider. The EBS storage
provider supports the following pool attributes:

- **volume-type**

    Specifies the EBS volume type to create. You can use either the EBS volume
    type names, or synonyms defined by Juju (in parentheses):

    - standard (magnetic)
    - gp2 (ssd)
    - io1 (provisioned-iops)

    By default, magnetic/standard volumes will be created.

- **iops**

    The number of IOPS for provisioned-iops volume types. There are
    restrictions on minimum and maximum IOPS, as a ratio of the size of volumes.
    See [Provisioned IOPS (SSD) Volumes][aws-iops-ssd-volumes] for more
    information.

- **encrypted**

    Boolean (true|false); indicates whether created volumes are encrypted.

Recall that pool 'ebs-ssd' is provided for all EC2 environments. This is the
easiest way to get SSD-based volumes; the pool defaults the volume type to
ssd/gp2. The alternate way would be to create a new pool with a
'volume-type' of 'ssd'. For example:

```bash
juju create-storage-pool myssd-pool ebs volume-type=ssd
juju deploy postgresql --storage pgdata=myssd-pool,16G
```

For detailed information regarding EBS volume types, see the
[AWS EBS documentation][aws-ebs-volume-types].

### OpenStack/Cinder (cinder)

OpenStack-based models have access to the 'cinder' storage provider. The Cinder
provider does not currently have any specific configuration options.

### MAAS (maas)

MAAS has support for discovering information about machine disks,
and an API for acquiring nodes with specified disk parameters. Juju's MAAS
provider has an integrated 'maas' storage provider. This storage provider is
static-only; it is only possible to deploy charms using 'maas' storage to a
new machine in MAAS, and not to an existing machine, as described in the
section on dynamic storage.

The MAAS provider currently has a single configuration attribute:

- **tags**

    A comma-separated list of tags to match on the disks in MAAS. For example,
    you might tag some disks as 'fast'; you can then create a storage pool in
    Juju that will draw from the disks with those tags.

### Microsoft Azure (azure)

Azure-based models have access to the 'azure' storage provider. The Azure
provider does not currently have any specific configuration options.

The Microsoft Azure provider does not currently have any storage configuration.

### Google Compute Engine (gce)

Google-based models have access to the 'gce' storage provider. The GCE provider
does not currently have any specific configuration options.

### Oracle Compute Cloud (oracle)

Oracle-based models have access to the 'oracle' storage provider. The Oracle
provider currently supports a single pool configuration attribute:

- **volume-type**

    Volume type, a value of 'default' or 'latency'. Use 'latency' for
    low-latency, high IOPS requirements, and 'default' otherwise.

    For convenience, the Oracle provider registers two predefined pools:
    
    - 'oracle' (volume type is 'default')
    - 'oracle-latency' (volume type is 'latency').

#### Loop devices and LXD

LXD (localhost) does not officially support attaching loopback devices for
storage out of the box. However, with some configuration you can make this
work.

Each container uses the 'default' LXD profile, but also uses a model-specific
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
container to acquire one of them using `losetup`, but it is not sufficient to
enable the container to mount filesystems on the loop devices. One way to
achieve that is to make the container privileged by adding:

```yaml
config:
  security.privileged: "true"
```

## Writing charms

For guidance on how to create a charm that uses these storage features see
[Writing charms that use storage][developer-storage].


<!-- LINKS -->

[commands-add-storage]: ./commands.html#add-storage
[commands-attach-storage]: ./commands.html#attach-storage
[commands-create-storage-pool]: ./commands.html#create-storage-pool
[commands-detach-storage]: ./commands.html#detach-storage
[commands-show-storage]: ./commands.html#show-storage
[commands-storage]: ./commands.html#storage
[commands-storage-pools]: ./commands.html#storage-pools
[commands-remove-storage]: ./commands.html#remove-storage
[commands-upgrade-charm]: ./commands.html#upgrade-charm

[generic-storage-loop]: https://en.wikipedia.org/wiki/Loop_device
[generic-storage-rootfs]: https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt
[generic-storage-tmpfs]: https://en.wikipedia.org/wiki/Tmpfs
[anchor__loop-devices-and-lxd]: #loop-devices-and-lxd
[postgresql-charm]: https://jujucharms.com/postgresql
[ceph-charm]: https://jujucharms.com/ceph-osd
[developer-storage]: ./developer-storage.html
[aws-iops-ssd-volumes]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html#EBSVolumeTypes_piops
[aws-ebs-volume-types]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
