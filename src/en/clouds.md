Title: Clouds
TODO:  Needs to explain available auth types for clouds
  
# Clouds

Juju has built-in support for all major public clouds such as AWS (Amazon),
Azure (Microsoft), and GCE (Google), as well as for others. This means that no
preliminary work is needed to "teach" Juju about your chosen cloud. You simply
provide Juju with your cloud credentials and start deploying applications.
Private clouds like MAAS and OpenStack also work very well but naturally
require some extra configuration on your part.

This page contains general information about using clouds with Juju. To start
immediately with your chosen cloud you can go directly to
[Cloud credentials][credentials].

## Listing available clouds

To see which clouds Juju currently knows about, you can run the command:
  
```bash
juju clouds
```

This will return a list like this:
  
```no-highlight
Cloud        Regions  Default          Type        Description
aws               14  us-east-1        ec2         Amazon Web Services
aws-china          1  cn-north-1       ec2         Amazon China
aws-gov            1  us-gov-west-1    ec2         Amazon (USA Government)
azure             24  centralus        azure       Microsoft Azure
azure-china        2  chinaeast        azure       Microsoft Azure China
cloudsigma         5  hnl              cloudsigma  CloudSigma Cloud
google             7  us-east1         gce         Google Cloud Platform
joyent             6  eu-ams-1         joyent      Joyent Cloud
oracle             5  uscom-central-1  oracle      Oracle Cloud
rackspace          6  dfw              rackspace   Rackspace Cloud
localhost          1  localhost        lxd         LXD Container Hypervisor
```

This lists the cloud name (which you will use to specify the cloud you want to 
use), its type (the API used to control it) and the default region for each
cloud, so in the above, `us-east-1` is the default region for an aws cloud.

To see which regions Juju currently knows about for a specific cloud, you can
run the command, replacing `aws` with any of the clouds returned in the previous
command:
  
```bash
juju regions aws
```

This will return a list like this:
  
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

### Special clouds

There are three special types of clouds: MAAS, LXD and Manual.

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
  
  - **Manual:** There may be occasions where you can bring up machines for Juju
  to use which aren't part of a recognised public cloud or do not support other
  protocols used by Juju. As long as you have SSH access to these machines, you
  can get part of the Juju magic and deploy applications. See 
  [this documentation][juju-manual] for details on how to register these 
  machines with Juju and use them as part of a cloud.

## Specifying additional clouds

There are cases (an OpenStack cloud is a common one) where the cloud you want to 
use is not on Juju's list of known clouds. Juju usually only needs a small 
amount of information to be able to use these clouds too, so the fastest way to
get them recognised is to use the `add-cloud` command in its interactive mode.
This will ask a series of questions based on the type of cloud you are trying
to add. Currently Juju can add MAAS, OpenStack, Oracle, vSphere and manual
clouds in this way - each is detailed below (click on the triangle or name to
expand the relevant section). You can also generate a YAML file

^# MAAS

   To add a MAAS cloud, Juju only needs to know the name you wish to call it, and 
   the API endpoint used to connect to it. A sample session looks like this:
       
       juju add-cloud
  
       Cloud Types
        maas
        manual
        openstack
        oracle
        vsphere

       Select cloud type: maas

       Enter a name for your maas cloud: mainmaas

       Enter the API endpoint url: http://maas.example.org:5240/MAAS/api/2.0

      Cloud "mainmaas" successfully added
      You may bootstrap with 'juju bootstrap mainmaas'

   Once completed, you should also remember to add a credential for this cloud before 
   bootstrapping. See the [documentation on credentials][credentials] for more help.

^# Manual

   To add a 'manual' cloud, Juju only needs to know the name you wish to call it, and 
   the network address used to connect to it. A sample session looks like this:
       
       juju add-cloud
  
       Cloud Types
        maas
        manual
        openstack
        oracle
        vsphere

       Select cloud type: maas

       Enter a name for your maas cloud: mainmaas

       Enter the API endpoint url: http://maas.example.org:5240/MAAS/api/2.0

      Cloud "mainmaas" successfully added
      You may bootstrap with 'juju bootstrap mainmaas'

   Once completed, you should also remember to add a credential for this cloud before 
   bootstrapping. See the [documentation on credentials][credentials] for more help.

^# OpenStack

   To add an OpenStack cloud, Juju needs to know the endpoints to connect to, the 
   authorisation type to use and any region information. A sample session is shown
   below:
   
       juju add-cloud
       
       Cloud Types
        maas
        manual
        openstack
        oracle
        vsphere
       
       Select cloud type: openstack
       
       Enter a name for your openstack cloud: devstack
       
       Enter the API endpoint url for the cloud: https://openstack.example.com:35574/v3.0/
       
       Auth Types
        access-key
        userpass
       
       Select one or more auth types separated by commas: access-key,userpass
       
       Enter region name: dev1
       
       Enter the API endpoint url for the region: https://openstack-dev.example.com:35574/v3.0/
       
       Enter another region? (Y/n): n
       
       Cloud "devstack" successfully added
       You may bootstrap with 'juju bootstrap homestack'
       
   Note that it is possible to choose more than one authorisation method - just 
   separate the values with commas.

   Once completed, you should also remember to add a credential for this cloud
   before bootstrapping. See the [documentation on credentials][credentials] for
   more help.

^# Oracle

   You should only need to do this if you're using an Oracle trial account as
   the regular (paid) Oracle cloud is built-in, see
   [Oracle Compute][clouds-oracle] for both types of accounts.

   To add a cloud based on Oracle Compute, you first need to
   [import one or more Ubuntu images][oracleimages] from the Oracle dashboard.
   Juju then needs to know how to connect to Oracle and what to call the cloud:
       
       juju add-cloud

       Cloud Types
        maas
        manual
        openstack
        oracle
        vsphere
       
       Select cloud type: oracle
       Enter a name for your oracle cloud: oc
       
       Enter the API endpoint url for the cloud: https://api-z41.compute.em3.oraclecloud.com/

       Cloud "oracle" successfully added
       You may bootstrap with 'juju bootstrap oracle'

   The `endpoint address` in this case is the REST endpoint of the Compute
   domain. 

   Once completed, you should also remember to add a credential for this cloud before 
   bootstrapping. See the [documentation on credentials][credentials] for more help.

^# vSphere

   To add a cloud based on VMWare's vSphere, Juju needs to know how to connect to it
   and what to call the cloud.  :
       
       juju add-cloud
       Cloud Types
         maas
         manual
         openstack
         oracle
         vsphere
       
       Select cloud type: vsphere
       Enter a name for your vsphere cloud: vs1
       
       Enter the API endpoint url for the cloud: 178.18.42.10
       
       Enter region name: dc0
       
       Enter another region? (Y/n): y
       
       Enter region name: dc1
       
       Enter another region? (Y/n): n
       
       Cloud "vs1" successfully added
       You may bootstrap with 'juju bootstrap vs1'

   The `endpoint address` in this case is the IP address of the vSphere server. In this case
   we have also specified multiple regions (data centres in vSphere terminology).

   Once completed, you should also remember to add a credential for this cloud before 
   bootstrapping. See the [documentation on credentials][credentials] for more help.

## Manually specifying additional clouds

In this case it is possible to create
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

Having added a new cloud, if you re-run the `juju clouds` command, you 
should see something like this:

```no-highlight
Cloud        Regions  Default          Type        Description
aws               14  us-east-1        ec2         Amazon Web Services
aws-china          1  cn-north-1       ec2         Amazon China
aws-gov            1  us-gov-west-1    ec2         Amazon (USA Government)
azure             24  centralus        azure       Microsoft Azure
azure-china        2  chinaeast        azure       Microsoft Azure China
cloudsigma         5  hnl              cloudsigma  CloudSigma Cloud
google             7  us-east1         gce         Google Cloud Platform
joyent             6  eu-ams-1         joyent      Joyent Cloud
oracle             5  uscom-central-1  oracle      Oracle Compute Cloud Service
rackspace          6  dfw              rackspace   Rackspace Cloud
localhost          1  localhost        lxd         LXD Container Hypervisor
mystack            1  dev1             openstack   Openstack Cloud
```

<!-- LINKS -->

[credentials]: ./credentials.html "Juju documentation > Credentials"
[LXD-site]: http://www.ubuntu.com/cloud/lxd "LXD"
[juju-lxd]: ./clouds-LXD.html "Juju documentation > LXD"
[maas-site]: http://maas.io "MAAS website"
[juju-maas]: ./clouds-maas.html "Juju documentation > MAAS"
[juju-manual]: ./clouds-manual.html "Juju documentation > Manual cloud"
[yaml]: http://www.yaml.org/spec/1.2/spec.html
[clouds-oracle]: ./help-oracle.html
[oracleimages]: ./help-oracle.html#images
