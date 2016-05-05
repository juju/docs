Title: Juju actions  

# Juju Actions

Juju Charms can describe Actions that users can take on deployed services.

Actions are scripts that can be triggered on a unit via the CLI or the [Juju
GUI](controllers-gui.html). Parameters for an action are passed as a map,
either defined in a YAML file or given through the UI, and are validated
against the schema defined in actions.yaml. See
[Actions for the charm author](authors-charm-actions.html) for more
information.

Actions are sub-commands of the `juju action` command. To get more on their
usage, use `juju action help`.

Actions are exposed as of Juju 1.23. In Juju 1.22, they are only enabled in
the CLI when `JUJU_DEV_FEATURE_FLAG=actions` is set.

The following subcommands are specified:

```no-highlight
defined - show actions defined for a service
do      - queue an action for execution
fetch   - show results of an action by ID
status  - show results of all actions filtered by optional ID prefix
```

## Action commands 

### `juju action defined`

List the actions defined on a service.

 > Example
```bash
juju action defined mysql
backup: Take a backup of the database.
benchmark: Benchmark the performance of the database.
dump: Dump the database to a file.
restart: Restart the database.
restore: Restore from a dump.
start: Start the database.
stop: Stop the database.
test: Test the database.
```

Show the full schema of the actions on a service.

 > Example
```bash
juju action defined actions-demo --schema
report:
  description: Report back with the time
  params:
    description: Report back with the time
    properties: {}
    title: report
    type: object
run:
  description: Run some command
  properties:
    command:
      default: pwd
      description: The command to run
      type: string
    title: run
    type: object
```

> Note that the full schema is under the `properties` key of the root Action.
> Juju Actions rely on [JSON-Schema](http://json-schema.org) for validation.
> The top-level keys shown for the Action (`description` and `properties`) may
> include future additions to the feature.

### `juju action do`

Trigger an action (the ID of the action will be displayed, for use with `juju
action fetch <ID>` or `juju action status <ID>`; see below):

```bash
juju action do mysql/0 backup
Action queued with id: <ID>

juju action do mysql/0 tpcc
ERROR action "tpcc" not defined on unit "mysql/0"

juju action do mysql/0 benchmark
Action queued with id: <ID>

juju action do mysql/0 restart
Action queued with id: <ID>
```

Parameters can be passed directly:

```bash
juju action do mysql/0 benchmark bench="foo"
Action queued with id: <ID>

juju action do mysql/0 benchmark bench.kind="foo" bench.speed="fast"
Action queued with id: <ID>
```

Or indirectly via a YAML file (those provided directly take precedence):

 > Example params.yml
```yaml
bench:
  kind:
    smoke: yes
    crashtest: no
  speed: fast
```

```bash
juju action do mysql/0 benchmark --params=params.yml bench.speed=slow
Action queued with id: <ID>
```

### `juju action fetch`

Fetch the results of an action:

```bash
juju action fetch <ID>
message: <any error message>
results:
# An arbitrary YAML map set by the Action.
  outcome: success
  values:
    message: Hello world!
    time-completed: Thu Jan 22 11:28:04 EST 2015
status: completed
```

### `juju action status`

Query the status of an action:

```bash
juju action status <ID>
action: UUID
status: running
invoked: TIME

juju action status <ID>
action: UUID
status: failure
failure: <message>
```
