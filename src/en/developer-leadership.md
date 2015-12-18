Title: implementing leadership in juju charms

# Leadership for the Charm author

Leadership provides a mechanism whereby multiple units of a service can make
use of a single, shared, authoritative source for charm-driven configuration
settings.

Every service deployed by juju is guaranteed to have at most one leader at any
time. This is true independent of what the charm author does; whether or not
you implement the hooks or use the tools, the unit agents will each seek to
acquire leadership, and maintain it while they have it or wait for the current
leader to drop out.

## Leadership hooks

If you wish to be notified when your unit's leadership status changes, you
should implement the following hooks:

####  [`leader-elected`](reference-charm-hooks.html#leader-elected)
which will run at least once, when the unit is known to be leader and guaranteed
to remain so for at least 30s.

####  [`leader-settings-changed`](reference-charm-hooks.html#leader-settings-changed)
will run at least once when the unit is not guaranteed continued leadership for
the next 30s; and also whenever some other unit writes leader settings.

No particular guarantees can be made regarding the timeliness of the
`leader-settings-changed` hook; it's always possible for the juju agent itself
to be taken out of commission at the wrong moment and not restarted for a long
time.

## Leadership tools

Every unit can discover whether it's leader, independent of the hook that's
running. There is deliberately no mechanism for discovering which *other* unit
is the leader; such data always risks staleness and opens the door to a lot of
race scenarios.

### [`is-leader`](refence-hook-tools.html#is-leader)
will write `"True"` or `"False"` to stdout, and return 0, if
the unit is currently leader and can be guaranteed to remain so for 30s.
Output can be expressed as `--format json` or `--format yaml` if desired.
If it returns a non-zero exit code, no inferences regarding true leadership
status can be made, but you should generally fail safe and refrain from
acting as leader when you cannot be sure.

Truth is independent of hook sequence. If a unit has been
designated leader while mid-hook, it will start to return true; and if a
unit were to (say) lose its state-server connection mid-hook, and be unable
to verify continued leadership past lease expiry time, it would start to
return false.

Every service deployed by juju also has access to a pseudo-relation over which
leader settings can be communicated with the following tools:

### [`leader-set`](refrence-hook-tools.html#leader-set)
acts much like `relation-set`, in that it lets you write string
key/value pairs (in which an empty value removes the key), but with the
following differences:

* there's only one leader-settings bucket per service (not one per unit)
* only the leader can write to the bucket
* only minions are informed of changes to the bucket
* changes are propagated instantly, bypassing the sandbox

The instant propagation is surprising, and exists to satisfy the use case
where shared data can be chosen by the leader at the very beginning of (say)
the install hook; by propagating it instantly, any running minions can make
use of the data and progress immediately, without having to wait for the
leader to finish its hook.

It also means that you can guarantee that a successful `leader-set` call has
been reflected in the database, and that all minions will converge towards
seeing that value, even if an unexpected error takes down the current hook.

For both these reasons we strongly recommend that leader settings are always
written as a self-consistent group (`leader-set foo=bar baz=qux ping=pong`,
rather than `leader-set foo=bar; leader-set baz=qux` etc, in which minions
may end up seeing a sandbox in which only `foo` is set to the "correct"
value).

### [`leader-get`](reference-hook-tools.html#leader-get)
acts much like relation-get, in that it lets you read string
values by key (and expose them in helpful formats), but with the following
difference:

* it reads only from the single leader-settings bucket

...and the following key similarity:

* it presents a sandboxed view of leader-settings data.

This is necessary, as it is for relation data, because a hook context needs
to present *consistent* data; but it means that there's a small extra burden
on users of `leader-set`.

# Leadership HowTo's

### How do I...

### ...share one-shot configuration among units?

Assuming your own implementations of `create_settings` and `valid_settings`, you
can use the two pseudopython snippets below:

    def set_shared_settings():
        if is_leader():
            if !valid_settings(leader_get()):
                settings = create_settings()
                leader_set(settings)

    def get_shared_settings():
        settings = leader_get()
        if !valid_settings(settings):
             raise WaitingForLeader()
        return settings

...which can be used as follows:

  * `set_shared_settings` must be called in `leader-elected`, and may be called
    anywhere else you like (for example, at the very beginning of `install`, to
    cause those settings to be ppropagated to minions as soon as possible).
  * `get_shared_settings` must be called (and handled!) in
    `leader-settings-changed`, and may also be called at any other time it's
    convenient; you should always be prepared to catch WaitingForLeader and
    handle it appropriately (most likely by setting a "waiting" status and
    exiting without error, to wait for the `leader-settings-changed` which
    should arrive soon).

### ...share varying configuration among units?

You should be able to use the exact same constructs as above, in the same way;
you just might want to call `set_shared_settings` in a few more places. If you
need additional synchronisation, you can use a peer relation to communicate
minions' acknowledgements back to the leader.

!!! Note: peer relation membership is not guaranteed to match current reality
at any given time. To be resilient in the face of your service scaling at the
same time as you (say) rebalance your service, your leader code will need to
use the output of `status-get --service` to determine up-to-date membership,
and wait for the set of acked units in the peer relation to match that list.

### ...guarantee that a long-lived process runs on just one unit at once?

The `hacluster` charm used in our OpenStack deploys will set up corosync and
pacemaker, and may well be relevant to your needs; if that's not a good fit,
read on.

Juju's leadership concept is, by choice, relatively fine-grained, to ensure
timely handover of agent-level responsibilities. That's why `is-leader` success
guarantees only 30s of leadership; but it's no fun running a separate watchdog
process to `juju-run is-leader` every 30s and kill your process when that stops
working (apart from anything else, your juju-run could be blocked by other
operations, so you can't guarantee a run every 30s anyway).

And we don't plan to allow coarser-grained leadership requests. This is because
if one unit could declare itself leader for a day (or even an hour) a failed
leader will leave other parts of juju blocked for that length of time, and we're
not willing to take on that cost; the 30-60s handover delay is bad enough
already.

So, you'd basically have to implement your own protocol on top of the available
primitives. As a charm author, this is unlikely to be the best use of your time
-- extending the `hacluster` charm to cover your use case is likely to be more
efficient.

### ...render it likely that a long-lived process runs on one unit at a time?

!!! Note: this approach is not reliable. It may be good enough for some
workloads, but don't use it unless you understand the forces in play and the
worst possible consequences for your users...

If you start your long-lived process in `leader-elected`, and stop it in
`leader-settings-changed`, this will *usually* do what you want, but is
vulnerable to a number of failure modes -- both because hook execution may be
blocked until after the leadership lease has actually expired, *and* because
total juju failure could also cause the hook not to run (but leave the workload
untouched).

In the future, we may implement a `leader-deposed` hook, that can run with
*stronger* timeliness guarantees; but even if we do, it's a fundamentally
unreliable approach. Seriously, if you possibly can, go with the charmed-up
`hacluster` solution.
