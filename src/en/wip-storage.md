# Storage support (work in progress)

!!! Note: This page is a draft of the storage support to be included in a future version of juju-core. When the feature lands in a stable version, this information will be moved to appropriate parts of the existing documentation. _*NONE OF THE INSTRUCTIONS HERE ARE GUARANTEED TO WORK*_

!!! Note: For testing purposes, please see the #Testing section for requirements of storage support and notes on the current implementation


Many services require access to a storage resource of some form. Juju charms can declare what storage requirements  they have,
and these can be allocated when the charm is deployed. Charms may declare several types of storage requirement (e.g. for persistent storage and an additional cache) so that resources can be allocated at a more granular level.

## Deploying a charm with storage requirements

For the purposes of demonstration, we will use a charm which has been modified to support storage:
https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk

### Preparing storage
By default, charms with storage requirements will allocate those resources on the root filesystem of the unit where they are deployed.
To make use of additional storage resources, Juju needs to know what they are. Some providers (eg EC2) support generic default storage pools (see #REF  the documentation on provider support), but in the case of no default support or a desire to be more specific, Juju has the `juju storage` command and subcommands to create and manage storage resources

```
juju storage 
juju storage list
juju storage pool list
juju storage pool create
juju storage volume list
```



### deploying with storage constraints

As previously mentioned, a charm which requires storage will automatically allocate the default storage (unit filesystem) by default. It is possible to instead specify the storage to be used when the service is deployed, using constraints.

The constraints can specify the type/pool, size and count, of the storage required. At least one of the constraints must be specified, but otherwise they are all optional.

If pool is not specified, then Juju will select the default storage provider for the current environment (e.g. cinder for openstack, ebs for ec2, loop for local).
If size is not specified, then Juju will use the minimum size specified in the charm's storage metadata, or 1GiB if the metadata does not specify.
If count is not specified, then Juju will create a single instance of the store.

```
juju deploy <charm> --storage <label>=<pool>,<size>,count
```

For example, to deploy the postgresql service and have it use the unit’s local filesystem for 10 gibibytes of storage for its ‘data’ storage requirement:

```
juju deploy cs:~axwalk/postgresql --storage data=rootfs,10G
```

We can also deploy using a local loop device

```
juju deploy cs:~axwalk/postgresql --storage data=loop,5G
```

If the size is omitted...

```
juju deploy cs:~axwalk/postgresql --storage data=rootfs
```

Juju will use a default size of 1GiB, unless the charm itself has specified a minimum value, in which case that will be used.

When deploying on a provider which supplies storage, the supported storage pool types may be used in addition to ‘loop’ and ‘rootfs’. For example, on using Amazon’s EC2 provider, we can make use of the default ‘ebs’ storage pool

```
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G
```

Cloud providers may support more than one type of storage. For example, in the case of EC2, we can also make use of the ebd-ssd pool, which is SSD-based storage, and hence faster and better for some storage requirements.

```
juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd
```

We can also merely specify the size, in which case Juju will use the default pool for the selected environment.  E.g. 

```
juju deploy cs:~axwalk/postgresql --storage data=10G
```

Which, on the EC2 provider, will create a 10 gibibyte volume in the ‘ebs’ pool.

Charms may declare multiple types of storage, in which case they may all be specified using the constraint, or some or all can be omitted to accept the default values:


```
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G cache=ebs-ssd
```

### Persistence (incomplete!)

Some providers have the option to detach storage from the lifespan of the instance(s) which created/used it. This means that even after services have been removed, the storage and its contents still exist in your cloud, which may be useful for backup, recovery or transport purposes. Juju will not allow you to completely destroy an environment which contains such storage (except by using the --force option). To create persistent volumes, create a storage pool with the "persistent" attribute set to "true". Persistent volumes are currently supported by the EBS and Cinder storage providers. Currently, all Cinder volumes are considered persistent, regardless of whether the pool is configured as such.

Juju does not currently provide any means of decomissioning persistent storage, so you must do this manually after force-destroying the environment. This will be rectified in a future version of Juju.

### Provider support

All environment providers support the following storage providers:

- loop

    block-type, creates a file in the agent data-dir and attaches a loop device
    to it. See the Known Limitations section below for a comment on using the
    loop storage provider with local/LXC.

- rootfs

    filesystem-type, creates a sub-directory in the agent's data-dir for the
    unit/charm to use

- tmpfs

    filesystem-type, creates a tmpfs

Additionally, native storage providers exist for the EC2 (ebs), OpenStack
(cinder) and MAAS (maas) providers.

#### EC2/EBS

The EC2/EBS provider currently supports the following pool configuration attributes:

- volume-type

    specifies the EBS volume type to create. You can use either the EBS volume
    type names, or synonyms defined by Juju (in parentheses): gp2 (ssd), io1
    (provisioned-iops), standard (magnetic). By default, magnetic/standard
    volumes will be created. An 'ebs-ssd' pool is created in all EC2
    environments, which defaults the volume type to ssd/gp2 instead.

- iops

    the number of IOPS for provisioned-iops volume types. There are
    restrictions on minimum and maximum IOPS, as a ratio of the size of
    volumes; see the URL below for more information.

- encrypted

    true|false, indicating whether or not to encrypt volumes created by the pool.

For information regarding EBS volume types, see http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html.

#### OpenStack/Cinder

The OpenStack/Cinder provider does not currently have any configuration.

#### MAAS

The MAAS provider currently has a single configuration attribute:

- tags

    a comma-separated list of tags to match on the disks in MAAS. For example,
    you might tag some disks as "fast"; you can then create a storage pool in
    Juju that will draw from the disks with those tags.

## Writing a charm which supports storage



### Adding storage to the metadata.yaml

Storage requirements _may_ be added to the 'metadata.yaml' of the charm as follows:

```
storage:
  data:
    type: filesystem
    description: junk storage
    shared: false # not yet supported, see description below
    read-only: false # not yet supported, see description below
    minimum-size: 100M
    location: /srv/data
```

Here the charm is asking for storage it is calling 'data', and it further defines a type and location. It is possible to specify as many entries as desired for storage, and all but the 'type' key are optional. The 'type' attribute specifies the type of the storage: filesystem or block (i.e. block device/disk). The 'minimum-size' attribute specifies the minimum size of the store, overriding the default of 1GiB if the user does not specify a size. The location specifies the path at which to mount filesystem-type storage. The 'read-only' and 'shared' attributes are currently not handled. Support will be added in a future version of Juju.

By default, stores are singletons; a charm will have exactly one of the specified store. It is also possible for a charm to specify storage that may have multiple instantiations, e.g. multiple disks to add to a pool. To do this, you can specify the "multiple" attribute:

```
storage:
  disks:
    type: block
    multiple:
      range: 0-10
```

The above says that the charm may have anywhere from zero to ten block devices allocated to the 'disks' store. The formats supported by "range" are: m (a fixed number), m-n (an explicit range), and m- (a minimum number). 

### Implementing hooks

for each storage entity contained in the metadata.yaml, the following hooks may be implemented:

- *-storage-attached

- *-storage-detaching

Each hook is prefixed with the name of the store, similar to how relation hooks are prefixed
with the name of the relation. So, for example, if we had specified a need for storage labelled
'data', we would probably want to implement the hook 'data-storage-attached', which might look
something like:

```
mountpoint=$(storage-get location)
sed -i /etc/myservice.conf "s,MOUNTPOINT,$mountpoint"
```

The storage-attached hooks will be run before the install and upgrade-charm hooks, so that installation and upgrade routines may use the storage. The storage-detaching hooks will be run before storage is detached, and always before the stop hook is run, to allow the charm to gracefully release resources before they are removed and before the unit terminates.

### Additional considerations



## TESTING

The storage feature is available from Juju 1.24 onwards.

EXAMPLE
--------------

There is a modified version of the PostgreSQL charm using the storage feature. You can find the branch at
 https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk.

Here is how you can go about using the new feature.

```
$ juju deploy cs:~axwalk/postgresql pg-rootfs
$ juju deploy cs:~axwalk/postgresql --storage data=loop,1G pg-loop
$ juju deploy cs:~axwalk/postgresql --storage data=ebs,10G pg-magnetic
$ juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd,10G pg-ssd
$ juju storage pool create ebs-iops ebs volume-type=provisioned-iops iops=300
$ juju deploy cs:~axwalk/postgresql --storage data=ebs-iops,10G pg-iops
$ sleep $AWHILE
$ juju storage list
    [Storage]     
    UNIT          ID     LOCATION  STATUS   PERSISTENT
    pg-iops/0     data/4           pending  false      
    pg-loop/0     data/1 /srv/data attached false      
    pg-magnetic/0 data/2 /srv/data attached false      
    pg-rootfs/0   data/0 /srv/data attached false      
    pg-ssd/0      data/3 /srv/data attached false
```

IMPLEMENTED FEATURES
---------------------------------------

- Deploy services with storage (requires a charm that declares storage requirements)

  - block-device storage, i.e. no filesystem, charm can do with the block device what it wants

  - filesystem storage, i.e. a mounted filesystem, may be local or remote

  - volume-backed filesystems, Juju will manage a filesystem on block-device storage

- Add machine with volumes (mostly used for testing)

  - syntax is "juju add-machine --disks=<pool,size,count>

- X-storage-attached hook, notifying units of storage attachment

- Storage hook tools:

  - storage-get, enables units to enquire about properties of attached storage

  - storage-add, enables units to allocate additional storage instances, up to
    the maximum range specified in the charm metadata

- "juju storage" CLI:

  - list storage instances/attachments

  - list volumes/attachments

  - list and create storage pools

  - add storage instances to units

- Unit/machine placement, for charms with dynamic storage

- MAAS storage provider

  - this is a "static" storage provider; it only supports acquiring storage
    at the same time as acquiring a machine.

  - requires MAAS 1.8+

- Charm upgrades now check for incompatible storage changes:

  - type, read-only, shared, location may not be changed

  - range cannot be contracted, i.e. the minimum may not be
    increased, nor the maximium decreased.

- Read-only filesystems can be created, as well as read-only loop device
  attachments.

KNOWN LIMITATIONS
-----------------------------------------

- Persistent storage destruction. If you use persistent storage, you must use
  "destroy-environment --force" and manually destroy the storage through your
  cloud's management UI.

- It is not currently possible to upgrade a charm if it adds required storage,
  as there is no way to specify the storage constraints at upgrade time. Until
  such support is added, it is only possible to upgrade a charm from having no
  storage to having optional storage (i.e. minimum count of 0), and adding the
  storage after upgrade.

- Charm deployment currently does not check for mount-point conflicts.

- Shared storage is not yet supported.

- storage-add command: this is being worked on now, and will be ready for Juju 1.25.

- For LXC (local provider or not), you must currently set "allow-lxc-loop-mounts"
  for the loop storage provider to work. With the default AppArmor profile,
  LXC does not permit containers to mount loop devices. By setting
  allow-lxc-loop-mounts=true, you are explicitly enabling this, and access to
  all loop devices on the host.

- For LXC only, loop devices should but are not currently marked as
  "persistent". This is because loop devices remain in use even after the
  container is destroyed. As such, you will need to use "losetup" to detach
  loop devices that were allocated by containers.

