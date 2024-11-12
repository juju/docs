(command-juju-remove-cloud)=
# Command 'juju remove-cloud'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-cloud <command-juju-add-cloud>`, {ref}`update-cloud <command-juju-update-cloud>`, {ref}`clouds <command-juju-clouds>`

## Summary
Removes a cloud from Juju.

## Usage
```juju remove-cloud [options] <cloud name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |
| `--client` | false | Client operation |

## Examples

    juju remove-cloud mycloud
    juju remove-cloud mycloud --client
    juju remove-cloud mycloud --controller mycontroller


## Details

Remove a cloud from Juju.

If --controller is used, also remove the cloud from the specified controller,
if it is not in use.

If --client is specified, Juju removes the cloud from this client.