<!--
Todo:
- Review required (use style from the other cloud pages)
- Enhance interactive credentials section
-->

Working with your OpenStack cloud is easy. 

- Provide Juju with knowledge of your OpenStack cloud, such as its IP address.
- Add your access credentials
- Create a controller

This page takes you those three steps. It also provides some extra information that's specific to enabling OpenStack to work well with Juju. For example, every OpenStack cloud defines its own instance types.

<h2 id="heading--adding-an-openstack-cloud">Adding an OpenStack Cloud</h2>

The `juju add-cloud` command defines a cloud for Juju. It's useful to have OpenStack environment variables defined running it. Assuming that you have a "novarc" file available to you, use `source` (or the equivalent command `call` on MS Windows ) to load the variables into your environment. 

```plain
source /path/to/novarc
```

### ...via an interactive prompt 

Use the `add-cloud` command to interactively add your OpenStack cloud to Juju's list of clouds. You will need to supply a name you wish to call your cloud and the unique API endpoint, the authentication type(s), and region information.

```text
juju add-cloud --local
```

Here is an example interactive session:

``` text
Cloud Types
  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: openstack

Enter a name for your openstack cloud: myopenstack

Enter the API endpoint url for the cloud [https://x.x.x.x:5000/v3]:

Enter the filename of the CA certificate to access OpenStack cloud (optional) [/home/ubuntu/cacert.pem]:

Auth Types
  access-key
  userpass

Select one or more auth types separated by commas: userpass

Enter region name: dev1

Enter the API endpoint url for the region [use cloud api url]:

Enter another region? (Y/n): n

Successfully read CA Certificate from /home/ubuntu/test_certs/cacert.pem
Cloud "myopenstack" successfully added

You will need to add credentials for this cloud (`juju add-credential myopenstack`)
before creating a controller (`juju bootstrap myopenstack`).
```

`juju add-cloud` command pre-populates the defaults with the following environment variables.

- `OS_AUTH_URL` becomes the default API endpoint URL
- `OS_CACERT` becomes the default path to the CA certificate file
- `OS_REGION_NAME` becomes the default refion name

It is possible to choose more than one authorisation method - just separate the values with commas.

<h3 id="heading--manually-adding-an-openstack-cloud">..via a cloud definition file</h3>

This section shows how to manually add an OpenStack cloud to Juju (see [Adding clouds manually](/t/clouds/1100#heading--adding-clouds-manually) for background information). It also demonstrates how multiple authentication types can be allowed.

The manual method necessitates the use of a [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) configuration file. Here is an example:

``` yaml
clouds:
    mystack:
      type: openstack
      auth-types: [access-key,userpass]
      regions:
        dev1:
          endpoint: https://openstack.example.com:35574/v3.0/
```

Adding a cloud manually can be done locally or, since `v.2.6.0`, remotely (on a controller). Here, we'll show how to do it locally (client cache).

To add cloud 'mystack', assuming the configuration file is `mystack.yaml` in the current directory, we would run:

```text
juju add-cloud --local mystack mystack.yaml
```

[note]
In versions prior to `v.2.6.0` the `add-cloud` command only operates locally (there is no `--local` option).
[/note]

<h2 id="heading--gathering-credential-information">Gathering credential information</h2>

The credential information is found on your private or public OpenStack account.

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Credentials](/t/credentials/1112) page offers a full treatment of credential management.

In order to access OpenStack, you will need to add credentials to Juju. This can be done in one of three ways.

<h3 id="heading--using-the-interactive-method">Using the interactive method</h3>

Armed with the gathered information, you can add credentials with the command:

``` text
juju add-credential mystack
```

The command will interactively prompt you for the information needed for the chosen cloud. For the authentication type, either 'access-key', 'userpass', or 'access-key,userpass' (i.e. both are allowed) can be selected.

Alternately, you can use these credentials with [Juju as a Service](https://jujucharms.com/jaas) where you can deploy charms using a web GUI.

<h3 id="heading--using-a-file">Using a file</h3>

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential information for any cloud. This information is then added to Juju by pointing the `add-credential` command to the file:

``` text
juju add-credential myopenstack -f mycreds.yaml
```

See section [Adding credentials from a file](/t/credentials/1112#heading--adding-credentials-from-a-file) for guidance on what such a file looks like.

<h3 id="heading--using-environment-variables">Using environment variables</h3>

With OpenStack you have the option of adding credentials using the following environment variables that may already be present (and set) on your client system:

`OS_USERNAME`
`OS_PASSWORD`
`OS_TENANT_NAME`
`OS_DOMAIN_NAME`

Add this credential information to Juju in this way:

``` text
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to store them under.

On Linux systems, the file `$HOME/.novarc` may be used to define these variables and is parsed by the above command as part of the scanning process.

For background information on this method read section [Adding credentials from environment variables](/t/credentials/1112#heading--adding-credentials-from-environment-variables).

<h2 id="heading--creating-a-controller">Creating a controller</h2>

For many Openstack installations, you should now be in a position to create the controller.  At a command line prompt, use the `juju bootstrap`. This provisions a instance on your OpenStack cloud and installs the Juju controller within it.

```text
juju bootstrap <cloud> <controller-name>
```

This operation may fail with some installations and require more configuration. Here are some tips for two scenarios that

<h3 id="heading--images-and-private-clouds">Images and private clouds</h3>

OpenStack requires access to images to provision instances. Configuring this correctly is covered on the [Cloud image metadata](/t/cloud-image-metadata/1137) page.

If your image metadata is available locally, the `--metadata-source` option is available to you.

``` text
juju bootstrap <cloud> <controller name> \
               --metadata-source /path/to/simplestream/images
```

<h3 id="multiple-networks">Working with multiple networks</h2>

If there are multiple networks available, you will need to specify the intended network. Check your OpenStack networks with the `openstack` command:

``` text
openstack network list
```

Providing the preferred network's name or Choose the network you want the instances to boot from. <!-- How? --> You can use either the network name or the UUID with the 'network' configuration option when bootstrapping a new controller.

``` text
juju bootstrap <cloud> <controller-name> \
               --model-default network=<network-id>
```

If there is an external network configured for instances that are only accessible via floating IP, add the `use-floating-up` configuration option:

``` text
juju bootstrap <cloud> <controller-name> \
               --model-default network=<network-id> \
               --model-default external-network=<external-network-id> \
               --model-default use-floating-ip=true
```

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

## OpenStack-specific features

`v.2.6.4` provides a new constraint: ‘root-disk-source’. Specifying the string `volume` tells Juju to use Cinder block storage volumes that will be used to create instances' root disks:

```text
juju deploy myapp --constraints root-disk-source=volume
```

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
