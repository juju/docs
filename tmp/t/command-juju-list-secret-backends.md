(command-juju-list-secret-backends)=
# Command 'juju list-secret-backends'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-secret-backend <command-juju-add-secret-backend>`, {ref}`remove-secret-backend <command-juju-remove-secret-backend>`, {ref}`show-secret-backend <command-juju-show-secret-backend>`, {ref}`update-secret-backend <command-juju-update-secret-backend>`
**Alias:** secret-backends

## Summary
Lists secret backends available in the controller.

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-c`, `--controller` |  | Controller to operate in |
| `--format` | tabular | Specify output format (json&#x7c;tabular&#x7c;yaml) |
| `-o`, `--output` |  | Specify an output file |
| `--reveal` | false | Include sensitive backend config content |

## Examples

    juju secret-backends
    juju secret-backends --format yaml


## Details

Displays the secret backends available for storing secret content.