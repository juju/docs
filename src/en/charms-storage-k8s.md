Title: Persistent storage and Kubernetes
TODO:  Add how to create external storage
       Write a tutorial or two on using storage

# Persistent storage and Kubernetes

For each Juju-deployed Kubernetes application an *operator pod* is set up
automatically whose task it is to run the charm hooks for each unit. Each charm
also requires such persistent storage so that things like state and resources
can be preserved if the operator pod ever restarts. To accomplish all this, a
Juju storage pool called 'operator-storage' with provider type 'kubernetes' is
required. We call this type of storage *operator storage*.

In addition, a Kubernetes charm may itself require persistent storage (e.g.
the [mariadb-k8s][charm-store-staging-mariadb-k8s] charm). Its Juju storage
pool also has a provider type of 'kubernetes'. We call this type of
storage *charm storage*. As with standard charms, storage requirements are
stated in the charm's `metadata.yaml` file:

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

!!! Note:
    The topic of storage is covered in a non-Kubernetes context on the
    [Using Juju Storage][charms-storage] page.

### Juju-managed storage

As mentioned, there are two types of persistent storage that Juju can manage:

 - dynamically provisioned volumes
 - statically provisioned volumes

In both cases, a Juju storage pool needs to be created by the Juju operator.
The second type is needed when the storage system for your chosen backing cloud
is not supported by Kubernetes. This situation therefore demands that volumes
be set up prior to the creation of the storage pool. See
[Types of persistent volumes][upstream-kubernetes-volumes] for the list of
Kubernetes supported backends. 

#### Statically provisioned volumes

You set up static volumes via storage class definitions. The
[Kubernetes storage classes][upstream-kubernetes-classes] page offers details.
Here is a example procedure:

```bash
sudo snap install --classic kubectl
sudo mkdir -p /mnt/data/{op1,vol1}
kubectl create -f lxd-k8s-model-op1.yaml
kubectl create -f lxd-k8s-model-vol1.yaml
kubectl describe pv
```

The example YAML-formatted files `lxd-op1.yaml` and `lxd-vol1.yaml` define
volumes for operator storage and charm storage respectively that get created by
the `kubectl` command.

The content of the storage class definition files are given below. Typically
multiple charm storage volumes would be required. Note that operator storage
needs a minimum of 1024 MiB.

^# lxd-k8s-model-op1.yaml

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
        storageClassName: lxd-k8s-model-operator-storage
        hostPath:
          path: "/mnt/data/op1"

^# lxd-k8s-model-vol1.yaml

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
        storageClassName: lxd-k8s-model-charm-storage
        hostPath:
          path: "/mnt/data/vol1"

One naming convention that works is to have the storage classes names prefixed
with the name of the model in use.

We'll show how to create Juju storage pools using our newly-created volumes in
section [Creating storage pools][#creating-storage-pools].
 
!!! Important:
    Once a static volume is used, it is never re-used, even if the unit/pod is
    terminated and the volume is released. Just as static volumes are manually
    created, they must also be manually removed.
     
### External storage

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

This documentation will focus on Juju-managed storage only.

### Creating storage pools

Juju storage pools are created for both operator storage and charm storage
using the `create-storage-pool` command. Both are done by mapping to either a
Kubernetes storage class (dynamically provisioned volumes) or to a manually
defined one (statically provisioned volumes). The command's syntax is:

`juju create-storage-pool <pool name> kubernetes \
	storage-class=<storage class name> \
	storage-provisioner=<provisioner> \
	parameters.type=<paramters>`

The 'pool name' is used at charm deployment time. It is also the `deploy`
command that triggers the actual creation of the Kubernetes storage class when
that storage class is referred to for the first time.

These next few examples show how to create operator storage pool using various
Kubernetes supported storage provisioners.

For AWS using EBS volumes:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/aws-ebs \
	parameters.type=gp2
```

For GKE using Persistent Disk:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/gce-pd \
	parameters.type=pd-standard
```

For `microk8s` using built-in hostPath storage:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=microk8s-hostpath
```

For a manually defined storage class called 'lxd-k8s-model-operator-storage': 

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=lxd-k8s-model-operator-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

Creating a charm storage pool is done similarly. The below example creates a
pool arbitrarily called 'lxd-k8s-pool' using a manually defined storage class
called 'lxd-k8s-model-charm-storage': 

```bash
juju create-storage-pool lxd-k8s-pool kubernetes \
	storage-class=lxd-k8s-model-charm-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

The standard `storage-pools` command is used to list all current Juju storage
pools.


<!-- LINKS -->

[charms-storage]: ./charms-storage.md
[upstream-kubernetes-volumes]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes
[upstream-kubernetes-classes]: https://kubernetes.io/docs/concepts/storage/storage-classes/
[#creating-storage-pools]: #creating-storage-pools
[charm-store-staging-mariadb-k8s]: https://staging.jujucharms.com/u/wallyworld/mariadb-k8s/7
