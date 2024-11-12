(how-to-manage-storage-pools)=
# How to manage storage pools

> See also: {ref}`Storage pool <storage-pool>`

This document shows how to work with storage pools. 

**Contents:**
- [Create a storage pool](#heading--create-a-storage-pool)
- [View the available storage pools](#heading--view-the-available-storage-pools)
- [View the default storage pool](#heading--view-the-default-storage-pool)
- [Update a storage pool](#heading--update-a-storage-pool)
- [Remove a storage pool](#heading--remove-a-storage-pool)

<a href="#heading--create-a-storage-pool"><h2 id="heading--create-a-storage-pool">Create a storage pool</h2></a>

{ref}`tabs]
[tab version="juju"]

First, check if your provider supports any storage configuration attributes. For example, in the case of AWS, the `ebs` storage provider supports several configuration attributes, and among these are `volume-type`, which configures the volume type (i.e. magnetic, ssd, or provisioned-iops), and `iops`, which indicates the IOPS per GiB.

> See more: [Storage provider > `ebs` <7184md>`, [Wikipedia | IOPS](https://en.wikipedia.org/wiki/IOPS)

Second, use the `create-storage-pool` command, passing as parameters the desired name of the pool and the name of the provider and then all the key-value pairs that you want to specify. For example, the code below creates a storage pool with the name `iops` which is a version of `ebs` with 30 IOPS.

```text
juju create-storage-pool iops ebs volume-type=provisioned-iops iops=30
```

> See more: {ref}``juju create-storage-pool` <command-juju-create-storage-pool>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]

To create a storage pool, on a connected Model object, use the `create_storage_pool()` method, passing the name of the pool and the provider type. For example:

```python
await my_model.create_storage_pool("test-pool", "lxd")
```

> See more: [`create_storage_pool()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.create_storage_pool), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]
[/tabs]

<a href="#heading--view-the-available-storage-pools"><h2 id="heading--view-the-available-storage-pools">View the available storage pools</h2></a>

[tabs]
[tab version="juju"]

To view the available storage pools, use the `storage-pools` command:

```text
juju storage-pools
```

This will list all the predefined storage pools as well as any custom ones that may have been created with the `juju create-storage-pool` command.

```{note}

The name given to a default storage pool will often be the same as the name of the storage provider upon which it is based.

```


---
```{dropdown} Expand to view a sample output for a newly-added `aws` model


```bash
Name     Provider  Attributes
ebs      ebs
ebs-ssd  ebs       volume-type=ssd
loop     loop
rootfs   rootfs
tmpfs    tmpfs
```

```

---

> See more: [`juju storage-pools` <command-juju-storage-pools>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]

To view the available storage pools, on a connected Model object, use the `list_storage_pools()` method. For example:

```python
await my_model.list_storage_pools()
```

> See more: [`list_storage_pools()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.list_storage_pools), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]
[/tabs]

<a href="#heading--view-the-default-storage-pool"><h2 id="heading--view-the-default-storage-pool">View the default storage pool</h2></a>

[tabs]
[tab version="juju"]

To find out the default storage pool for your block-type / filesystem-type, run the `model-config` command followed by the `storage-default-block-source` / `storage-default-filesystem-source` key. For example:

```text
juju model-config storage-default-block-source
```

> See more: [`juju model-config` <command-juju-model-config>`, {ref}`List of model configuration keys > `storage-default-block-source` <7184md>`, {ref}`List of model configuration keys > `storage-default-filesystem-source` <7184md>` 

{ref}`/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]


<a href="#heading--update-a-storage-pool"><h2 id="heading--update-a-storage-pool">Update a storage pool</h2></a>

[tabs]
[tab version="juju"]

(TO BE ADDED) 

To update storage pool attributes, use the `update-storage-pool` command:

```text
juju update-storage-pool test-pool
```

---
```{dropdown} Expand to view a sample usage


```bash
# Update the storage-pool named iops with new configuration details:
juju update-storage-pool operator-storage volume-type=provisioned-iops iops=40

# Update which provider the pool is for:
juju update-storage-pool lxd-storage type=lxd-zfs
```

```

---

> See more: [`juju update-storage-pool <command-juju-update-storage-pool>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
To update an existing storage pool attributes, on a connected Model object, use the `update_storage_pool()` method, passing the name of the storage and the attribute values to update. For example:

```python
await my_model.update_storage_pool(
    "operator-storage", 
    attributes={"volume-type":"provisioned-iops", "iops"="40"})
```

> See more: [`update_storage_pool()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.update_storage_pool), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]
[/tabs]


<a href="#heading--remove-a-storage-pool"><h2 id="heading--remove-a-storage-pool">Remove a storage pool</h2></a>

[tabs]
[tab version="juju"]

(TO BE ADDED) 

To remove an existing storage pool, use the `remove-storage-pool` command:

```text
juju remove-storage-pool test-pool
```


> See more: [`juju remove-storage-pool` <command-juju-remove-storage-pool>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
To remove a storage pool, on a connected Model object, use the `remove_storage_pool()` method, passing the name of the storage. For example:

```python
await my_model.remove_storage_pool("test-pool")
```

> See more: [`remove_storage_pool()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.remove_storage_pool), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)



[/tab]
[/tabs]


<br>

> <small>**Contributors:** @cderici, @tmihoc </small>