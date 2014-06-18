# Configuring for OpenStack

You can use a menu driven environment to configure OpenStack by executing

    juju quickstart -i

Then scrolling down to "Create a new OpenStack environment" and hitting enter,
and then adding the credentials to your cloud in the appropriate fields.

You can also manually generate a generic configuration file for Juju, using the
command:

    juju generate-config

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

**Note:** If you have an existing configuration, you can use
`juju generate-config --show` to output the new config file, then copy and
paste relevant areas in a text editor etc.

The essential configuration sections for OpenStack look like this:

```yaml
type: openstack
# use-floating-ip specifies whether a floating IP address is
# required to give the nodes a public IP address. Some
# installations assign public IP addresses by default without
# requiring a floating IP address.
#
# use-floating-ip: false
# use-default-secgroup specifies whether new machine instances
# should have the "default" Openstack security group assigned.
#
# use-default-secgroup: false
# network specifies the network label or uuid to bring machines up
# on, in the case where multiple networks exist. It may be omitted
# otherwise.
#
# network: <your network label or uuid>
# tools-metadata-url specifies the location of the Juju tools and
# metadata. It defaults to the global public tools metadata
# location https://streams.canonical.com/tools.
#
# tools-metadata-url:  https://your-tools-metadata-url
# image-metadata-url specifies the location of Ubuntu cloud image
# metadata. It defaults to the global public image metadata
# location https://cloud-images.ubuntu.com/releases.
#
# image-metadata-url:  https://your-image-metadata-url
# image-stream chooses a simplestreams stream to select OS images
# from, for example daily or released images (or any other stream
# available on simplestreams).
#
# image-stream: "released"
# auth-url defaults to the value of the environment variable
# OS_AUTH_URL, but can be specified here.
#
# auth-url: https://yourkeystoneurl:443/v2.0/
# tenant-name holds the openstack tenant name. It defaults to the
# environment variable OS_TENANT_NAME.
#
# tenant-name: <your tenant name>
# region holds the openstack region. It defaults to the
# environment variable OS_REGION_NAME.
#
# region: <your region>
# The auth-mode, username and password attributes are used for
# userpass authentication (the default).
#
# auth-mode holds the authentication mode. For user-password
# authentication, auth-mode should be "userpass" and username and
# password should be set appropriately; they default to the
# environment variables OS_USERNAME and OS_PASSWORD respectively.
#
# auth-mode: userpass
# username: <your username>
# password: <secret>
#
# For key-pair authentication, auth-mode should be "keypair" and
# access-key and secret-key should be set appropriately; they
# default to the environment variables OS_ACCESS_KEY and
# OS_SECRET_KEY respectively.
#
# auth-mode: keypair
#access-key: <secret>
# secret-key: <secret>
```

**Note:** At any time you can run `juju generate-config --show` to display the
most revent version of the environments.yaml template file, instead of having
it write to file. Or you can invoke `juju quickstart -i` for an interactive way
of changing fields.

Remember to substitute in the parts of the snippet that are important to you.
If you are deploying on OpenStack the following documentation might also be
useful:

[Ubuntu Cloud
Infrastructure](https://help.ubuntu.com/community/UbuntuCloudInfrastructure)
