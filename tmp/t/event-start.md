(event-start)=
# Event 'start'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `start`</small>
>
> Source: [`ops.StartEvent`](https://ops.readthedocs.io/en/latest/#ops.StartEvent)

This document describes the `start` event.

"Start" is the point where a Unit agent starts to join its relations and can respond to commands like `juju run`.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

The `start` event is triggered on each starting unit immediately after the first `config-changed` event. Callback methods bound to the event should be used to ensure that the charm’s software is in a running state. Note that the charm’s software should be configured to persist in a started state without further intervention from Juju or an administrator.

Also, on kubernetes charms, whenever a unit's pod churns, `start` will be fired again on that unit. 

|   Scenario   | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Create unit   | `juju deploy foo`<br>`juju add-unit foo`  | `install -> config-changed -> start` |
|  (k8s only) pod churn  | `kubectl delete pod -n model-name app-name-0`  | `stop -> upgrade-charm -> config-changed -> start` |
|  Cluster reboot | `microk8s stop; microk8s start`  | `start` |
|  Upgrade application | `juju `  | `stop -> upgrade-charm -> config-changed -> start` |

```{note}

In kubernetes sidecar charms, Juju provides no ordering guarantees regarding `start` and `*-pebble-ready`.

```

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In `ops`, you can observe this event like you would any other:
```python
# in MyCharm.__init__
self.framework.observe(self.on.start, self._on_start)
``` 

The [`start` event object](https://ops.readthedocs.io/en/latest/#ops.StartEvent) does not expose any specific attributes.

<!--NOT RELEVANT HERE.
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>

In `python-libjuju` you can start units by either scaling up an existing application via 
`juju.Application.add_unit` or `juju.Application.scale`, or you can deploy a new application via `juju.Model.deploy`.
-->