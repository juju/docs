**Usage:** `juju grant-cloud [options] <user name> <permission> <cloud name> ...`

**Summary:**

Grants access level to a Juju user for a cloud.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

Valid access levels are:

         add-model
          admin
**Examples:**

Grant user 'joe' 'add-model' access to cloud 'fluffy':

`   juju grant-cloud joe add-model fluffy`

**See also:**

[revoke-cloud](https://discourse.jujucharms.com/t/command-revoke-cloud/1802), [add-user](https://discourse.jujucharms.com/t/command-add-user/1680)
