<div data-theme-toc="true"> </div>

Running through this guide will ensure that you're ready to deploy and manage Kubernetes workloads on Google Kubernetes Engine (GKE) with Juju.

Juju provides built-in support for GKE. That means, once you've registered your cluster, you'll be able to deploy workloads straight away. 

This guide covers: 

- making sure all necessary software is installed
- all configuration is in place
- a live Juju controller is available
- a Juju model has been created

# Software to Install

Using Juju to drive Kubernetes workloads on AKS requires installing some pre-requisite software:

- Juju client
- Google Cloud SD
- Kubernetes client

## Juju client (`juju`)

You will need to [install Juju](/t/installing-juju/1164). If you're on Linux, we recommend using snap:

```plain
snap install juju --classic
```

We also provide other installation methods as described on our [detailed installation documentation](/t/installing-juju/1164). 

## Googe Cloud SDK (`gcloud`)

Installing the Google Cloud SDK is easiest via snap:

```plain
snap install google-cloud-sdk --classic
```

Instructions for [other `gcloud` installation methods](https://cloud.google.com/sdk/docs/downloads-snap) also also available.

## Kubernetes client (`kubectl`)

`kubectl` is the command-line client for directly interacting with a Kubernetes cluster. Visit the Kubernetes documentation for manual [`kubectl` installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/).


# Provision a Kubernetes cluster on Google Kubernetes Engine

You will need to have an GKE cluster available before Juju can connect to it. In Azure's terminology, you need to create a "Managed Kubernetes resource". It's easy to do that via the [cloud console](https://console.cloud.google.com/kubernetes/).


 If you prefer to use command-line tools though, here are detailed instructions.

[note]
Please refer to Azure's own documentation for authoritative information on how to manage services and accounts with Azure.
[/note]


<!--
UNNECESSARY?

## Azure Account Requirements

Not all accounts have sufficient access to create AKS resources. If you

- Ensure that you have the "Owner" or "User Access Administrator" roles to a [Microsoft Azure subscription](https://azure.microsoft.com/en-us/free/).
- Your account should also have permission to create and register applications on [Azure Active Directory](https://docs.microsoft.com/en-nz/azure/active-directory/fundamentals/).
-->


[note type=warn status="Content not ready"]
Need to port this section across from Azure
[/note]

## Log in to Azure

From the command-line, login:

```plain
az login
```

## Configure the Azure subscription

A Subscription is a container for Azure resources that enables billing and usage accounting. Subscriptions are created under an Enrollment Account.

## (Optional) Create a new subscription

Creating a new subscription is unlikely to be necessary unless you have specialist requirements. Consult the [Azure documentation](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest) for details about whether this applies to you.

### Enable the `subscription` extension

To create subscriptions from the Azure CLI, an extension is required:

```plain
az extension add --name subscription
```

### List your Enrollment Accounts

To print a list of Enrollment Accounts, use `az billing enrollment-account list`: 

```plain
az billing enrollment-account list -o table
```

### Create a new subscription

Use the desired "Name" from the output as `<enrollment-account>` in the next step. `<subscription>` is a human-readable name that you would like to use for that subscription.

```plain
az account create --display-name <subscription> --enrollment-account-object-id <enrollment-account>
```

<!--
[note type=important]
The `az account create` command takes several options. For full instructions, consult the [Azure documentation for creating subscriptions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/programmatically-create-subscription?tabs=azure-cli).
[/note]
-->

### Listing subscriptions

You should now be able to set the are now able to see the new subscription in your list of current subscriptions:

```plain
az account list -o table
```

## Set the correct default subscription

To ensure billing is allocated to the correct account, you should use the `az account set` command. `<subscription>` can be a subscription's GUID or its name. To list available subscriptions, use `az account list`. 

```plain
az account set -s <subscription>
```

### Verify that the correct subscription is the default

Verify that you are connected to the correct subscription with the `account show` sub-command:

```plain
az account show -o table
```

## Register Resource providers

A "Resource provider", also known as a "Resource namespace", is a set of products that are available to subscriptions through Azure. AKS requires 4 providers to be enabled to function correctly.

These providers should be enabled already, but ensuring that they're available will prevent any problems.

```plain
az provider register --namespace 'Microsoft.Compute' --wait
``` 

```plain
az provider register --namespace 'Microsoft.Storage' --wait
``` 
```plain
az provider register --namespace 'Microsoft.Network' --wait
``` 

```plain
az provider register --namespace 'Microsoft.ContainerService' --wait
```

## Choose an Azure region to operate in

Each Azure region has different capabilities. In particular, different Kubernetes versions are supported within each region. To get the list of regions, Juju offers the `juju regions` command. The Azure CLI can inspect the region to check which Kubernetes version is supported there.

```plain
juju regions azure
```

```plain
az aks get-versions --location <region> -o table
```
Note the region down that you intend to use for when you create a Resource Group. 


## Create a Resource Group

A "Resource Group"  is a link between services and a geographic region for billing and authentication purposes. 

To create a Resource Group for your project, provide a region and a human-readable name to the `az group create` command. 

```plain
az group create --location <region> --name <resource-group>
```

To simplify further commands, you can set your new Resource Group as the default.

```plain
az configure --defaults group=<resource-group>
```

# Create the Kubernetes cluster with the Azure CLI

With a Resource Group and other necessary preparation in place, we're now able to provision an AKS cluster. 

## (Optional) Create a container registry

You may wish to provision a container registry for your cluster:

```plain
az acr create -n <registry-name> -g  <resource-group>
```

## Create the Kubernetes cluster with the Azure CLI

The `az aks create` command provisions a cluster. Assuming that you have selected a default Resource Group, providing a human-readable name as `<k8s-cluster>` is the only required option. 

```bash
az aks create -g <resource-group> --name <k8s-cluster>
```

[note]
`az aks create` is highly configurable, and you are recommended to read the options available via `az aks create --help`.
[/note]


# Linking the cluster to the local environment

## Enable `kubectl`

The Azure CLI will configure `kubectl` on your behalf via the `az aks get-credentials` command. `kubectl` will be able to control your cluster directly.

```plain
az aks get-credentials -g <resource-group> --name <k8s-cluster>
```

### Verify `kubectl` set up

To check that you have configured `kubectl` correctly, execute a command:

```plain
kubectl get nodes
```

# Set up Juju within the cluster

Now that the pieces are in place, let's join them together. This is a three step process:

- registering the cluster as a "K8s cloud"
- deploying a Juju controller within the cluster
- creating a "model" (namespace) to house our deployment(s)


## Register the cluster as a "K8s cloud"

In Juju's vocabulary, a "cloud" is a space that can host deployed workloads. To register a Kubernetes cluster with Juju, execute the `juju add-k8s` command. The `<cloud>` will be used by Juju to refer to the cluster.

```plain
juju add-k8s --aks --resource-group <resource-group> --cluster-name <k8s-cluster> <cloud>
```

## Create a controller

Juju, as an active agent system, requires a _controller_ to get started. Controllers are created with the `juju bootstrap` command that takes a cloud's name and our intended name for the controller.

```plain
juju bootstrap <cloud> <controller>
```


## Create a model

A model is a workspace for inter-related applications. They correspond (roughly) to a Kubernetes namespace. To create one, use `juju add-model` with a name of your choice:

```plain
juju add-model <model>
```

# Deploy workloads

You're now able to deploy workloads into your model.  Workloads are provided by charms (and sets of charms called bundles). 

<!--
## Finding charms that are suitable for Kubernetes
-->

Use the Kubernetes filter in the Charm Store to find Kubernetes workloads to deploy, e.g. https://jaas.ai/search?type=charm&series=kubernetes.
