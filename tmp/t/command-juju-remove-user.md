(command-juju-remove-user)=
# Command 'juju remove-user'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`unregister <command-juju-unregister>`, {ref}`revoke <command-juju-revoke>`, {ref}`show-user <command-juju-show-user>`, {ref}`users <command-juju-users>`, {ref}`disable-user <command-juju-disable-user>`, {ref}`enable-user <command-juju-enable-user>`, {ref}`change-user-password <command-juju-change-user-password>`

## Summary
Deletes a Juju user from a controller.

## Usage
```juju remove-user [options] <user name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |
| `-y`, `--yes` | false | Confirm deletion of the user |

## Examples

    juju remove-user bob
    juju remove-user bob --yes


## Details
This removes a user permanently.

By default, the controller is the current controller.