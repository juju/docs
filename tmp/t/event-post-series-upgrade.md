(event-post-series-upgrade)=
# Event 'post-series-upgrade'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `post-series-upgrade`</small>
>
> Source: [`ops.PostSeriesUpgradeEvent`](https://ops.readthedocs.io/en/latest/#ops.PostSeriesUpgradeEvent)

This event is triggered when an operator runs `juju upgrade-series <machine> complete` from the command line.    Read [here](https://juju.is/docs/olm/upgrade-a-machines-series#heading--upgrading-a-machines-series) to learn more about the series upgrade process.  This event hook allows charm units on the machine being upgraded to do any necessary tasks imediately following the upgrade process (which may have involved e.g. being rebooted, etc.). 

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

|  Scenario | Example command | Resulting events |
|:-:|-|-|
|[Upgrade series](https://juju.is/docs/olm/upgrade-a-machines-series#heading--upgrading-a-machines-series) | `juju upgrade-series <machine> complete` | `post-series-upgrade` -> (paused events now resume) |

Notably, after this event fires all paused/queued changes that accumulated since the [pre-series-upgrade event](https://discourse.charmhub.io/t/pre-series-upgrade-event/6473) fired will resume for all units on the machine that was upgraded.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In Ops, you can register event hooks to observe the pre-series-upgrade event,

```
self.framework.observe(
    self.on.post_series_upgrade, self._on_post_series_upgrade
)
```

```{caution}

 Leadership is pinned during the series upgrade process.  Even if the current leader died or was removed, re-election does not occur until the upgrade process completes.

```

<!--NOT RELEVANT HERE.
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>
-->