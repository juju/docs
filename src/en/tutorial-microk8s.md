Title: Using Juju with MicroK8s
TODO:  bug tracking: https://bugs.launchpad.net/juju/+bug/1804495

# Using Juju with MicroK8s

*This is in connection to the topic of
[Using Kubernetes with Juju][clouds-k8s]. See that page for background
information.*

Juju is compatible with the [MicroK8s][upstream-microk8s] project, which aims
to provide "a full Kubernetes system in under 60 seconds". It is quite
remarkable actually. It is composed of pure upstream binaries, runs all
services natively (i.e. no virtual machines or containers), and is fully
[CNCF certified][upstream-cncf]. This option is perfect for testing Kubernetes
on your personal workstation. Using it with Juju is icing on the cake!

Since MicroK8s runs locally we'll be using a local LXD cloud to create a Juju
controller.

## Installing the software

These instructions assume that you're using a fresh Ubuntu 18.04 LTS install,
or at least one that is not already using either Juju or LXD. This tutorial
installs Juju, LXD, and MicroK8s as snaps. It also removes a possibly existing
LXD deb package. Do not invoke the purge command below if you're currently
using LXD!

```bash
sudo snap install juju --classic
sudo snap install lxd
sudo snap install microk8s --classic 
sudo apt purge -y liblxc1 lxcfs lxd lxd-client
```

Enable some MicroK8s addons that will provide DNS and storage class support:

```bash
microk8s.enable dns storage
```

This will bring about changes to the cluster. See what's going on with the
`microk8s.kubectl` command:

```bash
microk8s.kubectl get all --all-namespaces
```

Sample output:

```no-highlight
NAMESPACE     NAME                                        READY   STATUS    RESTARTS   AGE
kube-system   pod/hostpath-provisioner-7d7c578f6b-rc6zz   1/1     Running   0          5m47s
kube-system   pod/kube-dns-67b548dcff-dlpgn               3/3     Running   0          5m53s

NAMESPACE     NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP         23m
kube-system   service/kube-dns     ClusterIP   10.152.183.10   <none>        53/UDP,53/TCP   5m53s

NAMESPACE     NAME                                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/hostpath-provisioner   1         1         1            1           5m47s
kube-system   deployment.apps/kube-dns               1         1         1            1           5m53s

NAMESPACE     NAME                                              DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/hostpath-provisioner-7d7c578f6b   1         1         1       5m47s
Kube-system   replicaset.apps/kube-dns-67b548dcff               1         1         1       5m53s
```

Later we'll see how this output will change once a charm is deployed.

## Creating a controller

Juju always needs a controller as a central management machine. Once this
machine is established all Juju-deployed applications will be contained within
the Kubernetes cluster itself; Juju deployments will not cause LXD containers
to be created.

So let's bring Juju into the picture by creating a controller now. At the time
of writing the production Charm Store was not yet updated with Kubernetes
charms. For now, we'll use the staging site instead:

```bash
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore localhost lxd
```

This will take about five minutes to finish. After which we'll have a
controller called 'lxd' that is based on the 'localhost' cloud.

## Adding the cluster to Juju

The `add-k8s` command adds the new Kubernetes cluster to Juju's list of known
clouds. Here, we arbitrarily call the new cloud 'microk8s-cloud':

```bash
microk8s.config | juju add-k8s microk8s-cloud
```

Confirm this by running `juju clouds`.

## Adding a model

At this point we have something interesting going on. The controller we created
earlier is now atypically associated with two clouds: the 'localhost' cloud and
the 'microk8s-cloud' cloud. So when we want to create a model we'll need
explicitly state which cloud to place the new model in. We'll do this now by
adding new model 'k8s-model' to cloud 'microk8s-cloud':

```bash
juju add-model k8s-model microk8s-cloud
```

The output to `juju models` should now look very similar to:

```no-highlight
Controller: lxd

Model       Cloud/Region         Status     Machines  Access  Last connection
controller  localhost/localhost  available         1  admin   just now
default     localhost/localhost  available         0  admin   26 minutes ago
k8s-model*  microk8s-cloud       available         0  admin   never connected
```

## Adding storage

One of the benefits of using MicroK8s is that we get dynamically provisioned
storage out of the box. Below we have Juju create two storage pools, one for
operator storage and one for charm storage:

```bash
juju create-storage-pool operator-storage kubernetes storage-class=microk8s-hostpath
juju create-storage-pool mariadb-pv kubernetes storage-class=microk8s-hostpath
```

See the [Persistent storage and Kubernetes][charms-storage-k8s] page for
in-depth information on how Kubernetes storage works with Juju.

## Deploying a Kubernetes charm

We can now deploy a Kubernetes charm. For example, here we deploy a charm by
requesting the use of the 'mariadb-pv' charm storage pool we just set up:

```bash
juju deploy cs:~wallyworld/mariadb-k8s --storage database=mariadb-pv,10M
```

The output to `juju status` should soon look like the following:

```no-highlight
Model      Controller  Cloud/Region    Version    SLA          Timestamp
k8s-model  lxd         microk8s-cloud  2.5-beta2  unsupported  18:55:56Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address         Notes
mariadb-k8s           active      1  mariadb-k8s  jujucharms   13  kubernetes  10.152.183.209  

Unit            Workload  Agent  Address   Ports     Message
mariadb-k8s/0*  active    idle   10.1.1.5  3306/TCP
```

In contrast to standard Juju behaviour, there are no machines listed here.
Let's see what has happened within the cluster:

```bash
microk8s.kubectl get all --all-namespaces
```

New sample output:

```no-highlight
NAMESPACE     NAME                                        READY   STATUS    RESTARTS   AGE
k8s-model     pod/juju-mariadb-k8s-0                      1/1     Running   0          140m
k8s-model     pod/juju-operator-mariadb-k8s-0             1/1     Running   0          140m
kube-system   pod/hostpath-provisioner-7d7c578f6b-rc6zz   1/1     Running   0          3h19m
kube-system   pod/kube-dns-67b548dcff-dlpgn               3/3     Running   0          3h19m

NAMESPACE     NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP         3h36m
k8s-model     service/juju-mariadb-k8s   ClusterIP   10.152.183.209   <none>        3306/TCP        140m
kube-system   service/kube-dns           ClusterIP   10.152.183.10    <none>        53/UDP,53/TCP   3h19m

NAMESPACE     NAME                                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/hostpath-provisioner   1         1         1            1           3h19m
kube-system   deployment.apps/kube-dns               1         1         1            1           3h19m

NAMESPACE     NAME                                              DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/hostpath-provisioner-7d7c578f6b   1         1         1       3h19m
kube-system   replicaset.apps/kube-dns-67b548dcff               1         1         1       3h19m

NAMESPACE   NAME                                         DESIRED   CURRENT   AGE
k8s-model   statefulset.apps/juju-mariadb-k8s            1         1         140m
K8s-model   statefulset.apps/juju-operator-mariadb-k8s   1         1         140m
```

You can easily identify the changes, as compared to the initial output, by
scanning the left hand side for the model name we chose: 'k8s-model', which
ends up being the Kubernetes "namespace".

To get information on pod 'juju-mariadb-k8s-0' you need to refer to the
namespace (since it's not the 'default' namespace) in this way:

```bash
microk8s.kubectl describe pods -n k8s-model juju-mariadb-k8s-0
```

The output is too voluminous to include here. See the
[upstream documentation][upstream-kubectl-viewing] on different ways of viewing
cluster information.

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

To gain experience with a standalone (non-Juju) MicroK8s installation you can
go through this Ubuntu tutorial:

[Install a local Kubernetes with MicroK8s][ubuntu-tutorial_kubernetes-microk8s].

As alluded to, some backing clouds may require you to create persistent
volumes, on top of creating the storage pools. The following tutorial will go
over this in detail:

[Setting up static Kubernetes storage][tutorial-k8s-static-pv]


<!-- LINKS -->

[clouds-k8s]: ./clouds-k8s.md
[upstream-microk8s]: https://microk8s.io
[upstream-cncf]: https://www.cncf.io/certification/software-conformance/
[charms-storage-k8s]: ./charms-storage-k8s.md
[upstream-kubectl-viewing]: https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources
[ubuntu-tutorial_kubernetes-microk8s]: https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s
[tutorial-k8s-static-pv]: ./tutorial-k8s-static-pv.md
