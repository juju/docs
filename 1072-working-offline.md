The objective of this page is to assist users who find themselves deploying and/or managing Juju within an *offline* network.

For the purposes here, a network is considered offline if the systems on that network have been deliberately deprived of access to any outside network, the internet in particular. This is typically done for security reasons.

Such a network can also be called a *proxy-restricted environment* since, normally, access is allowed to a few internet-enabled systems that act as intermediaries (proxies) for necessary services. In a Juju context, such services would commonly provide access to:

-   charms
-   APT packages
-   Various HTTP-based resources
-   snaps

Examples of common offline clouds are LXD, MAAS, and OpenStack.

This subject is broken up into several sub-topics, each with its own page. They all assume Juju has been installed on a system dedicated to the management of the offline environment.

<h2 id="heading--offline-mode-strategies">Offline mode strategies</h2>

This section will offer guidance at the system administrator level by describing what resources/protocols are required by various types of Juju deployments. In addition, suggestions for achieving the corresponding services are offered by means of HTTP/S proxying, APT proxying, and repository mirroring, Juju agent mirroring, and cloud image mirroring. See [Offline mode strategies](/t/offline-mode-strategies/1071).

<h2 id="heading--configuring-juju-for-offline-usage">Configuring Juju for offline usage</h2>

Juju needs to be configured in order for its various parts (client, controller, machines) to know how to request the resources necessary for various actions (controller creation, machine creation, charm deployments, etc.) to be successful. This section will show how this is done via the CLI. See [Configuring Juju for offline usage](/t/configuring-juju-for-offline-usage/1068).

<h2 id="heading--deploying-charms-offline">Deploying charms offline</h2>

Once the auxiliary services have been set up and Juju has been configured to use those services Juju charms can be deployed. This section describes how this is done. See [Deploying charms offline](/t/deploying-charms-offline/1069).

<h2 id="heading--installing-snaps-offline">Installing snaps offline</h2>

The exemplar snap for Juju users is [Charm Tools](/t/charm-tools/1180) but the guidance provided here can be applied to any snap. See [Installing snaps offline](/t/installing-snaps-offline/1179).

<h2 id="heading--using-the-localhost-cloud-offline">Using the localhost cloud offline</h2>

Here, an example of an offline Juju installation is provided through the use of the localhost cloud (LXD). Go to [Using the localhost cloud offline](/t/using-the-localhost-cloud-offline/1070).

<!-- LINKS -->
