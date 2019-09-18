**Usage:** `juju remove-storage [options] <storage> [<storage> ...]`

**Summary:**

Removes storage from the model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--force (= false)`

Remove storage even if it is currently attached

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-destroy (= false)`

Remove the storage without destroying it

**Details:**

Removes storage from the model. Specify one or more storage IDs, as output by `juju storage`.

By default, remove-storage will fail if the storage is attached to any units. To override this behaviour, you can use `juju remove-storage --force`.

**Examples:**

Remove the detached storage pgdata/0.

`   juju remove-storage pgdata/0`

Remove the possibly attached storage pgdata/0.

`   juju remove-storage --force pgdata/0`

Remove the storage pgdata/0, without destroying the corresponding cloud storage.

`   juju remove-storage --no-destroy pgdata/0`
