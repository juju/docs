**Usage:** `juju remove-user [options] <user name>`

**Summary:**

Deletes a Juju user from a controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`-y, --yes (= false)`

Confirm deletion of the user

**Details:**

This removes a user permanently.

By default, the controller is the current controller.

**Examples:**

       juju remove-user bob
        juju remove-user bob --yes
**See also:**

[unregister](https://discourse.jujucharms.com/t/command-unregister/1846), [revoke](https://discourse.jujucharms.com/t/command-revoke/1801), [show-user](https://discourse.jujucharms.com/t/command-show-user/1830), [list-users](https://discourse.jujucharms.com/t/command-list-users/1758), switch-user , [disable-user](https://discourse.jujucharms.com/t/command-disable-user/1713), [enable-user](https://discourse.jujucharms.com/t/command-enable-user/1719) , [change-user-password](https://discourse.jujucharms.com/t/command-change-user-password/1692)
