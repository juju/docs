In order to use a vSphere cloud you will need to have an existing vSphere installation which supports, or has access to, the following:

- VMware Hardware Version 8 (or greater)
- ESXi 5.0 (or greater)
- internet access
- DNS and DHCP

<h2 id="heading--adding-a-vsphere-cloud">Adding a vSphere cloud</h2>

### Using an interactive prompt 

Use the `add-cloud` command to interactively add your vSphere cloud to Juju's list of clouds. You will need to supply a name you wish to call your cloud, the IP address of the vSphere server, and a vSphere Datacenter name.

Alternatively, you can add the details manually. See the section [Manually adding a vSphere cloud](#heading--manually-adding-a-vsphere-cloud) below.

To interactively add a cloud definition to the local client cache  (just `add-cloud` on versions prior to `v.2.6.1`):

```text
juju add-cloud --local
```

Example user session:

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

The 'vCenter address or URL' in this case is the IP address or URL of the vSphere server. We have also specified multiple Datacenters.

Confirm the addition of the cloud with the `clouds --local` command (just `clouds` on versions prior to `v.2.6.1`).

<h3 id="heading--manually-adding-a-vsphere-cloud">Manually adding a vSphere cloud with a configuration file</h3>

This example covers manually adding a vSphere cloud to Juju.

You will need the name of the Datacenter(s). These can be listed within the vSphere web client by selecting 'vCenter Inventory Lists &gt; Resources &gt; Datacenters' from the hierarchical menu on the left. The values you need are listed in the 'Name' column, such as the 'dc0' and 'dc1' Datacenters shown here:

![vSphere web client showing Datacenters](https://assets.ubuntu.com/v1/386b31c4-config-vsphere-datacenters.png)

The manual method necessitates the use of a [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) configuration file. Here is an example:

```yaml
clouds:
 vsp-cloud:
  type: vsphere
  auth-types: [userpass]
  endpoint: 178.18.42.10
  regions:
   dc0: {}
   dc1: {}
```

Adding a cloud manually can be done locally or, since `v.2.6.1`, remotely (on a controller). Here, we'll show how to do it locally (client cache).

To add cloud 'vsp-cloud', assuming the configuration file is `vsp-cloud.yaml` in the current directory, we would run:

```text
juju add-cloud --local vsp-cloud vsp-cloud.yaml
```

[note]
In versions prior to `v.2.6.1` the `add-cloud` command only operates locally (there is no `--local` option).
[/note]

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Credentials](/t/credentials/1112) page offers a full treatment of credential management.

Use the `add-credential` command to interactively add your credentials to the new cloud:

```text
juju add-credential vsp-cloud
```

Example user session:

```text
Enter credential name: vsp-cloud-creds

Using auth-type "userpass".

Enter user: jlaurin@juju.example.com

Enter password: ********

Credential "vsp-cloud-creds" added locally for cloud "vsp-cloud".
```

We’ve called the new credential ‘vsp-cloud-creds’. You will need to provide your VMware account username (looks like an email address) and its password. The password will not be echoed back to the screen.

[note type="caution"]
Credentials for the vSphere cloud have been reported to become inoperative, as if invalid. If a previously working setup suddenly behaves as if incorrect credentials are being used, as a workaround, you may "remind" vSphere of your credentials. See [Dealing with inert credentials](/t/tutorial-managing-credentials/1289#heading--dealing-with-inert-credentials) for guidance.
[/note]

### Further information

For background information on adding a cloud to Juju, see these pages:

- [General cloud management](/t/clouds/1100#heading--general-cloud-management)
-  [Adding clouds manually](/t/clouds/1100#heading--adding-clouds-manually)

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'vsp-cloud':

```text
juju bootstrap vsp-cloud vsp-controller
```

Above, the name given to the new controller is 'vsp-controller'. vSphere will provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

There are three VMware-specific options available for specifying the network and datastore to use:

-  `primary-network`
The primary network that VMs will be connected to. If this is not specified, the first accessible network will be used.
- `external-network`
An external network that VMs will be connected to. The resulting IP address for a VM will be used as its public address. An external network provides the interface to the internet for virtual machines connected to external organization vDC networks.
- `datastore`
The datastore in which to create VMs. If this is not specified, the first accessible datastore will be used.

For example:

```text
juju bootstrap vsp-cloud vsp-controller \
    --config primary-network=$PRIMARY_NET \
    --config external-network=$EXTERNAL_NET \
    --config datastore=$DATA_STORE
```

The above `--config` options will only apply to the 'controller' and 'default' models. Use option `--model-default` instead if you want any newly-created models to be affected. You can also use the `model-defaults` command once the controller is created to do the same thing.

[note]
When creating a controller with vSphere, a cloud image is downloaded to the client and then uploaded to the cloud. This can take a while.
[/note]

<h2 id="heading--troubleshooting">vSphere specific features</h2>

When creating a controller, there are three levels of placement: cloud, region, and availability zone. In vSphere, these are mapped in two different ways depending on your topology:

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

Since `v.2.5.3`, there is a constraint called 'root-disk-source' that can stipulate the name of a vSphere datastore to house the root disk:

```text
juju deploy myapp --constraints root-disk-source=mydatastore
```

Since `v.2.5.3`, resource groups within a host or cluster can be specified with the 'zones' constraint:

```text
juju deploy myapp --constraints zones=mycluster/mygroup
juju deploy myapp --constraints zones=mycluster/myparent/mygroup
```

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
