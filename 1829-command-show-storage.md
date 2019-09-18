**Usage:** `juju show-storage [options] <storage ID> [...]`

**Summary:**

Shows storage instance information.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (`json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

Show extended information about storage instances.

Storage instances to display are specified by storage ids. Storage ids are positional arguments to the command and do not need to be comma separated when more than one id is desired.
