This page is dedicated to more advanced topics related to using LXD with Juju. The main page is [Using LXD with Juju](/t/using-lxd-with-juju/1093).

The topics presented here are:

- Add resilience to your models through LXD clustering
- Registering a remote LXD server as a LXD cloud
- Charms and LXD profiles

<h2 id="heading--lxd-clustering">Add resilience to your models through LXD clustering</h2>

LXD clustering provides the ability for applications to be deployed in a high-availability manner. In a clustered LXD cloud, Juju will deploy units across its nodes.

### Background

LXD clustering provides increased resilience in two senses for teams using Juju:

- first, the LXD cloud itself is not exposed to a single point of failure
- secondly, your model can be distributed across each node within the cluster. This can add resilience to individual applications that are deployed with multiple units

### Forming a LXD cluster

The documentation provided by the LXD project explains the process of [forming a LXD cluster](https://lxd.readthedocs.io/en/latest/clustering/).

A helpful tutorial video has also been provided by project lead [Stéphane Graber](https://www.youtube.com/channel/UCx1shw99U0qRyPKIiuOkjmA):

<iframe width="560" height="315" src="https://www.youtube.com/embed/RnBu7t2wD4U" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### Making use of a LXD cluster

From Juju's point of view, a LXD cluster is a "remote LXD server". Follow the instructions in the next section to register the cluster with Juju. 

## Registering a remote LXD server as a LXD cloud

Two commands enable you to register your LXD server with Juju as a cloud:

- `juju add-cloud` provides the connectivity details to enable Juju to connect to the LXD server 
- `juju add-credential` provides the security credentials for Juju to use when connected

#### Adding the cloud

**Option 1: Interactively**

To add the remote LXD information to Juju, run `juju add-cloud` without arguments and follow the prompts:

``` text
juju add-cloud
```

An example session:

``` text
Cloud Types

  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: lxd

Enter a name for your lxd cloud: lxd-remote

Enter the API endpoint url for the remote LXD server: https://10.10.0.1:8443
Auth Types
  certificate

Enter region [default]: 

Enter the API endpoint url for the region [use cloud api url]: 

Enter another region? (y/N): n

Cloud "lxd-remote" successfully added

You will need to add credentials for this cloud (`juju add-credential lxd-remote`)
before creating a controller (`juju bootstrap lxd-remote`).
```

**Option 2: Provide the cloud metadata via a file**

Save the contents of the following YAML fragment to a file (`/tmp/clouds.yaml`), making the appropriate changes.

```yaml
# clouds.yaml

clouds:
  lxd-cluster: # replace lxd-remote with your preferred name
    type: lxd
    auth-types: [interactive, certificate]
    endpoint: https://10.10.0.1:8443/  # replace with the actual endpoint
```

Run `juju add-cloud`, specifying the correct cloud name and path to your new clouds.yaml:  

```bash
juju add-cloud lxd-remote /tmp/clouds.yaml
``` 

#### Adding the security credential

**Option 1: Interactively**

To add the remote LXD information to Juju, run `juju add-cloud` without arguments and follow the prompts:

``` text
juju add-credential
```

An example session:

``` text
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


**Option 2: Provide the credential via a file**

Save the contents of the following YAML fragment to a file (`/tmp/credentials.yaml`), making the appropriate changes.

```yaml
# credentials.yaml

credentials:
    lxd-remote:  # this name must match the name in clouds.yaml
        admin:
            auth-type: interactive
            trust-password: DL7UXEd8tsTF3Tc # replace with actual password
```

Run `juju add-credential`, specifying the correct cloud name and path to your new clouds.yaml:  

```bash
juju add-credential lxd-remote -f /tmp/clouds.yaml
``` 

<!--
In terms of adding a LXD cloud, Juju is indifferent as to whether it is clustered or not. Juju connects to a single LXD host and, when prompted for connection information, you will need to decide which host that is. It should be noted that if this host becomes unavailable Juju will lose connection to the entire cluster.

[note type="caution"]
Each cluster node must have a network bridge that is connected to LXD. This is to allow the client to communicate with the Juju machines (containers).
[/note]

Clustering is configured by running `lxd init` on each LXD host (a minimum of three is recommended). The first host that does so will *initialise* the cluster and any subsequent node will *join* the cluster. When joining, `sudo` is required.

Once the cluster is set up a controller can be created and will end up randomly on one of the nodes. Since `v.2.5.0`, however, specific cluster nodes can be targeted. See [Deploying to specific machines](/t/deploying-applications-advanced/1061#heading--deploying-to-specific-machines) for how to do this.

[note type="caution"]
The cluster-creation process will remove any existing containers. In a Juju context, this implies that you must initialise the cluster *before* creating a controller.
[/note]

See the upstream documentation on [Clustering](https://lxd.readthedocs.io/en/latest/clustering/).


<h2 id="heading--adding-a-remote-lxd-cloud">Adding a remote LXD cloud</h2>

The traditional way of using LXD with Juju is by having both the Juju client and the LXD daemon local to each other. However, since `v.2.5.0` Juju supports connecting to a remote LXD daemon. Doing so does not require LXD to be installed alongside the Juju client.

Use the `add-cloud` command in interactive mode to add a LXD cloud to Juju's list of clouds. You will need to supply the name you wish to call your cloud and the unique LXD API endpoint.

For the manual method of adding a LXD cloud, see below section [Manually adding a remote LXD cloud](#heading--manually-adding-a-remote-lxd-cloud).

To interactively add a cloud definition to the local client cache:

``` text
juju add-cloud
```

Example user session:

``` text
Cloud Types

  lxd
  maas
  manual
  openstack
  vsphere

Select cloud type: lxd

Enter a name for your lxd cloud: lxd-remote

Enter the API endpoint url for the remote LXD server: https://10.55.60.244:8443
Auth Types
  certificate

Enter region [default]: 

Enter the API endpoint url for the region [use cloud api url]: 

Enter another region? (y/N): n

Cloud "lxd-remote" successfully added

You will need to add credentials for this cloud (`juju add-credential lxd-remote`)
before creating a controller (`juju bootstrap lxd-remote`).
```

[note type="caution"]
The remote LXD server needs to be available over the network and is specified with `lxd init` on the remote host. Networking is enabled automatically when clustering is chosen.
[/note]

Confirm the addition of the cloud with the `clouds --local` command (just `clouds` on versions prior to `v.2.6.0`).

<h4 id="heading--manually-adding-a-remote-lxd-cloud">Manually adding a remote LXD cloud</h4>

Alternatively, the remote LXD cloud can be added manually to Juju (see [Adding clouds manually](/t/clouds/1100#heading--adding-clouds-manually) for background information).

The manual method necessitates the use of a [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) configuration file. Here is an example:

``` yaml
clouds:
  lxd-remote-manual:
    type: lxd
    auth-types: [certificate]
    endpoint: https://10.55.60.244:8443
```

Adding a cloud manually can be done locally or, since `v.2.6.0`, remotely (on a controller). Here, we'll show how to do it locally (client cache).

We've called the cloud 'lxd-remote-manual'. The endpoint is based on the `HTTPS` protocol, port 8443, and the IP address of the remote LXD host.

To add cloud 'lxd-remote-manual', assuming the configuration file is `lxd-cloud.yaml` in the current directory, we would run:

``` text
juju add-cloud --local lxd-remote-manual lxd-cloud.yaml
```

[note]
In versions prior to `v.2.6.0` the `add-cloud` command only operates locally (there is no `--local` option).
[/note]

<h3 id="heading--adding-credentials">Adding credentials</h3>

As opposed to a local LXD cloud, in a remote context, credentials need to be added prior to creating a controller (see [Credentials](/t/credentials/1112) for background information).

Use the `add-credential` command to add credentials to the new cloud:

``` text
juju add-credential lxd-remote
```

``` text
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

We've called the new credential 'lxd-remote-creds'. When prompted for 'trust-password', enter the password that was set up with `lxd init` on the remote LXD host.

[note]
If the 'certificate' authentication type is chosen in place of 'interactive' the server and client certificates and the client key will need to be gathered manually. You will be prompted for the paths to the three files containing the data.
[/note]

<h4 id="heading--manually-adding-lxd-credentials">Manually adding LXD credentials</h4>

Like adding a cloud manually, a YAML file is needed to manually add credentials. Here is an example:

``` yaml
credentials:
  lxd-remote:
    lxd-remote-creds:
      auth-type: interactive
      trust-password: ubuntu
```

Here, we've named the credential as we did when using the interactive method: 'lxd-remote-creds'. The trust password is set as 'ubuntu'.

To add credentials for cloud 'lxd-remote', assuming the configuration file is `lxd-cloud-creds.yaml` in the current directory, we would run:

``` text
juju add-credential lxd-remote -f lxd-cloud-creds.yaml
```

-->

<h3 id="heading--next-steps">Next steps</h3>

Now that the cloud and credentials have been added the next step is to create a controller. See [Creating a controller](/t/using-lxd-with-juju/1093#heading--creating-a-controller) on the main LXD page.

<h2 id="heading--charms-and-lxd-profiles">Charms and LXD profiles</h2>

Juju (`v.2.5.0`) supports LXD profiles for charms. This is implemented by including file `lxd-profile.yaml` in a  charm's root directory. For example, here is a simple two-line file (this is taken from the [Openvswitch](https://jaas.ai/neutron-openvswitch) charm):

```yaml
config:
  linux.kernel_modules: openvswitch,ip_tables,ip6_tables
```

The profile will be applied to a LXD container that the charm is deployed into. The following functionality is built in:

- A validity check is performed on the profile(s) during the deployment of the charm. This is based on a hardcoded list of allowed items, everything else being denied. The `--force` option can be used to bypass this check but this is not recommended. The list is:

```text
config
   -boot
   -limits
   -migration

devices
   unix-char
   unix-block
   gpu
   usb
```

- Profiles are upgraded during the upgrade of the charm (`juju upgrade-charm`).
- Profiles are displayed at the machine level by using either the `show-machine` command or the `status --format=yaml` command. Below is an example of the kind of information that can be obtained from either of these two commands:

```text
   lxd-profiles:
      juju-default-lxd-profile-0:
        config:
          environment.http_proxy: ""
          linux.kernel_modules: openvswitch,nbd,ip_tables,ip6_tables
          security.nesting: "true"
          security.privileged: "true"
        description: lxd profile for testing, black list items grouped commented out
        devices:
          bdisk:
            source: /dev/loop0
            type: unix-block
          sony:
            productid: 51da
            type: usb
            vendorid: 0fce
          tun:
            path: /dev/net/tun
            type: unix-char
```

See the LXD documentation to learn about the valid [profile configuration options](https://lxd.readthedocs.io/en/latest/containers/).
