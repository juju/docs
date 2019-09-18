**Usage:** `juju users [options]`

**Summary:**

Lists Juju users allowed to connect to a controller or model.

**Options:**

`--all (= false)`

Include disabled users

`-c, --controller (= "")`

Controller to operate in

`--exact-time (= false)`

Use full timestamp for connection times

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

**Details:**

When used without a model name argument, users relevant to a controller are printed. When used with a model name, users relevant to the specified model are printed.

**Examples:**

       Print the users relevant to the current controller: 
        juju users

        Print the users relevant to the controller "another":

        juju users -c another

        Print the users relevant to the model "mymodel":

        juju users mymodel

**See also:**

[add-user](https://discourse.jujucharms.com/t/command-add-user/1680), [register](https://discourse.jujucharms.com/t/command-register/1777), [show-user](https://discourse.jujucharms.com/t/command-show-user/1830), [disable-user](https://discourse.jujucharms.com/t/command-disable-user/1713), [enable-user](https://discourse.jujucharms.com/t/command-enable-user/1719)

**Aliases:**

list-users
