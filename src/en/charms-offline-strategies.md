Title: Offline mode strategies
TODO:  docs needed: explanation of an agent (and link from 'agent mirror'). see models-upgrade.md

# Offline mode strategies

*This is in connection with the [Working offline][charms-offline] page. See
that resource for background information.*

This page provides an overview of various types of services that can be
implemented in order for Juju to live happily in an internet-deprived
environment. Common tools that can be used to achieve such services are also
listed.

The services of concern here are:

 - HTTP/S proxy
 - APT proxy
 - FTP proxy
 - APT mirror
 - Juju agent mirror
 - Cloud image mirror

## HTTP/S proxy

The purpose of a forward HTTP/S proxy is to act as an intermediary for a client
making any HTTP or HTTPS request. For our purposes, the client is a Juju
machine.

Most such proxies include a *caching* ability. That is, the proxy will store
the resulting data locally so that any subsequent request can be quickly
satisfied.

The de-facto forward proxy solution on Ubuntu is [`squid`][upstream-squid].

Juju uses options `http-proxy` and `https-proxy` to denote these proxies.

### No HTTP/S proxy

When an HTTP/S proxy is configured there may be destinations that should be
excluded from using it.

Juju uses option `no-proxy` to represent these destinations.

In general, all instances within a cloud should be able to communicate directly
with one another. It may, or it may not, be necessary to express this via the
`no-proxy` variable. This is because the latter is limited to the HTTP and
HTTPS protocols, which may not apply in every case. Nevertheless, it is often
done out of simplicity.

#### No proxy and the localhost cloud

This "no proxy" idea is often used extensively with the localhost cloud at both
the (shell) environment level and at the Juju level. The purpose being to
ensure the client can connect with the local controller and that the local
machines can inter-communicate, all without going through a proxy.

Hosts to exclude from the proxy include:

 - localhost & 127.0.0.1 (standard 'no proxy' settings)
 - the address assigned to the regular Ethernet device
 - the address assigned to the host's LXD bridge (to talk to the controller via
   its API)
 - the entire subnet dedicated to the particular LXD installation

## APT proxy

An HTTP/S or FTP proxy may not be configured to accept requests for APT
packages. An APT proxy is identical to that of an HTTP/S or FTP proxy except
that it applies specifically to APT package requests.

Some common implementations include:

 - [`APT-cacher`][upstream-apt-cacher]
 - [`Apt-Cacher NG`][upstream-apt-cacher-ng]
 - [`squid`][upstream-squid]
 - [`squid-deb-proxy`][upstream-squid-deb-proxy] (based on squid)

Juju uses options `apt-ftp-proxy`, `apt-http-proxy`, and `apt-https-proxy` to
set these proxies, depending on the protocol involved (i.e. FTP, HTTP, or
HTTPS).

## FTP proxy

A standard FTP proxy. Juju uses the `ftp-proxy` option for this type of proxy.

## APT mirror

Instead of proxying client requests to an internet-based repository it is
possible to maintain the repository internally. That is, you can have a copy or
*mirror* of an Ubuntu package repository. This option has a large storage
requirement and the initial setup/download time is considerable. Regular mirror
synchronization will also be needed.

Here are some popular mirroring solutions:

 - [`apt-mirror`][upstream-apt-mirror]
 - [`debmirror`][upstream-debmirror]
 - [`aptly`][upstream-aptly]

Juju uses the `apt-mirror` option for this.

### HTTP/S server

For any sort of mirror, an HTTP/S server (i.e. a web server) will be required
to respond to the actual client requests. These are the most common ones:

 - [`Apache`][upstream-apache]
 - [`nginx`][upstream-nginx]
 - [`lighttpd`][upstream-lighttpd]

## Juju agent mirror

An agent that gets installed onto a Juju machine is proxied through the
controller. If the latter cannot satisfy the request via its cache it will
download the agent from the [official agent site][upstream-agents], and then
pass it on to the machine. It is possible, however, to set up an agent mirror
so the remote site is not solicited by the controller. Download the latest few
agents and configure one of the aforementioned web servers accordingly.
Updates to the mirrored agents will be needed as new versions of Juju itself
become available.

Agent downloads can be performed manually from the above site where, for
example, the file `juju-2.3.1-ubuntu-amd64.tgz` is the 2.3.1 agent for all
Ubuntu releases for the AMD64 architecture.

Downloads can also be made with the `juju sync-agent-binaries` command. Note
that this method results in a larger download as only the major and minor
version numbers can be specified (e.g. 2.3 and not 2.3.1) and all architectures
are retrieved. Additionally, there will be a file for every Ubuntu release even
though they are all identical (e.g. `juju-2.3.1-xenial-amd64.tgz` ==
`juju-2.3.1-bionic-amd64.tgz`). Each one of these files is approximately 27 MiB
in size.

Below, all 2.3 agents are retrieved and placed into a local directory:

```bash
mkdir -p /home/ubuntu/tmp/agents
juju sync-agent-binaries --version 2.3 --local-dir=/home/ubuntu/tmp/agents-2.3
```

!!! Note:
    Once the agents are downloaded, the `juju sync-agent-binaries` command can
    also be used to push them to a model, thereby foregoing the need for a
    mirror.

## Cloud images mirror

A mirror can be made of the [official cloud images][upstream-cloud-images]
(`http://cloud-images.ubuntu.com`). This will primarily be useful for a
localhost cloud (LXD) but a local OpenStack installation can also make use of
such a mirror if LXD containers are put on its instances.


<!-- LINKS -->

[charms-offline]: ./charms-offline.html
[upstream-apt-cacher]: https://help.ubuntu.com/community/Apt-Cacher-Server
[upstream-apt-cacher-ng]: https://www.unix-ag.uni-kl.de/~bloch/acng/
[upstream-squid]: http://www.squid-cache.org/
[upstream-nginx]: https://www.nginx.com/resources/wiki/
[upstream-apache]: https://www.apache.org/
[upstream-lighttpd]: https://www.lighttpd.net/
[upstream-apt-mirror]: https://apt-mirror.github.io/
[upstream-debmirror]: http://manpages.ubuntu.com/cgi-bin/search.py?q=debmirror
[upstream-aptly]: https://www.aptly.info/
[upstream-squid-deb-proxy]: https://launchpad.net/squid-deb-proxy
[upstream-agents]: https://streams.canonical.com/juju/tools/agent/
[upstream-cloud-images]: http://cloud-images.ubuntu.com/
