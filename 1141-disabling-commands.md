Commands can be disabled **on a per-model basis** to defend against unintentional changes. This is accomplished through the use of the `disable-command` command with one of three increasingly restrictive command groups as an argument:

- `destroy-model`
   This group disables the ability to destroy both the model and its controller.
- `remove-object`
   This group includes the previous group's restrictions and also disables the removal of machines, relations, applications, and units.
- `all`
   This group includes the previous group's restrictions and disables all commands that can change the configuration of a model.

For example:

```text
juju disable-command destroy-model
```

The table [below](#heading--command-groups) lists all affected commands per group.

## Adding a message

To give users an idea as to why a command is disabled, a message can be passed.

For example:

```text
juju disable-command destroy-model "Check with SA before destruction."
```

If a user now attempts to destroy a protected model, they'd encounter an error similar to the following:

```text
Destroying model
ERROR cannot destroy model: Check with SA before destruction.

destroy-model operation has been disabled for the current model.
To enable the command run

    juju enable-command destroy-model
```

<h2 id="heading--re-enabling-a-command-group">Re-enabling a command group</h2>

To re-enable a command group the `enable-command` is used.

For example:

```text
juju enable-command destroy-model
```

<h2 id="heading--listing-disabled-command-groups">Listing disabled command groups</h2>

To list which command groups are disabled, use `disabled-commands`:

```text
juju disabled-commands
```

Example output:

```text
Disabled commands  Message
all
```

<h2 id="heading--command-groups">Command groups</h2>

This is the list of commands for each of the three command groups.

The `kill-controller` command cannot be blocked.

| destroy-model      | remove-object      | all                  |
|--------------------|--------------------|----------------------|
| destroy-controller | destroy-controller | add-relation         |
| destroy-model      | destroy-machine    | add-ssh-key          |
|                    | destroy-model      | add-unit             |
|                    | detach-storage     | add-user             |
|                    | remove-application | attach-storage       |
|                    | remove-machine     | change-user-password |
|                    | remove-relation    | config               |
|                    | remove-saas        | consume              |
|                    | remove-storage     | deploy               |
|                    | remove-unit        | destroy-controller   |
|                    |                    | destroy-model        |
|                    |                    | disable-user         |
|                    |                    | enable-ha            |
|                    |                    | enable-user          |
|                    |                    | expose               |
|                    |                    | import-filesystem    |
|                    |                    | import-ssh-key       |
|                    |                    | model-config         |
|                    |                    | model-defaults       |
|                    |                    | remove-application   |
|                    |                    | remove-machine       |
|                    |                    | remove-relation      |
|                    |                    | remove-ssh-key       |
|                    |                    | remove-unit          |
|                    |                    | remove-user          |
|                    |                    | resolved             |
|                    |                    | retry-provisioning   |
|                    |                    | run                  |
|                    |                    | set-constraints      |
|                    |                    | set-credential       |
|                    |                    | set-series           |
|                    |                    | sync-agent-binaries  |
|                    |                    | unexpose             |
|                    |                    | upgrade-charm        |
|                    |                    | upgrade-model        |

[note]
The above list was updated for `v.2.6.0`.
[/note]
