[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Constraints

Complete listing of constraints supported by juju and what they mean. See [using
constraints](charms-constraints.html) for how to specify these in a deployment.

## Generic constraints

arch

    Short name of architecture that a service must run on. Can be left blank to indicate any architecture is acceptable, or one of `amd64`, `arm`, or `i386`.
container

    Name of container type that a service unit must run inside. Can be left blank to indicate no preference, or one of `none` for uncontainerised, `lxc`, or `kvm`.
cpu-cores

    Minimum number of effective CPU cores that must be available to a service unit.
cpu-power

    Minimum amount of abstract CPU power that must be available to a service unit, where 100 units is roughly equivalent to "a single 2007-era Xeon" as reflected by 1 Amazon ECU. **Warning: Not all providers support this constraint, use `cpu-cores` for portability.**
mem

    Minimum number of megabytes of RAM that must be available to a service unit. An optional suffix of M/G/T/P indicates the value is mega-/giga-/tera-/peta- bytes.
root-disk

    Minimum amount of of disk space on the root drive on each service unit. Additional storage that may be attached separately does not count towards this value.
tags

    Comma-delimited tags assigned to the machine. Currently only supported by MaaS.

## Legacy constraints

In pre-1.0 juju some additional or differently named constraints were also
supported, these need to be migrated when upgrading.

cpu

    Number of CPU cores for most providers, but equivalent to an Amazon ECU on AWS. Use `cpu-cores` instead.
instance-type

    Cloud-specific instance-type name that a service used must be deployed on. Valid values vary by provider, and individual deployment in some cases. Use appropriate values for `cpu-count`, `mem`, and `root-disk` instead where possible for portability.
ec2-zone

    EC2 availability zone that a service unit must be deployed into. No equivalent implemented as of juju 1.12, follow [bug 1183831](https://bugs.launchpad.net/juju-core/+bug/1183831).
maas-name

    Specific MAAS machine name that a service unit must be deployed on. Use `maas-tags` instead by preference.
maas-tags

    List of tags a MAAS machine must have for a service unit to be deployed on. See "tags" above.
os-scheduler-hints

    Experimental constraint exposing Openstack-specific scheduler hints features. Do not use.

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

