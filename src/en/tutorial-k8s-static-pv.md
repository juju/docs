Title: Setting up static Kubernetes storage

# Setting up static Kubernetes storage

*This is in connection to the topic of
[Using Kubernetes with Juju][clouds-k8s]. See that page for background
information.*

This short tutorial will show the steps required to create Kubernetes
persistent storage volumes for use with Juju. This is normally done when the
backing cloud you're using does not have a storage type that is supported
natively by Kubernetes. There is no reason, however, why you cannot use
statically provisioned volumes with any cloud. Here, we'll use AWS as our
backing cloud. Kubernetes does support AWS/EBS volumes (as shown
[here][upstream-kubernetes-supported-volume-types]) but it does require the use
of the [`aws-integrator`][charm-store-staging-aws-integrator] charm, which
we'll cover in a separate tutorial.

The [Persistent storage and Kubernetes][charms-storage-k8s] page provides a
theoretical background on how Kubernetes storage works with Juju.

## Pre-requisites

The following requirements are assumed:

 - that you're using Ubuntu 18.04 LTS
 - that Juju (stable snap channel) is installed. See the
   [Installing Juju][reference-install] page.
 - that a credential for the 'aws' cloud has been added to Juju. See
   the [Credentials][credentials] page.

## Preliminaries

Let's begin creating a controller:

```bash
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore aws aws-k8s
```

!!! Note:                                                                                                                                                                                                        
    We've used the staging Charm Store in these instructions as the standard                                                                                                                                     
    site does not yet support Kubernetes charms and bundles. 

## Installing Kubernetes

For the purposes of this guide a complex Kubernetes cluster is not needed.
We've therefore chosen to use the 'kubernetes-core' bundle, which will give us
a minimalist cluster. Let's install it now:

```bash
juju deploy kubernetes-core
```

After about ten minutes things should have settled down to arrive at a stable
output to the `status` command:

```bash
juju status
```

Our example's output shows:

```no-highlight
Model    Controller  Cloud/Region   Version    SLA          Timestamp
default  aws-k8s     aws/us-east-1  2.5-beta2  unsupported  21:33:30Z

App                Version  Status  Scale  Charm              Store       Rev  OS      Notes
easyrsa            3.0.1    active      1  easyrsa            jujucharms  117  ubuntu  
etcd               3.2.10   active      1  etcd               jujucharms  209  ubuntu  
flannel            0.10.0   active      2  flannel            jujucharms  146  ubuntu  
kubernetes-master  1.12.2   active      1  kubernetes-master  jujucharms  219  ubuntu  exposed
kubernetes-worker  1.12.2   active      1  kubernetes-worker  jujucharms  239  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
easyrsa/0*            active    idle   0/lxd/0  10.90.92.117                    Certificate Authority connected.
etcd/0*               active    idle   0        54.158.28.106   2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  active    idle   0        54.158.28.106   6443/tcp        Kubernetes master running.
  flannel/0*          active    idle            54.158.28.106                   Flannel subnet 10.1.19.1/24
kubernetes-worker/0*  active    idle   1        35.174.241.18   80/tcp,443/tcp  Kubernetes worker running.
  flannel/1           active    idle            35.174.241.18                   Flannel subnet 10.1.5.1/24

Machine  State    DNS            Inst id              Series  AZ          Message
0        started  54.158.28.106  i-00ccf0eb4565c019d  bionic  us-east-1a  running
0/lxd/0  started  10.90.92.117   juju-590f65-0-lxd-0  bionic  us-east-1a  Container started
1        started  35.174.241.18  i-0168d3ad2c1f7b27c  bionic  us-east-1b  running
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
default     aws/us-east-1  available         3      8  admin   35 minutes ago
k8s-model*  k8s-cloud      available         0      -  admin   14 seconds ago
```

## Static persistent volumes

We've now reached the step where we can achieve the main goal of this tutorial.
We will now create persistent volumes, or PVs in Kubernetes parlance. Another
way of saying this is that we will set up statically provisioned storage.

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

YAML-formatted

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

!!! Important:
    The storage class name for a statically provisioned volume must be prefixed
    with the name of the intended model. In the examples above, the model name
    is 'k8s-model'. The remainder of the name, for both operator and charm
    storage, are fixed. This is explained again further on.


### Creating persistent volumes

The actual creation of the volumes is very easy. Simply refer the `kubectl`
command to the files. We begin by installing the tool if it's not yet present:

```bash
sudo snap install --classic kubectl
kubectl create -f operator-storage.yaml
kubectl create -f charm-storage-vol1.yaml
kubectl create -f charm-storage-vol2.yaml
```

This tool is communicating directly with the cluster and can do so based on the
configuration file that was copied over earlier.

## Creating Juju storage pools

Whether or not storage volumes are provisioned statically or dynamically Juju
storage pools must be created. And this must be done for both operator storage
and charm storage.

Below we have Juju create two storage pools, one for
operator storage and one for charm storage:

```bash
```

## Deploying a Kubernetes charm

We can now deploy a Kubernetes charm. For example, here we deploy a charm by
requesting the use of the 'mariadb-pv' charm storage pool we just set up:

```bash
juju deploy cs:~wallyworld/mariadb-k8s --storage database=mariadb-pv,10M
```

The output to `juju status` should soon look like the following:

```no-highlight
```

In contrast to standard Juju behaviour, there are no machines listed here.
Let's see what has happened within the cluster:

```bash
microk8s.kubectl get all --all-namespaces
```

New sample output:

```no-highlight
```

You can easily identify the changes, as compared to the initial output, by
scanning the left hand side for the model name we chose: 'k8s-model', which
ends up being the Kubernetes "namespace".

## Removing configuration and software

To remove all traces of MicroK8s and its configuration follow these steps:

```bash
juju destroy-model -y --destroy-storage k8s-model
juju remove-k8s microk8s-cloud
microk8s.reset
sudo snap remove microk8s
```

This leaves us with LXD and Juju installed as well as a LXD controller. To
remove even those things proceed as follows:

```bash
juju destroy-controller -y lxd
sudo snap remove lxd
sudo snap remove juju
```

That's the end of this tutorial!

## Next steps

To explore using Juju with the MicroK8s project consider the following
tutorial:

[Using Juju with MicroK8s][tutorial-microk8s].

To gain experience with a standalone (non-Juju) MicroK8s installation you can
go through this Ubuntu tutorial:

[Install a local Kubernetes with MicroK8s][ubuntu-tutorial_kubernetes-microk8s].


<!-- LINKS -->

[clouds-k8s]: ./clouds-k8s.md
[upstream-cncf]: https://www.cncf.io/certification/software-conformance/
[charms-storage-k8s]: ./charms-storage-k8s.md
[ubuntu-tutorial_kubernetes-microk8s]: https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s
[charm-store-staging-aws-integrator]: https://staging.jujucharms.com/u/johnsca/aws-integrator
[upstream-kubernetes-supported-volume-types]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes
[credentials]: ./credentials.md
[install]: ./reference-install.md
