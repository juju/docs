**Usage:** `juju unregister [options] <controller name>`

**Summary:**

Unregisters a Juju controller.

**Options:**

`-y, --yes (= false)`

Do not prompt for confirmation

**Details:**

Removes local connection information for the specified controller. This command does not destroy the controller. In order to regain access to an unregistered controller, it will need to be added again using the `juju register` command.

**Examples:**

`   juju unregister my-controller`

**See also:**

[destroy-controller](https://discourse.jujucharms.com/t/command-destroy-controller/1708), [kill-controller](https://discourse.jujucharms.com/t/command-kill-controller/1734), [register](https://discourse.jujucharms.com/t/command-register/1777)
