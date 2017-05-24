Title: Using a VMware vSphere cloud
TODO: Test vSphere

# Using a VMware vSphere cloud

In order to use a vSphere cloud you will need to have an existing vSphere
installation which supports VMware's Hardware Version 8 or better. The vSphere
installation will also need access to a DNS for Juju to function.

Juju doesn't have baked-in knowledge of your specific vSphere cloud, but it
does know how such clouds work. We just need to provide some information to add
it to the list of known clouds. 

## Adding a vSphere cloud

To make Juju aware of your vSphere installation, you will need to define it
within a YAML file containing the following values:

  - **cloudname**: an arbitrary name for your own reference
  - **endpoint**: the IP address of the VMware server
  - **region name**: a named region for each data centre

You will also need the name of one or more data centres. These can be listed
within the vSphere web client by selecting 'vCenter Inventory
Lists > Resources > Datacenters' from the hierarchical menu on the left. The
values you need are listed in the 'Name' column, such as the 'dc0' and 'dc1'
data centres shown here:

![vSphere web client showing data centres](./media/config-vsphere-datacenters.png)

With a **cloudname** of `myvscloud`, an **endpoint** of `178.18.42.10` and two
data centres named 'dc0' and 'dc1' respectively, a basic configuration would
look similar to this:

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
To add the above cloud definition to Juju, enter the following:

```bash
juju add-cloud myvscloud <YAML file>
```

You can check whether your vSphere installation has been added correctly by
looking for the following in the output from `juju clouds`:

<!-- JUJUVERSION: 2.0.1-trusty-amd64 -->
<!-- JUJUCOMMAND: juju clouds -->
```no-highlight
Cloud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
...
myvscloud          2  dc0            vsphere
```
## Adding credentials

Credentials can be added by typing `juju add-credential`, followed by the name
of the cloud you wish to add credentials for. This would be `myvscloud` in the
above example:

```bash
juju add-credential myvscloud
```
The process now becomes interactive. You will first be asked for an arbitrary
name for this credential, which you choose for yourself, followed by the
username and password for your VMware installation. 

With credentials added, you can now start using Juju with your vSphere cloud:

```bash
juju bootstrap myvscloud myvscontroller
```

!!! Note: 
    When bootstrapping Juju with vSphere, Juju downloads a cloud image to
    the Juju client machine and then uploads it to your cloud. If you're far away
    from VMware, this may take some time.

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
