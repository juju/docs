Title: FAN container networking

# FAN container networking

FAN networking addresses an important issue raised by the proliferation of
container usage: the need to manage the IP address space that results in
network connectivity among containers running on separate hosts.

Further reading on generic (non-Juju) FAN networking:

 - [FAN networking][fan-ubuntu-wiki] : general user documentation
 - [Container-to-Container Networking][fan-ubuntu-insights] : a less technical
   overview
 - [LXD network configuration][fan-lxd-config-options] : FAN configuration
   options at the LXD level
 - [`fanctl` man page][fan-fanctl-man-page] : configuration information at the
   operating system level

## Juju and FAN networking

Juju integrates with the FAN to provide network connectivity between containers
that was hitherto not possible. The typical use case is the seamless
interaction between deployed applications running within LXD containers on
separate Juju machines.














<!-- LINKS -->

[fan-ubuntu-wiki]: https://wiki.ubuntu.com/FanNetworking
[fan-ubuntu-insights]: https://insights.ubuntu.com/2015/06/22/container-to-container-networking-the-bits-have-hit-the-fan/
[fan-lxd-config-options]: https://github.com/lxc/lxd/blob/master/doc/networks.md
[fan-fanctl-man-page]: http://manpages.ubuntu.com/cgi-bin/search.py?q=fanctl
