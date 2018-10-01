Title: Using LXD with Juju - advanced
TODO:  bug tracking: https://bugs.launchpad.net/juju/+bug/1793661
       bug tracking: https://bugs.launchpad.net/juju/+bug/1793693

# Using LXD with Juju - advanced

This page is dedicated to more advanced topics related to using LXD with Juju.
The main page is [Using LXD with Juju][clouds-lxd].

The topics presented here are:

 - Adding a remote LXD cloud

## Adding a remote LXD cloud

The traditional way of using LXD with Juju is by having both the Juju client
and the LXD daemon local to each other. However, since `v.2.5` Juju supports
connecting to a remote LXD daemon. Doing so does not require LXD to be
installed alongside the Juju client.

Use the `add-cloud` command in interactive mode to add a LXD cloud to Juju's
list of clouds. You will need to supply the name you wish to call your cloud
and the unique LXD API endpoint.

For the manual method of adding a LXD cloud, see below section
[Manually adding a remote LXD cloud][#clouds-lxd-remote-add-manual].

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
    The remote LXD server needs to be available over the network and is
    specified with `lxd init` on the remote host. Networking is enabled
    automatically when clustering is chosen.

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

#### Manually adding a remote LXD cloud

Alternatively, the remote LXD cloud can be added manually to Juju (see
[Adding clouds manually][clouds-adding-manually] for background information).

The manual method necessitates the use of a [YAML-formatted][yaml]
configuration file. Here is an example:

```yaml
clouds:
  lxd-remote-manual:
    type: lxd
    auth-types: [certificate]
    endpoint: https://10.55.60.244:8443
```

We've called the cloud 'lxd-remote-manual'. The endpoint is based on the
`HTTPS` protocoal, port 8443, and the IP address of the remote LXD host.

To add cloud 'lxd-remote-manual', assuming the configuration file is
`lxd-cloud.yaml` in the current directory, we would run:

```bash
juju add-cloud lxd-remote-manual lxd-cloud.yaml
```

### Adding credentials

As opposed to a local LXD cloud, in a remote context, credentials need to be
added prior to creating a controller (see [Cloud credentials][credentials] for
background information).

Use the `add-credential` command to add credentials to the new cloud:

```bash
juju add-credential lxd-remote
```

```no-highlight
Enter credential name: lxd-remote-creds

Auth Types
  certificate
  interactive

Select auth type [interactive]: 

Enter trust-password: *******

Loaded client cert/key from "/home/ubuntu/.local/share/juju/lxd"
Uploaded certificate to LXD server.

Credential "lxd-remote-creds" added locally for cloud "lxd-remote".
```

We've called the new credential 'lxd-remote-creds'. When prompted for
'trust-password', enter the password that was set up with `lxd init` on the
remote LXD host.

!!! Note:
    If the 'certificate' authentication type is chosen in place of
    'interactive' the server and client certificates and the client key will
    need to be gathered manually. You will be prompted for the paths to the
    three files containing the data.

#### Manually adding LXD credentials

Like adding a cloud manually, a YAML file is needed to manually add
credentials. Here is an example:

```yaml
credentials:
  lxd-remote:
    lxd-remote-creds:
      auth-type: interactive
      trust-password: ubuntu
```

Here, we've named the credential as we did when using the interactive method:
'lxd-remote-creds'. The trust password is set as 'ubuntu'.

To add credentials for cloud 'lxd-remote', assuming the configuration file is
`lxd-cloud-creds.yaml` in the current directory, we would run:

```bash
juju add-credential lxd-remote -f lxd-cloud-creds.yaml
```

### Next steps

Now that the cloud and credentials have been added the next step is to create a
controller. See [Creating a controller][clouds-lxd-creating-a-controller] on
the main LXD page.


<!-- LINKS -->

[yaml]: http://www.yaml.org/spec/1.2/spec.html
[clouds-lxd]: ./clouds-LXD
[#clouds-lxd-remote-add-manual]: #manually-adding-a-remote-lxd-cloud
[controllers-creating]: ./controllers-creating.md
[clouds-adding-manually]: ./clouds.md#adding-clouds-manually
[credentials]: ./credentials.md
[clouds-lxd-creating-a-controller]: ./clouds-LXD.md#creating-a-controller
