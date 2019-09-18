**Usage:** `juju trust [options] <application name>`

**Summary:**

Sets the trust status of a deployed application to true.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--remove (= false)`

Remove trusted access from a trusted application

**Details:**

Sets the trust configuration value to true.

**Examples:**

`   juju trust media-wiki`

**See also:**

[config](https://discourse.jujucharms.com/t/command-config/1697)
