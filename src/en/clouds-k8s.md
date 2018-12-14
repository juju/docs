Title: Using Kubernetes with Juju
TODO:  Should eventually link to k8s-charm developer documentation
       Add architectural overview/diagram
       Consider manually adding a cluster via `add-cloud` and `add-credential`
       Change from staging store to production store when available
       Write tutorial on building a cluster using GCE with gcp-integrator
       Write tutorial on building a cluster using AWS with aws-integrator
       Example done with AWS since a LXD bundle needs each of its charms to specify profile edits according to https://is.gd/dqXGN2

# Using Kubernetes with Juju

Kubernetes ("k8s") provides a flexible architecture for managing containerised
applications at scale. See the
[Kubernetes documentation][upstream-kubernetes-docs] for more information.

Juju has the ability to add a Kubernetes cluster to its known list of clouds,
thereby treating the cluster like it does any other cloud. There are some
differences to working with such a cloud and they are covered in the next
section.

This document refers to page
[Persistent storage and Kubernetes][charms-storage-k8s] in a few places. You
may want to familiarise yourself with it now.

## Juju Kubernetes-specific workflow

The k8s-specific Juju commands are `add-k8s`, `remove-k8s`, and
`scale-application`. All other concepts and commands are applied in the
traditional manner.

The `add-k8s` command is used to add the Kubernetes cluster to Juju's list of
known clouds and import its credentials. The cluster configuration file will
first need to be copied to `~/.kube/config`. This command makes the usual
combination of `add-cloud` and `add-credential` unnecessary.

User credentials can still be added by way of the `add-credential` or
`autoload-credentials` commands. Also, at any time, the k8s CLI can be used to
add a new user to the cluster.

The `add-k8s` command can be used repeatedly to set up different clusters as
long as the contents of the configuration file has been changed accordingly.
The KUBECONFIG environment variable is useful here as it will be honoured by
Juju when finding the file to load.

The `remove-k8s` command is used to remove a Kubernetes cluster from Juju's
list of known clouds.

The `scale-application` command is used to scale a Kubernetes cluster. The
`add-unit` and `remove-unit` commands do not apply to a Kubernetes model.

A Kubernetes cloud also requires Kubernetes-specific charms.

!!! Note:
    Kubernetes charms are currently only available on the
    [staging Charm Store][charm-store-staging] and are for developmental and
    testing purposes only.

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
   minimal two-machine cluster available in the Charm Store. The tutorial
   [Setting up static Kubernetes storage][tutorial-k8s-static-pv] uses this
   bundle.
 - Use the [canonical-kubernetes][kubernetes-cdk-charm] bundle. This is the
   Canonical Distribution of Kubernetes (CDK), which is a more sophisticated
   version of 'kubernetes-core'.
 - Use the [conjure-up][upstream-conjure-up] installer. See the following
   resources for guidance:
     - The Ubuntu tutorial:
       [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up]
     - The upstream getting started guide:
       [Spell Walkthrough][upstream-conjure-up-guide]
 - Use [MicroK8s][upstream-microk8s]. This gives you get a local, fully
   compliant Kubernetes deployment with dynamic persistent volume support. See
   tutorial [Using Juju with microk8s][tutorial-microk8s].
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
    The `conjure-up` installer adds the cluster for you. The rest of this
    section can be skipped if that's what you used.

The configuration file can be copied over from the Kubernetes master node (and
saved as `~/.kube/config`). Here is one way you can do this if Juju was used to
install the cluster:

```bash
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
```

We can now take advantage of the `add-k8s` command as it will parse the
configuration file if copied to the above path. This allows us to quickly add
the cluster, which we have arbitrarily called 'k8s-cloud':

```bash
juju add-k8s k8s-cloud
```

Confirm the successful addition of the cloud with the `clouds` command.

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
    in general, a Kubernetes Juju model.

### Create persistent storage

Create persistent static volumes for operator storage if your chosen backing
cloud's storage is not supported natively by Kubernetes. You will need to do
the same for charm storage if your charm has storage requirements. Here, we
show examples for creating static volumes for both types:

```bash
kubectl create -f operator-storage.yaml
kubectl create -f charm-storage-vol1.yaml
```

For in-depth coverage on this topic see tutorial
[Setting up static Kubernetes storage][tutorial-k8s-static-pv].

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

The above tutorial also covers storage pool creation!

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

If you want to deploy a Kubernetes bundle see section
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


<!-- LINKS -->

[kubernetes-core-charm]: https://jujucharms.com/kubernetes-core/
[ubuntu-tutorial_install-kubernetes-with-conjure-up]: https://tutorials.ubuntu.com/tutorial/install-kubernetes-with-conjure-up#0
[kubernetes-cdk-charm]: https://jujucharms.com/u/containers/canonical-kubernetes/
[charm-store-staging]: https://staging.jujucharms.com
[charm-store-staging-integrator]: https://staging.jujucharms.com/q/integrator
[charms-storage-k8s]: ./charms-storage-k8s.md
[charms-bundles-k8s]: ./charms-bundles.md#kubernetes-bundles
[charms-storage-juju-deploy]: ./charms-storage.md#juju-deploy
[tutorial-microk8s]: ./tutorial-microk8s.md
[tutorial-k8s-static-pv]: ./tutorial-k8s-static-pv.md
[kubernetes-deploying-on-lxd]: https://github.com/juju-solutions/bundle-canonical-kubernetes/wiki/Deploying-on-LXD

[upstream-kubernetes-docs]: https://kubernetes.io/docs
[upstream-kubernetes-docs-service]: https://kubernetes.io/docs/concepts/services-networking/service/
[upstream-kubernetes-docs-ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[upstream-eks-kubernetes]: https://aws.amazon.com/eks/
[upstream-aks-kubernetes]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[upstream-gke-kubernetes]: https://cloud.google.com/kubernetes-engine/
[upstream-microk8s]: https://microk8s.io
[upstream-conjure-up]: https://conjure-up.io/
[upstream-conjure-up-guide]: https://docs.conjure-up.io/stable/en/walkthrough
