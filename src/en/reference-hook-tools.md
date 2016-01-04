Title: Hook tools

# Hook tools

Units deployed with juju have a suite of tooling available to them, called ‘hook
tools’. These commands provide the charm developer with a consistent interface
to take action on the units behalf, such as opening ports, obtaining
configuration, even determining which unit is the leader in a cluster. The
listed hook-tools are available in any hook running on the unit, and are only
available within ‘hook context’.

!!! Note: You can view a detailed listing of what each command listed below does
on your client with `juju help-tool {command}`. Or for more detailed help on
individual commands run the command with the -h flag.

!!! Note:  Many of the tools produce text based output, and those that do accept
a `--format` flag which can be set to json or yaml as desired.

## action-fail

`action-fail` sets the action's fail state with a given error message.  Using
`action-fail` without a failure message will set a default message indicating a
problem with the action. For more information about where you might use this
command, read more about [Juju Actions](actions.html) or
[how to write Juju Actions](developer-actions.html).

python:  
```python
from charmhelpers.core.hookenv import action_fail

action_fail(‘Unable to contact remote service’)
```
bash:  
```bash
action-fail ‘unable to contact remote service’
```


## action-get

`action-get` will print the value of the parameter at the given key, serialized
as YAML.  If multiple keys are passed, `action-get` will recurse into the param
map as needed. Read more about [Juju Actions](actions.html) or
[how to write Juju Actions](developer-actions.html).

python:  
```python
from charmhelpers.core.hookenv import action_get

timeout = action_get(‘timeout’)
```
bash:  
```bash
TIMEOUT=$(action-get timeout)
```


## action-set

`action-set` adds the given values to the results map of the
[Action](actions.html).  This map is returned to the user after the
completion of the Action.  Keys must start and end with lowercase alphanumeric,
and contain only lowercase alphanumeric, hyphens and periods.

python:  
```python
from charmhelpers.core.hookenv import action_set

action_set('com.juju.result', 'we are the champions')
```
bash:  
```bash
action-set com.juju.result 'we are the champions'
```


## close-port

`close-port` ensures a port or range is not accessible from the public
interface.

python:  
```python
from charmhelpers.core.hookenv import close_port

# Close a single port
close_port(80, protocol="UDP")
```
bash:  
```bash
# Close single port
close-port 80
# Close a range of ports
close-port 9000-9999/udp
```


## config-get

`config-get` returns information about the service configuration (as defined by
`config.yaml`). If called without arguments, it returns a dictionary containing
all config settings that are either explicitly set, or which have a non-nil
default value. If the `--all` flag is passed, it returns a dictionary containing
all defined config settings including nil values (for those without defaults).
If called with a single argument, it returns the value of that config key.
Missing config keys are reported as nulls, and do not return an error.

python:  
```python
from charmhelpers.core.hookenv import config

# Get all the configuration from charmhelpers as a dictionary.
cfg =config()
# Get the value for the "interval" key.
interval = cfg.get(‘interval’)
```
bash:  
```bash
INTERVAL=$(config-get interval)

config-get --all
```


## is-leader

`is-leader` will write `"True"` or `"False"` to stdout, and return 0, if
the unit is currently leader and can be guaranteed to remain so for 30
seconds. Output can be expressed as `--format json` or `--format yaml` if
desired.

python:  
```python
from charmhelpers.core.hookenv import is_leader

if is_leader():
    # Do something a leader would do
```
bash:  
```bash
LEADER=$(is-leader)
if [ "${LEADER}" == "True" ]; then
  # Do something a leader would do
fi
```


## juju-log

`juju-log` writes messages directly to the unit's log file. Valid
levels are: INFO, WARN, ERROR, DEBUG

python:  
```python
from charmhelpers.core.hookenv import juju_log

juju_log('Something has transpired', 'INFO')
```
bash:  
```bash
juju-log -l 'WARN' Something has transpired
```


## juju-reboot

`juju-reboot` causes the host machine to reboot, after stopping all containers
hosted on the machine.

An invocation without arguments will allow the current hook to complete, and
will only cause a reboot if the hook completes successfully.

If the `--now` flag is passed, the current hook will terminate immediately, and
be restarted from scratch after reboot. This allows charm authors to write
hooks that need to reboot more than once in the course of installing software.

The `--now` flag cannot terminate a debug-hooks session; hooks using `--now`
should be sure to terminate on unexpected errors, so as to guarantee expected
behavior in all situations.

`juju-reboot` is not supported when running actions.

python:  
```python
from subprocess import check_call

check_call(["juju-reboot", "--now"])
```
bash:  
```bash
# immediately reboot
juju-reboot --now

# Reboot after current hook exits
juju-reboot
```


## leader-get

`leader-get` prints the value of a leadership setting specified by key.  
`leader-get` acts much like [`relation-set`](#relation-set)) but only reads
from the leader settings. If no key is given, or if the key is "-", all keys
and values will be printed.

python:  
```python
from charmhelpers.core.hookenv import leader_get

address = leader_get('cluster-leader-address')
```
bash:  
```bash
ADDRESSS=$(leader-get cluster-leader-address)
```


## leader-set

`leader-set` immediately writes the key/value pairs to the juju controller,
which will then inform non-leader units of the change. It will fail if called
without arguments, or if called by a unit that is not currently service leader.

`leader-set` lets you write string key=value pairs, but with the following
differences:

- there's only one leader-settings bucket per service (not one per unit)
- only the leader can write to the bucket
- only minions are informed of changes to the bucket
- changes are propagated instantly

The instant propagation may be surprising, but it exists to satisfy the use case
where shared data can be chosen by the leader at the very beginning of the
install hook.

It is strongly recommended that leader settings are always written as a
self-consistent group `leader-set one=one two=two three=three`.

python:  
```python
from charmhelpers.core.hookenv import leader_set

leader_set('cluster-leader-address', "10.0.0.123")
```
bash:  
```bash
leader-set cluster-leader-address=10.0.0.123
```


## opened-ports

`opened-ports` lists all ports or ranges opened by the **unit**. The
opened-ports hook tool lists all the ports currently opened **by the running
charm**. It does not, at the moment, include ports which may be opened by other
charms co-hosted on the same machine
[lp#1427770](https://bugs.launchpad.net/juju-core/+bug/1427770).

!!! Note: opening ports is transactional (i.e. will take place on successfully
exiting the current hook), and therefore `opened-ports` will not return any
values for pending `open-port` operations run from within the same hook.

python:  
```python
from subprocess import check_output

range = check_output(["opened-ports"])
```
bash:  
```bash
opened-ports
```


## open-port

`open-port` registers a port or range to open on the public-interface. On public
clouds the port will only be open while the service is exposed. It accepts a
single port or range of ports with an optional protocol, which may be `udp` or
`tcp`, where `tcp` is the default.

`open-port` will not have any effect if the service is not exposed, and may have
a somewhat delayed effect even if it is. This operation is transactional, so
changes will not be made unless the hook exits successfully.

python:  
```python
from charmhelpers.core.hookenv import open_port

open_port(80, protocol='TCP')
```
bash:  
```bash
open-port 80/tcp

open-port 1234/udp
```


## payload-register

`payload-register` used while a hook is running to let Juju know that a
payload has been started. The information used to start the payload must be
provided when "register" is run.

The payload class must correspond to one of the payloads defined in
the charm's metadata.yaml.

python:  
```python
from subprocess import check_call

check_call(["payload-register", "monitoring", "docker", "0fcgaba"])
```
bash:  
```bash
payload-register monitoring docker 0fcgaba
```


## payload-unregister

`payload-unregister` used while a hook is running to let Juju know
that a payload has been manually stopped. The `class` and `id` provided
must match a payload that has been previously registered with juju using
payload-register.

python:  
```python
from subprocess import check_call

check_call(["payload-unregister", "monitoring", "0fcgaba"])
```
bash:  
```bash
payload-unregister monitoring 0fcgaba
```


## relation-get

`relation-get` reads the settings of the local unit, or of any remote unit,
in a given relation (set with `-r`, defaulting to the current relation
identifier, as in `relation-set`). The first argument specifies the settings
key, and the second the remote unit, which may be omitted if a default is
available (that is, when running a relation hook other than
[-relation-broken](authors-charm-hooks.html#[name]-relation-broken)).

If the first argument is omitted, a dictionary of all current keys and values
will be printed; all values are always plain strings without any
interpretation. If you need to specify a remote unit but want to see all
settings, use `-` for the first argument.

The environment variable
[`JUJU_REMOTE_UNIT`](reference-environment-variables.html#juju-remote-unit)
stores the default remote unit.

You should never depend upon the presence of any given key in `relation-get`
output. Processing that depends on specific values (other than `private-address`)
should be restricted to
[-relation-changed](authors-charm-hooks.html#[name]-relation-changed) hooks for
the relevant unit, and the absence of a remote unit's value should never be
treated as an [error](./authors-hook-errors.html) in the local unit.

In practice, it is common and encouraged for
[-relation-changed](authors-charm-hooks.html#[name]-relation-changed) hooks to
exit early, without error, after inspecting `relation-get` output and
determining the data is inadequate; and for
[all other hooks](authors-charm-hooks.html) to be resilient in the face of
missing keys, such that -relation-changed hooks will be sufficient to complete
all configuration that depends on remote unit settings.

Key value pairs for remote units that have departed remain accessible for the
lifetime of the relation.

python:
```python
from charmhelpers.core.hookenv import relation_get

# Since we define the relation id on every call to relation_get, both bash
# examples look like the line below
relation_get(rel_id)

# To get a specific setting from the remote unit in the specified relation
relation_get(rel_id, 'username')
```
bash:
```bash
# Getting the settings of the default unit in the default relation is done with:
 relation-get
  username: jim
  password: "12345"

# To get a specific setting from the default remote unit in the default relation
  relation-get username
   jim

# To get all settings from a particular remote unit in a particular relation you
   relation-get -r database:7 - mongodb/5
    username: bob
    password: 2db673e81ffa264c
```

## relation-ids

`relation-ids` outputs a list of the related **services** with a relation
name. Accepts a single argument (relation-name) which, in a relation hook,
defaults to the name of the current relation. The output is useful as input
to the `relation-list`, `relation-get`, and `relation-set` commands to read
or write other relation values.

python:  
```python
from charmhelpers.core.hookenv import relation_ids

relation_ids('database')
```
bash:  
```bash
relation-ids database
```


## relation-list

`relation-list` outputs a list of all the related **units** for a relation
identifier. If not running in a relation hook context, `-r` needs to be
specified with a relation identifier similar to the`relation-get` and
`relation-set` commands.

python:  
```python
from charmhelpers.core.hookenv import relation_list
from charmhelpers.core.hookenv import relation_id

# List the units on a relation for the given relation id.
related_units = relation_list(relation_id())
```
bash:  
```bash
relation-list 9

relation-list -r website:2
```


## relation-set

`relation-set` writes the local unit's settings for some relation. If it's not
running in a relation hook, `-r` needs to be specified. The `value` part of an
argument is not inspected, and is stored directly as a string. Setting an empty
string causes the setting to be removed.

`relation-set` is the tool for communicating information between
units of related services. By convention the charm that `provides` an
interface is likely to set values, and a charm that `requires` that interface
will read values; but there is nothing enforcing this. Whatever information you
need to propagate for the remote charm to work must be propagated via
relation-set, with the single exception of the `private-address` key, which is
always set before the unit joins.

For some charms you may wish to overwrite the `private-address` setting, for
example if you're writing a charm that serves as a proxy for some external
service. It is rarely a good idea to _remove_ that key though, as most charms
expect that value to exist unconditionally and may fail if it is not
present.

All values are set in a
[transaction](https://en.wikipedia.org/wiki/Transaction_processing) at the
point when the hook terminates successfully (i.e. the hook exit code is 0). At
that point all changed values will be communicated to the rest of the system,
causing -changed hooks to run in all related units.

There is no way to write settings for any unit other than the local unit.
However, any hook on the local unit can write settings for any relation which
the local unit is participating in.

python:  
```python
from charmhelpers.core.hookenv import relation_set

relation_set({'port': 80, 'tuning': 'default'})
```
bash:  
```bash
relation-set port=80 tuning=default

relation-set -r server:3 username=jim password=12345
```


## status-get

`status-get` allows charms to query what is recorded in Juju as
the current workload status. Without arguments, it just prints the workload
status value e.g. 'maintenance'. With `--include-data` specified, it prints
YAML which contains the status value plus any data associated with the status.

python:  
```python
from charmhelpers.core.hookenv import status_get

charm_status = status_get()
```
bash:  
```bash
status-get

status-get --include-data
```


## status-set

`status-set` allows charms to describe their current status. This places the
responsibility on the charm to know its status, and set it accordingly using
the `status-set` hook tool.

This hook tool takes 2 arguments. The first is the status to report, which can
be one of the following:

- `maintenance` (the unit is not currently providing a service, but expects to
  be soon, E.g. when first installing)
- `blocked` (the unit cannot continue without user input)
- `waiting` (the unit itself is not in error and requires no intervention,
  but it is not currently in service as it depends on some external factor,
  e.g. a service to which it is related is not running)
- `active` (This unit believes it is correctly offering all the services it is
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

python:  
```python
from charmhelpers.core.hookenv import status_set

status_set('blocked', 'Unable to continue until related to a database')
```
bash:  
```bash
status-set maintenance "installing software"
status-set maintenance "formatting storage space, time left: 120s"
status-set waiting "waiting for database"
status-set active
status-set active "Storage 95% full"
status-set blocked "Need a database relation"
status-set blocked "Storage full"
```


## storage-add

`storage-add` may be used to add storage to the **unit**.  The tool takes the
name of the storage (as defined in the charm metadata), and optionally the
number of storage instances to add; by default it will add a single storage
instance of the name.

python:  
```python
from subprocess import check_call

check_call(["storage-add", "database-storage=1"])
```
bash:  
```bash
storage-add database-storage=1
```


## storage-get

`storage-get` may be used to obtain information about storage being attached to,
or detaching from, the unit. If the executing hook is a storage hook,
information about the storage related to the hook will be reported; this may be
overridden by specifying the name of the storage as reported by storage-list,
and must be specified for non-storage hooks.

storage-get should be used to identify the storage location during
storage-attached and storage-detaching hooks. The exception to this is when the
charm specifies a static location for singleton stores.

python:  
```python
from subprocess import check_call

check_call(["storage-get", "21127934-8986-11e5-af63-feff819cdc9f"])
```
bash:
```bash
storage-get 21127934-8986-11e5-af63-feff819cdc9f

storage-get -s data/0
```


## storage-list

`storage-list` may be used to list storage instances that are attached to the
unit. The storage instance identifiers returned from `storage-list` may be
passed through to the `storage-get` command using the -s flag.

python:  
```python
from subprocess import check_output

storage = check_output(["storage-list"])
```
bash:  
```bash
storage-list
```


## unit-get

`unit-get` returns information about the local **unit**. It accepts a single
argument, which must be `private-address` or `public-address`. It is not
affected by context.

python:  
```python
from charmhelpers.core.hookenv import unit_get

address = unit_get('public-address')
```
bash:  
```bash
unit-get public-address
```
