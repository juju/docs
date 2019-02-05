Title: Setting up static Kubernetes storage - tutorial
TODO:  How to add a bespoke cluster to Juju?

# Setting up static Kubernetes storage - tutorial

*This is in connection to the topic of
[Using Kubernetes with Juju][clouds-k8s]. See that page for background
information.*

This tutorial will show the steps required to create Kubernetes **static**
persistent volumes (PVs) for use with Kubernetes-specific charms. This is
normally done when the backing cloud you're using does not have a storage type
that is supported natively by Kubernetes. There is no reason, however, why you
cannot use statically provisioned volumes with any cloud. Here, we'll use AWS
as our backing cloud.

Note that static volumes are dependent upon the Kubernetes
[`hostPath`][kubernetes-hostpath] volume type. This restricts us to a single
worker node cluster. The '[kubernetes-core][charm-kc]' bundle provides this and
that's we'll be using here.

## Prerequisites

The following prerequisites are assumed as a starting point for this tutorial:

 - You're using Ubuntu 18.04 LTS.
 - Juju (stable snap channel) is installed. See the [Installing Juju][install]
   page.
 - A credential for the 'aws' cloud has been added to Juju. See the
   [Using Amazon AWS with Juju][clouds-aws] page.

## Installing Kubernetes

Let's begin by creating a controller. We'll call it 'aws-k8s':

```bash
juju bootstrap aws aws-k8s
```

Now deploy Kubernetes:

```bash
juju deploy kubernetes-core
```

After about ten minutes things should have settled down to arrive at a stable
output to the `status` command:

```bash
juju status
```

Our example's output:

```no-highlight
Model    Controller  Cloud/Region   Version  SLA          Timestamp
default  aws-k8s     aws/us-east-1  2.5.0    unsupported  23:19:45Z

App                Version  Status  Scale  Charm              Store       Rev  OS      Notes
easyrsa            3.0.1    active      1  easyrsa            jujucharms  195  ubuntu  
etcd               3.2.10   active      1  etcd               jujucharms  378  ubuntu  
flannel            0.10.0   active      2  flannel            jujucharms  351  ubuntu  
kubernetes-master  1.13.2   active      1  kubernetes-master  jujucharms  542  ubuntu  exposed
kubernetes-worker  1.13.2   active      1  kubernetes-worker  jujucharms  398  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
easyrsa/0*            active    idle   0/lxd/0  10.213.157.48                   Certificate Authority connected.
etcd/0*               active    idle   0        54.236.253.89   2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  active    idle   0        54.236.253.89   6443/tcp        Kubernetes master running.
  flannel/1           active    idle            54.236.253.89                   Flannel subnet 10.1.35.1/24
kubernetes-worker/0*  active    idle   1        34.205.37.5     80/tcp,443/tcp  Kubernetes worker running.
  flannel/0*          active    idle            34.205.37.5                     Flannel subnet 10.1.28.1/24

Machine  State    DNS            Inst id              Series  AZ          Message
0        started  54.236.253.89  i-0c4d170f529709dc0  bionic  us-east-1a  running
0/lxd/0  started  10.213.157.48  juju-79c582-0-lxd-0  bionic  us-east-1a  Container started
1        started  34.205.37.5    i-0e769efd3646a56e1  bionic  us-east-1b  running
```

## Adding the cluster to Juju

We'll now copy over the cluster's main configuration file and then use the
`add-k8s` command to add the cluster to Juju's list of known clouds. Here, we
arbitrarily call the new cloud 'k8s-cloud':

```bash
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
juju add-k8s k8s-cloud
```

The success of this operation can be confirmed by running `juju clouds`.

## Adding a model

When we add a Kubernetes cluster to Juju we effectively have two clouds being
managed by one controller. For us, they are named 'aws' and 'k8s-cloud'. So
when we want to create a model we'll need explicitly state which cloud to place
the new model in. We'll do this now by adding a model called 'k8s-model' to
cloud 'k8s-cloud':

```bash
juju add-model k8s-model k8s-cloud
```

The output to `juju models` should now look very similar to:

```no-highlight
Controller: aws-k8s

Model       Cloud/Region   Status     Machines  Cores  Access  Last connection
controller  aws/us-east-1  available         1      4  admin   just now
default     aws/us-east-1  available         3      8  admin   27 seconds ago
k8s-model*  k8s-cloud      available         0      -  admin   never connected
```

Adding a model for a Kubernetes cloud unlocks the 'kubernetes' storage
provider, which we'll refer to later. The output to `juju storage-pools` should
now be:

```no-highlight
Name        Provider    Attrs
Kubernetes  kubernetes
```

## Static persistent volumes

We will now manually create Kubernetes persistent volumes (PVs). Another way of
saying this is that we will set up statically provisioned storage.

There are two types of storage: operator storage and charm storage (also called
unit storage). The bare minimum is one volume for operator storage. The
necessity of charm storage depends on the charms that will be deployed. Charm
storage is needed if the charm has storage requirements. The size and number of
those volumes are determined by those requirements and the nature of the charm
itself.

The creation of volumes is a two-step process. First set up definition files
for each PV, and second, create the actual PVs using `kubectl`, the Kubernetes
configuration management tool. We'll look at these two steps now.

### Defining persistent volumes

In this tutorial we'll be creating one operator storage volume and two charm
storage volumes. The three corresponding files are below. Click on their names
to reveal their contents.

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

^# charm-storage-vol2.yaml

      kind: PersistentVolume
      apiVersion: v1
      metadata:
        name: vol2
      spec:
        capacity:
          storage: 100Mi
        accessModes:
          - ReadWriteOnce
        persistentVolumeReclaimPolicy: Retain
        storageClassName: k8s-model-juju-unit-storage
        hostPath:
          path: "/mnt/data/vol2"

Note that operator storage needs a minimum of 1024 MiB.

!!! Important:
    When defining statically provisioned volumes, the intended storage class
    name must be prefixed with the name of the intended model. In the files
    above, the model name is 'k8s-model'.

### Creating persistent volumes

The actual creation of the volumes is very easy. Simply refer the `kubectl`
command to the files. We begin by installing the tool if it's not yet present:

```bash
sudo snap install kubectl --classic 
kubectl create -f operator-storage.yaml
kubectl create -f charm-storage-vol1.yaml
kubectl create -f charm-storage-vol2.yaml
```

This tool is communicating directly with the cluster. It can do so by virtue of
the existence of the cluster configuration file (`~/.kube/config`).

We can also use this tool to take a look at our new PVs:

```bash
kubectl -n k8s-model get sc,pv,pvc
```

Our example's output:

![kubectl -n k8s-model get sc-pv-pvc first][volumes]

Notice how our model name of 'k8s-model' can be passed to `kubectl`. When the
Juju model was added a Kubernetes "namespace" was set up with the same name.

## Creating Juju storage pools

The storage pool name for operator storage *must* be called 'operator-storage'
while the pool name for charm storage is arbitrary. Here, our charm has
storage requirements so we'll need a pool for it. We'll call it 'k8s-pool'. It
is this charm storage pool that will be used at charm deployment time.

For static volumes, the Kubernetes provisioner is
`kubernetes.io/no-provisioner`.

Our two storage pools are therefore created like this:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

```bash
juju create-storage-pool k8s-pool kubernetes \
	storage-class=juju-unit-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

Perform a verification by listing all current storage pools with the
`storage-pools` command. Our example yields this output:

![juju storage-pools][storage-pools]

Almost there!

## Deploying a Kubernetes charm

We can now deploy a Kubernetes charm. For example, here we deploy a charm by
requesting the use of the 'k8s-pool' charm storage pool we just set up:

```bash
juju deploy cs:~juju/mariadb-k8s --storage database=k8s-pool,10M
```

The output to `juju status` should soon look like the following:

```no-highlight
Model      Controller  Cloud/Region  Version    SLA          Timestamp
k8s-model  aws-k8s     k8s-cloud     2.5.0      unsupported  20:42:28Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address        Notes
mariadb-k8s           active      1  mariadb-k8s  jujucharms   13  kubernetes  10.152.183.87  

Unit            Workload  Agent  Address     Ports     Message
mariadb-k8s/0*  active    idle   10.1.69.14  3306/TCP
```

In contrast to standard Juju behaviour, there are no machines listed here.

Here is one of the created charm storage persistent volumes in use:

```bash
juju storage --filesystem
```

Output:

```no-highlight
Unit           Storage id  Id  Provider id                         Mountpoint      Size   State     Message
mariadb-k8s/0  database/0  0   juju-database-0-juju-mariadb-k8s-0  /var/lib/mysql  38MiB  attached  
```

We'll see the Provider id of 'juju-database-0-juju-mariadb-k8s-0' again in the
next section.

## Post-deploy cluster inspection

Let's see what has happened within the cluster due to the deployment of the
charm:

```bash
kubectl -n k8s-model get sc,pv,pvc
```

New sample output:

![kubectl -n k8s-model get sc-pv-pvc][sc-pv-pvc]

Awesome.

At the top we see that our two storage classes have been created and that
they're both associated with the 'no-provisioner' provisioner.

In the middle section it is clear that two of our volumes are being used
('Bound') and that one is available. The one that is used ('vol1') is claimed
by the same Provider id that we saw in the output of the `storage` command
above ('juju-database-0-juju-mariadb-k8s-0').

In the lower part we're told what has "claimed" the two used volumes. Each of
these claims have requested the use of the appropriate storage class.

If something goes wrong the following command can be used to drill down into
the various objects:

```bash
kubectl -n k8s-model describe pods,sc,pv,pvc
```

## Removing configuration and software

To remove all traces of Kubernetes and its configuration follow these steps:

```bash
juju destroy-model -y --destroy-storage k8s-model
juju remove-k8s k8s-cloud
rm -rf ~/.kube
rm ~/operator-storage.yaml
rm ~/charm-storage-vol1.yaml
rm ~/charm-storage-vol2.yaml
```

This leaves us with Juju and `kubetl` installed as well as an AWS controller.
To remove even those things proceed as follows:

```bash
juju destroy-controller -y --destroy-all-models aws-k8s
sudo snap remove juju
sudo snap remove kubectl
```

That's the end of this tutorial!

## Next steps

Consider the following tutorials:

 - [Using the aws-integrator charm][tutorial-k8s-aws]
 - [Using Juju with MicroK8s][tutorial-microk8s]

To gain experience with a standalone (non-Juju) MicroK8s installation check
out Ubuntu tutorial
[Install a local Kubernetes with MicroK8s][ubuntu-tutorial-kubernetes-microk8s].


<!-- LINKS -->

[clouds-k8s]: ./clouds-k8s.md
[upstream-cncf]: https://www.cncf.io/certification/software-conformance/
[ubuntu-tutorial-kubernetes-microk8s]: https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s
[install]: ./reference-install.md
[tutorial-microk8s]: ./tutorial-microk8s.md
[tutorial-k8s-aws]: ./tutorial-k8s-aws.md
[kubernetes-hostpath]: https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
[clouds-aws]: ./clouds-aws.md
[charm-kc]: https://jujucharms.com/kubernetes-core/

<!-- IMAGES -->

[storage-pools]: https://assets.ubuntu.com/v1/26ff0c70-storage-pools-2.png
[sc-pv-pvc]: https://assets.ubuntu.com/v1/a8cc75dd-sc-pv-pvc-2.png
[volumes]: https://assets.ubuntu.com/v1/34f93a4b-volumes-2.png
