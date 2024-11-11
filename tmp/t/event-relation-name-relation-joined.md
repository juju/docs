(event-relation-name-relation-joined)=
# Event '<relation name>-relation-joined'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>`> {ref}`Relation events <relation-events>` > `<relation name>-relation-joined`</small>
>
> See also: {ref}`A charm's life <charm-lifecycle>`, {ref}`The lifecycle of charm relations <6478md>`, https://discourse.charmhub.io/t/discussion-on-hooks-relation-departed-and-relation-broken/207/2, https://discourse.charmhub.io/t/relation-broken-hook-not-running-in-peers-relation/3212/2, {ref}`Charm hooks <6478md>`

```{important}

Before `juju v.3.0`, 'integrations' were called 'relations'. Remnants of this persist in the names, options, and output of certain commands, and in integration event names.

```

`relation-joined` is emitted when a unit joins in an existing relation. The unit will be a local one in the case of peer relations, a remote one otherwise.

By the time this event is emitted, the only available data concerning the relation is
 - the name of the joining unit.
 - the `private-address` of the joining unit.

In other words, when this event is emitted the remote unit has not yet had an opportunity to write any data to the relation databag. For that, you're going to have to wait for the first {ref}``relation-changed` <event-relation-name-relation-changed>` event.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

From the perspective of an application called `foo`, which can relate to an application called `bar`:

|   Scenario   | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Create unit   | `juju integrate foo bar` |  `*-relation-created -> *-relation-joined -> *-relation-changed` |
|  Create unit   | `juju add-unit bar -n 1`  |  `*-relation-joined -> *-relation-changed`|


```{note}

For a peer relation, `<peer relation name>-relation-joined` will be received by peers some time after a new peer unit appears. (And during its setup, that new unit will receive a  `<peer relation name>-relation-created`).

```

```{note}

For a peer relation, `<peer relation name>-relation-joined` will only be emitted if the scale is larger than 1. In other words, applications with a scale of 1 do not see peer relation joined/departed events.
**If you are using peer data as a means for persistent storage, then use peer `relation-created` instead**.

```

`relation-joined` can fire multiple times per relation, as multiple units can join, and is the exact inverse of `relation-departed`.
That means that if you consider the full lifecycle of an application, a unit, or a model, the net difference of the number of `*-relation-joined` events and the number of `*-relation-departed` events will be zero.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In `ops`, you can observe this event like you would any other:
```python
# in MyCharm.__init__
self.framework.observe(
  self.on.foo_relation_joined, 
  self._on_foo_relation_joined)
``` 

The [RelationJoinedEvent](https://ops.readthedocs.io/en/latest/index.html?highlight=RelationJoinedEvent#ops.charm.RelationJoinedEvent) object does not expose any specific attributes, but the `unit` attribute always refers to the unit that just joined the relation.

<!--NOT RELEVANT HERE.
<a href="#heading--pythonlib-juju"><h3 id="heading--pythonlib-juju">`pythonlib-juju`</h3></a>

In `python-libjuju` you can relate two applications via:
- `juju.Model.relate`
- `juju.Application.relate`
-->