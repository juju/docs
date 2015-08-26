# Storage support

Many services require access to a storage resource of some form. Juju charms can declare what storage requirements  they have,
and these can be allocated when the charm is deployed. Charms may declare several types of storage requirement (e.g. for
persistent storage and an additional cache) so that resources can be allocated at a more granular level.

Storage support should be considered stable as of Juju version 1.25.

## Deploying a charm with storage requirements

For the purposes of demonstration, we will use a charm which has been modified to support storage:
[cs:~axwalk/postgresql](https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk).

### Preparing storage
By default, charms with storage requirements will allocate those resources on the root filesystem of the unit where they are deployed.
To make use of additional storage resources, Juju needs to know what they are. Some providers (e.g. EC2) support generic default storage pools (see the documentation on [provider support](#provider-support)), but in the case of no default support or a desire to be more specific, Juju has the `juju storage` command and subcommands to create and manage storage resources

```bash
juju storage --help
juju storage add
juju storage list
juju storage pool list
juju storage pool create
juju storage volume list
```

### Deploying with storage constraints

As previously mentioned, a charm which requires storage will automatically allocate the default storage (unit filesystem) by default. It is possible to instead specify the storage to be used when the service is deployed, using constraints.

The constraints can specify the type/pool, size and count, of the storage required. At least one of the constraints must be specified, but otherwise they are all optional.

If pool is not specified, then Juju will select the default storage provider for the current environment (e.g. cinder for openstack, ebs for ec2, loop for local).
If size is not specified, then Juju will use the minimum size specified in the charm's storage metadata, or 1GiB if the metadata does not specify.
If count is not specified, then Juju will create a single instance of the store.

```bash
juju deploy <charm> --storage <label>=<pool>,<size>,count
```

For example, to deploy the postgresql service and have it use the unit’s local filesystem for 10 gibibytes of storage for its ‘data’ storage requirement:

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

Juju will use a default size of 1GiB, unless the charm itself has specified a minimum value, in which case that will be used.

When deploying on a provider which supplies storage, the supported storage pool types may be used in addition to ‘loop’ and ‘rootfs’. For example, on using Amazon’s EC2 provider, we can make use of the default ‘ebs’ storage pool

```bash
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G
```

Cloud providers may support more than one type of storage. For example, in the case of EC2, we can also make use of the ebd-ssd pool, which is SSD-based storage, and hence faster and better for some storage requirements.

```bash
juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd
```

We can also merely specify the size, in which case Juju will use the default pool for the selected environment.  E.g. 

```bash
juju deploy cs:~axwalk/postgresql --storage data=10G
```

Which, on the EC2 provider, will create a 10 gibibyte volume in the ‘ebs’ pool.

Charms may declare multiple types of storage, in which case they may all be specified using the constraint, or some or all can be omitted to accept the default values:


```bash
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G cache=ebs-ssd
```

#### Placement

If the storage provider supports dynamically adding storage to a machine, then
a service/unit deployed with storage may be placed on an existing machine. Not
all providers support dynamic storage; for example, MAAS does not as it is
providing an interface to physical hardware.

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

Additionally, native storage providers exist for the several major cloud
providers, described below.

#### EC2/EBS (ebs)

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

For information regarding EBS volume types, see [the EBS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html).

#### OpenStack/Cinder (cinder)

The OpenStack/Cinder provider does not currently have any configuration.

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

The Microsoft Azure provider does not currently have any configuration.

#### Google Compute Engine (gce)

The Google Compute Engine provider does not currently have any configuration.

## Writing a charm which supports storage

### Adding storage to the metadata.yaml

Storage requirements _may_ be added to the 'metadata.yaml' of the charm as follows:

```no-highlight
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

A filesystem-type store yields a directory in which the charm may store files. Block-type stores yield raw block devices -- typically disks or logical volumes. If the charm specifies a filesystem-type store, and the
storage provider supports provisioning only disks, then a disk will be created, attached, partitioned, and a filesystem created on top. The filesystem will be presented to the charm, and rest of the details will be
managed by Juju.

By default, stores are singletons; a charm will have exactly one of the specified store. It is also possible for a charm to specify storage that may have multiple instantiations, e.g. multiple disks to add to a pool. To do this, you can specify the "multiple" attribute:

```no-highlight
storage:
  disks:
    type: block
    multiple:
      range: 0-10
```

The above says that the charm may have anywhere from zero to ten block devices allocated to the 'disks' store. The formats supported by "range" are: m (a fixed number), m-n (an explicit range), and m- (a minimum number). 

Unless a number is explicitly specified during deployment, units of the service will be allocated the minimum number of storage instances specified in the charm metadata. It is then possible to add instances (up to the
maximum) by using the `juju storage add` command, or using the `storage-add` hook tool.

### Implementing hooks

for each storage entity contained in the metadata.yaml, the following hooks may be implemented:

- \*-storage-attached

- \*-storage-detaching

Each hook is prefixed with the name of the store, similar to how relation hooks are prefixed
with the name of the relation. So, for example, if we had specified a need for storage labelled
'data', we would probably want to implement the hook 'data-storage-attached', which might look
something like:

```no-highlight
mountpoint=$(storage-get location)
sed -i /etc/myservice.conf "s,MOUNTPOINT,$mountpoint"
```

The storage-attached hooks will be run before the install and upgrade-charm
hooks, so that installation and upgrade routines may use the storage. The
storage-detaching hooks will be run before storage is detached, and always
before the stop hook is run, to allow the charm to gracefully release resources
before they are removed and before the unit terminates.

There are several hook tools available for dealing with storage within a
charm, described below

- storage-list

    storage-list may be used to list storage instances that are attached
    to the unit. The names returned may be passed through to storage-get.

- storage-get

    storage-get may be used to obtain information about storage attached
    to the unit. If the executing hook is a storage hook, information
    about the storage related to the hook will be reported; this may be
    overridden by specifying the name of the storage as reported by
    storage-list, and must be specified for non-storage hooks.

- storage-add

    storage-add may be used to add storage to the unit. The tool takes
    the name of the storage (as in the charm metadata), and optionally
    the number of storage instances to add; by default it will add a
    single instance.


### Example

There is a modified version of the PostgreSQL charm using the storage feature. You can find the branch at
 [https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk](https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk).

Here is how you can go about using the new feature.

```no-highlight
juju deploy cs:~axwalk/postgresql pg-rootfs
juju deploy cs:~axwalk/postgresql --storage data=loop,1G pg-loop
juju deploy cs:~axwalk/postgresql --storage data=ebs,10G pg-magnetic
juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd,10G pg-ssd
juju storage pool create ebs-iops ebs volume-type=provisioned-iops iops=300
juju deploy cs:~axwalk/postgresql --storage data=ebs-iops,10G pg-iops
sleep $AWHILE
juju storage list
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

### Future work

#### Persistent storage / detachment / reattachment

Some providers have the option to detach storage from the lifespan of the instance(s) which created/used it. This means that even after
services have been removed, the storage and its contents still exist in your cloud, which may be useful for backup, recovery or transport
purposes.

For now, storage is always bound to a machine or unit, depending on how it is created. In the future, we will provide an interface for
unbinding storage from the machine or unit, so that it is destroyed only when the environment is destroyed. This will make it possible
to detach/reattach storage as desired.

#### Shared storage

Some providers, typically network filesystems, permit attaching storage to multiple machines. We intend to support multiple attachment
within Juju. Shared storage will be assigned to a service, and each unit of the service will attach to the same shared storage instance.

### Known limitations

- It is not currently possible to upgrade a charm if it adds required storage,
  as there is no way to specify the storage constraints at upgrade time. Until
  such support is added, it is only possible to upgrade a charm from having no
  storage to having optional storage (i.e. minimum count of 0), and adding the
  storage after upgrade.

- For LXC (local provider or not), you must currently set "allow-lxc-loop-mounts"
  for the loop storage provider to work. With the default AppArmor profile,
  LXC does not permit containers to mount loop devices. By setting
  allow-lxc-loop-mounts=true, you are explicitly enabling this, and access to
  all loop devices on the host.

