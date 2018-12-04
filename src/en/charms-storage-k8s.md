Title: Persistent storage and Kubernetes
TODO:  How to remove a static volume?

# Persistent storage and Kubernetes

For each Juju-deployed Kubernetes application an *operator pod* is set up
automatically whose task it is to run the charm hooks for each unit. Each charm
also requires such persistent storage so that things like state and resources
can be preserved if the operator pod ever restarts. To accomplish all this, a
Juju storage pool called 'operator-storage' with provider type 'kubernetes' is
required. We call this type of storage *operator storage*.

In addition, a Kubernetes charm may itself require persistent storage (e.g.
the [mariadb-k8s][charm-store-staging-mariadb-k8s] charm). Its Juju storage
pool also has a provider type of 'kubernetes'. We call this type of storage
*charm storage* (or unit storage). As with standard charms, storage
requirements are stated in the charm's `metadata.yaml` file:

```no-highlight
storage:
  database:
    type: filesystem
    location: /var/lib/mysql
```

Currently, only filesystem storage is supported.

Both operator storage and charm storage can be Juju-managed and this is the
recommended method. However, both can also be managed externally to Juju (i.e.
within Kubernetes itself).

Juju-managed storage can be provisioned either dynamically or statically.

The topic of storage is covered in a non-Kubernetes context on the
[Using Juju Storage][charms-storage] page.

!!! Note:
    Kubernetes charms are currently only available on the
    [staging Charm Store][charm-store-staging] and are for developmental and
    testing purposes only.

## Juju-managed storage

As mentioned, there are two types of persistent storage that Juju can manage:

 - dynamically provisioned volumes
 - statically provisioned volumes

In both cases, a Juju storage pool needs to be created by the Juju operator.
The second type is needed when the storage system for your chosen backing cloud
is not supported by Kubernetes. This situation therefore demands that volumes
be set up prior to the creation of the storage pool.

See [Types of volumes][kubernetes-supported-volume-types] for the list of
Kubernetes supported storage backends. This will inform you whether your
backing cloud can use dynamically provisioned volumes. As of time of writing,
the list of Juju-supported clouds that also have dynamic volume support are:

 - Amazon AWS
 - Google GCE
 - Microsoft Azure
 - OpenStack
 - VMware vSphere

!!! Important:
    Static volumes are mainly intended for testing/prototyping. They need the
    Kubernetes [`hostPath`][kubernetes-hostpath] plugin, which only works with
    a cluster consisting of a single worker node.

Juju-managed storage is in contrast to
[external storage][#external-storage-and-storage-precedence-rules], covered
later on.

### Statically provisioned volumes
 
You set up static volumes via YAML definition files. The
[Kubernetes storage classes][kubernetes-classes] page offers details as to the
structure of the file. Here is the generic procedure:

```bash
sudo snap install --classic kubectl
kubectl create -f charm-storage-vol1.yaml
kubectl create -f operator-storage.yaml
```

The example YAML-formatted files `operator-storage.yaml` and
`charm-storage-vol1.yaml` define volumes for operator storage and charm storage
respectively that get created by the `kubectl` command.

Example content of the volume definition files are given below. Typically
multiple charm storage volumes would be required. Note that operator storage
needs a minimum of 1024 MiB.

^# operator-storage.yaml

      kind: PersistentVolume
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

^# charm-storage-vol1.yaml

      kind: PersistentVolume
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

Once a static volume is used, it is never re-used, even if the unit/pod is
terminated and the volume is released. Just as static volumes are manually
created, they must also be manually removed.

!!! Important:
    The storage class name for a statically provisioned volume must be prefixed
    with the name of the intended model. In the examples above, the model name
    is 'k8s-model'. The remainder of the name, for both operator and charm
    storage, are fixed. This is explained again further on.

## Storage pool creation

Juju storage pools are created for both operator storage and charm storage
using the `create-storage-pool` command. Both are done by mapping to either a
Kubernetes storage class (dynamically provisioned volumes) or to a manually
defined one (statically provisioned volumes). The command's syntax is:

`juju create-storage-pool <pool name> kubernetes \
	storage-class=<storage class name> \
	storage-provisioner=<provisioner> \
	parameters.type=<paramters>`

For charm storage, the 'pool name' is referenced at charm deployment time by
the `deploy` command. It is also this command that triggers the actual creation
of the Kubernetes storage class when that storage class is referred to for the
first time.

The pool name for operator storage *must* be called 'operator-storage' while a
pool name for charm storage is arbitrary.

The storage class name for operator storage *must* be called
'juju-operator-storage' while a storage class name for charm storage *must* be
called 'juju-unit-storage'.

The standard `storage-pools` command is used to list Juju storage pools.

### Creating operator storage pools

The below examples show how to create operator storage pools for various
scenarios.

For AWS using EBS volumes (dynamically provisioned):

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/aws-ebs \
	parameters.type=gp2
```

For GCE using Persistent Disk (dynamically provisioned):

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/gce-pd \
	parameters.type=pd-standard
```

For `microk8s` using built-in hostPath storage (dynamically provisioned):

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=microk8s-hostpath
```

For MicroK8s, a special storage class name of 'microk8s-hostpath' is always
used.

For LXD (statically provisioned):

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

!!! Important:
    When creating a pool, Juju will prefix the current model's name to the
    stated storage class name. In the above example, assuming a model name of
    'k8s-model', the final storage class name associated with the pool becomes
    'k8s-model-juju-operator-storage'. It is this name that you must use when
    defining a static volume (YAML file).
    
### Creating charm storage pools

Creating a charm storage pool is done very similarly to creating an operator
storage pool. The below example creates a pool arbitrarily called 'k8s-pool'
that uses static volumes:

```bash
juju create-storage-pool k8s-pool kubernetes \
	storage-class=juju-unit-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

As with the operator storage static volume scenario, the final storage class
name associated with pool 'k8s-pool', assuming a model of 'k8s-model', becomes
'k8s-model-juju-unit-storage'.

For `microk8s`, the only difference from the creation of the corresponding
operator storage pool is the pool name:

```bash
juju create-storage-pool k8s-pool kubernetes \
	storage-class=microk8s-hostpath
```

## External storage and storage precedence rules 

Although the recommended approach is to use Juju-managed storage, Juju does
support externally created storage for both operator storage and charm storage.

For operator storage, Juju will use this order of precedence for determining
the storage it will use:

 1. a storage class called `<model name>-juju-operator-storage`
 1. a storage class called `juju-operator-storage`
 1. a storage class with label key `juju-storage`, with a value set to one of:
     - `<application name>-operator-storage`
     - `<model name>`
     - `default`
 1. a storage class with label `storageclass.kubernetes.io/is-default-class`

For charm storage the rules are similar:

 1. a storage class called `<model name>-juju-unit-storage`
 1. a storage class called `juju-unit-storage`
 1. a storage class with label key `juju-storage`, with a value set to one of:
     - `<application name>-unit-storage`
     - `<model name>`
     - `default`
 1. a storage class with label `storageclass.kubernetes.io/is-default-class`

Notice that for both operator and charm storage, the first rule is compatible
with Juju-managed statically provisioned volumes.


<!-- LINKS -->

[charms-storage]: ./charms-storage.md
[kubernetes-supported-volume-types]: https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes
[kubernetes-hostpath]: https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
[kubernetes-classes]: https://kubernetes.io/docs/concepts/storage/storage-classes/
[#creating-storage-pools]: #creating-storage-pools
[charm-store-staging-mariadb-k8s]: https://staging.jujucharms.com/u/wallyworld/mariadb-k8s/7
[charm-store-staging]: https://staging.jujucharms.com
[tutorial-microk8s]: ./tutorial-microk8s.md
[#external-storage-and-storage-precedence-rules]: #external-storage-and-storage-precedence-rules 
