Title: Constraints

# Constraints

Constraints set limits on the possible instances that may be started by Juju
commands. They are usually passed as a flag to commands that provision a
new machine (such as bootstrap, deploy, and add-machine). See [using
constraints](charms-constraints.html) for how to specify these in a
deployment.

Each constraint defines a minimum acceptable value for a characteristic of a
machine. Juju will provision the least expensive machine that fulfils all the
constraints specified. Note that these values are the minimum, and the actual
machine used may exceed these specifications if one that exactly matches does
not exist.

If a constraint is defined that cannot be fulfilled by any machine in the
environment, no machine will be provisioned, and an error will be printed in the
machine's entry in juju status.

Constraint defaults can be set on an environment or on specific applications by
using the set-constraints command (see `juju help set-constraints`). Constraints
set on the environment or on an application can be viewed by using the get-
constraints command. In addition, you can specify constraints when executing a
command by using the `--constraints` flag (for commands that support it).

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

- container

    Name of container type that an application unit must run inside. Can be
    left blank to indicate no preference, or one of `none` for
    uncontainerised or `lxc``.

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

Different clouds support different constraints and sometimes different
values for these constraints. Sometimes, different clouds also dictate
constraints that would conflict with other clouds and cannot be used
in combination. Use this list to help you understand the differing needs.

###Azure Provider:
- Unsupported: [cpu-power, tags, virt-type]
- Valid values: arch=[amd64]; instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cpu-cores, arch]

###Cloudsigma (currently behind development flag):
- Unsupported: [container, instance-type, tags, virt-type]

###EC2 Provider:
- Unsupported: [tags, virt-type]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cpu-cores, cpu-power]

###GCE Provider:
- Unsupported: [tags, virt-type]
- Valid values: instance-type=[defined on the cloud]; container=kvm
- Conflicting constraints: [instance-type] vs [arch, cpu-cores, cpu-power, mem, container]

###Joyent Provider:
- Unsupported: [cpu-power, tags, virt-type]
- Valid values: instance-type=[defined on the cloud]

###LXD Provider:
- Unsupported: [cpu-cores, cpu-power, instance-type, tags, virt-type]
- Valid values: arch=[host arch]

###MAAS Provider:
- Unsupported: [cpu-power, instance-type, virt-type]
- Valid values: arch=[defined on the cloud]

###Manual Provider:
- Unsupported: [cpu-power, instance-type, tags, virt-type]
- Valid values: arch=[for controller - host arch; for other machine - arch from machine hardware]

###Openstack Provider:
- Unsupported: [tags, cpu-power]
- Valid values: instance-type=[defined on the cloud]; virt-type=[kvm,lxd]
- Conflicting constraints: [instance-type] vs [mem, root-disk, cpu-cores]

###VSphere Provider:
- Unsupported: [tags, virt-type]
