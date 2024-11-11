(event-relation-name-relation-changed)=
# Event '<relation name>-relation-changed'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>`> {ref}`Relation events <relation-events>` > `<relation name>-relation-changed`</small>
>
> See also: {ref}`A charm's life <charm-lifecycle>`, {ref}`The lifecycle of charm relations <6475md>`, https://discourse.charmhub.io/t/discussion-on-hooks-relation-departed-and-relation-broken/207/2, https://discourse.charmhub.io/t/relation-broken-hook-not-running-in-peers-relation/3212/2, {ref}`Charm hooks <6475md>`

```{important}

Before `juju v.3.0`, 'integrations' were called 'relations'. Remnants of this persist in the names, options, and output of certain commands, and in integration (relation) event names.

```

`relation-changed` is emitted when another unit involved in the relation (from either side) touches the relation data. Relation data is *the* way for charms to share non-sensitive information (for sensitive information, `juju secrets` are on their way in juju 3).

> For centralized data -- for example, a single password or api token that one application generates to share with another application, we suggest that charm authors use the application data, rather than individual unit data. This data can only be written to by the application leader, and each remote unit related to that application will receive a single `relation-changed` event when it changes.

Hooks bound to this event should be the only ones that rely on remote relation settings. They should not error if the settings are incomplete, since it can be guaranteed that when the remote unit or application changes its settings again, this event will fire once more.

Charm authors should expect this event to fire many times during an application's life cycle. Units in an application are able to update relation data as needed, and a `relation-changed` event will fire every time the data in a relation changes. Since relation data can be updated on a per unit bases, a unit may receive multiple `relation-changed` events if it is related to multiple units in an application and all those units update their relation data. 


**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>
This event is guaranteed to follow immediately after each [`relation-joined`](https://discourse.charmhub.io/t/relation-name-relation-joined-event/6478). So all `juju` commands that trigger `relation-joined` will also cause `relation-changed` to be fired. So typical scenarios include: 

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Add an integration   | `juju integrate foo:a bar:b` | (all `foo` and `bar` units) <br> `*-relation-created -> *-relation-joined -> *-relation-changed`|

Additionally, a unit will receive a `relation-changed` event every time another unit involved in the relation changes the relation data. Suppose `foo` receives an event, and while handling it the following block executes:

```python
# in charm `foo`
relation.data[self.unit]['foo'] = 'bar'  # set unit databag
if self.unit.is_leader():
    relation.data[self.app]['foo'] = 'baz'  # set app databag
```

When the hook returns, `bar` will receive a `relation-changed` event.

```{note}
 
Note that units only receive `relation-changed` events for **other** units' changes. This can matter in a peer relation, where the application leader will not receive a `relation-changed` event for the changes that it writes to the peer relation's application data bag. If all units, including the leader, need to react to a change in that application data, charm authors may include an inline `.emit()` for the `<name>_relation_changed` event on the leader. 

```


> **When is data synchronized?** <br>
Relation data is sent to the controller at the end of the hook's execution. If a charm author writes to local relation data multiple times during the a single hook run, the net change will be sent to the controller after the local code has finished executing. The controller inspects the data and determines whether the relation data has been changed. Related units then get the `relation-changed` event the next time they check in with the controller.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>
In Ops, you can observe the event like you would any other:

```python
self.framework.observe(
    charm.on.<relation name>_relation_changed, 
    self._on_<relation name>_relation_changed
)
```
The [`RelationChangedEvent` event object](https://ops.readthedocs.io/en/latest/index.html?highlight=RelationChangedEvent#ops.charm.RelationChangedEvent) does not expose any specific attributes.