Title: OpenStack clouds

# OpenStack Clouds

Although Juju doesn't have baked-in knowledge of *your* OpenStack cloud, it
does know how such clouds work in general. We just need to provide some
information to add it to the list of known clouds.

## Adding an OpenStack Cloud

Using the Juju `add-cloud` command, it is easy to add your OpenStack clouds to
Juju's list of known clouds. The command is interactive, and will ask for
a name,endpoint,authorisation method(s) and regions to use. A sample session
is shown below.

Running...

```bash
juju add-cloud
```
...will enter the interactive mode. Enter the desired values to continue.

!!! Note:
To use the authentication from OpenStack, find the URL in your novarc the
`AUTH_URL` value and use `userpass` as the authentication type.

```
Cloud Types
 maas
 manual
 openstack
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
```

Note that it is possible to choose more than one authorisation method - just
separate the values with commas.

Once the cloud has been added, it will appear on the list of known clouds
output by the `juju clouds` command. Note that the cloud name will be
highlighted to indicate that it is a locally added cloud.

!["juju cloud with locally added cloud"](./media/list-clouds-local.png)

It is also possible to define OpenStack clouds in a YAML formatted configuration
file and register them with Juju. Please see the
[documentation for manually adding Openstack clouds][manual-openstack] for details.

## Adding credentials

If you source a novarc file for OpenStack, or use the default environmental
variables for accessing this cloud, you can simply get Juju to scan for the
credentials and add them.

Run the command...

```bash
juju autoload-credentials
```

Juju will search known locations, including environment variables, for
credential information and present you with a set of choices for storing them.
Simply follow the prompts.

For other methods of adding credentials, please see the specific
[credentials documentation][credentials].



## Images and private clouds

The above steps are all you need to use most OpenStack clouds which are
configured for general use. If this is your own cloud, you will also need to
additionally provide stream information so that the cloud can fetch the
relevant images for Juju to use. This is covered in the section on
[private clouds][simplestreams].

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[simplestreams]: ./howto-privatecloud.html
[credentials]: ./credentials.html
[manual-openstack]: ./clouds-openstack-manual.html
