**Usage:** `juju enable-destroy-controller [options]`

**Summary:**

Enable destroy-controller by removing disabled commands in the controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

Any model in the controller that has disabled commands will block a controller from being destroyed.

A controller administrator is able to enable all the commands across all the models in a Juju controller so that the controller can be destoyed if desired.

**See also:**

[disable-command](https://discourse.jujucharms.com/t/command-disable-command/1712), [disabled-commands](https://discourse.jujucharms.com/t/command-disabled-commands/1714), [enable-command](https://discourse.jujucharms.com/t/command-enable-command/1716)
