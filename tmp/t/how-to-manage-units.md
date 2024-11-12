(how-to-manage-units)=
# How to manage units

> See also: {ref}`Unit <unit>`

This document demonstrates various operations that you can perform on a unit. 

```{important}

Units are also relevant when adding storage or scaling an application. See {ref}`How to manage storage <how-to-manage-storage>` and {ref}`How to manage applications <how-to-manage-applications>`.

```

**Contents:**

- [Add a unit](#heading--add-a-unit)
- [Control the number of units](#heading--control-the-number-of-units)	
- [Show details about a unit](#heading--show-details-about-a-unit)
- [List a unit's resources](#heading--list-a-units-resources)
- [Show the status of a unit](#heading--show-the-status-of-a-unit) 
- [Set the meter status on a unit](#heading--set-the-meter-status-on-a-unit)
- [Mark unit errors as resolved](#heading--mark-unit-errors-as-resolved)
- [Remove a unit](#heading--remove-a-unit)


<a href="#heading--add-a-unit"><h2 id="heading--add-a-unit">Add a unit</h2></a>

{ref}`tabs]
[tab version="juju"]

To add a unit, use the `add-unit` command followed by the application name:

```{important}

This is only true for machine deployments. For Kubernetes, see [How to control the number of units <5891md>`.

```

```text
juju add-unit mysql
```

By using various command options, you can also specify the number of units, the model, the kind of storage, the target machine (e.g., if you want to collocate multiple units of the same or of different applications on the same machine -- though watch out for potentials configuration clashes!), etc. 


> See more: {ref}``juju add-unit` <command-juju-add-unit>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]

To add a unit in `python-libjuju` client, you simply call `add_unit()` on your `Application` object, as follows:

```python
my_app.add_unit(count=3)
```

> See more: [`Application (module)`](https://pythonlibjuju.readthedocs.io/en/latest/narrative/application.html), [Application.add_unit()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.add_unit), [Application.scale()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.scale)

{ref}`/tab]
[/tabs]

<a href="#heading--control-the-number-of-units"><h2 id="heading--control-the-number-of-units">Control the number of units</h2></a>

[tabs]
[tab version="juju"]

The procedure depends on whether you are on machines or rather Kubernetes.

**Machines.** To control the number of an application's units in a machine deployment, add or remove units in the amount required to obtain the desired number.

> See more: [How to add a unit <5891md>`, {ref}`How to remove a unit <5891md>`

**Kubernetes.** To control the number of an application's units in a Kubernetes deployment, run the `scale-application` command followed by the number of desired units (which can be both higher and lower than the current number). 

```text
juju scale-application mediawiki 3
```

> See more: {ref}``juju scale-application` <command-juju-scale-application>`

[/tab]

[tab version="terraform juju"]

To control the number of units of an application, in its resource definition specify a `units` attribute. For example, below we set it to 3.


```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  units = 3    
}
```

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)


[/tab]

[tab version="python libjuju"]
To control the number of units of an application in `python-libjuju` client, you can use the `Application.add_unit()` and `Application.destroy_units()` methods, or the `Application.scale()` method, depending on whether you're working on a CAAS system (e.g. Kubernetes), or an IAAS system (e.g. lxd).

If you're on  an IAAS system (machine applications):

```python
u = my_app.add_unit()
my_app.destroy_units(u.name) # Note that the argument is the name of the unit

# You may give multiple unit names to destroy at once
my_app.destroy_units(u1.name, u2.name)
```

If you're on  a CAAS sytem (k8s applications):

```python
my_app.scale(4)
```


> See more: [`Application (module)`](https://pythonlibjuju.readthedocs.io/en/latest/narrative/application.html), [Application.add_unit()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.add_unit), [Application.scale()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.scale), [Application.destroy_units()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.destroy_units)

{ref}`/tab]
[/tabs]

<a href="#heading--show-details-about-a-unit"><h2 id="heading--show-details-about-a-unit">Show details about a unit</h2></a>

[tabs]
[tab version="juju"]


To see more details about a unit, use the `show-unit` command followed by the unit name:

```text
juju show-unit mysql/0
```

By using various options you can also choose to get just a subset of the output, a different output format, etc.

> See more: [`juju show-unit` <command-juju-show-unit>`

{ref}`/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]

Too see details about a unit in `python-libjuju` client, you can use various fields and methods of a `Unit` object. For example, to get the `public_address` of a unit:

```python
my_unit.get_public_address()
```

Or, to see if the unit is a leader:
```python
my_unit.is_leader_from_status()
```

> See more: [`Unit` (module) <5891md>`, [Unit (methods)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit), [Unit.get_public_address()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit.get_public_address), [Unit.is_leader_from_status()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit.is_leader_from_status)

{ref}`/tab]
[/tabs]

<a href="#heading--list-a-units-resources"><h2 id="heading--list-a-units-resources">List a unit's resources</h2></a>

[tabs]
[tab version="juju"]

To see the resources for a unit, use the `resources` command followed by the unit name. For example:

```text
juju resources mysql/0
```

> See more: [`juju resources` <command-juju-resources>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]

The `python-libjuju` client does not support this. Please use the `juju` client.

> Related: [Application.get_resources()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_resources)

{ref}`/tab]
[/tabs]


<a href="#heading--show-the-status-of-a-unit"><h2 id="heading--show-the-status-of-a-unit">Show the status of a unit</h2></a>

[tabs]
[tab version="juju"]

To see the status of a unit, use the `status` command:

```text
juju status
```

This will show information about the model, along with its machines, applications and units. For example:

```text
Model           Controller           Cloud/Region        Version  SLA          Timestamp
tutorial-model  tutorial-controller  microk8s/localhost  2.9.34   unsupported  12:10:16+02:00

App             Version                         Status  Scale  Charm           Channel  Rev  Address         Exposed  Message
mattermost-k8s  .../mattermost:v6.6.0-20.04...  active      1  mattermost-k8s  stable    21  10.152.183.185  no       
postgresql-k8s  .../postgresql@ed0e37f          active      1  postgresql-k8s  stable     4                  no       Pod configured

Unit               Workload  Agent  Address       Ports     Message
mattermost-k8s/0*  active    idle   10.1.179.151  8065/TCP  
postgresql-k8s/0*  active    idle   10.1.179.149  5432/TCP  Pod configured
```

> See more: [`juju status` <command-juju-status>`, [Unit status](https://juju.is/docs/juju/status#heading--unit-status)

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]

To get the status of a unit on `pylibjuju-client`, you can use various (dynamically updated) status fields defined on a Unit object, such as:

```python
workload_st = my_unit.workload_status
agent_st = my_unit.agent_status
```
> See more: [Unit status](https://juju.is/docs/juju/status#heading--unit-status), {ref}``Unit` (module) <5891md>`, [Unit (methods)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit), [Unit.workload_status (field)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit.workload_status), [Unit.agent_status (field)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit.agent_status)

{ref}`/tab]
[/tabs]

<a href="#heading--set-the-meter-status-on-a-unit"><h2 id="heading--set-the-meter-status-on-a-unit">Set the meter status on a unit</h2></a>

[tabs]
[tab version="juju"]

To set the meter status on a unit, use the `set-meter-status` command followed by the unit name. For example:

```text
juju set-meter-status myapp/0
```

> See more: [`juju set-meter-status` <command-juju-set-meter-status>`

{ref}`/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]

The `python-libjuju` client does not support this. Please use the `juju` client.

[/tab]
[/tabs]

<a href="#heading--mark-unit-errors-as-resolved"><h2 id="heading--mark-unit-errors-as-resolved">Mark unit errors as resolved</h2></a>

[tabs]
[tab version="juju"]

To mark unit errors as resolved, use the `resolved` command followed by the unit name or a list of space-separated unit names. For example:

```text
juju resolved myapp/0
```

> See more: [`juju resolved` <command-juju-resolved>`

{ref}`/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
To mark unit errors as resolved in the `python-libjuju` client, you can call the `resolved()` method on a `Unit` object:

```python
my_unit.resolved()
```

> See more: [`Unit.resolved()` <5891md>`)

{ref}`/tab]
[/tabs]

<a href="#heading--remove-a-unit"><h2 id="heading--remove-a-unit">Remove a unit</h2></a>

[tabs]
[tab version="juju"]

To remove individual units instead of the entire application (i.e. all the units), use the `remove-unit` command followed by the unit name. For example, the code below removes unit 2 of the PostgreSQL charm. For example:

```{important}

While this can be used for both machine and Kubernetes deployments, unless you care about which unit you're removing specifically, in Kubernetes you may also just run `juju scale-application <n>`, where `n` is less than the current number of units. See [How to control the number of units <5891md>`.

```


```text
juju remove-unit postgresql/2
```

```{important}

In the case that the removed unit is the only one running, the corresponding machine will also be removed, unless any of the following is true for that machine: <br>

- it was created with `juju add-machine` <br>
- it is not being used as the only controller <br>
- it is not hosting Juju-managed containers (KVM guests or LXD containers)


```


It is also possible to remove multiple units at a time by passing instead a space-separated list of unit names:

```text
juju remove-unit mediawiki/1 mediawiki/3 mediawiki/5 mysql/2
```

<!--Why is this necessary? Doesn't removing a unit automatically destroy the storage?-->
To also destroy the storage attached to the units, add the `--destroy-storage` option.

<!--As a last resort in case of what...?-->
As a last resort, use the `--force` option (in `v.2.6.1`).

> See more: {ref}``juju remove-unit` <command-juju-remove-unit>`, {ref}`Removing things reference <removing-things>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
To remove individual units on `python-libjuju` client, simply use the `Application.destroy_units()` method:



```python
my_app.destroy_units(u.name) # Note that the argument is the name of the unit

# You may give multiple unit names to destroy at once
my_app.destroy_units(u1.name, u2.name)
```

> See more: [`Application (module)`](https://pythonlibjuju.readthedocs.io/en/latest/narrative/application.html), [Application.destroy_units()](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.destroy_units)

[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @hmlanigan, @skourta, @tmihoc </small>