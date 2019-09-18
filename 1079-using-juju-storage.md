<!--
Todo:
- bug tracking: https://pad.lv/1708212
- bug tracking: https://pad.lv/1709507
- bug tracking: https://pad.lv/1709508
- Review required
-->

Certain applications can benefit from advanced storage configurations and if a charm exists for such an application Juju can declare such requirements both at deploy time and during the lifetime of the application.

The level of sophistication is limited by the charm; a charm may support multiple storage options (e.g. persistent storage, additional cache). All this allows the user to allocate resources at a granular level. This page will refer to the [PostgreSQL charm](https://jujucharms.com/postgresql) and the [Ceph OSD charm](https://jujucharms.com/ceph-osd).

The Ceph examples used here are based on the Ceph cluster described in the document [Installing Ceph](/t/appendix-installing-ceph/1077).

<h2 id="heading--storage-management-commands">Storage management commands</h2>

Outside of application deployment, Juju also has a wide array of storage management abilities. Related commands are listed below, along with a brief description of each.

[`add-storage`](https://docs.jujucharms.com/commands#add-storage)
:   Creates and attaches a storage instance to a unit.

[`attach-storage`](https://docs.jujucharms.com/commands#attach-storage)
:   Attaches an existing storage instance to a unit.

[`create-storage-pool`](https://docs.jujucharms.com/commands#create-storage-pool)
:   Creates or defines a storage pool.

[`detach-storage`](https://docs.jujucharms.com/commands#detach-storage)
:   Detaches a storage instance from a unit. Storage is preserved.

[`import-filesystem`](https://docs.jujucharms.com/commands#import-filesystem)
:   Imports a filesystem into a model.

[`remove-storage`](https://docs.jujucharms.com/commands#remove-storage)
:   Removes a storage instance from a model. Storage is destroyed.

[`show-storage`](https://docs.jujucharms.com/commands#show-storage)
:   Shows details of a storage instance.

[`storage`](https://docs.jujucharms.com/commands#storage)
:   Lists all storage instances in a model.

[`storage-pools`](https://docs.jujucharms.com/commands#heading--storage-pools)
:   Lists all storage pools in a model.

<h2 id="heading--storage-constraints">Storage constraints</h2>

Several properties are used to dictate how storage is allocated:

-   'pool': class of storage
-   'size': size of each volume
-   'count': number of volumes

The default pool (e.g. 'ebs' for AWS, 'cinder' for OpenStack) is given by:

``` text
juju model-config storage-default-block-source
```

These properties are specified as constraints with the `juju deploy` or `juju add-storage` commands.

<h3 id="heading--juju-deploy">juju deploy</h3>

``` text
juju deploy <charm> [--storage <label>=<pool>,<size>,<count>]
```

Notes:

-   `label` is a string taken from the charm itself. It encapsulates a specific storage option/feature. Sometimes called a *store*.
-   `--storage` may be specified multiple times, to support multiple labels.

If at least one constraint is specified the following default values come into effect:

-   'pool' = the default pool (see above)
-   'size' = determined from the charm's minimum storage size, or 1GiB if the charm does not specify a minimum
-   'count' = the minimum number required by the charm, or '1' if the storage is optional

In the absence of any storage constraints, the storage will be put on the root filesystem.

<h3 id="heading--juju-add-storage">juju add-storage</h3>

``` text
juju add-storage <unit> <label>[=<pool>,<size>,<count>]
```

As with `juju add-unit` the storage parameters used are taken from the `juju deploy` command corresponding to the unit.

<h3 id="heading--examples">Examples</h3>

To deploy PostgreSQL with one instance (count) of 100GiB, via the charm's 'pgdata' storage label, using the default storage pool:

``` text
juju deploy postgresql --storage pgdata=100G
```

Assuming an AWS model, a more explicit, but equivalent, command is:

``` text
juju deploy postgresql --storage pgdata=ebs,100G,1
```

<h2 id="heading--storage-pools">Storage pools</h2>

Use the `juju storage-pools` command to list the predefined storage pools as well as any custom ones that may have been created with the `juju create-storage-pool` command:

``` text
juju storage-pools
```

Here is sample output for a newly-added AWS model:

``` text
Name     Provider  Attrs
ebs      ebs
ebs-ssd  ebs       volume-type=ssd
loop     loop
rootfs   rootfs
tmpfs    tmpfs
```

[note]
The name given to a default storage pool will often be the same as the name of the storage provider upon which it is based.
[/note]

Depending on the storage provider (see [below](#heading--storage-providers)), custom storage pools can be created. In the case of AWS, the 'ebs' storage provider supports several configuration attributes:

-   'volume-type': volume type (i.e. magnetic, ssd, or provisioned-iops)
-   'encrypted': enable/disable disk encryption
-   'iops': IOPS per GiB

For example, to provision a 3000 IOPS volume (100GiB x 30IOPS/GiB) by first creating a custom storage pool and then having a newly deployed PostgreSQL use it for its database storage:

``` text
juju create-storage-pool iops ebs volume-type=provisioned-iops iops=30
juju deploy postgresql --storage pgdata=iops,100G
```

See [IOPS](https://en.wikipedia.org/wiki/IOPS) (Wikipedia) for background information.

<h2 id="heading--dynamic-storage">Dynamic storage</h2>

Most storage can be dynamically added to, and removed from, a unit. Some types of storage, however, cannot be dynamically managed. For instance, Juju cannot disassociate MAAS disks from their respective MAAS nodes. These types of static storage can only be requested at deployment time and will be removed when the machine is removed from the model.

Certain cloud providers may also impose restrictions when attaching storage. For example, attaching an EBS volume to an EC2 instance requires that they both reside within the same availability zone. If this is not the case, Juju will return an error.

When deploying an application or unit that requires storage, using machine placement (i.e. `--to`) requires that the assigned storage be dynamic. Juju will return an error if you try to deploy a unit to an existing machine, while also attempting to allocate static storage.

<h3 id="heading--adding-and-detaching-storage">Adding and detaching storage</h3>

Assuming the storage provider supports it, storage can be created and attached to a unit using `juju add-storage`. Juju will ensure the storage is allowed to attach to the unit's machine.

Charms can specify a maximum number of storage instances. In the case of the charm 'postgresql', a maximum of one is allowed for 'pgdata'. If an attempt is made to exceed it, Juju will return an error.

Dynamic storage can be detached from units using `juju detach-storage`.

Charms can also define a minimum number of storage instances. The postgresql charm specifies a minimum of zero for 'pgdata' whereas another charm may specify a different number. In any case, if detaching storage from a unit would bring the total number of storage instances below the minimum, Juju will return an error.

It is not possible to add new storage to a model without also attaching it to a unit. However, with the `juju import-filesystem` command, you can add storage to a model that has been previously released from a removed model.

<h4 id="heading--examples">Examples</h4>

To create a 32GiB EBS volume and attach it to unit 'ceph-osd/0' as its OSD storage:

``` text
juju add-storage ceph-osd/0 osd-devices=ebs,32G,1
```

Above, the volume was created in the same availability zone as the instance (a requirement).

To detach OSD device 'osd-devices/2' from a Ceph unit:

``` text
juju detach-storage osd-devices/2
```

[note type="caution"]
Detaching storage from a unit does not destroy the storage.
[/note]

<h3 id="heading--persistence">Persistence</h3>

As we saw, detaching storage does not destroy the storage. In addition, when a unit is removed from a model, and the unit has dynamic storage attached, the storage will be detached and left intact. This allows detached storage to be re-attached to an existing unit using `juju attach-storage`, or to a new unit using the `--attach-storage` flag of `juju deploy` or `juju add-unit`.

The underlying cloud's storage resource is normally destroyed by first detaching it and then using `juju remove-storage`. To remove storage from the model without destroying it the `--no-destroy` option must be used. Be wary of using the latter option as Juju will lose sight of the volume; it will only be visible from the cloud provider.

If an attempt is made to either attach or remove storage that is currently in use (i.e. it is attached to a unit) Juju will return an error. To remove currently attached storage from the model the `--force` option must be used.

Finally, a model cannot be destroyed while storage volumes remain without passing a special option (`--release-storage` to detach all volumes and `--destroy-storage` to remove all volumes). Naturally, this applies to the removal of a controller as well.

<h4 id="heading--examples">Examples</h4>

To attach existing storage 'osd-devices/7' to existing unit 'ceph-osd/1':

``` text
juju attach-storage ceph-osd/1 osd-devices/7
```

To deploy PostgreSQL with (detached) existing storage 'pgdata/0':

``` text
juju deploy postgresql --attach-storage pgdata/0
```

[note]
The `--attach-storage` and `-n` flags cannot be used together.
[/note]

To add a new Ceph OSD unit with (detached) existing storage 'osd-devices/2':

``` text
juju add-unit ceph-osd --attach-storage osd-devices/2
```

To remove already detached storage 'osd-devices/3' from the model. It will also be automatically destroyed on the cloud provider:

``` text
juju remove-storage osd-devices/3
```

To remove currently attached storage 'pgdata/1' from the model and prevent it from being destroyed on the cloud provider:

``` text
juju remove-storage --force --no-destroy pgdata/1
```

To upgrade the OSD journal of Ceph unit 'ceph-osd/0' from magnetic to solid state (SSD) and dispose of the unneeded original journal 'osd-journals/0':

``` text
juju add-storage ceph-osd/0 osd-journals=ebs-ssd,8G,1
juju detach-storage osd-journals/0
juju remove-storage osd-journals/0
```

To destroy a controller (and its models) along with all existing storage volumes:

``` text
juju destroy-controller lxd-controller --destroy-all-models --destroy-storage
```

To destroy a model while keeping intact all existing storage volumes:

``` text
juju destroy-model default --release-storage
```

Assuming the above model was LXD-based, to create a new model and import the released storage volume into it, giving it a storage name of 'pgdata':

``` text
juju add-model default
juju import-filesystem lxd juju:juju-7a544c-filesystem-0 pgdata
```

The determination of the provider ID (`juju:juju-7a544c-filesystem-0`) is dependent upon cloud type. Above, it is given by the backing LXD pool and the volume name (obtained with `lxc storage volume list <lxd-pool>`), all separated by a `:`. A provider ID from another cloud may look entirely different. The LXD storage provider and associated LXD pools are described in detail [below](#heading--lxd-lxd).

<h3 id="heading--cross-model-storage">Cross-model storage</h3>

Storage management is currently restricted to a single model, which means it is not possible to reuse storage from one model/controller in another. Also, when a model/controller is removed, all associated storage will be destroyed. Support for releasing storage from a model, and enlisting it into another, is planned for a future release.

<h3 id="heading--upgrading-charms">Upgrading charms</h3>

When upgrading a charm with the [juju upgrade-charm](https://docs.jujucharms.com/commands#heading--upgrade-charm) command, the existing storage constraints specified at deployment time will be preserved.

It is also possible to change the storage constraints and define new ones by passing the `--storage` flag to `juju upgrade-charm`. For example, if the 'pgdata' storage option did not exist in revision 1 of the postgresql charm, but was introduced in revision 2, when upgrading (from 1 to 2) you could do:

``` text
juju upgrade-charm postgresql --storage pgdata=10G
```

If such a constraint was not provided, 'rootfs' would be used (as described in the section on deploying with [storage constraints](#heading--juju-deploy)).

[note type="caution"]
Specifying new constraints may be necessary when upgrading to a revision of a charm that introduces new, required, storage options.
[/note]

<h2 id="heading--storage-providers">Storage providers</h2>

<h3 id="heading--generic-storage-providers">Generic storage providers</h3>

There are several cloud-independent storage providers, which are available to all types of models:

-   [loop](https://en.wikipedia.org/wiki/Loop_device)

    Block-type, creates a file on the unit's root filesystem, associates a loop device with it. The loop device is provided to the charm.

-   [rootfs](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)

    Filesystem-type, creates a sub-directory on the unit's root filesystem for the unit/charm to use. Works with Kubernetes models.

-   [tmpfs](https://en.wikipedia.org/wiki/Tmpfs)

    Filesystem-type, creates a temporary file storage facility that appears as a mounted file system but is stored in volatile memory. Works with Kubernetes models.

Loop devices require extra configuration to be used within LXD. For that, please refer to [Loop devices and LXD](#heading--loop-devices-and-lxd) (below).

<!--
Providers 'rootfs' and 'tmpfs' are used, respectively, to map storage of a virtualisation host to the root disk or to an in-memory filesystem.
-->

<h3 id="heading--awsebs-ebs">AWS/EBS (ebs)</h3>

AWS-based models have access to the 'ebs' storage provider, which supports the following pool attributes:

-   **volume-type**

    Specifies the EBS volume type to create. You can use either the EBS volume type names, or synonyms defined by Juju (in parentheses):

    -   standard (magnetic)
    -   gp2 (ssd)
    -   io1 (provisioned-iops)
    -   st1 (optimized-hdd)
    -   sc1 (cold-storage)

    Juju's default pool (also called 'ebs') uses gp2/ssd as its own default.

-   **iops**

    The number of IOPS for provisioned-iops volume types. There are restrictions on minimum and maximum IOPS, as a ratio of the size of volumes. See [Provisioned IOPS (SSD) Volumes](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html#EBSVolumeTypes_piops) for more information.

-   **encrypted**

    Boolean (true|false); indicates whether created volumes are encrypted.

For detailed information regarding EBS volume types, see the [AWS EBS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html).

<h3 id="heading--openstackcinder-cinder">OpenStack/Cinder (cinder)</h3>

OpenStack-based models have access to the 'cinder' storage provider.

The 'cinder' storage provider has a 'volume-type' configuration option whose value is the name of any volume type registered with Cinder.

<h3 id="heading--maas-maas">MAAS (maas)</h3>

MAAS has support for discovering information about machine disks, and an API for acquiring nodes with specified disk parameters. Juju's MAAS provider has an integrated 'maas' storage provider. This storage provider is static-only; it is only possible to deploy charms using 'maas' storage to a new machine in MAAS, and not to an existing machine, as described in the section on dynamic storage.

The MAAS provider currently has a single configuration attribute:

-   **tags**

    A comma-separated list of tags to match on the disks in MAAS. For example, you might tag some disks as 'fast'; you can then create a storage pool in Juju that will draw from the disks with those tags.

<h3 id="heading--microsoft-azure-azure">Microsoft Azure (azure)</h3>

Azure-based models have access to the 'azure' storage provider.

The 'azure' storage provider has an 'account-type' configuration option that accepts one of two values: 'Standard_LRS' and 'Premium_LRS'. These are, respectively, associated with defined Juju pools 'azure' and 'azure-premium'.

Newly-created models configured in this way use "Azure Managed Disks". See [Azure Managed Disks Overview](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/managed-disks-overview) for information on what this entails (in particular, what the difference is between standard and premium disk types).

<h3 id="heading--google-compute-engine-gce">Google Compute Engine (gce)</h3>

Google-based models have access to the 'gce' storage provider. The GCE provider does not currently have any specific configuration options.

<h3 id="heading--oracle-compute-cloud-oracle">Oracle Compute Cloud (oracle)</h3>

Oracle-based models have access to the 'oracle' storage provider. The Oracle provider currently supports a single pool configuration attribute:

-   **volume-type**

    Volume type, a value of 'default' or 'latency'. Use 'latency' for low-latency, high IOPS requirements, and 'default' otherwise.

    For convenience, the Oracle provider registers two predefined pools:

    -   'oracle' (volume type is 'default')
    -   'oracle-latency' (volume type is 'latency').

<h3 id="heading--lxd-lxd">LXD (lxd)</h3>

[note]
The regular package archives for Ubuntu 14.04 LTS (Trusty) and Ubuntu 16.04 LTS (Xenial) do not include a version of LXD that has the 'lxd' storage provider feature. You will need at least version 2.16. See the [Using LXD with Juju](/t/using-lxd-with-juju/1093) page for installation help.
[/note]

LXD-based models have access to the 'lxd' storage provider. The LXD provider has two configuration options:

-   **driver**

    This is the LXD storage driver (e.g. zfs, btrfs, lvm, ceph).

-   **lxd-pool**

    The name to give to the corresponding storage pool in LXD.

Any other parameters will be passed to LXD (e.g. zfs.pool_name). See upstream [LXD storage configuration](https://github.com/lxc/lxd/blob/master/doc/storage.md) for LXD storage parameters.

Every LXD-based model comes with a minimum of one LXD-specific Juju storage pool called 'lxd'. If ZFS and/or BTRFS are present when the controller is created then pools 'lxd-zfs' and/or 'lxd-btrfs' will also be available. The following output to the `juju storage-pools` command shows all three Juju LXD-specific pools:

``` text
Name       Provider  Attrs
loop       loop
lxd        lxd
lxd-btrfs  lxd       driver=btrfs lxd-pool=juju-btrfs
lxd-zfs    lxd       driver=zfs lxd-pool=juju-zfs zfs.pool_name=juju-lxd
rootfs     rootfs
tmpfs      tmpfs
```

As can be inferred from the above output, for each Juju storage pool based on the 'lxd' storage provider there is a LXD storage pool that gets created. It is these LXD pools that will house the actual volumes.

The LXD pool corresponding to the Juju 'lxd' pool doesn't get created until the latter is used for the first time (typically via the `juju deploy` command). It is called simply 'juju'.

The command `lxc storage list` is used to list LXD storage pools. A full "contingent" of LXD non-custom storage pools would like like this:

``` text
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

To be clear, the three Juju-related pools above are for storing *volumes* that Juju applications can use. The fourth 'default' pool is the standard LXD storage pool where the actual *containers* (operating systems) live.

To deploy an application, refer to the pool as usual. Here we deploy PostgreSQL using the 'lxd' Juju storage pool, which, in turn, uses the 'juju' LXD storage pool:

``` text
juju deploy postgresql --storage pgdata=lxd,8G
```

See [Using LXD with Juju](/t/using-lxd-with-juju/1093) for how to use LXD in conjunction with Juju, including the use of ZFS as an alternative filesystem.

<h3 id="heading--kubernetes-kubernetes">Kubernetes (kubernetes)</h3>

Kubernetes-based models have access to the 'kubernetes' storage provider, which supports the following pool attributes:

-   **storage-class**

    The storage class for the Kubernetes cluster to use:

    -   `juju-unit-storage`
    -   `juju-charm-storage`
    -   `microk8s-hostpath`

-   **storage-provisioner**

    The Kubernetes storage provisioner. For example:

    -   `kubernetes.io/no-provisioner`
    -   `kubernetes.io/aws-ebs`
    -   `kubernetes.io/gce-pd`

-   **parameters.type**

    Extra parameters. For example:

    -   `gp2`
    -   `pd-standard`

Using storage with Kubernetes is covered on the [Persistent storage and Kubernetes](/t/persistent-storage-and-kubernetes/1078) page.

<h4 id="heading--loop-devices-and-lxd">Loop devices and LXD</h4>

LXD (localhost) does not officially support attaching loopback devices for storage out of the box. However, with some configuration you can make this work.

Each container uses the 'default' LXD profile, but also uses a model-specific profile with the name `juju-<model-name>`. Editing a profile will affect all of the containers using it, so you can add loop devices to all LXD containers by editing the 'default' profile, or you can scope it to a model.

To add loop devices to your container, add entries to the 'default', or model-specific, profile, with `lxc profile edit <profile>`:

``` yaml
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

Doing so will expose the loop devices so the container can acquire them via the `losetup` command. However, it is not sufficient to enable the container to mount filesystems onto the loop devices. One way to achieve that is to make the container "privileged" by adding:

``` yaml
config:
  security.privileged: "true"
```

<h2 id="heading--writing-charms">Writing charms</h2>

For guidance on how to create a charm that uses these storage features see [Writing charms that use storage](/t/writing-charms-that-use-storage/1128).

<!-- LINKS -->
