<!--
Todo:
- How to remove a static volume?
-->

*This is in connection to the topic of [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090). See that page for background information.*

For each Juju-deployed Kubernetes application an *operator pod* is set up automatically whose task it is to run the charm hooks for each unit. Each charm also requires persistent storage so that things like state and resources can be preserved if the operator pod ever restarts. To accomplish all this, a Juju storage pool called 'operator-storage' with provider type 'kubernetes' is required. We call this type of storage *operator storage*.

In addition, a Kubernetes charm may itself require persistent storage (e.g. the [mariadb-k8s](https://jujucharms.com/u/juju/mariadb-k8s/) charm). Its Juju storage pool also has a provider type of 'kubernetes'. We call this type of storage *workload storage*. As with standard charms, storage requirements are stated in the charm's `metadata.yaml` file:

```text
storage:
  database:
    type: filesystem
    location: /var/lib/mysql
```

Currently, only filesystem storage is supported.

Both operator storage and workload storage can be Juju-managed and this is the recommended method. However, both can also be managed externally to Juju (i.e. within Kubernetes itself).

Generic Juju storage (non-Kubernetes) is covered on the [Using Juju storage](/t/using-juju-storage/1079) page.

<h2 id="heading--juju-managed-storage">Juju-managed storage</h2>

There are two types of persistent storage that Juju can manage:

- dynamically provisioned volumes
- statically provisioned volumes

A Juju storage pool will subsequently utilise those volumes.

Static volumes are required when the storage system for the backing cloud is not supported by Kubernetes. This situation demands that volumes be set up prior to the creation of the storage pool.

[note type="caution"]
Static volumes are mainly intended for testing/prototyping. They need the Kubernetes
[`hostPath`](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) plugin, which only works with a cluster consisting of a single worker node.
[/note]

Juju-managed storage is in contrast to [external storage](#heading--external-storage-and-storage-precedence-rules).

<h3 id="heading--dynamically-provisioned-volumes">Dynamically provisioned volumes</h3>

In `v.2.6.0`, upon invocation of `add-k8s`, automatic dynamic volume (as well as storage pool) configuration will be attempted. Storage configuration can proceed based on the options passed to `add-k8s`:

- `--region`
  specifies the cloud type and the cloud region
- `--storage`
  specifies the storage class

Auto-configuration will select a recommended storage class that is both supported by Kubernetes and compatible with the backing cloud. The operator can override this by specifying a storage class with the `--storage` option. If no suitable storage class is found the value of the `--storage` option will cause a storage class to be created.

The configured storage class becomes the model default and is exposed using model configuration keys `operator-storage` and `workload-storage` that will be used for operator storage and workload storage, respectively.

It is possible to use a different value for specific models using standard model configuration methods:

```text
juju config -m mymodel workload-storage=mystorageclass
```

[note type=caution]
For applications within a Juju-deployed cluster (e.g. CDK) to make use of dynamic volumes, a cloud-specific [integrator charm](https://jujucharms.com/q/integrator) is required.
[/note]

<h3 id="heading--statically-provisioned-volumes">Statically provisioned volumes</h3>

You set up static volumes via YAML definition files. The [Kubernetes storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/) page offers details as to the structure of the file. Here is the generic procedure:

```text
sudo snap install --classic kubectl
kubectl create -f charm-storage-vol1.yaml
kubectl create -f operator-storage.yaml
```

The example YAML-formatted files `operator-storage.yaml` and `charm-storage-vol1.yaml` define volumes for operator storage and workload storage respectively that get created by the `kubectl` command.

Example content of the volume definition files are given below. Typically multiple workload storage volumes would be required. Note that operator storage needs a minimum of 1024 MiB.

<details> <summary>operator-storage.yaml</summary>
<pre><code>  kind: PersistentVolume
  apiVersion: v1
  metadata:
    name: op1
  spec:
    capacity:
      storage: 1032Mi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Retain
    storageClassName: k8s-model-juju-operator-storage
    hostPath:
      path: "/mnt/data/op1"
</code></pre>
</details>

<details> <summary>charm-storage-vol1.yaml</summary>
<pre><code>  kind: PersistentVolume
  apiVersion: v1
  metadata:
    name: vol1
  spec:
    capacity:
      storage: 100Mi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Retain
    storageClassName: k8s-model-juju-unit-storage
    hostPath:
      path: "/mnt/data/vol1"
</code></pre>
</details>

Once a static volume is used, it is never re-used, even if the unit/pod is terminated and the volume is released. Just as static volumes are manually created, they must also be manually removed.

[note type="caution"]
The storage class name for a statically provisioned volume must be prefixed with the name of the intended model. In the examples above, the model name is 'k8s-model'. The remainder of the name, for both operator and workload storage, are fixed.
[/note]

<h2 id="heading--storage-pool-creation">Storage pool creation</h2>

Whether or not storage volumes are provisioned statically or dynamically Juju storage pools must be created. This is done for operator storage and, if a charm has storage requirements, for workload storage. All on a per-model basis.

In `v.2.6.0`, upon invocation of `add-k8s`, automatic storage pool (as well as dynamic volume) configuration will be attempted. The manual creation of pools, therefore, may not be necessary.

For static storage, the number of storage pools is dependent on the storage classes listed in the PV definition files. The simplest arrangement is to have a single storage pool for each storage type and this is the approach our definition files above have taken. The two storage classes are 'k8s-model-juju-operator-storage' and 'k8s-model-juju-unit-storage' .

Naturally, then, during the creation of a storage pool for static volumes the storage class is needed. However, Juju will automatically prepend the name of the current model (or that of the model specified via `-m`) to the referenced storage class name when it informs the cluster. Omit, therefore, the model name portion of the storage class when creating such a (static) pool.

The storage pool name for operator storage *must* be called 'operator-storage' while the pool name for workload storage is arbitrary. It is this workload storage pool that will be used at charm deployment time (`deploy` command). It is also this command that triggers the actual creation of the Kubernetes storage class when that storage class is used for the first time.

Juju storage pools are created using the standard `create-storage-pool` command and by passing values for "pool name", "storage class name", "provisioner", and optional provisioner-specific parameters. The command syntax is:

```text
juju create-storage-pool <pool name> <storage provider> \
     storage-class=<storage class name> storage-provisioner=<provisioner> \
     parameters.type=<paramters>
```

In a Kubernetes context, the "storage provider" is always `kubernetes`. This provider becomes available upon the addition of a Kubernetes model. In `v.2.6.0` Juju is able to recognise the Kubernetes context and assumes the value of the storage provider.

For static volumes, the provisioner is `kubernetes.io/no-provisioner`.

For dynamic volumes, the provisioner is dependant upon the underlying [storage backend](https://kubernetes.io/docs/concepts/storage/storage-classes/#provisioner). Examples are given in the next two sections that follow.

The storage class names for both operator storage and workload storage do not need to be stated. Juju will create a name if one is not explicitly given. This is not true, however, for static volumes because a volume definition requires a storage class name.

When creating a pool, if a storage class name is provided, the current model's name will be prefixed to that storage class name. For instance, given a model name of 'k8s-model' and a storage class name of 'juju-operator-storage', the final storage class name associated with the pool becomes 'k8s-model-juju-operator-storage'. This is really only pertinent when using static volumes as the complete storage class name must be included in the volume definition files.

The standard `storage-pools` command is used to list Juju storage pools.

<h3 id="heading--creating-operator-storage-pools">Creating operator storage pools</h3>

The below examples show the syntax for creating operator storage pools for various scenarios.

For AWS using SSD/gp2 backed EBS volumes (dynamically provisioned):

``` text
juju create-storage-pool operator-storage kubernetes \
    storage-class=juju-operator-storage \
    storage-provisioner=kubernetes.io/aws-ebs \
    parameters.type=gp2
```

For GCE using Persistent Disk (dynamically provisioned):

``` text
juju create-storage-pool operator-storage kubernetes \
    storage-class=juju-operator-storage \
    storage-provisioner=kubernetes.io/gce-pd \
    parameters.type=pd-standard
```

For `microk8s` using built-in hostPath storage (dynamically provisioned):

``` text
juju create-storage-pool operator-storage kubernetes \
    storage-class=microk8s-hostpath
```

For MicroK8s, a special storage class name of 'microk8s-hostpath' is always used.

For any cloud (statically provisioned):

``` text
juju create-storage-pool operator-storage kubernetes \
    storage-class=juju-operator-storage \
    storage-provisioner=kubernetes.io/no-provisioner
```

<h3 id="heading--creating-charm-storage-pools">Creating workload storage pools</h3>

Creating a workload storage pool is done very similarly to creating an operator storage pool. The below example creates a pool arbitrarily called 'k8s-pool' that uses static volumes:

``` text
juju create-storage-pool k8s-pool kubernetes \
    storage-class=juju-unit-storage \
    storage-provisioner=kubernetes.io/no-provisioner
```

The final storage class name associated with above pool 'k8s-pool', assuming a model of 'k8s-model', becomes 'k8s-model-juju-unit-storage'.

For `microk8s`, the only difference from the creation of the corresponding operator storage pool is the pool name:

``` text
juju create-storage-pool k8s-pool kubernetes \
    storage-class=microk8s-hostpath
```

<h2 id="heading--kubernetes-emptydir-volumes">Kubernetes emptyDir volumes</h2>

Kubernetes [emptyDir volumes](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) can be achieved via Juju's [generic storage providers](/t/using-juju-storage/1079#heading--generic-storage-providers) 'rootfs' and 'tmpfs'.

For example, to request 2 GiB of memory-based storage:

```text
juju deploy cs:~juju/mariadb-k8s --storage database=tmpfs,2G
```

<h2 id="heading--external-storage-and-storage-precedence-rules">External storage and storage precedence rules</h2>

Although the recommended approach is to use Juju-managed storage, Juju does support externally created storage for both operator storage and workload storage.

For operator storage, Juju will use this order of precedence for determining the storage it will use:

1.  a storage class called `<model name>-juju-operator-storage`
2.  a storage class called `juju-operator-storage`
3.  a storage class with label key `juju-storage`, with a value set to one of:
    -   `<application name>-operator-storage`
    -   `<model name>`
    -   `default`
4.  a storage class with label `storageclass.kubernetes.io/is-default-class`

For workload storage the rules are similar:

1.  a storage class called `<model name>-juju-unit-storage`
2.  a storage class called `juju-unit-storage`
3.  a storage class with label key `juju-storage`, with a value set to one of:
    -   `<application name>-unit-storage`
    -   `<model name>`
    -   `default`
4.  a storage class with label `storageclass.kubernetes.io/is-default-class`

<!-- LINKS -->
