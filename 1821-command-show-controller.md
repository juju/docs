**Usage:** `juju show-controller [options] [<controller name> ...]`

**Summary:**

Shows detailed information of a controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (`json|yaml`)

`-o, --output (= "")`

Specify an output file

`--show-password (= false)`

Show password for logged in user

**Details:**

Shows extended information about a controller(s) as well as related models and user login details.

**Examples**:

       juju show-controller
        juju show-controller aws google
**See also:**

[controllers](https://discourse.jujucharms.com/t/command-controllers/1700)
