**Usage:** `juju remove-machine [options] <machine number> ...`

**Summary:**

Removes one or more machines from a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--force (= false)`

Completely remove a machine and all its dependencies

`--keep-instance (= false)`

Do not stop the running cloud instance

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Machines are specified by their numbers, which may be retrieved from the output of `juju status`.

Machines responsible for the model cannot be removed.

Machines running units or containers can be removed using the `--force` option; this will also remove those units and containers without giving them an opportunity to shut down cleanly.

**Examples:**

Remove machine number 5 which has no running units or containers:

`   juju remove-machine 5`

Remove machine 6 and any running units or containers:

`   juju remove-machine 6 --force`

Remove machine 7 from the Juju model but do not stop the corresponding cloud instance:

`   juju remove-machine 7 --keep-instance`

**See also:**

[add-machine](https://discourse.jujucharms.com/t/command-add-machine/1672)
