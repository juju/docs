**Usage:** `juju add-user [options] <user name> [<display name>]`

**Summary:**

Adds a Juju user to a controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

The user's details are stored within the controller and will be removed when the controller is destroyed.

A user unique registration string will be printed. This registration string must be used by the newly added user as supplied to complete the registration process. Some machine providers will require the user to be in possession of certain credentials in order to create a model.

**Examples:**

       juju add-user bob
        juju add-user --controller mycontroller bob
**See also:**

[register](https://discourse.jujucharms.com/t/command-register/1777), [grant](https://discourse.jujucharms.com/t/command-grant/1726), [users](https://discourse.jujucharms.com/t/command-users/1855), [show-user](https://discourse.jujucharms.com/t/command-show-user/1830), [disable-user](https://discourse.jujucharms.com/t/command-disable-user/1713), [enable-user](https://discourse.jujucharms.com/t/command-enable-user/1719), [change-user-password](https://discourse.jujucharms.com/t/command-change-user-password/1692), [remove-user](https://discourse.jujucharms.com/t/command-remove-user/1794)
