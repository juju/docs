(storage-support)=
# Storage Support

## Persistent storage for stateful applications

### Example

On AWS, an example using dynamic persistent volumes.
```text
juju bootstrap aws
juju deploy kubernetes-core
juju deploy aws-integrator
juju trust aws-integrator
```

**Note**: the aws-integrator charm is needed to allow dynamic storage provisioning.

Wait for `juju status` to go green.
```text
juju scp kubernetes-master/0:config ~/.kube/config
juju add-k8s myk8scloud
juju add-model myk8smodel myk8scloud
juju create-storage-pool k8s-ebs kubernetes storage-class=juju-ebs storage-provisioner=kubernetes.io/aws-ebs parameters.type=gp2
juju deploy cs:~wallyworld/mariadb-k8s --storage database=10M,k8s-ebs
```
Now you can see the storage being created/attached using `juju storage`.

`juju storage`
or
`juju storage --filesystem`
or
`juju storage --volume`
or
`juju storage --format yaml`

You can also see the persistent volumes and volume claims being created in Kubernetes.

`kubectl -n myk8smodel get all,pvc,pv`


### In more detail

Application pods may be restarted, either by Juju to perform an upgrade, or at the whim of Kubernetes itself. Applications like databases which require persistent storage can make use of Kubernetes persistent volumes.

As with any other charm, Kubernetes charms may declare that storage is required. This is done in metadata.yaml.

```yaml
storage:
  database:
    type: filesystem
    location: /var/lib/mysql
```

An example charm is [mariadb-k8s](https://jujucharms.com/u/juju/mariadb-k8s).

Only filesystem storage is supported at the moment. Block volume support may come later.

There's 2 ways to configure the Kubernetes cluster to provide persistent storage:

1. A pool of manually provisioned, static persistent volumes

2. Using a storage class for dynamic provisioning of volumes

In both cases, you use a Juju storage pool and can configure it to supply extra Kubernetes specific configuration if needed.

### Manual Persistent Volumes

This approach is mainly intended for testing/prototyping.

You can create persistent volumes using whatever backing provider is supported by the underlying cloud. One or many volumes may be created. The _storageClassName_ attribute of each volume needs to be set to an arbitrary name.

Next create a  storage pool in Juju which will allow the use of the persistent volumes:

`
juju create-storage-pool <poolname> kubernetes storage-class=<classname> storage-provisioner=kubernetes.io/no-provisioner
`

_classname_ is the base storage class name assigned to each volume.
_poolname_ will be used when deploying the charm.


Kubernetes will pick an available available volume each time it needs to provide storage to a new pod. Once a volume is used, it is never re-used, even if the unit/pod is terminated and the volume is released. Just as volumes are manually created, they must also be manually deleted.

This approach is useful for testing/protyping. If you deploy the kubernetes-core bundle, you can create one or more "host path" persistent volumes on the worker node (each mounted to a different directory). Here's an example YAML config file to use with kubectl to create 1 volume:

```
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mariadb-data
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: <model>-mariadb-unit-storage
  hostPath:
    path: "/mnt/data"
```
You'd tweak the host path and volume name to create a selection of persistent volumes to test with - remember, each manually created volume can only be used once.

**Note:** the storage class name in the PV YAML above has the model name prepended to it. This is because storage classes are global to the cluster and so Juju will prepend the model name to disambiguate. So you will need to know the model name when setting up static PVs. Or you can create them and edit the storage class attribute later using `kubectl edit`.

Then create the Juju storage pool:

`
juju create-storage-pool test-storage kubernetes storage-class=mariadb-unit-storage storage-provisioner=kubernetes.io/no-provisioner
`

Now deploy the charm:

`
juju deploy cs:~juju/mariadb-k8s --storage database=10M,test-storage
`

Juju will create a suitably named Kubernetes storage class with the relevant provisioner type to enable the use of the statically created volumes.

### Dynamic Persistent Volumes

To allow for Kubernetes to create persistent volumes on demand, a Kubernetes storage class is used. This is done automatically by Juju if you create a storage pool. As with vm based clouds, a Juju storage pool configures different classes of storage which are available to use with deployed charm.

It's also possible to set up a Kubernetes storage class manually and have finer grained control over how things tie together, but that's beyond the scope of this topic.

Before deploying your charm which requires storage, create a Juju storage pool which defines what backing provider will be used to provision the dynamic persistent volumes. The backing provider is specific to the underlying cloud and more details are available in the Kubernetes [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/) documentation.

The example below is for a Kubernetes cluster deployed on AWS requiring EBS persistent volumes of type gp2. The name of the pool is arbitrary - in this case _k8s-eb2_. Note that the Kubernetes cluster needs be deployed with the cloud specific integrator charm as described earlier.

`juju create-storage-pool k8s-ebs kubernetes storage-class=juju-ebs storage-provisioner=kubernetes.io/aws-ebs parameters.type=gp2`

You can see what storage pools have been set up in Juju.

`juju storage-pools`

**Note**: only pools of type "kubernetes" are currently supported. rootfs, tmpfs and loop are unsupported.

Once a storage pool is set up, to define how Kubernetes should be configured to provide dynamic volumes, you can go ahead a deploy a charm using the standard Juju storage directives.

`juju deploy cs:~juju/mariadb-k8s --storage database=10M,k8s-ebs`

Use `juju storage` command (and its variants) to see the state of the storage.

If you scale up

`juju scale-application mariadb 3`

you will see that 2 need EBS volumes are created and become attached.

If you scale down

`juju scale-application mariadb 2`

you will see that one of the EBS volumes becomes detached but is still associated wih the model.

Scaling up again

`juju scale-application mariadb 3`

will result in this detached storage being reused and attached to the new unit.

Destroying the entire model will result in all persistent volumes for that model also being deleted.

### What's next?

https://discourse.jujucharms.com/t/advanced-storage-support/204