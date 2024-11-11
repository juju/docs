(event-update-status)=
# Event 'update-status'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `update-status`</small>
>
> Source: [`ops.UpdateStatusEvent`](https://ops.readthedocs.io/en/latest/#ops.UpdateStatusEvent)
>
> See also: [Juju | Status](https://juju.is/docs/juju/status)

The `update-status` event is fired periodically by Juju at regular intervals (default: 5m). The `update-status` hook runs model-wide.

Historically, this hook was intended to allow authors to run code that gets the “health” of the application. However, health checks can also be specified via {ref}`pebble <6484md>`.

Since the update-status interval is model-wide (not per application) and is set by the user (for example, it can be set to once per hour), charms should not rely on it for critical operations.

In integration tests, unless specifically testing the update-status hook, you may want to "disable" it so it doesn't interfere with the test. This can be achieved by setting the interval to e.g. 1h at the beginning of the test.

**Contents:**
- [Set the update-status interval](#heading--set-the-update-status-interval)
    - [Existing model](#heading--existing-model)
    - [New model](#heading--new-model)
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)




<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

By default, the `update-status` event is triggered by the Juju controller at 5-minute intervals. This event can be used to monitor the health of deployed charms and determine the status of long running tasks (such as package installation), updating the status message reported to Juju accordingly. The interval can be configured model-wide, for example: `juju model-config update-status-hook-interval=1m`.

As it is triggered periodically, the `update-status`  can happen in between any other charm events.

<a href="#heading--set-the-update-status-interval"><h2 id="heading--set-the-update-status-interval">Configuring the update-status interval</h2></a>
<a href="#heading--existing-model"><h3 id="heading--existing-model">Existing model</h3></a>

```shell
juju model-config update-status-hook-interval=1m
```
```{note}

[`jhack ffwd`](https://discourse.charmhub.io/t/jhack-utils-ffwd/6602) can be used to temporarily crank the interval up while developing/testing/debugging.

```

<a href="#heading--new-model"><h3 id="heading--new-model">New model</h3></a>


To set the hook interval at model creation time:

```shell
juju add-model --config update-status-hook-interval="60m" MyModel
```

To set the default hook interval for all future models at controller creation time:
```shell
juju bootstrap microk8s MyCtrl --model-default update-status-hook-interval="60m"
```


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In Ops, you can register event hooks to observe the update-status event,
```python
self.framework.observe(
    self.on.update_status, self._on_update_status
)
```

<!--NOT RELEVANT HERE.
<a href="#heading--debugging"><h4 id="heading--debugging">Debugging</h4></a>

To debug the update-status hook of a running charm, 

```shell
juju debug-code your-app/0 update-status
```

It may be useful to temporarily reduce the hook interval to 10s for this purpose.

<a href="#heading--python-libjuju"><h3 id="heading--python-libjuju">`python-libjuju`</h3></a>
From within integration tests written with pytest-operator, you can set the interval with:

```python
await ops_test.model.set_config(
    {"update-status-hook-interval": "60m"}
)
```
-->