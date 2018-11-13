Title: Using Kubernetes with Juju
TODO:  Should eventually link to k8s-charm developer documentation
       Update when storage becomes a Juju drivable aspect.
       Add architectural overview/diagram once Juju:k8s becomes stable.
       Consider manually adding a cluster (third-party installs) via `add-cloud` and `add-credential`
       Add charms section when they become available in the charm store (change from staging store to production store)
       Link to Discourse posts for microk8s, aws-integrator?

# Using Kubernetes with Juju

Kubernetes provides a flexible architecture for managing containerised
applications at scale (see the
[Kubernetes documentation][upstream-kubernetes-docs] for more information). It
most commonly employs Docker as its container technology.

!!! Note:
    Kubernetes is often abbreviated as "k8s" (pronounced "kate's").

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
 1. Create a controller (and optionally a model)
 1. Deploy k8s-specific charms

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
    site does not yet contain the Kubernetes charms and bundles.

**Alternative methods for obtaining a Kubernetes cluster**  
Beyond your own custom/bespoke Kubernetes cluster, here is a list of
alternative methods to explore for setting one up:

 1. Use the 'canonical-kubernetes' bundle, which is a more sophisticated
    version of what we used above.
 1. Use the [`conjure-up`][upstream-conjure-up] installer. See Ubuntu tutorial
    [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up]
    for guidance. Although the tutorial specifically mentions the
    [Canonical Distribution of Kubernetes][cdk-charm] you can choose the
    identical minimal install deployed above from the installer's interface.
 1. Use [`microk8s`][upstream-microk8s]. With microk8s, you get a local, fully
    compliant Kubernetes deployment with dynamic persistent volume support, and
    a running ingres controller.
 1. Use a bundle made for the major cloud vendors. There are special
    "integrator" charms that assist with such deployments.
    [Search the Charm Store][charm-store-integrator] for 'integrator'.
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

If the `juju deploy` command was used to deploy the cluster the above file can
be copied over from the Kubernetes master node (and saved as `~/.kube/config`)
in this way:

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
Cloud        Regions  Default          Type        Description
.
.
.
k8scloud           0                   kubernetes
```

## Add a model

Add a model in the usual way:

```bash
juju add-model lxd-k8s-model lxd-k8s-cloud
```

This will cause a Kubernetes namespace in the cluster to be created that will
host all of the pods and other resources for that model.

## Juju and Kubernetes storage

For each Juju-deployed Kubernetes application an *operator pod* is
automatically set up whose task it is to run the charm hooks for each deployed
unit’s charm.

Each charm requires persistent storage so that things like state and resources
can be preserved if the pod ever restarts. To accomplish this, a Juju storage
pool called 'operator-storage' with the provider type 'kubernetes' must exist.

### Operator storage

Operator storage is set up by defining a Juju storage pool that maps to a
Kubernetes storage class. Below are some examples using various Kubernetes
storage provisioners:

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

### Charm storage

## Configuration

Juju k8s applications support application specific configuration. This allows
k8s configuration to be used to control how Juju deploys the application on
Kubernetes. The following are supported (these names are the Juju configuration
attribute names; the k8s meaning should be obvious):

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
[credentials]: ./credentials.md
[upstream-kubernetes-docs]: https://kubernetes.io/docs
[upstream-microk8s]: https://microk8s.io
[upstream-conjure-up]: https://conjure-up.io/
[charm-store-integrator]: https://staging.jujucharms.com/q/integrator

[upstream-eks-kubernetes]: https://aws.amazon.com/eks/
[upstream-aks-kubernetes]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[upstream-gke-kubernetes]: https://cloud.google.com/kubernetes-engine/
[upstream-dok-kubernetes]: https://www.digitalocean.com/products/kubernetes/
