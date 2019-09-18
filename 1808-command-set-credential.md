**Usage:** `juju set-credential [options] <cloud name> <credential name>`

**Summary:**

Relates a remote credential to a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

This command relates a credential cached on a controller to a specific model. It does not change/update the contents of an existing active credential. See command `update-credential` for that.

The credential specified may exist locally (on the client), remotely (on the controller), or both. The command will error out if the credential is stored neither remotely nor locally.

When remote, the credential will be related to the specified model.

When local and not remote, the credential will first be uploaded to the controller and then related.

This command does not affect an existing relation between the specified credential and another model. If the credential is already related to a model this operation will result in that credential being related to two models. Use the `show-credential` command to see how remote credentials are related to models.

Examples:

For cloud 'aws', relate remote credential 'bob' to model 'trinity':

`   juju set-credential -m trinity aws bob`

**See also:**

[credentials](https://discourse.jujucharms.com/t/command-credentials/1704), [show-credential](https://discourse.jujucharms.com/t/command-show-credential/1822), [update-credential](https://discourse.jujucharms.com/t/command-update-credential/1848)
