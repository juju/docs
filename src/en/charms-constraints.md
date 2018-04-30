Title: Using constraints

# Using constraints

A *constraint* is a user-defined minimum hardware specification for a machine
that is spawned by Juju. There is a total of nine constraints and they are
listed on the [Reference: Juju constraints][reference-constraints] page.

Here is a summary of the characteristics of constraints:

 - Some constraints are only supported by certain clouds.

## How constraints work

### Satisfying a constraint

When Juju causes a machine to be created, the resulting machine will exceed the
constraint-defined minimum if the backing cloud is unable to satisfy the
constraint precisely. However, if the cloud cannot satisfy the constraint at
all then an error will be emitted and a machine will not be provisioned.

### Constraint scopes

Constraints may be set during the creation of the controller and are used to
set minimum specifications for Juju machines. Constraints that apply to all
machines in the models managed by the controller, but excluding the controller
itself, are known as **model constraints**. These are set via the
`--constraints` option. Constraints that apply to solely the controller are
known as **controller constraints** and are set by using the
`--bootstrap-constraints` option. The same values can be used by either type.

### Constraint defaults

Constraint defaults can be set on a per-controller basis, on a per-model basis
(`set-model-constraints`), or on a per-application basis (`set-constraints`).
Constraints set on the environment or on an application can be viewed by using
the get- constraints command. In addition, you can specify constraints when
executing a command by using the `--constraints` flag (for commands that
support it).

### Constraint precedence 

Constraints specified on the environment and an application will be combined to
determine the full list of constraints on the machine(s) to be provisioned by
the command. Application-specific constraints will override environment-specific
constraints, which override the juju default constraints.

Constraints may be set for models and
applications, with application constraints taking precedence. Changes to
constraints do not affect any units which have already been placed on machines.

To ignore any constraints which may have been previously set, you can assign a 
'null' value. 

### Adding a machine with constraints

There are two scenarios where you might want to specify a constraint when
adding a machine (`juju add-machine`):

 1. You intend to later deploy a charm or bundle (`juju deploy`) to the
    machine. Note that you can also simply specify the constraint during the
    deployment.
 1. You intend to scale out an application (`juju add-unit`) using a different
    constraint that was used during the initial deployment. Note that
    constraints are, by default, preserved on a per-application basis.

## Setting constraints when deploying a charm

To deploy the 'mariadb' charm to a machine that has at least 4 GiB of memory:
  
```bash
juju deploy mariadb --constraints mem=4G
```

To deploy MySQL on a machine that has at least 6 GiB of memory and 2 CPUs:
  
```bash
juju deploy mysql --constraints "mem=6G cores=2"
```

To deploy Apache and ensure its machine will have 4 GiB of memory (or more) as
well as ignore a possible `cores` constraint (previously set at either the
model or application level):
  
```bash
juju deploy apache2 --constraints "mem=4G cores=" 
```
    
## Setting constraints for a controller

Constraints can be applied to a controller during its creation
(`juju bootstrap`) by using the `--bootstrap-constraints` option. See
[Creating a controller][controllers-creating] for details and examples.

## Setting constraints for all models

All models within a controller can have their constraints set during the
controller-creation process by applying the `--constraints` option to the
`bootstrap` command. See [Creating a controller][controllers-creating] for
guidance on doing this.

Default model constraints can be overridden for specific models, applications,
or machines, as detailed below.

Model-related constraints can also be overridden at the application and machine
level.

## Setting constraints for a single model

To set a memory constraint at the model level so any machines created within it
will also have the constraint assigned:
  
```bash
juju set-model-constraints mem=4G
```

Current model constraints can be shown with:

```bash
juju get-model-constraints
```

Reset a model constraint by assigning the null value to it:
 
```bash
juju set-model-constraints mem=
```

## Setting, displaying, and updating constraints for an application

An application's constraints are usually set at deploy time, with the `deploy`
command:
  
```bash
juju deploy mariadb cores=4
```

An application's current constraints are displayed with the `get-constraints`
command:
 
```bash
juju get-constraints mariadb
```

An application's constraints are updated, thereby affecting any additional
units, with the `set-constraints` command:
  
```bash
juju set-constraints mariadb cores=2
```

!!! Note:
    Both the `get-constraints` and `set-constraints` commands work with
    application custom names. See [Deploying applications][charms-deploying]
    for how to set a custom name.
    
## Setting constraints when adding a machine

A machine can be added that satisfies a constraint:

```bash 
juju add-machine --constraints arch=arm
```

You can subsequently deploy applications to that specific machine. See
[Deploying to specific machines][charms-deploying-to-option] for how to do
this.

To add a machine that is connected to a space, such as 'storage':

```bash 
juju add-machine --constraints spaces=storage
```

If a space constraint is prefixed by '^' then the machine will **not** be
connected to that space. For example, given the following:

```no-highlight
--constraints spaces=db-space,^storage,^dmz,internal
```

the resulting instance will be connected to both the 'db-space' and 'internal'
spaces, and not connected to either the 'storage' or 'dmz' spaces.

See the [Network spaces][network-spaces] page for details on spaces.


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.html
[controllers-creating]: ./controllers-creating.html
[network-spaces]: ./network-spaces.html
[charms-deploying-to-option]: ./charms-deploying-advanced.html#deploying-to-specific-machines
[reference-constraints]: ./reference-constraints.html
