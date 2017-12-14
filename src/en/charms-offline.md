Title: Working offline

# Working offline

The objective of this page is to assist users who find themselves deploying
and/or managing Juju within an *offline* network.

For the purposes here, a network is considered offline if the systems on that
network have been deliberately deprived of access to any outside network, the
internet in particular. This is typically done for security reasons.

Such a network can also be called a *proxy-restricted environment* since,
normally, access is allowed to a few internet-enabled systems that act as
intermediaries (proxies) for necessary services. In a Juju context, such
services would commonly provide access to:

 - charms
 - APT packages
 - Various HTTP-based resources
 - snaps

Examples of common offline clouds are LXD, MAAS, and OpenStack.

This subject is broken up into several sub-topics, each with its own page. They
all assume Juju has been installed on a system dedicated to the management of
the offline environment.

## Offline mode strategies

This section will offer guidance at the system administrator level by
describing what resources/protocols are required by various types of Juju
deployments. In addition, suggestions for achieving the corresponding services
are offered by means of HTTP/S proxying, APT proxying, and repository
mirroring, Juju agent mirroring, and cloud image mirroring. See
[Offline mode strategies][charms-offline-strategies].

## Configuring Juju for offline usage

Juju needs to be configured in order for its various parts (client, controller,
machines) to know how to request the resources necessary for various actions
(controller creation, machine creation, charm deployments, etc.) to be
successful. This section will show how this is done via the CLI. See
[Configuring Juju for offline usage][charms-offline-config].

## Deploying charms offline

Once the auxiliary services have been set up and Juju has been configured to
use those services Juju charms can be deployed. This section describes how this
is done. See [Deploying charms offline][charms-offline-deploying].

## Distributing snaps internally

The exemplar snap for Juju users is [Charm Tools][tools-charm-tools] but the
guidance provided here can be applied to any snap. See 
[Distributing snaps internally][snaps-offline].

## Using the localhost cloud (LXD) offline

Here, an example of an offline Juju installation is provided through the use
of the localhost cloud (LXD). Go to
[Using the localhost cloud (LXD) offline][charms-offline-lxd].


<!-- LINKS -->

[charms-offline-deploying]: ./charms-offline-deploying.html
[tools-charm-tools]: ./tools-charm-tools.html
[snaps-offline]: ./snaps-offline.html
[charms-offline-strategies]: ./charms-offline-strategies.html
[charms-offline-config]: ./charms-offline-config.html
[charms-offline-lxd]: ./charms-offline-lxd.html
