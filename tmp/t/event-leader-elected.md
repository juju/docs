(event-leader-elected)=
# Event 'leader-elected'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `leader-elected`</small>
>
> Source: [`ops.LeaderElectedEvent`](https://ops.readthedocs.io/en/latest/index.html#ops.LeaderElectedEvent) <br>
> See also: {ref}`Leader <6470md>`, {ref}`How to implement leadership <6470md>`


The `leader-elected` event is emitted for a unit that is elected as leader. Together with `leader-settings-changed`, it is one of two "leadership events". A unit receiving this event can be guaranteed that it will have leadership for approximately 30 seconds (from the moment the event is received). After that time, juju *might* have elected a different leader. The same holds if the unit checks leadership by `Unit.is_leader()`: if the result is `True`, then the unit can be ensured that it has leadership for the next 30s.

> Leadership can change while a hook is running. (You could start a hook on unit/0 who is the leader, and while that hook is processing, you lose network connectivity for a long time [more than 30s], and then by the time the hook notices, juju has already moved on to another leader.) 

> Juju doesn't guarantee that a leader will see every event: if the leader unit is overloaded long enough for the lease to expire (>30s), then juju will elect a different leader. Events that fired in between would be received units that are not leader yet or not leader anymore.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

- `leader-elected` is always emitted **after** peer-`relation-created` during the Startup phase. However, by the time `relation-created` runs, juju may already have a leader. This means that, in peer-relation-created handlers, it might already be the case that `self.unit.is_leader()` returns `True` even though the unit did not receive a leadership event yet. If the starting unit is *not* leader, it will receive a {ref}``leader-settings-changed` <event-leader-settings-changed>` instead.

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Start new unit   | `juju deploy foo`<br>`juju add-unit foo`  | (new leader) `install -> (*peer)-relation-created -> leader-elected`|

-  During the Operation phase, leadership changes can in principle occur at any time, for example if the leader unit is unresponsive for some time. When a leader loses leadership it will only receive a `leader-settings-changed` event, just like all the other non-leader units. The new leader will receive `leader-elected`.

> It is not possible to select a specific unit and 'promote' that unit to leader, or 'demote' an existing leader unit. Juju has control over which unit will become leader after the current leader is gone. 

```{note}

However, you can cause leadership change by destroying the leader unit or killing the jujud-machine service in operator charms.

- non-k8s models: `juju remove-unit <leader_unit>`
- operator charms: `juju ssh -m <id> -- systemctl stop jujud-machine-<id>`
- sidecar charms: ssh into the charm container, source the `/etc/profile.d/juju-introspection.sh` script, and then get access to a few cli tools, including `juju_stop_unit`.

That will cause the lease to expire within 60s, and another unit of the same application will be elected leader and receive `leader-elected`. 

```

- If the leader unit is removed, then one of the remaining units will be elected as leader and see the `leader-elected` event; all the other remaining units will see `leader-settings-changed`. If the leader unit was not removed, no leadership events will be fired on any units.

> Note that unless there's only one unit left, it is impossible to predict or control which one of the remaining units will be elected as the new leader.

|   Scenario  | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Current leader loses leadership   | `juju remove-unit foo`  | (new leader): `leader-elected` <br> (all other foo units): `leader-settings-changed`|


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>


In `ops`, you can observe this event like you would any other:
```python
# in MyCharm.__init__
self.framework.observe(self.on.leader_elected, self._on_leader_elected)
```
The [`leader-elected` event object](https://ops.readthedocs.io/en/latest/#ops.LeaderElectedEvent) does not expose any specific attributes.

You can test for leadership at any time with [`Charm.unit.is_leader()`](https://ops.readthedocs.io/en/latest/index.html#ops.Unit.is_leader). This is an instant check, whose result is never cached by `ops`. See {ref}`this <talking-to-a-workload-control-flow-from-a-to-z>` for more.

```{note}

When writing unit tests with the OF harness, leadership is set with `self.harness.set_leader(True)` ([`ops.testing.Harness.set_leader`](https://ops.readthedocs.io/en/latest/harness.html#ops.testing.Harness.set_leader)).

```

```{note}

Behind the scenes, OF uses the hook-tools
[is-leader](https://discourse.charmhub.io/t/hook-tools/1163#heading--is-leader),
[leader-set](https://discourse.charmhub.io/t/hook-tools/1163#heading--leader-set) and
[leader-get](https://discourse.charmhub.io/t/hook-tools/1163#heading--leader-get)
to interact with juju regarding leadership.

```

<!--NOT RELEVANT HERE.
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>

To obtain the leadership status of every unit, you can use [juju.unit.Unit.is_leader_from_status](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html?highlight=is_leader_from_status#juju.unit.Unit.is_leader_from_status):

```python
units = ops_test.model.applications[app_name].units
leadership_status = [await units[i].is_leader_from_status() for i in range(len(units))]
```

This can be combined with `block_until_with_coroutines` to [block until a leader is elected](https://github.com/juju/python-libjuju/issues/609).

-->