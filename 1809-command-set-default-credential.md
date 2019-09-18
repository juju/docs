**Usage:** `juju set-default-credential <cloud name> <credential name>`

**Summary:**

Sets local default credentials for a cloud.

**Details:**

The default credentials are specified with a "credential name". A credential name is created during the process of adding credentials either via `juju add-credential` or `juju autoload-credentials`. Credential names can be listed with `juju credentials`.

This command sets a locally stored credential to be used as a default. Default credentials avoid the need to specify a particular set of credentials when more than one are available for a given cloud.

**Examples:**

`   juju set-default-credential google credential_name`

**See also:**

[credentials](https://discourse.jujucharms.com/t/command-credentials/1704), [add-credential](https://discourse.jujucharms.com/t/command-add-credential/1670), [remove-credential](https://discourse.jujucharms.com/t/command-remove-credential/1785), [autoload-credentials](https://discourse.jujucharms.com/t/command-autoload-credentials/1686)
