**Usage:** `juju download-backup [options] <ID>`

**Summary:**

Get an archive file.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--filename (= "")`

Download target

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

download-backup retrieves a backup archive file.

If `--filename` is not used, the archive is downloaded to a temporary location and the filename is printed to stdout.
