**Usage:** `juju show-credential [options] [<cloud name> <credential name>]`

**Summary:**

Shows credential information on a controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (yaml)

`-o, --output (= "")`

Specify an output file

`--show-secrets (= false)`

Display credential secret attributes

**Details:**

This command displays information about credential(s) stored on the controller for this user.

To see the contents of a specific credential, supply its cloud and name. To see all credentials stored for you, supply no arguments.

To see secrets, content attributes marked as hidden, use `--show-secrets option`. To see locally stored credentials, use `juju credentials` command.

**Examples:**

       juju show-credential google my-admin-credential
        juju show-credentials 
        juju show-credentials --show-secrets
**See also:**

[credentials](https://discourse.jujucharms.com/t/command-credentials/1704)

**Aliases:**

show-credentials
