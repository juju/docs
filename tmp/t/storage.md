(storage)=
# Storage

> See also:
> - [Juju | Manage storage](https://juju.is/docs/juju/manage-storage)

Many applications require access to some persistent storage. Juju and Ops provide a facility for working with and defining charms that require storage.

**Contents:**

- [Defining storage](#heading--defining-storage)
    - [Storage on Kubernetes](#heading--storage-on-kubernetes)
- [Storage events](#heading--storage-events)
- [Charm and Container Accessing to Storage](#heading--storage-model)
- [Scaling Storage](#heading--scaling-storage)



 <a href="#heading--defining-storage"><h2 id="heading--defining-storage">Defining storage</h2></a>
 
Charm storage is defined in the [`storage` key in `charmcraft.yaml`](https://juju.is/docs/sdk/charmcraft-yaml#heading--storage).

The `storage` map definition:

|     Field      |            Type             | Default  | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :------------: | :-------------------------: | :------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|     `type`     |          `string`           | required | Type of storage requested. Supported values are `block` or `filesystem`.<br/><br/>The `filesystem` type yields a directory in which the charm may store files. The `block` type yields a raw block device, typically disks or logical volumes.<br/><br/>If the charm specifies a `filesystem`-type store, and the storage provider supports provisioning only disks, then a disk will be created, attached, partitioned, and a filesystem created on top. The `filesystem` will be presented to the charm as normal. |
| `description`  |          `string`           |  `nil`   | Description of the storage requested                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|   `multiple`   | `map`<br/>(see table below) |  `nil`   | By default, stores are singletons; a charm will have exactly one of the specified stores. The `multiple` field specifies the number of storage instances to be requested.<br/><br/>Unless a number is explicitly specified during deployment, units of the application will be allocated the minimum number of storage instances specified in the charm metadata. It is then possible to add instances (up to the maximum) by using the `juju storage add command`.                                                  |
| `minimum-size` |          `string`           |  `1GiB`  | Size in the forms: `1.0G`, `1GiB`, `1.0GB`. Supported size multipliers are `M`, `G`, `T`, `P`, `E`, `Z`, `Y`. Not specifying a multiplier implies `M`.                                                                                                                                                                                                                                                                                                                                                               |
|   `location`   |          `string`           |  `nil`   | Specifies the mount location for `filesystem` stores. For multi-stores, the location acts as the parent directory for each mounted store.                                                                                                                                                                                                                                                                                                                                                                            |
|  `properties`  |         `string[]`          |  `nil`   | List of properties for the storage. Currently only `transient` is supported                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|  `shared`  |         `bool`          |  `false`   | True indicates that all units of the application share the storage.                                                                                                                                                                                                                                                                                                                                                                                                                                          |

The `multiple` map definition:

|  Field  |      Type      | Default | Description                                                                                                                                                                      |
| :-----: | :------------: | :-----: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `range` | `string`/`int` |   nil   | Value can be an `int` for a precise number, or a `string` in the forms: `m-n`, `m+`, `m-`, where `m` and `n` are of type `int`. <br/><br/>Examples: `range: 2` or `range: 0-10`. |

An example of a storage definition inside `metadata.yaml`:

```yaml
# ...
storage:
  # Name of this storage is 'data'
  data:
    type: filesystem
    description: junk storage
    minimum-size: 100M
    location: /srv/data
# ...
```

<a href="#heading--storage-on-kubernetes"><h3 id="heading--storage-on-kubernetes">Storage on Kubernetes</h3></a>

In addition to the above, there is some additional data required to define storage for Kubernetes charms. You will still need to define the top-level storage map (as above), but also specify which containers you would like the storage mounted into. Consider the following `metadata.yaml` snippet:

```yaml
# ...
containers:
  # define a container named "important-app"
  important-app:
    # use the "app-image" oci resource
    resource: app-image
    # mount our 'logs' store at /var/log/important-app
    # in the workload container
    mounts:
      - storage: logs
        location: /var/log/important-app
  # This is another container with no storage
  supporting-app:
    resource: supporting-app-image

storage:
  logs:
    type: filesystem
    # specifying location on the charm container is optional
    # when unspecified, defaults to /var/lib/juju/storage/<name>/<num>
# ...
```

The above snippet will ensure that both the `important-app` container and charm container inside each Pod has the `logs` store mounted. Under the hood, the `storage` map is translated into a series of [`PersistentVolume`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)s, mounted into Pods with [`PersistentVolumeClaim`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)s.

```{note}

The `location` attribute *must* be specified when mounting a storage into a workload container as shown above - this will dictate the mount point for the specific container. 

Optionally, developers can specify the `location` attribute on the storage itself, which will specify the mount point in the charm container. If left unset, the charm container will have the storage volume mounted at a predictable path at `/var/lib/juju/storage/<name>/<num>`, where `<num>` is the index of the storage. This defaults to `0`. 

For the above `metadata.yaml`, the charm container would have the storage available at: `/var/lib/juju/storage/logs/0`.

```


 <a href="#heading--storage-events"><h2 id="heading--storage-events">Storage events</h2></a>
 
 
There are two key events associated with storage:

|         Event name         |                                                 Event Type                                                 | Description                                                                                                                                                                                                                                                                                                                                                                                                                     |
| :------------------------: | :--------------------------------------------------------------------------------------------------------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<name>_storage_attached`  | [`StorageAttachedEvents`](https://ops.readthedocs.io/en/latest/index.html#ops.StorageAttachedEvent)  | This event is triggered when new storage is available for the charm to use. Callback methods bound to this event allow the charm to run code when storage has been added.<br/><br/>Such methods will be run before the `install` event fires, so that the installation routine may use the storage. The name prefix of this hook will depend on the storage key defined in the `metadata.yaml` file.                            |
| `<name>_storage_detaching` | [`StorageDetachingEvent`](https://ops.readthedocs.io/en/latest/index.html#ops.StorageDetachingEvent) | Callback methods bound to this event allow the charm to run code before storage is removed.<br/><br/>Such methods will be run before storage is detached, and always before the `stop` event fires, thereby allowing the charm to gracefully release resources before they are removed and before the unit terminates.<br/><br/>The name prefix of the hook will depend on the storage key defined in the `metadata.yaml` file. |

<a href="#heading--storage-model"><h2 id="heading--storage-model">Charm and Container Accessing to Storage</h2></a>

When you use storage mounts with juju, it will be automatically mounted into the charm container
at either:

* the specified `location` based on the storage section of metadata.yaml or

* the default location `/var/lib/juju/storage/<storage-name>/<num>` where `num`
  is zero for "normal"/singular storages or integer id for storages that support `multiple`
  attachments.

The operator framework provides the `Model.storages` dict-like member that maps storage names to a
list of storages mounted under that name.  It is a list in order to handle the case of storage
configured for multiple instances.  For the basic singular case, you will simply access the
first/only element of this list.

Charm developers should *not* directly assume a location/path for mounted storage.  To access
mounted storage resources, retrieve the desired storage's mount location from within your charm
code - e.g.:

```python
def _my_hook_function(self, event):
    ...
    storage = self.model.storages['my-storage'][0]
    root = storage.location

    fname = 'foo.txt'
    fpath = os.path.join(root, fname)
    with open(fpath, 'w') as f:
        f.write('super important config info')
    ...
```

This example utilizes the framework's representation of juju storage - i.e. `self.model.storages`
which returns a [`mapping`](https://ops.readthedocs.io/en/latest/index.html#ops.StorageMapping) of
`<storage_name>` to [`Storage`](https://ops.readthedocs.io/en/latest/index.html#ops.Storage)
objects, which exposes the `name`, `id` and `location` of each storage to the charm developer,
where `id` is the underlying storage provider ID.

If you have also mounted storage in a container, that storage will be located directly at the
specified mount location.  For example with the following content in your metadata.yaml:

```
containers:
  foo:
    resource: foo-image
    mounts:
      - storage: data
        location: /foo-data
```

storage for the "foo" container will be mounted directly at `/foo-data`.  There are no storage name
or integer-indexed subdirectories. Juju does not currently support multiple storage instances for
charms using "containers" functionality.  If you are writing a container-based charm (e.g. for
kubernetes clouds) it is best to have your charm code communicate the storage location to the
workload rather than hard-coding the storage path in the container itself.  This can be
accomplished by various means. One method is passing the mount path via a file using the
`Container` API:

```python
def _on_mystorage_storage_attached(self, event):
    # get the mount path from the charm metadata
    container_meta = self.framework.meta.containers['my-container']
    storage_path = container_meta.mounts['my-storage'].location
    # push the path to the workload container
    c = self.model.unit.get_container('my-container')
    c.push('/my-app-config/storage-path.cfg', storage_path)

    ... # tell workload service to reload config/restart, etc.
```

<a href="#heading--scaling-storage"><h2 id="heading--scaling-storage">Scaling Storage</h2></a>

While juju provides an `add-storage` command, this does not "grow" existing storage
instances/mounts like you might expect.  Rather it works by increasing the number of storage
instances available/mounted for storages configured with the `multiple` parameter.  For charm
development, handling storage scaling (add/detach) amounts to handling `<name>_storage_attached`
and `<name_storage_detaching` events. For example, with the following in your metadata.yaml file:

```yaml
storage:
    my-storage:
        type: filesystem
        multiple:
            range: 1-10
```

juju will deploy the application with the minimum of the range (1 storage instance in the example
above).  Storage with this type of `multiple:...` configuration will have each instance residing
under an indexed subdirectory of that storage's main directory - e.g.
`/var/lib/juju/storage/my-storage/1` by default in charm container.  Running `juju add-storage
<unit> my-storage=32G,2` will add two additional instances to this storage - e.g.:
`/var/lib/juju/storage/my-storage/2` and `/var/lib/juju/storage/my-storage/3`.  "Adding" storage
does not modify or affect existing storage mounts.  This would generate two separate
storage-attached events that should be handled.

In addition to juju client requests for adding storage, the [`StorageMapping`](https://ops.readthedocs.io/en/latest/index.html#ops.StorageMapping)
returned by `self.model.storages` also exposes a
[`request`](https://ops.readthedocs.io/en/latest/index.html#ops.StorageMapping.request)
method (e.g. `self.model.storages.request()`) which provides an expedient method for the developer
to invoke the underlying
[`storage-add`](https://discourse.charmhub.io/t/hook-tools/1163#heading--storage-add) hook tool in
the charm to request additional storage. On success, this will fire a
`<storage_name>-storage-attached` event.

> <small> Contributors: @jnsgruk, @lengau, @tmihoc </small>