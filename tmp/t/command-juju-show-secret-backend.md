(command-juju-show-secret-backend)=
# Command 'juju show-secret-backend'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-secret-backend <command-juju-add-secret-backend>`, {ref}`secret-backends <command-juju-secret-backends>`, {ref}`remove-secret-backend <command-juju-remove-secret-backend>`, {ref}`update-secret-backend <command-juju-update-secret-backend>`

## Summary
Displays the specified secret backend.

## Usage
```juju show-secret-backend [options] <backend-name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-c`, `--controller` |  | Controller to operate in |
| `--format` | yaml | Specify output format (json&#x7c;yaml) |
| `-o`, `--output` |  | Specify an output file |
| `--reveal` | false | Include sensitive backend config content |

## Examples

    juju show-secret-backend myvault
    juju secret-backends myvault --reveal


## Details

Displays the specified secret backend.