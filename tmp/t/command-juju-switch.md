(command-juju-switch)=
# Command 'juju switch'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`controllers <command-juju-controllers>`, {ref}`models <command-juju-models>`, {ref}`show-controller <command-juju-show-controller>`

## Summary
Selects or identifies the current controller and model.

## Usage
```juju switch [options] [<controller>|<model>|<controller>:|:<model>|<controller>:<model>]```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |

## Examples

    juju switch
    juju switch mymodel
    juju switch mycontroller
    juju switch mycontroller:mymodel
    juju switch mycontroller:
    juju switch :mymodel


## Details
When used without an argument, the command shows the current controller
and its active model.
When a single argument without a colon is provided juju first looks for a
controller by that name and switches to it, and if it's not found it tries
to switch to a model within current controller. mycontroller: switches to
default model in mycontroller, :mymodel switches to mymodel in current
controller and mycontroller:mymodel switches to mymodel on mycontroller.
The `juju models` command can be used to determine the active model
(of any controller). An asterisk denotes it.