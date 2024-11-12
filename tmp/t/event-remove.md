(event-remove)=
# Event 'remove'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `remove`</small>
>
> Source: [`ops.RemoveEvent`](https://ops.readthedocs.io/en/latest/#ops.RemoveEvent) 

The `remove` event is emitted only once per unit: when the Juju controller is ready to remove the unit completely. The `stop` event is emitted prior to this, and all necessary steps for handling removal should be handled there.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- Triggers
- [Observing this event in Ops](#heading--observing-this-event-in-ops)



<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

The `remove` event is the last event a unit will ever see before going down, right after [`stop`](https://discourse.charmhub.io/t/6483). It is exclusively fired when the unit is in the [Teardown phase](https://discourse.charmhub.io/t/5938).

Handlers for this event should ensure that the workload is 'gracefully' shutdown.

> Note that by the time `remove` is fired, storage, relations and all charm resources will likely no longer be available. If you need to cleanup any of those, listen to `*-relation-broken` or `*-storage-detaching` instead.



<a href="#heading--triggers"><h2 id="heading--triggers">Triggers</h2></a>

On kubernetes charms, the `remove` event will occur on pod churn, when the unit dies. On machine charms, the stop event will be fired when a unit is put down.

|   Scenario   | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Remove unit   | `juju remove-unit foo/0` (on machine) or <br> `juju remove-unit --num-units 1 foo` (on k8s)  | `stop -> [relation/storage teardown] -> remove` |

Of course, removing an application altogether will result in these events firing on all units.

If the unit has any relations active or any storage attached at the time the removal occurs, these will be cleaned up (in no specific order) between `stop` and `remove`. This means the unit will receive `stop -> (*-relation-broken | *-storage-detaching) -> remove`.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In `ops`, you can observe the `remove` event like you would any other:

```
self.framework.observe(self.on.remove, self._on_remove)
```

The [`remove` event object](https://ops.readthedocs.io/en/latest/#ops.RemoveEvent) does not expose any specific attributes.