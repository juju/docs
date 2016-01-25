# Charm hooks reference

Hooks are executable files in a charm’s `hooks` directory. Hooks are invoked by
the Juju agent to trigger events in a charm.

All the hooks must be written to be
[idempotent](https://en.wikipedia.org/wiki/Idempotence), meaning that there
should be no difference from running the hook once from running it multiple
times.  This property is important because hooks can be run multiple times by
the Juju system in ways that might be difficult to predict.

## Core lifecycle hooks

This is a list of hooks that run during the normal charm lifecycle.

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
that will not change with configuration changes.  Like all hooks this must be
idempotent because there are scenarios where this hook can be run more than
once.

### leader-elected

`leader-elected` run at least once to signify that Juju decided this unit is
the leader.  Authors can use this hook to take action if their protocols for
leadership, consensus, raft, or quorum require one unit to assert leadership.
If the election process is done internally to the service, other code should be
used to signal the leader to Juju.  For more information read the [charm
leadership document](./authors-charm-leadership.html).  

### leader-settings-changed

`leader-settings-changed` runs when the leader has set values for the other
units to respond to.  Much like (config-changed)[#config-changed) but for the
leaders to send values to other units.  Follower units can implement this hook
and take action when the leader sets values.  For more information read the
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

This hook is called when a service removal is requested by the client. It should
implement the following logic:

- Stop the service
- Remove any files/configuration created during the service lifecycle
- Prepare any backup(s) of the service that are required for restore purposes.

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
service the charm is modeling.  The charm is run by Juju at regular intervals,
and gives authors an opportunity to run code that gets the “health” of the
service or services.  

## Relation hooks

Units will only participate in relations after they're been started, and before
they've been stopped. Within that time window, the unit may participate in
several different relations at a time, _including_ multiple relations with the
same name.

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

Juju can provides a variety of storage to charms.  The charms can define several
different types of storage that are allocated from Juju.  To read more
information, see the [storage
document](./storage.html)

### [name]-storage-attached

`[name]-storage-attached` allows the charm to run code when storage has been
added.  The storage-attached hooks will be run before the install hook, so that
the installation routine may use the storage.  The name prefix of this hook will
depend on the storage key [defined in the
metadata.yaml](./storage.html#adding-storage-to-the-metadata.yaml) file.

### [name]-storage-detaching

`[name]-storage-detaching` allows the charm to run code before storage is
removed.  The storage-detaching hooks will be run before storage is detached,
and always before the stop hook is run, to allow the charm to gracefully release
resources before they are removed and before the unit terminates.  The name
prefix of the hook will depend on the storage key [defined in the
`metadata.yaml`](./storage.html#adding-storage-to-the-metadata.yaml) file.
