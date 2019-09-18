**Usage:**` juju cancel-action [options] <<action ID | action ID prefix>...>`

**Summary:**

Cancel pending actions.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (`json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

Cancel actions matching given IDs or partial ID prefixes.
