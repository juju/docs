Title: Configuring Juju for offline usage

# Configuring Juju for offline usage

*This page makes use of information presented in the
[Offline mode strategies][charms-offline-strategies] document. Please see that
page for a full understanding.*

There are three Juju entities to take into account when configuring Juju in a
network-restricted environment. Each one of these may require specific
treatment depending on the backing cloud type and in what manner the local
network is restricted. These are:

 - client
 - controller
 - machines

Where the *client* is the Juju client from whence `juju` commands are invoked;
the *controller* is the Juju machine acting as controller; and the *machines*
are the Juju machines that get created during charm deployment.

## Configuration methods

The **client** is made aware of proxy settings via the shell that it is running
under (e.g. Bash). This is done by exporting the relevant environment
variables:

 - `http_proxy`
 - `https_proxy`
 - `no_proxy`

The **controller** is a Juju machine that typically consumes proxy settings 
during its creation.

The **machines** are configured for proxies indirectly via their model. This
can be done during controller creation but it can equally be done post-creation
using standard model configuration methods.

Juju has the following offline-related model configuration options at its
disposal:

 - `apt-ftp-proxy`
 - `apt-http-proxy`
 - `apt-https-proxy`
 - `apt-mirror`
 - `ftp-proxy`
 - `http-proxy`
 - `https-proxy`

Read [Configuring models][models-config] for details on how a model can be
configured.

## Juju resources

Here is a lit of internet-based resources that Juju should have access to,
whether via a proxy or a local resource.

 - cloud provider  
   The **client** requires access to the backing cloud in order to create a
   controller. Most public clouds have a RESTful API that operates over TCP
   port 443. A special case is the localhost cloud, in which the client talks
   to the local LXD daemon.

 - [http://cloud-images.ubuntu.com](http://cloud-images.ubuntu.com)  
   Official Ubuntu cloud images. Required for the **client** when using the
   localhost cloud.

 - [https://streams.canonical.com](https://streams.canonical.com)  
     - Where Juju agents are stored online. It is therefore required by the
       **controller** in order to pass agents to the machines.  
     
     - Used to map Juju series to cloud images. The exception is the MAAS
       cloud, which maintains its own registry of images.
   
 - [http://archive.ubuntu.com](http://archive.ubuntu.com)  
   The Ubuntu package archive. Required for every Juju machine, including the
   controller. Used for package management (e.g. updates). Charms deployed on
   the machines typically call for packages to install.
   
 - [http://security.ubuntu.com](http://security.ubuntu.com)  
   Ubuntu security package updates. Recommended for every Juju machine. All
   security updates eventually end up in the Ubuntu package archive ('-updates'
   pocket).

 - [https://jujucharms.com](https://jujucharms.com)  
   The Charm Store. Required for the **controller** so that charms can be
   deployed on the machines. The **client** *may* require access if the
   [juju-gui charm][charm-store-juju-gui] is deployed on the controller (the
   default behaviour). Otherwise, local charms will be required (see
   [Deploying charms offline][charms-offline-deploying]).

 - charm-specific resources  
   Some charms require auxiliary site support (for pulling down resources).
   Popular sites include [https://ppa.launchpad.net][launchpad-ppa] and
   [https://github.com][github]. Therefore, the **machines** *may* need access
   to these.

resource                                       | client | controller | machines
---------------------------------------------- | ------ | ---------- | --------
cloud provider                                 | X      |            |
[http://cloud-images.ubuntu.com][cloud-images] | X [1]  | X          | X [4]
[https://streams.canonical.com][streams]       | X      | X          |  
[http://archive.ubuntu.com][ubuntu-archive]    |        | X          | X
[http://security.ubuntu.com][security-archive] |        | X          | X
[https://jujucharms.com][charm-store]          | X [3]  | X          |  
charm-specific resources                       |        |            | X

[1]: Required for localhost cloud only.

[3]: Not needed if the `--no-gui` option is used with the `juju bootstrap`
command. See [The Juju GUI][controllers-gui].

[4]: Required if the machine will host LXD containers.

!!! Note:
    The above table does not take into account the packaging needs of the Juju
    client host system (e.g. package updates).
    
## Network criteria

Here we set out what actual network connectivity is required for the different
stages of setting up a cloud environment with Juju.

A special case arises when the localhost cloud (LXD) is
employed. In such a context, the controller 

### Controller creation

When creating a controller the client is
responsible for setting up a new machine within the backing cloud.
Thus the client needs access to both. Once the new machine has been provisioned, it is only the *controller*
(and the LXD agent) that needs access to those locations. Once a controller is
properly bootstrapped, from then the *client* needs access to the controller's
API (for 'lxd' this should likely not be via a proxy).

For bootstrap, we need access to the cloud provider (in the case of LXD this is
your LXD daemon listening on the LXD bridge). We'll also likely need access to
https://streams.canonical.com unless you're planning on using a local jujud
agent binary. (Typically we download it from streams.canonical.com to be sure
we can get updates and support more than just one architecture or series.) We
also use streams in order to map OS series into images for the cloud.

We'll also likely need access to archive.ubuntu.com and security.ubuntu.com, in
order to ensure your packages are up-to-date. We also need access to packages
like juju-mongodb3.2 on the bootstrapped machine.
If you have a different archive to use, its possible to set apt mirrors, etc.
And you can also set up alternative locations to download agent binaries
(agent-metadata-url). And you may want a different location to find images for
your cloud (image-metadata-url).

The controller itself may need proxy information to retrieve various
packages. This is configured with --config options during bootstrap.

Models may also need this proxy information if charms deployed in those models
require external network access (for example, access to pypi to install
requisite pip packages). This is configured with --model-default options during
bootstrap.

## Using the localhost cloud (LXD) offline

Begin by defining the HTTP and HTTPS proxies. In this example they happen to be
the same:

```bash
export http_proxy=http://squid.internal:3128
export https_proxy=http://squid.internal:3128
```

Next, we employ a slightly ingenious method to define the destinations that
must *not* use the above proxies:

```bash
export no_proxy=$(echo localhost 127.0.0.1 10.245.67.130 10.44.139.{1..255} | sed 's/ /,/g')
```

set the proxy for both the controller you are about to create, and for the
client that you are running. You're also likely to need to set 'no-proxy' to
appropriate values so that you can still contact things like the LXD agent
running on your host machine.

?????? where X.Y is the IP address that was assigned to your LXD bridge. 

Finally, apply these settings during the controller-creation process:

```bash
juju bootstrap \
--model-default http-proxy=$http_proxy \
--model-default https-proxy=$https_proxy \
--model-default no-proxy=$no_proxy \
localhost lxd
```

## no proxy for localhost, our eth0 ip address, and our lxd subnet
https://bugs.launchpad.net/juju/+bug/1730617

<!-- LINKS -->

[charms-offline-deploying]: ./charms-offline-deploying.html
[charms-offline-strategies]: ./charms-offline-strategies.html
[models-config]: ./models-config.html
[cloud-images]: http://cloud-images.ubuntu.com
[streams]: https://streams.canonical.com
[ubuntu-archive]: http://archive.ubuntu.com
[security-archive]: http://security.ubuntu.com
[charm-store]: https://jujucharms.com
[charm-store-juju-gui]: https://jujucharms.com/u/juju-gui/juju-gui
[controllers-gui]:  controllers-gui.html
[github]: https://github.com
[launchpad-ppa]: https://ppa.launchpad.net
