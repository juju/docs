*This is in connection to the topic of [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090). See that page for background information.*

This tutorial will demonstrate the use of the '[aws-integrator](https://jujucharms.com/u/containers/aws-integrator/)' charm with the AWS cloud to make Kubernetes **dynamic** persistent volumes (PVs) available for use with Kubernetes-specific charms.

<h2 id="heading--prerequisites">Prerequisites</h2>

The following prerequisites are assumed as a starting point for this tutorial:

- You're using Ubuntu 18.04 LTS.
- Juju `v.2.5.0` is installed. See the [Installing Juju](/t/installing-juju/1164) page.
- A credential for the 'aws' cloud has been added to Juju. See the [Using Amazon AWS with Juju](/t/using-amazon-aws-with-juju/1084) page.
- Sufficient permissions are assigned to the above credential in order for 'aws-integrator' to perform operations (see [Permissions Requirements](https://github.com/juju-solutions/charm-aws-integrator#permissions-requirements); this tutorial assigns the IAM security policy of 'AdministratorAccess').

<h2 id="heading--installing-kubernetes">Installing Kubernetes</h2>

Let's begin by creating a controller. We'll call it 'aws-k8s':

``` text
juju bootstrap aws aws-k8s
```

We'll deploy Kubernetes using the '[kubernetes-core](https://jujucharms.com/kubernetes-core/)' bundle, which will give us a minimalist cluster. We'll add the integrator charm to the mix by means of an overlay bundle that we'll store in file `k8s-aws-overlay.yaml`:

``` yaml
applications:
  aws-integrator:
    charm: cs:~containers/aws-integrator
    num_units: 1
relations:
  - ['aws-integrator', 'kubernetes-master']
  - ['aws-integrator', 'kubernetes-worker']
```

See [Overlay bundles](/t/charm-bundles/1058#heading--overlay-bundles) for details on overlays.

We can now deploy the cluster like so:

``` text
juju deploy kubernetes-core --overlay k8s-aws-overlay.yaml
juju trust aws-integrator
```

The `trust` command grants 'aws-integrator' access to the credential used in the `bootstrap` command. This charm acts as a proxy for the Juju machines, acting as Kubernetes nodes, to create and attach dynamic storage volumes in the AWS backing cloud.

[note type=caution]
When a cluster is not built, but merely added, such as one originating from a public Kubernetes service like Azure's AKS or Google's GKE, then an integrator charm is not required. Ready-made clusters have storage built in.
[/note]

It will take about ten minutes to arrive at a stable `status` command output:

```text
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

<h2 id="heading--adding-the-cluster-to-juju">Adding the cluster to Juju</h2>

We'll now copy over the cluster's main configuration file and then use the `add-k8s` command to add the cluster to Juju's list of known clouds. Here, we arbitrarily call the new cloud 'k8s-cloud':

``` text
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
juju add-k8s k8s-cloud
```

The success of this operation can be confirmed by running `juju clouds`.

<h2 id="heading--adding-a-model">Adding a model</h2>

When we add a Kubernetes cluster to Juju we effectively have two clouds being managed by one controller. For us, they are named 'aws' and 'k8s-cloud'. So when we want to create a model we'll need explicitly state which cloud to place the new model in. We'll do this now by adding a model called 'k8s-model' to cloud 'k8s-cloud':

``` text
juju add-model k8s-model k8s-cloud
```

<h2 id="heading--dynamic-persistent-volumes">Dynamic persistent volumes</h2>

As opposed to static Kubernetes persistent volumes, dynamic PVs do not need to be created in advance. They will be created on an as-needed basis by the cluster. This is generally the preferred method.

Tutorial [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193) shows how to set up static PVs and includes information on how to inspect a cluster and its various objects using the `kubectl` tool.

<h2 id="heading--creating-juju-storage-pools">Creating Juju storage pools</h2>

The storage pool name for operator storage *must* be called 'operator-storage' while the pool name for workload storage is arbitrary. Here, our charm has storage requirements so we'll need a pool for it. We'll call it 'k8s-pool'. It is this workload storage pool that will be used at charm deployment time.

For dynamic AWS volumes, the Kubernetes provisioner is `kubernetes.io/aws-ebs`. We will also request a general purpose SSD drive by passing the `gp2` parameter.

Our two storage pools are therefore created like this:

``` text
juju create-storage-pool operator-storage kubernetes \
    storage-class=juju-operator-storage \
    storage-provisioner=kubernetes.io/aws-ebs parameters.type=gp2
```

``` text
juju create-storage-pool k8s-pool kubernetes \
    storage-class=juju-unit-storage \
    storage-provisioner=kubernetes.io/aws-ebs parameters.type=gp2
```

<h2 id="heading--deploying-a-kubernetes-charm">Deploying a Kubernetes charm</h2>

We can now deploy a Kubernetes charm. For example, here we deploy a charm by requesting the use of the 'k8s-pool' workload storage pool we just set up:

``` text
juju deploy cs:~juju/gitlab-k8s
juju deploy cs:~juju/mariadb-k8s --storage database=k8s-pool,10M
juju add-relation gitlab-k8s mariadb-k8s
```

The output to `juju status` should soon look similar to this:

``` text
Model      Controller  Cloud/Region  Version  SLA          Timestamp
k8s-model  aws         k8s-cloud     2.5.0    unsupported  18:57:16Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address         Notes
gitlab-k8s            active      1  gitlab-k8s   jujucharms    0  kubernetes  10.152.183.184  
mariadb-k8s           active      1  mariadb-k8s  jujucharms    0  kubernetes  10.152.183.221  

Unit            Workload  Agent  Address     Ports     Message
gitlab-k8s/0*   active    idle   10.1.11.14  80/TCP    
mariadb-k8s/0*  active    idle   10.1.11.13  3306/TCP
```

Congratulations, you deployed a Kubernetes workload using dynamically provisioned volumes through the use of the AWS integrator charm!

<h2 id="heading--removing-configuration-and-software">Removing configuration and software</h2>

To remove all traces of Kubernetes and its configuration follow these steps:

``` text
juju destroy-model -y --destroy-storage k8s-model
juju remove-k8s k8s-cloud
rm -rf ~/.kube
```

This leaves us with Juju installed as well as an AWS controller. To remove even those things proceed as follows:

``` text
juju destroy-controller -y --destroy-all-models aws-k8s
sudo snap remove juju
```

<h2 id="heading--next-steps">Next steps</h2>

Consider the following tutorials:

- [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193)
- [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194)
- [Multi-cloud controller with GKE and auto-configured storage](/t/tutorial-multi-cloud-controller-with-gke-and-auto-configured-storage/1465)
- [Installing Kubernetes with CDK and using auto-configured storage](/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469)

To gain experience with a standalone (non-Juju) MicroK8s installation check out Ubuntu tutorial [Install a local Kubernetes with MicroK8s](https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s).
