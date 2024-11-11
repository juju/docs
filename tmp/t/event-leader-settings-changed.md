(event-leader-settings-changed)=
# Event 'leader-settings-changed'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `leader-settings-changed`</small>
>
> Source: [`ops.LeaderSettingsChanged`](https://ops.readthedocs.io/en/latest/index.html#ops.LeaderSettingsChangedEvent) </br>
> See also: {ref}`Leadership hook tools <6471md>` <br>

The `leader-settings-changed` event is emitted when a leadership change occurs, all units that are not the new leader will receive the event. Also, this event is emitted if changes have been made to leader settings.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops) 

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

During startup sequence, for all non-leader units:

|   Scenario   | Example Command  | Resulting Events |
| :-------: | -------------------------- | ------------------------------------ |
|  Create unit   | `juju deploy foo -n 2`  | `install -> leader-settings-changed -> config-changed -> start` (non-leader)|


If the leader unit is rescheduled, or removed entirely. When the new leader is elected:

|  Scenario   | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Removal of leader   | `juju remove-unit foo/0` (foo/0 being leader)  | `leader-settings-changed` (for all non leaders) |

> Since this event needs leadership changes to trigger, check out {ref}`triggers for `leader-elected` <6471md>` as the same situations apply for `leader-settings-changed`.


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In Ops, you can observe the event like you would any other:

```
self.framework.observe(
    charm.on.leader_settings_changed, 
    self._leader_settings_changed
)
```

With Ops, you can test for leadership with `self.unit.is_leader()` ([`ops.Unit.is_leader`](https://ops.readthedocs.io/en/latest/index.html#ops.Unit.is_leader)).

When writing unit tests with the OF harness, leadership is set with `self.harness.set_leader(True)` ([`ops.testing.Harness.set_leader`](https://ops.readthedocs.io/en/latest/harness.html#ops.testing.Harness.set_leader)).

```{note}

Behind the scenes, OF uses the hook-tools
[is-leader](https://discourse.charmhub.io/t/hook-tools/1163#heading--is-leader),
[leader-set](https://discourse.charmhub.io/t/hook-tools/1163#heading--leader-set) and
[leader-get](https://discourse.charmhub.io/t/hook-tools/1163#heading--leader-get)
to interact with juju regarding leadership.

```

<!--NOT RELEVANT HERE.
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>
-->