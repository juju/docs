(command-juju-list-regions)=
# Command 'juju list-regions'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-cloud <command-juju-add-cloud>`, {ref}`clouds <command-juju-clouds>`, {ref}`show-cloud <command-juju-show-cloud>`, {ref}`update-cloud <command-juju-update-cloud>`, {ref}`update-public-clouds <command-juju-update-public-clouds>`
**Alias:** regions

## Summary
Lists regions for a given cloud.

## Usage
```juju list-regions [options] <cloud>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |
| `--client` | false | Client operation |
| `--format` | tabular | Specify output format (json&#x7c;tabular&#x7c;yaml) |
| `-o`, `--output` |  | Specify an output file |

## Examples

    juju regions aws
    juju regions aws --controller mycontroller
    juju regions aws --client
    juju regions aws --client --controller mycontroller


## Details

List regions for a given cloud.

Use --controller option to list regions from the cloud from a controller.

Use --client option to list regions known locally on this client.