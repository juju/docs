Title: Using Kubernetes with Juju
TODO:  Should eventually link to k8s-charm developer documentation
       Update when storage becomes a Juju drivable aspect.
       Add architectural overview/diagram once Juju:k8s becomes stable.
       Consider manually adding a cluster (third-party installs) via `add-cloud` and `add-credential`
       Add charms section when they become available in the charm store

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
deploy the cluster using Juju itself (with the localhost cloud). We will do so
by deploying a minimal two-machine Kubernetes cluster by making use of the
[kubernetes-core][kubernetes-core-charm] bundle available in the Charm Store:

```bash
juju bootstrap localhost lxd-k8s
juju deploy kubernetes-core
```

!!! Note:
    An alternative to using the bundle is to use the `conjure-up` installer.
    See Ubuntu tutorial
    [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up]
    for guidance. Although the tutorial specifically mentions the
    [Canonical Distribution of Kubernetes][cdk-charm] you can choose the
    identical minimal install deployed above from the installer's interface.

Sample output looks like this:

```no-highlight
Model    Controller  Cloud/Region         Version    SLA
default  lxd         localhost/localhost  2.4-beta3  unsupported

App                Version  Status   Scale  Charm              Store       Rev  OS      Notes
easyrsa            3.0.1    active       1  easyrsa            jujucharms   40  ubuntu  
etcd               3.2.9    active       1  etcd               jujucharms   80  ubuntu  
flannel            0.9.1    active       2  flannel            jujucharms   56  ubuntu  
kubernetes-master  1.10.2   waiting      1  kubernetes-master  jujucharms  104  ubuntu  exposed
kubernetes-worker  1.10.2   active       1  kubernetes-worker  jujucharms  118  ubuntu  exposed

Unit                  Workload  Agent      Machine  Public address  Ports           Message
easyrsa/0*            active    idle       0/lxd/0  10.0.219.187                    Certificate Authority connected.
etcd/0*               active    idle       0        10.191.96.169   2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  waiting   executing  0        10.191.96.169   6443/tcp        (config-changed) Waiting for kube-system pods to start
  flannel/0*          active    idle                10.191.96.169                   Flannel subnet 10.1.21.1/24
kubernetes-worker/0*  active    executing  1        10.191.96.126   80/tcp,443/tcp  (config-changed) Kubernetes worker running.
  flannel/1           active    idle                10.191.96.126                   Flannel subnet 10.1.69.1/24

Machine  State    DNS            Inst id              Series  AZ  Message
0        started  10.191.96.169  juju-c841ac-0        xenial      Running
0/lxd/0  started  10.0.219.187   juju-c841ac-0-lxd-0  xenial      Container started
1        started  10.191.96.126  juju-c841ac-1        xenial      Running

Controller Timestamp
23 May 2018 14:00:52Z
```

### Add the cluster to Juju

We will need some information about the cluster in order to add it to Juju.
This is found within the main Kubernetes configuration file.

!!! Note:
    If `conjure-up` was used to install the cluster then the rest of this
    section can be skipped; this install method adds the cluster for you.

#### Adding quickly (bundle installs)

If the `juju deploy` command was used to deploy the cluster the above file can
be copied over from the Kubernetes master node (and saved as `~/.kube/config`)
in this way:

```bash
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
```

We can now take advantage of the `add-k8s` command as it internally parses the
copied configuration file from the specified path. This allows us to quickly
add the cluster-cloud, which we have arbitrarily called 'k8scloud':

```bash
juju add-k8s k8scloud
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
juju add-model k8smodel
```

This will cause a Kubernetes namespace in the cluster to be created that will
host all of the pods and other resources for that model.

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
[upstream-kubernetes-docs]: https://kubernetes.io/docs
[credentials]: ./credentials.md
