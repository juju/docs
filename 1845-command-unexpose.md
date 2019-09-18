**Usage:** `juju unexpose [options] <application name>`

**Summary:**

Removes public availability over the network for an application.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Adjusts the firewall rules and any relevant security mechanisms of the cloud to deny public access to the application.

An application is unexposed by default when it gets created.

**Examples:**

`   juju unexpose wordpress`

**See also:**

[expose](https://discourse.jujucharms.com/t/command-expose/1721)
