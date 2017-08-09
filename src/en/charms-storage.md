Title: Using Juju Storage
TODO:  bug tracking: https://pad.lv/1708212
       bug tracking: https://pad.lv/1709507
       bug tracking: https://pad.lv/1709508
       Revise Note 'not possible to add storage' after reviewing command `import-filesystem`

# Using Juju Storage

Certain applications can benefit from advanced storage configurations and if a
charm exists for such an application Juju can declare such requirements both
at deploy time and during the lifetime of the application.

The level of sophistication is limited by the charm; a charm may support
multiple storage options (e.g. persistent storage, additional cache). All this
allows the user to allocate resources at a granular level. This page will refer
to the [PostgreSQL charm][charm-store-postgresql] and the
[Ceph OSD charm][charm-store-ceph-osd].

The Ceph examples used here are based on the Ceph cluster described in the
document [Installing Ceph][charms-storage-ceph].

## Storage management commands

Outside of application deployment, Juju also has a wide array of storage
management abilities. Related commands are listed below, along with a brief
description of each.

[`add-storage`][commands-add-storage]
: Creates and attaches a storage instance to a unit.

[`attach-storage`][commands-attach-storage]
: Attaches an existing storage instance to a unit.

[`create-storage-pool`][commands-create-storage-pool]
: Creates or defines a storage pool.

[`detach-storage`][commands-detach-storage]
: Detaches a storage instance from a unit. Storage is preserved.

[`remove-storage`][commands-remove-storage]
: Removes a storage instance from a model. Storage is destroyed.

[`show-storage`][commands-show-storage]
: Shows details of a storage instance.

[`storage`][commands-storage]
: Lists all storage instances in a model.

[`storage-pools`][commands-storage-pools]
: Lists all storage pools in a model.

## Storage constraints

Several properties are used to dictate how storage is allocated:

- 'pool': class of storage
- 'size': size of each volume
- 'count': number of volumes

The default pool (e.g. 'ebs' for AWS, 'cinder' for OpenStack) is given by:

```bash
juju model-config storage-default-block-source
```

These properties are specified as constraints with the `juju deploy` or
`juju add-storage` commands.

### juju deploy

```bash
juju deploy <charm> [--storage <label>=<pool>,<size>,<count>]
```

Notes:

- `label` is a string taken from the charm itself. It encapsulates a specific
  storage option/feature. Sometimes called a *store*.
- `--storage` may be specified multiple times, to support multiple labels.

If at least one constraint is specified the following default values come into
effect:

- 'pool' = the default pool (see above)
- 'size' = determined from the charm's minimum storage size, or 1GiB if the
  charm does not specify a minimum
- 'count' = the minimum number required by the charm, or '1' if the storage is
  optional

In the absence of any storage constraints, the storage will be put on the root
filesystem.

### juju add-storage

```bash
juju add-storage <unit> <label>[=<pool>,<size>,<count>]
```

As with `juju add-unit` the storage parameters used are taken from the `juju deploy`
command corresponding to the unit.

### Examples

To deploy PostgreSQL with one instance (count) of 100GiB, via the charm's 'pgdata'
storage label, using the default storage pool:

```bash
juju deploy postgresql --storage pgdata=100G
```

Assuming an AWS model, a more explicit, but equivalent, command is:

```bash
juju deploy postgresql --storage pgdata=ebs,100G,1
```

## Storage pools

Use the `juju storage-pools` command to list the predefined storage pools as
well as any custom ones that may have been created with the
`juju create-storage-pool` command:

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

!!! Note:
    The name given to a default storage pool will often be the same as the
    name of the storage pool upon which it is based.

Depending on the storage provider (see [below][anchor__storage-providers]),
custom storage pools can be created. In the case of AWS, the 'ebs' storage
provider supports several configuration attributes:

- 'volume-type': volume type (i.e. magnetic, ssd, or provisioned-iops)
- 'encrypted': enable/disable disk encryption
- 'iops': IOPS per GiB

For example, to provision a 3000 IOPS volume (100GiB x 30IOPS/GiB) by first
creating a custom storage pool and then having a newly deployed PostgreSQL use
it for its database storage:

```bash
juju create-storage-pool iops ebs volume-type=provisioned-iops iops=30
juju deploy postgresql --storage pgdata=iops,100G
```

See [IOPS][wikipedia-iops] (Wikipedia) for background information.

## Dynamic storage

Most storage can be dynamically added to, and removed from, a unit. Some types
of storage, however, cannot be dynamically managed. For instance, Juju cannot
disassociate MAAS disks from their respective MAAS nodes. These types of static
storage can only be requested at deployment time and will be removed when the
machine is removed from the model.

Certain cloud providers may also impose certain restrictions when attaching
storage. For example, attaching an EBS volume to an EC2 instance requires that
they both reside within the same availability zone. If this is not the case,
Juju will return an error.

When deploying an application or unit that requires storage, using machine
placement (i.e. `--to`) requires that the assigned storage be dynamic. Juju will
return an error if you try to deploy a unit to an existing machine, while also
attempting to allocate static storage.

### Adding and detaching storage

Assuming the storage provider supports it, storage can be created and attached
to a unit using `juju add-storage`. Juju will ensure the storage is allowed to
attach to the unit's machine.

!!! Note:
    Currently, it is not possible to add storage to the model without also
    attaching it to a unit.

Charms can specify a maximum number of storage instances. In the case of the
charm 'postgresql', a maximum of one is allowed for 'pgdata'. If an attempt is
made to exceed it, Juju will return an error.

Dynamic storage can be detached from units using `juju detach-storage`.

Charms can also define a minimum number of storage instances. The postgresql
charm specifies a minimum of zero for 'pgdata' whereas another charm may specify
a different number. In any case, if detaching storage from a unit would bring
the total number of storage instances below the minimum, Juju will return an
error.

#### Examples

To create a 32GiB EBS volume and attach it to unit 'ceph-osd/0' as its OSD
storage:

```bash
juju add-storage ceph-osd/0 osd-devices=ebs,32G,1
```

Above, the volume was created in the same availability zone as the instance (a
requirement).

To detach OSD device 'osd-devices/2' from a Ceph unit:

```bash
juju detach-storage osd-devices/2
```

!!! Important:
    Detaching storage from a unit does not destroy the storage.

### Persistence

As we saw, detaching storage does not destroy the storage. In addition, when a
unit is removed from a model, and the unit has dynamic storage attached, the
storage will be detached and left intact. This allows detached storage to be
re-attached to an existing unit using `juju attach-storage`, or to a new unit
using the `--attach-storage` flag of `juju deploy` or `juju add-unit`.

Storage is destroyed (removed from the model) by first detaching it and then
using `juju remove-storage`.

If an attempt is made to either attach or remove storage that is currently in
use (i.e. it is attached to a unit) Juju will return an error.

Finally, a model cannot be destroyed while storage volumes remain without
passing a special option (`--destroy-storage`). Naturally, this applies to
the removal of a controller as well.

#### Examples

To attach existing storage 'osd-devices/7' to existing unit 'ceph-osd/1':

```bash
juju attach-storage ceph-osd/1 osd-devices/7
```

To deploy PostgreSQL with (detached) existing storage 'pgdata/0':

```bash
juju deploy postgresql --attach-storage pgdata/0
```

!!! Note:
    The `--attach-storage` and `-n` flags cannot be used together.

To add a new Ceph OSD unit with (detached) existing storage 'osd-devices/2':

```bash
juju add-unit ceph-osd --attach-storage osd-devices/2
```

To destroy already detached storage 'osd-devices/3' (remove it from the model):

```bash
juju remove-storage osd-devices/3
```

To upgrade the OSD journal of Ceph unit 'ceph-osd/0' from magnetic to solid
state (SSD) and dispose of the unneeded original journal 'osd-journals/0':

```bash
juju add-storage ceph-osd/0 osd-journals=ebs-ssd,8G,1
juju detach-storage osd-journals/0
juju remove-storage osd-journals/0
```
 
To destroy a controller (and its models) along with all existing storage
volumes:

```bash
juju destroy-controller lxd-controller --destroy-all-models --destroy-storage
```

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

If such a constraint was not provided, 'rootfs' would be used (as described in
the section on deploying with
[storage constraints][anchor__storage-constraints-juju-deploy]).

!!! Warning:
    Specifying new constraints may be necessary when upgrading to a revision of
    a charm that introduces new, required, storage options.

## Storage providers

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

AWS-based models have access to the 'ebs' storage provider, which supports the
following pool attributes:

- **volume-type**

    Specifies the EBS volume type to create. You can use either the EBS volume
    type names, or synonyms defined by Juju (in parentheses):

    - standard (magnetic)
    - gp2 (ssd)
    - io1 (provisioned-iops)

    The default volume type is 'standard'. Since the default pool is 'ebs' the
    default volume for AWS will be magnetic.

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
juju deploy postgresql --storage pgdata=myssd-pool,32G
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

### LXD (lxd)

LXD-based models have access to the 'lxd' storage provider. The LXD provider
does not currently have any specific configuration options.

!!! Note:
    To get an LXD version on either Ubuntu 14.04 LTS (Trusty) or Ubuntu 16.04
    LTS (Xenial) that has the 'lxd' storage provider feature the
    [LXD PPA][ppa-lxd] (
    `sudo apt-add-repository -yu ppa:ubuntu-lxc/lxd-stable; sudo apt install -y lxd`
    ) will be required.

Every LXD-based model comes with a minimum of one LXD-specific Juju storage
pool called 'lxd'. If ZFS and/or BTRFS are present when the controller is
created then pools 'lxd-zfs' and/or 'lxd-btrfs' will also be available. The
following output to the `juju storage-pools` command shows all three Juju
LXD-specific pools:

```no-highlight
Name       Provider  Attrs
loop       loop
lxd        lxd
lxd-btrfs  lxd       driver=btrfs lxd-pool=juju-btrfs
lxd-zfs    lxd       driver=zfs lxd-pool=juju-zfs zfs.pool_name=juju-lxd
rootfs     rootfs
tmpfs      tmpfs
```

As can be inferred from the above output, for each Juju storage pool based on
the 'lxd' storage provider there is a LXD storage pool that gets created. It
is these LXD pools that will house the actual volumes.

The LXD pool corresponding to the Juju 'lxd' pool doesn't get created until the
latter is used for the first time (typically via the `juju deploy` command). It
is called simply 'juju'.

The command `lxc storage list` is used to list LXD storage pools. A full
"contingent" of LXD non-custom storage pools would like like this:

```no-highlight
+------------+-------------+--------+------------------------------------+---------+
|    NAME    | DESCRIPTION | DRIVER |               SOURCE               | USED BY |
+------------+-------------+--------+------------------------------------+---------+
| default    |             | dir    | /var/lib/lxd/storage-pools/default | 1       |
+------------+-------------+--------+------------------------------------+---------+
| juju       |             | dir    | /var/lib/lxd/storage-pools/juju    | 0       |
+------------+-------------+--------+------------------------------------+---------+
| juju-btrfs |             | btrfs  | /var/lib/lxd/disks/juju-btrfs.img  | 0       |
+------------+-------------+--------+------------------------------------+---------+
| juju-zfs   |             | zfs    | /var/lib/lxd/disks/juju-zfs.img    | 0       |
+------------+-------------+--------+------------------------------------+---------+
```

To be clear, the three Juju-related pools above are for storing *volumes* that
Juju applications can use. The fourth 'default' pool is the standard LXD
storage pool where the actual *containers* (operating systems) live.

To deploy an application, refer to the pool as usual. Here we deploy PostgreSQL
using the 'lxd' Juju storage pool, which, in turn, uses the 'juju' LXD storage
pool:

```bash
juju deploy postgresql --storage pgdata=lxd,8G
```

See [Using LXD as a cloud][clouds-lxd] for how to use LXD in conjunction with
Juju, including the use of ZFS as an alternative filesystem.

#### Loop devices and LXD

LXD (localhost) does not officially support attaching loopback devices for
storage out of the box. However, with some configuration you can make this
work.

Each container uses the 'default' LXD profile, but also uses a model-specific
profile with the name `juju-<model-name>`. Editing a profile will affect all of
the containers using it, so you can add loop devices to all LXD containers by
editing the 'default' profile, or you can scope it to a model.

To add loop devices to your container, add entries to the 'default', or
model-specific, profile, with `lxc profile edit <profile>`:

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

Doing so will expose the loop devices so the container can acquire them via the
`losetup` command. However, it is not sufficient to enable the container to
mount filesystems onto the loop devices. One way to achieve that is to make the
container "privileged" by adding:

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

[clouds-lxd]: ./clouds-LXD.html
[charms-storage-ceph]: ./charms-storage-ceph.html
[generic-storage-loop]: https://en.wikipedia.org/wiki/Loop_device
[generic-storage-rootfs]: https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt
[generic-storage-tmpfs]: https://en.wikipedia.org/wiki/Tmpfs
[anchor__loop-devices-and-lxd]: #loop-devices-and-lxd
[anchor__storage-constraints-juju-deploy]: #juju-deploy
[charm-store-postgresql]: https://jujucharms.com/postgresql
[charm-store-ceph-osd]: https://jujucharms.com/ceph-osd
[ceph-charm]: https://jujucharms.com/ceph-osd
[developer-storage]: ./developer-storage.html
[aws-iops-ssd-volumes]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html#EBSVolumeTypes_piops
[aws-ebs-volume-types]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
[wikipedia-iops]: https://en.wikipedia.org/wiki/IOPS
[ppa-lxd]: https://launchpad.net/~ubuntu-lxc/+archive/ubuntu/lxd-stable

[anchor__storage-providers]: #storage-providers
