(command-juju-unregister)=
# Command 'juju unregister'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`destroy-controller <command-juju-destroy-controller>`, {ref}`kill-controller <command-juju-kill-controller>`, {ref}`register <command-juju-register>`

## Summary
Unregisters a Juju controller.

## Usage
```juju unregister [options] <controller name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `--no-prompt` | false | Do not ask for confirmation |

## Examples

    juju unregister my-controller


## Details

Removes local connection information for the specified controller.  This
command does not destroy the controller.  In order to regain access to an
unregistered controller, it will need to be added again using the juju register
command.