(event-container-pebble-ready)=
# Event '<container>-pebble-ready'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `<container>-pebble-ready`</small>
>
> Source: [`ops.PebbleReadyEvent`](https://ops.readthedocs.io/en/latest/index.html#ops.PebbleReadyEvent)

<!--
> - {ref}`How to operate workload containers <6468md>`
> - {ref}`Interact with Pebble <how-to-run-workloads-with-a-charm---kubernetes>`
-->

The `<container>-pebble-ready` event is emitted once the sidecar container has started and a Unix socket is available for Pebble. There is one `<container>-pebble-ready` event for each container defined in `charmcraft.yaml`. This event allows the charm to configure how services should be launched.

```{note}
 
This event is specific to Kubernetes sidecar charms and is only ever fired on Kubernetes deployments.

```

The `pebble-ready` event doesn't guarantee the workload container is *still* up. For example, if you manually `kubectl patch` during (for example) `install`, then you may receive this event after the old workload is down but before the new one is up.
For this reason it's essential, even in `pebble-ready` event handlers, to catch [`ConnectionError`](https://ops.readthedocs.io/en/latest/pebble.html#ops.pebble.ConnectionError) when using Pebble to make container changes. There is a [`Container.can_connect`()](https://ops.readthedocs.io/en/latest/#ops.Container.can_connect) method, but note that this is a point-in-time check, so just because `can_connect()` returns `True` doesn’t mean it will still return `True` moments later. So, **code defensively** to avoid race conditions.

Moreover, as pod churn can occur at any moment, `pebble-ready` events can be received throughout any phase of [a charm's lifecycle](https://juju.is/docs/sdk/a-charms-life). Each container could churn multiple times, and they all can do so independently from one another. In short, the charm should make no assumptions at all about the moment in time at which it may or may not receive `pebble-ready` events, or how often that can occur. The fact that the charm receives a `pebble-ready` event indicates that the container has just become ready (for the first time, or again, after pod churn), therefore you typically will need to **reconfigure your workload from scratch** every single time.

This feature of `pebble-ready` events make them especially suitable for a [holistic handling pattern](https://discourse.charmhub.io/t/deltas-vs-holistic-charming/11095).

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in `ops`</h2></a>

When using the `ops` library, you can observe the event like you would any other:

```
self.framework.observe(
    self.on.<container>_pebble_ready, 
    self._on_pebble_ready,
)
```

The [`PebbleReadyEvent`](https://ops.readthedocs.io/en/latest/#ops.PebbleReadyEvent) class is a subclass of [`WorkloadEvent`](https://ops.readthedocs.io/en/latest/#ops.WorkloadEvent), so it exposes a [`workload`](https://ops.readthedocs.io/en/latest/#ops.WorkloadEvent.workload) attribute which returns the [`ops.Container`](https://ops.readthedocs.io/en/latest/#ops.Container) instance the event is associated with.

<!-- THIS IS USEFUL BUT DOES NOT BELONG HERE. MOVE TO PY-LIBJUJU TO PY-LIBJUJU DOCS, WHEN WE HAVE THEM. 
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>

For integration tests, the first deployment of the charm will trigger pebble-ready as part of the start process.

```python
resources = {
        "nginx-image": "ubuntu/nginx",
    }
await ops_test.model.deploy(charm, resources=resources, application_name=<application name>)
```
Scale-up operations will do so as well.
```python
await ops_test.model.applications[<application name>].scale(scale=<total number of units>)
```

> Note:  `wait_for_idle` may return before the workload application is ready, and a `block_until` the service, e.g. via HTTP API, returns a “ready” status, would probably be needed.
-->