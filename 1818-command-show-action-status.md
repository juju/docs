**Usage:** `juju show-action-status [options] [<action ID>|<action ID prefix>]`

**Summary:**

Show results of all actions filtered by optional ID prefix.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (`json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--name (= "")`

Action name

`-o, --output (= "")`

Specify an output file

**Details:**

Show the status of Actions matching given ID, partial ID prefix, or all Actions if no ID is supplied. If `--name` is provided the search will be done by name rather than by ID.
