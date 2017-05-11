Title: Charm hooks

# Charm hooks

An application unit's direct action is entirely defined by its charm's hooks. Hooks
are executable files in a charm's `hooks` directory; hooks with particular names
(see below) will be invoked by the juju unit agent at particular times, and
thereby cause changes to the world.

Whenever a hook-worthy event takes place, the unit agent first checks whether
that hook is being [debugged](./authors-hook-debug.html), and if so hands over
control to the user. Otherwise, it tries to find a hook with precisely the right
name. If the hook doesn't exist, the agent continues without complaint; if the
hook does exist, it is invoked without arguments in a specific
[hook context](./authors-hook-environment.html), and its output is written to
the unit agent's log. If it returns a non-zero exit code, the agent enters an
[error state](./authors-hook-errors.html) and awaits user intervention.

The agent will also enter an error state if the unit agent process is aborted
during hook execution.

There are multiple types of hooks, each described in more detail in the
following sections.

!!! Note: None of the hooks are required; if you don't implement a hook, it
just doesn't get run. When a hook event occurs, Juju will look for the
corresponding hook file to execute, but if it finds none, will continue
running without generating an error.

All the hooks must be written to be
[idempotent](https://en.wikipedia.org/wiki/Idempotence), meaning that there
should be no difference from running the hook once from running it multiple
times. This property is important because hooks can be run multiple times by
the Juju system in ways that might be difficult to predict.

## Core lifecycle hooks

These run during the normal charm lifecycle.

### config-changed

`config-changed` runs in several different situations.

  - immediately after "install"
  - immediately after "upgrade-charm"
  - at least once when the unit agent is restarted (but, if the unit is in an
    [error state](./authors-hook-errors.html), it won't be run until after the
    error state is cleared).
  - after changing charm configuration using the GUI or command line interface

It cannot assume that the software has already been started; it should not start
stopped software, but should (if appropriate) restart running software to take
configuration changes into account.

### install

`install` is run at the beginning of a charm lifecycle. The hook should be used
to perform one-time setup operations, such as installing prerequisite software
that will not change with configuration changes.

### leader-elected

`leader-elected` is run at least once to signify that Juju decided this unit is
the leader. Authors can use this hook to take action if their protocols for
leadership, consensus, raft, or quorum require one unit to assert leadership.
If the election process is done internally to the application, other code
should be used to signal the leader to Juju. For more information read the
[charm leadership document](./authors-charm-leadership.html).

### leader-settings-changed

`leader-settings-changed` runs when the leader has set values for the other
units to respond to. Much like (config-changed)[#config-changed) but for the
leaders to send values to other units. Follower units can implement this hook
and take action when the leader sets values. For more information read the
[charm leadership document](./authors-charm-leadership.html).

### start

`start` runs immediately after the first `config-changed` hook. It should be
used to ensure the charm's software is running. Note that the charm's software
should be configured so as to persist through reboots without further
intervention on juju's part.

### stop

`stop` runs immediately before the end of the unit's destruction sequence. It
should be used to ensure that the charm's software is not running, and will not
start again on reboot.

This hook is called when an application removal is requested by the client. It
should implement the following logic:

- Stop the application
- Remove any files/configuration created during the application lifecycle
- Prepare any backup(s) of the application that are required for restore purposes.

### upgrade-charm

`upgrade-charm` runs immediately after any
[upgrade](./developer-upgrade-charm.html) operation that does _not_ itself
interrupt an existing [error state](./authors-hook-errors.html). It should be
used to reconcile local state written by some other version of the charm into
whatever form it needs to take to be manipulated by the current version.

While the forced upgrade functionality is intended as a developer tool, and is
not generally suitable for end users, it's somewhat optimistic to depend on the
functionality never being abused. In light of this, if you need to run an
`upgrade-charm` hook before your other hooks will work correctly, it may be wise
to preface all your other hooks with a quick call to your (idempotent)
`upgrade-charm`.

### update-status

`update-status` provides constant feedback to the user about the status of the
application the charm is modeling. The charm is run by Juju at regular
intervals, and gives authors an opportunity to run code that gets the “health”
of the application.

## Relation hooks

Units will only participate in relations after they're been started, and before
they've been stopped. Within that time window, the unit may participate in
several different relations at a time, _including_ multiple relations with the
same name.

To illustrate, consider a database application that will be used by multiple
client applications. Units of a single client application will surely want to
connect to, and use, the same database; but if units of another client
application were to use that same database, the consequences could be
catastrophic for all concerned.

If juju respected the `limit` field in relation [metadata](./authors-charm-metadata.html),
it would be possible to work around this, but it's not a high-
priority [bug](https://bugs.launchpad.net/bugs/1089297): most provider
applications _should_ be able to handle multiple requirers anyway; and most
requirers will only be connected to one provider anyway.

When a unit running a given charm participates in a given relation, it runs at
least three hooks for every remote unit it becomes aware of in that relation.

### [name]-relation-joined

`[name]-relation-joined` is run only when that remote unit is first
observed by the unit. It should be used to `relation-set` any local unit
settings that can be determined using no more than the name of the joining unit
and the remote `private-address` setting, which is always available when the
relation is created and is by convention not deleted.

You should not depend upon any other relation settings in the -joined hook
because they're not guaranteed to be present; if you need more information you
should wait for a -changed hook that presents the right information.

### [name]-relation-changed

`[name]-relation-changed` is always run once, after `-joined`, and will
subsequently be run whenever that remote unit changes its settings for the
relation. It should be the _only_ hook that _relies_ upon remote relation
settings from `relation-get`, and it should _not_ error if the settings are
incomplete: you can guarantee that when the remote unit changes its settings,
the hook will be run again.

The settings that you can get, and that you should set, are determined by the
relation's [interface](./authors-relations.html).

### [name]-relation-departed

`[name]-relation-departed` is run once only, when the remote unit is known to be
leaving the relation; it will only run once at least one `-changed` has been
run, and after `-departed` has run, no further `-changed` hooks will be run.
This should be used to remove all references to the remote unit, because there's
no guarantee that it's still part of the system; it's perfectly probable
(although not guaranteed) that the system running that unit has already shut
down.

When a unit's own participation in a relation is known to be ending, the unit
agent continues to uphold the ordering guarantees above; but within those
constraints, it will run the fewest possible hooks to notify the charm of the
departure of each individual remote unit.

Once all necessary `-departed` hooks have been run for such a relation, the unit
agent will run the final relation hook:

### [name]-relation-broken

`[name]-relation-broken` indicates that the current relation is no longer valid,
and that the charm's software must be configured as though the relation had
never existed. It will only be called after every necessary `-departed` hook has
been run; if it's being executed, you can be sure that no remote units are
currently known locally.

It is important to note that the `-broken` hook might run even if no other units
have ever joined the relation. This is not a bug: even if no remote units have
ever joined, the fact of the unit's participation can be detected in other hooks
via the `relation-ids` tool, and the `-broken` hook needs to execute to give the
charm an opportunity to clean up any optimistically-generated configuration.

And, again, it's important to internalise the fact that there may be multiple
runtime relations in play with the same name, and that they're independent: one
`-broken` hook does not mean that _every_ such relation is broken.

## Storage Charm Hooks

Juju can provide a variety of storage to charms. The charms can define several
different types of storage that are allocated from Juju. To read more
information, see the [storage document](./developer-storage.html)

### [name]-storage-attached

`[name]-storage-attached` allows the charm to run code when storage has been
added. The storage-attached hooks will be run before the install hook, so that
the installation routine may use the storage. The name prefix of this hook will
depend on the storage key [defined in the
metadata.yaml](./developer-storage.html#adding-storage) file.

### [name]-storage-detaching

`[name]-storage-detaching` allows the charm to run code before storage is
removed. The storage-detaching hooks will be run before storage is detached,
and always before the stop hook is run, to allow the charm to gracefully release
resources before they are removed and before the unit terminates. The name
prefix of the hook will depend on the storage key [defined in the
`metadata.yaml`](./developer-storage.html#adding-storage) file.

## Writing hooks

If you follow the [tutorial](./authors-charm-writing.html), you'll get a good
sense of the basics. To fill out your knowledge, you'll want to study the hook
[context and tools](./authors-hook-environment.html), and to experiment with
[debug-hooks](./authors-hook-debug.html).

Independent of the nuts and bolts, though, good hooks display a number of useful
high-level properties:

  - They are _idempotent_: that is to say that there should be no observable
difference between running a hook once, and running it N times in a row. If
this property does not hold, you are likely to be making your own life
unnecessarily difficult: apart from anything else, the average user's most
likely first response to a failed hook will be to try to run it again
(if they don't just skip it).
  - They are _easy to read_ and understand. It's tempting to write a single
file that does everything, and which just calls different functions internally
depending on the value of `argv[0]`, and to symlink that one file for every
hook; but such structures quickly become unwieldy. The time taken to write a
library, separate from the hooks, is very likely to be well spent: it lets you
write single hooks that are clear and focused, and insulates the maintainer
from irrelevant details.

  - Where possible, they reuse [common code](https://launchpad.net/charm-tools)
already written to ease or solve common use cases.
  - They do not return [errors](./authors-hook-errors.html) unless there is a
good reason to believe that they cannot be resolved without user intervention.
Doing so is an admission of defeat: a user who sees your charm returning an
error state is unlikely to have the specific expertise necessary to resolve it.
If you have to return an error, please be sure to at least write any context
you can to the log before you do so.
  - They write only _very_ sparingly to the
[charm directory](./authors-charm-components.html).

We recommend you also familiarise yourself with the [best practices]
(./authors-charm-best-practice.html) and, if you plan to distribute your charm, the [charm
store policy](./authors-charm-policy.html).
