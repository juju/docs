**Usage:** `juju add-cloud [options] <cloud name> <cloud definition file>`

**Summary:**

Adds a cloud definition to Juju.

**Options:**

`-f (= "")`

The path to a cloud definition file

`--replace (= false)`

Overwrite any existing cloud information for `<cloud name>`

**Details:**

Juju needs to know how to connect to clouds. A cloud definition describes a cloud's endpoints and authentication requirements. Each definition is stored and accessed later as .

If you are accessing a public cloud, running add-cloud unlikely to be necessary. Juju already contains definitions for the public cloud providers it supports.

add-cloud operates in two modes:

     juju add-cloud
      juju add-cloud <cloud name> <cloud definition file>
When invoked without arguments, add-cloud begins an interactive session designed for working with private clouds. The session will enable you to instruct Juju how to connect to your private cloud.

When is provided with , Juju stores that definition its internal cache directly after validating the contents.

If already exists in Juju's cache, then the `--replace` option is required.

A cloud definition file has the following YAML format:

clouds: # mandatory mycloud: # argument type: openstack # , see below auth-types: [ userpass ] regions:

           london:

              endpoint: https://london.mycloud.com:35574/v3.0/
for private clouds: - lxd - maas - manual - openstack - vsphere

for public clouds:

      - azure
      - cloudsigma
      - ec2
      - gce
      - joyent
      - oci
Examples:

       juju add-cloud
        juju add-cloud mycloud ~/mycloud.yaml
        juju add-cloud --replace mycloud ~/mycloud2.yaml
See also:

[clouds](https://discourse.jujucharms.com/t/command-clouds/1695)
