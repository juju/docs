Title: Using constraints
TODO:  Include default resources for provisioned machine (i.e. no constraint used)

# Using constraints

A *constraint* is a user-defined minimum hardware specification for a machine
that is spawned by Juju. There are a total of nine constraints, with the most
common ones being 'mem', 'cores', 'root-disk', and 'arch'. Their meanings
should be self-explanatory. The definitive list is found on the
[Reference: Juju constraints][reference-constraints] page.

Here are some noteworthy characteristics of constraints:

 - Some constraints are only supported by certain clouds.
 - Changes to constraint defaults do not affect existing machines.
 - If an application is deployed with a constraint then any subsequently added
   unit will use the same constraint, unless overridden.

## How constraints work

In the simplest of terms, when Juju adds a constraint to the machine-creation
request the end result will be a system that has exactly those resources. In
reality, however, due to the nature of the chosen backing cloud, things rarely
work out so perfectly. In addition, Juju implements a sophisticated method for
how a user can configure constraints. This page will clarify how constraints
work.

### Satisfying a constraint

When the backing cloud is unable to satisfy the constraint precisely, the
resulting system's resources will exceed the constraint-defined minimum.
However, if the cloud cannot satisfy the constraint at all then an error will
be emitted and a machine will not be provisioned.

### Constraint scopes and precedence

On a controller basis, the following constraint scopes exist:

 - Controller machine
 - All models
 - Single model
 - Single application
 - Single machine

Constraints specified on the model and an application will be combined to
determine the full list of constraints. Application constraints will override
model constraints, which override any set default constraints.

To ignore any constraints which may have been previously set, you can assign a 
'null' value. 

#### Controller machine

Constraints that apply solely to the controller are set a controller-creation
time by using the `--bootstrap-constraints` option.

#### All models

Constraints that apply to all machines in the models managed by the controller,
but excluding the controller itself are set via the `--constraints` option.

#### Single model

Constraints that apply to all machines in the models managed by the controller,
but excluding the controller itself are set via the `--constraints` option.

#### Single application

Constraints that apply to all machines in the models managed by the controller,
but excluding the controller itself are set via the `--constraints` option.

#### Single machine

Constraints that apply to all machines in the models managed by the controller,
but excluding the controller itself are set via the `--constraints` option.

### Constraint defaults

Constraint defaults can be set on a per-controller basis, on a per-model basis
(`set-model-constraints`), or on a per-application basis (`set-constraints`).
Constraints set on the environment or on an application can be viewed by using
the get- constraints command. In addition, you can specify constraints when
executing a command by using the `--constraints` flag (for commands that
support it).
    
## Setting constraints for a controller

Constraints can be applied to a controller (machine) during its creation
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

## Setting and displaying constraints for a single model

A model's constraints are set, thereby affecting any subsequent machines, with
the `set-model-constraints` command:
 
```bash
juju set-model-constraints mem=4G
```

A model's constraints are displayed with the `get-model-constraints` command:

```bash
juju get-model-constraints
```

A model's constraints can be reset by assigning the null value to it:
 
```bash
juju set-model-constraints mem=
```

## Setting, displaying, and updating constraints for an application

An application's constraints are usually set at deploy time, with the `deploy`
command. To deploy the 'mariadb' charm to a machine that has at least 4 GiB of
memory:
  
```bash
juju deploy mariadb --constraints mem=4G
```

To deploy MySQL on a machine that has at least 6 GiB of memory and 2 CPUs:
  
```bash
juju deploy mysql --constraints "mem=6G cores=2"
```

!!! Note:
    Multiple constraints are space-separated and placed within quotation
    marks.

To deploy Apache and ensure its machine will have 4 GiB of memory (or more) as
well as ignore a possible `cores` constraint (previously set at either the
model or application level):
  
```bash
juju deploy apache2 --constraints "mem=4G cores=" 
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

There are two scenarios where you might want to specify a constraint when
adding a machine:

 1. You intend to later deploy a charm or bundle to the machine. Note that you
    can instead just specify the constraint during the deployment.
 1. You intend to scale out (`add-unit`) an existing application using a
    constraint that differs from that which was used for the initial
    deployment.

Once the machine is added look over
[Deploying to specific machines][charms-deploying-advanced-to-option] for
either of the above scenarios.

A machine can be added that satisfies a constraint:

```bash 
juju add-machine --constraints arch=arm
```

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
[charms-deploying-advanced-to-option]: ./charms-deploying-advanced.html#deploying-to-specific-machines
[reference-constraints]: ./reference-constraints.html
