(event-relation-name-relation-departed)=
# Event '<relation name>-relation-departed'

> See also: 
> - {ref}`Event <event>`
> - https://discourse.charmhub.io/t/a-charms-life/5938
> - [Relation events](https://discourse.charmhub.io/t/relation-events/6498)
> - https://discourse.charmhub.io/t/the-lifecycle-of-charm-relations/1050
> - https://discourse.charmhub.io/t/discussion-on-hooks-relation-departed-and-relation-broken/207/2
> - https://discourse.charmhub.io/t/relation-broken-hook-not-running-in-peers-relation/3212/2
> - https://discourse.charmhub.io/t/charm-hooks/1040

```{important}

Before `juju v.3.0`, 'integrations' were called 'relations'. Remnants of this persist in the names, options, and output of certain commands, and in integration event names.

```

`relation-departed` is a "teardown" event, emitted when a remote unit departs a relation. 
This event is the exact inverse of `relation-joined`.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Relation data](#heading--relation-data) 
- [Observing this event in Ops](#heading--observing-this-event-in-ops)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

`*-relation-broken` events are emitted on a unit when a related application is scaled down. Suppose you have two related applications, `foo` and `bar`.
If you scale down `bar`, all `foo` units will receive a `*-relation-departed` event. The departing unit will receive a `*-relation-broken` event as part of its {ref}`teardown sequence <charm-lifecycle>`.
Also removing a relation altogether will trigger `*-relation-departed` events (followed by `*-relation-broken`) on all involved units.

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Unit removal   | `juju remove-unit --num-units 1 bar` | (foo/0): `*-relation-departed` <br> (bar/0): `*-relation-broken -> stop -> ...` |
|  Integration removal   | `juju remove-relation foo bar` | (all units): `*-relation-departed -> *-relation-broken` |

Of course, removing the application altogether, instead of a single unit, will have a similar effect and also trigger these events.

Both relation-departed and relation-broken will always fire, regardless of how the relation is terminated.

```{note}

For a peer relation, the relation itself will never be destroyed until the application is removed and no units remain, at which point there won't be anything to call the relation-broken hook on anyway.

```

Note that on relation removal (`juju remove-relation`); only when all `-departed` hooks for such a relation and all callback methods bound to this event have been run for such a relation, the unit agent will fire `relation-broken`.

The `relation-departed` event is seen both by the leaving unit(s) and the remaining unit(s):

- For remaining units (those which have joined and not yet departed), this event is emitted once for each departing unit and in no particular order. At the point when a remaining unit receives a `relation-departed`, it's perfectly probable (although not guaranteed) that the system running that unit has already shut down.
- For departing units, this event is emitted once for each remaining unit.

 <a href="#heading--relation-data"><h2 id="heading--relation-data">Relation data</h2></a>

A unit's relation settings persist beyond its own departure from the relation; the final unit to depart a relation marked for termination is responsible for destroying the relation and all associated data.

`relation-changed` ISN'T fired for removed relations.
If you want to know when to remove a unit from your data, that would be relation-departed.

> During a `relation-departed` hook, relation settings can still be read (with relation-get) and a relation can even still be set (with relation-set), by  explicitly providing the relation ID. All units will still be able to see all other units, and any unit can call relation-set to update their own published set of data on the relation. However, data updated by the departing unit will not be published to the remaining units. This is true even if there are no units on the other side of the relation to be notified of the change.

If any affected unit publishes new data on the relation during the relation-departed hooks, the new data will NOT be see by the departing unit (it will NOT receive a relation-changed; only the remaining units will).


```{note}

(juju internals) When a unit's own participation in a relation is known to be ending, the unit agent continues to uphold the guaranteed event ordering, but within those constraints, it will run the fewest possible hooks to notify the charm of the departure of each individual remote unit.

```


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

You can observe the `*-relation-departed` event like you would any other:

```
self.framework.observe(
    self.on.<endpoint name>_relation_departed, 
    self._<endpoint name>_relation_departed
)
```
The [RelationDepartedEvent](https://ops.readthedocs.io/en/latest/index.html?highlight=RelationDepartedEvent#ops.charm.RelationDepartedEvent) object exposes the following attributes:

- `departing_unit`: the `Unit` instance that's departing the relation.
You can determine if the current unit is the departing unit with `event.departing_unit`:
```python
if event.departing_unit == self.model.unit:
    # cleanup etc.
```