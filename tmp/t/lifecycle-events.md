(lifecycle-events)=
# Lifecycle events

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > Lifecycle events</small>

The bulk of the events a charm will see during its lifetime are "lifecycle events": broadly defined as: events that don't fit into any other specific category.

<!--The most common [events](https://ops.readthedocs.io/en/latest/#ops.charm.HookEvent) that Charm authors should consider handling explicitly are:

- `install`
- `config-changed`
- `start`
- `upgrade-charm`
- `update-status`
- `<container>-pebble-ready`
- `<container>-pebble-custom-notice`
- `stop`
- `remove`
-->

**Contents:**
- [Complete list of lifecycle events](#heading--complete-list-of-lifecycle-events)
- [Lifecycle event triggers](#heading--lifecycle-event-triggers)
- [Lifecycle events in Ops](#heading--lifecycle-events-in-ops)


<a href="#heading--complete-list-of-lifecycle-events"><h2 id="heading--complete-list-of-lifecycle-events">Complete list of lifecycle events</h2></a>

- {ref}``start` <event-start>`: fired as soon as the unit initialization is complete.
- {ref}``config-changed` <event-config-changed>`: fired whenever the cloud admin changes the charm configuration *.
- {ref}``install` <event-install>`: fired when juju is done provisioning the unit.
- {ref}``<container>-pebble-ready` <event-container-pebble-ready>`: fired on kubernetes charms when the requested container is ready.
- {ref}``<container>-pebble-custom-notice` <event-container-pebble-custom-notice>`: fired when a Pebble custom notice is triggered.
- [`<container>-pebble-check-failed`](https://ops.readthedocs.io/en/latest/#ops.PebbleCheckFailedEvent): fired when a Pebble check passes the failure threshold (in Juju 3.6 and above)
- [`<container>-pebble-check-recovered`](https://ops.readthedocs.io/en/latest/#ops.PebbleCheckRecoveredEvent): fired when a Pebble check passes after previously reaching the failure threshold (in Juju 3.6 and above)
- {ref}``leader-elected` <event-leader-elected>`: fired on the new leader when juju elects one.
- {ref}``leader-settings-changed` <event-leader-settings-changed>`: fired on all follower units when a new leader is chosen.
- {ref}``pre-series-upgrade` <event-pre-series-upgrade>`: fired before the series upgrade takes place.
- {ref}``post-series-upgrade` <event-post-series-upgrade>`: fired after the series upgrade has taken place.
- {ref}``stop` <event-stop>`: fired before the unit begins deprovisioning.
- {ref}``remove` <event-remove>`: fired just before the unit is deprovisioned.
- {ref}``update-status` <event-update-status>`: fired automatically at regular intervals by juju.
- {ref}``upgrade-charm` <event-upgrade-charm>`: fired when the cloud admin upgrades the charm.
- {ref}``collect-metrics` <event-collect-metrics-deprecated>` : (deprecated, will be removed soon)

<a href="#heading--lifecycle-event-triggers"><h2 id="heading--lifecycle-event-triggers">Lifecycle event triggers</h2></a>

All lifecycle events are triggered in a predictable pattern following a specific action by the administrator (with the exception of `update-status`, which triggers on an interval, and Kubernetes container events, such as {ref}``<container >-pebble-ready` <event-container-pebble-ready>`, which can occur at any time). For example:

|  Scenario   | Example Command                          | Resulting Events                     |
| :-------: | ---------------------------------------- | ------------------------------------ |
|  Deploy   | `juju deploy ./hello-operator.charm`     | `install -> config-changed -> start -> <container>-pebble-ready` |
|   Scale   | `juju add-unit -n 2 hello-operator`      | `install -> config-changed -> start -> <container>-pebble-ready` |
| Configure | `juju config hello-operator thing=foo`   | `config-changed`                     |
|  Upgrade  | `juju upgrade-charm hello-operator`      | `upgrade-charm -> config-changed ->  <container>-pebble-ready`    |
|  Remove   | `juju remove-application hello-operator` | `stop -> remove`                     |

```{note}

Exception to the "all lifecycle events are fired in a predictable pattern following cloud admin actions" rule is {ref}``<container>-pebble-ready` <event-container-pebble-ready>`. As kubernetes pods can churn autonomously (outside of juju's control), it can happen that the container comes and goes at unpredictable times. When that happens, the charm will receive **again** `<container>-pebble-ready`. See {ref}`the page on `pebble-ready` <event-container-pebble-ready>` for more details.

```

<a href="#heading--lifecycle-events-in-ops"><h2 id="heading--lifecycle-events-in-ops">Lifecycle events in Ops</h2></a>

In `ops`, all lifecycle events are accessible via `CharmBase`'s  `on` attribute.
So you typically want to observe these events by doing:
```python
# in MyCharm(CharmBase)  __init__():
self.framework.observe(self.on.start, self._on_start)
self.framework.observe(self.on.install, self._on_install)
...
```
 

<!--COMMENT: LET's KEEP THIS DOC JUST ABOUT THE EVENTS THEMSELVES
<h2 id="heading--hook-failure">Failure in handling events</h3>

If the code of the operator for handling a particular event fails, for example with an exception propagating outside of the [event handler](https://juju.is/docs/sdk/constructs), Juju will [retry the failed event handler](https://juju.is/docs/olm/configure-a-model) with an exponential back-off, capped at five minutes.

-->