(command-juju-list-users)=
# Command 'juju list-users'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-user <command-juju-add-user>`, {ref}`register <command-juju-register>`, {ref}`show-user <command-juju-show-user>`, {ref}`disable-user <command-juju-disable-user>`, {ref}`enable-user <command-juju-enable-user>`
**Alias:** users

## Summary
Lists Juju users allowed to connect to a controller or model.

## Usage
```juju list-users [options] [model-name]```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `--all` | false | Include disabled users |
| `-c`, `--controller` |  | Controller to operate in |
| `--exact-time` | false | Use full timestamp for connection times |
| `--format` | tabular | Specify output format (json&#x7c;tabular&#x7c;yaml) |
| `-o`, `--output` |  | Specify an output file |

## Examples

Print the users relevant to the current controller:

    juju users
    
Print the users relevant to the controller "another":

    juju users -c another

Print the users relevant to the model "mymodel":

    juju users mymodel


## Details
When used without a model name argument, users relevant to a controller are printed.
When used with a model name, users relevant to the specified model are printed.