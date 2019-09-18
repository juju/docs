**Usage:** `juju restore-backup [options]`

**Summary:**

Restore from a backup archive to the existing controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--file (= "")`

Provide a file to be used as the backup

`--id (= "")`

Provide the name of the backup to be restored

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Restores the Juju state database backup that was previously created with `juju create-backup`, returning an existing controller to a previous state. Note: Only the database will be restored. Juju will not change the existing environment to match the restored database, e.g. no units, relations, nor machines will be added or removed during the restore process.

Note: Extra care is needed to restore in an HA environment, please see https://docs.jujucharms.com/stable/controllers-backup for more information. If the provided state cannot be restored, this command will fail with an explanation.
