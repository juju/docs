**Usage:** `juju set-wallet [options] <wallet name> <value>`

**Summary:**

Set the wallet limit.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

Set the monthly wallet limit.

**Examples:**

Sets the monthly limit for wallet named 'personal' to 96.

`   juju set-wallet personal 96`
