**Usage:** juju payloads [options] [pattern ...]

**Summary:**

Display status information about known payloads.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

This command will report on the runtime state of defined payloads.

When one or more pattern is given, Juju will limit the results to only those payloads which match any of the provided patterns. Each pattern will be checked against the following info in Juju:

* unit name
* machine id
* payload type
* payload class
* payload id
* payload tag
* payload status

**Aliases:**

list-payloads
