(command-juju-enable-destroy-controller)=
# Command 'juju enable-destroy-controller'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`disable-command <command-juju-disable-command>`, {ref}`disabled-commands <command-juju-disabled-commands>`, {ref}`enable-command <command-juju-enable-command>`

## Summary
Enable destroy-controller by removing disabled commands in the controller.

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |

## Details

Any model in the controller that has disabled commands will block a controller
from being destroyed.

A controller administrator is able to enable all the commands across all the models
in a Juju controller so that the controller can be destoyed if desired.