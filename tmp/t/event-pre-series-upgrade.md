(event-pre-series-upgrade)=
# Event 'pre-series-upgrade'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `pre-series-upgrade`</small>
>
> Source: [`ops.PreSeriesUpgradeEvent`](https://ops.readthedocs.io/en/latest/#ops.PreSeriesUpgradeEvent)

This event is triggered when an operator runs `juju upgrade-series <machine> prepare ...` from the command line.    Read [here](https://juju.is/docs/olm/upgrade-a-machines-series#heading--upgrading-a-machines-series) to learn more about the series upgrade process.  This event hook allows charm units on the machine being upgraded to do any necessary tasks prior to the upgrade process beginning (which may involve e.g. being rebooted, etc.). 

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

|  Scenario | Example command | Resulting events |
|:-:|-|-|
|[Upgrade series](https://juju.is/docs/olm/upgrade-a-machines-series#heading--upgrading-a-machines-series) | `juju upgrade-series <machine> prepare`| `pre-series-upgrade` -> (events on pause until upgrade completes) |

 Notably, after this event fires and before the [post-series-upgrade event](https://discourse.charmhub.io/t/post-series-upgrade-event/6472) fires, juju will pause events and changes for all units on the machine being upgraded.  There will be no config-changed, update-status, etc. events to interrupt the upgrade process until after the upgrade process is completed via `juju upgrade-series <machine> complete`.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In Ops, you can register event hooks to observe the pre-series-upgrade event,

```
self.framework.observe(
    self.on.pre_series_upgrade, self._on_pre_series_upgrade
)
```

```{caution}

 Leadership is pinned during the series upgrade process.  Even if the current leader dies or is removed, re-election will not occur for applications on the upgrading machine until the series upgrade operation completes.

```

<!--NOT RELEVANT HERE.
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>
-->