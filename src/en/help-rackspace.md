Title: Help with Rackspace clouds

# Using the Rackspace public cloud

Juju already has knowledge of the Rackspace cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. Rackspace
will appear in the list of known clouds when you issue the command:
  
```bash
juju list-clouds
```
And you can see more specific information (e.g. the supported regions) by 
running:
  
```bash
juju show-cloud rackspace
```

If at any point you believe Juju's information is out of date (e.g. Rackspace just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Credentials

For Juju to use 'userpass' authentication, you will need to collect the 
following information from your Rackspace account:

 - **`username`** For the 'userpass' auth-type, this is the name used to log
    in to the [Rackspace cloud control panel](https://mycloud.rackspace.com).

 - **`password`** For the 'userpass' auth-type, this is the password associated
    with the value of 'username'.

 - **`tenant-name`** This is the Rackspace account number. You can view it in 
    the cloud control panel in the top-right corner (under your username).

 - **`region`** This is the Rackspace region, such as 'dfw', 'lon', or 'syd'.

To add these credentials for Juju to use, select one of these options:
  
### 1. Using environment variables

You can set the following variables: `OS_USERNAME`, `OS_PASSWORD`,
`OS_AUTH_URL`, `OS_REGION_NAME`, `OS_TENANT_NAME`, `OS_ACCESS_KEY`, and
`OS_SECRET_KEY`.

These can easily be imported into Juju. Run the command:
  
```bash
juju autoload-credentials
```
This will scan known locations and environment variables for cloud credentials
and ask which ones to use/what name to store them under.

### 2. Manually adding credentials

Run the interactive command:
  
```bash
juju add-credential rackspace
```

Which will ask for a credential name, and the authentication type. Enter 
'userpass' and proceed with the values obtained above.

!!! Note: If you add more than one credential for this cloud, you will also
need to set the default one to use with `juju set-default-credential`.


### 3. Create and use a `~/.novarc` file

Place the AWS information in a '~/.novarc' or similarly named file
containing the environment variables and assigned values. See the official
[OpenStack](http://docs.openstack.org/icehouse/install-guide/install/apt/content/cli_openrc.html) documentation.

## Configuration

Currently, Rackspace do not use the default published streams for machine 
images and it is necessary to provide some extra configuration.

Create a YAML file called, say, `~/config-rackspace.yaml` and provide the
configuration-related material. In this example, it would look like this:

```yaml
agent-metadata-url: https://streams.canonical.com/juju/tools
image-metadata-url: http://0315ec36e423bb7dba4b-3eabf88619cf7b7e6fc262bcf48df10b.r19.cf1.rackcdn.com/images
image-stream: "released"
default-series: "trusty"
```
This file will be used in the next stage.

## Bootstrap

To create the controller, run the following command:
  

```bash
juju bootstrap mycloud rackspace --config=~/config-rackspace.yaml
```

This will create a new controller called 'mycloud' with the configuration 
values we entered earlier.

This controller will be visible in the
[Rackspace cloud control panel](https://mycloud.rackspace.com):

![bootstrap machine 0 in Rackspace portal](./media/config-rackspace_portal-machine_0.png)
