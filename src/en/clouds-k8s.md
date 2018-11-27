Title: Using Kubernetes with Juju
TODO:  Should eventually link to k8s-charm developer documentation
       Add architectural overview/diagram
       Consider manually adding a cluster via `add-cloud` and `add-credential`
       Change from staging store to production store when available
       Link to Discourse posts on aws-integrator?
       Write tutorial on building a cluster using GKE
       Write tutorial on building a cluster using AWS
       Example done with AWS since a LXD bundle needs each of its charms to specify profile edits according to https://is.gd/dqXGN2

# Using Kubernetes with Juju

Kubernetes ("k8s") provides a flexible architecture for managing containerised
applications at scale (see the
[Kubernetes documentation][upstream-kubernetes-docs] for more information). It
most commonly employs Docker as its container technology.

These instructions refer to page
[Persistent storage and Kubernetes][charms-storage-k8s] in a few places. You
may want to familiarise yourself with it now.

## Juju Kubernetes-specific workflow

The only k8s-specific Juju commands are `add-k8s`, `remove-k8s`, and
`scale-application`. All other concepts and commands are applied in the
traditional Juju manner.

The `add-k8s` command is used to add the Kubernetes cluster to Juju's list of
known clouds and import its credentials. The cluster configuration file will
first need to be copied to `~/.kube/config`. This command makes the usual
combination of `add-cloud` and `add-credential` unnecessary.

User credentials can still be added by way of the `add-credential` or
`autoload-credentials` commands. Also, at any time, the k8s CLI can be used to
add a new user to the k8s cluster.

The `add-k8s` command can be used repeatedly to set up different clusters as
long as the contents of the configuration file has been changed accordingly.
The KUBECONFIG environment variable is useful here as it will be honoured by
Juju when finding the file to load.

The `remove-k8s` command is used to remove a Kubernetes cluster from Juju's
list of known clouds.

The `scale-application` command is used to scale a Kubernetes cluster. The
`add-unit` and `remove-unit` commands cannot be applied to a Kubernetes model.

## Using Kubernetes with Juju

First off, a Kubernetes cluster will be required. Essentially, you will use it
as you would any other cloud that Juju interacts with: the cluster becomes the
backing cloud.

The following steps describe the general approach for using Kubernetes with
Juju:

 1. Obtain a Kubernetes cluster
 1. Add the cluster to Juju
 1. Add a model
 1. Create persistent storage (if necessary)
 1. Create storage pools
 1. Deploy a Kubernetes charm

### Obtain a Kubernetes cluster

There are many ways to obtain a Kubernetes cluster. Here is a list of
suggestions:

 - Use the [kubernetes-core][kubernetes-core-charm] bundle, which gives a
   minimal two-machine cluster available in the Charm Store.
 - Use the [canonical-kubernetes][kubernetes-cdk-charm] bundle. This is the
   Canonical Distribution of Kubernetes (CDK), which is a more sophisticated
   version of what we used above.
 - Use the [conjure-up][upstream-conjure-up] installer. See Ubuntu tutorial
   [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up]
   for guidance. Although the tutorial specifically mentions the CDK bundle
   you can choose the core bundle from the installer's interface.
 - Use [MicroK8s][upstream-microk8s] where you get a local, fully compliant
   Kubernetes deployment with dynamic persistent volume support. See tutorial
   [Using Juju with microk8s][tutorial-microk8s].
 - Use a bundle made for the major cloud vendors. There are special
   "integrator" charms that assist with such deployments.
   [Search the Charm Store][charm-store-staging-integrator] for 'integrator'.
 - Use a public Kubernetes cloud vendor such as
   [Amazon EKS][upstream-eks-kubernetes],
   [Azure AKS][upstream-aks-kubernetes], and
   [Google GKE][upstream-gke-kubernetes].

!!! Note:
    Kubernetes bundles do not work well on a LXD cloud at this time. Refer to 
    [Deploying on LXD][kubernetes-deploying-on-lxd] for details.

### Add the cluster to Juju

We will need some information about the cluster in order to add it to Juju.
This is found within the main Kubernetes configuration file.

!!! Note:
    If `conjure-up` was used to install the cluster then the rest of this
    section can be skipped; this install method adds the cluster for you.

The configuration file can be copied over from the Kubernetes master node (and
saved as `~/.kube/config`). Here is one way you can do this if Juju was used to
install the cluster:

```bash
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
```

We can now take advantage of the `add-k8s` command as it internally parses the
copied configuration file from the specified path. This allows us to quickly
add the cluster-cloud, which we have arbitrarily called 'k8s-cloud':

```bash
juju add-k8s k8s-cloud
```

Now confirm the successful addition of the cloud with the `clouds` command.

### Add a model

Add a model in the usual way. We've arbitrarily called it 'k8s-model':

```bash
juju add-model k8s-model k8s-cloud
```

This will cause a Kubernetes namespace in the cluster to be created that will
host all of the pods and other resources for that model. The namespace is the
name of the Juju model. A Kubernetes Juju model also starts off with a storage
pool called 'kubernetes'. You can see this with the `storage-pools` command.

!!! Note:
    We reuse the model name of 'k8s-model' elsewhere on this page to designate,
    in general, a Kubernetes model.

### Create persistent storage

Create persistent static volumes for operator storage if your chosen backing
cloud's storage is not supported natively by Kubernetes. You will need to do
the same for charm storage if your charm has storage requirements. Here, we
show examples for creating static volumes for both types:

```bash
kubectl create -f operator-storage.yaml
kubectl create -f charm-storage-vol1.yaml
```

For assistance with the contents of these files see section
[Statically provisioned volumes][charms-storage-k8s-static-pv].

### Create storage pools

Create storage pools for operator storage and, if needed, charm storage. We
show examples for creating pools of both types:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/no-provisioner
juju create-storage-pool k8s-pool kubernetes \
	storage-class=juju-unit-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

For details on creating storage pools see section
[Storage pool creation][charms-storage-k8s-pool-creation].

### Deploy a Kubernetes charm

A Kubernetes-specific charm is deployed in standard fashion. If the charm has
storage requirements you will need to specify them, as you do with a normal
charm. For example, here is a charm that uses the previously created charm
storage called 'k8s-pool':

```bash
juju deploy cs:~wallyworld/mariadb-k8s --storage database=k8s-pool,10M
```

The [Using Juju storage][charms-storage-juju-deploy] page covers the above
syntax.

If you want to deploy a Kubernetes bundles see section
[Kubernetes bundles][charms-bundles-k8s].

#### Configuration

The below table lists configuration keys supported by Kubernetes charms that
are set at deploy time. The corresponding Kubernetes meaning can be obtained
from the Kubernetes documentation for
[Services][upstream-kubernetes-docs-service] and
[Ingress][upstream-kubernetes-docs-ingress].

| Key                        			| Type    | Default 	     | Valid values | Comments                     |
|:----------------------------------------------|---------|------------------|--------------|:-----------------------------|
`kubernetes-service-type`			| string  | ClusterIP 	     |		    |
`kubernetes-service-external-ips`		| string  | []		     |		    |
`kubernetes-service-target-port`		| string  | <container port> |		    |
`kubernetes-service-loadbalancer-ip` 		| string  | ""		     |		    |
`kubernetes-service-loadbalancer-sourceranges`	| string  | []		     |		    |
`kubernetes-service-externalname`		| string  | ""		     |		    |
`kubernetes-ingress-class`			| string  | nginx	     |		    |
`kubernetes-ingress-ssl-redirect`		| boolean | false	     |		    |
`kubernetes-ingress-ssl-passthrough`		| boolean | false	     |		    |
`kubernetes-ingress-allow-http`			| boolean | false	     |		    |

For example:

```bash
juju deploy mariadb-k8s --config kubernetes-service-loadbalancer-ip=10.1.1.1
```

There are two other keys that are not Kubernetes-specific:

| Key                        			| Type    | Default 	     | Valid values | Comments                     |
|:----------------------------------------------|---------|------------------|--------------|:-----------------------------|
`juju-external-hostname`			| string  | ""   	     |              |
`juju-application-path` 			| string  | "/"		     |              |

Keys 'juju-external-hostname' and 'juju-application-path' control how the
application is exposed externally using a Kubernetes Ingress Resource in
conjunction with the configured ingress controller (default: nginx).

## Inspect cluster storage objects

List cluster storage objects such as storage classes (SC), persistent
volumes (PV), and persistent volume claims (PVC) in this way:

```bash
kubectl -n k8s-model get sc,pv,pvc
```

Drill down into Kubernetes objects such as pods and PVCs with the following
commands:

```bash
kubectl -n k8s-model describe pods
kubectl -n k8s-model describe pvc
```


<!-- LINKS -->

[kubernetes-core-charm]: https://jujucharms.com/kubernetes-core/
[ubuntu-tutorial_install-kubernetes-with-conjure-up]: https://tutorials.ubuntu.com/tutorial/install-kubernetes-with-conjure-up#0
[kubernetes-cdk-charm]: https://jujucharms.com/u/containers/canonical-kubernetes/
[upstream-kubernetes-docs]: https://kubernetes.io/docs
[upstream-kubernetes-docs-service]: https://kubernetes.io/docs/concepts/services-networking/service/
[upstream-kubernetes-docs-ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[upstream-conjure-up]: https://conjure-up.io/
[charm-store-staging-integrator]: https://staging.jujucharms.com/q/integrator
[charms-storage-k8s]: ./charms-storage-k8s.md
[charms-storage-k8s-static-pv]: ./charms-storage-k8s.md#statically-provisioned-volumes
[charms-storage-k8s-pool-creation]: ./charms-storage-k8s.md#storage-pool-creation
[charms-bundles-k8s]: ./charms-bundles.md#kubernetes-bundles
[charms-storage-juju-deploy]: ./charms-storage.md#juju-deploy
[tutorial-microk8s]: ./tutorial-microk8s.md
[kubernetes-deploying-on-lxd]: https://github.com/juju-solutions/bundle-canonical-kubernetes/wiki/Deploying-on-LXD

[upstream-eks-kubernetes]: https://aws.amazon.com/eks/
[upstream-aks-kubernetes]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[upstream-gke-kubernetes]: https://cloud.google.com/kubernetes-engine/
[upstream-microk8s]: https://microk8s.io
