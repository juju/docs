(hook)=
# Hook

In Juju, a **hook** is a notification from  the controller agent through the unit agent to the charm that the internal representation of Juju has changed in a way that requires a reaction from the charm so that the unit's state and the controller's state can be reconciled.


In the charm SDK, in {ref}`Ops <ops-ops>`, Juju hooks are translated into Ops events = 'events', specifically, into classes that inherit from [`HookEvent`](https://ops.readthedocs.io/en/latest/index.html#ops.HookEvent).


**Contents:**
- [List of hooks](#heading--list-of-hooks)	


## List of hooks

> [Source](https://github.com/juju/juju/blob/main/internal/charm/hooks/hooks.go)

### Lifecycle hooks

#### `collect-metrics`
#### `config-changed`

The `config-changed` hook always runs once immediately after the `install` hook, and likewise after the `upgrade-charm` hook. It also runs whenever the service configuration changes, and when recovering from transient unit agent errors.

### `install`

The `install` hook always runs once, and only once, before any other hook. 

#### `leader-deposed`
#### `leader-elected`
#### `leader-settings-changed`

#### `post-series-upgrade`
> Removed in Juju 4.

####  `pre-series-upgrade`
> Removed in Juju 4.

#### `remove`

### `start`

The `start` hook always runs once immediately after the first `config-changed` hook; there are currently no other circumstances in which it will be called, but this may change in the future.

### `stop`

The `stop` hook is the last hook to be run before the unit is destroyed. In the future, it may be called in other situations.


### `update-status`
### `upgrade-charm`

The `upgrade-charm` hook always runs once immediately after the charm directory contents have been changed by an unforced charm upgrade operation, and *may* do so after a forced upgrade; but will *not* be run after a forced upgrade from an existing error state. (Consequently, neither will the `config-changed` hook that would ordinarily follow the `upgrade-charm`.

### Action hooks

For each action, a hook named on the template `<action name>-action`.

### Pebble hooks
> These hooks require an associated workload/container, and the name of the workload/container whose change triggered the hook. The hook file names that these kinds represent will be prefixed by the workload/container name; for example, `mycontainer-pebble-ready`.


####  `<container>-pebble-change-updated` 

#### `<container>-pebble-check-failed`

> Added in Juju 3.6.

#### `<container>-pebble-check-recovered`
> Added in Juju 3.6.

#### `<container>-pebble-custom-notice`

#### `<container>-pebble-ready`

### Relation hooks

> These hooks require an associated relation, and the name of the relation unit whose change triggered the hook. The hook file names that these kinds represent will be prefixed by the relation name; for example, `db-relation-joined`.

#### `<endpoint>-relation-broken`

The `relation-broken` hook is not specific to any unit, and always runs once when the local unit is ready to depart the relation itself. Before this hook is run, a `relation-departed` hook will be executed for every unit known to be related; it will never run while the relation appears to have members, but it may be the first and only hook to run for a given relation. The stop hook will not run while relations remain to be broken.

#### `<endpoint>-relation-changed`

The `relation-changed` hook for a given unit always runs once immediately following the `relation-joined` hook for that unit, and subsequently whenever the related unit changes its settings (by calling `relation-set` and exiting without error). Note that immediately only applies within the context of this particular runtime relation -- that is, when `foo-relation-joined` is run for unit `bar/99` in relation id `foo:123`, the only guarantee is that/ the next hook to be run *in relation id `foo:123`* will be `foo-relation-changed` for `bar/99`. Unit hooks may intervene, as may hooks for other relations, and even for other foo relations.


#### `<endpoint>-relation-created`
#### `<endpoint>-relation-departed`

The "relation-departed" hook for a given unit always runs once when a related unit is no longer related. After the "relation-departed" hook has run, no further notifications will be received from that unit; however, its settings will remain accessible via relation-get for the complete lifetime of the relation.

#### `<endpoint>-relation-joined`

The "relation-joined" hook always runs once when a related unit is first seen.

### Storage hooks

> These hooks require an associated storage. The hook file names that these kinds represent will be prefixed by the storage name; for example, `shared-fs-storage-attached`.

#### `<storage>-storage-attached`
#### `<storage>-storage-detaching`


### Secret hooks

> These hooks require an associated secret.

#### `secret-changed`

Triggered by Juju on a secret's observer when the secret's owner changes the secret's contents.

#### `secret-expired`
> Currently supported only for charm secrets.

Triggered by Juju on a secret's owner when a secret’s expiration time elapses. 

#### `secret-remove`
> Currently supported only for charm secrets.

Triggered by Juju on a secret's owner when one of the secret's revisions can be removed.

#### `secret-rotate`
> Currently supported only for charm secrets.

Triggered by Juju on a secret's owner when the secret’s rotation policy elapses . 



<!--

https://juju.is/docs/sdk/the-juju-execution-flow-for-a-charm: 
The Juju [controller](https://juju.is/docs/olm/controller) sends an [event](https://juju.is/docs/sdk/event) to a unit [agent](https://juju.is/docs/olm/agent) that is in the charm container / VM. The unit agent executes the charm according to certain environment variables.


terminology: hooks is Juju-side, events is Ops-side
All hooks are events. Not all events are hooks. Hence, hookevent makes sense. The definition of an Ops event as a data structure that encapsulates part of the execution context of a charm is true of hook events but not of custom events.

A charm is a state machine. This state machine is event-driven. If some conditions are met, an event is triggered that will move the machine to a different state.

We created a charm. The first state is `install`. Suppose that means creating some file. 

hook = the process of creating and checking this file.
the state condition = is the file created?

User types `juju deploy x`. ... unit agent communicates with the charm via hooks. Which hook gets fired depends on the charm. "You're in this state but have still not met the exit conditions that would allow you to move to a different state."

Running Hooks
The jujud agent installed on each provisioned machine executes the install hook of the charm

Other hooks may be executed as part of the deployment process, such as start, config-changed, and any relation hooks if the application is being related to other app

In Juju, a **hook** is an executable file that a Juju unit agent runs to communicate with the {ref}`charm <charm>`, in the follow sequence: 

1. The unit agent executes hooks on the charm.
1. The charm runs hook tools.
1. Hook tools make gRPC calls to the unit agent.

The unit agent chooses which hook needs to be run. (There's a decision loop. The unit agent gets a notification that something has changed. It has a prioritized list of decision. Depending on which condition obtains, a specific hook gets run. If no condition obtains, the unit agent runs the update-status hook. Caveats: Some hooks will not run if it's been run before -- e.g., install -- or if some other hook hasn't yet it run -- or if start hasn't been run. There is no queue. The order in which we get events is not necessarily the order in which we act on those events. Part of running a hook is setting up the environment variables. Envvars are set up by the uniter.) The charm implements the hook to be run in the way that is best for its workload.

juju deploy... 


Decision tree:
Compare remote state to local state
- Is the charm we are running the charm that we should be running? If not, run upgrade-charm.
- Check to see if we need to update the charm directory

Depending on the charm development framework being used, hooks have been implemented in different ways:

- In the hooks-based framework, they are specific files placed in the `/hooks` folder of a charm, each named after the hook it represented.
- In the reactive-framework, they are functions in a single Python file. When you build a reactive charm, the build process creates the hooks folder and necessary hooks linking back to that file.  
- In the current, {ref}`Ops (`ops`) <ops-ops>`, framework, they are functions in a single Python file. 

In all implementations, h

Hooks form the basis of the {ref}`event <event>`-handling system. 

In the current charm development framework, {ref}`Ops (`ops`) <ops-ops>`, events are code blocks, typically methods of a class that inherits from `CharmBase` and represents the charm object.


```{note}

Most hooks/events (their names and semantics) have not changed across the various frameworks. The main change across frameworks is the way of implementing the operational logic to be executed in response to them.

```

-->

<br>

> <small>**Contributors:** @anvial, @hmlanigan, @ppasotti , @simonrichardson, @tmihoc  </small>