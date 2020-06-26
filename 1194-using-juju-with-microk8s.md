<!--
TODO

- explain difference between clouds stored on the client vs controller

 -->


Juju works well with [MicroK8s](https://microk8s.io) to provide a full  [CNCF-certified](https://www.cncf.io/certification/software-conformance/) Kubernetes system in under 60 seconds.

<h2 id="heading--installing-the-software">Install and set up MicroK8s</h2>

> For installation instructions for other platforms, including Windows 10, macOS, ARM devices such as Raspberry Pi and LXD, see the [MicroK8s documentation](https://microk8s.io/docs).


The easiest way to install MicroK8s is via the snap:

``` text
sudo snap install microk8s --classic 
```

### Join the `microk8s` group

Add your account to the `microk8s` group. This grants the account elevated privileges to the cluster, meaning that sudo will not be required to interact with `microk8s`:

```text
sudo usermod -a -G microk8s $USER
```

This command requires you to log out and log back in before the changes are applied. 

```text
su - $USER
```

Alternatively, exit the shell by executing `exit` or by using <kbd>Ctrl</kbd> + <kbd>D</kbd> and restart your session.


### Await installation

MicroK8s will take a few minutes to install all of its components.

```text
microk8s status --wait-ready
```

### Verify installation

Now let's inspect the cluster with the `microk8s.kubectl` command:

``` text
microk8s.kubectl get all --all-namespaces
```

You should see output similar to:

```text
NAMESPACE   NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
default     service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   22s
```

It's possible that you encounter an error message relating to permissions. If this happens, execute  `sudo usermod -a -G microk8s $USER` and restart. 

```plain
Insufficient permissions to access MicroK8s.
You can either try again with sudo or add the user ubuntu to the 'microk8s' group:

    sudo usermod -a -G microk8s $USER

The new group will be available on the user's next login.
```



### Enable DNS and storage addons

Now enable some MicroK8s addons that will provide DNS and storage class support:

```text
microk8s.enable dns storage
```

This will bring about changes to the cluster. Re-invoking the `microk8s.kubectl get all --all-namespaces` should eventually give you something like this:

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

## Install Juju

Juju, like MicroK8s, is easiest to install via the snap: 

```plain
sudo snap install juju --classic
```

For other installation methods, see the [Installing Juju](/t/installing-juju/1164) page.

<h2 id="heading--creating-a-controller">Creating a controller</h2>

Juju recognises when MicroK8s is installed and automatically sets up a cloud called 'microk8s'. There is no need to manually add the cluster to Juju (verify this with `juju clouds --local`). A controller can then be created just like a normal cloud. Here we've called it 'micro':

```text
juju bootstrap microk8s micro
```

https://discourse.jujucharms.com/uploads/default/original/1X/ca1da0a2e668d808ea8d078fc78beef452e85013.mp4 

[note type=important status="Important term - cloud"]
Within the Juju community, the term cloud has a specific meaning. A cloud is a target that Juju knows how to manage workloads for. Kubernetes clusters, including MicroK8s, are often referred to as "k8s clouds".
[/note]

[note status="Using a version of Juju earlier than v2.6.0"]
Earlier versions of Juju did not have built-in support for MicroK8s. You should upgrade your version of Juju to the current stable release. If that's not possible, you can use `juju add-k8s` to register your MicroK8s cluster with Juju.
[/note]

### Verify the bootstrap process

Confirm the microk8s cloud is live by running `juju clouds`. It should be visible within the controller and client sections.

```plain
$ juju clouds
Only clouds with registered credentials are shown.
There are more clouds, use --all to see them.

Clouds available on the controller:
Cloud     Regions  Default    Type
microk8s  1        localhost  k8s  

Clouds available on the client:
Cloud           Regions  Default            Type       Credentials  Source    Description
[...]
microk8s        1        localhost          k8s        1            built-in  A Kubernetes Cluster
[...]
```



[note type=important status="Important concept - clouds"]
A cloud, as a Juju term, means a deployment target. A cloud includes API endpoints and credential information.

In Juju, you interact with the _client_ (the `juju` command on your local machine). It connects to a _controller_. The controller is hosted on a _cloud_ and controls _models_.

A cloud can be registered on the controller, the client or both. Registering a cloud with the client allows the client to bootstrap a new controller onto it. Registering a cloud with a controller allows it to control models hosted on multiple providers.
[/note]

<h2 id="heading--adding-a-model">Adding a model</h2>

A model is a container for a set of related applications. That model represents resources needed for the applications within it, including compute, storage and network. 

```text
juju add-model testing
```
https://discourse.jujucharms.com/uploads/default/original/1X/88e808884b25f675bc59c067a6f0f4a842a831da.mp4 

[note type=important status="Difference from traditional clouds"]
There is no 'default' model provided on k8s clouds. Creating a model implies creating a Kubernetes namespace. Rather than pollute your cluster's namespaces, Juju favours an explicit approach.
[/note]

### Verifying that the model has been added 

Use the `juju models` command to list models hosted on the cloud. It will look very similar to:

```text
$ juju models
Controller: micro

Model       Cloud/Region        Type        Status     Access  Last connection
controller  microk8s/localhost  kubernetes  available  admin   just now
testing*    microk8s            kubernetes  available  admin   never connected
```


<!---

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

--->

<h2 id="heading--deploying-a-kubernetes-charm">Deploying a Kubernetes charm</h2>

We can now deploy a Kubernetes charm. For example, here we deploy a charm by requesting the use of the 'mariadb-pv' workload storage pool we just set up:

```text
juju deploy cs:~juju/mariadb-k8s --storage database=10M
```
https://discourse.jujucharms.com/uploads/default/original/1X/5c9ee6d9a4c831a32657f2dfe0554b09c65dc1b9.mp4 



### Verify deployment

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
testing           service/mariadb-k8s          ClusterIP   10.152.183.153   <none>        3306/TCP        76s
kube-system       service/kube-dns             ClusterIP   10.152.183.10    <none>        53/UDP,53/TCP   9m45s

NAMESPACE     NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/hostpath-provisioner   1/1     1            1           9m39s
kube-system   deployment.apps/kube-dns               1/1     1            1           9m45s

NAMESPACE     NAME                                              DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/hostpath-provisioner-6d744c4f7c   1         1         1       9m39s
kube-system   replicaset.apps/kube-dns-6bfbdd666c               1         1         1       9m45s

NAMESPACE         NAME                                    READY   AGE
controller-mk8s   statefulset.apps/controller             1/1     6m6s
testing           statefulset.apps/mariadb-k8s            1/1     77s
testing          statefulset.apps/mariadb-k8s-operator   1/1     93s
```

You can easily identify the changes, as compared to the initial output, by scanning the left hand side for our model name 'k8s-model', which runs in a Kubernetes namespace of the same name. The operator/controller pod runs in a namespace whose name is based on our controller name ('mk8s'): 'controller-mk8s'.

To get information on pod 'mariadb-k8s-0' you need to refer to the namespace (since it's not the 'default' namespace) in this way:

```text
microk8s.kubectl describe pods -n testing mariadb-k8s-0
```

The output is too voluminous to include here. See the [upstream documentation](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources) on different ways of viewing cluster information.

<h2 id="heading--removing-configuration-and-software">Removing configuration and software</h2>

To remove all traces of what we've done in this tutorial, use the following commands:

```text
juju kill-controller -y -t 0 mk8s
microk8s.reset
sudo snap remove microk8s
sudo snap remove juju
```

That's the end of this tutorial!

<h2 id="heading--next-steps">Next steps</h2>

- Learn more about [using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090)
