**Usage:** `juju spaces [options] [--short] [--format yaml|json] [--output <path>]`

**Summary:**

List known spaces, including associated subnets.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--short (= false)`

only display spaces.

**Details:**

Displays all defined spaces. If `--short` is not given both spaces and their subnets are displayed, otherwise just a list of spaces. The `--format` argument has the same semantics as in other CLI commands - "yaml" is the default. The `--output` argument allows the command output to be redirected to a file.

**Aliases:**

list-spaces
