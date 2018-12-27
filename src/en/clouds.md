Title: Clouds
TODO:  Bug tracking: https://bugs.launchpad.net/juju/+bug/1749302
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1749583
       INFO: Auth types found at ~/.local/share/juju/public-clouds.yaml
       There is contention whether access-key can be used with keystone v3 (see https://github.com/juju/docs/issues/2868)
table_of_contents: True

# Clouds

Juju supports a wide variety of clouds. In addition, many of these are known to
Juju out of the box. The remaining supported clouds do need to be added to
Juju, and, as will be shown, it is simply done.

Once your cloud is known to Juju, whether by default or due to it being added,
the next step is to add your cloud credentials to Juju. The exception is for a
local LXD cloud; credentials are added automatically.

This rest of this page covers general cloud management and an overview of how
clouds are added. You can still get started by selecting your cloud here:

 - [Amazon AWS][clouds-aws] *****
 - [Microsoft Azure][clouds-azure] *****
 - [Google GCE][clouds-google] *****
 - [Oracle OCI][clouds-oci] *****
 - [Rackspace][clouds-rackspace] *****
 - [Joyent][clouds-joyent] *****
 - [LXD][clouds-lxd] (local) *****
 - [LXD][clouds-lxd] (remote)
 - [Kubernetes][clouds-k8s]
 - [VMware vSphere][clouds-vmware]
 - [OpenStack][clouds-openstack]
 - [MAAS][clouds-maas]
 - [Manual][clouds-manual]

Those clouds known to Juju out of the box are denoted by an *****.

## General cloud management

To get the list of clouds that Juju is currently aware of use the `clouds`
command:

```bash
juju clouds
```

This will return a list very similar to:

```no-highlight
Cloud        Regions  Default        Type        Description
aws               15  us-east-1      ec2         Amazon Web Services
aws-china          1  cn-north-1     ec2         Amazon China
aws-gov            1  us-gov-west-1  ec2         Amazon (USA Government)
azure             26  centralus      azure       Microsoft Azure
azure-china        2  chinaeast      azure       Microsoft Azure China
cloudsigma         5  hnl            cloudsigma  CloudSigma Cloud
google            13  us-east1       gce         Google Cloud Platform
joyent             6  eu-ams-1       joyent      Joyent Cloud
oracle             4  us-phoenix-1   oci         Oracle Cloud Infrastructure
rackspace          6  dfw            rackspace   Rackspace Cloud
localhost          1  localhost      lxd         LXD Container Hypervisor
```

Each line represents a cloud that Juju can interact with. It gives the cloud
name, the number of cloud regions Juju is aware of, the default region (for the
current Juju client), the type/API used to control it, and a brief description.

!!! Important:
    The cloud name (e.g. 'aws', 'localhost') is what you will use in any
    subsequent Juju commands to refer to a cloud.

To see which regions Juju is aware of for any given cloud use the `regions`
command. For the 'aws' cloud then:

```bash
juju regions aws
```

This returns a list like this:
  
```no-highlight
us-east-1
us-east-2
us-west-1
us-west-2
ca-central-1
eu-west-1
eu-west-2
eu-central-1
ap-south-1
ap-southeast-1
ap-southeast-2
ap-northeast-1
ap-northeast-2
sa-east-1
```

To change the default region for a cloud:

```bash
juju set-default-region aws eu-central-1
```

You can also specify a region to use when
[Creating a controller][controllers-creating].

To get more detail about a particular cloud:

```bash
juju show-cloud azure
```

To learn of any special features a cloud may support the `--include-config`
option can be used with `show-cloud`. These can then be passed to either of the
`bootstrap` or the `add-model` commands. See
[Passing a cloud-specific setting][controllers-creating-include-config] for
an example.

To synchronise the Juju client with changes occurring on public clouds (e.g.
cloud API changes, new cloud regions) or on Juju's side (e.g. support for a new
cloud):

```bash
juju update-clouds
```

To change the definition of an existing cloud, 'oracle' for instance, create a
[YAML-formatted][yaml] file, say `oracle.yaml`, with contents like:

```no-highlight
clouds:
   oracle:
      type: oci
      config:
         compartment-id: <some value>
```

And then:

```bash
juju add-cloud --replace oracle oracle.yaml
```

This will avoid you having to include `--config compartment-id=<some value>` at
controller-creation time (`bootstrap`).

## Adding clouds

Adding a cloud is done with the `add-cloud` command, which has both interactive
and manual modes.

### Adding clouds interactively

Interactive mode is the recommended method for adding a cloud, especially for
new users. This mode currently supports the following clouds: MAAS, Manual,
OpenStack, Oracle, and vSphere.

### Adding clouds manually

As an alternative to the interactive method, more experienced Juju operators
can add their clouds manually. This can assist with automation.

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. It has the following format:

```yaml
clouds:
  <cloud_name>:
    type: <cloud type>
    auth-types: [<authenticaton types>]
    regions:
      <region-name>:
        endpoint: <https://xxx.yyy.zzz:35574/v3.0/>
```

The table below shows the authentication types available for each cloud type.
It does not include the `interactive` type as it does not apply in the context
of adding a cloud manually.

| cloud type      | authentication types            |
|-----------------|---------------------------------|
`azure`		  | `service-principal-secret`
`cloudsigma`	  | `userpass`
`ec2`		  | `access-key`
`gce`		  | `jsonfile,oauth2`
`joyent`	  | `userpass`
`lxd`		  | n/a, `certificate` (`v.2.5`)
`maas`		  | `oauth1`
`manual`	  | n/a
`oci`	  	  | `httpsig`
`openstack` 	  | `access-key,userpass`
`oracle`	  | `userpass`
`rackspace`	  | `userpass`
`vsphere`	  | `userpass`

To add a cloud in this way we simply supply an extra argument to specify the
relative path to the file:
 
`juju add-cloud <cloud-name> <cloud-file>`

Here are some examples of manually adding a cloud:

 - [Manually adding MAAS clouds][clouds-maas-manual]
 - [Manually adding an OpenStack cloud][clouds-openstack-manual]
 - [Manually adding a vSphere cloud][clouds-vsphere-manual]


<!-- LINKS -->

[clouds-aws]: ./help-aws.md
[clouds-azure]: ./help-azure.md
[clouds-google]: ./help-google.md
[clouds-oci]: ./clouds-oci.md
[clouds-rackspace]: ./help-rackspace.md
[clouds-joyent]: ./help-joyent.md
[clouds-lxd]: ./clouds-LXD.md
[clouds-vmware]: ./help-vmware.md
[clouds-openstack]: ./help-openstack.md
[clouds-maas]: ./clouds-maas.md
[clouds-manual]: ./clouds-manual.md
[clouds-k8s]: ./clouds-k8s.md

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[controllers-creating]: ./controllers-creating.md
[controllers-creating-include-config]: ./controllers-creating.md#passing-a-cloud-specific-setting

[clouds-maas-manual]: ./clouds-maas.md#manually-adding-maas-clouds
[clouds-openstack-manual]: ./help-openstack.md#manually-adding-an-openstack-cloud
[clouds-vsphere-manual]: ./help-vmware.md#manually-adding-a-vsphere-cloud
