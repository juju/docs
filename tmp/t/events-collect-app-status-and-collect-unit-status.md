(events-collect-app-status-and-collect-unit-status)=
# Events 'collect-app-status' and 'collect-unit-status'

> <small> {ref}`Event <event>` > {ref}`List of events > Ops events <12562md>` > `collect-app-status` and `collect-unit-status`</small>
>
> Source:  [`CollectStatusEvent`](https://ops.readthedocs.io/en/latest/#ops.CollectStatusEvent)

The `collect-app-status` and `collect-unit-status`  events are produced not by Juju but Ops.

The events are emitted on the charm, starting from `ops 2.7`, before the framework exits. The goal is to offer the charm a chance to uniformly set the application or unit status based on its internal state after processing the Juju event that triggered this execution.

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing these events in Ops](#heading--observing-these-events-in-ops)	


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

The `collect-app-status` and `collect-unit-status` events are fired once by the framework *after* any Juju event is emitted, and before any other framework event is emitted. The `-app-status` event is for setting application status, and the `-unit-status` event for setting unit status.

For example, if the unit is processing a `config-changed` event, the charm will see:

> `config-changed` -> **`collect-unit-status`** -> `pre-commit` -> `commit`


<a href="#heading--observing-these-events-in-ops"><h2 id="heading--observing-these-events-in-ops">Observing these events in Ops</h2></a>

To observe the `collect-unit-status` event:

```python
# in MyCharm.__init__
self.framework.observe(self.on.collect_unit_status, self._on_collect_unit_status)
``` 

This will observe the event uniformly across the units of the charm.


To observe the `collect-app-status` event:

```python
# in MyCharm.__init__
self.framework.observe(self.on.collect_app_status, self._on_collect_app_status)
``` 

This will ensure that only the leader unit processes it, and the result becomes the overall application status.

A [`CollectStatusEvent`](https://ops.readthedocs.io/en/latest/#ops.CollectStatusEvent) instance does not expose any specific attributes but exposes an `add_status` method to automatically manage statuses with different priorities. Read the [API reference docs](https://ops.readthedocs.io/en/latest/#ops.CollectStatusEvent) for more information and examples.