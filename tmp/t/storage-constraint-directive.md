(storage-constraint-directive)=
# Storage constraint (directive)

><small> {ref}`Storage <storage>` > Storage constraint </small> <br>
>
> See also: {ref}`How to manage storage <how-to-manage-storage>`, {ref}``juju deploy` <7180md>`, {ref}``juju add-storage` <7180md>`, {ref}``juju refresh` <7180md>`

In Juju, a **storage constraint** is a collection of storage specifications that can be passed as a positional argument to some commands (`add-storage`) or as the argument to the `--storage` option of other commands (`deploy`, `refresh`) to dictate how storage is allocated.

<!--When you perform `juju deploy` or `juju add-storage`, you can dictate how storage is allocated by specifying a `--storage` option.-->

```{important}

A *storage constraint* is slightly different from a {ref}`constraint <constraint>` -- while the general meaning is similar, the syntax is quite different. For this reason, a storage constraint is sometimes also called a *storage directive*.

```

```{important}

To put together a storage constraint, you need information from both the charm and the {ref}`storage provider <storage-provider>` /  {ref}`storage pool <storage-pool>`. 

```

This constraint has the form `<label>=<pool>,<count>,<size>`.

```{important}

The order of the arguments does not actually matter -- they are identified based on a regex (pool names must start with a letter and sizes must end with a unit suffix). 

```

<!-- Where in the charm project exactly do you find this label?-->

`<label>` is a string taken from the charmed operator itself. It encapsulates a specific storage option/feature. Sometimes it is also called a *store*.

The values are as follows:

*   `<pool>`: the storage pool. See {ref}`Storage pool <storage-pool>`.
*   `<count>`: number of volumes
*   `<size>`: size of each volume


If at least one constraint is specified the following default values come into effect:

* `<pool>`: the default storage pool. See {ref}`How to view the default storage pool <7180md>`.
* `<count>`: the minimum number required by the charm, or '1' if the storage is optional
* `<size>`: determined from the charm's minimum storage size, or 1GiB if the charmed operator does not specify a minimum


---
```{dropdown} Expand to see an example of a partial specification and its fully-specified equivalent


Suppose you want to deploy PostgreSQL with one instance (count) of 100GiB, via the charm's 'pgdata' storage label, using the default storage pool:

```text
juju deploy postgresql --storage pgdata=100G
```

Assuming an AWS model, where the default storage pool is `ebs`, this is equivalent to:

```text
juju deploy postgresql --storage pgdata=ebs,100G,1
```

```

----

In the absence of any storage specification, the storage will be put on the root filesystem (`rootfs`). <!--I'm guessing this takes care of `<pool>`. What about the other values?-->

 `--storage` may be specified multiple times, to support multiple charm labels.