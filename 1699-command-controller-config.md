**Usage:** `juju controller-config [options] [<attribute key>[=<value>] ...]`

**Summary:**

Displays or sets configuration settings for a controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

**Details:**

By default, all configuration (keys and values) for the controller are displayed if a key is not specified. Supplying one key name returns only the value for that key.

Supplying key=value will set the supplied key to the supplied value; this can be repeated for multiple keys. You can also specify a yaml file containing key values. Not all keys can be updated after bootstrap time.

Available keys and values can be found here:

https://jujucharms.com/stable/controllers-config

**Examples:**

       juju controller-config
        juju controller-config api-port
        juju controller-config -c mycontroller
        juju controller-config auditing-enabled=true audit-log-max-backups=5
        juju controller-config auditing-enabled=true path/to/file.yaml
        juju controller-config path/to/file.yaml
**See also:**

[controllers](https://discourse.jujucharms.com/t/command-controllers/1700), [model-config](https://discourse.jujucharms.com/t/command-model-config/1768), [show-cloud](https://discourse.jujucharms.com/t/command-show-cloud/1820)
