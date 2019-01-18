Title: Disabling commands
TODO:  Table needs verification

# Restricting changes to running models

Commands can be disabled on a per-model basis. This is to protect the model
from unintentional changes. This is accomplished through the use of the
`disable-command` command with one of three progressively restrictive command
groups:

 - destroy-model
 - remove-object
 - all

By disabling the `destroy-model` group, for instance, users lose the ability to
destroy both the model and its controller. Specifying the `remove-object` group
adds to these restrictions by disabling the removal of machines, relations,
applications, and units. The `all` group disables the complete set of commands
that can change the configuration of a model.

To give users an idea as to why a command is disabled, an optional message
argument can be passed.

For example, to prevent execution of both the `destroy-model` and
`destroy-controller` commands:

```bash
juju disable-command destroy-model "Check with SA before destruction."
```

If a user now attempts to destroy a protected model, they'd encounter an error
similar to the following:

```no-highlight
Destroying model
ERROR cannot destroy model: Check with SA before destruction.

destroy-model operation has been disabled for the current model.
To enable the command run

    juju enable-command destroy-model
```

!!! Important: 
    The `--force` option supported by some commands overrides disabled
    commands.

## Re-enabling a command

To re-enable a command the `enable-command` is used.

For example, to restore the commands associated with the 'destroy-model'
command group:

```bash
juju enable-command destroy-model
```
  
As usual, these actions are performed against the currently selected
controller and model.

To list which commands have been disabled, use `disabled-commands`:

```bash
juju disabled-commands
``` 

This will output will list any group that's currently disabled:

<!-- JUJUVERSION: 2.0.1-xenial-amd64 -->
<!-- JUJUCOMMAND: juju disabled-commands -->
```no-highlight
Disabled commands  Message
all
```

!!! Note: 
    In some cases, the disable command will only take effect after the user has
    logged out of Juju (`juju logout`) and logged back in again (`juju login`).

## Commands within each command group

| destroy-model      | remove-object      | all                  |
|--------------------|--------------------|----------------------|
| destroy-controller | destroy-controller | add-relation         |
| destroy-model      | destroy-model      | add-unit             |
|                    | destroy-machine    | add-ssh-key          |
|                    | remove-machine     | add-user             |
|                    | remove-relation    | change-user-password |
|                    | remove-application | deploy               |
|                    | remove-unit        | disable-user         |
|                    |                    | destroy-controller   |
|                    |                    | destroy-model        |
|                    |                    | enable-ha            |
|                    |                    | enable-user          |
|                    |                    | expose               |
|                    |                    | import-ssh-key       |
|                    |                    | remove-application   |
|                    |                    | remove-machine       |
|                    |                    | remove-relation      |
|                    |                    | remove-ssh-key       |
|                    |                    | remove-unit          | 
|                    |                    | resolved             |
|                    |                    | retry-provisioning   |
|                    |                    | run                  |
|                    |                    | config               |
|                    |                    | set-constraints      | 
|                    |                    | model-config         |
|                    |                    | sync-agent-binaries  |
|                    |                    | unexpose             |
|                    |                    | upgrade-charm        |
|                    |                    | upgrade-model        |
