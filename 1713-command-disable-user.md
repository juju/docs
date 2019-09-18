**Usage:** `juju disable-user [options] <user name>`

**Summary:**

Disables a Juju user.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

A disabled Juju user is one that cannot log in to any controller.

This command has no affect on models that the disabled user may have created and/or shared nor any applications associated with that user.

**Examples:**

`   juju disable-user bob`

**See also:**

[users](https://discourse.jujucharms.com/t/command-users/1855), [enable-user](https://discourse.jujucharms.com/t/command-enable-user/1719), [login](https://discourse.jujucharms.com/t/command-login/1760)
