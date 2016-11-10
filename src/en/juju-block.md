Title: Restricting changes to the running Juju environment

# Restricting changes to running models

Deployed models can be protected from unintentional changes by disabling
commands that can alter a model.

This is accomplished through the use of the `disable-command` with one of three
progressively restrictive groups of commands:

- destroy-model
- remove-object
- all

By disabling the `destroy-model` group, for instance, the user loses the ability
to destroy both the model and its controller. Specifying the `remove-object`
group adds to these restrictions by disabling the removal of machines,
relations, applications and units. The 'all` group disables the complete set of
commands that can change the configuration of a model.

To give the user some feedback on why a command might be disabled, an optional
'message' argument can be passed as part of the disable command.

For example, the following could be used to prevent execution of both the
`destroy-model` and `destroy-controller` commands:

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
```

## Re-enabling a command

The reverse of `disable-command` is `enable-command.` This can be used with
the corresponding group to restore a user's access to a group of commands: 

```bash
juju enable-command destroy-model
```
  
By default, these actions are performed against the currently selected
controller and model, but specific models can be targeted by using the
additional '-m' or '--model' argument.

If you need to list which commands have been disabled, use 'disabled-commands`:

```bash
juju disabled-commands
``` 

!!! Warning: In some cases, the disable command will only take effect after the
user has logged out of Juju and logged back in again.

## Command within each enable or disable group

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
|                    |                    | set-config           |
|                    |                    | set-constraints      | 
|                    |                    | set-model-config     |
|                    |                    | sync-tools           |
|                    |                    | unexpose             |
|                    |                    | unset-config         |
|                    |                    | unset-model-config   |
|                    |                    | upgrade-charm        |
|                    |                    | upgrade-juju         |

!!! Note: The '--force' option recognized by some Juju commands bypasses any
restriction level that would otherwise apply. If your policy is to use
restrictions then the immediate use of the '--force' option should not be part
of your workflow. If you must use it, do so after having first run the Juju
command without it to ensure you are aware of any possible restrictions.
