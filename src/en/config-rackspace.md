Title: Configuring for Rackspace
TODO: Review again when Juju 2.0 more mature ('juju add-credential rackspace' should exist)
      Need exhaustive list of conf/cred parameters to use ('juju help rackspace-provider' should exist)


# Configuring for Rackspace


## Prerequisites

 - A Rackspace cloud account is required. See https://cart.rackspace.com/cloud .

 - The Juju client (the host running the below commands) will need the ability
   to contact the Rackspace infrastructure on TCP ports 22 and 17070.

 - An understanding of the [Getting started](./getting-started.html) page.


## Configuration

Values will need to be found for the following parameters:

 - default-region
 - auth-type
 - username
 - password
 - tenant-name

### `default-region`

### `auth-type`

### `username`

### `password`

### `tenant-name`

The file `~/config-rackspace.yaml` in this example would look like this:

```yaml
logging-config: "<root>=DEBUG"
agent-metadata-url: https://streams.canonical.com/juju/tools
image-metadata-url: http://0315ec36e423bb7dba4b-3eabf88619cf7b7e6fc262bcf48df10b.r19.cf1.rackcdn.com/images
image-stream: "released"
default-series: "trusty"
```

!!! Note: A temporary URL provided by Rackspace has been used for
'image-metadata-url' in the example configuration.


## Credentials

The file `credentials-rackspace.yaml` in this example would look like this:

```yaml
    rackspace:
        default-credential: some_label
        default-region: DFW
        some_label:
            auth-type: userpass
            username: username
            password: secret_password
            tenant-name: "######'
```

Now add these credentials to the system. At time of this writing, you must
manually add the above block to the user-wide credentials file
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
            username: username
            password: secret_password
            tenant-name: "######'
```

```bash
juju list-credentials
```

## Bootstrap

Once the configuration and credentials files have been set it is time to
bootstrap. Here we call the controller 'controller-rackspace' and use `--upload-tools`
to make the agent software available to our chosen series (Trusty):

```bash
juju bootstrap controller-rackspace rackspace --debug --upload-tools --config=~/config-rackspace.yaml
```

A successful bootstrap will result in the controller being visible in the
[Rackspace cloud console](https://mycloud.rackspace.com):

![bootstrap machine 0 in Rackspace portal](./media/config-rackspace_portal-machine_0.png)


## Additional notes

See [General configuration options](https://jujucharms.com/docs/stable/config-general)
for additional and advanced customization of your environment.
