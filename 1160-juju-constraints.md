<!--
Todo:
- Add constraints info for Oracle and Rackspace
- Confirm/explain: different clouds also dictate constraints that would conflict with other clouds and cannot be used in combination.
- Rethink: Cloud difference section (include examples of things that work?)
-->

Constraints are minimum requirements for machines that are created on behalf of Juju. They are passed as options to commands that either provision a new machine directly or are set as defaults for new machines at the controller, model, or application level.

This reference page lists all the constraints that can be used with Juju.

For in-depth coverage and examples see the [Using constraints](/t/using-constraints/1060) page in the user guide.

<h2 id="heading--generic-constraints">Generic constraints</h2>

- `arch`
Architecture. Values include 'amd64', 'arm', 'i386', 'arm64', or 'ppc64'.

- `cores`
Effective CPU cores. An integer.

- `cpu-power`
Abstract CPU power. An integer, where 100 units is roughly equivalent to "a single 2007-era Xeon" as reflected by 1 Amazon vCPU. In a Kubernetes context a unit of "milli" is implied.

    **Note:** Not supported by all providers. Use `cores` for portability.

- `instance-type`
Cloud-specific instance-type name. Values vary by provider, and individual deployment in some cases.

    **Note:** When compatibility between clouds is desired, use corresponding values for `cores`, `mem`, and `root-disk` instead.

- `mem`
Memory (MiB). An optional suffix of M/G/T/P indicates the value is mega-/giga-/tera-/peta- bytes.

- `root-disk`
Disk space on the root drive (MiB). An optional suffix of M/G/T/P is used as per the `mem` constraint. Additional storage that may be attached separately does not count towards this value.

- `root-disk-source` (`v.2.5.3`)
Name of storage object which houses the root disk.

  **Note:** Supported by the vSphere and OpenStack providers. For vSphere, specify a datastore. For OpenStack, use the string `volume` to use Cinder block storage volumes.

- `tags`
Comma-delimited tags assigned to the machine. Tags can be positive, denoting an attribute of the machine, or negative (prefixed with "^"), to denote something that the machine does not have.

  Example: tags=virtual,^dualnic

  **Note:** Currently only supported by the MAAS provider.

- `spaces`
A comma-delimited list of Juju network space names that a unit or machine needs access to. Space names can be positive, listing an attribute of the space, or negative (prefixed with "^"), listing something the space does not have.

  Example: spaces=storage,db,^logging,^public (meaning, select machines connected to the storage and db spaces, but NOT to logging or public spaces).

    **Note:** EC2 and MAAS are the only providers that currently support the spaces constraint.

- `virt-type`
Virtualization type, such as 'kvm'.

- `zones`
A list of availability zones. Values vary by provider. Multiple values present a range of zones that a machine must be created within.

  Example: zones=us-east-1a,us-east-1c

    **Note:** A zone can also be used as a placement directive (`--to` option).

<h2 id="heading--cloud-differences">Cloud differences</h2>

Constraints cannot be applied towards a backing cloud in an agnostic way. That is, a particular cloud type may support some constraints but not others. Also, even if two clouds support a constraint, sometimes the constraint **value** may work with one cloud but not with the other. The list below addresses the situation.

<h3 id="heading--azure">Azure:</h3>

- Unsupported: [cpu-power, tags, virt-type, root-disk-source]
- Valid values: arch=[amd64]; instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cpu-cores, arch]

<h3 id="heading--cloudsigma">CloudSigma:</h3>

- Unsupported: [instance-type, tags, virt-type, root-disk-source]

<h3 id="heading--ec2">EC2:</h3>

- Unsupported: [tags, virt-type, root-disk-source]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cpu-cores, cpu-power]

<h3 id="heading--gce">GCE:</h3>

- Unsupported: [tags, virt-type, root-disk-source]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [arch, cpu-cores, cpu-power, mem]

<h3 id="heading--lxd">LXD:</h3>

- Unsupported: [cpu-power, tags, virt-type, root-disk-source]
- Valid values: arch=[host arch]

<h3 id="heading--maas">MAAS:</h3>

- Unsupported: [cpu-power, instance-type, virt-type, root-disk-source]
- Valid values: arch=[defined on the cloud]

<h3 id="heading--manual">Manual:</h3>

- Unsupported: [cpu-power, instance-type, tags, virt-type, root-disk-source]
- Valid values: arch=[for controller - host arch; for other machine - arch from machine hardware]

<h3 id="heading--openstack">OpenStack:</h3>

- Unsupported: [tags, cpu-power, root-disk-source]
- Valid values: instance-type=[defined on the cloud]; virt-type=[kvm,lxd]
- Conflicting constraints: [instance-type] vs [mem, root-disk, cpu-cores]

<h3 id="heading--vsphere">vSphere:</h3>

- Unsupported: [tags, virt-type]
