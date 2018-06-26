Title: Clouds
TODO:  Needs to explain available auth types for clouds
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1749302
       Bug tracking: https://bugs.launchpad.net/juju/+bug/1749583
  
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

## Listing and updating cloud information

To see which clouds Juju is aware of use the `clouds` command:

```bash
juju clouds
```

This will return a list very similar to:

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

Each line represents a backing cloud that Juju can interact with. It gives the
cloud name, the number of cloud regions Juju is aware of, the default region
(for the current Juju client), the type/API used to control it, and a brief
description.

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

To specify a different region, see
[Creating a controller](./controllers-creating.html).

To change the default region for a cloud:

```bash
juju set-default-region aws eu-central-1
```

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

## Special clouds

There are three special cloud types: LXD, MAAS, and Manual.

  - **LXD**  
  This cloud is based on containers running locally. It is quick to set up and
  is ideal for testing Juju and developing your own charms. For details on this
  cloud see the [Using LXD with Juju][clouds-lxd] page.
  
  - **MAAS**  
  This cloud treats physical servers as a public cloud treats cloud instances.
  For details on this cloud see the [Using MAAS with Juju][clouds-maas] page.
  
  - **Manual**  
  There may be occasions where you can bring up machines for Juju
  to use which aren't part of a recognised public cloud or do not support other
  protocols used by Juju. As long as you have SSH access to these machines, you
  can get part of the Juju magic and deploy applications. See 
  [this documentation][juju-manual] for details on how to register these 
  machines with Juju and use them as part of a cloud.

## Adding clouds

There are cases (an OpenStack cloud is a common one) where the cloud you want to 
use is not on Juju's list of known clouds. Juju usually only needs a small 
amount of information to be able to use these clouds too, so the fastest way to
get them recognised is to use the `add-cloud` command in its interactive mode.
This will ask a series of questions based on the type of cloud you are trying
to add. Currently Juju can add MAAS, OpenStack, Oracle, vSphere and manual
clouds in this way - each is detailed below (click on the triangle or name to
expand the relevant section). You can also generate a YAML file.

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

   You must now add a credential for this cloud prior to creating a controller
   (`juju bootstrap`). See the [Credentials][credentials] page for details.
   
^# Manual

   To add a Manual cloud, Juju needs to know the name you wish to call it, the
   IP address (or hostname) used to connect to it, and what remote user account
   to connect to (over SSH). This last is done by prepending 'user@' to the
   address/hostname.
   
   In terms of SSH, the user running the Juju client is expected to already be
   able to connect to the remote host (either by password or public key).
   
   A sample session looks like this:

       juju add-cloud

       Cloud Types
        maas
        manual
        openstack
        oracle
        vsphere
      
      Select cloud type: manual
      
      Enter a name for your manual cloud: mycloud
      
      Enter the controller's hostname or IP address: noah@10.143.211.93
      
      Cloud "mycloud" successfully added
      You may bootstrap with 'juju bootstrap mycloud'

   A Juju-added credential is not required. The ability for Juju to make an SSH
   connection is all that's needed.

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

   You must now add a credential for this cloud prior to creating a controller
   (`juju bootstrap`). See the [Credentials][credentials] page for details.

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

   You must now add a credential for this cloud prior to creating a controller
   (`juju bootstrap`). See the [Credentials][credentials] page for details.

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

   The `endpoint address` in this case is the IP address of the vSphere server.
   In this case we have also specified multiple regions (data centres in
   vSphere terminology).

   You must now add a credential for this cloud prior to creating a controller
   (`juju bootstrap`). See the [Credentials][credentials] page for details.

### Adding clouds manually

As an alternative to the interactive method, clouds can be added manually. This
can assist with automation.

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. It has the following format:

```yaml
clouds:
  <cloud_name>:
    type: <type_of_cloud>
    auth-types: <[access-key, oauth1, userpass]>
    regions:
      <region-name>:
        endpoint: <https://xxx.yyy.zzz:35574/v3.0/>
```

To add a cloud in this way we simply supply an extra argument to specify the
relative path to the file:
 
`juju add-cloud <cloudname> <file>`

To confirm that the cloud has been successfully added you can re-run the
`clouds` command.

Below we provide two examples.

#### Manually adding MAAS clouds

This example covers manually adding a MAAS cloud to Juju. It also demonstrates
how multiple clouds of the same type can be defined and added.

Here is the YAML file:

```yaml
clouds:
   devmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://devmaas/MAAS
   testmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://172.18.42.10/MAAS
   prodmaas:
      type: maas
      auth-types: [oauth1]
      endpoint: http://prodmaas/MAAS
```

This defines three MAAS clouds and refers to them by their respective
region controllers.

To add clouds 'devmaas' and 'prodmaas', assuming the configuration file is
`maas-clouds.yaml` in the current directory, we would run:

```bash
juju add-cloud devmaas maas-clouds.yaml
juju add-cloud prodmaas maas-clouds.yaml
```

You must now add a credential for this cloud prior to creating a controller
(`juju bootstrap`). See the [Credentials][credentials] page for details. The
[Using MAAS with Juju][clouds-maas-add-credentials] page also includes
MAAS-specific guidance on this.

#### Manually adding an OpenStack cloud

This examples shows how to manually add an OpenStack cloud to Juju. It also
demonstrates how multiple authentication methods can be stipulated.

Here is the YAML file:

```yaml
clouds:
    mystack:
      type: openstack
      auth-types: [access-key, userpass]
      regions:
        dev1:
          endpoint: https://openstack.example.com:35574/v3.0/
```

To add cloud 'mystack', assuming the configuration file is `mystack.yaml` in
the current directory, we would run:
  
```bash
juju add-cloud mystack mystack.yaml
```

You must now add a credential for this cloud prior to creating a controller
(`juju bootstrap`). See the [Credentials][credentials] page for details.


<!-- LINKS -->

[credentials]: ./credentials.md
[clouds-lxd]: ./clouds-LXD.md
[maas-site]: http://maas.io
[juju-maas]: ./clouds-maas.md
[juju-manual]: ./clouds-manual.md "Juju documentation > Manual cloud"
[yaml]: http://www.yaml.org/spec/1.2/spec.html
[clouds-oracle]: ./help-oracle.md
[oracleimages]: ./help-oracle.md#images
[controllers-creating-include-config]: ./controllers-creating.md#passing-a-cloud-specific-setting
[clouds-maas-add-credentials]: ./clouds-maas.md#add-credentials
