<div data-theme-toc="true">

</div><!--
Todo:
- rationalise with /t/the-hook-environment-hook-tools-and-how-hooks-are-run/1047 and /t/writing-your-first-juju-charm/1046
-->

Units deployed with Juju have a suite of tooling available to them, called ‘hook tools’. These commands provide the charm developer with a consistent interface to take action on the units behalf, such as opening ports, obtaining configuration, even determining which unit is the leader in a cluster. The listed hook-tools are available in any hook running on the unit, and are only available within ‘hook context’.

Many of the tools produce text based output, and those that do accept a `--format` flag which can be set to JSON or YAML as desired.

[note]
You can view a detailed listing of what each command listed below does on your client with `juju help-tool {command}`. Or for more detailed help on individual commands run the command with the -h flag.
[/note]

## Informational


<h3 id="heading--status-get">status-get</h3>

`status-get` allows charms to query the current workload status. 

[details="Further information"]
Without arguments, it just prints the status code e.g. 'maintenance'. With `--include-data` specified, it prints YAML which contains the status value plus any data associated with the status.

Include the `--application` option to get the overall status for the application, rather than an individual unit.
[/details]

Examples for accessing the unit's status:
[details="From Python"]

``` python
from charmhelpers.core.hookenv import status_get

charm_status = status_get()
```
[/details]

[details="From bash"]

``` text
status-get

status-get --include-data
```
[/details]

Examples for accessing the application's status:

[details="From bash"]

``` text
status-get --application
```
[/details]

<h3 id="heading--status-set">status-set</h3>

`status-set` changes what is displayed in `juju status`. 

[details="Further details"]
`status-set` allows charms to describe their current status. This places the responsibility on the charm to know its status, and set it accordingly using the `status-set` hook tool. Changes made via `status-set` are applied without waiting for a hook execution to end and are not rolled back if a hook execution fails.

The leader unit is responsible for setting the overall status of the application by using the `--application` option.

This hook tool takes 2 arguments. The first is the status code and the second is a message to report to the user.

Valid status codes are:

-   `maintenance` (the unit is not currently providing a service, but expects to be soon, e.g. when first installing)
-   `blocked` (the unit cannot continue without user input)
-   `waiting` (the unit itself is not in error and requires no intervention, but it is not currently in service as it depends on some external factor, e.g. an application to which it is related is not running)
-   `active` (This unit believes it is correctly offering all the services it is primarily installed to provide)

For more extensive explanations of these status codes, [please see the status reference page](/t/charm-unit-status-and-their-meanings/1168).

The second argument is a user-facing message, which will be displayed to any users viewing the status, and will also be visible in the status history. This can contain any useful information.

In the case of a `blocked` status though the **status message should tell the user explicitly how to unblock the unit** insofar as possible, as this is primary way of indicating any action to be taken (and may be surfaced by other tools using Juju, e.g. the Juju GUI).

A unit in the `active` state with should not generally expect anyone to look at its status message, and often it is better not to set one at all. In the event of a degradation of service, this is a good place to surface an explanation for the degradation (load, hardware failure or other issue).

A unit in `error` state will have a message that is set by Juju and not the charm because the error state represents a crash in a charm hook - an unmanaged and uninterpretable situation. Juju will set the message to be a reflection of the hook which crashed. For example “Crashed installing the software” for an install hook crash, or “Crash establishing database link” for a crash in a relationship hook.

[/details]

Examples for setting the unit's status:

[details="From Python"]

#### With the [`charmhelpers` package](https://charm-helpers.readthedocs.io/en/latest/api/charmhelpers.core.hookenv.html#charmhelpers.core.hookenv.status_set)

Set the unit's status to blocked:

``` python
from charmhelpers.core.hookenv import status_set

status_set('blocked', 'Unable to continue until related to a database')
```

#### With the standard library

Set the unit's status to blocked:

``` python
from subprocess import call

call(['status-set', 'blocked', 'Add a db relation'])
```
[/details]


[details="From bash"]
```bash
# Set the unit's workload status to "maintenance".
# This implies a short downtime that should self-resolve.
status-set maintenance "installing software"
status-set maintenance "formatting storage space, time left: 120s"

# Set the unit's workload status to "waiting"
# The workload is awaiting something else in the model to become active 
status-set waiting "waiting for database"

# Set the unit workload's status to "active"
# The workload is installed and running. Any messages should be informational. 
status-set active
status-set active "Storage 95% full"

# Set the unit's workload status to "blocked"
# This implies human intervention is required to unblock the unit.
# Messages should describe what is needed to resolve the problem.
status-set blocked "Add a database relation"
status-set blocked "Storage full"
```
[/details]

Examples for setting the application's status:

[details="From Python"]
Set the application's status to active:

```python
from charmhelpers.core.hookenv import status_set

status_set('active', application_status=True)
```


Set the application's status to blocked:

```python
from subprocess import call

call(['status-set', '--application', 'blocked', 'Application upgrade underway'])
```

[/details]

[details="From bash"]
```bash
# From a unit, update its status
status-set maintenance "Upgrading to 4.1.1"

# From the leader, update the application's status line 
status-set --application maintenance "Application upgrade underway"
```

Non-leader units which attempt to use `--application` will receive an error

``` text
status-set --application maintenance "I'm not the leader."
error: this unit is not the leader
```
[/details]


<h3 id="heading--application-version-set">application-version-set</h3>

`application-version-set` allows you to specify which version of the application is deployed. This will be provided to users via `juju status`.

[details="From Python"]

With the [charmhelpers package][]: 

```python
from charmhelpers.core.hookenv import application_version_set

application_version_set('1.1.10')
```

With the standard library:

```python
from subprocess import call

call(["application-version-set", "1.1.10"])
```
[/details]

[details=From bash]
```bash
application-version-set 1.1.10
```
[/details]
<!--
```bash
@hook 'update-status'
function update_status() {
    application-version-set 1.1.10
}
```
-->
<h3 id="heading--juju-log">juju-log</h3>

`juju-log` writes messages directly to the unit's log file. Valid levels are: INFO, WARN, ERROR, DEBUG

Examples

[details="From Python"]

``` python
from charmhelpers.core.hookenv import log

log('Something has transpired', 'INFO')
```
[/details]

[details="From bash"]

```bash
juju-log -l 'WARN' Something has transpired
```
[/details]

[details="From PowerShell"]

```powershell
Import-Module CharmHelpers

# Basic logging
Write-JujuLog "Something has transpired"

# Logs the message and throws an error, stopping the script
Write-JujuError "Something has transpired. Throwing an error..."
```
[/details]


## Actions

<h3 id="heading--action-fail">action-fail</h2>

`action-fail` sets the action's fail state with a given error message. Using `action-fail` without a failure message will set a default message indicating a problem with the action. For more information about where you might use this command, read more about [Juju Actions](/t/working-with-actions/1033) or [how to write Juju Actions](/t/actions-for-the-charm-author/1113).


[details="From Python"]
With the standard library:

```python
from subprocess import call

call(["action-fail", "Unable to contact remote service"])
```

With the [charmhelpers package][]:

```python
from charmhelpers.core.hookenv import action_fail

action_fail("Unable to contact remote service")
```
[/details]

[details="From bash"]

``` bash
action-fail 'unable to contact remote service'
```
[/details]

<h3 id="heading--action-get">action-get</h2>

`action-get` will print the value of the parameter at the given key, serialized as YAML. If multiple keys are passed, `action-get` will recurse into the param map as needed. Read more about [Juju Actions](/t/working-with-actions/1033) or [how to write Juju Actions](/t/actions-for-the-charm-author/1113).


[details="From Python"]
With the standard library:

```python
from subprocess import call

call(["action-get", "timeout"])
```

With the [charmhelpers package][]:

``` python
from charmhelpers.core.hookenv import action_get

timeout = action_get(‘timeout’)
```
[/details]

[details="From bash"]

```bash
TIMEOUT=$(action-get timeout)
```
[/details]

<h3 id="heading--action-set">action-set</h2>

`action-set` adds the given values to the results map of the [Action](/t/working-with-actions/1033). This map is returned to the user after the completion of the Action. Keys must start and end with lowercase alphanumeric, and contain only lowercase alphanumeric, hyphens and periods.


[details="From Python"]
With the standard library:

```python
from subprocess import call

call(["action-set", "answer", "42"]) 
```

With the [charmhelpers package][]:

``` python
from charmhelpers.core.hookenv import action_set

action_set('answer', '42')
```
[/details]

[details="From bash"]

```bash
action-set answer 42
```
[/details]

## Metrics

<h3 id="heading--add-metric">add-metric</h3>

[note]
`add-metric` may only be executed from the [`collect-metrics`](/t/charm-hooks/1040#heading--collect-metrics) hook.
[/note]

Records a measurement which will be forwarded to the Juju controller. The same metric may not be collected twice in the same command.

[details="From Python"]
With the standard library:

```python
from subprocess import call

call(["add-metric", f"metric1={value1}"]) 
```
With the [`charmhelpers` package](https://charm-helpers.readthedocs.io/en/latest/api/charmhelpers.core.hookenv.html#charmhelpers.core.hookenv.add_metric):

```python
from charmhelpers.core.hookenv import add_metric

add_metric(answer='42')
```
[/details]

[details="From bash"]

```bash
add-metric metric1=value1 [metric2=value2 …]
```
[/details]

## Networking

<h3 id="heading--network-get">network-get</h3>

`network-get` reports hostnames, IP addresses and CIDR blocks related to endpoint bindings.

[details="Further details"]
By default it lists three pieces of address information:

-   binding address(es)
-   ingress address(es)
-   egress subnets

See [Network primitives](/t/charm-network-primitives/1126) for in-depth coverage.
[/details]

<h3 id="heading--open-port">open-port</h3>

`open-port` registers a port or range to open on the public-interface.

[details="Further details"]
On public clouds the port will only be open while the application is exposed. It accepts a single port or range of ports with an optional protocol, which may be `icmp`, `udp`, or `tcp`. `tcp` is the default.

`open-port` will not have any effect if the application is not exposed, and may have a somewhat delayed effect even if it is. This operation is transactional, so changes will not be made unless the hook exits successfully.
[/details]

Examples

[details="From Python"]

``` python
from charmhelpers.core.hookenv import open_port

open_port(80, protocol='TCP')
```
[/details]

[details="From bash"]

Open port 80 to TCP traffic:
```bash
open-port 80/tcp
```
Open port 1234 to UDP traffic:
```bash
open-port 1234/udp

Open a range of ports to UDP traffic:
```bash
open-port 1000-2000/udp
```



<h3 id="heading--close-port">close-port</h3>

`close-port` ensures a port, or port range, is not accessible from the public interface.

[details=From Python]
``` python
from charmhelpers.core.hookenv import close_port

# Close a single port to TCP traffic
close_port(80)

# Close a port range
close_port("9000-9999", "UDP")

# Disable ICMP
close_port(None, "ICMP")
```
[/details]

[details=From bash]

``` text
# Close single port
close-port 80

# Close a range of ports
close-port 9000-9999/udp

# Disable ICMP
close-port icmp
```
[/details]

[details="From PowerShell"]

``` powershell
Import-Module CharmHelpers

# Close a single port
Close-JujuPort "80/TCP"

# Close a range of ports
Close-JujuPort "1000-2000/UDP"

# Disable ICMP
Close-Port "ICMP"
```
[/details]

<h3 id="heading--unit-get">unit-get</h3>

[note type="caution"]
`unit-get` is deprecated in favour of `network-get` hook tool. See [Network primitives](/t/charm-network-primitives/1126) for details.
[/note]

`unit-get` returns the IP address of the unit. 

[details="Further details"]
It accepts a single argument, which must be `private-address` or `public-address`. It is not affected by context.

Note that if a unit has been deployed with `--bind space` then the address returned from `unit-get private-address` will get the address from this space, not the 'default' space.
[/details]

Examples:

[details="From Python"]
```python
from charmhelpers.core.hookenv import unit_get

public_address = unit_get('public-address')
private_address = unit_get('private-address')
```
[/details]

[details="From bash"]

``` text
unit-get public-address
```
[/details]

[details="From PowerShell"]

```powershell
Import-Module CharmHelpers
Get-JujuUnit -Attr "public-address"
```
[/details]



## Configuration

<h3 id="heading--config-get">config-get</h3>

`config-get` returns information about the application configuration (as defined by `config.yaml`). If called without arguments, it returns a dictionary containing all config settings that are either explicitly set, or which have a non-nil default value. If the `--all` flag is passed, it returns a dictionary containing all defined config settings including nil values (for those without defaults). If called with a single argument, it returns the value of that config key. Missing config keys are reported as nulls, and do not return an error.

[details=From Python]

``` python
from charmhelpers.core.hookenv import config

# Get all the configuration for the application
cfg = config()

# Get the value for the "interval" key
interval = config(‘interval’)
```
[/details]

[details=From bash]

``` text
INTERVAL=$(config-get interval)

config-get --all
```
[/details]

[details=From PowerShell]

```powershell
Import-Module CharmHelpers
$interval = Get-JujuCharmConfig "interval"
```
[/details]

<h2 id="heading--goal-state">goal-state</h2>

`goal-state` queries information about charm deployment and returns it as structured data.

[details=Further details]

`goal-state` provides:

-   the details of other peer units have been deployed and their status
-   the details of remote units on the other end of each endpoint and their status

The output will be a subset of that produced by the `juju status`. There will be output for sibling (peer) units and relation state per unit.

The unit status values are the workload status of the (sibling) peer units. We also use a unit status value of dying when the unit's life becomes dying. Thus unit status is one of:

`allocating`
`active`
`waiting`
`blocked`
`error`
`dying`

The relation status values are determined per unit and depend on whether the unit has entered or left scope. The possible values are:

- `joining` : a relation has been created, but no units are available. This occurs when the application on the other side of the relation is added to a model, but the machine hosting the first unit has not yet been provisioned. Calling `relation-set` will work correctly as that data will be passed through to the unit when it comes online, but `relation-get` will not provide any data.
- `joined` : the relation is active. A unit has entered scope and is accessible to this one.
- `broken` : unit has left, or is preparing to leave scope. Calling `relation-get` is not advised as the data will quickly out of date when the unit leaves.
- `suspended` : parent cross model relation is suspended
- `error`: an external error has been detected

By reporting error state, the charm has a chance to determine that goal state may not be reached due to some external cause. As with status, we will report the time since the status changed to allow the charm to empirically guess that a peer may have become stuck if it has not yet reached active state.

[/details]

Examples

[details=From Python]
With the [charmhelpers package][], one interacts with `goal-state` indirectly:

```python
from charmhelpers.core.hookenv import expected_peer_units

peers = expected_peer_units()
```

```python
from charmhelpers.core.hookenv import expected_related_units

expected_related_units() 
```

With the standard library:
```python
from subprocess import call

call([goal-state])
```
[/details]

[details=From bash]
```bash
goal-state
```
[/details]


<h2 id="heading--is-leader">is-leader</h2>

`is-leader` indicates whether the current unit is the application leader.

[details="Further details"]
`is-leader`will write `"True"` to STDOUT and return 0 if the unit is currently leader and can be guaranteed to remain so for 30 seconds.

Output can be expressed as `--format json` or `--format yaml` if desired.
[/details]

Examples

[details="From Python"]
```python
from charmhelpers.core.hookenv import is_leader

if is_leader():
    # Do something a leader would do
```
[/details]

[details="From bash"]
```bash
LEADER=$(is-leader)
if [ "${LEADER}" == "True" ]; then
  # Do something a leader would do
fi
```
[/details]

[details="From PowerShell"]

```powershell
Import-Module CharmHelpers
if (Is-Leader) {
    # Do something a leader would do
}
```
[/details]

## Affecting the machine

<h3 id="heading--juju-reboot">juju-reboot</h3>

[note]
`juju-reboot` is not supported within actions
[/note]

`juju-reboot` causes the host machine to reboot, after stopping all containers hosted on the machine.

[details=Further details]
An invocation without arguments will allow the current hook to complete, and will only cause a reboot if the hook completes successfully.

If the `--now` flag is passed, the current hook will terminate immediately, and be restarted from scratch after reboot. This allows charm authors to write hooks that need to reboot more than once in the course of installing software.

The `--now` flag cannot terminate a debug-hooks session; hooks using `--now` should be sure to terminate on unexpected errors, so as to guarantee expected behavior in all situations.
[/details]

Examples:

[details="From Python]

``` python
from subprocess import check_call

check_call(["juju-reboot", "--now"])
```
[/details]

[details=From bash]

``` text
# immediately reboot
juju-reboot --now

# Reboot after current hook exits
juju-reboot
```
[/details]
[details From PowerShell]

``` powershell
Import-Module CharmHelpers

# immediately reboot
ExitFrom-JujuHook -WithReboot
```
[/details]

## Relations

<h3 id="heading--leader-get">leader-get</h3>

`leader-get` prints the value of a leadership setting specified.

[details="Further details"]
 `leader-get` acts much like [`relation-get`](#heading--relation-get)) but only reads from the leader settings. If no key is given, or if the key is "-", all keys and values will be printed.
[/details]

Examples:

[details="From Python"]

``` python
from charmhelpers.core.hookenv import leader_get

address = leader_get('cluster-leader-address')
```
[/details]
[details="From bash"]

``` text
ADDRESSS=$(leader-get cluster-leader-address)
```
[/details]

[details="From PowerShell"]

```powershell
Import-Module CharmHelpers
$clusterLeaderAddress = Get-LeaderData "cluster-leader-address"
```
[/details]

<h3 id="heading--leader-set">leader-set</h3>

[note]
The functionality provided by leader data (`leader-get` and `leader-set`) is now being replaced by "application-level relation data". See [`relation-get`](#heading--relation-get) and [`relation-set`](#heading--relation-set). 
[/note]

`leader-set` immediately writes key/value pairs to the Juju controller. The controller will then propagate that data to other units via `leader-get`. 

[details="Further data"]
The hook tool will fail if called without arguments, or if called by a unit that is not currently application leader.

`leader-set` lets you distribute string key=value pairs to other units, but with the following differences:

-   there's only one leader-settings bucket per application (not one per unit)
-   only the leader can write to the bucket
-   only minions are informed of changes to the bucket
-   changes are propagated instantly

The instant propagation may be surprising, but it exists to satisfy the use case where shared data can be chosen by the leader at the very beginning of the install hook.

It is strongly recommended that leader settings are always written as a self-consistent group `leader-set one=one two=two three=three`.
[/details]

Examples:
[details="From Python"]
``` python
from charmhelpers.core.hookenv import leader_set

leader_set('cluster-leader-address', "10.0.0.123")
```
[/details]

[details="From bash"]

```bash
leader-set cluster-leader-address=10.0.0.123
```
[/details]

[details = "From PowerShell"]:

```powershell
Import-Module CharmHelpers

Set-LeaderData @{"cluster-leader-address"="10.0.0.123"}
```
[/details]

<h3 id="heading--opened-ports">opened-ports</h3>

`opened-ports` lists all ports or ranges opened by the **unit**. The opened-ports hook tool lists all the ports currently opened **by the running charm**. It does not, at the moment, include ports which may be opened by other charms co-hosted on the same machine [lp#1427770](https://bugs.launchpad.net/juju-core/+bug/1427770).

[note]
Opening ports is transactional (i.e. will take place on successfully exiting the current hook), and therefore `opened-ports` will not return any values for pending `open-port` operations run from within the same hook.
[/note]

python:

``` python
from subprocess import check_output

range = check_output(["opened-ports"])
```

bash:

``` text
opened-ports
```

## Relations


<h3 id="heading--relation-get">relation-get</h3>

`relation-get` reads the settings of the local unit, or of any remote unit, in a given relation (set with `-r`, defaulting to the current relation identifier, as in `relation-set`). The first argument specifies the settings key, and the second the remote unit, which may be omitted if a default is available (that is, when running a relation hook other than [-relation-broken](/t/charm-hooks/1040#%5Bname%5D-relation-broken)).

If the first argument is omitted, a dictionary of all current keys and values will be printed; all values are always plain strings without any interpretation. If you need to specify a remote unit but want to see all settings, use `-` for the first argument.

The environment variable [`JUJU_REMOTE_UNIT`](/t/juju-environment-variables/1162#heading--juju_remote_unit) stores the default remote unit.

You should never depend upon the presence of any given key in `relation-get` output. Processing that depends on specific values (other than `private-address`) should be restricted to [-relation-changed](/t/charm-hooks/1040#%5Bname%5D-relation-changed) hooks for the relevant unit, and the absence of a remote unit's value should never be treated as an [error](/t/dealing-with-errors-encountered-by-charm-hooks/1048) in the local unit.

In practice, it is common and encouraged for [-relation-changed](/t/charm-hooks/1040#%5Bname%5D-relation-changed) hooks to exit early, without error, after inspecting `relation-get` output and determining the data is inadequate; and for [all other hooks](/t/charm-hooks/1040) to be resilient in the face of missing keys, such that -relation-changed hooks will be sufficient to complete all configuration that depends on remote unit settings.

Key value pairs for remote units that have departed remain accessible for the lifetime of the relation.

python:

``` python
from charmhelpers.core.hookenv import relation_get

# Since we define the relation id on every call to relation_get, both bash
# examples look like the line below
relation_get(rel_id)

# To get a specific setting from the remote unit in the specified relation
relation_get(rel_id, 'username')
```

bash:

``` text
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

<h3 id="heading--relation-ids">relation-ids</h3>

`relation-ids` outputs a list of the related **applications** with a relation name. Accepts a single argument (relation-name) which, in a relation hook, defaults to the name of the current relation. The output is useful as input to the `relation-list`, `relation-get`, and `relation-set` commands to read or write other relation values.

python:

``` python
from charmhelpers.core.hookenv import relation_ids

relation_ids('database')
```

bash:

``` text
relation-ids database
```

powershell:

``` powershell
Import-Module CharmHelpers
Get-JujuRelationIds -RelType "database"
```

<h3 id="heading--relation-list">relation-list</h3>

`relation-list` outputs a list of all the related **units** for a relation identifier. If not running in a relation hook context, `-r` needs to be specified with a relation identifier similar to the`relation-get` and `relation-set` commands.

python:

``` python
from charmhelpers.core.hookenv import relation_list
from charmhelpers.core.hookenv import relation_id

# List the units on a relation for the given relation id.
related_units = relation_list(relation_id())
```

bash:

``` text
relation-list 9
```

powershell:

``` powershell
Import-Module CharmHelpers
Get-JujuRelatedUnits -RelId (Get-JujuRelationId)
```

<h3 id="heading--relation-set">relation-set</h3>

`relation-set` writes the local unit's settings for some relation. If it's not running in a relation hook, `-r` needs to be specified. The `value` part of an argument is not inspected, and is stored directly as a string. Setting an empty string causes the setting to be removed.

`relation-set` is the tool for communicating information between units of related applications. By convention the charm that `provides` an interface is likely to set values, and a charm that `requires` that interface will read values; but there is nothing enforcing this. Whatever information you need to propagate for the remote charm to work must be propagated via relation-set, with the single exception of the `private-address` key, which is always set before the unit joins.

For some charms you may wish to overwrite the `private-address` setting, for example if you're writing a charm that serves as a proxy for some external application. It is rarely a good idea to *remove* that key though, as most charms expect that value to exist unconditionally and may fail if it is not present.

All values are set in a [transaction](https://en.wikipedia.org/wiki/Transaction_processing) at the point when the hook terminates successfully (i.e. the hook exit code is 0). At that point all changed values will be communicated to the rest of the system, causing -changed hooks to run in all related units.

There is no way to write settings for any unit other than the local unit. However, any hook on the local unit can write settings for any relation which the local unit is participating in.

python:

``` python
from charmhelpers.core.hookenv import relation_set

relation_set({'port': 80, 'tuning': 'default'})
```

bash:

``` text
relation-set port=80 tuning=default

relation-set -r server:3 username=jim password=12345
```

<h3 id="heading--resource-get">resource-get</h3>

`resource-get` fetches a resource from the Juju controller or the Juju Charm store. The command returns a local path to the file for a named resource.

If `resource-get` has not been run for the named resource previously, then the resource is downloaded from the controller at the revision associated with the unit's application. That file is stored in the unit's local cache. If `resource-get` *has* been run before then each subsequent run synchronizes the resource with the controller. This ensures that the revision of the unit-local copy of the resource matches the revision of the resource associated with the unit's application.

The path provided by `resource-get` references the up-to-date file for the resource. Note that the resource may get updated on the controller for the application at any time, meaning the cached copy *may* be out of date at any time after `resource-get` is called. Consequently, the command should be run at every point where it is critical for the resource be up to date.

``` sh
# resource-get software
/var/lib/juju/agents/unit-resources-example-0/resources/software/software.zip
```

## Storage

<h3 id="heading--storage-add">storage-add</h3>

`storage-add` adds storage volumes to the unit.

[details="Further details"]
`storage-add` takes the name of the storage volume (as defined in the charm metadata), and optionally the number of storage instances to add. By default, it will add a single storage instance of the name.
[/details]

Examples:

[details="From Python"]

``` python
from subprocess import check_call

check_call(["storage-add", "database-storage=1"])
```
[/details]

[details="From bash"]
``` text
storage-add database-storage=1
```
[/details]


<h3 id="heading--storage-get">storage-get</h3>

`storage-get` obtains information about storage being attached to, or detaching from, the unit. 

[details="Further details"]
If the executing hook is a storage hook, information about the storage related to the hook will be reported; this may be overridden by specifying the name of the storage as reported by storage-list, and must be specified for non-storage hooks.

`storage-get` can be used to identify the storage location during storage-attached and storage-detaching hooks. The exception to this is when the charm specifies a static location for singleton stores.
[/details]

Examples:

[details="From Python"]
``` python
from subprocess import check_call

check_call(["storage-get", "21127934-8986-11e5-af63-feff819cdc9f"])
```
[/details]
[details="From bash"]

```bash
# retrieve information by UUID
storage-get 21127934-8986-11e5-af63-feff819cdc9f

# retrieve information by name
storage-get -s data/0
```
[/details]

<h3 id="heading--storage-list">storage-list</h3>

`storage-list` list storages instances that are attached to the unit. 

[details="Further details"]

The storage instance identifiers returned from `storage-list` may be passed through to the `storage-get` command using the -s option.
[/details]

Examples:
[details="From Python"]

```python
from subprocess import check_output

storage_volumes = check_output(["storage-list"])
for storage in storage_volumes.splitlines():
    info = check_output(["storage-get", "-s", storage])
```
[/details]


## Payloads

Please see [payloads in Charm metadata](/t/charm-metadata/1043#heading--payloads-field) for further details on how to use payloads within your charms.

<h3 id="heading--payload-status-set">payload-status-set</h3>

`payload-status-set` is used to update the current status of a registered payload. The `class` and `id` provided must match a payload that has been previously registered with juju using [payload-register](#heading--payload-register). 

Valid payload status codes:

-   starting
-   started
-   stopping
-   stopped

Examples:

[details="From Python"]

``` python
from charmhelpers.core.hookenv import payload_status_set

payload_status_set('monitor', '0fcgaba', 'stopping')
```
[/details]

[details="From bash"]

``` shell
payload-status-set monitor abcd13asa32c starting
```
[/details]

<h3 id="heading--payload-register">payload-register</h3>

`payload-register` informs Juju that a payload has started.

[details="Further details"]
Used while a hook is running to let Juju know that a payload has been started. The information used to start the payload must be provided when "register" is run.

The payload class must correspond to one of the payloads defined in the charm's metadata.yaml.

An example fragment from `metadata.yaml`:

``` yaml
payloads:
    monitoring:
        type: docker
    kvm-guest:
        type: kvm
```
[/details]

Examples:
[details = "From Python"]

``` python
from charmhelpers.core.hookenv import payload_register

payload_register('monitoring', 'docker', '0fcgaba')
```
[/details]
[details="From bash"]

```bash
payload-register monitoring docker 0fcgaba
```
[/details]

<h3 id="heading--payload-unregister">payload-unregister</h3>

`payload-unregister` reports that a payload has stopped.

[details="Further details"]
It used while a hook is running to let Juju know that a payload has been manually stopped. The `class` and `id` provided must match a payload that has been previously registered with Juju using payload-register.
[/details]

Examples:
[details="From Python"]

``` python
from charmhelpers.core.hookenv import payload_unregister

payload_unregister('monitoring', '0fcgaba')
```
[/details]
[details="From bash"]

``` text
payload-unregister monitoring 0fcgaba
```
[/details]

  [charmhelpers package]: https://charm-helpers.readthedocs.io/
