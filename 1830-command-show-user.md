**Usage:** `juju show-user [options] [<user name>]`

**Summary:**

Show information about a user.

**Options:**

`-c, --controller (= "")`

Controller to operate in

`--exact-time (= false)`

Use full timestamp for connection times

`--format (= yaml)`

Specify output format (`json|yaml`)

`-o, --output (= "")`

Specify an output file

**Details:**

By default, the YAML format is used and the user name is the current user.

**Examples:**

       juju show-user
        juju show-user jsmith
        juju show-user --format json
        juju show-user --format yaml
**See also:**

[add-user](https://discourse.jujucharms.com/t/command-add-user/1680), [register](https://discourse.jujucharms.com/t/command-register/1777), [users](https://discourse.jujucharms.com/t/command-users/1855)
