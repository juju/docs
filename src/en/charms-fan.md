Title: FAN container networking

# FAN container networking

FAN networking addresses an important issue caused by the proliferation of
container usage: the need to manage the IP address space that results in
network connectivity among containers running on separate hosts.

Juju integrates with the FAN to provide network connectivity between deployed
container-based applications that was hitherto not possible.

Further reading on generic (non-Juju) FAN networking:

 - [FAN networking][fan-ubuntu-wiki] : general user documentation
 - [Container-to-Container Networking][fan-ubuntu-insights] : a less technical overview
 - [LXD network configuration][fan-lxd-config-options] : LXD FAN options
 - [`fanctl` man page][fan-fanctl-man-page] : low level information

## Juju and FAN networking














<!-- LINKS -->

[fan-ubuntu-wiki]: https://wiki.ubuntu.com/FanNetworking
[fan-ubuntu-insights]: https://insights.ubuntu.com/2015/06/22/container-to-container-networking-the-bits-have-hit-the-fan/
[fan-lxd-config-options]: https://github.com/lxc/lxd/blob/master/doc/networks.md
[fan-fanctl-man-page]: http://manpages.ubuntu.com/cgi-bin/search.py?q=fanctl
