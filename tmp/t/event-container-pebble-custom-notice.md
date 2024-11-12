(event-container-pebble-custom-notice)=
# Event '<container>-pebble-custom-notice'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `<container>-pebble-custom-notice`</small>
>
> Source: [`ops.PebbleCustomNoticeEvent`](https://ops.readthedocs.io/en/latest/index.html#ops.PebbleCustomNoticeEvent)

<!--
> - {ref}`How to operate workload containers <13019md>`
> - {ref}`Interact with Pebble <how-to-run-workloads-with-a-charm---kubernetes>`
-->

Juju emits the `<container>-pebble-custom-notice` event when a Pebble notice of type "custom" occurs for the first time or repeats. There is one `<container>-pebble-custom-notice` event for each container defined in `charmcraft.yaml`. This event allows the charm to respond to custom events that happen in the workload container.

```{note}
 
This event is specific to Kubernetes sidecar charms and is only ever fired on Kubernetes deployments.

```

> See more: {ref}`How to use custom notices from the workload container <13019md>`