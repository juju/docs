(event-scenario)=
# Event (Scenario)

> <small> {ref}`Scenario <scenario>` > Event </small>

In Scenario, the `Event` object corresponds to the homonym Juju data structure -- a Juju event.

> See more: {ref}`Event (in Juju) <event>`

Like a Juju event, the `scenario.Event` data structure encapsulates some environment variables that the charm is being executed with and roughly represents the "reason why" the charm is being executed.

The fundamental piece of information carried by an Event is therefore the name of the 'hook' that the Juju controller has decided should be executed by this charm.

# Basic usage

In many situations, the name of the event is enough for Scenario to work.

Look at the code snippet below:

```python
from scenario import Context, State
from charm import MyCharm

ctx = Context(MyCharm)
ctx.run(event="update-status", state=State())
```

`Context.run` will first cast the string `'update-status'` to an `Event` data structure. The following code is therefore equivalent:

```python
from scenario import Event
...
ctx.run(event=Event("update-status"), state=State())
```

# Event metadata: generic usage
Depending on the hook, certain additional environment variables need to be set for `ops ` to function, just like the Juju unit agent guarantees them to be present when the charm is run for real. 

```{note}

For example, {ref}`relation events <relation-events>` require a `JUJU_RELATION_ID` envvar to be set.

```

In those situations, you cannot simply use strings to refer to events, but you need to provide an 
`Event` object to which you can pass some additional required metadata. Scenario's runtime will use that information to populate the envvars that `ops` expects to be set.

For example, if you want to simulate {ref}`relation events <relation-events>` in Scenario, you need to:

```python
from scenario import Event, Relation
...
relation = Relation('foo')
ctx.run(
    event=Event("foo-relation-changed", relation=relation), 
    state=State(relations={ref}`relation])
)
```

The same holds for [workload events <event-container-pebble-ready>` and {ref}`secret events <secret-events>`.

```{note}

For workload (`pebble-ready`) events, the reason we need to associate the container with the event is that the Framework uses **an envvar** (and not the event name) to determine which container the event is about. Scenario needs that information, similarly, for injecting that envvar into the charm's runtime.

```

```{note}

For secret events, the reason is similar: the operator framework uses several envvars set by Juju to determine the secret ID the event is about and other required metadata.

```

# Syntactic sugar
As a way to simplify the user experience, all event types that are associated to some operator data structure can be obtained from the data structure itself. 

So instead of doing

```python
relation = Relation('foo')
relation_changed_evt = Event('foo_relation_changed', relation=relation)
```

you can simply:

```python
relation_changed_evt = Relation('foo').changed_event
```

And similarly for {ref}``Container` <10623md>` and {ref}``Secret` <10623md>`.

|{ref}``Relation` <10623md>` method | event |
|--|--|
|`Relation('foo').changed_event`|`foo_relation_changed`|
|`Relation('foo').joined_event`|`foo_relation_joined`|
|`Relation('foo').broken_event`|`foo_relation_broken`|
|`Relation('foo').created_event`|`foo_relation_created`|
|`Relation('foo').departed_event`|`foo_relation_departed`|

|{ref}``Container` <10623md>` method | event|
|--|--|
|`Container('foo').pebble_ready_event`|`foo_pebble_ready`|

|{ref}``Secret` <10623md>` method | event|
|--|--|
|`Secret('id').changed_event`|`secret_changed`|
|`Secret('id').rotate_event`|`secret_rotate`|
|`Secret('id').expired_event`|`secret_expired`|
|`Secret('id').remove_event`|`secret_remove`|