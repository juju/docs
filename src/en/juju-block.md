Title: Using Juju block to prevent accidental changes  

# Restricting changes to the running Juju environment

Changes to a running Juju environment can be restricted in order to prevent accidental
changes.

There are three accumulative levels of restrictions that can be applied:

- destroy-environment
- remove-object
- all-changes

These are applied and removed with the 'block' and 'unblock' commands.


## Understanding and applying restrictions

### destroy-environment

This level blocks just the 'destroy-environment' command. You can therefore
prevent an environment from being destroyed like this:

```bash
juju block destroy-environment
```

### remove-object

This level includes the 'destroy-environment' level and adds more restrictions.
In total, it prevents the following commands from being run:

- destroy-environment
- remove-machine
- remove-relation
- remove-service
- remove-unit

This restriction level gets applied in this way:

```bash
juju block remove-object
```

### all-changes

This level includes the 'remove-object' level and adds more restrictions. In
total, it prevents the following commands from being run:

- add-machine
- add-relation
- add-unit
- authorised-keys add
- authorised-keys delete
- authorised-keys import
- deploy
- destroy-environment
- ensure-availability
- expose
- resolved
- remove-machine
- remove-relation
- remove-service
- remove-unit
- retry-provisioning
- run
- set
- set-constraints
- set-env
- unexpose
- unset
- unset-env
- upgrade-charm
- upgrade-juju
- user add
- user change-password
- user disable
- user enable

This restriction level gets applied in this way:

```bash
juju block all-changes
```

## Adding restrictions via environments.yaml

You have the option of setting restriction levels via environments.yaml instead
of using the 'block' command.

The three (Boolean) parameters corresponding to the three levels are:

- block-destroy-environment
- block-remove-object
- block-all-changes

See the full
[list of configuration parameters](config-general.html#alphabetical-list-of-general-configuration-values).


## Removing restrictions

When a change is being blocked that you are certain you need to make, you can
remove the block using the 'unblock' command.

For example, to permit the 'remove-relation' command currently blocked by the
'remove-object' restriction level, run:

```bash
juju unblock remove-object
```

Typically you would restore the block after having made the change.

!!! Note: The '--force' option recognized by some Juju commands bypasses any
restriction level that would otherwise apply. If your policy is to use
restrictions then the immediate use of the '--force' option should not be part
of your workflow. If you must use it, do so after having first run the Juju
command without it to ensure you are aware of any possible restrictions.

For more information run ```juju help block``` and ```juju help unblock```.
