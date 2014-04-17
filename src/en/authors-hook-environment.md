[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# How hooks are run

When a charm is deployed onto a unit, the raw charm is extracted into a
directory; this directory is known as the charm directory. It's owned and
operated by juju, and juju sometimes temporarily cedes control of it to user
code, by running a hook inside it.

When a hook's running, it should be considered to have sole access to the charm
directory; at all other times, you should consider that juju may be making
arbitrarily scary changes to the directory, and that it is not safe to read or
write to anything in there at all.

This is to say that the software you install must, once it's running, be
entirely independent of the charm that created it. It's fine (and encouraged,
with some caveats) to store _charm_ state in the charm directory, but the state
of your _software_ must remain unperturbed by direct changes to the charm.

So, every hook runs with easy access to the charm files. Every hook also runs as
root, with a number of useful variables set, and has access to hook-specific
tools that let you interrogate and affect the juju environment.

No more than one hook will execute on a given system at a given time. A unit in
a container is considered to be on a different system to any unit on the
container's host machine.

## Environment variables

The following variables are always available.

  - The `$CHARM_DIR` variable is the path to the charm directory.
  - The `$PATH` variable is prefixed with the path to the hook tools directory.
  - The `$JUJU_UNIT_NAME` variable holds the name of the unit.
  - The `$JUJU_API_ADDRESSES` variable holds a space-separated list of API server addresses.

In addition, every relation hook makes available relation-specific variables.

  - The `$JUJU_RELATION` variable holds the relation name. This information is of limited value, because it's always the same as the part of the hook name just before "-relation-".
  - The `$JUJU_RELATION_ID` variable holds an opaque relation identifier, used to distinguish between multiple relations with the same name. It is vitally important, because it's the only reasonable way of telling the difference between (say) a database service's many independent clients.

...and, if that relation hook is not a -broken hook:

  - The `$JUJU_REMOTE_UNIT` variable holds the name of the unit which is being reported to have -joined, -changed, or -departed.

Juju does _not_ pay any attention to the values of the above variables when
running hook tools: they're a one-way communication channel from juju to the
charm only. Finally, in all cases:

  - The `$JUJU_AGENT_SOCKET` and `$JUJU_CONTEXT_ID` variables allow the hook tools to work: juju _does_ pay attention to them, but you should treat them as opaque and avoid messing with them.

Finally, if you're [debugging](./authors-hook-debug.html), you'll also have
access to:

  - The `$JUJU_HOOK_NAME` variable, which will be set to the current hook name.

## Hook tools

All hook tools are available in all hooks. Many of the tools produce output, and
those that do accept a `--format` flag whose value can be set to `json` or
`yaml` as desired. If it's not specified, the format defaults to `smart`, which
transforms the basic output as follows:

  - strings are left untouched
  - boolean values are converted to the strings `True` and `False`
  - ints and floats are converted directly to strings
  - lists of strings are converted to a single newline-separated string
  - all other types (in general, dictionaries) are formatted as YAML

Tools which do not produce output also accept the `--format` flag, but ignore
it, for compatibility reasons.

The various "relation-" tools infer context from the hook where possible. If
they're running in a relation hook, the current relation id is set as the
default; and if they're running in a -joined, -changed, or -broken hook, the
current remote unit is set as the default.

Best use of relation hooks will be made by those who understand the [relation
model](./authors-relations-in-depth).

### juju-log

`juju-log` writes its arguments directly to the unit's log file. All hook output
is currently logged anyway, so it's theoretically redundant with `echo`, but
this is an implementation detail and should not be depended upon. If it's
important, please `juju-log` it.

    juju-log "some important text"

It accepts a `--debug` flag which causes the message to be logged at `DEBUG`
level; in all other cases it's logged at `INFO` level. The `-l`/`--level`
argument is ignored, and is present only to prevent legacy charms from entirely
failing to run; the inability to specify logging levels and targets in more
detail is a known [bug](https://bugs.launchpad.net/juju-core/+bug/1223325).

### unit-get

`unit-get` returns information about the local unit. It accepts a single
argument, which must be `private-address` or `public-address`. It is not
affected by context:

    unit-get private-address
    10.0.1.101
    unit-get public-address
    foo.example.com

### config-get

`config-get` returns information about the service configuration (as defined by
the charm). If called without arguments, it returns a dictionary containing all
config settings that are either explicitly set, or which have a non-nil default
value. If the `--all` flag is passed, it returns a dictionary containing all
definied config settings including nil values (for those without defaults). If
called with a single argument, it returns the value of that config key. Missing
config keys are reported as having a value of nil, and do not return an error.

Getting the interesting bits of the config is done with:

    config-get
    key: some-value
    another-key: default-value

To get the whole config including the nulls:

    config-get --all
    key: some-value
    another-key: default-value
    no-default: null

To retrieve a specific value pass its key as argument:

    config-get [key]
    some-value

The command can also be call if no value is set and no default is set of even if
the setting doesn't exist. In both cases nothing will be returned.

    config-get [key-with-no-default]
    config-get [missing-key]

**Note: ** The above two examples are not misprints - asking for a value which doesn't exist or has not been set returns nothing and raises no errors.

### open-port

`open-port` marks a port on the local system as appropriate to open, if and when
the service is exposed to the outside world. It accepts a single port with an
optional protocol, which may be `udp` or `tcp`, where `tcp` is the default.

Examples:

Open 80/tcp if and when the service is exposed:

    open-port 80

Open 1234/udp if and when the service is exposed:

    open-port 1234/udp

`open-port` will not have any effect if the service is not exposed, and may have
a somewhat delayed effect even if it is. It accepts and ignores `--format`,
because it doesn't produce any output.

### close-port

`close-port` unmarks a local system port. If the service is not exposed, it has
no effect; otherwise the port is marked for imminent closure. It accepts the
same flags and arguments as `open-port`.

Examples:

Close 1234/udp if it was open:

    close-port 1234/udp

Close port 80 if it was open:

    close-port 80

### relation-set

`relation-set` writes the local unit's settings for some relation. It accepts
any number of `key=value` strings, and an optional `-r` argument, which defaults
to the current relation id. If it's not running in a relation hook, `-r` needs
to be specified. The `value` part of an argument is not inspected, and is stored
directly as a string. Setting an empty string causes the setting to be removed.

Examples:

Setting a pair of values for the local unit in the default relation which is
stored in the environment variable `JUJU_RELATION_ID`:

    echo $JUJU_RELATION_ID
    server:3

The setting is done with:

    relation-set username=bob password=2db673e81ffa264c

To set the pair of values for the local unit in a specific relation specify the
relation id:

    relation-set -r server:3 username=jim password=12345

To clear a value for the local unit in the default relation enter:

    relation-set deprecated-or-unused=

`relation-set` is the single tool at your disposal for communicating your own
configuration to units of related services. At least by convention, the charm
that `provides` an interface is likely to set values, and a charm that
`requires` that interface will read them; but there's nothing forcing this.
Whatever information you need to propagate for the remote charm to work must be
propagated via relation-set, with the single exception of the `private-address`
key, which is always set before the unit joins.

You may wish to overwrite the `private-address` setting, for example if you're
writing a charm that serves as a proxy for some external service; but you should
in general avoid _removing_ that key, because most charms expect that value to
exist unconditionally.

All values set are stored locally until the hook completes; at that point, if
the hook exit code is 0, all changed values will be communicated to the rest of
the system, causing -changed hooks to run in all related units.

There is no way to write settings for any unit other than the local unit; but
any hook on the local unit can write settings for any relation the local unit is
participating in.

### relation-get

`relation-get` reads the settings of the local unit, or of any remote unit, in a
given relation (set with `-r`, defaulting to the current relation, as in
`relation-set`). The first argument specifies the settings key, and the second
the remote unit, which may be omitted if a default is available (that is, when
running a relation hook other than -broken).

If the first argument is omitted, a dictionary of all current keys and values
will be printed; all values are always plain strings without any interpretation.
If you need to specify a remote unit but want to see all settings, use `-` for
the first argument.

The environment variable `JUJU_REMOTE_UNIT` stores the default remote unit:

    echo $JUJU_REMOTE_UNIT
    mongodb/2

Getting the settings of the default unit in the default relation is done with:

    relation-get
    username: jim
    password: "12345"

To get one setting from the default remote unit in the default relation enter:

    relation-get username
    jim

To get all settings from a particular remote unit in a particular relation you
specify them together with the command. So

    relation-get -r database:7 - mongodb/5
    username: bob
    password: 2db673e81ffa264c

Note that `relation-get` produces results that are _consistent_ but not
necessarily _accurate_, in that you will always see settings that:

  - were accurate at some point in the reasonably recent past 
  - are always the same within a single hook run... 
  - _except_ when inspecting the unit's own relation settings, in which case local changes from `relation-set` will be seen correctly.

You should never depend upon the presence of any given key in `relation-get`
output. Processing that depends on specific values (other than `private-addres`)
should be restricted to -changed hooks for the relevant unit, and the absence of
a remote unit's value should never be treated as an [error](./authors-hook-
errors.html) in the local unit.

In practice, it is common and encouraged for -relation-changed hooks to exit
early, without error, after inspecting `relation-get` output and determining it
to be inadequate; and for [all other hooks](./authors-hook-kinds.html) to be
resilient in the face of missing keys, such that -relation-changed hooks will be
sufficient to complete all configuration that depends on remote unit settings.

Settings for remote units already known to have departed remain accessible for
the lifetime of the relation.

`relation-get` currently has a [bug](https://bugs.launchpad.net/juju-
core/+bug/1223339) that allows units of the same service to see each other's
settings outside of a peer relation. Depending on this behaviour is foolish in
the extreme: if you need to share settings between units of the same service,
always use a peer relation to do so, or you may be seriously inconvenienced when
the hole is closed without notice.

### relation-list

`relation-list` accepts the `-r` flag as above, and outputs the names of every
remote unit currently known to be in the relation.

Examples:

To show all remote units in the current relation enter:

    relation-list
    mongodb/0
    mongodb/2
    mongodb/3

All remote units in a specific relation can be shown with:

    relation-list -r website:2
    haproxy/0

### relation-ids

`relation-ids` accepts a single argument which, in a relation hook, defaults to
the name of the current relation.

Examples:

The current relation is stored in the environment variable `JUJU_RELATION`. So
all relations like the current one can be shown with:

    relation-ids
    server:1
    server:7
    server:9

To show all relations with a given name pass it as argument:

    relation-ids reverseproxy
    reverseproxy:3

Note again that all commands that produce output accept `--format json` and
`--format yaml`, and you may consider it smarter to use those for clarity's sake
than to depend on the default `smart` format.

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

