**Usage:** `juju show-machine [options] <machineID> ...`

**Summary:**

Show a machine's status.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--color (= false)`

Force use of ANSI color codes

`--format (= yaml)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--utc (= false)`

Display time as UTC in RFC3339 format

**Details:**

Show a specified machine on a model. Default format is in yaml, other formats can be specified with the `--format` option.

Available formats are yaml, tabular, and json

**Examples:**

Display status for machine 0

`juju show-machine 0`

Display status for machines 1, 2 & 3

`juju show-machine 1 2 3`
