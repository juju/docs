# Charm relation interfaces

As described [elsewhere](./authors-charm-metadata.html), picking an interface is
a strong statement; whether you're providing or requiring a given interface, you
need to be compatible with all providers and requirers of that interface.

In short, this means that you need to set the same settings as do all the other
charms with the same role for the interface; and you should only expect to be
able to read those settings set by the other charms with the counterpart role.

!!__Note: __ Some popular interfaces are documented and we have reference
implementations for them. If you are just starting out with interfaces, you  may
find it easier to start with these.

## Determining charm relation interfaces

This is in some respects an uncomfortable situation to be in. If two charms
declare compatibility, but fail when run together due to disagreement about the
actual definition of that interface; it's not immediately clear which is at
fault, because the "standard" is defined only by consensus among the existing
charms that provide or require that interface.

On the upside, this means that reading any charm that already implements the
interface is *theoretically* good enough to figure it out; in practice, it's
sometimes hard to understand the code in isolation. The incontrovertible way to
determine the protocol defined by an interface is to deploy a pair of charms
that already use that interface, and [intercept](./authors-hook-debug.html) the
communications between them.

    juju deploy mongodb
    juju deploy node-app

In a separate window, once node-app/0 reports `started` status:

    juju debug-hooks node-app/0 *

This opens a tmux session; when the unit wants to run a hook, it'll create a new
window in which you can interactively inspect the environment. In a relation
hook, you'll want to run the following commands:

    relation-get

This should produce a `key: value` pairing of relation data for that event. The
output will resemble something similar to this:
    
    address: example.com:37070
    username: bob
    password: seekrit

...and then close that tmux window and wait to see if another one opens for the
next hook. Assuming you started debugging before creating the relation, you'll
see exactly one -joined hook, and at least one -changed hook, and you're only
done when new -changed hooks stop popping up.

The relation-get [tool](./authors-hook-environment.html) accepts a `--format`
parameter that accepts `json` and `yaml` values, in case you want to consume
them programmatically.

In practice, what you'll most likely find is that one side sets a couple of
keys, the other side gets them, and that's that... in no more than two changed
hooks. Be aware, though, that it is possible in principle for an interface to
imply a more demanding interface, involving multiple rounds of setting and
getting.

## Documenting charm relation interfaces

In light of the above, there is a clear need for some means of documenting the
above. The optional `gets` and `sets` fields in a charm's relation [metadata
](./authors-charm-metadata.html) should be used for this purpose.

Please be especially careful to note that this format is *not* checked by juju
today. But it does encode the information that's most helpful to your fellow
charmers, and by doing so in a consistent and machine-readable format we
maximise our chances of one day making use of this information automatically.

The simple form, which will be the most common form, looks like this:

    name: python-django
    ...
    provides:
      website:
        interface: http
        sets: [host, port]

...and this:
    
    name: haproxy
    ...
    requires:
      reverseproxy:
        interface: http
        gets: [host, port]
    

this indicates that a relation can surely be made between python-django and
haproxy, because the `website` relation unconditionally sets the keys that the
`reverseproxy` relation requires in order to function.

The more complex form, which is only required for complex protocols, is defined
as follows:

  - `gets` holds a list of settings keys that must all be set by each unit on the remote end of a relation in order for the local unit to function.
  - `sets` holds a list of settings that will be set by each unit of the local charm. These settings can either be a plain string, indicating that no remote settings need exist for this key to be written; or a single-element map, with the setting to be written mapped to the remote settings that must exist for this to be done.

For example, consider charms `a` and `b`, which do the following handshake dance
before they can complete their configuration:

  - `b/0` starts running -joined, which takes a while.
  - `a/0` runs -joined and -changed before `b/0` has finished -joined. In the -changed hook, it fails to find the remote settings it expected, and exits without error.
  - `b/0` finishes -joined, setting `X` and `Y`, thus triggering -changed on `a/0`.
  - `a/0` sets `P` and `Q` in response, causing a -changed on `b/0`.
  - `b/0` completes local configuration using `P` and `Q`, and sets `Z`, triggering a final -changed on `a/0`.
  - `a/0` completes local configuration using `X`, `Y`, and `Z`, and sets nothing.

For example, in the hypothetical complex protocol described in the previous
section, the metadata for charm `a` above would contain:

    requires:
      ab:
        interface: ab
        sets:
        - P: [X, Y]
        - Q: [X, Y]
        gets: [X, Y, Z]
    

...indicating that `P` and `Q` will only be written when `X` and `Y` have; and
that configuration will not complete without `X`, `Y` and `Z`. Meanwhile charm
`b` would contain:

    provides:
      ab:
        interface: ab
        sets:
        - X
        - Y
        - Z: [P, Q]
        gets: [P, Q]

...indicating that it will always write `X` and `Y`, and that `Z` will be
written when `P` and `Q` have; and that configuration will not be complete
without `P` and `Q`.

Peer relations are a different matter, in that peer relations are the mechanism
by which service units share information internally. It's not unusual for peer
service units to maintain convenient caches of distributed information in their
own peer settings, and this inevitably involves generating settings keys at
runtime.

## Interface reference implementations

Although we have described above that interfaces arrive by convention, there are
several well-used interfaces which have enough implementations to define a
defacto standard.

Below is a list of the interfaces for which we have compiled documentation and
reference implementations.

  - [mysql](./interface-mysql.html) - the database interface used by MySQL and client services.
