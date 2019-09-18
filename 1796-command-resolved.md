**Usage:** `juju resolved [options] [<unit> ...]`

**Summary:**

Marks unit errors resolved and re-executes failed hooks.

**Options**:

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--all (= false)`

Marks all units in error as resolved

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-retry (= false)`

Do not re-execute failed hooks on the unit

**Aliases:**

resolve
