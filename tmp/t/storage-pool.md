(storage-pool)=
# Storage pool

> <small> {ref}`Storage <storage>` > Storage pool </small>
>
> See also: {ref}`How to manage storage pools <how-to-manage-storage-pools>`


```{important}

A storage pool is defined on top of a {ref}`storage provider <storage-provider>`.


```

<!--
A storage pool is the aggregate storage capacity available for the provider to partition and assign to individual units.
-->

<!--from https://discourse.charmhub.io/t/juju-create-storage-pool/1702 >> Details: -->

A **storage pool** is a mechanism for administrators to define sources of storage that they will use to satisfy application storage requirements.

A single pool might be used for storage from units of many different applications - it is a resource from which different stores may be drawn.

A pool describes provider-specific parameters for creating storage, such as performance (e.g. IOPS), media type (e.g. magnetic vs. SSD), or durability.

For many providers, there will be a shared resource where storage can be requested (e.g. for Amazon EC2, `ebs`). Creating pools there maps provider specific settings into named resources that can be used during deployment.

Pools defined at the model level are easily reused across applications. Pool creation requires a pool name, the provider type and attributes for configuration as space-separated pairs, e.g. tags, size, path, etc.

For Kubernetes models, the provider type defaults to “kubernetes” unless otherwise specified.