# Writing charms that use storage

The storage feature can be implemented in any charm running on Juju version
1.25 or later.  For services that can take advantage of block storage or other
types  of storage there are two additional storage hooks for the code to react
to storage changes.

If you are interested in information of how to deploy charms that use the
storage feature read the [Using Charms](./charms-storage.html) document.

## Adding storage

Storage requirements _may_ be added to the `metadata.yaml` file of the charm as
follows:

```yaml
storage:
  data:
    type: filesystem
    description: junk storage
    shared: false # not yet supported, see description below
    read-only: false # not yet supported, see description below
    minimum-size: 100M
    location: /srv/data
```

In this definition the charm is asking for storage it is calling 'data', and it
further defines a type and location. It is possible to specify as many entries
as desired for storage, and all but the 'type' key are optional. The 'type'
attribute specifies the type of the storage: filesystem or block (i.e. block
device/disk). The 'minimum-size' attribute specifies the minimum size of the
store, overriding the default of 1GiB if the user does not specify a size. The
location specifies the path at which to mount filesystem-type storage. The
'read-only' and 'shared' attributes are currently not handled. Support will be
added in a future version of Juju.

A [filesystem-type](./charms-storage.html#provider-support) store yields a
directory in which the charm may store files.
[Block-type](./charms-storage.html#ec2/ebs-(ebs)) stores yield raw block
devices -- typically disks or logical volumes. If the charm specifies a
filesystem-type store, and the storage provider supports provisioning only
disks, then a disk will be created, attached, partitioned, and a filesystem
created on top. The filesystem will be presented to the charm, and rest of the
details will be managed by Juju.

By default, stores are singletons; a charm will have exactly one of the
specified store. It is also possible for a charm to specify storage that may
have multiple instantiations, e.g. multiple disks to add to a pool. To do this,
you can specify the "multiple" attribute:

```yaml
storage:
  disks:
    type: block
    multiple:
      range: 0-10
```

The definition above indicates that the charm may have anywhere from zero to ten
block devices allocated to the 'disks' store. The formats supported by "range"
are: m (a fixed number), m-n (an explicit range), and m- (a minimum number).

Unless a number is explicitly specified during deployment, units of the service
will be allocated the minimum number of storage instances specified in the charm
metadata. It is then possible to add instances (up to the maximum) by using the
`juju storage add` command, or using the `storage-add` hook tool.

## Storage hooks

For each storage entity defined in the `metadata.yaml` file, the following hooks
may be implemented:

- [[name]-storage-attached](./reference-charm-hooks.html#[name]-storage-attached)

- [[name]-storage-detaching](.reference-charm-hooks.html#[name]-storage-detaching)

Each hook is prefixed with the name of the store, similar to how relation hooks
are prefixed with the name of the relation. So, for example, if we had specified
a need for storage labelled 'data', we would probably want to implement the hook
'data-storage-attached', which might look something like:

```bash
#!/bin/bash
set -eux
mountpoint=$(storage-get location)
sed -i /etc/myservice.conf "s,MOUNTPOINT,$mountpoint"
status-set maintenance “Storage ready and mounted.”
```

The `[name]-storage-attached` hooks will be run before the install hook, so that
the installation routine may use the storage. The `[name]-storage-detaching`
hook will be run before storage is detached, and always before the stop hook is
run, to allow the charm to gracefully release resources before they are removed
and before the unit terminates.

There are several hook tools available for dealing with storage within a
charm, described below

- [`storage-list`](./reference-hook-tools.html#storage-list)

    `storage-list` may be used to list storage instances that are attached
    to the unit. The names returned may be passed through to `storage-get`.

- [`storage-get`](./reference-hook-tools.html#storage-get)

    `storage-get` may be used to obtain information about storage being
    attached to, or detaching from, the unit. If the executing hook is a
    storage hook, information about the storage related to the hook will
    be reported; this may be overridden by specifying the name of the
    storage as reported by storage-list, and must be specified for
    non-storage hooks.

    `storage-get` should be used to identify the storage location during
    storage-attached and storage-detaching hooks. The exception to this
    is when the charm specifies a static location for singleton stores.

- [`storage-add`](./reference-hook-tools.html#storage-add)

    `storage-add` may be used to add storage to the unit. The tool takes
    the name of the storage (as in the charm metadata), and optionally
    the number of storage instances to add; by default it will add a
    single instance.

### Future work

#### Persistent storage / detachment / reattachment

Some providers have the option to detach storage from the lifespan of the
instance(s) which created/used it. This means that even after services have been
removed, the storage and its contents still exist in your cloud, which may be
useful for backup, recovery or transport purposes.

For now, storage is always bound to a machine or unit, depending on how it is
created. In the future, we will provide an interface for unbinding storage from
the machine or unit, so that it is destroyed only when the environment is
destroyed. This will make it possible to detach/reattach storage as desired.

#### Shared storage

Some providers, typically network filesystems, permit attaching storage to
multiple machines. We intend to support multiple attachment within Juju. Shared
storage will be assigned to a service, and each unit of the service will attach
to the same shared storage instance.

### Known limitations

- It is not currently possible to upgrade a charm if it adds required storage,
  as there is no way to specify the storage constraints at upgrade time. Until
  such support is added, it is only possible to upgrade a charm from having no
  storage to having optional storage (i.e. minimum count of 0), and adding the
  storage after upgrade.

- For LXC (local provider or not), you must currently set
  ["allow-lxc-loop-mounts"](./config-general.html#alphabetical-list-of-general-configuration-values)
  to "true" for the lxc provider to work. With the default AppArmor profile,
  LXC does not permit containers to mount loop devices. By setting
  `allow-lxc-loop-mounts=true`, you are explicitly enabling this, and access
  to all loop devices on the host.
