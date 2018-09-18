Title: Using LXD with Juju - advanced

# Using LXD with Juju - advanced

This page is dedicated to more advanced topics related to using LXD with Juju.
The main page is [Using LXD with Juju][clouds-lxd].

The topics presented here are:

 - Adding a remote LXD cloud

## Adding a remote LXD cloud

The traditional way of using LXD with Juju is by having both the Juju client
and the LXD daemon local to each other. However, since `v.2.5` Juju supports
connecting to a remote LXD daemon.

Use the interactive `add-cloud` command to add your LXD cloud to Juju's list
of clouds. You will need to supply a name you wish to call your cloud and the
unique LXD API endpoint.

For the manual method of adding a LXD cloud, see below section
[Manually adding a LXD cloud][#clouds-lxd-manual].

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types

  lxd
  maas
  manual
  oci
  openstack
  oracle
  vsphere

Select cloud type: lxd

Enter a name for your lxd cloud: lxd-remote

Enter the API endpoint url for the remote LXD server: https://10.55.60.244:8443                                                                                                   
Auth Types
  certificate

Select one or more auth types separated by commas [certificate]: 

Enter region [default]: 

Enter the API endpoint url for the region [use cloud api url]: 

Enter another region? (y/N): n

Cloud "lxd-remote" successfully added

You may need to `juju add-credential lxd-remote' if your cloud needs additional credentials
Then you can bootstrap with 'juju bootstrap lxd-remote'
```

!!! Important:
    The remote LXD server needs to be available over the network. This is
    specified with `lxd init` on the remote host.

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
lxd-remote         1  default          lxd         LXD Container Hypervisor
```

### Manually adding a LXD cloud

This covers manually adding a LXD cloud to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

```yaml
clouds:
  lxd-remote-manual:
    type: lxd
    auth-types: [certificate]
    endpoint: 10.55.60.244
```

<--! test if 'interactive' is required in the above -->

We've call the cloud 'lxd-remote-manual' and the endpoint is the IP address of
the remote LXD host.

To add cloud 'lxd-remote-manual', assuming the configuration file is
`lxd-cloud.yaml` in the current directory, we would run:

```bash
juju add-cloud lxd-remote-manual lxd-cloud.yaml
```

## Adding credentials

As opposed to a local LXD cloud, credentials need to be added prior to creating
a controller for a remote one.

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

Use the interactive `add-credential` command to add your credentials to the new
cloud. The 'certificate' auth type requires you to gather the LXD server
certificate and both the LXD client certificate and key. The client in this
context is Juju.

```bash
juju add-credential lxd-remote
```

Example user session:

```no-highlight
Enter credential name: lxd-remote-creds-cert

Auth Types
  certificate
  interactive

Select auth type [interactive]: certificate

Enter the path to the PEM-encoded LXD server certificate file: server.crt

Enter the path to the PEM-encoded LXD client certificate file: .local/share/juju/lxd/client.crt                                                                                   
Enter the path to the PEM-encoded LXD client key file: .local/share/juju/lxd/client.key                                                                                           
Credential "lxd-remote-creds-cert" added locally for cloud "lxd-remote".
```

We've called the new credential 'lxd-remote-creds'. When prompted for
'', you should paste your MAAS API key.

!!! Note:
    The API key will not be echoed back to the screen.

<!-- LINKS -->

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[clouds-lxd]: ./clouds-LXD
[#clouds-lxd-manual]: #manually-adding-a-lxd-cloud
[controllers-creating]: ./controllers-creating.md
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
[credentials]: ./credentials.md
