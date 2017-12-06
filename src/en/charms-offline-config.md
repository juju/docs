Title: Configuring Juju for offline usage

# Configuring Juju for offline usage

This page makes use of information presented in the
[Offline mode strategies][charms-offline-strategies] document.

Juju honours various proxy settings There are 2 places to configure proxies
when bootstrapping juju.

The bootstrap unit itself may need proxy information to retrieve various
packages. This is configured with --config options during bootstrap.

Models may also need this proxy information if charms deployed in those models
require external network access (for example, access to pypi to install
requisite pip packages). This is configured with --model-default options during
bootstrap.

Consider an environment where all network traffic must go
through an http://squid.internal:3128 proxy. We plan to deploy charms locally
with LXD, so we need to ensure all inter-container traffic is not proxied. This
can be achieved as follows:

## no proxy for localhost, our eth0 ip address, and our lxd subnet

```bash
export no_proxy=`echo localhost 10.245.67.130 10.44.139.{1..255} | sed 's/ /,/g'`
export http_proxy=http://squid.internal:3128
export https_proxy=http://squid.internal:3128
```

Now bootstrap with the appropriate proxy configuration:

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

https://bugs.launchpad.net/juju/+bug/1730617

<!-- LINKS -->

[charms-offline-deploying]: ./charms-offline-deploying.html
[charms-offline-strategies]: ./charms-offline-strategies.html
