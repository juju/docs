*This is in connection to the topic of [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090). See that page for background information.*

Juju is compatible with the [MicroK8s](https://microk8s.io) project, which aims to provide "a full Kubernetes system in under 60 seconds". It is quite remarkable actually. It is composed of pure upstream binaries, runs all services natively (i.e. no virtual machines or containers), and is fully [CNCF certified](https://www.cncf.io/certification/software-conformance/). This option is perfect for testing Kubernetes on your personal workstation. Using it with Juju is icing on the cake!

This tutorial was written using Juju `v.2.6.0` and MicroK8s `v1.14.1`.

<h2 id="heading--installing-the-software">Installing the software</h2>

These instructions assume that you're using a fresh Ubuntu 18.04 LTS install, or at least one that is not already using Juju. This tutorial installs Juju and MicroK8s as snaps.

``` text
sudo snap install juju --classic
sudo snap install microk8s --classic 
```

We now need to add our account to the `microk8s` group, which grants the account elevated privileges to the cluster:

```text
sudo usermod -a -G microk8s $USER
``` 

Now let's inspect the cluster with the `microk8s.kubectl` command:

``` text
microk8s.kubectl get all --all-namespaces
```

Do not proceed until you see output similar to:

```text
NAMESPACE   NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
default     service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   22s
```

Now enable some MicroK8s addons that will provide DNS and storage class support:

```text
microk8s.enable dns storage
```

This will bring about changes to the cluster. Re-invoking the last command should eventually give you something like this:

```text
NAMESPACE     NAME                                        READY   STATUS    RESTARTS   AGE
kube-system   pod/hostpath-provisioner-6d744c4f7c-t9hgh   1/1     Running   0          2m50s
kube-system   pod/kube-dns-6bfbdd666c-rxnp9               3/3     Running   0          2m56s

NAMESPACE     NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP         3m55s
kube-system   service/kube-dns     ClusterIP   10.152.183.10   <none>        53/UDP,53/TCP   2m56s

NAMESPACE     NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/hostpath-provisioner   1/1     1            1           2m50s
kube-system   deployment.apps/kube-dns               1/1     1            1           2m56s

NAMESPACE     NAME                                              DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/hostpath-provisioner-6d744c4f7c   1         1         1       2m50s
kube-system   replicaset.apps/kube-dns-6bfbdd666c               1         1         1       2m56s
```

Later we'll see how this output will change once a charm is deployed.

<h2 id="heading--creating-a-controller">Creating a controller</h2>

Juju `v.2.6.0` recognises when MicroK8s is installed and automatically sets up a cloud called 'microk8s'. There is no need to manually add the cluster to Juju (verify this with `juju clouds --local`). A controller can then be created just like a normal cloud. Here we've called it 'mk8s':

```text
juju bootstrap microk8s mk8s
```

Confirm the live cloud by running `juju clouds`.

<h2 id="heading--adding-a-model">Adding a model</h2>

In `v.2.6.0` a model can be added like you would for any other cloud:

```text
juju add-model k8s-model
```

The output to `juju models` should now look very similar to:

```text
Controller: mk8s

Model       Cloud/Region        Type        Status     Access  Last connection
controller  microk8s/localhost  kubernetes  available  admin   just now
k8s-model*  microk8s            kubernetes  available  admin   never connected
```

Notice that there is no 'default' model.

<h2 id="heading--adding-storage">Adding storage</h2>

One of the benefits of using MicroK8s is that we get dynamically provisioned storage out of the box. Below we create two storage pools, one for operator storage and one for workload storage:

```text
juju create-storage-pool operator-storage
juju create-storage-pool mariadb-pv
```

<h2 id="heading--deploying-a-kubernetes-charm">Deploying a Kubernetes charm</h2>

We can now deploy a Kubernetes charm. For example, here we deploy a charm by requesting the use of the 'mariadb-pv' workload storage pool we just set up:

```text
juju deploy cs:~juju/mariadb-k8s --storage database=mariadb-pv,10M
```

The output to `juju status` should soon look like the following:

```text
Model      Controller  Cloud/Region  Version    SLA          Timestamp
k8s-model  mk8s        microk8s      2.6-beta2  unsupported  14:47:20Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address         Notes
mariadb-k8s           active      1  mariadb-k8s  jujucharms    1  kubernetes  10.152.183.153  

Unit            Workload  Agent  Address    Ports     Message
mariadb-k8s/0*  active    idle   10.1.1.15  3306/TCP
```

In contrast to standard Juju behaviour, there are no machines listed here. Let's see what has happened within the cluster:

```text
microk8s.kubectl get all --all-namespaces
```

New sample output:

```text
NAMESPACE         NAME                                        READY   STATUS    RESTARTS   AGE
controller-mk8s   pod/controller-0                            2/2     Running   1          6m6s
k8s-model         pod/mariadb-k8s-0                           1/1     Running   0          77s
k8s-model         pod/mariadb-k8s-operator-0                  1/1     Running   0          93s
kube-system       pod/hostpath-provisioner-6d744c4f7c-t9hgh   1/1     Running   0          9m39s
kube-system       pod/kube-dns-6bfbdd666c-rxnp9               3/3     Running   0          9m45s

NAMESPACE         NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
controller-mk8s   service/controller-service   ClusterIP   10.152.183.168   <none>        17070/TCP       6m7s
default           service/kubernetes           ClusterIP   10.152.183.1     <none>        443/TCP         10m
k8s-model         service/mariadb-k8s          ClusterIP   10.152.183.153   <none>        3306/TCP        76s
kube-system       service/kube-dns             ClusterIP   10.152.183.10    <none>        53/UDP,53/TCP   9m45s

NAMESPACE     NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/hostpath-provisioner   1/1     1            1           9m39s
kube-system   deployment.apps/kube-dns               1/1     1            1           9m45s

NAMESPACE     NAME                                              DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/hostpath-provisioner-6d744c4f7c   1         1         1       9m39s
kube-system   replicaset.apps/kube-dns-6bfbdd666c               1         1         1       9m45s

NAMESPACE         NAME                                    READY   AGE
controller-mk8s   statefulset.apps/controller             1/1     6m6s
k8s-model         statefulset.apps/mariadb-k8s            1/1     77s
k8s-model         statefulset.apps/mariadb-k8s-operator   1/1     93s
```

You can easily identify the changes, as compared to the initial output, by scanning the left hand side for our model name 'k8s-model', which runs in a Kubernetes namespace of the same name. The operator/controller pod runs in a namespace whose name is based on our controller name ('mk8s'): 'controller-mk8s'.

To get information on pod 'mariadb-k8s-0' you need to refer to the namespace (since it's not the 'default' namespace) in this way:

```text
microk8s.kubectl describe pods -n k8s-model mariadb-k8s-0
```

The output is too voluminous to include here. See the [upstream documentation](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources) on different ways of viewing cluster information.

<h2 id="heading--removing-configuration-and-software">Removing configuration and software</h2>

To remove all traces of what we've done in this tutorial use the following commands:

```text
juju kill-controller -y -t 0 mk8s
microk8s.reset
sudo snap remove microk8s
sudo snap remove juju
```

That's the end of this tutorial!

<h2 id="heading--next-steps">Next steps</h2>

Consider the following tutorials:

-   [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192)
-   [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193)

To gain experience with a standalone (non-Juju) MicroK8s installation check out Ubuntu tutorial [Install a local Kubernetes with MicroK8s](https://tutorials.ubuntu.com/tutorial/install-a-local-kubernetes-with-microk8s).
