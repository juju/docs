(event-stop)=
# Event 'stop'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `stop`</small>
>
> Source: [`ops.StopEvent`](https://ops.readthedocs.io/en/latest/#ops.StopEvent)


This document describes the `stop` event.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Triggers](#heading--triggers)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

The `stop` event is the one-before-last event a unit will ever see before going down, the last one being {ref}``remove` <event-remove>`. It is exclusively fired when the unit is in the {ref}`Teardown phase <charm-lifecycle>`.

The `stop` event is emitted only once: when the Juju controller is ready to destroy the unit. When handling the `stop` event, charms should gracefully terminate all services for the supported application and update any relevant cluster/leader information to remove or update any data relating to the current unit. Additionally, the charm should ensure that the software will not automatically start again on reboot.


<a href="#heading--triggers"><h2 id="heading--triggers">Triggers</h2></a>

On kubernetes charms, the `stop` event will occur on pod churn, when the unit dies. On machine charms, the stop event will be fired as part of {ref}`the teardown sequence <charm-lifecycle>` when a unit goes down.
Ways to force the occurrence of a `stop` include:

- `juju remove-application`
- `juju remove-unit`

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In `ops`, you can observe the `stop` event like you would any other:

    self.framework.observe(self.on.stop, self._on_stop)

The [`stop` event object](https://ops.readthedocs.io/en/latest/#ops.StopEvent) does not expose any specific attributes.

<!--NOT RELEVANT HERE.
<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>

In `python-libjuju` you can kill units and application via 

`juju.Application.destroy_unit(*unit_names)`

`juju.Application.destroy()`

This will cause any affected unit to stop.
-->