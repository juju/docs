# Event Cycle

 Taking a broad look at multiple services, there are several common events that
each service goes through: install, configure, start, upgrade, and stop. To
orchestrate services, Juju drives these events that a charm can respond to with
executable files called hooks. Juju executes the specific hook for the
appropriate event.

There are several core lifecycle hooks that can be implemented by any charm:  

* [install](./reference-charm-hooks.html#install)
* [config-changed](./reference-charm-hooks.html#config-changed)
* [start](./reference-charm-hooks.html#start)
* [upgrade-charm](./reference-charm-hooks.html#upgrade-charm)
* [stop](./reference-charm-hooks.html#stop)
* [update-status](./reference-charm-hooks.html#update-status)
* [leader-elected](./reference-charm-hooks.html#leader-elected)
* [leader-settings-changed](./reference-charm-hooks.html#leader-settings-changed)

For every relation defined by a charm, an additional four "relation hooks" can
be implemented, named after the charm relation:  

* [[name]-relation-joined](./reference-charm-hooks.html#[name]-relation-joined)
* [[name]-relation-changed](./reference-charm-hooks.html#[name]-relation-changed)
* [[name]-relation-departed](./reference-charm-hooks.html#[name]-relation-departed)
* [[name]-relation-broken](./reference-charm-hooks.html#[name]-relation-broken)

For every storage pool created a charm can implement two additional storage
hooks:  

* [[name]-storage-attached](./reference-charm-hooks.html#[name]-storage-attached)
* [[name]-storage-detaching](./reference-charm-hooks.html#[name]-storage-detaching)

There is more information on [Charm Hooks](./reference-charm-hooks.html) in the
Reference section of the Juju documentation.

# Deployment Events by example

When deploying a charm, there is a guaranteed set lifecycle events that every
charm will run - this is the basic series of hooks executed in the initial
deployment cycle.

1. install
1. leader-elected (leader-settings-changed respectively)
1. config-changed
1. start
1. update-status

# Configuration Events by example

Other event chains can be initiated by Juju commands or actions in the GUI.
These chains follow a few different paths depending on which event is triggered
against the unit. For example, if we were to change the configuration of the
vanilla charm, Juju would then call the config-changed hook, and nothing else.

1. config-changed

# Relation Events by example

When a relation is added from the vanilla charm to a database charm, the first
event is `database-relation-joined` the two units know about each other and the
code should prepare communication between the two. After the join a
`database-relation-changed` state is set, the two units have peer to peer
communication.

1. database-relation-joined
1. database-relation-changed

When the relation is removed, either by removing the relation or deleting the
related node, two additional events will be triggered. The first event
`[name]-relation-departed` is run while there is still a relationship with the
other unit, to allow operations such as backup, or to allow graceful
terminations of connections. The second event `[name]-relation-broken` is run
when the relation no longer exists, where a charm might remove a system from a
configuration and restart the service if necessary.

1. database-relation-departed
1. database-relation-broken

# Leader Events by example

Software with many distributed services may require a notion of a “leader”, or a
single service as the organizer of the other services. Such services often have
“leader elections” or come to a “quorum” to determine the leader among
themselves. The leadership hooks allow Juju to determine one leader and creates
an event if the leader is ever destroyed or otherwise displaced.

1. leader-elected
1. leader-settings-changed

There is more detailed information about [Charm Leadership in the Juju
documentation](./authors-charm-leadership.html).

# Storage Events by example

Many services require access to storage resources. Juju has events related to
storage for the charm to respond to. There are two events related to storage,
so the charm can react storage is attached and when it is detached.

1. [name]-storage-attached
1. [name]-storage-detached

There is more information about [storage feature in the Juju
documentation](./storage.html).

While these concepts are important to understand how Juju works, [creating a
charm in the reactive framework](./authors-charm-building.html) reduces the need
to interact directly with the event model. We will preserve the install and
config-changed hook(s) in most layers. The relation hooks are generated when
using an interface layer, during the `charm build` process. The remainder of
actions taken, will be directed with artificial states, set by the layers
author.

# Handling reactive states

When charming with the reactive framework, it’s possible to use
developer-created states and boolean logic to run code when the states represent
something meaningful to your deployment. Such as when a database is connected,
and when it is available, or the primary workload becoming available for use.
These are additional “events” that are abstracted from the hook event cycle
outlined above.

Many states can be performed during a single hook execution, as these abstracted
states are run through a dispatcher, and ordering is not guaranteed. All state
based events, like hook events, are required to be
[idempotent](https://en.wikipedia.org/wiki/Idempotence).

Let’s assume we have an install hook that looks similar to the following:  

```python
@hook(‘install’)
def install():
    # Do work to install the Apache web server...
    reactive.set_state(‘apache.installed’)
```

We can continue to “react” to this event with an event subscription using the
“@when” decorator. Note: that we are still in the Install hook context.

```python
@when(‘apache.installed’)
def do_something():
   # Install a webapp on top of the Apache Web server...
   set_state(‘webapp.available’)
```

# Handling relations with reactive states

When building a charm using layers -- implementing an interface layer -- these
layers set states for the code to react to. This allows the charm author to
focus solely on the states rather than the traditional method of putting all the
code in the [relationship hook sequence](#relation-events-by-example).

# Relation states by example

In the vanilla `layers.yaml` file, we include “interface:mysql". This relates
directly to the “database” relation defined in `metadata.yaml`; with this
inclusion in `layers.yaml`, your charm will pick up the mysql interface layer
from [the layers webservice](http://interfaces.juju.solutions/). The vanilla
code can then react to the “database.connected” state and/or the
“database.available” state.

This is illustrated by the following block which handles messaging to the user
that the code is waiting for MySQL to send the connection details:

```python
@when('database.connected')
@when_not('database.available')
def waiting_mysql(mysql):
    remove_state('apache.start')
    status_set('waiting', 'Waiting for MySQL')
```

> It’s important to note that the instructions for this particular interface are
only applicable to this particular interface. Interfaces are unique to the
author’s implementation, and any states set will vary from interface to
interface. These states are documented in the interface layer repository
README.md file.
