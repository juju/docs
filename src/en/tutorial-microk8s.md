Title: Using Juju with microk8s

# Using Juju with microk8s

*This is in connection with the [Using Kubernetes with Juju][clouds-k8s] page.
See that resource for background information.*

This tutorial has the following pre-requisites:


# Software installation

These instructions assume you're using a fresh Ubuntu 18.04 LTS install, or at
least one that is not already using either Juju or LXD. This tutorial installs
Juju, LXD, and microk8s as snaps. It also removes a possibly existing LXD deb
package. Do not invoke the purge command below if you're currently using LXD!

```bash
sudo snap install juju --classic
sudo snap install lxd
sudo snap install microk8s --classic 
sudo apt purge -y liblxc1 lxcfs lxd lxd-client
```

Enable some microk8s addons that will provide DNS and storage class support:

```bash
microk8s.enable dns storage
```

This will bring about changes to the cluster. See what's going on with the
`microk8s.kubectl` command:

```bash
microk8s.kubectl get all --all-namespaces
```

It's time to bring Juju in to the picture by creating a controller. At the time
of writing the production Charm Store was not yet updated with Kubernetes
charms. For now, we'll use the staging site instead:

```bash
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore localhost lxd
```

This will take about five minutes to finish.

The `add-k8s` command adds the new Kubernetes cluster to Juju's list of known
clouds. Here, we arbitrarily call the new cloud 'microk8s-cloud':

```bash
microk8s.config | juju add-k8s microk8s-cloud
```

Confirm this by running `juju clouds`.

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

One of the benefits of using `microk8s` is that we get dynamically provisioned
storage out of the box. Below we have Juju create two storage pools, one for
operator storage and one for charm storage:

```bash
juju create-storage-pool operator-storage kubernetes storage-class=microk8s-hostpath
juju create-storage-pool mariadb-pv kubernetes storage-class=microk8s-hostpath
```

See the [Persistent storage and Kubernetes][charms-storage-k8s] page for
in-depth information on how Kubernetes storage works with Juju.

We can deploy a Kubernetes charm. For example, here we deploy a charm by
requesting the use of the 'mariadb-pv' charm storage pool we just set up:

```bash
juju deploy cs:~wallyworld/mariadb-k8s --storage database=mariadb-pv,10M
```

The output to `juju status` should soon look like:

```no-highlight
Model      Controller  Cloud/Region    Version    SLA          Timestamp
k8s-model  lxd         microk8s-cloud  2.5-beta2  unsupported  18:55:56Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address         Notes
mariadb-k8s           active      1  mariadb-k8s  jujucharms   13  kubernetes  10.152.183.209  

Unit            Workload  Agent  Address   Ports     Message
mariadb-k8s/0*  active    idle   10.1.1.5  3306/TCP
```


<!-- LINKS -->

[clouds-k8s]: ./clouds-k8s.md
[upstream-microk8s]: https://microk8s.io
[charms-storage-k8s]: ./charms-storage-k8s.md
