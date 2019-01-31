Title: Using Kubernetes with Juju
TODO:  Should eventually link to k8s-charm developer documentation
       Add architectural overview/diagram
       Consider manually adding a cluster via `add-cloud` and `add-credential`
       Write tutorial on building a cluster using GCE with azure-integrator

# Using Kubernetes with Juju

Kubernetes ("k8s") provides a flexible architecture for managing containerised
applications at scale. See the
[Kubernetes documentation][upstream-kubernetes-docs] for more information.

The objective of this page is to give an overview of how an existing Kubernetes
cluster can be integrated with Juju and what the general workflow is once
that's done. Links will be provided to pages that preset more theory as well as
to practical tutorials. Although this page is not about showing how to install
Kubernetes itself, we do give pointers on how to do so.

Essentially, Juju is able to treat the added cluster as it does any other of
its known clouds (i.e. create models and deploy charms). There are some
differences to working with such a cloud and they are called out in the
following section.

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

Charms need to be written specifically for a Juju:Kubernetes context.

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

 - Use the '[kubernetes-core][charm-kc]' bundle, which gives a minimal
   two-machine cluster available in the Charm Store.
 - Use the '[canonical-kubernetes][charm-cdk]' bundle. This is the Canonical
   Distribution of Kubernetes (CDK), which is a more sophisticated version of
   'kubernetes-core'.
 - Use the [conjure-up][upstream-conjure-up] installer.
 - Use [MicroK8s][upstream-microk8s]. This gives you a local, fully compliant
   Kubernetes deployment with dynamic persistent volume support.
 - When Kubernetes is deployed via charms, special integrator charms made for
   specific cloud vendors can greatly assist (e.g. storage).
   [Search the Charm Store][charm-store-integrator] for 'integrator'.
 - Use a public Kubernetes cloud vendor such as
   [Amazon EKS][upstream-eks-kubernetes],
   [Azure AKS][upstream-aks-kubernetes], and
   [Google GKE][upstream-gke-kubernetes].

!!! Note:
    Kubernetes bundles do not work well on a LXD cloud at this time. Refer to 
    [Deploying on LXD][kubernetes-deploying-on-lxd] for details.

### Add the cluster to Juju

Information about the cluster is needed in order to add it to Juju. This is
found within the main Kubernetes configuration file that can be copied over
from the Kubernetes master node (and saved as `~/.kube/config`). We can then
take advantage of the `add-k8s` command as it will parse the configuration file
if copied to the above path. This allows us to quickly add the cluster.

Note that the `conjure-up` installer adds the cluster for you.

### Add a model

Add a model in the usual way, with the `add-model` command. This will cause a
Kubernetes namespace in the cluster to be created that will host all of the
pods and other resources for that model. The namespace is the name of the Juju
model. A Kubernetes Juju model also starts off with a storage pool called
'kubernetes'.

### Create persistent storage

Create persistent static volumes for operator storage if your chosen backing
cloud's storage is not supported natively by Kubernetes. You will need to do
the same for charm storage if your charm has storage requirements. This is done
with the Kubernetes tool `kubectl`.

### Create storage pools

Create storage pools for operator storage and, if needed, charm storage. This
is done in the usual way, with the `create-storage-pool` command.

### Deploy a Kubernetes charm

A Kubernetes-specific charm is deployed in standard fashion, with the `deploy`
command. If the charm has storage requirements you will need to specify them,
as you do with a normal charm.

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

## Storage theory and practical guides

Page [Persistent storage and Kubernetes][charms-storage-k8s] explains how Juju
works with Kubernetes storage.

The following practical guides are available:

 - The `conjure-up` installer can be used to install Kubernetes. See the
   following resources for guidance:
     - The Ubuntu tutorial:
       [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up]
     - The upstream getting started guide:
       [Spell Walkthrough][upstream-conjure-up-guide]
 - Tutorial [Setting up static Kubernetes storage][tutorial-k8s-static-pv]
   shows how to set up statically provisioned persistent volumes with Juju by
   way of the 'kubernetes-core' charm.
 - Tutorial [Using Juju with MicroK8s][tutorial-microk8s] provides steps for
   getting started with Juju and MicroK8s.
 - Tutorial [Using the aws-integrator charm][tutorial-k8s-aws] demonstrates
   deploying Kubernetes with Juju on AWS with an integrator charm.


<!-- LINKS -->

[charm-cdk]: https://jujucharms.com/canonical-kubernetes/
[charm-kc]: https://jujucharms.com/kubernetes-core/
[ubuntu-tutorial_install-kubernetes-with-conjure-up]: https://tutorials.ubuntu.com/tutorial/install-kubernetes-with-conjure-up#0
[charm-store-integrator]: https://jujucharms.com/q/integrator
[charms-storage-k8s]: ./charms-storage-k8s.md
[tutorial-microk8s]: ./tutorial-microk8s.md
[tutorial-k8s-static-pv]: ./tutorial-k8s-static-pv.md
[tutorial-k8s-aws]: ./tutorial-k8s-aws.md
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
