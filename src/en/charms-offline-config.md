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
 - non-controller model

Where 'client' is the Juju client from whence the `juju` commands are invoked;
the 'controller' is the Juju controller; and the 'non-controller model' is the
model housing the workload Juju machines. By configuring the latter model, all
its machines become thereby configured.

????????? refer to models-config.md

--model-default
--config

## Network criteria

For bootstrap, we need access to the cloud provider (in the case of LXD this is
your LXD agent running on the lxd bridge).
We'll also likely need access to https://streams.canonical.com unless you're
planning on using a local jujud agent binary. (Typically we download it from
streams.canonical.com to be sure we can get updates and support more than just
one architecture or series.) We also use streams in order to map OS series into
images for the cloud.

We'll also likely need access to archive.ubuntu.com and security.ubuntu.com, in
order to ensure your packages are up-to-date. We also need access to packages
like juju-mongodb3.2 on the bootstrapped machine.
If you have a different archive to use, its possible to set apt mirrors, etc.
And you can also set up alternative locations to download agent binaries
(agent-metadata-url). And you may want a different location to find images for
your cloud (image-metadata-url).

For some charms that you deploy you may need access to more sites
(ppa.launchpad.net, github.com, etc.), that is very application specific.
You'll also need access to jujucharms.com if you want to use store charms
rather than local charms.

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

set the proxy for both the controller you are about to create, and for the
client that you are running. You're also likely to need to set 'no-proxy' to
appropriate values so that you can still contact things like the LXD agent
running on your host machine.

```bash
export no_proxy=`echo localhost 10.245.67.130 10.44.139.{1..255} | sed 's/ /,/g'`
```

?????? where X.Y is the IP address that was assigned to your LXD bridge. 

Finally, apply these settings during the controller-creation process:

```bash
juju bootstrap \
--config http-proxy=$http_proxy \
--config https-proxy=$https_proxy \
--config no-proxy=$no_proxy \
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
