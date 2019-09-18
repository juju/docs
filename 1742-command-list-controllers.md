**Usage:** `juju controllers [options]`

**Summary:**

Lists all controllers.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

`--refresh (= false)`

Connect to each controller to download the latest details

**Details:**

The output format may be selected with the `--forma`' option. In the default tabular output, the current controller is marked with an asterisk.

**Examples:**

       juju controllers
        juju controllers --format json --output ~/tmp/controllers.json
**See also:**

[models](https://discourse.jujucharms.com/t/command-models/1771), [show-controller](https://discourse.jujucharms.com/t/command-show-controller/1821)

**Aliases:**

list-controllers
