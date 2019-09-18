**Usage:** `juju expose [options] <application name>`

**Summary:**

Makes an application publicly available over the network.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Adjusts the firewall rules and any relevant security mechanisms of the cloud to allow public access to the application.

**Examples:**

   `juju expose wordpress`

**See also:**

[unexpose](https://discourse.jujucharms.com/t/command-unexpose/1845)
