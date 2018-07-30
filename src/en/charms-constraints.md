Title: Using constraints
TODO:  Important: include default resources requested for non-constrained machine
       bug tracking: https://bugs.launchpad.net/juju/+bug/1768308
       Consider a diagram for the Defaults section

# Using constraints

A *constraint* is a user-defined minimum hardware specification for a machine
that is spawned by Juju. There are a total of nine types of constraint, with
the most common ones being 'mem', 'cores', 'root-disk', and 'arch'. The
definitive constraint resource is found on the
[Reference: Juju constraints][reference-constraints] page.

Several noteworthy constraint characteristics:

 - Some constraints are only supported by certain clouds.
 - Changes to constraint defaults do not affect existing machines.
 - Multiple constraints are logically AND'd (i.e. the machine must satisfy all
   constraints).

## Clouds and constraints

The idealized use case is that of stipulating a constraint when deploying an
application and the backing cloud providing a machine with those exact
resources. In the majority of cases, however, default constraints may have been
set (at various levels) and the cloud is unable to supply those exact
resources.

When the backing cloud is unable to precisely satisfy a constraint, the
resulting system's resources will exceed the constraint-defined minimum.
However, if the cloud cannot satisfy a constraint at all then an error will be
emitted and a machine will not be provisioned.

### Constraints and the LXD cloud

For the 'lxd' cloud type things are different. With this cloud, constraints
are interpreted as resource maximums as opposed to minimums. In the absence of
constraints, a machine (container) will, by default, have access to **all** of
the underlying system's (LXD host) resources.

This cloud type also honours instance constraints where 
[AWS instance type][aws-instance-types-kirkland] names are used (e.g.
't2.micro' maps to 1 CPU and 1 GiB of memory). When used in combination with
specific CPU/MEM constraints the latter values will override corresponding
instance type values.

!!! Warning:
    Due to the different meaning of constraints in the context of a LXD
    cloud, care must be taken when using commands in which the cloud type is
    not called out.
    
## Constraint scopes, defaults, and precedence

Constraints can be applied to various levels or scopes. Defaults can be set on
some of them, and in the case of overlapping configurations a precedence is
adhered to.

On a per-controller basis, the following constraint **scopes** exist:

 - Controller machine
 - All models
 - Single model
 - Single application
 - All units of an application
 - Single machine

So a constraint can apply to any of the above. We will see how to target each
later on.

Among the scopes, **default** constraints can be set for each with the
exception of the controller and single machines.

The all-units scope has its default set dynamically. It is the possible
constraint used in the initial deployment of the corresponding application.

The following **precedence** is observed (in order of priority):

 - Machine
 - Application (and its units)
 - Model
 - All models
 
For instance, if a default constraint ('mem') applies to a single model and
the same constraint has been stipulated when adding a machine (`add-machine`)
within that model then the machine's constraint value will be applied.

The dynamic default for units can be overridden by either setting the
application's default or by adding a machine with a constraint and then
applying the new unit to that machine.

## Setting constraints for a controller

Constraints are applied to the controller during its creation using the
`--bootstrap-constraints` option:

```bash
juju bootstrap --bootstrap-constraints cores=2 google
```

Here, we want to ensure that the controller has at least two CPUs.

See [Creating a controller][controllers-creating] for details and further
examples.

!!! Note:
    Constraints applied with '--bootstrap-constraints' will automatically apply
    to any future controllers provisioned for high availability (HA). See
    [Controller high availability][controllers-ha].

## Setting constraints for all models

Constraints can be applied to all models by, again, stating them during the
controller-creation process, but using the `--constraints` option instead:

```bash
juju bootstrap --constraints mem=4G aws
```

Above, we want every machine in every model to have a minimum of four GiB of
memory.

See [Creating a controller][controllers-creating] for more guidance.

!!! Important:
    The `--constraints` option also affects the controller. Individual
    constraints from `--bootstrap-constraints` override any identical
    constraints from `--constraints`.

For the LXD cloud, the following invocation will place a **limit** of 2GiB of
memory for each machine:

```bash
juju bootstrap --constraints mem=2G localhost
```

## Setting and displaying constraints for a model

A model's constraints are set, thereby affecting any subsequent machines in
that model, with the `set-model-constraints` command:
 
```bash
juju set-model-constraints mem=4G
```

For the LXD cloud, all new machines in the current model will be limited
to an instance type of 'c5.large' (2 CPU and 4 GiB):

```bash
juju set-model-constraints instance-type=c5.xlarge
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

Constraints at the application level can be set at deploy time, via the
`deploy` command. To deploy the 'mariadb' charm to a machine that has at least
4 GiB of memory:
  
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

For the LXD cloud, we deploy PostgreSQL using a combination of an instance type
and a specific CPU constraint. Instance 'c5.large' maps to 2 CPU and 4 GiB but
the specific memory constraint of 3.5 GiB yields a machine with 2 CPUs and 3.5
GiB of memory:

```bash
juju deploy postgresql --constraints "mem=3.5G instance-type=c5.large"
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

An application's default cannot be set until the application has been deployed.

!!! Note:
    Both the `get-constraints` and `set-constraints` commands work with
    application custom names. See [Deploying applications][charms-deploying]
    for how to set a custom name.

## Setting constraints when adding a machine

Constraints at the machine level can be set when adding a machine with the
`add-machine` command. Doing so provides a way to override defaults at the
all-units, application, model, and all-models levels.

Once such a machine has been provisioned it can be used for an initial
deployment (`deploy`) or a scale out deployment (`add-unit`). See
[Deploying to specific machines][charms-deploying-advanced-to-option] for
the command syntax to use.
 
A machine can be added that satisfies a constraint in this way:

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

To get a maximum of two CPUs for a machine in a LXD cloud:

```bash
juju add-machine --constraints cores=2
```


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.md
[controllers-creating]: ./controllers-creating.md
[network-spaces]: ./network-spaces.md
[charms-deploying-advanced-to-option]: ./charms-deploying-advanced.md#deploying-to-specific-machines
[reference-constraints]: ./reference-constraints.md
[controllers-ha]: ./controllers-ha.md
[aws-instance-types-kirkland]: https://github.com/dustinkirkland/instance-type/blob/master/yaml/aws.yaml
