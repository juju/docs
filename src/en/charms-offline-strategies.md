Title: Offline mode strategies
TODO:  docs needed: explanation of an agent (and link from 'agent mirror'). see models-upgrade.md

# Offline mode strategies

This is in connection with the [Working offline][charms-offline] page. See
that resource for background information.

This page provides an overview of various types of services that can be
implemented in order for Juju to live happily in an internet-deprived
environment. Common tools that can be used to achieve such services are also
listed.

The services of concern here are:

 - HTTP/S proxy
 - APT proxy
 - APT repository mirror
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

## APT proxy

An HTTP/S proxy may not accept HTTP/S requests for APT packages. The idea of an
APT proxy is identical to that of an HTTP/S proxy except that it applies
specifically to APT package requests.

Some common implementations include:

 - [`APT-cacher`][upstream-apt-cacher]
 - [`Apt-Cacher NG`][upstream-apt-cacher-ng]
 - [`squid`][upstream-squid]
 - [`squid-deb-proxy`][upstream-squid-deb-proxy] (based on squid)

## APT repository mirror

Instead of proxying client requests to an internet-based repository it is
possible to maintain the repository internally. That is, you can have a copy or
*mirror* of a Ubuntu package repository. This option has a large storage
requirement and the initial setup/download time is considerable. Regular mirror
synchronization will also be needed.

Here are some popular mirroring solutions:

 - [`apt-mirror`][upstream-apt-mirror]
 - [`debmirror`][upstream-debmirror]
 - [`aptly`][upstream-aptly]

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

## Cloud images mirror

A mirror can be made of the [official cloud images][upstream-cloud-images].
This will primarily be useful for a localhost cloud (LXD) but a local OpenStack
installation can also make use of such a mirror if LXD containers are put on
its instances.


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
