Title: Offline mode strategies

# Offline mode strategies

This is in connection with the [Working offline][charms-offline] page. See
that resource for background information.

This page offers suggestions on how to achieve the following services in order
for Juju to live happily in an internet-deprived environment:

 - HTTP/S proxies
 - APT caching proxies
 - internal APT repositories and mirrors

## HTTP/S proxies
## APT caching proxies

An APT caching proxy satisfies a client's package request and if it does not
have the package in its store, it downloads it (and adds it to its store). Some
common implementations include:

 - [`APT-cacher`][upstream-apt-cacher]
 - [`Apt-Cacher NG`][upstream-apt-cacher-ng]
 - [`squid`][upstream-squid]
 - [`squid-deb-proxy`][upstream-squid-deb-proxy] (based on squid)

## Internal APT repositories and mirrors



<!-- LINKS -->

[charms-offline]: ./charms-offline.html
[upstream-apt-cacher]: https://help.ubuntu.com/community/Apt-Cacher-Server
[upstream-apt-cacher-ng]: https://www.unix-ag.uni-kl.de/~bloch/acng/
[upstream-squid]: http://www.squid-cache.org/
[upstream-squid-deb-proxy]: https://launchpad.net/squid-deb-proxy
