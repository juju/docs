(charm-lifecycle)=
# Charm lifecycle

> See also: {ref}`Exploring event emission sequences with jhack tail <explore-event-emission-with-jhack-tail>`


This document is about the lifecycle of a charm, specifically the Juju events that are used to keep track of it. These events are relayed to charm code by the Operator Framework in specific sequences depending on what's going on in the Juju model. 

It is common wisdom that event ordering should not be generally relied upon when coding a charm, to ensure resilience. It can be however useful to understand the logic behind the timing of events, so as to avoid common mistakes and have a better picture of what is happening in your charm. In this document we'll learn how:

* A charm's lifecycle can be seen to consist of three **phases**, each one with characteristic events and sequences thereof. The fuzziest of the three being the Operation phase, where pretty much anything can happen short of setup events.
* Not all events can be reliably be assumed to occur in specific temporal orders, but some can.

In this document we will *not* learn:

* What each event means or is typically used to represent about a workload status. For that see [the SDK docs](https://juju.is/docs/sdk/events). 
* What event cascades are triggered by a human administrator running commands through the Juju CLI. For that see [this other doc](https://discourse.charmhub.io/t/core-lifecycle-events/4455/3).

```{note}

The graphs are screenshots of mermaid sources currently available [here](https://github.com/PietroPasotti/charm-events), pending mermaid support to be available on discourse.

```

**Contents:**
- [The graph](#heading--the-graph)
    - [Legend](#heading--legend)
- [Other events](#heading--other-events)
- [Notes on the setup phase](#heading--notes-on-the-setup-phase)
- [Notes on the operation phase](#heading--notes-on-the-operation-phase)
- [Notes on the teardown phase](#heading--notes-on-the-teardown-phase)
- [Caveats](#heading--caveats)
- [Deprecation notices](#heading--deprecation-notices)
- [Event semantics and data](#heading--event-semantics-and-data)
- [Appendices](#heading--appendices)
    - [Appendix 1: scenario example](#heading--appendix-1-scenario-example)
    - [ Appendix 2: deferring an event](#heading---appendix-2-deferring-an-event)


<a href="#heading--the-graph"><h2 id="heading--the-graph">The graph</h2></a>

![image|690x713](upload://aFpDVI0qN94mmLTY4nSdsrMPuKH.png)

<a href="#heading--legend"><h3 id="heading--legend">Legend</h3></a>

* `(start)` and `(end)` are 'meta' nodes and represent the beginning and end of the lifecycle of a Charm/juju unit. All other nodes represent hooks (events) that can occur during said lifecycle.
* Hard arrows represent strict temporal ordering which is enforced by the Juju state machine and respected by the Operator Framework, which mediates between the Juju controller and the Charm code.
* Dotted arrows represent a 1:1 relationship between relation events, explained in more detail down in the Operation section.
* The large yellow boxes represent broad phases in the lifecycle. You can read the graph as follows: when you fire up a unit, there is first a setup phase, when that is done the unit enters a operation phase, and when the unit goes there will be a sequence of teardown events. Generally speaking, this guarantees some sort of ordering of the events: events that are unique to the teardown phase can be guaranteed not to be fired during the setup phase. So a {ref}``stop`] will never be fired before a [`start`].
* The colours of the event nodes represent a logical but practically meaningless grouping of the events.
  * green for leadership events
  * red for storage events
  * purple for relation events
  * blue for generic lifecycle events   

<a href="#heading--other-events"><h2 id="heading--other-events">Workload and substrate-specific events</h2></a>

Note the `[workload events] (k8s only)` node in the operation phase. That represents all events meant to communicate information about the workload container on kubernetes charms. At the time of writing the only such events are:

* [`*-pebble-ready` <event-container-pebble-ready>`
* {ref}``*-pebble-custom-notice` <event-container-pebble-custom-notice>`
* [`*-pebble-check-failed`](https://ops.readthedocs.io/en/latest/#ops.PebbleCheckFailedEvent)
* [`*-pebble-check-recovered`](https://ops.readthedocs.io/en/latest/#ops.PebbleCheckRecoveredEvent)

All of these can fire at any time whatsoever during the lifecycle of a charm.

Similarly, the `{ref}`pre/post]-series-upgrade (lxd only)` events can only occur on machine charms at any time during the operation phase.

<a href="#heading--notes-on-the-setup-phase"><h2 id="heading--notes-on-the-setup-phase">Notes on the setup phase</h2></a>
* The only events that are guaranteed to always occur during Setup are [`start`], [`config-changed`] and [`install`]. The other events only happen if the charm happens to have (peer) relations at install time (e.g. if a charm that already is related to another gets scaled up) or it has storage. Same goes for leadership events. For that reason they are styled with dashed borders.
* [`config-changed`] occurs between [`install`] and [`start`] regardless of whether any leadership (or relation) event fires.
* Any [`*-relation-created`] event can occur at Setup time, but if X is a peer relation, then `X-relation-created` can **only** occur at Setup, while for non-peer relations, they can occur also during Operation. The reason for this is that a peer relation cannot be created or destroyed 'manually' at arbitrary times, they either exist or not, and if they do exist, then we know it from the start.

<a href="#heading--notes-on-the-operation-phase"><h2 id="heading--notes-on-the-operation-phase">Notes on the operation phase</h2></a>

* [`update-status` <event-update-status>` is fired automatically and periodically, at a configurable regular interval (default is 5m) which can be configured by `juju model-config update-status-hook-interval`.
* {ref}``collect-metrics` <event-collect-metrics-deprecated>` is fired automatically and periodically in older juju versions, at a regular interval of 5m, AND whenever the user runs `juju collect-metrics`.
* [`leader-elected`] and [`leader-settings-changed`] only fire on the leader unit and the non-leader unit(s) respectively, just like at startup.
* There is a square of symmetries between the `*-relation-[joined/departed/created/broken]` events:
  * Temporal ordering: a `X-relation-joined` cannot *follow* a `X-relation-departed` for the same relation ID. Same goes for [`*-relation-created`] and [`*-relation-broken`], as well as [`*-relation-created`] and [`*-relation-changed`].
  * Ownership: `joined/departed` are unit-level events: they fire when an application has a (peer) relation and a new unit joins or leaves. All units (including the newly created or leaving unit), will receive the event. `created/broken` are relation-level events, in that they fire when two applications become related or a relation is removed (e.g. via `juju remove-relation` or because an application is destroyed).
  * Number: there is a 1:1 relationship between `joined/departed` and `created/broken`: when a unit joins a relation with X other units, X [`*-relation-joined`] events will be fired. When a unit leaves, all units will receive a [`*-relation-departed`] event (so X of them are fired). Same goes for `created/broken` when two applications are related or a relationship is broken. Find in appendix 1 a somewhat more elaborate example.
* Technically speaking all events in this box are optional, but I did not style them with dashed borders to avoid clutter. If the charm shuts down immediately after start, it could happen that no operation event is fired.
* A `X-relation-joined` event is always followed up (immediately after) by a `X-relation-changed` event. But any number of [`*-relation-changed`] events can be fired at any time during operation, and they need not be preceded by a [`*-relation-joined`] event.
* There are more temporal orderings than the one displayed here; event chains can be initiated by human operation as detailed [in the SDK docs](https://juju.is/docs/sdk/events) and [the leadership docs](https://juju.is/docs/sdk/leadership). For example, it is guaranteed that a [`leader-elected`] is always followed by a [`settings-changed`], and that if you remove the leader unit, you should get [`*-relation-departed`] and a [`leader-settings-changed`] on the remaining units (although no specific ordering can be guaranteed [cfr this bug...](https://bugs.launchpad.net/juju/+bug/1964582)). 
* Secret events (in purple) can technically occur at any time, provided your charm either has created a secret, or observes a secret that some other charm has created. Only the owner of a secret can receive `secret-rotate` and `secret-expire` for that secret, and only an observer of a secret can receive `secret-changed` and `secret-removed`. 

<a href="#heading--notes-on-the-teardown-phase"><h2 id="heading--notes-on-the-teardown-phase">Notes on the teardown phase</h2></a>

* Both relation and storage events are guaranteed to fire before [`stop`]/[`remove`] if they will fire at all. They are optional, in that a departing unit (or application) might have no storage or relations.
* [`*-relation-broken`] events in the Teardown phase are fired in case an application is being torn down. These events can also occur at Operation time, if the relation is removed by e.g. a charm or a controller.
* The entire teardown phase is **skipped** if the cloud is killed. The next event the charm will see in this case would be a `start` event. This would happen, for example, on `microk8s stop; microk8s start`.

<a href="#heading--caveats"><h2 id="heading--caveats">Caveats</h2></a>

* Events can be deferred by charm code by calling `Event.defer()`. That means that the event is put in a queue of deferred events which will get flushed by the operator framework as soon as the next event comes in, and *before* firing that new event in turn. See Appendix 2 for a visual representation. What this means in practice is that deferring an event can break the temporal ordering of the events as outlined in this graph; `defer()`ring an event twice will break the ordering guarantees we outlined here. Cf. the appendix for an UML-y representation. Cfr [this document on defer](https://discourse.charmhub.io/t/deferring-events-details-and-dilemmas/5930) for more.
* The events in the Operation phase can interleave in arbitrary ways. For this reason it's essential that hook handlers make *no assumptions* about each other -- each handler should check its preconditions independently and operate under the assumption that the relative ordering is totally arbitrary -- except relation events, which have some partial ordering as explained above.

<a href="#heading--deprecation-notices"><h2 id="heading--deprecation-notices">Deprecation notices</h2></a>

* `leader-deposed` is a juju hook that was planned but never actually implemented. You may see a WARNING mentioning it in the `juju debug-log` but you can ignore it.
* [`collect-metrics`](https://discourse.charmhub.io/t/charm-hooks/1040#heading--collect-metrics) is no longer being fired in recent juju versions.

<a href="#heading--event-semantics-and-data"><h2 id="heading--event-semantics-and-data">Event semantics and data</h2></a>

This document is only about the timing of the events; for the 'meaning' of the events, other sources are more appropriate; e.g. [juju-events](https://juju.is/docs/sdk/events).
For the data attached to an event, one should refer to the docstrings in the ops.charm.HookEvent subclass that the event you're expecting in your handler inherits from.


<a href="#heading--appendices"><h2 id="heading--appendices">Appendices</h2></a>

<a href="#heading--appendix-1-scenario-example"><h3 id="heading--appendix-1-scenario-example">Appendix 1: scenario example</h3></a>


This is a representation of the relation events a deployment will receive in a simple scenario that goes as follows:
* We start with two unrelated applications, `applicationA` and `applicationB`, with one unit each.
* `applicationA` and `applicationB` become related via a relation called `R`.
* `applicationA` is scaled up to 2 units.
* `applicationA` is scaled down to 1 unit.
* `applicationA` touches the `R` databag (e.g. during an `update-status` hook, or as a result of a `config-changed`, an action, a custom event...).
* The relation `R` is removed.

Note that many event sequences are marked as 'par' for *parallel*, which means that the events can be dispatched to the units arbitrarily interleaved.

![image|690x578](upload://22fYgoRypCRsfvRNCWcGS6xLFvr.png) 
![image|690x554](upload://72j3paIuuzJcj7yAW2z96W5ygR9.png) 


<a href="#heading---appendix-2-deferring-an-event"><h3 id="heading---appendix-2-deferring-an-event"> Appendix 2: deferring an event</h3></a>
 > {ref}`jhack tail <explore-event-emission-with-jhack-tail>` offers functionality to visualize the deferral status of events in real time.

This is the 'normal' way of using `defer()`: an event `event1` comes in but we are not ready to process it; we `defer()` it; when `event2` comes in, the operator framework will first flush the queue and fire `event1`, then fire `event2`. The ordering is preserved: `event1` is consumed before `event2` by the charm.

![image|618x623](upload://iAF9tW9cwlMucHF2INYmhGlyhGe.png) 

Suppose now that the charm defers `event1` again; then `event2` will be processed by the charm before `event1` is. `event1` will only be fired again once another event, `event3`, comes in in turn.
The result is that the events are consumed in the order: `2-1-3`. Beware.

![image|568x804](upload://56Di1wIWMM0Z7gGr7a8RNjnpiJs.png)


[`install`]: https://juju.is/docs/sdk/events#heading--install
[`start`]: https://juju.is/docs/sdk/events#heading--start
[`stop`]: https://juju.is/docs/sdk/events#heading--stop
[`remove`]: https://juju.is/docs/sdk/events#heading--remove
[`*-pebble-ready`]: https://discourse.charmhub.io/t/event-container-pebble-ready/6468
[`config-changed`]: https://juju.is/docs/sdk/events#heading--config-changed
[`update-status`]: https://juju.is/docs/sdk/events#heading--update-status
[`collect-metrics`]: https://discourse.charmhub.io/t/charm-hooks/1040#heading--collect-metrics
[`leader-settings-changed`]: https://discourse.charmhub.io/t/charm-hooks/1040
[`upgrade-charm`]: https://juju.is/docs/sdk/events#heading--upgrade-charm
[`*-relation-created`]: https://juju.is/docs/sdk/relations#heading--relation-events
[`*-relation-joined`]: https://juju.is/docs/sdk/relations#heading--relation-events
[`*-relation-changed`]: https://juju.is/docs/sdk/relations#heading--relation-events
[`*-relation-broken`]: https://juju.is/docs/sdk/relations#heading--relation-events

[`leader-elected`]: https://discourse.charmhub.io/t/leader-elected/5778
[`*-relation-departed`]: https://discourse.charmhub.io/t/relation-departed/5943


> Contributors: @ppasotti