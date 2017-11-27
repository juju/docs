Title: Working offline

# Working offline

The objective of this page is to assist users who find themselves deploying
and/or managing Juju within an *offline* network.

For the purposes here, a network is considered offline if the systems on that
network have been deliberately deprived of access to any outside network, the
internet in particular. This is typically done for security reasons.

Some select systems, however, may be provided internet access in order to act
as intermediaries for necessary services. In a Juju context, such services
would commonly provide access to:

 - charms
 - HTTP-based resources
 - APT packages
 - snaps

This top-level document links to sub-pages that cover the following topics:

 - Offline mode strategies (proxies and mirrors)
 - Configuring Juju for offline usage
 - Deploying charms offline
 - Distributing snaps internally

## Offline mode strategies (proxies and mirrors)



## Configuring Juju for offline usage



## Deploying charms offline

[Deploying charms offline][charms-offline]

## Distributing snaps internally

The exemplar snap for Juju users is [Charm Tools][tools-charm-tools] but the
guidance provided here can be applied to any snap. See 
[Distributing snaps internally][snaps-offline].


<!-- LINKS -->

[charms-offline]: ./charms-offline.html
[tools-charm-tools]: ./tools-charm-tools.html
[snaps-offline]: ./snaps-offline.html
[charms-offline-strategies]: ./charms-offline-strategies.html
[charms-offline-config]: ./charms-offline-config.html
