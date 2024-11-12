(relation-events)=
# Relation events

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>`> Relation events </small>
>
> See also: {ref}`Charm lifecycle <charm-lifecycle>`, {ref}`The lifecycle of charm relations <6498md>`, {ref}`How to integrate with other charms <6498md>`

```{important}

Before `juju v.3.0`, 'integrations' were called 'relations'. Remnants of this persist in the names, options, and output of certain commands, and in integration event names.

```

If a charm has any relations, it typically may want to be notified of when the relation is created or destroyed, when a remote unit joins or leaves, or when a unit other than itself (local or remote) changes the relation data. 
Relation events allow charms to observe changes to the juju model in all of these situations. 

**Contents:**

- [Complete list of relation events](#heading--complete-list-of-relation-events)
- [Relation event triggers](#heading--relation-event-triggers)
- [Relation events in `ops`](#heading--relation-events-in-ops) 

<a href="#heading--complete-list-of-relation-events"><h2 id="heading--complete-list-of-relation-events">Complete list of relation events</h2></a>

```{note}

All relation events are tied to a specific relation. You can't just observe "any change to any relation's data": you need to individually register observers to each relation.
For this reason, the relation events are prefixed with a `<relation name>` placeholder. The real name of the event will depend on how the charm refers to the relation.

```

 - [`<relation name>-relation-created`](https://discourse.charmhub.io/t/relation-name-relation-created-event/6476); emitted when a new relation is created.
 - [`<relation name>-relation-broken`](https://discourse.charmhub.io/t/relation-name-relation-broken-event/6474); emitted when a relation is broken.
 - [`<relation name>-relation-joined`](https://discourse.charmhub.io/t/relation-name-relation-joined-event/6478); emitted when a new unit joins in an existing relation.
 - [`<relation name>-relation-departed`](https://discourse.charmhub.io/t/relation-name-relation-departed-event/6477); emitted when a unit departs from an existing relation.
 - [`<relation name>-relation-changed`](https://discourse.charmhub.io/t/relation-name-relation-changed-event/6475) ; emitted when another unit has touched the relation data.

<a href="#heading--relation-event-triggers"><h2 id="heading--relation-event-triggers">Relation event triggers</h2></a>

Relation events trigger as a response to changes in the juju model relation topology. When a new relation is created or removed, events are fired on all units of both involved applications.

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | ---------------------------------------- | ------------------------------------ |
|  Relate   | `juju integrate foo:a bar:b`     | `(foo): a-relation-created -> a-relation-changed`<br> `(bar): b-relation-created -> b-relation-changed` |
|  Remove relation   | `juju remove-relation foo:a bar:b`     | `(foo): a-relation-broken`<br> `(bar): b-relation-broken` |

If you have two already related applications, and one of them gains or loses a unit, then the newly added unit will receive the same event sequences as if it had just been related (from its point of view, the relation is 'brand new'), while the units that were there already receive a `-relation-joined` event.
Similarly if a unit is removed, that unit will receive `-relation-broken`, while the ones that remain will see a `-relation-departed`.

|  Scenario   | Example Command                          | Resulting Events                     |
| :-------: | ---------------------------------------- | ------------------------------------ |
|  Add unit   | `juju add-unit foo -n 1`     | `(foo): a-relation-created -> a-relation-changed`<br> `(bar): b-relation-joined -> b-relation-changed` |
|  Remove relation   | `juju remove-unit foo:a --num-units 1`     | `(foo): a-relation-broken`<br> `(bar): b-relation-departed` |

```{note}

`-relation-changed` events are not only fired as part of these event sequences, but also whenever a unit touches the relation data.
As such, contrary to many other events, `-relation-changed` events are mostly triggered by charm code (and not by the cloud admin doing things on the juju model).

```

<a href="#heading--relation-events-in-ops"><h2 id="heading--relation-events-in-ops">Relation events in `ops`</h2></a>

In ops, all relation events inherit from [`ops.charm.RelationEvent`](https://ops.readthedocs.io/en/latest/index.html?highlight=relationevent#ops.charm.RelationEvent), which gives them the following attributes:
- [`relation`](https://ops.readthedocs.io/en/latest/index.html?highlight=relationevent#ops.charm.RelationEvent.relation): the `ops.model.Relation` instance, involved in this event
-  [`app`](https://ops.readthedocs.io/en/latest/index.html?highlight=relationevent#ops.charm.RelationEvent.app):  the remote `ops.model.Application` that has triggered this event
- [`unit`](https://ops.readthedocs.io/en/latest/index.html?highlight=relationevent#ops.charm.RelationEvent.unit):  the remote `ops.model.Unit` that has triggered this event.