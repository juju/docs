**Usage:** `juju update-credential [options] <cloud-name> <credential-name>`

**Summary:**

Updates a controller credential for a cloud.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--credential (= "")`

Name of credential to update

**Details:**

Cloud credentials for controller are used for model operations and manipulations. Since it is common to have long-running models, it is also common to have these cloud credentials become invalid during models' lifetime.

When this happens, a user must update the cloud credential that a model was created with to the new and valid details on controller.

This command allows to update an existing, already-stored, named, cloud-specific controller credential.

NOTE: This is the only command that will allow you to manipulate cloud credential for a controller. All other credential related commands, such as `add-credential`, `remove-credential` and `credentials` deal with credentials stored locally on the client not on the controller.

**Examples:**

`   juju update-credential aws mysecrets`

**See also:**

[add-credential](https://discourse.jujucharms.com/t/command-add-credential/1670), [credentials](https://discourse.jujucharms.com/t/command-credentials/1704)
