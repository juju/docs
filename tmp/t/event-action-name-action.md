(event-action-name-action)=
# Event '<action name>-action'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > `<action name>-action`</small>
>
> See also: {ref}`How to handle charm actions <6466md>` <br>
> Source: [`ops.charm.ActionEvent`](https://ops.readthedocs.io/en/latest/#ops.charm.ActionEvent)

This document describes the `<action name>-action` event. Actions are methods of a charm designed to be directly called by the cloud administrator when the charm is deployed, in contrast with events, which are fired by juju and allow the charm to automatically respond to changing circumstances.

An action can have "parameters" (passed by the cloud admin to the charm) and "results" (passed by the charm back to the cloud admin, once the handler returns).

> Note: If hyphens are used in action names, they are replaced with underscores in the corresponding event names. For example, an action named `snapshot-database` would result in an event named `snapshot_database_action` being triggered when the action is invoked.


**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>


The `<action name>-action` event will trigger after a user invokes the `action-name` from the Juju CLI. It can be emmited to a single unit:


|  Scenario  | Example Command            | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Invoke action  | `juju run <unit/0> foo` | `foo_action` (on unit/0) |

Or to several units of a same application:

|   Scenario   | Example Command            | Resulting Events                     |
| :-------: | -------------------------- | ------------------------------------ |
|  Invoke action  | `juju run <unit/0> <unit/1> foo` | `foo_action` (on units 0 and 1) |



> Note that the action handler in the charm can in principle cause other events to be fired. For example:
> - Deferred events will trigger before the action.
> - If the action handler updates relation data, a `<relation name>_relation_changed` will be emitted afterwards on the affected units.


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

You can subscribe to the event:

```python
self.framework.observe(
    charm.on.<action name>_action, 
    self.<action name>_action
)
```

Actions are surfaced as events that a charm can observe, similarly to [lifecycle events](https://juju.is/docs/sdk/events). Action names are parsed by the Charmed Operator Framework and surfaced as events named `<action_name>_action`.

```{note}

If hyphens are used in action names, they are replaced with underscores in the corresponding event names. For example, an action named `snapshot-database` would result in an event named `snapshot_database_action` being triggered when the action is invoked.

```

Action handlers are passed an [`ActionEvent`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent) as their first parameter, and thus have access to the action parameter values through the `<event>.params` construct. In addition to the `params` dict, the [`ActionEvent`](https://ops.readthedocs.io/en/latest/#ops.ActionEvent) class provides three convenience methods to the developer:

- `<event>.fail(message="")`: Report to the administrator that the action has failed, optionally providing a message indicating why the failure occured.
- `<event>.log(message)`: Log a message for the administrator (available while the action is running).
- `<event>.set_results(results)`: Report the result of the action, where `results` is a dictionary. The maximum size must be under the maximum size allowed by the OS for arguments (typically around 100KB).



```{note}

Note that any stderr output logged during the action handler execution will be injected into the results under the 'Stdout' key. For this reason, we don't allow a "Stdout" key to be used in `set_results`'s argument.

```

```python
def do_something_action(self, event):
	"""Handle *do-something* action."""
	result_dict = _my_results_getter()
	event.set_results(result_dict)
```