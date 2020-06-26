## Overview

To register a VMware ESXi cluster with vSphere as a "vSphere cloud", there are three main steps:

1. `juju add-cloud` registers the cluster with Juju, providing Juju with details such as the host's IP address
2. `juju add-credential` provides credentials to Juju to access the vSphere API
3. `juju bootstrap` creates a Juju controller within the cluster

## Requirements

vSphere cloud you will need to have an existing vSphere installation which supports, or has access to, the following:

- VMware Hardware Version 8 (or greater)
- ESXi 5.0 (or greater)
- Internet access
- DNS and DHCP

Juju supports both high-availability vSAN deployments as well and standard deployments. 

<h2 id="heading--adding-a-vsphere-cloud">Adding a vSphere cloud</h2>

There are two mechanisms for registering a cluster with Juju. You can either use a guided interactive prompt or create a configuration file with equivalent information and provide that.

During the process, you will be asked to provide the following information:

- A name that Juju will refer to the cluster as
- IP address of your cluster's vCenter
- The name(s) of any Datacenter(s) that you want to enable Juju to be able to deploy to

#### Tip: Finding Datacenter names in vSphere

Your Datacenters are available through the vSphere web client by selecting <kbd>vCenter Inventory Lists</kbd> &gt; <kbd>Resources</kbd> &gt; <kbd>Datacenters</kbd> from the hierarchical menu at the top left. 

The values you need are listed in the 'Name' column, such as the 'dc0' and 'dc1' Datacenters shown here:

![vSphere web client showing Datacenters](https://assets.ubuntu.com/v1/386b31c4-config-vsphere-datacenters.png)

### Using an interactive prompt 

Use the `add-cloud` command to interactively add your vSphere cloud to Juju's list of clouds:

```text
juju add-cloud --local
```

[note status="Why --local?"]
Juju controllers have the ability to manage workloads that span multiple clouds. Adding the `--local` option indicates that the information should be stored on the machine where you are executing the commands and not passed to a controller. 
[/note]

An session with multiple datacenters:

```text
Cloud Types
  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: vsphere

Enter a name for your vsphere cloud: vsp-cloud

Enter the vCenter address or URL: 178.18.42.10

Enter datacenter name: dc0

Enter another datacenter? (y/N): y

Enter datacenter name: dc1

Enter another datacenter? (y/N): n

Cloud "vsp-cloud" successfully added

You will need to add credentials for this cloud (`juju add-credential vsp-cloud`)
before creating a controller (`juju bootstrap vsp-cloud`).
```

<h3 id="heading--manually-adding-a-vsphere-cloud">Manually adding a vSphere cloud with a configuration file</h3>

Write out a [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) configuration file with the sections in angle brackets (&lt;&#8230;&gt;) replaced with the relevant information for your system. 


```yaml
clouds:
 <cloud-name>:
  type: vsphere
  auth-types: [userpass]
  endpoint:  <vcenter-ip-address-or-hostname>
  regions:
    <datacenter-1>: {}
    [<datacenter-n>: {}]
```

Here is an example:

```yaml
clouds:
 vsp-cloud:
  type: vsphere
  auth-types: [userpass]
  endpoint: 178.18.42.10
  regions:
   dc0: {}  # these empty maps
   dc1: {}  # are necessary
```

Adding a cloud manually can either be done locally or the cloud can be stored on a current controller). Here, we'll show how to do it locally (client cache).

To add cloud 'vsp-cloud', assuming the configuration file is `vsp-cloud.yaml` in the current directory, we would run:

```text
juju add-cloud --local vsp-cloud vsp-cloud.yaml
```

[note status="Why --local?"]
Juju controllers have the ability to manage workloads that span multiple clouds. Adding the `--local` option indicates that the information should be stored on the machine where you are executing the commands and not passed to a controller. 
[/note]

<h2 id="heading--adding-credentials">Adding credentials</h2>

Use the `juju add-credential` command to register security credentials to the new cloud.

```text
juju add-credential vsp-cloud
```

Example user session:

```text
Enter credential name: vsp-cloud-creds

Using auth-type "userpass".

Enter user: jlaurin@juju.example.com

Enter password: ********

Enter vmfolder (optional): juju-root

Credential "vsp-cloud-creds" added locally for cloud "vsp-cloud".
```

We’ve called the new security credential ‘vsp-cloud-creds’. You will need to provide your VMware account username--this looks like an email address--and the associated password.

[note status="Locked out?"]
Credentials for the vSphere cloud have been reported to occasionally stop working over time.

If this occurs, then you can "remind" vSphere of your credentials. See [Dealing with inert credentials](/t/tutorial-managing-credentials/1289#heading--dealing-with-inert-credentials) for guidance.
[/note]

### Further information

For background information on adding a cloud to Juju, see these pages:

- [General cloud management](/t/clouds/1100#heading--general-cloud-management)
-  [Adding clouds manually](/t/clouds/1100#heading--adding-clouds-manually)
- [Credentials](/t/credentials/1112)

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'vsp-cloud':

```text
juju bootstrap vsp-cloud vsp-controller
```

Above, the name given to the new controller is 'vsp-controller'. vSphere will provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

There are three VMware-specific options available for specifying the network and datastore to use:

-  `primary-network`
The primary network that VMs will be connected to. If this is not specified, Juju will look for a network named `VM Network`.
- `external-network`
An external network that VMs will be connected to. The resulting IP address for a VM will be used as its public address. An external network provides the interface to the internet for virtual machines connected to external organization vDC networks.
- `datastore`
The datastore in which to create VMs. If this is not specified, the process will abort unless there is only one datastore available.

For example:

```text
juju bootstrap vsp-cloud vsp-controller \
    --config primary-network=$PRIMARY_NET \
    --config external-network=$EXTERNAL_NET \
    --config datastore=$DATA_STORE
```

The above `--config` options will only apply to the 'controller' and 'default' models. Use option `--model-default` instead if you want any newly-created models to be affected. You can also use the `model-defaults` command once the controller is created to do the same thing.

[note status="Initial bootstrap duration"]
When creating a controller with vSphere, a cloud image is downloaded to the client and then uploaded to the ESX host. This depends on your network connection and can take a while.
[/note]

<h2 id="heading--troubleshooting">vSphere specific features</h2>

When creating a controller, there are three levels of placement that Juju understands: cloud, region, and availability zone. In vSphere, these are mapped in two different ways depending on your topology:

- cloud (vSphere endpoint), region (Datacenter), availability zone (host)
- cloud (vSphere endpoint), region (Datacenter), availability zone (cluster)

If your topology has a cluster without a host, Juju will see this as an Availability Zone and may fail silently. To solve this, either make sure the host is within the cluster, or use a placement directive:

```text
juju bootstrap vsphere/<datacenter> <controllername> --to zone=<cluster|host>
```

To create a controller using Datacenter 'dc1' you would enter the following:

```text
juju bootstrap vsp-cloud/dc1 vsp-controller
```

### Specifying a datastore when deploying an application

There is a constraint called 'root-disk-source' that can stipulate the name of a vSphere datastore to house the root disk:

```text
juju deploy myapp --constraints root-disk-source=mydatastore
```

### Deploying applications to a specific host or cluster

Resource groups within a host or cluster can be specified with the 'zones' constraint:

```text
juju deploy myapp --constraints zones=mycluster/mygroup
juju deploy myapp --constraints zones=mycluster/myparent/mygroup
```

## Removing the cluster

To remove the ability for Juju to manage workloads on your cluster, use the following commands. You will 

- `juju destroy-controller --destroy-all-models <controller-name>`
- `juju remove-cloud --client <cloud-name>` 
- `juju remove-credential --client  <credential-name>`

<!--
### Where information is stored

Juju stores cloud and credential information in the following loc

- Linux: `$XDG_DATA_HOME/juju/`
- macOS: ?
- Windows: ?

-->
<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

### Example Workload: Charmed Kubernetes

Your cluster is now set up to deploy [Charmed Kubernetes](https://ubuntu.com/kubernetes), a "pure upstream" Kubernetes distribution that is standards-compliant and easy to upgrade. Follow these [instructions to deploy Kubernetes to vSphere](https://ubuntu.com/kubernetes/install#multi-node) (start at the "Add model" step). 
 


### Further reading

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
