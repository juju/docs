(command-juju-remove-secret-backend)=
# Command 'juju remove-secret-backend'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-secret-backend <command-juju-add-secret-backend>`, {ref}`secret-backends <command-juju-secret-backends>`, {ref}`show-secret-backend <command-juju-show-secret-backend>`, {ref}`update-secret-backend <command-juju-update-secret-backend>`

## Summary
Removes a secret backend from the controller.

## Usage
```juju remove-secret-backend [options] <backend-name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-c`, `--controller` |  | Controller to operate in |
| `--force` | false | force removal even if the backend stores in-use secrets |

## Examples

    juju remove-secret-backend myvault
    juju remove-secret-backend myvault --force


## Details

Removes a secret backend, used for storing secret content.
If the backend is being used to store secrets currently in use,
the --force option can be supplied to force the removal, but be
warned, this will affect charms which use those secrets.