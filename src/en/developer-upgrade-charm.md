Title: Upgrading a Charm

# Upgrade Charm

A service's charm can be changed at runtime with the `upgrade-charm` command. By
default, it changes to the latest available version of the same charm; if
`--revision` is specified, it changes to that revision of the same charm; and if
`--switch` is specified it changes to any arbitrary charm, inferred from the
argument in the same way as in `juju deploy`.

For a charm to replace another, though, there is a minimum standard of
compatibility, which applies regardless of the particular change. That is:

  - a subordinate charm must be replaced by a subordinate charm, and a principal
    charm must be replaced by a principal charm.
  - every runtime relation used by the service must exist in both charms.
  - charm relations that are defined, but not in use at runtime, may be removed
    freely.
  - in particular, it's not possible to remove a peer relation by upgrading,
    because peer relations are always in use.

No other factor is used in determining compatibility: configuration settings in
particular are converted completely naively, such that any settings from the
original charm that share a name and type are preserved; any incompatible
settings are removed; and any new settings take defaults as though freshly
deployed.

When a service has been upgraded but a particular unit has not, the unit will
continue to see the configuration settings from before conversion; these
settings will not be affected by subsequent changes to the service's settings.

## Forced charm upgrades

Juju defines the [upgrade-charm hook](reference-charm-hooks.html#upgrade-charm)
for resolving differences between versions of the same charm. No notice is given
of charm upgrades; a charm upgrade may run at any time the unit is started, and
the only opportunity for resolution that exists occurs *after* the change has
taken place.

This is quite a tight restriction, but nonetheless valuable, so long as you can
guarantee it will run. However, it's important to understand that the upgrade-
charm accepts a `--force` flag: a forced charm upgrade will upgrade even units
that are currently in an [error](./authors-hook-errors.html) state, at the cost
of skipping the `upgrade-charm` hook for those units.

This is useful for charm authors who want to push a new version of a failed hook
(they can `upgrade-charm --force` and then `resolved --retry` to run it
immediately without otherwise disturbing the system); but it's potentially
dangerous if abused. We recommend that use of the feature be restricted to charm
authors while developing their own charms, and that it's not sensible to devote
serious effort to recovering from inappropriately forced upgrades.

## Charm upgrade errors

These will only occur as a result of conflicts between the contents of the charm
directory written at runtime, and should never be seen by a user; users
certainly cannot be expected to understand the structure of your charm well
enough to solve the conflicts sanely.

When you're writing a new version of a charm, you should always test upgrading
it from (at least) the previous version, to ensure these errors don't slip out
into the wild.

You can completely avoid these errors by _never_ writing to the charm directory;
and you can also avoid them by rigorously delineating the parts of your charm
directory that you write to at runtime, and ensuring you never add a file to the
raw charm that could conflict with the runtime state.

If you're writing your hooks in Python, you should be doubly aware of this: if
you don't configure Python to suppress bytecode caching, it will write `.pyc`
files next to your Python files at runtime, and effectively prevent you from
rearranging those directories in future. This is not an unreasonable burden to
bear, but it's important to know you're taking it on.

If you encounter a charm upgrade error, you can run `git status` in the charm
directory to see what the problem is, and use the knowledge thus gleaned to fix
the charm and try to upgrade again.
