Title: Hook tools

# Hook tools

Juju incorporates a number of helper functions called 'hook-tools' which can be
executed from within the hook environment - i.e. they can form part of the code
for a charm's hooks (and also can be used during debug sessions). They are
provided as shell commands, but if you are writing your charm using Python,
they are wrapped by the charmhelpers module (
[see the relevant docs for charmhelpers here](https://pythonhosted.org/charmhelpers/api/charmhelpers.core.hookenv.html))

Many of the tools produce output,
and those that do accept a `--format` flag whose value can be set to `json` or
`yaml` as desired. If it's not specified, the format defaults to `smart`, which
transforms the basic output as follows:


  - strings are left untouched
  - boolean values are converted to the strings `True` and `False`
  - ints and floats are converted directly to strings
  - lists of strings are converted to a single newline-separated string
  - all other types (in general, dictionaries) are formatted as YAML

Also see the [hook environment](./authors-hook-environment.html) page for further
details of the hook environment.

## Available commands:

### close-port

`close-port` unmarks a local system port. If the service is not exposed, it has
no effect; otherwise the port is marked for imminent closure. It accepts the
same flags and arguments as `open-port`.

Examples:

Close 1234/udp if it was open:

```no-highlight
close-port 1234/udp
```

Close port 80 if it was open:

```no-highlight
close-port 80
```

Close a range of ports:

```no-highlight
close-port 80-100
```

### config-get

`config-get` returns information about the service configuration (as defined by
the charm). If called without arguments, it returns a dictionary containing all
config settings that are either explicitly set, or which have a non-nil default
value. If the `--all` flag is passed, it returns a dictionary containing all
defined config settings including nil values (for those without defaults). If
called with a single argument, it returns the value of that config key. Missing
config keys are reported as nulls, and do not return an error.

Getting the interesting bits of the config is done with:

```no-highlight
config-get
key: some-value
another-key: default-value
```

To get the whole config including any nulls:

```no-highlight
config-get --all
key: some-value
another-key: default-value
no-default: null
```

To retrieve a specific value pass its key as argument:

```no-highlight
config-get [key]
some-value
```

This command will also work if no value is set and no default is set or even
if the setting doesn't exist. In both cases nothing will be returned.

```no-highlight
config-get [key-with-no-default]
config-get [missing-key]
```

!!! Note: The above two examples are not misprints - asking for a value which
doesn't exist or has not been set returns nothing and raises no errors.

### juju-log

`juju-log` writes its arguments directly to the unit's log file. All hook
output is currently logged anyway, though this may not always be the case - If
it's important, use`juju-log`.

```bash
juju-log "some important text"
```

This tool accepts a `--debug` flag which causes the message to be logged at
`DEBUG` level; in all other cases it's logged at `INFO` level.

### juju-reboot [--now]

There are several cases where a charm needs to reboot a machine, such as
after a kernel upgrade, or to upgrade the entire system. The charm may not
be able to complete the hook until the machine is rebooted.

The juju-reboot command allows charm authors to schedule a reboot from inside
a charm hook. The reboot will only happen if the hook completes without error.
You can schedule a reboot like so:

```bash
juju-reboot
```

The `--now` option can be passed to block hook execution. In this case the
`juju-reboot` command will hang until the unit agent stops the hook and
re-queues it for the next run. This will allow you to create multi-step
install hooks.

Charm authors must wrap calls to juju-reboot to ensure it is actually
necessary, otherwise the charm risks entering a reboot loop. The preferred
work-flow is to check if the feature/charm is in the desired state, and
reboot when needed. This bash example assumes that "$FEATURE_IS_INSTALLED"
variable was defined by a check for the feature, then 'juju-reboot' is
called if the variable is false:

```bash
if [[ $FEATURE_IS_INSTALLED  == "false" ]]
then
    install_feature
    juju-reboot --now
fi
```

The `juju-reboot` command can be called from any hook. It can also be
called using the `juju run` command.


### is-leader

`is-leader` will write `"True"` or `"False"` to stdout, and return 0, if
the unit is currently leader and can be guaranteed to remain so for 30
seconds.

Output can be expressed as `--format json` or `--format yaml` if desired.

If it returns a non-zero exit code, no inferences regarding true leadership
status can be made, but you should generally opt to fail safe and refrain from
acting as the leader when not sure.

The result of `is-leader` truth is independent of hook sequence. If a unit has
been designated as the leader while the hook is running, it will start to
return true; and if a unit were to (for example) lose its state-server
connection mid-hook and be unable to verify continued leadership past lease
expiry time, it would start to return false.

### leader-set

Every service deployed by Juju has access to a pseudo-relation over which
leader settings can be communicated.

`leader-set` acts much like [`relation-set`](#relation-set), in that it lets
you write string key/value pairs (in which an empty value removes the key), but
with the following differences:

      * there's only one leader-settings bucket per service (not one per unit)
      * only the leader can write to the bucket
      * only minions are informed of changes to the bucket
      * changes are propagated instantly, bypassing the sandbox

The instant propagation may be surprising, but it exists to satisfy the use case
where shared data can be chosen by the leader at the very beginning of (say)
the install hook. By propagating it instantly, any running minions can make
use of the data and progress immediately, without having to wait for the
leader to finish its hook.

It also means that you can guarantee that a successful `leader-set` call has
been reflected in the database, and that all minions will converge towards
seeing that value, even if an unexpected error takes down the current hook.

For both these reasons it is strongly recommended that leader settings are
always written as a self-consistent group (`leader-set foo=bar baz=qux ping=pong`,
rather than `leader-set foo=bar; leader-set baz=qux` etc, to avoid situations
where minions may end up seeing a sandbox in which only `foo` is set to the
"correct" value).

### leader-get

`leader-get` acts much like relation-get, in that it lets you read string
values by key (and expose them in helpful formats), but it reads only from the
single leader-settings bucket.

As with `realtion-get`, it presents a sandboxed view of leader-settings data.
This is necessary, as it is for relation data, because a hook context needs
to present *consistent* data; but it means that there's a small extra burden
on users of `leader-set`.


### open-port

`open-port` marks a port or range of ports on the local system as appropriate to
open, if and when the service is exposed to the outside world. It accepts a
single port or range of ports with an optional protocol, which may be `udp` or
`tcp`, where `tcp` is the default.

Examples:

Open 80/tcp if and when the service is exposed:

```no-highlight
open-port 80
```

Open 1234/udp if and when the service is exposed:

```no-highlight
open-port 1234/udp
```

Open the range 8000 to 8080:

```no-highlight
open 8000-8080/tcp
```

`open-port` will not have any effect if the service is not exposed, and may have
a somewhat delayed effect even if it is. This operation is transactional, so
changes will not be made unless the hook exits successfully.

Juju also tracks ports opened across the machine and will not allow conflict; if
another charm has already opened the port
(**or one or more ports in a range**) you have specified,
your request will be ignored.

This command accepts and ignores `--format` for
compatibility purposes, but it doesn't produce any output.

### opened-ports

The opened-ports hook tool lists all the ports currently opened
**by the running charm**. It does not, at the moment, include ports which may
be opened by other charms co-hosted on the same machine
[lp #1427770](https://bugs.launchpad.net/juju-core/+bug/1427770).

The command returns a list of one port or range of ports per line, with the port
number followed by the protocol (tcp or udp).

For example, running `opened-ports` may return:

```no-highlight
70-80/tcp
81/tcp
```

!!! Note: opening ports is transactional (i.e. will take place on successfully
exiting the current hook), and therefore `opened-ports` will not return any
values for pending `open-port` operations run from within the same hook.




### relation-get

`relation-get` reads the settings of the local unit, or of any remote unit,
in a given relation (set with `-r`, defaulting to the current relation
identifier, as in `relation-set`). The first argument specifies the settings
key, and the second the remote unit, which may be omitted if a default is
available (that is, when running a relation hook other than -broken).

If the first argument is omitted, a dictionary of all current keys and values
will be printed; all values are always plain strings without any
interpretation. If you need to specify a remote unit but want to see all
settings, use `-` for the first argument.

The environment variable `JUJU_REMOTE_UNIT` stores the default remote unit:

```bash
echo $JUJU_REMOTE_UNIT
 mongodb/2
```

Getting the settings of the default unit in the default relation is done with:

```no-highlight
relation-get
 username: jim
 password: "12345"
```

To get a specific setting from the default remote unit in the default relation
you would instead use:


```no-highlight
relation-get username
 jim
```

To get all settings from a particular remote unit in a particular relation you
specify them together with the command:

```no-highlight
relation-get -r database:7 - mongodb/5
 username: bob
 password: 2db673e81ffa264c
```

Note that `relation-get` produces results that are _consistent_ but not
necessarily _accurate_, in that you will always see settings that:

  - were accurate at some point in the reasonably recent past
  - are always the same within a single hook run, _except_ when inspecting the
    unit's own relation settings, in which case local changes from `relation-set`
    will be seen correctly.

You should never depend upon the presence of any given key in `relation-get`
output. Processing that depends on specific values (other than `private-address`)
should be restricted to [-changed](authors-charm-hooks.html#[name]-relation-changed)
hooks for the relevant unit, and the absence
of a remote unit's value should never be treated as an
[error](./authors-hook-errors.html) in the local unit.

In practice, it is common and encouraged for -relation-changed hooks to exit
early, without error, after inspecting `relation-get` output and determining it
to be inadequate; and for [all other hooks](authors-charm-hooks.html) to be
resilient in the face of missing keys, such that -relation-changed hooks will be
sufficient to complete all configuration that depends on remote unit settings.

Settings for remote units already known to have departed remain accessible for
the lifetime of the relation.

!!! Note: `relation-get` currently has a bug
[LP #1223339](https://bugs.launchpad.net/juju-core/+bug/1223339)
which allows units of the same service to see each other's
settings outside of a peer relation. Depending on this behaviour is inadvisable: if
you need to share settings between units of the same service, always use a peer
relation to do so, or your charm may fail unexpectedly when the bug is fixed.

### relation-list

`relation-list` outputs a list of all the related **units** for a relation
identifier. If not running in a relation hook context, `-r` needs to be
specified with a relation identifier similar to the`relation-get` and
`relation-set` commands.

Examples:

To show all remote units for the current relation identifier:

```no-highlight
relation-list
```

Which should return something similar to:

```no-highlight
mongodb/0
mongodb/2
mongodb/3
```
All remote units in a specific relation identifier can be shown with:

```no-highlight
relation-list -r website:2
 haproxy/0
```

### relation-ids

`relation-ids` outputs a list of the related **services** with a relation
name. Accepts a single argument (relation-name) which, in a relation hook,
defaults to the name of the current relation. The output is useful as input
to the `relation-list`, `relation-get`, and `relation-set` commands to read
or write other relation values.

Examples:

The current relation name is stored in the environment variable
`JUJU_RELATION`. All "server" relation identifiers can be shown with:

```no-highlight
relation-ids
server:1
server:7
server:9
```

To show all relation identifiers with a different name pass it as an argument:

```no-highlight
relation-ids reverseproxy
    reverseproxy:3
```

Note again that all commands that produce output accept `--format json` and
`--format yaml`, and you may consider it smarter to use those for clarity's
sake than to depend on the default `smart` format.

### relation-set

`relation-set` writes the local unit's settings for some relation. It accepts
any number of `key=value` strings, and an optional `-r` argument, which
defaults to the current relation identifier. If it's not running in a relation
hook, `-r` needs to be specified. The `value` part of an argument is not
inspected, and is stored directly as a string. Setting an empty string causes
the setting to be removed.

Examples:

Setting a pair of values for the local unit in the default relation identifier
which is stored in the environment variable `JUJU_RELATION_ID`:

```bash
echo $JUJU_RELATION_ID
server:3
```

The setting is done with:

```no-highlight
relation-set username=bob password=2db673e81ffa264c
```

To set the pair of values for the local unit in a specific relation specify the
relation identifier:

```no-highlight
relation-set -r server:3 username=jim password=12345
```

To clear a value for the local unit in the default relation enter:

```no-highlight
relation-set deprecated-or-unused=
```

`relation-set` is the single tool at your disposal for communicating your own
configuration to units of related services. At least by convention, the charm
that `provides` an interface is likely to set values, and a charm that
`requires` that interface will read them; but there's nothing forcing this.
Whatever information you need to propagate for the remote charm to work must be
propagated via relation-set, with the single exception of the `private-address`
key, which is always set before the unit joins.

For some charms you may wish to overwrite the `private-address` setting, for
example if you're writing a charm that serves as a proxy for some external
service. It is rarely a good idea to _remove_ that key though, as most charms
expect that value to exist unconditionally and may fail if it is not
present.

All values are set transactionally at the point when the hook terminates
successfully (i.e. the hook exit code is 0). At that point all changed values will
be communicated to the rest of the system, causing -changed hooks to run in
all related units.

There is no way to write settings for any unit other than the local unit. However,
any hook on the local unit can write settings for any relation which the local unit
is participating in.


### status-get

`status-get` allows charms to query what is recorded in Juju as
the current workload status. Without arguments, it just prints the workload
status value e.g. 'maintenance'. With `--include-data` specified, it prints
YAML which contains the status value plus any data associated with the status.

Examples:

```no-highlight
status-get
status-get --include-data
```


### status-set

`status-set` allows charms to describe their current status. This places the
responsibility on the charm to know its status, and set it accordingly using
the `status-set` hook tool.

This hook tool takes 2 arguments. The first is the status to report, which can
be one of the following:

  - maintenance (the unit is not currently providing a service, but expects to
    be soon, E.g. when first installing)
  - blocked (the unit cannot continue without user input)
  - waiting (the unit itself is not in error and requires no intervention,
    but it is not currently in service as it depends on some external factor,
    e.g. a service to which it is related is not running)
  - active (This unit believes it is correctly offering all the services it is
    primarily installed to provide)

For more extensive explanations of these statuses, and other possible status
values which may be set by Juju itself,
[please see the status reference page](./reference-status.html).

The second argument is a user-facing message, which will be displayed to any
users viewing the status, and will also be visible in the status history. This
can contain any useful information.

This status message provides valuable feedback to the user about what is
happening. Changes in the status message are not broadcast to peers and
counterpart units - they are for the benefit of humans only, so tools
representing Juju services (e.g. the Juju GUI) should check occasionally
and be told the current status message.

Spamming the status with many changes per second is therefore rather redundant
(and might be throttled by the state server). Nevertheless, a thoughtful charm
will provide appropriate and timely feedback for human users, with estimated
times of completion of long-running status changes.

In the case of a `blocked` status though the **status message should tell the
user explicitly how to unblock the unit** insofar as possible, as this is
primary way of indicating any action to be taken (and may be surfaced by other
tools using Juju, e.g. the Juju GUI).

A unit in the `active` state with should not generally expect anyone to look at
its status message, and often it is better not to set one at all. In the event
of a degradation of service, this is a good place to surface an explanation for
the degradation (load, hardware failure or other issue).

A unit in `error` state will have a message that is set by Juju and not the
charm because the error state represents a crash in a charm hook - an unmanaged
and uninterpretable situation. Juju will set the message to be a reflection of
the hook which crashed. For example “Crashed installing the software” for an
install hook crash, or “Crash establishing database link” for a crash in a
relationship hook.

Examples:

```no-highlight
status-set maintenance "installing software"
status-set maintenance "formatting storage space, time left: 120s"
status-set waiting "waiting for database"
status-set active
status-set active "Storage 95% full"
status-set blocked "Need a database relation"
status-set blocked "Storage full"
```

### storage-add

`storage-add` may be used to add storage to the unit.  The tool takes the name
of the storage (as in the charm metadata), and optionally the number of storage
instances to add; by default it will add a single storage instance of the name.

Examples:  

```no-highlight
storage-add data
storage-add block=4
```

### storage-get

`storage-get` may be used to obtain information about storage being attached to,
or detaching from, the unit. If the executing hook is a storage hook,
information about the storage related to the hook will be reported; this may be
overridden by specifying the name of the storage as reported by storage-list,
and must be specified for non-storage hooks.

storage-get should be used to identify the storage location during
storage-attached and storage-detaching hooks. The exception to this is when the
charm specifies a static location for singleton stores.

Examples:  

```no-highlight
storage-get -s data/0
kind: filesystem
location: /srv/data

storage-get -s data/0 --format json
{"kind":"filesystem","location":"/srv/data"}

storage-get -s data/0 location
/srv/data
```

### storage-list

`storage-list` may be used to list storage instances that are attached to the
unit. The storage instance identifiers returned from `storage-list` may be
passed through to the `storage-get` command using the -s flag.

Examples:  

```no-highlight
storage-list
data/0

storage-list --format json
["data/0"]
```

### unit-get

`unit-get` returns information about the local unit. It accepts a single
argument, which must be `private-address` or `public-address`. It is not
affected by context:  

```no-highlight
unit-get private-address
10.0.1.101
unit-get public-address
foo.example.com
```
