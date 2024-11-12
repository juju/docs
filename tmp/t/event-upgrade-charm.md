(event-upgrade-charm)=
# Event 'upgrade-charm'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `upgrade-charm`</small>
>
> Source: [`ops.UpgradeCharmEvent`](https://ops.readthedocs.io/en/latest/#ops.UpgradeCharmEvent)

<!--
> - [ops.CharmEvents.upgrade_charm](https://ops.readthedocs.io/en/latest/index.html#ops.CharmEvents.upgrade_charm)
> - [juju.application.Application.upgrade_charm](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.upgrade_charm)
-->

The `upgrade-charm` event is emitted for a unit that is undergoing an upgrade.

The event is emitted after the new charm code has been unpacked - therefore this event is handled by the callback method bound to the event in the new codebase.

The associated callback should be used to reconcile the current state written by an older version into whatever form is required by the current charm version. An example of a reconciliation that needs to take place is to migrate an old relation data schema to a new one.

```{important}

- Typically, operations performed on `upgrade-charm` should also be considered for [`install`](https://discourse.charmhub.io/t/install-event/6469).
- In some cases, [`config-changed`](https://discourse.charmhub.io/t/config-changed-event/6465) can be used instead of `install` and `upgrade-charm` because it is guaranteed to fire after both.
- Note that you cannot upgrade a Charmhub charm to the same version. However, upgrading a local charm from path works (and goes through the entire upgrade sequence) even if the charm is exactly the same.

```

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops) 


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

|  Scenario | Example command | Resulting events |
|:-:|-|-|
|Upgrade kubernetes charm | `juju refresh` | `stop` (old charm) -> `upgrade-charm` (new charm) -> `config-changed` -> `leader-settings-changed` (if the unit is not the leader) -> `start` -> `*-pebble-ready`|
|Upgrade machine charm | `juju refresh` | `upgrade-charm` -> `config-changed` -> `leader-settings-changed` (if the unit is not the leader) -> `start`|
|Attach resource | `juju attach-resource foo bar=baz` | (same as upgrade) |

```{important}

An upgrade does NOT emit:\
- any relation events (unless relation data is intentionally modified in one of the upgrade sequence hooks)\
- {ref}``leader-elected` <6485md>`

```


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In Ops, you can observe this event like you would any other:

```python
# in MyCharm.__init__
self.framework.observe(self.on.upgrade_charm, self._upgrade_charm)
``` 

The [`upgrade_charm` event object](https://ops.readthedocs.io/en/latest/#ops.UpgradeCharmEvent) does not expose any specific attributes.


<!-- THIS IS USEFUL BUT DOES NOT BELONG HERE. MOVE TO PY-LIBJUJU TO PY-LIBJUJU DOCS, WHEN WE HAVE THEM. 
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>

`Application.refresh()` or [`Application.upgrade_charm()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.upgrade_charm) can be used to upgrade from charmhub or from path. An `idle_period` of ~60-90 sec is required to make sure all units started upgrading before `wait_for_idle` returns.

See also: [juju/1974065](https://bugs.launchpad.net/juju/+bug/1974065)

```python
await ops_test.model.applications[app_name].refresh(
    path=path_to_charm, resources=charm_resources
)
await ops_test.model.wait_for_idle(
    apps=[app_name], status="active", timeout=300, idle_period=60
)
```


```{caution}

 The act of upgrading often includes rescheduling the pod, which means you have a new container with a new pebble coming up and the service may no longer be present, because you are in a new container. – @jameinel

```

-->