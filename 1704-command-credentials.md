**Usage:** `juju credentials [options] [<cloud name>]`

**Summary:**

Lists locally stored credentials for a cloud.

**Options:**

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

`--show-secrets (= false)`

Show secrets

**Details:**

Locally stored credentials are used with `juju bootstrap`
and `juju add-model`.

An arbitrary "credential name" is used to represent credentials, which are added either via `juju add-credential` or `juju autoload-credentials`. Note that there can be multiple sets of credentials and, thus, multiple names.

Actual authentication material is exposed with the `--show-secrets` option.

A controller, and subsequently created models, can be created with a different set of credentials but any action taken within the model (e.g.: `juju deploy`;  `juju add-unit`) applies the credential used to create that model. This model credential is stored on the controller. A credential for 'controller' model is determined at bootstrap time and will be stored on the controller. It is considered to be controller default. Recall that when a controller is created a 'default' model is also created. This model will use the controller default credential. To see all your credentials on the controller use `juju show-credentials` command.

When adding a new model, Juju will reuse the controller default credential. To add a model that uses a different credential, specify a locally stored credential using `--credential` option. See `juju help add-model` for more information.

Credentials denoted with an asterisk '*' are currently set as the local default for the given cloud.

Examples:

       juju credentials
        juju credentials aws
        juju credentials --format yaml --show-secrets
**See also:**

[add-credential](https://discourse.jujucharms.com/t/command-add-credential/1670), [remove-credential](https://discourse.jujucharms.com/t/command-remove-credential/1785), [set-default-credential](https://discourse.jujucharms.com/t/command-set-default-credential/1809), [autoload-credentials](https://discourse.jujucharms.com/t/command-autoload-credentials/1686), [show-credentials](https://discourse.jujucharms.com/t/command-show-credentials/1823)

**Aliases:**

list-credentials
