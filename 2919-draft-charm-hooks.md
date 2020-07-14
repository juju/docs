<div data-theme-toc="true"> </div>

# About

Charm hooks are the mechanism that Juju uses to invoke charms. They are executable files within a charm's `hooks/` directory that are triggered by events.

Somewhat confusingly for newcomers to Juju though, most charms writers do not interact with hooks directly. Instead, the author of a charm interacts with an interface provided by a charming framework.

## Triggers

The events that trigger hooks, and sequences of hooks, are useful to know:

### Periodic Events

Timers trigger hooks:

| Hook | Comments |
|---|---|
|  `update-status` | Timer interval defined by the `update-status-hook-interval` model configuration option |
| `collect-metrics` | This timer is not configurable.  |

### Deployment and Unit Creation

When a charm is first deployed, via `juju deploy`, `juju add-unit`, or `juju scale-application`, the charm receives an opportunity to install any necessary software.

#### Kubernetes (K8s) Clouds

| Hook | Comments |
|---|---|
| `*-relation-created` | For every peer relation |
| `*-relation-created` | For other relations |
| `leader-elected` | |
| `config-changed` | |
| `start` | |
| `storage-attached` |  |
| `update-status` |  |


#### Traditional Clouds

Traditional clouds differ from K8s in that they include an `install` hook and their `storage-attached` hook occurs sooner (to enable installation to proceed on a persistent storage). 

| Hook | Comments |
|---|---|
| `storage-attached` |  |
| `install` |  |
| `*-relation-created` | For every peer relation |
| `*-relation-created` | For other relations |
| `leader-elected` | |
| `config-changed` | |
| `start` | |
| `update-status` | |

### Machine Boot

When the underlying machine starts up, units hosted by the machine run the following hooks:

#### Kubernetes Clouds

No hooks are executed. The [OCI image](https://github.com/opencontainers/image-spec) deployed by the charm includes an entrypoint itself. 

#### Traditional Clouds

| Hook | Comments |
|---|---|
|  `start` | Prior to Juju 2.8, this was only triggered on first boot |


### Machine Shutdown

When the underlying machine reboots or is powered off, units hosted by the machine run the following hooks:

#### Kubernetes Clouds

No hooks are executed.

#### Traditional Clouds

| Hook | Comments |
|---|---|
|  `stop` | Prior to Juju 2.8, no hooks were triggered |


### Configuration Change

When a Juju user executes `juju config` and changes an option, charms are notified of the change via a hook:


| Hook | Comments |
|---|---|
|  `config-changed` |  |

### Unit Creation

See **Deployment and Unit Creation**.

### Unit Removal

Units can be removed from a model at any time. Commands that invoke unit removal include `juju remove-unit`, `juju remove-application`, and `juju scale-application`.

#### Kubernetes (K8s) Clouds

No hooks are executed.

#### Traditional Clouds

Units may be co-hosted on the same machine. These hooks provide the opportunity for units to clean up.

| Hook | Comments |
|---|---|
| `*-storage-detached` | When the `--destroy-storage` option is provided |
| `*-relation-departed` | For every relation that has moved past "created" into the "joined" state |
| `stop` | |
| `remove` | |

### Relation Creation

Relations invoke hooks within units of _both_ applications, but neither application requires units on the other side to proceed. This can create an unintuitive situation where one unit can send data over the relation to units that have not yet been provisioned.

| Hook | Comments |
|---|---|
| `<relation-name>-relation-created` | Does not imply that a unit is available on the other side of the relation. |

### Unit joins the relation

When a unit is added to a relation, all units are notified. 

| Hook | Comments |
|---|---|
| `<relation-name>-relation-joined` |  |

### Change to Relation Data

When a unit executes the `relation-set` hook tool, all other units receive a notification:

| Hook | Comments |
|---|---|
| `<relation-name>-relation-changed` |  |


### Unit Departure from a Relation

When a unit is removed from the model,  its related units are notified of this: 

| Hook | Comments |
|---|---|
| `<relation-name>-relation-departed` |  |


### Relation Removal

When `juju remove-relation` or a command that removes relation, such as `juju remove-application`, is executed, units are notified: 

| Hook | Comments |
|---|---|
| `<relation-name>-relation-broken` |  |


### Storage Creation

Storage is added ("attached") to specific units, rather than to the application as a whole. The `juju attach-storage` command triggers the following hook once the cloud has made the storage volume available:

| Hook | Comments |
|---|---|
| `<storage-name>-storage-attached` |  |

### Storage Removed

Storage can be detached from a model via the `juju detach-storage` or removed altogether via `juju destroy-storage`. From the perspective of units, these two operations are indistinguishable and receive the same hook:

| Hook | Comments |
|---|---|
| `<storage-name>-storage-detached` |  |

### Series Upgrade

Machines are sometimes kept alive for many years. To support this use case, charms can manage the process of enabling an application to continue to function under a new operating system version.

#### Kubernetes (K8s) Clouds

Not applicable.

#### Traditional Clouds

| Hook | Comments |
|---|---|
| `pre-series-upgrade` | Before the machine's OS has been upgraded. |
| `post-series-upgrade` | Once the machine's OS has been upgraded. |


<!--
TODO upgrade-series

| Command: `juju upgrade-series <machine> cosmic <series>`  |  |  |

-->

<!--

Writing charm hooks is usually an indirect process. 

Writing charms typically involves interacting with a framework. The framework translates the author's code into charm hook tools.

Charm hooks are executable files with a charm's `hooks` directory. They are executed when the _unit agent_ detects an event that change. 

A hook can trigger further hooks. For example, it is possible to trigger the `config-change` hook by invoking the `config-set` _hook tool_. 

-->

## Execution environment

Hooks are run in serial on each machine. When multiple units occupy the same machine, they can compete for execution time.

When multiple hooks are queued for execution, they operate in the following priority:

- Upgrade Series hooks
  - `pre-series-upgrade`
  - `post-series-upgrade` 
- `upgrade-juju`
- `restart`
- Any hook that needs to be retried
- Leadership hooks, e.g.
  - `leader-elected`
- Actions hooks
- Commands to be executed from `juju run`
- Storage, e.g.
  - `storage-attached`
  - `storage-detaching`
- Other hooks, except
- `update-status`




## Further Detail

An application unit's direct action is entirely defined by its charm's hooks. Hooks are executable files in a charm's `hooks` directory; hooks with particular names (see below) will be invoked by the juju unit agent at particular times, and thereby cause changes to the world.

Whenever a hook-worthy event takes place, the unit agent first checks whether that hook is being [debugged](/t/debugging-charm-hooks/1116), and if so hands over control to the user. Otherwise, it tries to find a hook with precisely the right name. If the hook doesn't exist, the agent continues without complaint; if the hook does exist, it is invoked without arguments in a specific [hook context](/t/the-hook-environment-hook-tools-and-how-hooks-are-run/1047), and its output is written to the unit agent's log. If it returns a non-zero exit code, the agent enters an [error state](/t/dealing-with-errors-encountered-by-charm-hooks/1048) and awaits user intervention.

The agent will also enter an error state if the unit agent process is aborted during hook execution.

There are multiple types of hooks, each described in more detail in the following sections.

[note]
None of the hooks are required; if you don't implement a hook, it just doesn't get run. When a hook event occurs, Juju will look for the corresponding hook file to execute, but if it finds none, will continue running without generating an error.
[/note]

All the hooks must be written to be [idempotent](https://en.wikipedia.org/wiki/Idempotence), meaning that there should be no difference from running the hook once from running it multiple times. This property is important because hooks can be run multiple times by the Juju system in ways that might be difficult to predict.

## Events that trigger charm hooks

Many events 

### Machine startup

When the machine that's hosting a Juju unit starts up, the `start` hook is executed. This hook may be necessary to perform some tasks  

### Machine shutdown

Shutting down a machine does not trigger any charm hooks to be fired.

### New peer unit 

### Peer unit 

### Leader elected

### Configuration changes via `juju config` and relation data 

Charms are expected to respond appropriately as configuration changes . Many events can 

- The `relation-set` allows peers a 
- `leader-set` hook tool


# Configuration changes via 

| Trigger | Hook(s) |
|----|----|
| `juju config`  | <li> `config-changed`
| `juju relate <a> <b>` | On all units of application `a`: <li> `config-changed` <li> `<rel>-relation-created` <li> `<rel>-relation-joined` <br><br> On all units of application `b`: <li> `config-changed` <li> `<rel>-relation-created` <li> `<rel>-relation-joined`
|  | <li> `config-changed`

- when users execute `juju config`, the `config-change`
- a unit leaving may trigger a change in _leadership_

<h2 id="heading--core-lifecycle-hooks">Core lifecycle hooks</h2>

These run during the normal charm lifecycle.

<h3 id="heading--config-changed">config-changed</h3>

`config-changed` runs in several different situations.

-   immediately after "install"
-   immediately after "upgrade-charm"
-   at least once when the unit agent is restarted (but, if the unit is in an [error state](/t/dealing-with-errors-encountered-by-charm-hooks/1048), it won't be run until after the error state is cleared).
-   after changing charm configuration using the GUI or command line interface

It cannot assume that the software has already been started; it should not start stopped software, but should (if appropriate) restart running software to take configuration changes into account.

<h3 id="heading--install">install</h3>

`install` is run at the beginning of a charm lifecycle. The hook should be used to perform one-time setup operations, such as installing prerequisite software that will not change with configuration changes.

<h3 id="heading--leader-elected">leader-elected</h3>

`leader-elected` is run at least once to signify that Juju decided this unit is the leader. Authors can use this hook to take action if their protocols for leadership, consensus, raft, or quorum require one unit to assert leadership. If the election process is done internally to the application, other code should be used to signal the leader to Juju. For more information read the [Implementing leadership](/t/implementing-leadership/1124) page.

<h3 id="heading--leader-settings-changed">leader-settings-changed</h3>

`leader-settings-changed` runs when the leader has set values for the other units to respond to. Much like (config-changed)[#heading--config-changed] but for the leaders to send values to other units. Follower units can implement this hook and take action when the leader sets values. For more information read the [Implementing leadership](/t/implementing-leadership/1124) page.

<h3 id="heading--start">start</h3>

`start` runs immediately after the first `config-changed` hook. It should be used to ensure the charm's software is running. Note that the charm's software should be configured so as to persist through reboots without further intervention on juju's part.

`start` is also run after a machine reboot.

<h3 id="heading--stop">stop</h3>

`stop` runs immediately before the end of the unit's destruction sequence. It should be used to ensure that the charm's software is not running, and will not start again on reboot.

<h3 id="heading--stop">remove</h3>

`remove` runs immediately after the `stop` hook. 

This hook is called when an application removal is requested by the client. It should implement the following logic:

-   Stop the application
-   Remove any files/configuration created during the application lifecycle
-   Prepare any backup(s) of the application that are required for restore purposes.

<h3 id="heading--upgrade-charm">upgrade-charm</h3>

`upgrade-charm` runs immediately after any [upgrade](/t/upgrading-a-charm/1131) operation that does *not* itself interrupt an existing [error state](/t/dealing-with-errors-encountered-by-charm-hooks/1048). It should be used to reconcile local state written by some other version of the charm into whatever form it needs to take to be manipulated by the current version.

While the forced upgrade functionality is intended as a developer tool, and is not generally suitable for end users, it's somewhat optimistic to depend on the functionality never being abused. In light of this, if you need to run an `upgrade-charm` hook before your other hooks will work correctly, it may be wise to preface all your other hooks with a quick call to your (idempotent) `upgrade-charm`.

<h3 id="heading--update-status">update-status</h3>

`update-status` provides constant feedback to the user about the status of the application the charm is modeling. The charm is run by Juju at regular intervals, and gives authors an opportunity to run code that gets the “health” of the application.

<h2 id="heading--relation-hooks">Relation hooks</h2>

Units will only participate in relations after they're been started, and before they've been stopped. Within that time window, the unit may participate in several different relations at a time, *including* multiple relations with the same name.

To illustrate, consider a database application that will be used by multiple client applications. Units of a single client application will surely want to connect to, and use, the same database; but if units of another client application were to use that same database, the consequences could be catastrophic for all concerned.

If juju respected the `limit` field in relation [metadata](/t/charm-metadata/1043), it would be possible to work around this, but it's not a high- priority [bug](https://bugs.launchpad.net/bugs/1089297): most provider applications *should* be able to handle multiple requirers anyway; and most requirers will only be connected to one provider anyway.

When a unit running a given charm participates in a given relation, it runs at least three hooks for every remote unit it becomes aware of in that relation.

<h3 id="heading--name-relation-created">[name]-relation-created</h3>

`[name]-relation-created` is run after the `install` hook and before any `[name]-relation-joined` hooks.  It is guaranteed to run before any leadership hook for peer relations.  For non-peer relations established at a later point in time, the hook will fire once the relation has been established.

<h3 id="heading--name-relation-joined">[name]-relation-joined</h3>

`[name]-relation-joined` is run only when that remote unit is first observed by the unit. It should be used to `relation-set` any local unit settings that can be determined using no more than the name of the joining unit and the remote `private-address` setting, which is always available when the relation is created and is by convention not deleted.

You should not depend upon any other relation settings in the -joined hook because they're not guaranteed to be present; if you need more information you should wait for a -changed hook that presents the right information.

<h3 id="heading--name-relation-changed">[name]-relation-changed</h3>

`[name]-relation-changed` is always run once, after `-joined`, and will subsequently be run whenever that remote unit changes its settings for the relation. It should be the *only* hook that *relies* upon remote relation settings from `relation-get`, and it should *not* error if the settings are incomplete: you can guarantee that when the remote unit changes its settings, the hook will be run again.

The settings that you can get, and that you should set, are determined by the relation's [interface](/t/implementing-relations-in-juju-charms/1051).

<h3 id="heading--name-relation-departed">[name]-relation-departed</h3>

`[name]-relation-departed` is run once only, when the remote unit is known to be leaving the relation; it will only run once at least one `-changed` has been run, and after `-departed` has run, no further `-changed` hooks will be run. This should be used to remove all references to the remote unit, because there's no guarantee that it's still part of the system; it's perfectly probable (although not guaranteed) that the system running that unit has already shut down.

When a unit's own participation in a relation is known to be ending, the unit agent continues to uphold the ordering guarantees above; but within those constraints, it will run the fewest possible hooks to notify the charm of the departure of each individual remote unit.

Once all necessary `-departed` hooks have been run for such a relation, the unit agent will run the final relation hook:

<h3 id="heading--name-relation-broken">[name]-relation-broken</h3>

`[name]-relation-broken` indicates that the current relation is no longer valid, and that the charm's software must be configured as though the relation had never existed. It will only be called after every necessary `-departed` hook has been run; if it's being executed, you can be sure that no remote units are currently known locally.

It is important to note that the `-broken` hook might run even if no other units have ever joined the relation. This is not a bug: even if no remote units have ever joined, the fact of the unit's participation can be detected in other hooks via the `relation-ids` tool, and the `-broken` hook needs to execute to give the charm an opportunity to clean up any optimistically-generated configuration.

And, again, it's important to internalise the fact that there may be multiple runtime relations in play with the same name, and that they're independent: one `-broken` hook does not mean that *every* such relation is broken.

<h2 id="heading--storage-charm-hooks">Storage Charm Hooks</h2>

Juju can provide a variety of storage to charms. The charms can define several different types of storage that are allocated from Juju. To read more information, see the [storage document](/t/writing-charms-that-use-storage/1128)

<h3 id="heading--name-storage-attached">[name]-storage-attached</h3>

`[name]-storage-attached` allows the charm to run code when storage has been added. The storage-attached hooks will be run before the install hook, so that the installation routine may use the storage. The name prefix of this hook will depend on the storage key [defined in the metadata.yaml](/t/writing-charms-that-use-storage/1128#heading--adding-storage) file.

<h3 id="heading--name-storage-detaching">[name]-storage-detaching</h3>

`[name]-storage-detaching` allows the charm to run code before storage is removed. The storage-detaching hooks will be run before storage is detached, and always before the stop hook is run, to allow the charm to gracefully release resources before they are removed and before the unit terminates. The name prefix of the hook will depend on the storage key [defined in the `metadata.yaml`](/t/writing-charms-that-use-storage/1128#heading--adding-storage) file.

<h2 id="heading--metric-hooks">Metric Hooks</h2>

<h3 id="heading--collect-metrics">collect-metrics</h3>

Juju executes the collect-metrics hook every five minutes for the lifetime of the unit. Use the [`add-metric`](/t/hook-tools/1163#heading--add-metric) hook tool in `collect-metrics` to add measurements to Juju.

Because it may run concurrently with lifecycle charm hooks, `collect-metrics` executes in a more restricted environment where many hook tools (such as `config-get`) are not available. If access to charm configuration or other items is absolutely required, `charmhelpers.core.unitdata.kv` may be used to pass information into the `collect-metrics` hook context.

<h2 id="heading--writing-hooks">Writing hooks</h2>

If you follow the [Getting started](/t/getting-started-with-charm-development/1118) guide, you'll get a good sense of the basics. To fill out your knowledge, you'll want to study the hook [context and tools](/t/the-hook-environment-hook-tools-and-how-hooks-are-run/1047), and to experiment with [debug-hooks](/t/debugging-charm-hooks/1116).

Independent of the nuts and bolts, though, good hooks display a number of useful high-level properties:

-   They are *idempotent*: that is to say that there should be no observable difference between running a hook once, and running it N times in a row. If this property does not hold, you are likely to be making your own life unnecessarily difficult: apart from anything else, the average user's most likely first response to a failed hook will be to try to run it again (if they don't just skip it).
-   They are *easy to read* and understand. It's tempting to write a single file that does everything, and which just calls different functions internally depending on the value of `argv[0]`, and to symlink that one file for every hook; but such structures quickly become unwieldy. The time taken to write a library, separate from the hooks, is very likely to be well spent: it lets you write single hooks that are clear and focused, and insulates the maintainer from irrelevant details.

-   Where possible, they reuse [common code](https://launchpad.net/charm-tools) already written to ease or solve common use cases.
-   They do not return [errors](/t/dealing-with-errors-encountered-by-charm-hooks/1048) unless there is a good reason to believe that they cannot be resolved without user intervention. Doing so is an admission of defeat: a user who sees your charm returning an error state is unlikely to have the specific expertise necessary to resolve it. If you have to return an error, please be sure to at least write any context you can to the log before you do so.
-   They write only *very* sparingly to the [charm directory](/t/components-of-a-charm/1038).

We recommend you also familiarise yourself with the [best practices](/t/best-practice-for-charm-authors/1037) and, if you plan to distribute your charm, the [charm store policy](/t/charm-store-policy/1044).
