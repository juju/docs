# Juju Actions

Juju Charms can describe Actions that users can take on deployed services.  [More on Actions for Charm authors here](authors-charm-actions.html).

Actions are scripts that can be triggered on a unit by the Juju user via CLI or the [Juju web UI](howto-gui-management.html). Parameters for an action are passed as a map, either defined in a YAML file or given through the UI, and are validated against the schema defined in actions.yaml as explained [in the docs for Charm authors](authors-charm-actions.html).

Actions are sub-commands of the `juju action` command.  For more on their usage, you can use `juju action help` to see more details.

Actions are exposed as of Juju 1.23.  In Juju 1.22, they are only enabled in the CLI when `JUJU_DEV_FEATURE_FLAG=actions` is set.

The following subcommands are specified:

```
defined - show actions defined for a service
do      - queue an action for execution
fetch   - show results of an action by ID
status  - show results of all actions filtered by optional ID prefix
```

## Action commands 

### `juju action defined`

A user can list the actions defined on a service.

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

A user can show the full schema of the Actions on a service.

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

> Note that the full schema is under the `properties` key of the root Action.  Juju Actions rely on [JSON-Schema](http://json-schema.org) for validation.  The top-level keys shown for the Action (`description` and `properties`) may include future additions to the feature.

### juju action do

A user can trigger an Action from the command-line, passing an optional YAML file as parameters, or defining parameters directly via the CLI.  The UUID of the Action will be shown, for use with `juju action fetch <ID>`.

```bash
juju action do mysql/0 backup
Action queued with id: <ID>

juju action do mysql/0 tpcc
ERROR action "tpcc" not defined on unit "mysql/0"

juju action do mysql/0 benchmark
Action queued with id: <ID>

juju action do mysql/0 benchmark --parameters bm.yaml
Action queued with id: <ID>

juju action do mysql/0 restart
Action queued with id: <ID>
```

The user may also provide params directly via the command-line.

```bash
juju action do mysql/0 benchmark bench="foo"
Action queued with id: <ID>

juju action do mysql/0 benchmark bench.kind="foo" bench.speed="fast"
Action queued with id: <ID>
```

For complex schemas, the user may define params in a YAML file.  The user may also overwrite values via the command-line:

 > Example params.yml
```yaml
bench:
  kind:
    smoke: yes
    crashtest: no
  speed: fast
```

```bash
juju action do mysql/0 bench --params=path/to/params.yml bench.speed=slow
Action queued with id: <ID>
```

### juju action fetch

The user may fetch the results of an Action by ID:

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

### juju action status

The user may look up the status of an Action by ID:

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
