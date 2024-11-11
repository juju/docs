(event-config-changed)=
# Event 'config-changed'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Lifecycle events <lifecycle-events>` > `config-changed`</small>
>
> Source: [`ops.ConfigChangedEvent`](https://ops.readthedocs.io/en/latest/#ops.ConfigChangedEvent)

This document describes the `config-changed` event.


**Contents:**
- [Emission sequence](#heading--emission-sequence)

<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>


The `config-changed` event is emitted in response to various events throughout a charm’s lifecycle:

- In response to a configuration change using the GUI or CLI.
- On networking changes (if the machine reboots and comes up with a different IP).
- Some time between the `install` event and the `start` event in the {ref}`startup phase of a charm's lifecycle <charm-lifecycle>`. <br>(The `config_changed` event will **ALWAYS** happen at least once, when the initial configuration is accessed from the charm.)

Callbacks associated with this event should ensure the current charm configuration is properly reflected in the underlying application configuration. Invocations of associated callbacks should be idempotent and should not make changes to the environment, or restart services, unless there is a material change to the charm's configuration, such as a change in the port exposed by the charm, addition or removal of a relation which may require a database migration or a "scale out" event for high availability, or similar.

Callbacks must not assume that the underlying applications or services have been started.

There are many situations in which `config-changed` can occur. In many of them,  the event being fired does not mean that the config has in fact changed, though it may be useful to execute logic that checks and writes workload configuration. For example, since `config-changed` is guaranteed to fire once during the startup sequence, some time after `install` is emitted, charm authors might omit a call to write out initial workload configuration during the `install` hook, relying on that configuration to be written out in their `config-changed` handler instead.

|  Scenario   | Example Command                          | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Create unit   | `juju deploy foo`<br>`juju add-unit foo`  | `install -> config-changed -> start` |
|  Configure a unit   | `juju config foo bar=baz`  | `config-changed` |