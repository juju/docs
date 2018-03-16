Title: Constraints | Reference
TODO:  Add constraints info for Oracle and Rackspace

# Constraints

Constraints set minimum requirements on the instances that are created on
behalf of Juju. They are usually passed as options to commands that provision a
new machine (such as `bootstrap`, `deploy`, and `add-machine`). The
[Using constraints][charms-constraints] page describes how this is done.

## Satisfying constraints

So each constraint defines a minimum value for a characteristic of a machine.
One way of looking at this is that Juju will provision the least expensive
machine that fulfils the criteria specified by the Juju operator.

Note that the resulting machine may exceed these specifications if the backing
cloud is unable to satisfy them precisely. If a constraint cannot be satisfied
by the cloud then no machine will be provisioned, and an error will be emitted
(and show up in the output to `juju status`).

Constraint defaults can be set on a per-controller basis, on a per-model
basis, or on an application basis. by
using the `set-constraints` command. Constraints set on the environment or on
an application can be viewed by using the get- constraints command. In
addition, you can specify constraints when executing a command by using the
`--constraints` flag (for commands that support it).

Constraints specified on the environment and an application will be combined to
determine the full list of constraints on the machine(s) to be provisioned by
the command. Application-specific constraints will override environment-specific
constraints, which override the juju default constraints.

Constraints are specified as key value pairs separated by an equals sign, with
multiple constraints delimited by a space.


## Generic constraints


- arch

    Short name of architecture that an application must run on. Can be left
    blank to indicate any architecture is acceptable, or one of `amd64`,
    `arm`, `i386`, `arm64`, or `ppc64`.

- cores

    Minimum number of effective CPU cores that must be available to an
    application unit.

- cpu-power

    Minimum amount of abstract CPU power that must be available to an
    application unit, where 100 units is roughly equivalent to "a single
    2007-era Xeon" as reflected by 1 Amazon vCPU. 
    
    **Note:**  Not all providers support this constraint, use
    `cores` for portability.

- instance-type

    Cloud-specific instance-type name that an application used must be
    deployed on. Valid values vary by provider, and individual
    deployment in some cases. 
    
    **Note:**  When compatibility between clouds is desired, use
    corresponding values for `cores`, `mem`, and `root-disk`
    instead.

- mem

    Minimum number of megabytes of RAM that must be available to an
    application unit. An optional suffix of M/G/T/P indicates the value is
    mega-/giga-/tera-/peta- bytes.

- root-disk

    Minimum amount of of disk space on the root drive on each application
    unit. The value is megabytes unless an optional suffix of M/G/T/P is used
    per the `mem` constraint. Additional storage that may be attached
    separately does not count towards this value.

- tags

    Comma-delimited tags assigned to the machine. Tags can be positive, 
    denoting an attribute of the machine, or negative (prefixed with "^"),
    to denote something that the machine does not have. Currently only
    supported by MAAS.

    Example: tags=virtual,^dualnic

- spaces

    Permits specifying a comma-delimited list of Juju network space names
    that a unit or machine needs access to. Space names can be positive,
    listing an attribute of the space, or negative (prefixed with "^"),
    listing something the space does not have, separated by commas.

    Example: spaces=storage,db,^logging,^public (meaning, select machines connected
    to the storage and db spaces, but NOT to logging or public spaces).

    EC2 and MAAS are the only providers that support the spaces constraint.
    Support in other providers is planned for future releases.

- virt-type

    Specifies the type of virtualization to be used, such as `kvm`.


## Cloud differences

Constraints cannot be applied towards a backing cloud in an agnostic way. That
is, a particular cloud type may support some constraints but not others. Also,
even if two clouds support a constraint, sometimes the constraint value may
work with one cloud but not with the other. All this is the natural consequence
of Juju striving to support widely differing cloud types. The list below
addresses the situation.

<!-- EXPLANATION REQUIRED
Sometimes, different clouds also dictate constraints that would conflict with
other clouds and cannot be used in combination.
-->

### Azure:
- Unsupported: [cpu-power, tags, virt-type]
- Valid values: arch=[amd64]; instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cpu-cores, arch]

### CloudSigma:
- Unsupported: [instance-type, tags, virt-type]

### EC2:
- Unsupported: [tags, virt-type]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cpu-cores, cpu-power]

### GCE:
- Unsupported: [tags, virt-type]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [arch, cpu-cores, cpu-power, mem]

### Joyent:
- Unsupported: [cpu-power, tags, virt-type]
- Valid values: instance-type=[defined on the cloud]

### LXD:
- Unsupported: [cpu-cores, cpu-power, instance-type, tags, virt-type]
- Valid values: arch=[host arch]

### MAAS:
- Unsupported: [cpu-power, instance-type, virt-type]
- Valid values: arch=[defined on the cloud]

### Manual:
- Unsupported: [cpu-power, instance-type, tags, virt-type]
- Valid values: arch=[for controller - host arch; for other machine - arch from machine hardware]

### OpenStack:
- Unsupported: [tags, cpu-power]
- Valid values: instance-type=[defined on the cloud]; virt-type=[kvm,lxd]
- Conflicting constraints: [instance-type] vs [mem, root-disk, cpu-cores]

<!-- MISSING
### Oracle:
### Rackspace:
-->

### vSphere:
- Unsupported: [tags, virt-type]


<!-- LINKS -->

[charms-constraints]: ./charms-constraints.html
