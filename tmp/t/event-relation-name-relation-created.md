(event-relation-name-relation-created)=
# Event '<relation name>-relation-created'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>`> {ref}`Relation events <relation-events>` > `<relation name>-relation-created`</small>
>
> See also: {ref}`A charm's life <charm-lifecycle>`, {ref}`The lifecycle of charm relations <6476md>`, https://discourse.charmhub.io/t/discussion-on-hooks-relation-departed-and-relation-broken/207/2, https://discourse.charmhub.io/t/relation-broken-hook-not-running-in-peers-relation/3212/2, {ref}`Charm hooks <6476md>`

```{important}

Before `juju v.3.0`, 'integrations' were called 'relations'. Remnants of this persist in the names, options, and output of certain commands, and in integration event names.

```

`relation-created` is a "setup" event and, emitted when an application is related to another. Its purpose is to inform the newly related charms that they are entering the relation.

If juju is aware of the existence of the relation "early enough", before the application has started (i.e. *before* the application has started = {ref}``start` <event-start>` has run), this event will be fired as part of the [Setup phase](https://discourse.charmhub.io/t/a-charms-life/5938#heading--notes-on-the-setup-phase). An important consequence of this fact is, that for all peer-type relations, since juju is aware of their existence from the start, those `relation-created`  events will always fire before `start`.

Similarly, if an application is being scaled up, the new unit will see `relation-created` events for all relations the application already has during the Setup phase.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Relation data](#heading--relation-data)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
| Integrate  | `juju integrate foo bar` | (all foo & bar units): `*-relation-created --> *-relation-joined -> *-relation-changed` |
|  Scale up an integrated app | `juju add-unit -n1 foo` | (new foo unit): `install -> *-relation-created -> leader-settings-changed -> config-changed -> start` |


In the following scenario, one deploys two applications and relates them "very early on". For example, in a single command.
|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Deploy and quickly integrate | `juju deploy foo; juju deploy bar; juju integrate foo bar` | (all units): same as previous case. |
<a href="#heading--relation-data"><h2 id="heading--relation-data">Relation Data</h2></a>
Starting from when `*-relation-created` is received, relation data can be read-written by units, up until when the corresponding `*-relation-broken` is received.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>
In Ops, you can observe the event like you would any other:

```python
self.framework.observe(
    charm.on.<relation name>_relation_created, 
    self._on_<relation name>_relation_created
)
```
The [`RelationCreatedEvent` event object](https://ops.readthedocs.io/en/latest/index.html?highlight=RelationCreatedEvent#ops.charm.RelationCreatedEvent) does not expose any specific attributes.