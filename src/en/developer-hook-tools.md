# Juju tools

Units deployed with juju have a suite of tooling available to them, called ‘hook tools’. These commands provide the charm developer with a consistent interface to take action on the units behalf, such as opening ports, obtaining configuration, even determining which unit is the leader in a cluster. The listed hook-tools are available in any hook running on the unit, and are only available within ‘hook context’.

> Note: you can view a detailed listing of what each command listed below does
on your client with `juju help-tool {command}`. Or for more detailed help on
individual commands run the command with the -h flag.

## action-fail

`action-fail` sets the action's fail state with a given error message.  Using
`action-fail` without a failure message will set a default message indicating a
problem with the action.

```python
from charmhelpers.core.hookenv import action_fail

action_fail(‘Unable to contact remote service’)
```
```bash
action-fail ‘unable to contact remote service’
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## action-get

`action-get` will print the value of the parameter at the given key, serialized
as YAML.  If multiple keys are passed, `action-get` will recurse into the param
map as needed.

```python
from charmhelpers.core.hookenv import action_get

timeout = action_get(‘timeout’)
```
```bash
TIMEOUT=$(action-get timeout)
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## action-set

`action-set` adds the given values to the results map of the Action.  This map
is returned to the user after the completion of the Action.  Keys must start
and end with lowercase alphanumeric, and contain only lowercase alphanumeric,
hyphens and periods.


```python
from charmhelpers.core.hookenv import action_set

action_set('com.juju.result', 'we are the champions')
```
```bash
action-set com.juju.result 'we are the champions'
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## close-port

`close-port` ensures a port or range is not accessible from the public
interface.

```python
from charmhelpers.core.hookenv import close_port

# Close a single port
close_port(80, protocol="UDP")
```
```bash
# Close single port
close-port 80
# Close a range of ports
close-port 9000-9999/udp
```
```powershell
close-port.exe 80
```

## config-get

`config-get` prints the service configuration for one key or all keys.

```python
from charmhelpers.core.hookenv import config

# Get all the configuration as a dictionary.
cfg =config()
# Get the value for the "interval" key.
interval = cfg.get(‘interval’)
```
```bash
INTERVAL=$(config-get interval)
```
```powershell
$url = config-get.exe --format=json "installer-url"
```

## is-leader

`is-leader` prints a boolean indicating whether the local unit is guaranteed to
be service leader for at least 30 seconds. If it fails, you should assume that
there is no such guarantee.

```python
from charmhelpers.core.hookenv import is_leader

if is_leader():
    # Do something a leader would do
```
```bash
LEADER=$(is-leader)
if [ "${LEADER}" == "True" ]; then
  # Do something a leader would do
fi
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## juju-log

`juju-log` writes a message to the juju log at the appropriate log level. Valid
levels are: INFO, WARN, ERROR, DEBUG

```python
from charmhelpers.core.hookenv import juju_log

juju_log('Something has transpired', 'INFO')
```
```bash
juju-log -l 'INFO' Something has transpired
```
```powershell
juju-log.exe "Failed to run amqp-relation-broken: $_"
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

juju-reboot is not supported when running actions.

```python
from subprocess import check_call

check_call(["juju-reboot", "--now"])
```
```bash
# immediately reboot
juju-reboot --now

# Reboot after current hook exits
juju-reboot
```
```powershell
juju-reboot.exe --now
```

## leader-get

`leader-get` prints the value of a leadership setting specified by key. If no
key is given, or if the key is "-", all keys and values will be printed.

```python
from charmhelpers.core.hookenv import leader_get

address = leader_get('cluster-leader-address')
```
```bash
ADDRESSS=$(leader-get cluster-leader-address)
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## leader-set

`leader-set` immediately writes the  key/value pairs to the state server,
which will then inform non-leader units of the change. It will fail if called
without arguments, or if called by a unit that is not currently service leader.

```python
from charmhelpers.core.hookenv import leader_set

leader_set('cluster-leader-address', "10.0.0.123")
```
```bash
leader-set cluster-leader-address=10.0.0.123
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## opened-ports

`opened-ports` lists all ports or ranges opened by the unit.

```python
from subprocess import check_output

range = check_output(["opened-ports"])
```
```bash
opened-ports
```
```powershell
opened-ports.exe
```

## open-port

`open-port` registers a port or range to open on the public-interface. On public
clouds the port will only be open while the service is exposed.

```python
from charmhelpers.core.hookenv import open_port

open_port(80, protocol='TCP')
```
```bash
open-port 80/tcp
```
```powershell
open-port.exe 80
```

## payload-register

`payload-register` used while a hook is running to let Juju know that a
payload has been started. The information used to start the payload must be
provided when "register" is run.

The payload class must correspond to one of the payloads defined in
the charm's metadata.yaml.

```python
from subprocess import check_call

check_call(["payload-register", "monitoring", "docker", "0fcgaba"])
```
```bash
payload-register monitoring docker 0fcgaba
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## payload-unregister

`payload-unregister` used while a hook is running to let Juju know
that a payload has been manually stopped. The <class> and <id> provided
must match a payload that has been previously registered with juju using
payload-register.

```python
from subprocess import check_call

check_call(["payload-unregister", "monitoring", "0fcgaba"])
```
```bash
payload-unregister monitoring 0fcgaba
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## relation-get

`relation-get` prints the value of a unit's relation setting, specified by key.

```python
from charmhelpers.core.hookenv import relation_get

# when in a relationship hook context
relation_get('private-address')
```
```bash
relation-get private-address
```
```powershell
$ctx["rabbit_host"] = relation-get.exe -attr "private-address" -rid $rid -unit $unit
```

## relation-ids

`relation-ids` lists all relation id's with the given relation name.

```python
from charmhelpers.core.hookenv import relation_ids

relation_ids('database')
```
```bash
relation-ids database
```
```powershell
$ids = relation_ids.exe -reltype 'amqp'
```

## relation-list

`relation-list` lists the units on the relation. Scoped through a relation id.

```python
from charmhelpers.core.hookenv import relation_list
from charmhelpers.core.hookenv import relation_id

relation_list(relation_id())
```
```bash
relation-list 9
```
```powershell
$related_units = related-list.exe -r $relationId
```

## relation-set

`relation-set` writes relation data to send to the related units. If no relation
is specified then the current relation is used. The setting values are not
inspected and are stored as strings. Setting an empty string causes the setting
to be removed.

```python
from charmhelpers.core.hookenv import relation_set

relation_set({'port': 80, 'tuning': 'default'})
```
```bash
relation-set port=80 tuning=default
```
```powershell
relation-set.exe -r $relid port=80 tuning=default
```

## status-get

`status-get` prints the previously set state of the workload.

```python
from charmhelpers.core.hookenv import status_get

charm_status = status_get()
```
```bash
status-get
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## status-set

`status-set` wites the workload state with an optional message which is visible
to the user using `juju status`

```python
from charmhelpers.core.hookenv import status_set

status_set('blocked', 'Unable to continue until related to a database')
```
```bash
status-set blocked 'Unable to continue until related to a database'
```
```powershell
status-set.exe "active"
```

## storage-add

`storage-add` adds storage instances to unit using provided storage directives.
A storage directive consists of a storage name as per charm specification and
optional storage COUNT. COUNT is a positive integer indicating how many
instances of the storage to create. If unspecified, COUNT defaults to 1.

```python
from subprocess import check_call

check_call(["storage-add", "database-storage=1"])
```
```bash
storage-add database-storage=1
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## storage-get

`stoarge-get` information for storage instance with specified id. When no <key>
is supplied, all keys values are printed.

```python
from subprocess import check_call

check_call(["storage-get", "21127934-8986-11e5-af63-feff819cdc9f"])
```
```bash
storage-get 21127934-8986-11e5-af63-feff819cdc9f
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## storage-list

`storage-list` will list the names of all storage instances attached to the
unit. These names can be passed to `storage-get` using the "-s" flag to query
the storage attributes.

```python
from subprocess import check_output

storage = check_output(["storage-list"])
```
```bash
storage-list
```
<!-- ```powershell
# Command Not yet implemented.
``` -->

## unit-get

`unit-get` return the unit specific information requested, such as
private-address or public-address.

```python
from charmhelpers.core.hookenv import unit_get

address = unit_get('public-address')
```
```bash
unit-get public-address
```
```powershell
unit-get.exe public-address
```
