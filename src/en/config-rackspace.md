Title: Configuring for Rackspace
TODO: Review again soon (created: March 2016)
      'juju add-credential rackspace' should exist
      Need exhaustive list of conf/cred parameters to use
      Does 'juju show-cloud rackspace' replace 'juju help rackspace-provider'? Confirm these commands
      Confirm navigation.tpl contains controllers & models (see links in first paragraph)
      Explain the configuration parameters (like credentials parameters)
      Explain how to use auth-type 'access-key'


# Configuring for Rackspace

Here we gather the ingredients necessary for the creation of a *controller* for
the Rackspace cloud provider (see [Controllers](./controllers.html)). If your
objective is instead to create a Rackspace *model* please see [Defining a
model](./models-defining.html).


## Prerequisites

 - A Rackspace cloud account is required. See https://cart.rackspace.com/cloud .

 - The Juju client (the host running the below commands) will need the ability
   to contact the Rackspace infrastructure on TCP ports 22 and 17070.

 - An understanding of the [Getting started](./getting-started.html) page.


## Credentials

Values will need to be found for certain parameters:

**`default-region`**<br/>
Decide on the default Rackspace *region*. See 
[Rackspace regions](https://support.rackspace.com/how-to/about-regions/).
or the output to `juju list-clouds`.

**`auth-type`**<br/>
This can be either 'access-key' or 'userpass'. Here, we'll use 'userpass'.

**`username`**<br/>
For the 'userpass' auth-type, this is the name used to log in to the
[Rackspace cloud control panel](https://mycloud.rackspace.com).

**`password`**<br/>
For the 'userpass' auth-type, this is the password associated with the value of
'username'.

**`tenant-name`**<br/>
This is the Rackspace account number. You can view it in the cloud control
panel in the top-right corner (under your username).

See `juju show-cloud rackspace`.

### Add credentials

Create a YAML file called, say, `credentials-rackspace.yaml` and provide the
credential-related material. In this example, it would look like this:

```yaml
    rackspace:
        default-credential: some_label
        default-region: DFW
        some_label:
            auth-type: userpass
            username: your_username
            password: your_password
            tenant-name: "123456"
```

Now add this to the system. At time of this writing, you must manually add the
above block to the user-wide credentials file
`~/.local/share/juju/credentials`. Put it under the 'credentials:' section.
Therefore, if this is the sole block in that file, the entire file would appear
as:

```yaml
credentials:
    rackspace:
        default-credential: some_label
        default-region: DFW
        some_label:
            auth-type: userpass
            username: your_username
            password: your_password
            tenant-name: "123456"
```


## Configuration

Create a YAML file called, say, `~/config-rackspace.yaml` and provide the
configuration-related material. In this example, it would look like this:

```yaml
logging-config: "<root>=DEBUG"
agent-metadata-url: https://streams.canonical.com/juju/tools
image-metadata-url: http://0315ec36e423bb7dba4b-3eabf88619cf7b7e6fc262bcf48df10b.r19.cf1.rackcdn.com/images
image-stream: "released"
default-series: "trusty"
```

!!! Note: A temporary URL provided by Rackspace has been used for
'image-metadata-url' in the example configuration. This should not be needed in
the long term.


## Create controller

Once the configuration and credentials information have been entered it is time
to create the controller for Rackspace. See
[Creating a controller](./controllers-creating.html).

This will result in the controller being visible in the
[Rackspace cloud control panel](https://mycloud.rackspace.com):

![bootstrap machine 0 in Rackspace portal](./media/config-rackspace_portal-machine_0.png)


## Additional notes

See [General configuration options](https://jujucharms.com/docs/stable/config-general)
for additional and advanced customization of your environment.
