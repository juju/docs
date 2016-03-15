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
[credentials][credentials] and start deploying services.

## Listing available clouds

To see which clouds Juju currently knows about, you can run the command:
  
```bash
juju list-clouds
```

This will return a list like this:
  
```no-highlight
CLOUD        TYPE        REGIONS
aws          ec2         us-east-1, us-west-1, us-west-2, eu-west-1, eu-central-1, ap-southeast-1, ap-southeast-2 ...
aws-china    ec2         cn-north-1
aws-gov      ec2         us-gov-west-1
azure        azure       centralus, eastus, eastus2, northcentralus, southcentralus, westus, northeurope ...
azure-china  azure       chinaeast, chinanorth
cloudsigma   cloudsigma  hnl, mia, sjc, wdc, zrh
google       gce         us-east1, us-central1, europe-west1, asia-east1
joyent       joyent      eu-ams-1, us-sw-1, us-east-1, us-east-2, us-east-3, us-west-1
lxd          lxd         localhost
maas         maas        
manual       manual      
rackspace    rackspace   DFW, ORD, IAD, LON, SYD, HKG
```

This lists the cloud name (which you will use to specify the cloud you want to 
use), its type (the API used to control it) and the known regions for the cloud.

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

You will see, listed among the clouds Juju knows about, three special types of
clouds: MAAS, LXD and Manual.

  - **LXD:** This is the cloud you want to use if you are testing Juju or 
  developing your own Juju charms - it is incredibly fast! 
  [LXD is a container hypervisor][LXD-site] that runs on any Linux host, providing 
  the ability to spin up containers on the host machine. For more details on
  using LXD, please see the [LXD documentation][juju-lxd]
  
  - **MAAS:** An acronym of Metal As A Service, MAAS lets you treat physical
  servers like virtual machines in the cloud. Rather than having to manage each
  server individually, MAAS turns your bare metal into an elastic cloud-like
  resource. There is more information on MAAS at the [MAAS website][maas-site], 
  and detailed [instructions on using MAAS with Juju here][juju-maas].
  
  - **Manual:** There may be occassions where you can bring up machines for Juju
  to use which aren't part of a recognised public cloud or do not support other
  protocols used by Juju. As long as you have SSH access to these machines, you
  can get part of the Juju magic and deploy services. See 
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
    regions:
      <region-name>:
        auth-url: <https://xxx.yyy.zzz:35574/v3.0/>
        auth-types: <[access-key, oauth, userpass]>
```
with the releavant values substituted in for the parts indicated
(within '<' '>').

For example, a typical OpenStack cloud on the local network you want to call 
'mystack' would appear something like this:
  
```yaml
clouds:
    mystack:
      type: openstack
      regions:
        dev1:
          auth-url: https://openstack.example.com:35574/v3.0/
          auth-types: [access-key, userpass]
```
With the yaml file saved, you can now import this information into Juju like so:
  
```bash
juju add-cloud mystack mystack.yaml
```

Note that the name you give your cloud MUST match the value given inside the 
YAML file you created.

Having added a new cloud, if you re-run the `juju list-clouds` command, you 
should see something like this:

```no-highlight
CLOUD          TYPE        REGIONS
aws            ec2         us-east-1, us-west-1, us-west-2, eu-west-1, eu-central-1, ap-southeast-1, ap-southeast-2 ...
aws-china      ec2         cn-north-1
aws-gov        ec2         us-gov-west-1
azure          azure       centralus, eastus, eastus2, northcentralus, southcentralus, westus, northeurope ...
azure-china    azure       chinaeast, chinanorth
cloudsigma     cloudsigma  hnl, mia, sjc, wdc, zrh
google         gce         us-east1, us-central1, europe-west1, asia-east1
joyent         joyent      eu-ams-1, us-sw-1, us-east-1, us-east-2, us-east-3, us-west-1
lxd            lxd         localhost
maas           maas        
manual         manual      
rackspace      rackspace   DFW, ORD, IAD, LON, SYD, HKG
local:mystack  openstack   dev1
```

The 'local:' prefix indicates that this is a cloud you have added yourself. 


[credentials]: ./credentials.html "Juju documentation > Credentials"
[LXD-site]: http://www.ubuntu.com/cloud/lxd "LXD"
[juju-lxd]: ./cloud-LXD.html "Juju documentation > LXD"
[maas-site]: http://maas.io "MAAS website"
[juju-maas]: ./cloud-maas.html "Juju documentation > MAAS"
[juju-manual]: ./cloud-manual.html "Juju documentation > Manual cloud"
[yaml]: http://www.yaml.org/spec/1.2/spec.html
