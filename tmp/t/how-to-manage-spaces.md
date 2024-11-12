(how-to-manage-spaces)=
# How to manage spaces

> See also: {ref}`Space <space>`
<!--{ref}``juju add-space` <6664md>`,  {ref}``juju move-to-space` <6664md>`, {ref}``juju reload-spaces` <6664md>`, {ref}``juju remove-space` <6664md>`, {ref}``juju rename-space` <6664md>`, {ref}``juju spaces` <6664md>`
-->

Juju users are able to create, view, rename, or delete spaces.
<!-- and move subnets between them.-->

```{caution}

Juju can deploy to an IPv6 stack or an IPv4 stack, but not both at once (i.e., dual stacks are not supported).

```

**Contents:**
- [Add a space](#heading--add-a-space)
- [Reload spaces](#heading--reload-spaces)	 
- [View available spaces](#heading--view-the-available-spaces) 
- [View details about a space](#heading--view-details-about-a-space)
- [Rename a space](#heading--rename-a-space)
- [Remove a space](#heading--remove-a-space)



<a href="#heading--add-a-space"><h2 id="heading--add-a-space">Add a space</h2></a>

{ref}`tabs]
[tab version="juju"]

Spaces are created with the `add-space` command. The following example creates a new space called `db-space` and associates the `172.31.0.0/20` subnet with it:

``` text
juju add-space db-space 172.31.0.0/20
added space "db-space" with subnets 172.31.0.0/20
```

> See more: [`juju add-space` <command-juju-add-space>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
To create and add a new space, on a connected Model object, use the `add_space()` method, passing a name for the space and associated subnets. For example:

```python
await my_model.add_space("db-space", ["172.31.0.0/20"])
```

> See more: [`add_space()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.add_space), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]
[/tabs]

<a href="#heading--reload-spaces"><h2 id="heading--reload-spaces">Reload spaces</h2></a>

[tabs]
[tab version="juju"]


To reload spaces, along with their subnets, use the `reload-spaces` command:

```text
juju reload-spaces
```

This will show you any new spaces (whether added via `add-space` or directly on the provider end), or any new subnets of an existing space.

> See more: [`juju reload-spaces` <command-juju-reload-spaces>`

```{important}

This command is especially relevant for a MAAS cloud. There, you cannot add a space via `juju add-space`. Rather, you must add it directly using the MAAS UI/CLI and then run `juju reload-spaces` to make it known to Juju.

```

{ref}`/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--view-the-available-spaces"><h2 id="heading--view-the-available-spaces">View  available spaces</h2></a>

[tabs]
[tab version="juju"]

The spaces known to `juju` can be viewed with the `spaces` command, as follows:

```text
$ juju spaces
Name   Space ID  Subnets
alpha  0         172.31.0.0/20
                 172.31.16.0/20
                 172.31.32.0/20
                 172.31.48.0/20
                 172.31.64.0/20
                 172.31.80.0/20
                 252.0.0.0/12
                 252.16.0.0/12
                 252.32.0.0/12
                 252.48.0.0/12
                 252.64.0.0/12
                 252.80.0.0/12
```

> See more: [`juju spaces` <command-juju-spaces>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
To view available spaces, on a connected Model, use the `get_spaces()` method.

```python
await my_model.get_spaces()
```

> See more: [`get_spaces()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.get_spaces), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

{ref}`/tab]
[/tabs]

 <a href="#heading--view-details-about-a-space"><h2 id="heading--view-details-about-a-space">View details about a space</h2></a>

[tabs]
[tab version="juju"]

To view details about a space, run the `show-space` command:

```text
juju show-space
```

The command also allows you to specify a model to operate in, an output format, etc.

> See more: [`juju show-space` <command-juju-show-space>`

{ref}`/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--rename-a-space"><h2 id="heading--rename-a-space">Rename a space</h2></a>

[tabs]
[tab version="juju"]

To rename a space `db-space` to `public-space`, do:

```text
$ juju rename-space db-space public-space
renamed space "db-space" to "public-space"
```

```{important}

Spaces can also be renamed during controller configuration, via the `juju-ha-space` and `juju-mgmt-space` key, or during model configuration, via the `default-space` key.

```

<!--
Space names are valid values for the [controller configuration <6664md>` items:

- `juju-ha-space`
- `juju-mgmt-space`

The name of `default-space`, which is by default "alpha", can also be specified in {ref}`model-configuration <6664md>`.
-->

> See more: {ref}``juju rename-space` <command-juju-rename-space>`

{ref}`/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--remove-a-space"><h2 id="heading--remove-a-space">Remove a space</h2></a>

[tabs]
[tab version="juju"]

You can delete a space using the `remove-space` command. 

```text
$ juju remove-space public-space
removed space "public-space"
```

```{important}

Deleting a space will cause any subnets in it to move back to the `alpha` space. See [How to manage subnets <how-to-manage-subnets>`.

```

> See more: {ref}``juju remove-space` <command-juju-remove-space>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @manadart, @tmihoc </small>