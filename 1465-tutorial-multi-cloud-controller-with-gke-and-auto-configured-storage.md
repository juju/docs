*This is in connection to the topic of [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090). See that page for background information.*

This tutorial will demonstrate how to take advantage of the auto-configuration of Kubernetes **dynamic** persistent volumes (PVs) for use with Kubernetes-specific charms. This is normally done when your backing cloud has a storage type that is supported natively by Kubernetes. Here, we'll use a GKE-based cluster that, naturally, does. The cluster will be added, as a cloud, to an existing GCE-based controller.

<h2 id="heading--prerequisites">Prerequisites</h2>

The following prerequisites are assumed as a starting point for this tutorial:

- You're using Ubuntu 18.04 LTS.
- Juju `v.2.6.0` is installed. See the [Installing Juju](/t/installing-juju/1164) page.
- A GKE cluster exists and is available to be added to Juju. See appendix [Installing a GKE cluster](/t/appendix-installing-a-gke-cluster/1448) for assistance in building such a cluster.
- The Google CLI tools are installed local to the Juju client and configured. See [Install the Google CLI tools](/t/appendix-installing-a-gke-cluster/1448#heading--install-the-google-cli-tools) in the above appendix. 
- A GCE-based controller exists and is managed by the local Juju client. See the [Using Google GCE with Juju](/t/using-google-gce-with-juju/1088) page for help.

<h2 id="heading--adding-the-cluster-to-an-existing-controller">Adding the cluster to an existing controller</h2>

We'll use the `add-k8s` command to add the cluster to an existing GCE-based controller called 'gce'. The `--gke` option invokes the installed Google CLI tools to allow for communication with the GKE provider (i.e. Google). Here, our existing GKE cluster happens to be called 'hello-cluster':

```text
juju add-k8s -c gce --gke hello-cluster
```

You will be asked to confirm your settings. If the Google CLI tools have been fully configured you shouldn't need to enter any information. You will simply need to confirm default values by pressing ENTER. A sample session:

```text
Available Accounts
  javierlarin72@gmail.com

Select account [javierlarin72@gmail.com]: {ENTER}

Available Projects
  juju-239814
  juju-gce-1225


Select project [juju-239814]: {ENTER}

Available Clusters
  hello-cluster in us-east4

Select cluster [hello-cluster in us-east4]: {ENTER}
```

The fact that the cluster was added without error indicates that the auto-configuration of storage was successful for both operator storage and workload storage.

The success of this operation can be confirmed by running `juju clouds -c gce`. Here is the command output:

```text
Clouds on controller "gce":

Cloud          Regions  Default     Type  Description
google              18  asia-east1  gce   
hello-cluster        1  us-east4    k8s
```

<h2 id="heading--adding-a-model-to-a-multi-cloud-controller">Adding a model to a multi-cloud controller</h2>

We want to create a Kubernetes model. Since the controller now manages two clouds ('google' and 'hello-cluster') we need to specify which cloud we're interested in. Here, we create a model called 'turbo' for the 'hello-cluster' cloud:

```text
juju add-model turbo hello-cluster
```

The output to `juju models` should now look like this:

```text
Controller: gce

Model       Cloud/Region     Type        Status     Machines  Cores  Units  Access  Last connection
controller  google/us-east1  gce         available         1      4  -      admin   just now
default     google/us-east1  gce         available         0      -  -      admin   2 hours ago
turbo*      hello-cluster    kubernetes  available         0      -  2      admin   3 minutes ago
```

<h2 id="heading--deploying-kubernetes-charms">Deploying Kubernetes charms</h2>

We can now deploy a Kubernetes charm. For simplicity, we'll start with a charm that does not have storage requirements:

```text
juju deploy cs:~juju/gitlab-k8s
```

Next we add a charm that does have storage requirements:

```text
juju deploy cs:~juju/mariadb-k8s --storage database=10M
```

Because dynamic storage was set up automatically when the cluster was added there is no need to specify a  storage pool. If we did, the value for the `--storage` option would have looked like `database=<pool-name>,10M`.

Now we add a relation between the two applications:

```text
juju add-relation gitlab-k8s mariadb-k8s
```

The output to `juju status --relations` should eventually stabilise to the following:

```text
Model  Controller  Cloud/Region   Version  SLA          Timestamp
turbo  gce         hello-cluster  2.6-rc2  unsupported  20:08:45Z

App          Version  Status  Scale  Charm        Store       Rev  OS          Address      Notes
gitlab-k8s            active      1  gitlab-k8s   jujucharms    1  kubernetes  10.7.247.1   
mariadb-k8s           active      1  mariadb-k8s  jujucharms    1  kubernetes  10.7.247.60  

Unit            Workload  Agent  Address   Ports     Message
gitlab-k8s/0*   active    idle   10.4.6.6  80/TCP    
mariadb-k8s/0*  active    idle   10.4.1.6  3306/TCP  

Relation provider   Requirer          Interface  Type     Message
mariadb-k8s:server  gitlab-k8s:mysql  mysql      regular
```

Here is one of the created workload storage persistent volumes in use:

```text
juju storage
```

Output:

```text
Unit           Storage id  Type        Pool        Size   Status    Message
mariadb-k8s/0  database/0  filesystem  kubernetes  35MiB  attached  Successfully provisioned volume pvc-X-X-X-X-X using kubernetes.io/gce-pd
```

There, we see that storage class gce-pd (GCEPersistentDisk) was chosen during the auto-configuration of storage.

<h2 id="heading--next-steps">Next steps</h2>

Consider the following tutorials:

- [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193)
- [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194)
- [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192)
- [Installing Kubernetes with CDK and using auto-configured storage](/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469)
