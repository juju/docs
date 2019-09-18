**Usage:** ` juju add-space [options] <name> [<CIDR1> <CIDR2> ...]`

**Summary:**

Add a new network space.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Adds a new space with the given name and associates the given (optional) list of existing subnet CIDRs with it.
