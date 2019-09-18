**Usage:** `juju remove-k8s [options] <k8s name>`

**Summary:**

Removes a k8s endpoint from Juju.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

Removes the specified k8s cloud from the controller (if it is not in use), and user-defined cloud details from this client.

**Examples:**

`   juju remove-k8s myk8scloud`

**See also:**

[add-k8s](https://discourse.jujucharms.com/t/command-add-k8s/1671)
