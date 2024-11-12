(constraint)=
# Constraint

<!--
> - {ref}``juju bootstrap --bootstrap-constraints` <6184md>`
> - {ref}``juju bootstrap --constraints` <6184md>`
> - {ref}``juju deploy --constraints` <6184md>`
> - {ref}``juju add-machine --constraints` <6184md>`
> - {ref}``juju constraints` <6184md>`
> - {ref}``juju model-constraints` <6184md>`
> - {ref}``juju set-constraints` <6184md>`
> - {ref}``juju set-model-constraints` <6184md>`
-->

<!--REMOVING BECAUSE IT'S DEPRECATED:
> - {ref}`How to manage constraints <6184md>`
-->

In Juju, a **constraint** is a key-value pair that represents a specification that can be passed to certain `juju` commands /command flags to customise the hardware resources (bare metal machines, virtual machines, system containers, Kubernetes containers) spawned by Juju. 

If the resource is a bare metal machine or a virtual machine, a constraint represents a minimum, whereas if the resource is a system container or a Kubernetes container it represents a maximum.

For machine (non-Kubernetes) clouds, constraints can be set directly on individual {ref}`machines <machine>`. However, more commonly they are set at the level of the {ref}`controller <controller>`, {ref}`model <model>`, or {ref}`application <application>`. If you set constraints at multiple levels at once -- that is, with overlap -- the constraint applied at the more specific level takes precedence.

The rest of this document describes all the existing constraints.

```{caution}

Some of these keys -- their availability and their meaning -- vary from one cloud to another. Below this is indicated with a generic note. For specifics see {ref}`List of supported clouds > `<cloud name>` <list-of-supported-clouds>`.

```

<!--
A constraint is a specification that operators indicate to Juju. When adding units, Juju attempts to use the smallest instance type on the cloud that satisfies all of the constraints.

Constraints are not specific to individual machines, but the whole application. Constraints can also be applied during the bootstrap process.
-->


<!--FROM THE ABOUT DOC. TODO: INTEGRATE ABOVE.
<a href="#heading--introduction"><h2 id="heading--introduction">Introduction</h2></a>

A *constraint* is a user-defined hardware specification for a machine that is spawned by Juju. There are  in all ten types of constraints, with the most common ones being `mem`, `cores`, `root-disk`, and `arch`. The definitive constraint resource is found on the https://juju.is/docs/olm/constraints-reference page.

Several noteworthy constraint characteristics:

-   A constraint can be specified whenever a new machine is spawned with the command `bootstrap`, `deploy`, or `add-machine`.
-   Some constraints are only supported by certain clouds.
-   When used with `deploy`, the constraint becomes the application's default constraint.
-   Multiple constraints are logically ANDs (i.e., the machine must satisfy all constraints).
-   When used in conjunction with a placement directive (the `--to` option), the placement directive takes precedence.
-->

**Contents:**

- [List of constraints](#heading--list-of-constraints)	

<a href="#heading--list-of-constraints"><h2 id="heading--list-of-constraints">List of constraints</h2></a>

<!--Source: https://github.com/juju/juju/blob/develop/core/constraints/constraints.go#L23 -->

|||
|---|---|
| <a href="#heading--allocate-public-ip"><h4 id="heading--allocate-public-ip">`allocate-public-ip`</h4></a>| Supplying this constraint will determine whether machines are issued an IP address accessible outside of the cloud's virtual network.  <p> **Valid values:** `true`, `false`. <p> **Note:** Applies to public clouds (GCE, EC2, Azure) and OpenStack. Public cloud instances are assigned a public IP by default.|
| <a href="#heading--arch"><h4 id="heading--arch">`arch`</h4></a>|The architecture. <br> <br>**Valid values:** `amd64`, `arm64`, `ppc64el`, `s390x`, `riscv64`.|
| <a href="#heading--container"><h4 id="heading--container">`container`</h4></a>| Indicates that a machine must be the specified container type. <p> **Valid values:** `lxd`, `kvm`. |
| <a href="#heading--cores"><h4 id="heading--cores">`cores`</h4></a>|Number of effective CPU cores. <br> <br> **Type:** integer. <br> <br> **Alias:** `cpu-cores`.|
| <a href="#heading--cpu-power"><h4 id="heading--cpu-power">`cpu-power`</h4></a>|Abstract CPU power. <br> <br> **Type:** integer, where 100 units is roughly equivalent to "a single 2007-era Xeon" as reflected by 1 Amazon vCPU. In a Kubernetes context a unit of "milli" is implied. <p> **Note:** Not supported by all providers. Use `cores` for portability.|
| <a href="#heading--image-id"><h4 id="heading--image-id">`image-id`</h4></a> | (Starting with `3.2`) The image ID. If not nil, indicates that a machine must use the specified image. <br> <br> **Note:** Not supported by all providers. Value is provider-specific.  Also, when applied during `juju deploy`, must be used in conjunction with the `--base` flag of the command -- the `image-id` will specify the image to be used for the provisioned machines and the `--base` will specify the charm revision to be deployed on those machines. |
| <a href="#heading--instance-role"><h4 id="heading--instance-role">`instance-role`</h4></a>| Indicates that the specified role/profile for the given cloud should be used.  <p> **Note:** Only valid for clouds which support instance roles. Currently only for AWS with instance profiles and (starting with Juju 3.6) for Azure with managed identities. |
| <a href="#heading--instance-type"><h4 id="heading--instance-type">`instance-type`</h4></a>|Cloud-specific instance-type name. Values vary by provider, and individual deployment in some cases. <p> **Note:** When compatibility between clouds is desired, use corresponding values for `cores`, `mem`, and `root-disk` instead.|
| <a href="#heading--mem"><h4 id="heading--mem">`mem`</h4></a>|Memory (MiB). An optional suffix of M/G/T/P indicates the value is mega-/giga-/tera-/peta- bytes.|
| <a href="#heading--root-disk"><h4 id="heading--root-disk">`root-disk`</h4></a>|Disk space on the root drive (MiB). An optional suffix of M/G/T/P is used as per the `mem` constraint. Additional storage that may be attached separately does not count towards this value.|
| <a href="#heading--root-disk-source"><h4 id="heading--root-disk-source">`root-disk-source`</h4></a>|Name of the storage pool or location the root disk is from. <p> **Note:** `root-disk-source` has different behaviour with each provider. |
| <a href="#heading--spaces"><h4 id="heading--spaces">`spaces`</h4></a>|A comma-delimited list of Juju network space names that a unit or machine needs access to. Space names can be positive, listing an attribute of the space, or negative (prefixed with "^"), listing something the space does not have. <p> Example: `spaces=storage,db,^logging,^public` (meaning, select machines connected to the storage and db spaces, but NOT to logging or public spaces). <p> **Note:** EC2 and MAAS are the only providers that currently support the spaces constraint.|
| <a href="#heading--tags"><h4 id="heading--tags">`tags`</h4></a>|Comma-delimited tags assigned to the machine. Tags can be positive, denoting an attribute of the machine, or negative (prefixed with `^`), to denote something that the machine does not have. <p> Example: `tags=virtual,^dualnic` <p> **Note:** Currently only supported by the MAAS provider.|
| <a href="#heading--virt-type"><h4 id="heading--virt-type">`virt-type`</h4></a>|Virtualisation type. <p> **Valid values:** `kvm`, `virtual-machine`.|
| <a href="#heading--zones"><h4 id="heading--zones">`zones`</h4></a>|A list of availability zones.  Multiple values present a range of zones that a machine must be created within. <p> **Valid values:** Depending on the cloud provider. <p> **Example for the `aws` cloud:** `zones=us-east-1a,us-east-1c` <p> **Note:** A zone can also be used as a {ref}`placement directive <placement-directive>` (`--to zone= <name of zone>`).|




<!-- THIS CONTENT IS MOVED TO THE CLOUD-SPECIFIC DOCS:
<a href="#heading--cloud-differences"><h2 id="heading--cloud-differences">Cloud differences</h2></a>


Constraints cannot be applied towards a backing cloud in an agnostic way. That is, a particular cloud type may support some constraints but not others. Also, even if two clouds support a constraint, sometimes the constraint **value** may work with one cloud but not with the other. The list below addresses the situation.

<a href="#heading--azure"><h3 id="heading--azure">Azure</h3></a>


- Unsupported: [cpu-power, tags, virt-type]
- Valid values: arch=[amd64]; instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cores, arch]
```{note}
**Note:** `root-disk-source` is the juju storage pool for the root disk. By specifying a storage pool, the root disk can be configured to use encryption.
```


<a href="#heading--ec2"><h3 id="heading--ec2">EC2</h3></a>

- Unsupported: [tags, virt-type, allocate-public-ip]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [mem, cores, cpu-power]

```{note}
**Note:** `root-disk-source` is the juju storage pool for the root disk. By specifying a storage pool, the root disk can be configured to use encryption.
```

<a href="#heading--gce"><h3 id="heading--gce">GCE</h3></a>


- Unsupported: [tags, virt-type, root-disk-source]
- Valid values: instance-type=[defined on the cloud]
- Conflicting constraints: [instance-type] vs [arch, cores, cpu-power, mem]

<a href="#heading--kubernetes"><h3 id="heading--kubernetes">Kubernetes</h3></a>


- Unsupported: [cores, virt-type, container,  instance-type, spaces, allocate-public-ip, root-disk-source]
- Non-standard: cpu-power=100 is 1/10 of a core. **cpu-power** is measured in millicores as defined by Kubernetes.

<a href="#heading--lxd"><h3 id="heading--lxd">LXD</h3></a>


- Unsupported: [cpu-power, tags, virt-type, container, allocate-public-ip]
- Valid values: arch=[host arch]

```{note}
**Note:** `root-disk-source` is the LXD storage pool for the root disk. The default LXD storage pool is used if root-disk-source is not specified.
```

<a href="#heading--maas"><h3 id="heading--maas">MAAS</h3></a>


- Unsupported: [cpu-power, instance-type, virt-type, allocate-public-ip, root-disk-source]
- Valid values: arch=[defined on the cloud]

<a href="#heading--manual"><h3 id="heading--manual">Manual</h3></a>


- Unsupported: [cpu-power, instance-type, tags, virt-type, allocate-public-ip, root-disk-source]
- Valid values: arch=[for controller - host arch; for other machine - arch from machine hardware]

<a href="#heading--oracle"><h3 id="heading--oracle">Oracle</h3></a>


- Unsupported: [tags, virt-type, container, root-disk-source]
- Valid values: arch=[amd64]

<a href="#heading--openstack"><h3 id="heading--openstack">OpenStack</h3></a>


- Unsupported: [tags, cpu-power]
- Valid values: instance-type=[defined on the cloud]; virt-type=[kvm,lxd]
- Conflicting constraints: [instance-type] vs [mem, root-disk, cores]

```{note}
**Note:** `root-disk-source` is either "local" or "volume"
```

<a href="#heading--vsphere"><h3 id="heading--vsphere">vSphere</h3></a>

- Unsupported: [tags, virt-type, allocate-public-ip]
- Valid values: arch=[amd64, i386]

```{note}
**Note:** `root-disk-source` is the datastore for the root disk
```





<a href="#heading--clouds-and-constraints"><h2 id="heading--clouds-and-constraints">Clouds and constraints</h2></a>


In the ideal case, you stipulate a constraint when deploying an application and the backing cloud provides a machine with those exact resources. In the majority of cases, however, default constraints may have already been set (at various levels) and the cloud may be unable to supply those exact resources.

When the backing cloud is unable to precisely satisfy a constraint, the resulting system's resources will exceed the constraint-defined minimum. However, if the cloud cannot satisfy a constraint at all, then an error will be emitted and a machine will not be provisioned.

<a href="#heading--constraints-and-lxd-containers"><h3 id="heading--constraints-and-lxd-containers">Constraints and LXD containers</h3></a>


Constraints can be applied to LXD containers either when they're running directly upon a LXD cloud type or when hosted on a Juju machine (residing on any cloud type). **However, with containers, constraints are interpreted as resource maximums as opposed to minimums.**

In the absence of constraints, a container will, by default, have access to **all** of the underlying system's resources.

LXD constraints also honour instance type names from either [AWS](https://github.com/dustinkirkland/instance-type/blob/master/yaml/aws.yaml), [Azure](https://github.com/dustinkirkland/instance-type/blob/master/yaml/azure.yaml), or [GCE](https://github.com/dustinkirkland/instance-type/blob/master/yaml/gce.yaml) (e.g., AWS type `t2.micro` maps to 1 CPU and 1 GiB of memory). When used in combination with specific CPU/MEM constraints, the latter values will override the corresponding instance type values.

<a id="constraints-and-kubernetes"></a>
<a href="#heading--constraints-and-kubernetes"><h3 id="heading--constraints-and-kubernetes">Constraints and Kubernetes</h3></a>


Constraints in Kubernetes models control the resource requests and limits on the pods spawned as a result of deploying an application.

```{important}

Memory and CPU constraints on sidecar charms currently only represent requests used by Kubernetes for scheduling, and don't set
limits and requests separately on each container. This deficiency is tracked under bug [LP1919976](https://bugs.launchpad.net/juju/+bug/1919976).

```

-->

<!-- I THINK THIS IS ALREADY COVERED BY THAT ONE SENTENCE ON SCOPE IN THE INTRO:
<a href="#heading--constraint-scopes-defaults-and-precedence"><h2 id="heading--constraint-scopes-defaults-and-precedence">Constraint scopes, defaults, and precedence</h2></a>


Constraints can be applied to various levels or scopes. Defaults can be set on some of them, and in the case of overlapping configurations a precedence is adhered to. Changing a default does not affect the existing machines.

On a per-controller basis, the following constraint **scopes** exist:

-   {ref}`Controller machine <6184md>`
-   All models
-   {ref}`Single model <6184md>`
-   {ref}`Single application <6184md>`
-   All units of an application
-   {ref}`Single machine <6184md>`

Among the scopes, **default** constraints can be set for each with the exception of the controller and single machines.

The all-units scope has its default set dynamically. It is the possible constraint used in the initial deployment of an application.

The following **precedence** is observed (in order of priority):

1.   Machine
1.   Application (and its units)
1.   Model
1.   All models

For instance, if a default constraint (`mem`) applies to a single model and the same constraint has been stipulated when adding a machine (`add-machine`) within that model, then the machine's constraint value will be applied.

The dynamic default for units can be overridden by either setting the application's default or by adding a machine with a constraint and then applying the new unit to that machine.

-->