# Storage support (work in progress)

!!! Note: This page is a draft of the storage support to be included in a future version of juju-core. When the feature lands in a stable version, this information will be moved to appropriate parts of the existing documentation.

> for testing purposes, please see #REF #Testing for requirements of storage support and notes on the current implementation


Many services require access to a storage resource of some form. Juju charms can declare what storage requirements  they have,
and these can be allocated when the charm is deployed. Charms may declare several types of storage requirement (e.g. for persistent storage and an additional cache) so that resources can be allocated at a more granular level.

## Deploying a charm with storage requirements

For the purposes of demonstration, we will use a charm which has been modified to support storage:
https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk

### Preparing storage
By default, charms with storage requirements will allocate those resources on the root filesystem of the unit where they are deployed.
To make use of additional storage resources, Juju needs to know what they are. Some providers (eg EC2) support generic default storage pools (see #REF  the documentation on provider support), but in the case of no default support or a desire to be more specific, Juju has the `juju storage` command and subcommands to create and manage storage resources

juju storage 
juju storage list
juju storage pool list
juju storage pool create
juju storage volume list



### deploying with storage constraints

As previously mentioned, a charm which requires storage will automatically allocate the default storage (unit filesystem) by default. It is possible to instead specify the storage to be used when the service is deployed, using constraints.

The constraints can specify the type/pool and size of the storage required.

```
juju deploy <charm> --storage <label>=<pool>,<size>
```

For example, to deploy the postgresql service and have it use the unit’s local filesystem for 10 Gigabytes of storage for its ‘data’ storage requirement:

    juju deploy cs:~axwalk/postgresql --storage data=rootfs,10G

We can also deploy using a local loopback mount

    juju deploy cs:~axwalk/postgresql --storage data=loop,5G

If the size is omitted...

    juju deploy cs:~axwalk/postgresql --storage data=rootfs

Juju will use a default size of 1G, unless the charm itself has specified a minimum value, in which case that will be used.

When deploying on a provider which supplies storage, the supported storage pool types may be used in addition to ‘loop’ and ‘rootfs’. For example, on using Amazon’s EC2 provider, we can make use of the default ‘ebs’ storage pool

    juju deploy cs:~axwalk/postgresql --storage data=ebs,10G

Cloud providers may support more than one type of storage. For example, in the case of EC2, we can also make use of the ebd-ssd pool, which is SSD-based storage, and hence faster and better for some storage requirements.

    juju deploy cs:~axwalk/postgresql --storage data=ebs-ssd

We can also merely specify the size, in which case Juju will use the default pool for the selected environment.  E.g. 
    juju deploy cs:~axwalk/postgresql --storage data=10G

Which, on the EC2 provider, will create a 10 gigabyte volume in the ‘ebs’ pool.

Charms may specify as many different types of storage as they require, in which case they may all be specified using the constraint, or some or all can be omitted to accept the default values:



    juju deploy cs:~axwalk/postgresql --storage data=ebs,10G cache=ebs-ssd

### Persistence (provisional)

Some providers have the option to detach storage from the lifespan of the instance(s) which created/used it. This means that even after services have been removed, the storage and its contents still exist in your cloud, which may be useful for backup, recovery or transport purposes. Juju will not allow you to completely destroy an environment which contains such storage (except by using the --force option). If this feature is enabled for storage pools, you must remember to decommission the storage manually.

### Provider-specific options

AWS/EC2

## Writing a charm which supports storage



### Adding storage to the metadata.yaml

Storage requirements _may_ be added to the 'metadata.yaml' of the charm as follows:

```
storage:
  data:
    type: filesystem
    location: /srv/data
```

Here the charm is asking for storage it is calling 'data', and it further defines a type and location. It is possible to specify as many entries as desired for storage, and all of the related keys are optional. E.g.

```
storage:
   data:
      type:filesystem
   cache:
```
### Implementing hooks

for each storage entity contained in the metadata.yaml, the following hooks may be implemented:

*-storage-attached
*-storage-detaching(not yet supported)

### Additional considerations



## TESTING

If you are so inclined to test this feature out, you will need to build from source (1.24+) and enable the feature with:
    export JUJU_DEV_FEATURE_FLAGS=storage
prior to bootstrapping.


EXAMPLE
--------------

There is a modified version of the PostgreSQL charm using the storage feature. You can find the branch at
 https://code.launchpad.net/~axwalk/charms/trusty/postgresql/trunk. If you're interested in seeing the changes required to the charm, they're here: http://bazaar.launchpad.net/~axwalk/charms/trusty/postgresql/trunk/revision/112 (4 lines of code, 4 lines of YAML - not bad!)

Anyway, here's how you can go about using the new feature.

$ export JUJU_DEV_FEATURE_FLAGS=storage
$ juju bootstrap --upload-tools # only because it's from source!
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


IMPLEMENTED FEATURES
---------------------------------------

- deploy services with storage (requires a charm that declares storage requirements)
  * block-device storage, i.e. no filesystem, charm can do with the block device what it wants
  * filesystem storage, i.e. a mounted filesystem, may be local or remote
  * volume-backed filesystems, Juju will manage a filesystem on block-device storage
- add machine with volumes (mostly used for testing)
  * syntax is "juju add-machine --disks=<pool,size,count>
- X-storage-attached hook, notifying units of storage attachment
- storage-get hook, enabling units to enquire about properties of the attached storage
- "juju storage" CLI:
  * list storage instances/attachments
  * list volumes/attachments
  * list and create storage pools
- probably other things which elude me

PROVIDER SUPPORT
-------------------------------

All environment providers support the following storage providers:
 - loop: block-kind, creates a file in the agent data-dir and attaches a loop device to it. See the caveats section below for a comment on using the loop storage provider with local/LXC.
 - rootfs: filesystem-kind, creates a sub-directory in the agent's data-dir for the unit/charm to use

We have implemented support for creating volumes in the ec2 provider, via the "ebs" storage provider. By default, the ebs provider will create cheap and nasty magnetic volumes. There is also an "ebs-ssd" storage pool provided OOTB that will create SSD (gp2) volumes. Finally, you can create your own pools if you like; the parameters for ebs are:
  - volume-type: may be "magnetic", "ssd", or "provisioned-iops"
  - iops: number of provisioned IOPS (requires volume-type=provisioned-iops)

Some storage providers also support a "persistent=<bool>" pool attribute. By using this, Juju will not tie the lifetime of storage entities (volumes, filesystems) to the lifetime of the machines that they are attached to. In EC2/EBS terms, a persistent volume is one without any attachments having the DeleteOnTermination flag set. Juju will not allow you to cleanly destroy an environment with persistent volumes; you may use "--force" to subvert this as usual, but please be aware that this will leak the resource.

UNIMPLEMENTED/CAVEATS
-----------------------------------------

- Storage destruction. Unit and machine destruction are prevented if they have attached storage, so if you're playing with storage expect to have to "destroy-environment --force".
- Unit agent will not yet wait for required storage before installing.
- Unit/machine placement is currently disabled if storage is specified.
- Doesn't matter at the moment due to above point, but charm deployment currently does not check for mount-point conflicts.
- Charm upgrade does not currently check for incompatible changes to storage requirements in deployed charms.
- No X-storage-detach(ing|ed) hook yet; it hopefully goes without saying, but anyway: since storage destruction isn't yet done, you won't be notified when storage is destroyed.
- storage-add command: this is being worked on now, and will hopefully be ready soon.
- OpenStack/Cinder storage provider. This is well under way, and should be ready within the next couple of weeks.
- MAAS storage provider. We've been syncing up with the MAAS team, but unfortunately we have not yet been able to schedule time to do the work. Work will commence as soon as the Cinder provider lands.
- For LXC (local provider or not), you must currently set "allow-lxc-loop-mounts" for the loop storage provider to work. With the default AppArmor profile, LXC does not permit containers to mount loop devices. By setting allow-lxc-loop-mounts=true, you are explicitly enabling this, and access to all loop devices on the host.
- For LXC only, loop devices should but are not currently marked as "persistent". This is because loop devices remain in use even after the container is destroyed. As such, you will need to use "losetup" to detach loop devices that were allocated by containers.

