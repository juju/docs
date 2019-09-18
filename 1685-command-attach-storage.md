**Usage:** `juju attach-storage [options] <unit> <storage> [<storage> ...]`

**Summary:**

Attaches existing storage to a unit.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Attach existing storage to a unit. Specify a unit and one or more storage IDs to attach to it.

**Examples:**

`   juju attach-storage postgresql/1 pgdata/0`
