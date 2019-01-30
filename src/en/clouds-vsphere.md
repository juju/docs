Title: Using VMware vSphere with Juju
TODO:  Review required

# Using VMware vSphere with Juju

In order to use a vSphere cloud you will need to have an existing vSphere
installation which supports VMware's Hardware Version 8 or better. The vSphere
installation will also need access to a DNS for Juju to function.

Juju doesn't have baked-in knowledge of your specific vSphere cloud, but it
does know how such clouds work. We just need to provide some information to add
it to the list of known clouds.

## Adding a vSphere cloud

Use the interactive `add-cloud` command to add your vSphere cloud to Juju's
list of clouds. You will need to supply a name you wish to call your cloud, the
IP address of the vSphere server, and a region name.

For the manual method of adding a vSphere cloud, see below section
[Manually adding a vSphere cloud][#manually-adding-a-vSphere-cloud].

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: vsphere

Enter a name for your vsphere cloud: myvscloud

Enter the API endpoint url for the cloud: 178.18.42.10

Enter region name: dc0

Enter another region? (Y/n): y

Enter region name: dc1

Enter another region? (Y/n): n

Cloud "myvscloud" successfully added

You will need to add credentials for this cloud (`juju add-credential myvscloud`)
before creating a controller (`juju bootstrap myvscloud`).
```

The 'API endpoint url' in this case is the IP address of the vSphere server.
We have also specified multiple regions ("data centres" in vSphere
terminology).

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

<!-- JUJUVERSION: 2.0.1-trusty-amd64 -->
<!-- JUJUCOMMAND: juju clouds -->
```no-highlight
Cloud        Regions  Default        Type        Description
.
.
.
myvscloud          2  dc0            vsphere
```

### Manually adding a vSphere cloud

This example covers manually adding a vSphere cloud to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).

You will need the name of one or more data centres. These can be listed within
the vSphere web client by selecting 'vCenter Inventory Lists > Resources >
Datacenters' from the hierarchical menu on the left. The values you need are
listed in the 'Name' column, such as the 'dc0' and 'dc1' data centres shown
here:

![vSphere web client showing data centres](https://assets.ubuntu.com/v1/386b31c4-config-vsphere-datacenters.png)

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

```yaml
clouds:
 myvscloud:
  type: vsphere
  auth-types: [userpass]
  endpoint: 178.18.42.10
  regions:
   dc0: {}
   dc1: {}
```

To add cloud 'myvscloud', assuming the configuration file is
`vsphere-cloud.yaml` in the current directory, we would run:

```bash
juju add-cloud myvscloud vsphere-cloud.yaml
```

## Adding credentials

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

Credentials can be added by typing `juju add-credential`, followed by the name
of the cloud you wish to add credentials for. This would be `myvscloud` in the
above example:

```bash
juju add-credential myvscloud
```

The process now becomes interactive. You will first be asked for an arbitrary
name for this credential, which you choose for yourself, followed by the
username and password for your VMware installation.

## Creating a controller

You are now ready to create a Juju controller for cloud 'myvscloud':

```bash
juju bootstrap myvscloud myvscloud-controller
```

Above, the name given to the new controller is 'myvscloud
myvscloud-controller'. vSphere will provision an instance to run the
controller on.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

There are three VMware-specific options available for specifying the network
and datastore to use:

 - **`primary-network`**  
   The primary network that VMs will be connected to. If this is not specified,
   the first accessible network will be used.
 - **`external-network`**  
   The name of an additional "external" network to which the VM should be
   connected. The IP from this network will be used as the `public-address` of
   the VMs.
 - **`datastore`**  
   Datastore is the name of the datastore in which to create the VM. If this is
   not specified, the first accessible datastore will be used.

For example:

```bash
juju bootstrap myvscloud myvscloud-controller \
	--config primary-network=PRIMARY_NET \
	--config external-network=EXTERNAL_NET \
	--config datastore=NFSSTORE
```

!!! Note:
    When you specify these options in the bootstrap command, they will only
    apply to the 'controller' and 'default' models. Use
    [`model-defaults`](./models-config.html) if you want all new models to use
    those options.

!!! Note:
    When bootstrapping Juju with vSphere, Juju downloads a cloud image to
    the Juju client machine and then uploads it to your cloud. If you're far
    away from the cluster, this may take some time.

## Troubleshooting

When bootstrapping, Juju contemplates three levels of placement: Cloud, Region and
Availability Zone. In vSphere, these are mapped in two different ways depending
on your topology:

- Cloud (vSphere endpoint), Region (data centre), Availability Zone (Host)
- Cloud (vsphere endpoint), Region (data centre), Availability Zone (Cluster)

If your topology has a cluster without a host, Juju will see this as an
Availability Zone and may fail silently. To solve this, either make sure the
host is within the cluster, or be specific about placement. Ideally, you should
always be explicit with placement while using this version of Juju.

You can be specific about placement by using the following syntax:

```bash
juju bootstrap vsphere/<datacenter> <controllername> --to zone=<cluster|host>
```
To bootstrap our previous example using the second data centre (dc1), for instance,
you would enter the following:

```bash
juju bootstrap myvscloud/dc1 myvscontroller
```

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[#manually-adding-a-vSphere-cloud]: #manually-adding-a-vsphere-cloud
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
[rscontrolpanel]: https://mycloud.rackspace.com
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
[credentials]: ./credentials.md
