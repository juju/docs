**Usage:** `juju detach-storage [options] <storage> [<storage> ...]`

**Summary:**

Detaches storage from units.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Detaches storage from units. Specify one or more unit/application storage IDs, as output by "juju storage". The storage will remain in the model until it is removed by an operator.

**Examples:**

   juju detach-storage pgdata/0
