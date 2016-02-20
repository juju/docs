Title: Juju constraints  

# Constraints

Constraints constrain the possible instances that may be started by Juju
commands. They are usually passed as a flag to commands that provision a
new machine (such as bootstrap, deploy, and add-machine). See [using
constraints](charms-constraints.html) for how to specify these in a
deployment.

Each constraint defines a minimum acceptable value for a characteristic of a
machine.  Juju will provision the least expensive machine that fulfils all the
constraints specified.  Note that these values are the minimum, and the actual
machine used may exceed these specifications if one that exactly matches does
not exist.

If a constraint is defined that cannot be fulfilled by any machine in the
environment, no machine will be provisioned, and an error will be printed in the
machine's entry in Juju status.

Constraint defaults can be set on an environment or on specific services by
using the set-constraints command (see `juju help set-constraints`).  Constraints
set on the environment or on a service can be viewed by using the get-
constraints command.  In addition, you can specify constraints when executing a
command by using the --constraints flag (for commands that support it).

Constraints specified on the environment and service will be combined to
determine the full list of constraints on the machine(s) to be provisioned by
the command.  Service-specific constraints will override environment-specific
constraints, which override the Juju default constraints.

Constraints are specified as key value pairs separated by an equals sign, with
multiple constraints delimited by a space.


## Generic constraints


- arch

    Short name of architecture that a service must run on. Can be left
    blank to indicate any architecture is acceptable, or one of `amd64`,
    `arm`, `i386`, `arm64`, or `ppc64`.

- container

    Name of container type that a service unit must run inside. Can be
    left blank to indicate no preference, or one of `none` for
    uncontainerised, `lxc`, or `kvm`.

- cpu-cores

    Minimum number of effective CPU cores that must be available to a
    service unit.

- cpu-power

    Minimum amount of abstract CPU power that must be available to a
    service unit, where 100 units is roughly equivalent to "a single
    2007-era Xeon" as reflected by 1 Amazon ECU. 
    
    **Note:**  Not all providers support this constraint, use
    `cpu-cores` for portability.

- instance-type

    Cloud-specific instance-type name that a service used must be
    deployed on. Valid values vary by provider, and individual
    deployment in some cases. 
    
    **Note:**  When compatibility between clouds is desired, use
    corresponding values for `cpu-cores`, `mem`, and `root-disk`
    instead.

- mem

    Minimum number of megabytes of RAM that must be available to a
    service unit. An optional suffix of M/G/T/P indicates the value is
    mega-/giga-/tera-/peta- bytes.

- networks

    Comma-delimited list of networks that must be available to the
    machine. Networks that must not be available to the machine are
    prefixed with a "^". For example. "db,^dmz".
    Currently only supported by MaaS.

- root-disk

    Minimum amount of of disk space on the root drive on each service
    unit. The value is megabytes unless an optional suffix of M/G/T/P
    is used per the `mem` constraint. Additional storage that may be
    attached separately does not count towards this value.

- tags

    Comma-delimited tags assigned to the machine. Currently only
    supported by MaaS.

- spaces

    Spaces constraint allows specifying a list of Juju network space names a unit
    or machine needs access to. Both positive and negative (prefixed with "^")
    spaces can be in the list, separated by commas.

    Example: spaces=storage,db,^logging,^public (meaning, select machines connected
    to the storage and db spaces, but NOT to logging or public spaces).

    EC2 is the only provider supporting spaces constraints. Support for other
    providers is planned for future releases.

## Legacy constraints

In pre-1.0 Juju some additional or differently named constraints were
also supported, these need to be migrated when upgrading.

- cpu

    Number of CPU cores for most providers, but equivalent to an Amazon
    ECU on AWS. Use `cpu-cores` instead.

- ec2-zone

    EC2 availability zone that a service unit must be deployed into. No
    equivalent implemented as of Juju 1.12, follow [bug
    1183831](https://bugs.launchpad.net/juju-core/+bug/1183831).

- maas-name

    Specific MAAS machine name that a service unit must be deployed on.
    Use `maas-tags` instead by preference.

- maas-tags

    List of tags a MAAS machine must have for a service unit to be
    deployed on. See "tags" above.

- os-scheduler-hints

    Experimental constraint exposing Openstack-specific scheduler hints
    features. Do not use.
