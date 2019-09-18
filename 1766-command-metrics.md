**Usage:** `juju metrics [options] [tag1[...tagN]]`

**Summary:**

Retrieve metrics collected by specified entities.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--all (= false)`

retrieve metrics collected by all units in the model

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

Display recently collected metrics.
