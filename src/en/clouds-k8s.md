Title: Using Kubernetes with Juju
TODO:  Should eventually link to k8s-charm developer documentation
       Add architectural overview/diagram
       Consider manually adding a cluster (third-party installs) via `add-cloud` and `add-credential`
       Change from staging store to production store when available
       Link to Discourse posts for microk8s, aws-integrator?
       Write a tutorial or two on building a cluster using the methods listed

# Using Kubernetes with Juju

Kubernetes provides a flexible architecture for managing containerised
applications at scale (see the
[Kubernetes documentation][upstream-kubernetes-docs] for more information). It
most commonly employs Docker as its container technology.

## Juju k8s-specific workflow

The only k8s-specific Juju commands are `add-k8s` and `remove-k8s`. All other
concepts and commands are applied in the traditional Juju manner.

If the Kubernetes cluster is built with Juju itself (via a bundle) and
`juju add-k8s` is run immediately afterwards, the contents of file
`~/.kube/config` (if it exists) is used to add the cluster and the credentials
to Juju, making the usual combination of `add-cloud` and `add-credential`
unnecessary.

User credentials can still be added by way of the `add-credential` or
`autoload-credentials` commands. Also, at any time, the k8s CLI can be used to
add a new user to the k8s cluster.

The `add-k8s` command can be used repeatedly to set up different clusters as
long as the contents of the configuration file has been changed accordingly.
The KUBECONFIG environment variable is useful here as it will be honoured by
Juju when finding the file to load.

We'll demonstrate the use of the `add-k8s` command below.
    
## Using Kubernetes with Juju

First off, a Kubernetes cluster will be required. Essentially, you will use it
as you would any other cloud that Juju interacts with: the cluster becomes the
backing cloud.

To summarise, the steps for using Kubernetes with Juju are:

 1. Obtain a Kubernetes cluster
 1. Add the cluster to Juju
 1. Add a model
 1. Define storage classes (if necessary)
 1. Create storage pools (charm storage if necessary)
 1. Deploy a Kubernetes-specific charm

### Obtain a Kubernetes cluster

You may obtain a Kubernetes cluster in any way. However, in this document, we
deploy the cluster using Juju itself (with the 'localhost' cloud). We will do
so by deploying a minimal two-machine Kubernetes cluster by making use of the
[kubernetes-core][kubernetes-core-charm] bundle available in the Charm Store:

```bash
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore localhost lxd-k8s
juju deploy kubernetes-core
```

Sample output to `juju status` looks like this:

```no-highlight
Model    Controller  Cloud/Region         Version    SLA          Timestamp
default  lxd-k8s     localhost/localhost  2.5-beta1  unsupported  17:38:29Z

App                Version  Status   Scale  Charm              Store       Rev  OS      Notes
easyrsa            3.0.1    active       1  easyrsa            jujucharms  117  ubuntu  
etcd               3.2.10   active       1  etcd               jujucharms  209  ubuntu  
flannel            0.10.0   active       2  flannel            jujucharms  146  ubuntu  
kubernetes-master  1.12.2   waiting      1  kubernetes-master  jujucharms  219  ubuntu  exposed
kubernetes-worker  1.12.2   active       1  kubernetes-worker  jujucharms  239  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
easyrsa/0*            active    idle   0/lxd/0  10.232.236.186                  Certificate Authority connected.
etcd/0*               active    idle   0        10.80.187.237   2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  waiting   idle   0        10.80.187.237   6443/tcp        Waiting for kube-system pods to start
  flannel/0*          active    idle            10.80.187.237                   Flannel subnet 10.1.24.1/24
kubernetes-worker/0*  active    idle   1        10.80.187.177   80/tcp,443/tcp  Kubernetes worker running.
  flannel/1           active    idle            10.80.187.177                   Flannel subnet 10.1.34.1/24

Machine  State    DNS             Inst id              Series  AZ  Message
0        started  10.80.187.237   juju-2ad61f-0        bionic      Running
0/lxd/0  started  10.232.236.186  juju-2ad61f-0-lxd-0  bionic      Container started
1        started  10.80.187.177   juju-2ad61f-1        bionic      Running
```

!!! Note:
    We've used the staging Charm Store in these instructions as the standard
    site does not yet contain Kubernetes charms and bundles.

#### Alternative methods for obtaining a Kubernetes cluster

Here is a list of alternative methods to explore for setting up a Kubernetes
cluster:

 1. Use the 'canonical-kubernetes' bundle, which is a more sophisticated
    version of what we used above.
 1. Use the [`conjure-up`][upstream-conjure-up] installer. See Ubuntu tutorial
    [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up]
    for guidance. Although the tutorial specifically mentions the
    [Canonical Distribution of Kubernetes][cdk-charm] you can choose the
    identical minimal install deployed above from the installer's interface.
 1. Use [`microk8s`][upstream-microk8s]. With microk8s, you get a local, fully
    compliant Kubernetes deployment with dynamic persistent volume support.
 1. Use a bundle made for the major cloud vendors. There are special
    "integrator" charms that assist with such deployments.
    [Search the Charm Store][charm-store-staging-integrator] for 'integrator'.
 1. Use a public cloud vendor such as [Amazon EKS][upstream-eks-kubernetes],
    [Azure AKS][upstream-aks-kubernetes],
    [Google GKE][upstream-gke-kubernetes], and
    [DigitalOcean Kubernetes][upstream-dok-kubernetes].

### Add the cluster to Juju

We will need some information about the cluster in order to add it to Juju.
This is found within the main Kubernetes configuration file.

!!! Note:
    If `conjure-up` was used to install the cluster then the rest of this
    section can be skipped; this install method adds the cluster for you.

#### Adding a juju-deployed cluster quickly

If Juju was used to deploy the cluster, as we've done in this example, the
above file can be copied over from the Kubernetes master node (and saved as
`~/.kube/config`) in this way:

```bash
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
```

We can now take advantage of the `add-k8s` command as it internally parses the
copied configuration file from the specified path. This allows us to quickly
add the cluster-cloud, which we have arbitrarily called 'lxd-k8s-cloud':

```bash
juju add-k8s lxd-k8s-cloud
```

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud          Regions  Default          Type        Description
.
.
.
lxd-k8s-cloud        0                   kubernetes
```

### Add a model

Add a model in the usual way:

```bash
juju add-model lxd-k8s-model lxd-k8s-cloud
```

This will cause a Kubernetes namespace in the cluster to be created that will
host all of the pods and other resources for that model.

### Define storage classes

Define a storage class for operator storage if your chosen backing cloud's
storage is not supported natively by Kubernetes. You will need to do the same
for charm storage if your charm has storage requirements (we will do so since
our intended charm will need storage).

Here, since our example is using an unsupported storage solution (LXD)
we'll create storage classes for both types:

```bash
kubectl create -f lxd-k8s-model-op1.yaml
kubectl create -f lxd-k8s-model-vol1.yaml
```

See [Persistent storage and Kubernetes][charms-storage-k8s] for more
information.

### Create storage pools

Create storage pools for operator storage and, if needed, charm storage. We
will need to do both for our example:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=lxd-k8s-model-operator-storage \
	storage-provisioner=kubernetes.io/no-provisioner
juju create-storage-pool lxd-k8s-pool kubernetes \
	storage-class=lxd-k8s-model-charm-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

Again, refer to [Persistent storage and Kubernetes][charms-storage-k8s] for
more information.

### Deploy a Kubernetes-specific charm

Deploy a Kubernetes charm. This example uses a
[MariaDB charm][charm-store-staging-mariadb-k8s] that will make use of the
previously created charm storage called 'lxd-k8s-pool':

```bash
juju deploy cs:~wallyworld/mariadb-k8s --storage database=10M,lxd-k8s-pool
```

The [Using Juju storage][charms-storage-juju-deploy] page covers the above
syntax.

## Configuration

Kubernetes charms support Kubernetes-specific settings that influence how Juju
deploys the application. The following are supported (these names are the Juju
configuration attribute names; the Kubernetes meaning should be self-evident):

| Key                        			| Type    | Default 	     | Valid values | Comments                     |
|:----------------------------------------------|---------|------------------|--------------|:-----------------------------|
kubernetes-service-type				| string  | ClusterIP 	     |		    |
kubernetes-service-external-ips			| string  | []		     |		    |
kubernetes-service-target-port			| string  | <container port> |		    |
kubernetes-service-loadbalancer-ip		| string  | ""		     |		    |
kubernetes-service-loadbalancer-sourceranges	| string  | []		     |		    |
kubernetes-service-externalname			| string  | ""		     |		    |
kubernetes-ingress-class			| string  | nginx	     |		    |
kubernetes-ingress-ssl-redirect			| boolean | false	     |		    |
kubernetes-ingress-ssl-passthrough		| boolean | false	     |		    |
kubernetes-ingress-allow-http			| boolean | false	     |		    |

There are three other configuration attributes which are not k8s-specific:

| Key                        			| Type    | Default 	     | Valid values | Comments                     |
|:----------------------------------------------|---------|------------------|--------------|:-----------------------------|
juju-external-hostname				| string  | 		     |              | Mandatory; user specified
juju-application-path				| string  | "/"		     |              |

Attributes 'juju-external-hostname' and 'juju-application-path' control how the
application is exposed externally using a Kubernetes Ingress Resource in
conjunction with the configured ingress controller (default: nginx).

Juju uses a deployment controller for each application to manage pod lifecycle,
which allows for the addition or removal of units as normal. It remains
possible to perform these same actions directly in the cluster by way of the
Kubernetes `scale` command.


<!-- LINKS -->

[kubernetes-core-charm]: https://jujucharms.com/kubernetes-core/
[ubuntu-tutorial_install-kubernetes-with-conjure-up]: https://tutorials.ubuntu.com/tutorial/install-kubernetes-with-conjure-up#0
[cdk-charm]: https://jujucharms.com/u/containers/canonical-kubernetes/
[upstream-kubernetes-docs]: https://kubernetes.io/docs
[upstream-conjure-up]: https://conjure-up.io/
[charm-store-staging-integrator]: https://staging.jujucharms.com/q/integrator
[charms-storage-k8s]: ./charms-storage-k8s.md
[charm-store-staging-mariadb-k8s]: https://staging.jujucharms.com/u/wallyworld/mariadb-k8s/7
[charms-storage-juju-deploy]: ./charms-storage.md#juju-deploy

[upstream-eks-kubernetes]: https://aws.amazon.com/eks/
[upstream-aks-kubernetes]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[upstream-gke-kubernetes]: https://cloud.google.com/kubernetes-engine/
[upstream-dok-kubernetes]: https://www.digitalocean.com/products/kubernetes/
[upstream-microk8s]: https://microk8s.io
