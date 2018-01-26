Title: Leadership Howtos

# Leadership howtos 

Here are some examples of how to implement the leadership concept. See
[Implementing leadership][leadership] for background information.

## Sharing one-time configuration among units

Assuming your own implementations of `create_settings` and `valid_settings`,
you can use the two pseudo-python snippets below:

```python
def set_shared_settings():
    if is_leader():
        if not valid_settings(leader_get()):
            settings = create_settings()
            leader_set(settings)

def get_shared_settings():
    settings = leader_get()
    if not valid_settings(settings):
         raise WaitingForLeader()
    return settings
```

This can be used as follows:

 - `set_shared_settings` must be called in `leader-elected`, and may be
   called anywhere else you like (for example, at the very beginning of
   `install`, to cause those settings to be propagated to minions as soon
   as possible).
 - `get_shared_settings` must be called (and handled!) in
   `leader-settings-changed`, and may also be called at any other time it's
   convenient; you should always be prepared to catch WaitingForLeader and
   handle it appropriately (most likely by setting a "waiting" status and
   exiting without error, to wait for the `leader-settings-changed` which
   should arrive soon).

## Sharing varying configuration among units
  
You should be able to use the exact same constructs as above, in the same
way; you just might want to call `set_shared_settings` in a few more places.
If you need additional synchronisation, you can use a peer relation to
communicate minion's acknowledgements back to the leader.

!!! Note: 
    Peer relation membership is not guaranteed to match current reality
    at any given time. To be resilient in the face of your application scaling at
    the same time as you rebalance your application, your leader code will need
    to use the output of `status-get --application` to determine up-to-date
    membership, and wait for the set of acknowledged units in the peer relation
    to match that list.

## Guaranteeing that a long-lived process runs on just one unit at once

The `hacluster` charm used in our OpenStack deploys will set up corosync and
pacemaker, and may well be relevant to your needs; if that's not a good fit,
read on.

Juju's leadership concept is, by choice, relatively fine-grained, to ensure
timely handover of agent-level responsibilities. That's why `is-leader`
success guarantees only 30 seconds of leadership; but it's no fun running a
separate watchdog process to `juju-run is-leader` every 30 seconds and kill
your process when that stops working (apart from anything else, your juju-run
could be blocked by other operations, so you can't guarantee a run every 30
seconds anyway).

And we don't plan to allow coarser-grained leadership requests. This is
because if one unit could declare itself leader for a day (or even an hour)
a failed leader will leave other parts of Juju blocked for that length of
time, and we're not willing to take on that cost; the 30-60 second handover
delay is bad enough lready.

So, you'd basically have to implement your own protocol on top of the
available primitives. As a charm author, this is unlikely to be the best use
of your time -- extending the `hacluster` charm to cover your use case is
likely to be more efficient.

## Running a long-lived process on one unit at a time
 
!!! Note: 
    This approach is not reliable. It may be good enough for some
    workloads, but don't use it unless you understand the forces in play and the
    worst possible consequences for your users...

If you start your long-lived process in `leader-elected`, and stop it in
`leader-settings-changed`, this will *usually* do what you want, but is
vulnerable to a number of failure modes -- both because hook execution may be
blocked until after the leadership lease has actually expired, *and* because
total Juju failure could also cause the hook not to run (but leave the
workload untouched).

In the future, we may implement a `leader-deposed` hook, that can run with
*stronger* timeliness guarantees; but even if we do, it's a fundamentally
unreliable approach. Seriously, if you possibly can, go with the charmed-up
`hacluster` solution.


<!-- LINKS -->

[leadership]: ./developer-leadership.html
