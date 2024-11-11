(event-relation-name-relation-broken)=
# Event '<relation name>-relation-broken'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>`> {ref}`Relation events <relation-events>` > `<relation name>-relation-broken`</small>
>
> See also: {ref}`A charm's life <charm-lifecycle>`, {ref}`The lifecycle of charm relations <6474md>`, 
 https://discourse.charmhub.io/t/discussion-on-hooks-relation-departed-and-relation-broken/207/2,  https://discourse.charmhub.io/t/relation-broken-hook-not-running-in-peers-relation/3212/2
>
> Source: [`ops.charm.RelationBrokenEvent`](https://ops.readthedocs.io/en/latest/index.html?highlight=relationbrokenevent#ops.charm.RelationBrokenEvent)

`relation-broken` is a ["teardown"](https://discourse.charmhub.io/t/a-charms-life/5938) event and is emitted when a relation is being removed; when a unit participating in a relation is being removed, even if the relation is otherwise still alive (through other units); or when an application involved in a relation is being removed.

<!--an existing relation between two applications is fully terminated.
https://bugs.launchpad.net/juju/+bug/1979811 seems to indicate it can be emitted any time a unit is dying, including when the application still has other units involved in the relation.
-->



This event is run only once per unit per relation and is the exact inverse of `relation-created`. `relation-created` indicates that relation data can be accessed; `relation-broken` indicates that relation data can no longer be read-written.

The event indicates that the relation under consideration is no longer valid, and that the charm’s software must be configured as though the relation had never existed. It will only be called after every hook bound to `RelationDepartedEvent` has been run. If a hook bound to this event is being executed, it is guaranteed that no remote units are currently known locally.


**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

There are two main operations which cause a `<relation name>-relation-broken` event to occur:

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
| Unit removal   | `juju remove-unit --num-units 1 bar` | (foo/0): `*-relation-departed` <br> (bar/0): `*-relation-broken -> stop -> ...` |
|  Relation removal   | `juju remove-relation foo bar` | (all units): `*-relation-departed -> *-relation-broken` |

Of course, removing the application altogether, instead of a single unit, will have a similar effect and also trigger these events.

> It is important to note that **the `-broken` hook might run even if no other units have ever joined the relation**. This is not a bug: even if no remote units have ever joined, the fact of the unit’s participation can be detected in other hooks via the `relation-ids` tool, and the `-broken` hook needs to execute to allow the charm to clean up any optimistically-generated configuration.

Also, it’s important to internalise the fact that there may be multiple relations in play with the same name, and that they’re independent: one `-broken` hook does not mean that *every* such relation is broken.

```{note}

For a peer relation, `<peer relation name>-relation-broken` will never fire, not even during the [Teardown phase](https://discourse.charmhub.io/t/a-charms-life/5938#heading--notes-on-the-teardown-phase).

```


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In Ops, you can observe the event like you would any other:

```python
self.framework.observe(
    charm.on.<relation name>_relation_broken, 
    self._on_<relation name>_relation_broken
)
```
The [`RelationBrokenEvent` event object](https://ops.readthedocs.io/en/latest/index.html?highlight=RelationBrokenEvent#ops.charm.RelationBrokenEvent) does not expose any specific attributes.


<!--NOT RELEVANT HERE.

When writing unit tests with the OF harness, you can test relation-broken handlers by removing the relation like one would with `juju remove-relation`:

```python
self.harness.remove_relation(relation_id, remote_unit_name)
``` 
See: [`ops.testing.Harness.remove_relation`](https://ops.readthedocs.io/en/latest/index.html?highlight=remove_relation#ops.testing.Harness.remove_relation)


<a href="#heading--pythonlib-juju"><h3 id="heading--pythonlib-juju">`pythonlib-juju`</h3></a>

In python-libjuju, you can cause relation-broken to fire by [removing an application](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.remove) or [removing the relation](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.remove_relation). Or you can [observe a model until the relation is removed](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html#reacting-to-changes-in-a-model).
-->