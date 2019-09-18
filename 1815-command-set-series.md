**Usage:** `juju set-series [options] <application> <series>`

**Summary:**

Set an application's series.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--force (= false)`

Set even if the series is not supported by the charm and/or related subordinate charms.

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

When no options are set, an application series value will be set within juju. The update is disallowed unless the `--force` option is used if the requested series is not explicitly supported by the application's charm and all subordinates, as well as any other charms which may be deployed to the same machine.

**Examples**:

    juju set-series <application> <series>
    juju set-series <application> <series> --force
**See also:**

[status](https://discourse.jujucharms.com/t/command-status/1836), [upgrade-charm](https://discourse.jujucharms.com/t/command-upgrade-charm/1849)
