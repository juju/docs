<!--
Todo:
- Should eventually link to k8s-charm developer documentation
- Add architectural overview/diagram
- Consider manually adding a cluster via `add-cloud` and `add-credential`
- Write tutorial on building a cluster using GCE with gcp-integrator
- Write tutorial on building a cluster using AKS
-->

Kubernetes ("K8s") provides a flexible architecture for managing containerised applications at scale. See the [Kubernetes documentation](https://kubernetes.io/docs) for more information.

The objective of this page is to give an overview of how an existing Kubernetes cluster can be integrated with Juju and what the general workflow is once that's done. Links will be provided at the end to [theoretical and practical](#heading--storage-theory-and-practical-guides) material. Finally, although this page is not about showing how to install Kubernetes itself, we do give pointers on how to do so.

<h2 id="heading--juju-kubernetes-specific-workflow">Juju Kubernetes-specific workflow</h2>

Essentially, Juju is able to treat the added cluster as it does any other of its known clouds (i.e. create models and deploy charms). There are some differences to working with such a cloud and they are called out in this section.

The k8s-specific Juju commands are `add-k8s`, `remove-k8s`, and `scale-application`. All other concepts and commands are applied in the traditional manner.

The `add-k8s` command makes the usual combination of `add-cloud` and `add-credential` unnecessary.

In `v.2.6.1`, the `add-k8s` command can be used to add the Kubernetes cluster and its credentials to the client's local cache (option `--local`) or to add these things directly to a running controller (the default behaviour). There are also options `--aks` and `--gke` for streamlining the addition of AKS and GKE clusters. 

In `v.2.5.0`, only local behaviour is possible (there is no `--local` option). The cluster configuration file will also first need to be copied to `~/.kube/config`.

User credentials can still be added by way of the `add-credential` or `autoload-credentials` commands. Also, at any time, the k8s CLI can be used to add a new user to the cluster.

The `add-k8s` command can repeatedly set up different clusters as long as the contents of the configuration file has been changed accordingly. The KUBECONFIG environment variable is useful here as it will be honoured by Juju when finding the file to load.

The `remove-k8s` command is used to remove a Kubernetes cluster from Juju's list of known clouds.

The `scale-application` command is used to scale a Kubernetes cluster. The `add-unit` and `remove-unit` commands do not apply to a Kubernetes model.

Charms need to be written specifically for Kubernetes workloads. See tutorial [Understanding Kubernetes charms](/t/understanding-kubernetes-charms-tutorial/1263).

<h2 id="heading--running-kubernetes-workloads">Running Kubernetes workloads</h2>

First off, a Kubernetes cluster will be required. Essentially, you will use it as you would any other cloud that Juju interacts with: the cluster becomes the backing cloud.

The following steps describe the general approach for using Kubernetes with Juju:

1. Obtain a Kubernetes cluster
1. Add the cluster
1. Add a model
1. Create persistent static storage (if necessary)
1. Create storage pools
1. Deploy a Kubernetes charm

<h3 id="heading--obtain-a-kubernetes-cluster">Obtain a Kubernetes cluster</h3>

There are many ways to obtain a Kubernetes cluster. Here is a list of suggestions:

- Use the '[kubernetes-core](https://jujucharms.com/kubernetes-core/)' bundle, which gives a minimal two-machine cluster available in the Charm Store.
- Use the '[canonical-kubernetes](https://jujucharms.com/canonical-kubernetes/)' bundle. This is the Charmed Distribution of Kubernetes (CDK), which is a more sophisticated version of 'kubernetes-core'. See tutorial [Installing Kubernetes with CDK and using auto-configured storage](/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469).
- Use the [conjure-up](https://conjure-up.io/) installer.
- Use [MicroK8s](https://microk8s.io). This gives you a local, fully compliant Kubernetes deployment with dynamic persistent volume support.
- When Kubernetes is deployed via charms, special integrator charms made for specific cloud vendors can greatly assist (e.g. storage). [Search the Charm Store](https://jujucharms.com/q/integrator) for 'integrator'.
- Use a public Kubernetes cloud vendor such as [Amazon EKS](https://aws.amazon.com/eks/), [Azure AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/), and [Google GKE](https://cloud.google.com/kubernetes-engine/). To get started with GKE, see appendix [Installing a GKE cluster](/t/appendix-installing-a-gke-cluster/1448).

[note]
Kubernetes bundles do not work well on a LXD cloud at this time. Refer to [Deploying on LXD](https://github.com/juju-solutions/bundle-canonical-kubernetes/wiki/Deploying-on-LXD) for details.
[/note]

<h3 id="heading--add-the-cluster">Add the cluster</h3>

Juju needs information about the cluster in order to add it. This information is part of the main Kubernetes configuration file which can be found on the Kubernetes master node. This is the same config file that `kubectl` uses. Copy this configuration file to your local machine and save it as `~/.kube/config`. The `add-k8s` command will parse that file and add the cluster as a cloud.

In `v.2.6.1` clusters based on AKS and GKE can be added without the cluster configuration file. These types have special helper modes that enable their respective, independently installed, CLI toolkits and are accessible via options `--aks` and `--gke`.

In `v.2.6.1` the `add-k8s` command can apply to the client's local cache of clouds or to an existing controller. This works similar to the `add-cloud` command; see the [Adding clouds](/t/clouds/1100#heading--adding-clouds) section.

[note type="important"]
The `conjure-up` installer adds the cluster automatically.
[/note]

<h3 id="heading--add-a-model">Add a model</h3>

After having added the cluster to the controller, you can create k8s models on that controller using `juju add-model <k8s-cloud-name>`. This will create a Kubernetes namespace in the cluster which is named after the model name. This namespace will host all of the pods and other resources of that model. The model also has a default storage pool called "kubernetes".

<h3 id="heading--create-persistent-static-storage">Create persistent static storage</h3>

Create persistent static volumes for operator storage if your chosen cloud's storage is not supported natively by Kubernetes. You will need to do the same for workload storage if your charm has storage requirements. This is done with the Kubernetes tool `kubectl`.

<h3 id="heading--create-storage-pools">Create storage pools</h3>

Create storage pools for operator storage and, if needed, workload storage. This is done in the usual way, with the `create-storage-pool` command.

<h3 id="heading--deploy-a-kubernetes-charm">Deploy a Kubernetes charm</h3>

A Kubernetes-specific charm is deployed in standard fashion, with the `deploy` command. If the charm has storage requirements you will need to specify them, as you do with a normal charm.

<h4 id="heading--configuration">Configuration</h4>

The below table lists configuration keys supported by Kubernetes charms that are set at deploy time. The corresponding Kubernetes meaning can be obtained from the Kubernetes documentation for [Services](https://kubernetes.io/docs/concepts/services-networking/service/) and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/).

| Key                                            | Type    | Default          | Valid values | Comments |
|:-----------------------------------------------|---------|------------------|--------------|:---------|
| `kubernetes-service-type`                      | string  | ClusterIP        |              |          |
| `kubernetes-service-external-ips`              | string  | []             |              |          |
| `kubernetes-service-target-port`               | string  | <container port> |              |          |
| `kubernetes-service-loadbalancer-ip`           | string  | ""               |              |          |
| `kubernetes-service-loadbalancer-sourceranges` | string  | []             |              |          |
| `kubernetes-service-externalname`              | string  | ""               |              |          |
| `kubernetes-ingress-class`                     | string  | nginx            |              |          |
| `kubernetes-ingress-ssl-redirect`              | boolean | false            |              |          |
| `kubernetes-ingress-ssl-passthrough`           | boolean | false            |              |          |
| `kubernetes-ingress-allow-http`                | boolean | false            |              |          |

For example:

``` text
juju deploy mariadb-k8s --config kubernetes-service-loadbalancer-ip=10.1.1.1
```

There are two other keys that are not Kubernetes-specific:

| Key                      | Type   | Default | Valid values | Comments |
|:-------------------------|--------|---------|--------------|:---------|
| `juju-external-hostname` | string | ""      |              |          |
| `juju-application-path`  | string | "/"     |              |          |

Keys 'juju-external-hostname' and 'juju-application-path' control how the application is exposed externally using a Kubernetes Ingress Resource in conjunction with the configured ingress controller (default: nginx).

<h2 id="heading--storage-theory-and-practical-guides">Storage theory and practical guides</h2>

The [Persistent storage and Kubernetes](/t/persistent-storage-and-kubernetes/1078) page provides the theory on how Juju works with Kubernetes storage.

The following practical guides are available:

- The `conjure-up` installer can be used to install Kubernetes. See the following resources for guidance:
   - The Ubuntu tutorial: [Install Kubernetes with conjure-up](https://tutorials.ubuntu.com/tutorial/install-kubernetes-with-conjure-up#0)
   - The upstream getting started guide: [Spell Walkthrough](https://docs.conjure-up.io/stable/en/walkthrough)
- Tutorial [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193) shows how to set up statically provisioned persistent volumes with Juju by way of the 'kubernetes-core' charm.
- Tutorial [Multi-cloud controller with GKE and auto-configured storage](/t/tutorial-multi-cloud-controller-with-gke-and-auto-configured-storage/1465) provides steps on how to add an existing GKE-based Kubernetes cluster to an existing controller. It also covers storage auto-configuration.
- Tutorial [Installing Kubernetes with CDK and using auto-configured storage](/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469) shows how to install Kubernetes with the CDK bundle and illustrates storage class and storage pool auto-configuration.
- Tutorial [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194) provides steps for getting started with Juju and MicroK8s.
- Tutorial [Using Juju on Charmed Kubernetes on VMWare](/t/tutorial-using-juju-on-kubernetes-on-vmware/1376) provides the steps for getting started with Juju on a Kubernetes cluster on VMWare.
- Tutorial [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192) demonstrates deploying Kubernetes with Juju on AWS with an integrator charm.
