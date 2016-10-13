Title: Using a VMware vSphere cloud
TODO: Test vSphere

# Using a VMware vSphere Cloud

In order to use the vSphere provider you will need to have an existing
vSphere installation which supports VMware's Hardware Version 8 or better.

Juju doesn't have baked-in knowledge of your specific vSphere cloud, but it
does know how such clouds work. We just need to provide some information to add
it to the list of known clouds. 

## Adding a vSphere cloud

vSphere support in the current version of Juju is provisional. You need to set
the environmental variable JUJU_DEV_FEATURE_FLAGS="vsphere-provider" within
your shell to enable it:

```bash
export JUJU_DEV_FEATURE_FLAGS="vsphere-provider"
```
To make Juju aware of your vSphere installation, you will need to define it
within a YAML file containing the following values:

  - **cloudname**: an arbitrary name for your own reference
  - **endpoint**: the IP address of the VMware server
  - **region name**: a named region for each data centre

With a **cloudname** of `myvscloud`, an **endpoint** of `178.18.42.10` and a
single data centre called `dc0`, a basic configuration would look similar to
this:

```yaml
clouds:
 myvscloud:
  type: vsphere
  auth-types: [userpass]
  endpoint: 178.18.42.10
  regions:
   dc0: {}
```

To add the above cloud definition to Juju, enter the following:

```bash
juju add-cloud myvscloud <YAML file>
```

You can check whether your vSphere installation has been added correctly by
looking for the following in the output from `juju list-clouds`:

```bash
CLOUD           TYPE        REGIONS
aws             ec2         us-east1, us-west1, us-west2
...
myvscloud    vsphere     dc0
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
juju bootstrap vsphere myvscloud
```

!!! Note: Juju's vSphere provider downloads a cloud image to the Juju client machine
and then uploads it to your cloud. If you're far away from VMware, this may
take some time.
