Title: Using OpenStack with Juju
TODO:  Review required (use style from the other cloud pages)
       Enhance interactive credentials section

# Using OpenStack with Juju

Although Juju doesn't have baked-in knowledge of *your* OpenStack cloud, it
does know how such clouds work in general. We just need to provide some
information to add it to the list of known clouds.

## Image metadata

OpenStack requires access to images for its instances to use. If you have
chosen to use a private OpenStack cloud with Juju you will need to ensure that
images are set up. This is covered in
[Cloud image metadata][cloud-image-metadata]. 

## Adding an OpenStack Cloud

Use the interactive `add-cloud` command to add your OpenStack cloud to Juju's
list of clouds. You will need to supply a name you wish to call your cloud and
the unique API endpoint, the authentication type(s), and region information.

For the manual method of adding an OpenStack cloud, see below section
[Manually adding an OpenStack cloud][#clouds-openstack-manual].

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  vsphere

Select cloud type: openstack

Enter a name for your openstack cloud: mystack

Enter the API endpoint url for the cloud: https://openstack.example.com:35574/v3.0/

Auth Types
  access-key
  userpass

Select one or more auth types separated by commas: access-key,userpass

Enter region name: dev1

Enter the API endpoint url for the region: https://openstack-dev.example.com:35574/v3.0/

Enter another region? (Y/n): n

Cloud "mystack" successfully added
You may bootstrap with 'juju bootstrap mystack'
```

Note that it is possible to choose more than one authorisation method - just
separate the values with commas.

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud        Regions  Default          Type        Description
.
.
.
mystack            1  dev1             openstack
```

### Manually adding an OpenStack cloud

This section shows how to manually add an OpenStack cloud to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).
It also demonstrates how multiple authentication types can be allowed
(comma-separated).

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

```yaml
clouds:
    mystack:
      type: openstack
      auth-types: [access-key,userpass]
      regions:
        dev1:
          endpoint: https://openstack.example.com:35574/v3.0/
```

To add cloud 'mystack', assuming the configuration file is `mystack.yaml` in
the current directory, we would run:
  
```bash
juju add-cloud mystack mystack.yaml
```

## Gathering credential information

The credential information is found on your private or public OpenStack
account.

## Adding credentials

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

In order to access OpenStack, you will need to add credentials to Juju. This
can be done in one of three ways.

### Using the interactive method

Armed with the gathered information, you can add credentials with the command:

```bash
juju add-credential mystack
```

The command will interactively prompt you for the information needed for the
chosen cloud. For the authentication type, either 'access-key', 'userpass', or
'access-key,userpass' (i.e. both are allowed) can be selected.

Alternately, you can use these credentials with [Juju as a Service][jaas] where
you can deploy charms using a web GUI.

### Using a file

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential
information for any cloud. This information is then added to Juju by pointing
the `add-credential` command to the file:

```bash
juju add-credential myopenstack -f mycreds.yaml
```

See section [Adding credentials from a file][credentials-adding-from-file] for
guidance on what such a file looks like.

### Using environment variables

With OpenStack you have the option of adding credentials using the following
environment variables that may already be present (and set) on your client
system:

`OS_USERNAME`  
`OS_PASSWORD`  
`OS_TENANT_NAME`  
`OS_DOMAIN_NAME`

Add this credential information to Juju in this way:
  
```bash
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to
store them under.

On Linux systems, the file `$HOME/.novarc` may be used to define these
variables and is parsed by the above command as part of the scanning process.

For background information on this method read section
[Adding credentials from environment variables][credentials-adding-from-variables].

## Creating a controller

Once the image metadata has been gathered, either locally or via a registered
and running Simplestream service, check your OpenStack networks.  If there are
multiple possible networks available to the cloud, it is also necessary to
specify the network name or UUID for Juju to use to boot instances. Both the
network name and UUID can be retrieved with the following command:

```bash
openstack network list
```

Choose the network you want the instances to boot from.  You can use either the
network name or the UUID with the 'network' configuration option when
bootstrapping a new controller.

With the product-streams service running in your OpenStack Cloud, you are now
ready to create a Juju controller:

```bash
juju bootstrap <cloud> <controller name> --config network=<network_id>
```

or if the simplestream data is local:

```bash
juju bootstrap <cloud> <controller name> --metadata-source ~/simplestreams/images --config network=<network_id>
```

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[cloud-image-metadata]: ./howto-privatecloud.md
[credentials]: ./credentials.md
[#clouds-openstack-manual]: #manually-adding-an-openstack-cloud
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
[credentials-adding-from-variables]: ./credentials.md#adding-credentials-from-environment-variables
[credentials-adding-from-file]: ./credentials.md#adding-credentials-from-a-file
[jaas]: https://jujucharms.com/jaas
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
