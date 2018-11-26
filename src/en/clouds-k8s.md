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

This page assumes you have a good understanding of
[Persistent storage and Kubernetes][charms-storage-k8s].

## Juju Kubernetes-specific workflow

The only k8s-specific Juju commands are `add-k8s`, `remove-k8s`, and
`scale-application`. All other concepts and commands are applied in the
traditional Juju manner.

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

The following steps describe the general approach for using Kubernetes with
Juju:

 1. Obtain a Kubernetes cluster
 1. Add the cluster to Juju
 1. Add a model
 1. Create persistent storage (if necessary)
 1. Create storage pools (charm storage if necessary)
 1. Deploy a Kubernetes charm

### Obtain a Kubernetes cluster

You may obtain a Kubernetes cluster in any way. However, in this document, we
deploy the cluster using Juju itself (with the 'aws' cloud). We will do
so by deploying a minimal two-machine Kubernetes cluster with the use of the
[kubernetes-core][kubernetes-core-charm] bundle available in the Charm Store:

```bash
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore aws aws
juju deploy kubernetes-core
```

!!! Note:
    We've used the staging Charm Store in these instructions as the standard
    site does not yet support Kubernetes charms and bundles.

This can take around 10 minutes to settle. Sample final output to `juju status`
looks like this:

```no-highlight
Model    Controller  Cloud/Region   Version    SLA          Timestamp
default  aws         aws/us-east-1  2.5-beta2  unsupported  19:31:40Z

App                Version  Status  Scale  Charm              Store       Rev  OS      Notes
easyrsa            3.0.1    active      1  easyrsa            jujucharms  117  ubuntu  
etcd               3.2.10   active      1  etcd               jujucharms  209  ubuntu  
flannel            0.10.0   active      2  flannel            jujucharms  146  ubuntu  
kubernetes-master  1.12.2   active      1  kubernetes-master  jujucharms  219  ubuntu  exposed
kubernetes-worker  1.12.2   active      1  kubernetes-worker  jujucharms  239  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
easyrsa/0*            active    idle   0/lxd/0  10.213.7.167                    Certificate Authority connected.
etcd/0*               active    idle   0        54.162.110.147  2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  active    idle   0        54.162.110.147  6443/tcp        Kubernetes master running.
  flannel/0*          active    idle            54.162.110.147                  Flannel subnet 10.1.81.1/24
kubernetes-worker/0*  active    idle   1        18.210.11.210   80/tcp,443/tcp  Kubernetes worker running.
  flannel/1           active    idle            18.210.11.210                   Flannel subnet 10.1.34.1/24

Machine  State    DNS             Inst id              Series  AZ          Message
0        started  54.162.110.147  i-0f94dff8233b92b3c  bionic  us-east-1a  running
0/lxd/0  started  10.213.7.167    juju-2f253d-0-lxd-0  bionic  us-east-1a  Container started
1        started  18.210.11.210   i-0a2b626f2b0c92219  bionic  us-east-1b  running
```

Please wait to get very similar output before proceeding.

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
 1. Use [MicroK8s][upstream-microk8s] where you get a local, fully compliant
    Kubernetes deployment with dynamic persistent volume support. See tutorial
    [Using Juju with microk8s][tutorial-microk8s].
 1. Use a bundle made for the major cloud vendors. There are special
    "integrator" charms that assist with such deployments.
    [Search the Charm Store][charm-store-staging-integrator] for 'integrator'.
 1. Use a public cloud vendor such as [Amazon EKS][upstream-eks-kubernetes],
    [Azure AKS][upstream-aks-kubernetes], and
    [Google GKE][upstream-gke-kubernetes].

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
add the cluster-cloud, which we have arbitrarily called 'k8s-cloud':

```bash
juju add-k8s k8s-cloud
```

Now confirm the successful addition of the cloud with the `clouds` command.

Before continuing, ensure the output to the following command does not report
anything suspicious:

```bash
kubectl describe pods
```

### Add a model

Add a model in the usual way:

```bash
juju add-model k8s-model k8s-cloud
```

This will cause a Kubernetes namespace in the cluster to be created that will
host all of the pods and other resources for that model.

### Create persistent storage

Create persistent static volumes for operator storage if your chosen backing
cloud's storage is not supported natively by Kubernetes. You will need to do
the same for charm storage if your charm has storage requirements (we will do
so since our intended charm will need storage).

Since our example scenario is using an unsupported storage solution (LXD) we'll
need to create static volumes for both types:

```bash
kubectl create -f operator-storage.yaml
kubectl create -f charm-storage-vol1.yaml
```

We can inspect these new persistent volumes (PV) and any possible storage
classes (SC):

```bash
kubectl get sc,pv
```

Output:

```no-highlight
NAME                    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS                      REASON   AGE
persistentvolume/op1    1032Mi     RWO            Retain           Available           k8s-model-juju-operator-storage            25m
persistentvolume/vol1   100Mi      RWO            Retain           Available           k8s-model-juju-unit-storage                24m
```

### Create storage pools

Create storage pools for operator storage and, if needed, charm storage. We
will need to do both for our example:

```bash
juju create-storage-pool operator-storage kubernetes \
	storage-class=juju-operator-storage \
	storage-provisioner=kubernetes.io/no-provisioner
juju create-storage-pool k8s-pool kubernetes \
	storage-class=juju-unit-storage \
	storage-provisioner=kubernetes.io/no-provisioner
```

Notice how the model name 'k8s-model' is not part of the storage class names
that show up for each static volume above. Juju will prepend the current model
when a provisioner of 'kubernetes.io/no-provisioner' is requested.

### Deploy a Kubernetes charm

It's time to deploy a Kubernetes-specific charm. Our example uses a
[MariaDB charm][charm-store-staging-mariadb-k8s] that will use the previously
created charm storage called 'k8s-pool':

```bash
juju deploy cs:~wallyworld/mariadb-k8s --storage database=k8s-pool,10M
```

The [Using Juju storage][charms-storage-juju-deploy] page covers the above
syntax.

The output to the `status` command should resemble this:

```no-highlight
Model      Controller  Cloud/Region  Version    SLA          Timestamp
k8s-model  aws         k8s-cloud     2.5-beta2  unsupported  20:52:11Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address        Notes
mariadb-k8s           active      1  mariadb-k8s  jujucharms   13  kubernetes  10.152.183.82  

Unit            Workload  Agent  Address     Ports     Message
mariadb-k8s/0*  active    idle   10.1.34.13  3306/TCP
```

Check for changes to the cluster storage objects:

```bash
kubectl -n k8s-model get sc,pv
```

Sample output:

```no-highlight
NAME                                                          PROVISIONER                    AGE
storageclass.storage.k8s.io/k8s-model-juju-operator-storage   kubernetes.io/no-provisioner   2m16s
storageclass.storage.k8s.io/k8s-model-juju-unit-storage       kubernetes.io/no-provisioner   115s

NAME                    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                               STORAGECLASS                      REASON   AGE
persistentvolume/op1    1032Mi     RWO            Retain           Bound    k8s-model/mariadb-k8s-operator-volume-juju-operator-mariadb-k8s-0   k8s-model-juju-operator-storage            25m
persistentvolume/vol1   100Mi      RWO            Retain           Bound    k8s-model/juju-database-0-juju-mariadb-k8s-0 			k8s-model-juju-unit-storage                25m
```

We see the storage classes that we specified in the YAML files are now in use
and the persistent volumes have a claim on them.

Section [Kubernetes bundles][charms-bundles-k8s] has some extra information on
bundles if that's what you're interested in.

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
[cdk-charm]: https://jujucharms.com/u/containers/canonical-kubernetes/
[upstream-kubernetes-docs]: https://kubernetes.io/docs
[upstream-kubernetes-docs-service]: https://kubernetes.io/docs/concepts/services-networking/service/
[upstream-kubernetes-docs-ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[upstream-conjure-up]: https://conjure-up.io/
[charm-store-staging-integrator]: https://staging.jujucharms.com/q/integrator
[charms-storage-k8s]: ./charms-storage-k8s.md
[charms-bundles-k8s]: ./charms-bundles.md#kubernetes-bundles
[charm-store-staging-mariadb-k8s]: https://staging.jujucharms.com/u/wallyworld/mariadb-k8s/7
[charms-storage-juju-deploy]: ./charms-storage.md#juju-deploy
[tutorial-microk8s]: ./tutorial-microk8s.md

[upstream-eks-kubernetes]: https://aws.amazon.com/eks/
[upstream-aks-kubernetes]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[upstream-gke-kubernetes]: https://cloud.google.com/kubernetes-engine/
[upstream-microk8s]: https://microk8s.io
