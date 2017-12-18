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
are the Juju workload machines that get created during charm deployment.

These entities interact in the following way: the client is responsible for
creating the controller, and then manages the controller via the latter's API.
The controller, in turn, is responsible for accessing and passing all needed
resources to the machines.

There are a few exceptions to the above rule. When creating a controller the
client needs to both access and then transfer both the 'juju-gui' charm and the
Juju agent to the controller.

## Network criteria

Here we examine what network access is needed to various internet-based
resources for the aforementioned three entities in order to satisfy base
requirements as well as requirements arising from local implementation
decisions.

Any unsatisfied network criteria will need to be overcome by a combination of
new local services (see [Offline mode strategies][charms-offline-strategies])
and the appropriate Juju configuration changes (covered
[below][anchor__offline-configuration-methods]).

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
       **client** in order to pass an agent to the newly-created controller and
       then later required by the **controller** itself in order to pass agents
       to any subsequently-created machines.  
     
     - Used to map Juju series to cloud images. Required by the **client** for
       all cloud providers. The exception is the MAAS cloud, which maintains
       its own registry of images.
   
 - [**http://archive.ubuntu.com**][ubuntu-archive]  
   The Ubuntu package archive.  
   
    Required by the **controller** and the **machines**. Used for providing
   software needed to set up the controller (e.g. `juju-mongodb`) as well as
   package management (e.g. updates). In addition, charms deployed on the
   machines typically call for packages to be installed.
   
 - [**http://security.ubuntu.com**][security-archive]  
   Ubuntu security package updates.  
   
    Recommended for the **controller** and the **machines**. Note that all
   security updates eventually end up in the Ubuntu package archive via the
   '-updates' pocket.

 - [**https://jujucharms.com**][charm-store]  
   The Charm Store. Required by the **controller** so that charms can be
   deployed on the machines. The **client** only requires access if the
   [juju-gui charm][charm-store-juju-gui] is deployed on the controller (the
   default behaviour).  
   
    See [Deploying charms offline][charms-offline-deploying] for how to manage
   charms locally.  
   
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
[http://cloud-images.ubuntu.com][cloud-images] | X [1]  | X [3]      | X [4]
[https://streams.canonical.com][streams]       | X      | X          |  
[http://archive.ubuntu.com][ubuntu-archive]    |        | X          | X
[http://security.ubuntu.com][security-archive] |        | X          | X
[https://jujucharms.com][charm-store]          | X [2]  | X          |  
charm-specific resources                       |        |            | X

[1]: Required for the localhost cloud only.

[2]: Not needed if the `--no-gui` option is used with the `juju bootstrap`
command. See [The Juju GUI][controllers-gui].

[3]: Required for the localhost cloud only.

[4]: Required if the machines will host LXD containers.

!!! Note:
    The above table does not take into account the packaging needs (e.g.
    package updates) of the client host system.

## Offline configuration methods

The **client** is made aware of proxy settings via the shell that it is running
under (e.g. Bash). This is done by exporting the relevant environment
variables:

 - `http_proxy`
 - `https_proxy`
 - `no_proxy`

Both the **controller** and the **machines** are configured at the model level,
therefore both these entities can be configured together. Keep in mind,
however, that the controller is configured via the 'controller' model and the
machines are configured via whatever model that will eventually contain them.
This information is passed during the controller creation process since the
controller needs to download Ubuntu packages in order to provision itself.

Juju has the following offline-related model configuration settings at its
disposal:

 - `agent-metadata-url`
 - `apt-ftp-proxy`
 - `apt-http-proxy`
 - `apt-https-proxy`
 - `apt-mirror`
 - `ftp-proxy`
 - `http-proxy`
 - `https-proxy`
 - `image-metadata-url`

The method for configuring models while using the `bootstrap` command is done
with either the `--config` option or the `--model-default` option. The latter
is a more powerful choice since it applies to all existing and future models
whereas `--config` only affects the 'controller' and 'default' models.

Read [Configuring models][models-config] for details on how a model can be
configured.

### Examples

To set an HTTP proxy for the **client**, whose URL is given by $PROXY_HTTP:

```bash
export http_proxy=$PROXY_HTTP
```

To configure all models to use an APT mirror, whose URL is given by
$MIRROR_APT, while creating an AWS-based controller:

```bash
juju bootstrap --model-default apt-mirror=$MIRROR_APT aws
```

To have all models of a localhost cloud use local resources for both Juju agent
binaries and cloud images, whose URLs are given by $LOCAL_AGENTS and
$LOCAL_IMAGES, respectively:

```bash
juju bootstrap \
    --model-default agent-metadata-url=$LOCAL_AGENTS \
    --model-default image-metadata-url=$LOCAL_IMAGES \
    localhost
```


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
[anchor__offline-configuration-methods]: #offline-configuration-methods
[anchor__no-proxy-and-the-localhost-cloud]: ./charms-offline-strategies.html#no-proxy-and-the-localhost-cloud
