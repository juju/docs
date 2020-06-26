<!--
Todo:
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1747998
-->

Juju models networks using *spaces*, which can be mapped to one or more subnets of the chosen backing cloud. When a space's subnets span multiple availability zones, Juju will automatically distribute application units across subnets and zones, thereby providing increased resilience.

From a security standpoint, spaces allow you to restrict an application's network access. Spaces allow you to configure the model's network topology to restrict applications to posse only the network connectivity they need.

Here are a few properties to keep in mind:

- Spaces can contain multiple subnets
- Subnets are restricted to a single one space
- All subnets within a space are considered equal in terms of routing

[note status="Provider support"]
Spaces are currently only supported by the MAAS and EC2 providers.
[/note]

<h2 id="heading--use-case">Example: isolating a database from the Internet</h2>

Consider a model divided into three segments with distinct security requirements:

-   The "dmz" space for publicly-accessible applications (e.g. HAProxy) providing access to the CMS application behind it.
-   The "cms" space for content-management applications accessible via the "dmz" space only.
-   The "db" space for backend database applications, which should be accessible only by the applications.

HAProxy is deployed inside the "dmz" space, it is accessible from the internet and proxies HTTP requests to one or more Joomla units in the "cms" space. The backend MySQL for Joomla is running in the "db" space. All subnets within the "cms" and "db" spaces provide no access from outside the environment for security reasons.

<!---
[note]
Future development will implement isolation among spaces via firewall and/or access control rules. This means that only network traffic required for the applications to function will be allowed between spaces.
[/note]
-->

<h2 id="heading--adding-and-listing-spaces-and-subnets">Adding and listing spaces and subnets</h2>

Spaces are created with the `add-space` command. The following command maps a space called `db-space` with subnet 192.168.123.0/24:

``` text
juju add-space db-space 192.168.123.0/24
```

To see which spaces have been added, along with any subnets belonging to those spaces, use the `juju spaces` command. Its output will look similar to the following:

``` text
Space    Subnets
db-space 192.168.123.0/24
public
undefined  192.168.122.0/24
```

To map an existing subnet to a space use the `add-subnet` command. Here we map subnet 192.168.124.0/24 to space 'db-space':

``` text
juju add-subnet 192.168.124.0/24 db-space
```

The `juju subnets` command will list all subnets known to Juju with output similar to the following:

``` text
subnets:
  192.168.122.0/24:
    type: ipv4
    provider-id: "5"
    status: in-use
    space: undefined
    zones:
    - default
  192.168.123.0/24:
    type: ipv4
    provider-id: "6"
    status: in-use
    space: undefined
    zones:
    - default
```

<h3 id="heading--maas-and-spaces">MAAS and spaces</h3>

MAAS has a native knowledge of spaces. Within MAAS, spaces can be created, configured, and destroyed. This allows Juju to leverage MAAS spaces without the need to add/remove spaces and subnets. However, this also means that Juju needs to "pull" such information from MAAS. This is done by default upon controller-creation. Run `juju reload-spaces` to refresh Juju's knowledge of MAAS spaces and works on a per-model basis.

[note]
The `reload-spaces` command does not currently pull in all information. This is being worked upon. See [LP #1747998](https://bugs.launchpad.net/juju/+bug/1747998).
[/note]

<h3 id="heading--bridges">Bridges</h3>

Juju creates bridges for containers *only* when Juju knows the spaces an application may require, and the container's bridge for that application will only connect to the required network interfaces.

<h2 id="heading--using-spaces">Using spaces</h2>

Once all desired spaces have been added and/or configured they can be called upon by using either a *constraint* or a *binding*.

A space constraint, like any other constraint, operates at the machine level. It requests that certain network connections be made available to the Juju machine. When a constraint is used, all application endpoints get associated with the space.

-   See the [Using constraints](/t/using-constraints/1060) page to learn more about constraints.
-   For examples of using the 'spaces' constraint, read [Deploying to spaces](/t/deploying-applications-advanced/1061#heading--deploying-to-network-spaces) for how to use it with the `deploy` command and [Setting constraints when adding a machine](/t/using-constraints/1060#heading--setting-constraints-when-adding-a-machine) for how to use it with the `add-machine` command.

A binding is a space-specific, software level operation and is a more fine-grained request. It associates an application endpoint with a subnet.

-  See examples of using a binding when deploying applications on [Deploying to network spaces](/t/deploying-applications-advanced/1061#heading--deploying-to-network-spaces). For using spaces with bundles go to [Charm bundles](/t/charm-bundles/1058#heading--binding-endpoints-within-a-bundle).
- The `juju bind` command allows you to modify an application's endpoint bindings.
