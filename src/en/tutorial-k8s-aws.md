Title: Using the aws-integrator charm - tutorial

# Using the aws-integrator charm - tutorial

*This is in connection to the topic of
[Using Kubernetes with Juju][clouds-k8s]. See that page for background
information.*

This tutorial will demonstrate the use of the '[aws-integrator][charm-aws]'
charm with the AWS cloud to make Kubernetes **dynamic** persistent volumes
(PVs) available for use with Kubernetes-specific charms.

## Prerequisites

The following prerequisites are assumed as a starting point for this tutorial:

 - You're using Ubuntu 18.04 LTS.
 - Juju (stable snap channel) is installed. See the [Installing Juju][install]
   page.
 - A credential for the 'aws' cloud has been added to Juju. See the
   [Using Amazon AWS with Juju][clouds-aws] page.
 - Sufficient permissions are assigned to the above credential in order for
   'aws-integrator' to perform operations (see
   [Permissions Requirements][github-aws-integrator-permissions]; this tutorial
   assigns the IAM security policy of 'AdministratorAccess').

## Installing Kubernetes

Let's begin by creating a controller. We'll call it 'aws-k8s':

```bash
juju bootstrap aws aws-k8s
```

We'll deploy Kubernetes using the '[kubernetes-core][charm-kc]' bundle, which
will give us a minimalist cluster. However, we'll add the integrator charm to
the mix by means of an overlay bundle that we'll store in file
`k8s-aws-overlay.yaml`:

```yaml
applications:
  aws-integrator:
    charm: cs:~containers/aws-integrator
    num_units: 1
relations:
  - ['aws-integrator', 'kubernetes-master']
  - ['aws-integrator', 'kubernetes-worker']
```

See [Overlay bundles][charms-bundles-overlays] for details on overlays.

We can now deploy the cluster like so:

```bash
juju deploy kubernetes-core --overlay k8s-aws-overlay.yaml
juju trust aws-integrator
```

The `trust` command grants 'aws-integrator' access to the credential used in
the `bootstrap` command. This charm acts as a proxy for the Kubernetes nodes to
create and attach dynamic storage volumes in the AWS backing cloud.

It will take about ten minutes to get a stable `status` command output:

```bash
juju status
```

Our example shows:

```no-highlight
Model    Controller  Cloud/Region   Version  SLA          Timestamp
default  aws-k8s     aws/us-east-1  2.5.0    unsupported  03:28:12Z

App                Version  Status  Scale  Charm              Store       Rev  OS      Notes
aws-integrator     1.15.71  active      1  aws-integrator     jujucharms    8  ubuntu  
easyrsa            3.0.1    active      1  easyrsa            jujucharms  195  ubuntu  
etcd               3.2.10   active      1  etcd               jujucharms  338  ubuntu  
flannel            0.10.0   active      2  flannel            jujucharms  351  ubuntu  
kubernetes-master  1.13.2   active      1  kubernetes-master  jujucharms  542  ubuntu  exposed
kubernetes-worker  1.13.2   active      1  kubernetes-worker  jujucharms  398  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
aws-integrator/0*     active    idle   0        3.90.20.92                      ready
easyrsa/0*            active    idle   0/lxd/0  10.57.10.22                     Certificate Authority connected.
etcd/0*               active    idle   0        3.90.20.92      2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  active    idle   0        3.90.20.92      6443/tcp        Kubernetes master running.
  flannel/1           active    idle            3.90.20.92                      Flannel subnet 10.1.101.1/24
kubernetes-worker/0*  active    idle   1        54.160.5.2      80/tcp,443/tcp  Kubernetes worker running.
  flannel/0*          active    idle            54.160.5.2                      Flannel subnet 10.1.11.1/24

Machine  State    DNS          Inst id              Series  AZ          Message
0        started  3.90.20.92   i-06b046ea0ade98e9c  bionic  us-east-1a  running
0/lxd/0  started  10.57.10.22  juju-06e5d4-0-lxd-0  bionic  us-east-1a  Container started
1        started  54.160.5.2   i-04c67dc1d633c2794  bionic  us-east-1b  running
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

## Dynamic persistent volumes

As opposed to static Kubernetes persistent volumes, dynamic PVs do not need to
be created in advance. They will be created on an as-needed basis by the
cluster. This is generally the preferred method.

Tutorial [Setting up static Kubernetes storage][tutorial-k8s-static-pv] shows
how to set up static PVs and includes information on how to inspect a
cluster and its various objects using the `kubectl` tool.

## Creating Juju storage pools

The storage pool name for operator storage *must* be called 'operator-storage'
while the pool name for charm storage is arbitrary. Here, our charm has
storage requirements so we'll need a pool for it. We'll call it 'k8s-pool'. It
is this charm storage pool that will be used at charm deployment time.

For dynamic AWS volumes, the Kubernetes provisioner is `kubernetes.io/aws-ebs`.
We will also request a general purpose SSD drive by passing the `gp2`
parameter.

Our two storage pools are therefore created like this:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/aws-ebs parameters.type=gp2
```

```bash
juju create-storage-pool k8s-pool kubernetes \
	storage-class=juju-unit-storage \
	storage-provisioner=kubernetes.io/aws-ebs parameters.type=gp2
```

## Deploying a Kubernetes charm

We can now deploy a Kubernetes charm. For example, here we deploy a charm by
requesting the use of the 'k8s-pool' charm storage pool we just set up:

```bash
juju deploy cs:~juju/gitlab-k8s
juju deploy cs:~juju/mariadb-k8s --storage database=k8s-pool,10M
juju add-relation gitlab-k8s mariadb-k8s
```

The output to `juju status` should soon look similar to this:

```no-highlight
Model      Controller  Cloud/Region  Version  SLA          Timestamp
k8s-model  aws         k8s-cloud     2.5.0    unsupported  18:57:16Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address         Notes
gitlab-k8s            active      1  gitlab-k8s   jujucharms    0  kubernetes  10.152.183.184  
mariadb-k8s           active      1  mariadb-k8s  jujucharms    0  kubernetes  10.152.183.221  

Unit            Workload  Agent  Address     Ports     Message
gitlab-k8s/0*   active    idle   10.1.11.14  80/TCP    
mariadb-k8s/0*  active    idle   10.1.11.13  3306/TCP
```

Congratulations, you deployed a Kubernetes workload using dynamically
provisioned volumes through the use of the AWS integrator charm!

## Removing configuration and software

To remove all traces of Kubernetes and its configuration follow these steps:

```bash
juju destroy-model -y --destroy-storage k8s-model
juju remove-k8s k8s-cloud
rm -rf ~/.kube
```

This leaves us with Juju installed as well as an AWS controller. To remove
even those things proceed as follows:

```bash
juju destroy-controller -y --destroy-all-models aws-k8s
sudo snap remove juju
```

## Next steps

Consider the following tutorials:

 - [Setting up static Kubernetes storage][tutorial-k8s-static-pv]
 - [Using Juju with MicroK8s][tutorial-microk8s]

To gain experience with a standalone (non-Juju) MicroK8s installation check
out Ubuntu tutorial
[Install a local Kubernetes with MicroK8s][ubuntu-tutorial-kubernetes-microk8s].


<!-- LINKS -->

[clouds-k8s]: ./clouds-k8s.md
[ubuntu-tutorial-kubernetes-microk8s]: https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s
[charm-store-staging-aws-integrator]: https://staging.jujucharms.com/u/johnsca/aws-integrator
[kubernetes-supported-volume-types]: https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes
[install]: ./reference-install.md
[tutorial-microk8s]: ./tutorial-microk8s.md
[tutorial-k8s-static-pv]: ./tutorial-k8s-static-pv.md
[kubernetes-hostpath]: https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
[charms-bundles-overlays]: ./charms-bundles.md#overlay-bundles
[clouds-aws]: ./clouds-aws.md
[charm-kc]: https://jujucharms.com/kubernetes-core/
[charm-aws]: https://jujucharms.com/u/containers/aws-integrator/
[github-aws-integrator-permissions]: https://github.com/juju-solutions/charm-aws-integrator#permissions-requirements

<!-- IMAGES -->

[storage-pools]: https://assets.ubuntu.com/v1/26ff0c70-storage-pools-2.png
[sc-pv-pvc]: https://assets.ubuntu.com/v1/a8cc75dd-sc-pv-pvc-2.png
[volumes]: https://assets.ubuntu.com/v1/34f93a4b-volumes-2.png
