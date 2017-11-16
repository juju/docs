Title: Juju and FAN networking

# Juju and FAN networking

FAN networking addresses a need raised by the proliferation of container usage
in an IPv4 context: the ability to manage the address space such that network
connectivity among containers running on separate hosts is achieved.

Juju integrates with the FAN to provide network connectivity between containers
that was hitherto not possible. The typical use case is the seamless
interaction between deployed applications running within LXD containers on
separate Juju machines.

## FAN overview

The FAN is a mapping between a smaller IPv4 address space (e.g. a /16 network)
and a larger one (e.g. a /8 network) where **subnets** from the larger one (the
*underlay* network) are assigned to **addresses** on the smaller one (the
*overlay* network). Connectivity between containers on the larger network is
enabled in a simple and efficient manner.

In the case of the above networks (/16 underlay and /8 overlay), each host
address on the underlay "provides" 253 addresses on the overlay. FAN networking
can thus be considered a form of "address expansion".

Further reading on generic (non-Juju) FAN networking:

 - [FAN networking][fan-ubuntu-wiki] : general user documentation
 - [Container-to-Container Networking][fan-ubuntu-insights] : a less technical
   overview
 - [LXD network configuration][fan-lxd-config-options] : FAN configuration
   options at the LXD level
 - [`fanctl` man page][fan-fanctl-man-page] : configuration information at the
   operating system level

## Juju model FAN configuration

Juju manages FAN networking at the model level (see
[Configuring models][models-config]) and is enabled via the
`container-networking-method` configuration option.

The essential parameter for FAN itself, irrespective of Juju, is the mapping of
the underlay network to the overlay network. The `fan-config` model option is
used to specify this.

## Cloud provider requirements













<!-- LINKS -->

[fan-ubuntu-wiki]: https://wiki.ubuntu.com/FanNetworking
[fan-ubuntu-insights]: https://insights.ubuntu.com/2015/06/22/container-to-container-networking-the-bits-have-hit-the-fan/
[fan-lxd-config-options]: https://github.com/lxc/lxd/blob/master/doc/networks.md
[fan-fanctl-man-page]: http://manpages.ubuntu.com/cgi-bin/search.py?q=fanctl
[models-config]: ./models-config.html
