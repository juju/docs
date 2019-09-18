**Usage:** `juju upload-backup [options] <filename>`

**Summary:**

Store a backup archive file remotely in Juju.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

`upload-backup` sends a backup archive file to remote storage.
