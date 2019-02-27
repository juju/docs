Title: Implementing leadership

# Implementing leadership

Leadership provides a mechanism whereby multiple units of an application can
make use of a single, shared, authoritative source for charm-driven
configuration settings.

Every application deployed by Juju is guaranteed to have at most one leader at
any time. This is true independent of what the charm author does; whether or not
you implement the hooks or use the tools, the unit agents will each seek to
acquire leadership, and maintain it while they have it or wait for the current
leader to drop out.

## Leadership hooks

If you wish to be notified when your unit's leadership status changes, you
should implement the following hooks:

[`leader-elected`](reference-charm-hooks.html#leader-elected)  
which will run at least once, when the unit is known to be leader and guaranteed
to remain so for at least 30 seconds.

[`leader-settings-changed`](reference-charm-hooks.html#leader-settings-changed)  
will run at least once when the unit is not guaranteed continued leadership for
the next 30 seconds; and also whenever some other unit writes leader settings.

No particular guarantees can be made regarding the timeliness of the
`leader-settings-changed` hook; it's always possible for the Juju agent itself
to be taken out of commission at the wrong moment and not restart for a long
time.

## Leadership tools

Every unit can discover whether it's the leader, independent of the hook that's
running. There is deliberately no mechanism for discovering which *other* unit
is the leader; such data always risks staleness and opens the door to a lot of
race scenarios.

[`is-leader`](reference-hook-tools.html#is-leader)  
will write `"True"` or `"False"` to stdout, and return 0, if
the unit is currently leader and can be guaranteed to remain so for 30 seconds.
Output can be expressed as `--format json` or `--format yaml` if desired.
If it returns a non-zero exit code, no inferences regarding true leadership
status can be made, but you should generally fail safe and refrain from
acting as leader when you cannot be sure.

Truth is independent of hook sequence. If a unit has been designated leader
while mid-hook, it will start to return true; and if a unit were to, for
example, lose its connection to the state-server mid-hook, and be unable
to verify continued leadership past lease expiry time, it would start to
return false.

Every application deployed by Juju also has access to a pseudo-relation over
which leader settings can be communicated with the following tools:

[`leader-set`](reference-hook-tools.html#leader-set)  
acts much like `relation-set`, in that it lets you write string
key/value pairs (in which an empty value removes the key), but with the
following differences:

* there's only one leader-settings bucket per application (not one per unit)
* only the leader can write to the bucket
* only minions are informed of changes to the bucket
* changes are propagated instantly, bypassing the sandbox

The instant propagation exists to satisfy the use case where shared data can be
chosen by the leader at the very beginning of, for example, the install hook;
by propagating it instantly, any running minions can make use of the data and
progress immediately, without having to wait for the leader to finish its hook.

It also means that you can guarantee that a successful `leader-set` call has
been reflected in the database, and that all minions will converge towards
seeing that value, even if an unexpected error takes down the current hook.

For both these reasons we strongly recommend that leader settings are always
written as a self-consistent group (`leader-set foo=bar baz=qux ping=pong`,
rather than `leader-set foo=bar; leader-set baz=qux` etc, in which minions
may end up seeing a sandbox in which only `foo` is set to the "correct"
value).

[`leader-get`](reference-hook-tools.html#leader-get)  
acts much like relation-get, in that it lets you read string
values by key (and expose them in helpful formats), but with the following
difference:

* it reads only from the single leader-settings bucket

...and the following key similarity:

* it presents a sandboxed view of leader-settings data.

This is necessary, as it is for relation data, because a hook context needs
to present *consistent* data; but it means that there's a small extra burden
on users of `leader-set`.

## Leadership howtos 

See [Leadership howtos][leadership-howtos] for examples.


<!-- LINKS -->

[leadership-howtos]: ./developer-leadership-howtos.html
