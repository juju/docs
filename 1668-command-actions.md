**Usage:** `juju actions [options] <application name>`

**Summary:**

List actions defined for an application.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= default)`

Specify output format (`default|json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--schema (= false)`

Display the full action schema

**Details:**

List the actions available to run on the target application, with a short description. To show the full schema for the actions, use `--schema`.

For more information, see also the 'run-action' command, which executes actions.

**Aliases:**

list-actions
