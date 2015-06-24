Title: The lifecycle of charm relations

# The Relations lifecycle

A unit's `scope` consists of the group of units that are transitively connected
to that unit within a particular relation. So, for a globally-scoped relation,
that means every unit of each service in the relation; for a container-scoped
relation, it means only those sets of units which are deployed alongside one
another. That is to say: a globally-scoped relation has a single unit scope,
whilst a container-scoped relation has one for each principal unit.

When a unit becomes aware that it is a member of a relation, its only self-
directed action is to `join` its scope within that relation. This involves two
steps:

  - Write initial relation settings (just one value, `private-address`), to
    ensure that they will be available to observers before they're triggered 
    by the next step;
  - Signal its existence, and role in the relation, to the rest of the system.

The unit then starts observing and reacting to any other units in its scope
which are playing a role in which it is interested. To be specific:

  - Each provider unit observes every requirer unit
  - Each requirer unit observes every provider unit
  - Each peer unit observes every other peer unit

Now, suppose that some unit as the very first unit to join the relation; and
let's say it's a requirer. No provider units are present, so no hooks will fire.
But, when a provider unit joins the relation, the requirer and provider become
aware of each other almost simultaneously. (Similarly, the first two units in a
peer relation become aware of each other almost simultaneously.)

So, concurrently, the units on each side of the relation run their relation-
joined and relation-changed hooks with respect to their counterpart. The intent
is that they communicate appropriate information to each other to set up some
sort of connection, by using the relation-set and relation-get hook tools; but
neither unit is safe to assume that any particular setting has yet been set by
its counterpart.

This sounds tricky to deal with, but merely requires suitable respect for
the relation-get tool: it is important to realise that relation-get is never
_guaranteed_ to contain any values at all, because we have decided that it's
perfectly legitimate for a unit to delete its own private-address value. But in
normal circumstances, it's reasonable to treat `private-address` as guaranteed.

In one specific kind of hook, this is easy to deal with. A relation-changed hook
can always exit without error when the current remote unit is missing data,
because the hook is guaranteed to be run again when that data changes:
assuming the remote unit is running a charm that agrees on how to implement the
interface, the data _will_ change and the hook _will_ be run again.

In _all_ other cases - unit hooks, relation hooks for a different relation,
relation hooks for a different remote unit in the same relation, and even
relation hooks other than -changed for the _same_ remote unit - there is no
such guarantee. These hooks all run on their own schedule, and there is no
reason to expect them to be re-run on a predictable schedule, or in some cases
ever again.

This means that all such hooks need to be able to handle missing relation data,
and to complete successfully; they mustn't fail, because the user is powerless
to resolve the situation, and they can't even wait for state to change, because
they all see their own sandboxed composite snapshot of fairly-recent state,
which never changes.

So, outside a very narrow range of circumstances, relation-get should be treated
with particular care. The corresponding advice for relation-set is very simple
by comparison: relation-set should be called early and often. Because the unit
agent serializes hook execution, there is never any danger of concurrent changes
to the data, and so a null setting change can be safely ignored, and will not
cause other units to react.

## Departing relations

A unit will depart a relation when either the relation or the unit itself is
marked for termination. In either case, it follows the same sequence:

  - For every known related unit (those which have joined and not yet departed),
    run the relation-departed hook.
  - Run the relation-broken hook.
  - `depart` from its scope in the relation.

So what's the difference between relation-departed and relation-broken? Think of
relation-departed as the "saying goodbye" event. Relation settings can still be
read (with relation-get), but can no longer be set (with relation-set). When
relation-broken fires, the relation no longer exists. This is a good spot to do
any final cleanup, if necessary. Both relation-departed and relation-broken will
always fire, regardless of how the relation is terminated.

The unit's eventual departure from its scope will in turn be detected by units
of the related service (if they have not already inferred its imminent departure
by other means) and cause them to run relation-departed hooks. A unit's relation
settings persist beyond its own departure from the relation; the final unit to
depart a relation marked for termination is responsible for destroying the relation
and all associated data.
