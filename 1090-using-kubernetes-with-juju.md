<div data-theme-toc="true"> </div>

<!--
Todo:
- Should eventually link to k8s-charm developer documentation
- Add architectural overview/diagram
- Consider manually adding a cluster via `add-cloud` and `add-credential`
- Write tutorial on building a cluster using GCE with gcp-integrator
- Write tutorial on building a cluster using AKS
-->

Kubernetes ("K8s") provides a flexible architecture for cloud-native applications at scale. We believe that Juju is the simplest way to manage a multi-container workloads on K8s. This guide takes you through the registration steps necessary to connect the two systems.  

[note status="What is Juju?"]
Juju is the simplest DevOps tool for managing digital services built with inter-related applications. If you are unfamiliar with Juju, then we recommend following our [Getting Started with Juju](https://juju.is/docs/getting-started-with-juju) tutorial.
[/note]

[note status="Need a Kubernetes cluster for experimentation?"]
Install [MicroK8s][] to create a local Kubernetes cluster with zero effort.
[/note]

[MicroK8s]: https://microk8s.io/

<!--

<h2 id="heading--juju-kubernetes-specific-workflow">Juju Kubernetes-specific workflow</h2>

Some minor differences aside, Juju is able to treat your cluster as it does any other cloud. Applications can relate across K8s and traditional infrastructure. Actions are available for  There are some differences to working.



The k8s-specific Juju commands are `add-k8s`, `remove-k8s`, and `scale-application`. All other concepts and commands are applied in the traditional manner.

The `add-k8s` command makes the usual combination of `add-cloud` and `add-credential` unnecessary.

In `v.2.6.1`, the `add-k8s` command can be used to add the Kubernetes cluster and its credentials to the client's local cache (option `--local`) or to add these things directly to a running controller (the default behaviour). 

In `v.2.5.0`, only local behaviour is possible (there is no `--local` option). The cluster configuration file will also first need to be copied to `~/.kube/config`.

User credentials can still be added by way of the `add-credential` or `autoload-credentials` commands. Also, at any time, the k8s CLI can be used to add a new user to the cluster.

The `add-k8s` command can repeatedly set up different clusters as long as the contents of the configuration file has been changed accordingly. The KUBECONFIG environment variable is useful here as it will be honoured by Juju when finding the file to load.

The `remove-k8s` command is used to remove a Kubernetes cluster from Juju's list of known clouds.

The `scale-application` command is used to scale a Kubernetes cluster. The `add-unit` and `remove-unit` commands do not apply to a Kubernetes model.

Charms need to be written specifically for Kubernetes workloads. See tutorial [Understanding Kubernetes charms](/t/understanding-kubernetes-charms-tutorial/1263).

-->


<h2 id="heading--running-kubernetes-workloads">Running Kubernetes workloads</h2>

To run workloads on Kubernetes with Juju, a small number of registration steps are required:

1. Obtain a Kubernetes cluster
1. Register the cluster with Juju
1. Create a Juju controller
1. Register storage resources

You're now ready to deploy cloud-native workloads with charms:

1. Add a model
1. Deploy workloads



<h3 id="heading--obtain-a-kubernetes-cluster">Obtain a Kubernetes cluster</h3>

There are many ways to obtain a Kubernetes cluster. If you are unsure which option to choose, then you should [install MicroK8s](https://microk8s.io/).


| Use Case | Recommended Action(s)
|-----|-----|
| Local development, testing and experimentation | Install [MicroK8s](https://microk8s.io)
| Multi-node testing/production on own a private cloud | Install [Charmed Kubernetes](https://ubuntu.com/kubernetes/docs/install-manual)
| Multi-node testing/production on the public cloud | Install [Charmed Kubernetes](https://ubuntu.com/kubernetes/docs/install-manual) with the relevant [integrator charm](https://jaas.ai/search?q=integrator)
| Use a hosted Kubernetes distribution | Enable the service via the provider


<!--
ARCHIVE

Here is a list of suggestions:


- Use the '[kubernetes-core](https://jujucharms.com/kubernetes-core/)' bundle, which gives a minimal two-machine cluster available in the Charm Store.
- Use the '[canonical-kubernetes](https://jujucharms.com/canonical-kubernetes/)' bundle. This is the Charmed Distribution of Kubernetes (CDK), which is a more sophisticated version of 'kubernetes-core'. See tutorial [Installing Kubernetes with CDK and using auto-configured storage](/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469).
- Use [MicroK8s](https://microk8s.io). This gives you a local, fully compliant Kubernetes deployment with dynamic persistent volume support.
- When Kubernetes is deployed via charms, special integrator charms made for specific cloud vendors can greatly assist (e.g. storage). [Search the Charm Store](https://jujucharms.com/q/integrator) for 'integrator'.
- Use a public Kubernetes cloud vendor such as [Amazon EKS](https://aws.amazon.com/eks/), [Azure AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/), and [Google GKE](https://cloud.google.com/kubernetes-engine/). To get started with GKE, see appendix [Installing a GKE cluster](/t/appendix-installing-a-gke-cluster/1448).

[note]
Kubernetes bundles do not work well on a LXD cloud at this time. Refer to [Deploying on LXD](https://github.com/juju-solutions/bundle-canonical-kubernetes/wiki/Deploying-on-LXD) for details.
[/note]

-->

<h3 id="heading--add-the-cluster">Register the Kubernetes cluster with Juju</h3>

Registering the cluster with Juju is known as  "adding a cloud" in Juju's terminology. A cloud is a deployment target. The exact process to register the cluster depends on how your system is configured.

#### When running MicroK8s

The cluster is already registered. Feel free to move to the next section. 


#### When you're already able to interact with your cluster via `kubectl`

The registration process is a single command: 

```plain
juju add-k8s
```

#### When you have used Juju to deploy Charmed Kubernetes

We can use Juju to extract its configuration file to save it locally with these commands:

```plain
mkdir ~/.kube
juju scp kubernetes-master/0:/home/ubuntu/config ~/.kube/config
juju add-k8s
```

#### Otherwise

Copy the cluster's configuration file from the master node to your local machine and save it as `$HOME/.kube/config`, then run

```plain
juju add-k8s
```

<!--
Juju needs information about the cluster in order to add it. This information is part of the main Kubernetes configuration file which can be found on the Kubernetes master node. This is the same config file that `kubectl` uses.

In `v.2.6.1` clusters based on AKS and GKE can be added without the cluster configuration file. These types have special helper modes that enable their respective, independently installed, CLI toolkits and are accessible via options `--aks` and `--gke`.

In `v.2.6.1` the `add-k8s` command can apply to the client's local cache of clouds or to an existing controller. This works similar to the `add-cloud` command; see the [Adding clouds](/t/clouds/1100#heading--adding-clouds) section.

-->

### Create a Juju controller

The Juju controller is a central software agent that oversees applications  managed with Juju. It is created via the `juju bootstrap` command. 

```plain
juju bootstrap <cloud-name> <controller-name>
```

### Register storage resources

Registering storage is easy, but the exact process depends on where your Kubernetes is hosted. In most cases, no action is necessary.

```plain
juju create-storage-pool
``` 

When an application that you wish to deploy--your "workload" in Juju terms--makes uses of persistent storage, you may need to ensure that it has been added to your Kubernetes cluster.

Charmed Kubernetes users can use Juju to provide it with storage based on [Ceph or NFS](https://ubuntu.com/kubernetes/docs/storage).

The model also has a default storage pool called "kubernetes".

The `create-storage-pool` command

<h3 id="heading--add-a-model">Add a model</h3>

Before deploying applications with charms, Juju users create a "model". The model is a workspace for inter-related applications. It is an abstraction over applications, machines hosting them and other components such as persistent storage.  
 
To add a model, use the `juju add-model` command:

```plain
juju add-model <k8s-cloud-name>
```

Inside the cluster, adding a Juju model creates a Kubernetes namespace with the same name. The namespace hosts all of the pods and other resources, except global resources. 



<!--
ARCHIVE


<h3 id="heading--create-persistent-static-storage"> Create persistent static storage </h3>

[note]
If you are using MicroK8s, feel free to skip this step. MicroK8s automatically provides persistent volumes on demand.
[/note]

When an application that you wish to deploy--your "workload" in Juju terms--makes uses of persistent storage, you may need to ensure that it has been added to your Kubernetes cluster.

Charmed Kubernetes users can use Juju to provide it with storage based on [Ceph or NFS](https://ubuntu.com/kubernetes/docs/storage).

Users of other clusters should follow their vendor's instructions and verify that the storage pools are available with the command: `kubectl get sc,po`.

Create persistent static volumes for operator storage if your chosen cloud's storage is not supported natively by Kubernetes. You will need to do the same for workload storage if your charm has storage requirements. This is done with the Kubernetes tool `kubectl`.

<h3 id="heading--create-storage-pools">Create storage pools</h3>

Create storage pools for operator storage and, if needed, workload storage. 

The model also has a default storage pool called "kubernetes".

The `create-storage-pool` command.
-->


<h3 id="heading--deploy-a-kubernetes-charm">Deploy a Kubernetes charm</h3>

A Kubernetes-specific charm is deployed in standard fashion, with the `deploy` command. If the charm has storage requirements you will need to specify them, as you do with a normal charm.


#### Integrator charms

Juju charms can interact with the underlying cloud directly with the `juju trust` command. This command delegates the security credentials used by the controller to the charms themselves.

- integrator charm

```plain
juju deploy aws-integrator
juju trust aws-integrator
```


<h4 id="heading--configuration">Configuration</h4>

The below table lists configuration keys supported by Kubernetes charms that are set at deploy time. The corresponding Kubernetes meaning can be obtained from the Kubernetes documentation for [Services](https://kubernetes.io/docs/concepts/services-networking/service/) and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/).

| Key                                                       | Type    | Default          |
|:-----------------------------------------------|---------|------------------|
| `kubernetes-service-type`                      | string  | ClusterIP        | 
| `kubernetes-service-external-ips`              | string  | `[]`             |  
| `kubernetes-service-target-port`               | string  | `<container port>` |         
| `kubernetes-service-loadbalancer-ip`           | string  | `""`               |         
| `kubernetes-service-loadbalancer-sourceranges` | string  | `"[]"`             |
| `kubernetes-service-externalname`              | string  | `""`               |
| `kubernetes-ingress-class`                     | string  | `nginx`            |
| `kubernetes-ingress-ssl-redirect`              | boolean | `false`            |
| `kubernetes-ingress-ssl-passthrough`           | boolean | `false`            ||
| `kubernetes-ingress-allow-http`                | boolean | `false`            |

For example:

``` text
juju deploy mariadb-k8s --config kubernetes-service-loadbalancer-ip=10.1.1.1
```

There are two other keys that are not Kubernetes-specific:

<!--
TODO

Add valid values and comments

| Key                      | Type   | Default | Valid values | Comments |
|:-------------------------|--------|---------|--------------|:---------|
| `juju-external-hostname` | string | ""      |              |          |
| `juju-application-path`  | string | "/"     |              |          |
-->

| Key                      | Type   | Default | 
|:-------------------------|--------|---------|
| `juju-external-hostname` | string | `""`      |
| `juju-application-path`  | string | `"/"`     |

Keys 'juju-external-hostname' and 'juju-application-path' control how the application is exposed externally using a Kubernetes Ingress Resource in conjunction with the configured ingress controller (default: nginx).

<!--
<h2 id="heading--storage-theory-and-practical-guides">Storage theory</h2>

Refer to the  [Persistent storage and Kubernetes](/t/persistent-storage-and-kubernetes/1078) page for the theory on how Juju works with Kubernetes storage.
-->


## Tutorials and in-depth guides 

The following practical guides are available:

- Tutorial [Setting up static Kubernetes storage](/t/setting-up-static-kubernetes-storage-tutorial/1193) shows how to set up statically provisioned persistent volumes with Juju by way of the 'kubernetes-core' charm.
- Tutorial [Multi-cloud controller with GKE and auto-configured storage](/t/tutorial-multi-cloud-controller-with-gke-and-auto-configured-storage/1465) provides steps on how to add an existing GKE-based Kubernetes cluster to an existing controller. It also covers storage auto-configuration.
- Tutorial [Installing Kubernetes with CDK and using auto-configured storage](/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469) shows how to install Kubernetes with the CDK bundle and illustrates storage class and storage pool auto-configuration.
- Tutorial [Using Juju with MicroK8s](/t/using-juju-with-microk8s-tutorial/1194) provides steps for getting started with Juju and MicroK8s.
- Tutorial [Using Juju on Charmed Kubernetes on VMWare](/t/tutorial-using-juju-on-kubernetes-on-vmware/1376) provides the steps for getting started with Juju on a Kubernetes cluster on VMWare.
- Tutorial [Using the aws-integrator charm](/t/using-the-aws-integrator-charm-tutorial/1192) demonstrates deploying Kubernetes with Juju on AWS with an integrator charm.
