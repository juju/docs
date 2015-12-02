# Juju tools

Units deployed with juju have a suite of tooling available to them, called ‘hook tools’. These commands provide the charm developer with a consistent interface to take action on the units behalf, such as opening ports, obtaining configuration, even determining which unit is the leader in a cluster. The listed hook-tools are available in any hook running on the unit, and are only available within ‘hook context’.

> Note: you can view a detailed listing of what each command listed below does
on your client with `juju help-tool {command}`. Or for more detailed help on
individual commands run the command with the -h flag.

## action-fail

`action-fail` sets the action's fail state with a given error message.  Using
`action-fail` without a failure message will set a default message indicating a
problem with the action.

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
map as needed.

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

`action-set` adds the given values to the results map of the Action.  This map
is returned to the user after the completion of the Action.  Keys must start
and end with lowercase alphanumeric, and contain only lowercase alphanumeric,
hyphens and periods.

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
powershell:  
```powershell
Import-Module CharmHelpers
# Close a single port
Close-JujuPort "80/TCP"
# Close a range of ports
Close-JujuPort "1000-2000/UDP"
```


## config-get

`config-get` prints the service configuration for one key or all keys.

python:  
```python
from charmhelpers.core.hookenv import config

# Get all the configuration as a dictionary.
cfg =config()
# Get the value for the "interval" key.
interval = cfg.get(‘interval’)
```
bash:  
```bash
INTERVAL=$(config-get interval)
```
powershell:  
```powershell
Import-Module CharmHelpers
$interval = Get-JujuCharmConfig "interval"
```

## is-leader

`is-leader` prints a boolean indicating whether the local unit is guaranteed to
be service leader for at least 30 seconds. If it fails, you should assume that
there is no such guarantee.

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
powershell:  
```powershell
Import-Module CharmHelpers
if (Is-Leader) {
    # Do something a leader would do
}
```


## juju-log

`juju-log` writes a message to the juju log at the appropriate log level. Valid
levels are: INFO, WARN, ERROR, DEBUG

python:  
```python
from charmhelpers.core.hookenv import juju_log

juju_log('Something has transpired', 'INFO')
```
bash:  
```bash
juju-log -l 'INFO' Something has transpired
```
powershell:  
```powershell
Import-Module CharmHelpers
# Basic logging
Write-JujuLog "Something has transpired"
# Logs the message and throws an error, stopping the script
Write-JujuError "Something has transpired. Throwing an error..."
```

## juju-reboot

`juju-reboot` causes the host machine to reboot, after stopping all containers
hosted on the machine.

An invocation without arguments will allow the current hook to complete, and
will only cause a reboot if the hook completes successfully.

If the --now flag is passed, the current hook will terminate immediately, and
be restarted from scratch after reboot. This allows charm authors to write
hooks that need to reboot more than once in the course of installing software.

The --now flag cannot terminate a debug-hooks session; hooks using --now should
be sure to terminate on unexpected errors, so as to guarantee expected behavior
in all situations.

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
powershell:  
```powershell
Import-Module CharmHelpers
# immediately reboot
ExitFrom-JujuHook -WithReboot
```

## leader-get

`leader-get` prints the value of a leadership setting specified by key. If no
key is given, or if the key is "-", all keys and values will be printed.

python:  
```python
from charmhelpers.core.hookenv import leader_get

address = leader_get('cluster-leader-address')
```
bash:  
```bash
ADDRESSS=$(leader-get cluster-leader-address)
```
powershell:  
```powershell
Import-Module CharmHelpers
$clusterLeaderAddress = Get-LeaderData "cluster-leader-address"
```

## leader-set

`leader-set` immediately writes the  key/value pairs to the state server,
which will then inform non-leader units of the change. It will fail if called
without arguments, or if called by a unit that is not currently service leader.

python:  
```python
from charmhelpers.core.hookenv import leader_set

leader_set('cluster-leader-address', "10.0.0.123")
```
bash:  
```bash
leader-set cluster-leader-address=10.0.0.123
```
powershell:  
```powershell
Import-Module CharmHelpers
Set-LeaderData @{"cluster-leader-address"="10.0.0.123"}
```

## opened-ports

`opened-ports` lists all ports or ranges opened by the unit.

python:  
```python
from subprocess import check_output

range = check_output(["opened-ports"])
```
bash:  
```bash
opened-ports
```
powershell:  
```powershell
Import-Module CharmHelpers
# returns boolean
$isRangeOpen = Is-JujuPortRangeOpen "100-1000/TCP"
```


## open-port

`open-port` registers a port or range to open on the public-interface. On public
clouds the port will only be open while the service is exposed.

python:  
```python
from charmhelpers.core.hookenv import open_port

open_port(80, protocol='TCP')
```
bash:  
```bash
open-port 80/tcp
```
powershell:  
```powershell
Import-Module CharmHelpers
# Open a single port
Open-JujuPort "80/TCP"
# Open a range of ports
Open-JujuPort "1000-2000/UDP"
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
that a payload has been manually stopped. The <class> and <id> provided
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

`relation-get` prints the value of a unit's relation setting, specified by key.

python:  
```python
from charmhelpers.core.hookenv import relation_get

# when in a relationship hook context
relation_get('private-address')
```
bash:  
```bash
relation-get private-address
```
powershell:  
```powershell
Import-Module CharmHelpers
Get-JujuRelation -Attr "private-address"
```

## relation-ids

`relation-ids` lists all relation id's with the given relation name.

python:  
```python
from charmhelpers.core.hookenv import relation_ids

relation_ids('database')
```
bash:  
```bash
relation-ids database
```
powershell:  
```powershell
Import-Module CharmHelpers
Get-JujuRelationIds -RelType "database"
```


## relation-list

`relation-list` lists the units on the relation. Scoped through a relation id.

python:  
```python
from charmhelpers.core.hookenv import relation_list
from charmhelpers.core.hookenv import relation_id

relation_list(relation_id())
```
bash:  
```bash
relation-list 9
```
powershell:  
```powershell
Import-Module CharmHelpers
Get-JujuRelatedUnits -RelId (Get-JujuRelationId)
```


## relation-set

`relation-set` writes relation data to send to the related units. If no relation
is specified then the current relation is used. The setting values are not
inspected and are stored as strings. Setting an empty string causes the setting
to be removed.

python:  
```python
from charmhelpers.core.hookenv import relation_set

relation_set({'port': 80, 'tuning': 'default'})
```
bash:  
```bash
relation-set port=80 tuning=default
```
powershell:  
```powershell
Import-Module CharmHelpers
Set-JujuRelation -Relation_Settings @{"port"=80;"tuning"="default"}
```


## status-get

`status-get` prints the previously set state of the workload.

python:  
```python
from charmhelpers.core.hookenv import status_get

charm_status = status_get()
```
bash:  
```bash
status-get
```


## status-set

`status-set` wites the workload state with an optional message which is visible
to the user using `juju status`

python:  
```python
from charmhelpers.core.hookenv import status_set

status_set('blocked', 'Unable to continue until related to a database')
```
bash:  
```bash
status-set blocked 'Unable to continue until related to a database'
```


## storage-add

`storage-add` adds storage instances to unit using provided storage directives.
A storage directive consists of a storage name as per charm specification and
optional storage COUNT. COUNT is a positive integer indicating how many
instances of the storage to create. If unspecified, COUNT defaults to 1.

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

`stoarge-get` information for storage instance with specified id. When no <key>
is supplied, all keys values are printed.

python:  
```python
from subprocess import check_call

check_call(["storage-get", "21127934-8986-11e5-af63-feff819cdc9f"])
```
bash:
```bash
storage-get 21127934-8986-11e5-af63-feff819cdc9f
```


## storage-list

`storage-list` will list the names of all storage instances attached to the
unit. These names can be passed to `storage-get` using the "-s" flag to query
the storage attributes.

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

`unit-get` return the unit specific information requested, such as
private-address or public-address.

python:  
```python
from charmhelpers.core.hookenv import unit_get

address = unit_get('public-address')
```
bash:  
```bash
unit-get public-address
```
powershell:  
```powershell
Import-Module CharmHelpers
Get-JujuUnit -Attr "public-address"
```