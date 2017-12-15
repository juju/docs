Title: Configuring Juju for offline usage
TODO:  for localhost cloud and controller being on the same host as the client, it's possible to use LXD remotely. worth mentioning?

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

These entities interact in the following way: the client is responsible for
creating the controller, and then manages the controller via the latter's API.
The controller, in turn, is responsible for accessing and passing all needed
resources to the machines. There are a few exceptions to this rule.

## Offline configuration methods

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
using standard model configuration methods. Juju has the following
offline-related model configuration options at its disposal:

 - `apt-ftp-proxy`
 - `apt-http-proxy`
 - `apt-https-proxy`
 - `apt-mirror`
 - `ftp-proxy`
 - `http-proxy`
 - `https-proxy`

Read [Configuring models][models-config] for details on how a model can be
configured.

## Network criteria

Here we examine what network access is needed to various internet-based
resources for the aforementioned three entities in order to satisfy base
requirements as well as requirements arising from local implementation
decisions. Each resource includes the method to overcome a lack of connectivity
in an offline environment.

### Internet-based resources

 - **cloud provider**  
   The **client** requires access to the backing cloud in order to create a
   controller. Most public clouds have a RESTful API that operates over TCP
   port 443. A special case is the localhost cloud, in which the client talks
   to the local LXD daemon.

 - [**http://cloud-images.ubuntu.com**][cloud-images]  
   Official Ubuntu cloud images.  
   
     - Required when using the localhost cloud, by the **client** in order to
       create a controller and by the **controller** when creating further
       machines.

     - The **machines** require access if they will themselves be hosting LXD
       containers.

 - [**https://streams.canonical.com**][streams]

     - Where Juju agents are stored online. It is therefore required by the
       **controller** in order to pass agents to the machines.  
     
     - Used to map Juju series to cloud images. Required by the **client** for
       all cloud providers. The exception is the MAAS cloud, which maintains
       its own registry of images.
   
 - [**http://archive.ubuntu.com**][ubuntu-archive]  
   The Ubuntu package archive. Required by the **controller** and the
   **machines**. Used for providing software needed to set up the controller
   (e.g. `juju-mongodb`) as well as package management (e.g. updates). In
   addition, charms deployed on the machines typically call for packages to be
   installed.
   
 - [**http://security.ubuntu.com**][security-archive]  
   Ubuntu security package updates. Recommended for the **controller** and
   the **machines**. All security updates eventually end up in the Ubuntu
   package archive via the '-updates' pocket.

 - [**https://jujucharms.com**][charm-store]  
   The Charm Store. Required by the **controller** so that charms can be
   deployed on the machines. The **client** only requires access if the
   [juju-gui charm][charm-store-juju-gui] is deployed on the controller (the
   default behaviour).  
   
 - **charm-specific resources**  
   Some charms require auxiliary site support (for pulling down resources).
   Popular sites include [https://ppa.launchpad.net][launchpad-ppa] and
   [https://github.com][github]. Therefore, the **machines** *may* need access
   to these.

The following table summarizes the above information. An **X** designates
either a hard requirement or a requirement based on local factors (see the
footnotes). Remember that when using the localhost cloud, the controller
resides on the same host as the client, in the form of a LXD container.

resource                                       | client | controller | machines
---------------------------------------------- | ------ | ---------- | --------
cloud provider                                 | X      |            |
[http://cloud-images.ubuntu.com][cloud-images] | X [1]  | X [4]      | X [5]
[https://streams.canonical.com][streams]       | X [2]  | X          |  
[http://archive.ubuntu.com][ubuntu-archive]    |        | X          | X
[http://security.ubuntu.com][security-archive] |        | X          | X
[https://jujucharms.com][charm-store]          | X [3]  | X          |  
charm-specific resources                       |        |            | X

[1]: Required for the localhost cloud only.

[2]: Not needed for the MAAS cloud provider.

[3]: Not needed if the `--no-gui` option is used with the `juju bootstrap`
command. See [The Juju GUI][controllers-gui].

[4]: Required for the localhost cloud only.

[5]: Required if the machines will host LXD containers.

!!! Note:
    The above table does not take into account the packaging needs (e.g.
    package updates) of the client host system.

### Controller creation
Once a controller is properly bootstrapped, from then the *client* needs access
to the controller's API (for 'lxd' this should likely not be via a proxy).

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

If restricted, local charms will be required (see
[Deploying charms offline][charms-offline-deploying]).

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
[anchor__http/s-proxy]: ./charms-offline-strategies.html#http/s-proxy
[anchor__cloud-images-mirror]: ./charms-offline-strategies.html#cloud-images-mirror
