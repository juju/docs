**Usage:** `juju remove-backup [options] [--keep-latest|<ID>]`

**Summary:**

Remove the specified backup from remote storage.

**Options**:

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--keep-latest (= false)`

Remove all backups on remote storage except for the latest.

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

`remove-backup` removes a backup from remote storage.
