**Usage:** `juju create-backup [options] [<notes>]`

**Summary:**

Create a backup.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--filename (= "juju-backup-<date>-<time>.tar.gz")`

Download to this file

`--keep-copy (= false)`

Keep a copy of the archive on the controller

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-download (= false)`

Do not download the archive, implies `keep-copy`

Details:

This command requests that Juju creates a backup of its state and prints the backup's unique ID. You may provide a note to associate with the backup. By default, the backup archive and associated metadata are downloaded without keeping a copy remotely on the controller.

Use `--no-download` to avoid getting a local copy of the backup downloaded at the end of the backup process.

Use `--keep-copy` option to store a copy of backup remotely on the controller. Use `--verbose` to see extra information about backup.

To access remote backups stored on the controller, see `juju download-backup`.

**Examples:**

       juju create-backup 
        juju create-backup --no-download
        juju create-backup --no-download --keep-copy=false // ignores --keep-copy
        juju create-backup --keep-copy
        juju create-backup --verbose
**See also:**

[backups](https://discourse.jujucharms.com/t/command-backups/1687), [download-backup](https://discourse.jujucharms.com/t/command-download-backup/1715)
