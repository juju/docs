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

--model-default
--config

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
export no_proxy=`echo localhost 10.245.67.130 10.44.139.{1..255} | sed 's/ /,/g'`
```

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
