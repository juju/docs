Title: Juju clouds
TODO: Needs to explain available auth types for clouds
  
# Clouds

Juju ships with the ability to seamlessly use a number of public clouds
(including Amazon Web Services, Azure, Google Compute Engine, Joyent and
Rackspace) to deploy workloads, as well as private clouds (e.g.
OpenStack) which you configure.

The knowledge to run these public clouds is 'baked-in', so for the majority
of use-cases there is no additional configuration to be done - you can
simply specify the cloud you wish to use, supply Juju with some
[credentials][credentials] and start deploying applications.

## Listing available clouds

To see which clouds Juju currently knows about, you can run the command:
  
```bash
juju list-clouds
```

This will return a list like this:
  
```no-highlight
Cloud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
aws-china          1  cn-north-1     ec2         Amazon China
aws-gov            1  us-gov-west-1  ec2         Amazon (USA Government)
azure             18  centralus      azure       Microsoft Azure
azure-china        2  chinaeast      azure       Microsoft Azure China
cloudsigma         5  hnl            cloudsigma  CloudSigma Cloud
google             4  us-east1       gce         Google Cloud Platform
joyent             6  eu-ams-1       joyent      Joyent Cloud
rackspace          6  dfw            rackspace   Rackspace Cloud
localhost          1  localhost      lxd         LXD Container Hypervisor
```

This lists the cloud name (which you will use to specify the cloud you want to 
use), its type (the API used to control it) and the default region for each
cloud, so in the above, `us-east-1` is the default region for an aws cloud.

To see which regions Juju currently knows about for a specific cloud, you can
run the command, replacing `aws` with any of the clouds returned in the previous
command:
  
```bash
juju list-regions aws
```

This will return a list like this:
  
```no-highlight
us-east-1
us-west-1
us-west-2
eu-west-1
eu-central-1
ap-south-1
ap-southeast-1
ap-southeast-2
ap-northeast-1
ap-northeast-2
sa-east-1
```

This lists all of the regions available to you for the named cloud. To specify
a different region, see [Creating a controller](./controllers-creating.html).

Set the default region for a cloud with:
```bash
juju set-default-region aws eu-central-1
```

If you want more detail about a particular cloud, use:
```bash
juju show-cloud azure
```

Juju may have baked-in knowledge, but sometimes the recipe changes. Juju can 
also update its knowledge of public clouds, to take into account changes in 
the way clouds work, new regions or other aspects of their operation.

The command:
  
```bash
juju update-clouds
```

will fetch the latest information on supported public clouds. It is a good idea
to run this periodically, or if you are sure there are additional regions/clouds 
Juju supports which are not currently listed.

!!! Note: Juju can work with any OpenStack cloud, see the notes below for
[specifying additional clouds](#specifying-additional-clouds)

### Special clouds

There are three special types of
clouds: MAAS, LXD and Manual.

  - **LXD:** This is the cloud you want to use if you are testing Juju or 
  developing your own Juju charms - it is incredibly fast! 
  [LXD is a container hypervisor][LXD-site] that runs on any Linux host, providing 
  the ability to spin up containers on the host machine. For more details on
  using LXD, please see the [LXD documentation][juju-lxd].
  
  - **MAAS:** An acronym of Metal As A Service, MAAS lets you treat physical
  servers like virtual machines in the cloud. Rather than having to manage each
  server individually, MAAS turns your bare metal into an elastic cloud-like
  resource. There is more information on MAAS at the [MAAS website][maas-site], 
  and detailed [instructions on using MAAS with Juju here][juju-maas].
  
  - **Manual:** There may be occassions where you can bring up machines for Juju
  to use which aren't part of a recognised public cloud or do not support other
  protocols used by Juju. As long as you have SSH access to these machines, you
  can get part of the Juju magic and deploy applications. See 
  [this documentation][juju-manual] for details on how to register these 
  machines with Juju and use them as part of a cloud.

## Specifying additional clouds

There are cases (an OpenStack cloud is a common one) where the cloud you want to 
use is not on Juju's list of known clouds. In this case it is possible to create
a [YAML][yaml] formatted file with the information Juju requires and import this
new definition. The file should follow this general format:
  
```yaml
clouds:
  <cloud_name>:
    type: <type_of_cloud>
    auth-types: <[access-key, oauth, userpass]>
    regions:
      <region-name>:
        endpoint: <https://xxx.yyy.zzz:35574/v3.0/>
```
with the releavant values substituted in for the parts indicated
(within '<' '>').

For example, a typical OpenStack cloud on the local network you want to call 
'mystack' would appear something like this:
  
```yaml
clouds:
    mystack:
      type: openstack
      auth-types: [access-key, userpass]
      regions:
        dev1:
          endpoint: https://openstack.example.com:35574/v3.0/
```
In this case the url is at https://openstack.example.com:35574/v3.0/, and the cloud accepts either access-key or username/password authentication methods.

With the yaml file saved, you can now import this information into Juju like so:
  
```bash
juju add-cloud mystack mystack.yaml
```

Note that the name you give your cloud MUST match the value given inside the 
YAML file you created.

Having added a new cloud, if you re-run the `juju list-clouds` command, you 
should see something like this:

```no-highlight
loud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
aws-china          1  cn-north-1     ec2         Amazon China
aws-gov            1  us-gov-west-1  ec2         Amazon (USA Government)
azure             18  centralus      azure       Microsoft Azure
azure-china        2  chinaeast      azure       Microsoft Azure China
cloudsigma         5  hnl            cloudsigma  CloudSigma Cloud
google             4  us-east1       gce         Google Cloud Platform
joyent             6  eu-ams-1       joyent      Joyent Cloud
rackspace          6  dfw            rackspace   Rackspace Cloud
localhost          1  localhost      lxd         LXD Container Hypervisor
mystack            1  dev1           openstack   Openstack Cloud
```
[credentials]: ./credentials.html "Juju documentation > Credentials"
[LXD-site]: http://www.ubuntu.com/cloud/lxd "LXD"
[juju-lxd]: ./clouds-LXD.html "Juju documentation > LXD"
[maas-site]: http://maas.io "MAAS website"
[juju-maas]: ./clouds-maas.html "Juju documentation > MAAS"
[juju-manual]: ./clouds-manual.html "Juju documentation > Manual cloud"
[yaml]: http://www.yaml.org/spec/1.2/spec.html
