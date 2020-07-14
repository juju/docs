When charming with the reactive framework, it’s possible to use developer-created states and boolean logic to run code when the states represent something meaningful to your deployment, such as when a database is connected, and when it is available, or when the primary workload becomes available for use. These are additional “events” that are abstracted from the hook event cycle outlined later in this page.

Many states can be performed during a single hook execution, as these abstracted states are run through a dispatcher, and ordering is not guaranteed. All state based events, like hook events, are required to be [idempotent](https://en.wikipedia.org/wiki/Idempotence).

Let’s assume we have an install hook that looks similar to the following:

``` python
@hook(‘install’)
def install():
    # Do work to install the Apache web server...
    reactive.set_state(‘apache.installed’)
```

We can continue to “react” to this event with an event subscription using the “@when” decorator. Note: that we are still in the Install hook context.

``` python
@when(‘apache.installed’)
def do_something():
   # Install a webapp on top of the Apache Web server...
   set_state(‘webapp.available’)
```

<h2 id="heading--handling-relations-with-reactive-states">Handling relations with reactive states</h2>

When building a charm using layers -- implementing an interface layer -- these layers set states for the code to react to. This allows the charm author to focus solely on the states rather than the traditional method of putting all the code in the [relationship hook sequence](#heading--relation-events-by-example).

<h2 id="heading--relation-states-by-example">Relation states by example</h2>

In the vanilla `layer.yaml` file, we include “interface:mysql". This relates directly to the “database” relation defined in `metadata.yaml`; with this inclusion in `layer.yaml`, your charm will pick up the mysql interface layer from the [Juju Charm Layers Index](https://github.com/juju/layer-index). The vanilla code can then react to the “database.connected” state and/or the “database.available” state.

This is illustrated by the following block which handles messaging to the user that the code is waiting for MySQL to send the connection details:

``` python
@when('database.connected')
@when_not('database.available')
def waiting_mysql(mysql):
    remove_state('apache.start')
    status_set('waiting', 'Waiting for MySQL')
```

[note]
It is important to note that the instructions for this particular interface are only applicable to this particular interface. Interfaces are unique to the author’s implementation, and any states set will vary from interface to interface. These states are documented in the interface layer repository README.md file.
[/note]

<h2 id="heading--hook-event-cycle">Hook event cycle</h2>

Taking a broad look at multiple applications, there are several common events that each application goes through: install, configure, start, upgrade, and stop. To model applications, Juju drives these events that a charm can respond to with executable files called hooks. Juju executes the specific hook for the appropriate event.

There are several core lifecycle hooks that can be implemented by any charm:

- [install](/t/charm-hooks/1040#heading--install)
- [config-changed](/t/charm-hooks/1040#heading--config-changed)
- [start](/t/charm-hooks/1040#heading--start)
- [upgrade-charm](/t/charm-hooks/1040#heading--upgrade-charm)
- [stop](/t/charm-hooks/1040#heading--stop)
- [remove](/t/draft-charm-hooks/2919#heading--remove)
- [update-status](/t/charm-hooks/1040#heading--update-status)
- [leader-elected](/t/charm-hooks/1040#heading--leader-elected)
- [leader-settings-changed](/t/charm-hooks/1040#heading--leader-settings-changed)

For every relation defined by a charm, an additional give "relation hooks" can be implemented, named after the charm relation:

- [[name]-relation-created](/t/draft-charm-hooks/2919##heading--name-relation-created)
- [[name]-relation-joined](/t/charm-hooks/1040#heading--name-relation-joined)
- [[name]-relation-changed](/t/charm-hooks/1040#heading--name-relation-changed)
- [[name]-relation-departed](/t/charm-hooks/1040#heading--name-relation-departed)
- [[name]-relation-broken](/t/charm-hooks/1040#heading--name-relation-broken)

For every storage pool created a charm can implement two additional storage hooks:

- [[name]-storage-attached](/t/charm-hooks/1040#heading--name-storage-attached)
- [[name]-storage-detaching](/t/charm-hooks/1040#heading--name-storage-detaching)

There is more information on the [Charm hooks](/t/charm-hooks/1040) page.

<h2 id="heading--deployment-events-by-example">Deployment Events by example</h2>

When deploying a charm, there is a guaranteed set lifecycle events that every charm will run - this is the basic series of hooks executed in the initial deployment cycle.

1. install
1. leader-elected (leader-settings-changed respectively)
1. config-changed
1. start
1. update-status

<h2 id="heading--configuration-events-by-example">Configuration Events by example</h2>

Other event chains can be initiated by Juju commands or actions in the GUI. These chains follow a few different paths depending on which event is triggered against the unit. For example, if we were to change the configuration of the vanilla charm, Juju would then call the config-changed hook, and nothing else.

1. config-changed

<h2 id="heading--relation-events-by-example">Relation Events by example</h2>

When a relation is added from the vanilla charm to a database charm, the first event is `database-relation-joined` the two units know about each other and the code should prepare communication between the two. After the join a `database-relation-changed` state is set, the two units have peer to peer communication.

1. database-relation-joined
1. database-relation-changed

When the relation is removed, either by removing the relation or deleting the related node, two additional events will be triggered. The first event `[name]-relation-departed` is run while there is still a relationship with the other unit, to allow operations such as backup, or to allow graceful terminations of connections. The second event `[name]-relation-broken` is run when the relation no longer exists, where a charm might remove a system from a configuration and restart a process if necessary.

1. database-relation-departed
1. database-relation-broken

<h2 id="heading--leader-events-by-example">Leader Events by example</h2>

Software with many distributed nodes may require a notion of a “leader”, or a single node as the organizer of the other nodes. Such applications often have “leader elections” or come to a “quorum” to determine the leader among themselves. The leadership hooks allow Juju to determine one leader and creates an event if the leader is ever destroyed or otherwise displaced.

1. leader-elected
1. leader-settings-changed

See [Implementing leadership](/t/implementing-leadership/1124) for more details.

<h2 id="heading--storage-events-by-example">Storage Events by example</h2>

Many applications require access to storage resources. Juju has events related to storage for the charm to respond to. There are two events related to storage, so the charm can react storage is attached and when it is detached.

1.  [name]-storage-attached
2.  [name]-storage-detached

There is more information about the storage feature on the [Using storage](/t/using-juju-storage/1079) page.

While these concepts are important to understand how Juju works, [creating a charm in the reactive framework](/t/layers-for-charm-authoring/1122) reduces the need to interact directly with the event model. We will preserve the install and config-changed hook(s) in most layers. The relation hooks are generated when using an interface layer, during the `charm build` process. The remainder of actions taken will be directed with artificial states, set by the layer's author.
