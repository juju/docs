(context-scenario)=
# Context (Scenario)

> <small> {ref}`Scenario <scenario>` > Context </small>

In Scenario, the `Context` object represents the charm code and all of the metadata that is associated with it.

Scenario is about simulating events on charms.

The Context encapsulates:
- what charm type should be instantiated and passed to `ops.main` when the event emission is simulated
- what is in the charm's `charmcraft.yaml` / `metadata.yaml` + `actions.yaml` + `config.yaml`
- what is the charm execution root (a temporary directory and its contents when the charm is executed)
- the 'side-effects' of a charm execution:
  - any `stdout/stderr` output that gets pushed in the `juju-log`
- useful historical data about the intermediate steps of the state transition. These allow you peek into the charm execution black-box and write assertions about the path taken by the charm on its way to the 'final' state.
  - `unit_status_history: List[StatusBase]`
  - `app_status_history: List[StatusBase]`
  - `workload_version_history: List[str]`
- the events emitted on the charm.

# Basic Usage

```python
from scenario import Context, State
from charm import MyCharm

ctx = Context(charm_type=MyCharm)
state_out: State = ctx.run('start', State())
```

## Advanced usage

By default, `Context` will attempt to automatically load the charm metadata from the filesystem position of the module containing the charm type you pass to it.
If you need to customize any of the metadata, you can override this behaviour:

```python
from scenario import Context
from charm import MyCharm

ctx = Context(charm_type=MyCharm, meta={"requires": {"foo": {"interface": "bar"}}})
```

## Assertions on outputs and side effects

The `Context.run()` API is as black-box as it gets: pass in a state, get out another state. 
Charm testing however requires at times to inspect the execution flow of the charm. This means being able to introspect transient states such as status changes that are later discarded (a charm sets `maintenance` and then `active`: `active` will be part of the final state, but `maintenance` would be lost). 

Also consider logging output: that data is passed to Juju via the `debug-log` hook tool but is write-only: a charm cannot retrieve the logs it had emitted before.  But it can be useful to write testing code to validate debugging output.

Finally, it is often useful to inspect the execution path a charm took by examining what custom events a charm emitted on itself while executing the 'toplevel' Juju event. 

`Context` captures all these transient 'side effects' of the charm execution. 
These are not returned by the `.run()` call, as they do not belong in the `State`. Instead, they are attached to the `Context` itself.

```python
import ops
from scenario import Context, State
from charm import MyCharm, MyCustomEventType

ctx = Context(charm_type=MyCharm)
ctx.run('start', State())

# assert the charm set these statuses:
assert ctx.unit_status_history[0] == ops.MaintenanceStatus('starting...')
assert ctx.unit_status_history[1] == ops.MaintenanceStatus('workload coming up...')
assert ctx.unit_status_history[2] == ops.ActiveStatus('')

# assert the contents of the juju-log stack
assert ctx.juju_log[-1] == "setting active status"

# assert certain (custom) events have been emitted on the charm
assert isinstance(ctx.emitted_events[0], StartEvent)
assert isinstance(ctx.emitted_events[3], MyCustomEventType)
```

```{note}
 
These data structures are **not** automatically cleared! If you `.run()` multiple events in a sequence, they will keep adding up. You can call `Context.clear()` to clear all histories and emitted events.

```


# White-box testing with Scenario

When you call `Context.run()`, Scenario will set up the operator framework, emit the event, and tear everything down again.
This means that there is no easy way to get a hold of the charm instance to run tests against it.
In order to support this use case, the `Context` object exposes some API to give you temporarily back control of the framework before the event is emitted.

```python
from scenario import State, Context
state_in = State(
    config={'foo': 'bar'},
    unit_status=BlockedStatus("config not good"))
# suppose the charm is in blocked status because some previous state contained an invalid config.
# the config foo=bar *now* is correct, but the charm hasn't been notified of the config change yet.

with Context(MyCharm).manager("config-changed", state_in) as mgr:
    # if you get mgr.charm now, you will obtain the charm instance before the event has been emitted. So if you inspect the state, it will look exactly as our initial state_in.
    charm = mgr.charm
    assert charm.unit.status == BlockedStatus("config not good")
    # you can also make calls on internal APIs
    assert charm._check_config() is False
  
    # this emits the event
    state_out = mgr.run()
  
    # now the framework has emitted the event and the charm has executed all observers, so the state has changed
    assert charm.unit.status == ActiveStatus("config good")

# you can also run your assertions on the output state as usual
assert state_out.unit_status == ActiveStatus("config good")
```