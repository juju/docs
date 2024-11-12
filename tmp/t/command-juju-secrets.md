(command-juju-secrets)=
# Command 'juju secrets'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-secret <command-juju-add-secret>`, {ref}`remove-secret <command-juju-remove-secret>`, {ref}`show-secret <command-juju-show-secret>`, {ref}`update-secret <command-juju-update-secret>`

## Summary
Lists secrets available in the model.

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `--format` | tabular | Specify output format (json&#x7c;tabular&#x7c;yaml) |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |
| `-o`, `--output` |  | Specify an output file |
| `--owner` |  | Include secrets for the specified owner |

## Examples

    juju secrets
    juju secrets --format yaml


## Details

Displays the secrets available for charms to use if granted access.