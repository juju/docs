Title: Network Spaces
TODO: Critical: Review needed
      First section appears to introduce spaces repeatedly
      First section should not contain an example
      Diagrams needed
      Verify second example
      Include example of using binding/endpoint method
      Move examples to charms-deploy page
      Bug tracking: https://bugs.launchpad.net/juju/+bug/1747998

# Network Spaces

Juju models networks using *spaces*, which can be mapped to one or more
routable subnets. The Juju operator can model this topology in such a way that
applications gain only the required network connectivity without generating
complex network IP maps that are not portable.

Spaces represent sets of subnets that are available for running cloud instances
that may span one or more availability zones ("zones"). There are a few simple
considerations when using spaces:

- Any given subnet can be part of one and only one space.
- All subnets within a space are considered "equal" in terms of routing.

!!! Note:
    Network spaces are currently only supported by the MAAS and EC2 providers.

Having multiple subnets spanning different zones within the same space enables
Juju to perform automatic distribution of an application's units across zones
inside the same space. This allows for high-availability and the spreading of
instances evenly across subnets and zones.

As an example, consider a model divided into three segments with
distinct security requirements:

- The "dmz" space for publicly-accessible applications (e.g. HAProxy) providing
  access to the CMS application behind it.
- The "cms" space for content-management applications accessible via the "dmz"
  space only.
- The "database" space for backend database applications, which should be
  accessible only by the applications.

HAProxy is deployed inside the "dmz" space, it is accessible from the Internet
and proxies HTTP requests to one or more Joomla units in the "cms" space. The
backend MySQL for Joomla is running in the "database" space. All subnets within
the "cms" and "database" spaces provide no access from outside the environment
for security reasons.

!!! Note: 
    Future development will implement isolation among spaces via firewall
    and/or access control rules. This measns that only network traffic required
    for the applications to function will be allowed between spaces.

## Adding and listing spaces and subnets

Spaces are created with the `add-space` command:

```bash
juju add-space [options] <name> [<CIDR1> <CIDR2> ...]
```

The CIDR subnet arguments are optional, but the following command adds a space
called `db-space` with a single subnet, 192.168.123.0/24, as a member:

```bash
juju add-space db-space 192.168.123.0/24
```

To see which spaces have been added, along with any subnets belonging to those
spaces, use the `juju spaces` command. Its output will look similar to the
following:

```bash
Space    Subnets
db-space 192.168.123.0/24
public
undefined  192.168.122.0/24
```

Subnets share a similar command-set to spaces. To add an existing subnet to
Juju, for example, use the `add-subnet` command:

```bash
juju add-subnet [options] <CIDR>|<provider-id> <space> [<zone1> <zone2> ...]
```

Similar to the `spaces` command, typing `juju subnets` will list all subnets known
to Juju with output similar to the following:

```bash
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

### MAAS and spaces

MAAS has a native knowledge of spaces. Within MAAS, spaces can be created,
configured, and destroyed. This allows Juju to leverage MAAS spaces without the
need to add/remove spaces and subnets. However, this also means that Juju needs
to "pull" such information from MAAS. This is done by default upon
controller-creation. The command `juju reload-spaces` is used to refresh Juju's
knowledge of MAAS spaces and works on a per-model basis. 

!!! Note:
    The `juju reload-spaces` command does not currently pull in all
    information. This is being worked upon. See [LP #1747998][LP-1747998].

### Bridges

Prior to Juju 2.1, all deployed machines were regarded as potential hosts for
containers, and as a result, all network interfaces connected to those machines
were bridged by default. This happened even if no containers were placed on a
machine. If a container was placed on a machine, all of a machine's network
devices were made available to each container. 

Juju now creates bridges for containers *only* when Juju knows the spaces an
application may require, and the container's bridge for that application will
only connect to the required network interfaces. 

## Using spaces

Once all desired spaces have been added and/or configured they are called upon
when adding a machine or deploying an application. There are two available
methods for doing this: a *constraint* or a *binding*.

A space constraint, like any other constraint, operates at the machine level.
It requests that certain network connections be made available to the Juju
machine. When a constraint is used, all application endpoints get associated
with the space. For more general information on constraints, see the
[Constraints][charms-constraints] page.

A binding is a space-specific, software level operation and is a more
fine-grained request. It associates an application endpoint with a subnet.

For details on using spaces when deploying applications, and how to bind
endpoints to specific spaces, see [Deploying to spaces][deployspaces]. To
create bundles with specific bindings, see
[Using and Creating Bundles][createbundles].

## Spaces and subnets example

Let's model the following deployment in Juju using a MAAS-backed cloud:

- DMZ space (with 2 subnets, one in each zone), hosting 2
  units of the haproxy application, which is exposed and provides
  access to the CMS application behind it.
- CMS space (also with 2 subnets, one per zone), hosting 2
  units of mediawiki, accessible only via haproxy (not exposed).
- Database (again, 2 subnets, one per zone), hosting 2 units of
  mysql, providing the database backend for mediawiki.

First, ensure MAAS has the necessary subnets, which have the "automatic public
IP address" attribute enabled on each:

- 172.31.50.0/24, for space "database"
- 172.31.51.0/24, for space "database"
- 172.31.100.0/24, for space "cms"
- 172.31.110.0/24, for space "cms"
- 172.31.0.0/20, for the "dmz" space
- 172.31.16.0/20, for the "dmz" space

Second, add the MAAS cloud to Juju. See [Using a MAAS cloud][clouds-maas] for
guidance.

Third, create the Juju controller, assuming a cloud name of 'maas-cloud':

```bash
juju bootstrap maas-cloud
```

Finally, deploy the applications into their respective spaces (here we use the
constraints method), relate them, and expose haproxy:

```bash
juju deploy haproxy -n 2 --constraints spaces=dmz
juju deploy mediawiki -n 2 --constraints spaces=cms
juju deploy mysql -n 2 --constraints spaces=database
juju add-relation haproxy mediawiki
juju add-relation mediawiki mysql
juju expose haproxy
```

Once all the units are up, you will be able to get the public
IP address of one of the haproxy units (from `juju status`), and
open it in a browser, seeing the mediawiki page.

[createbundles]: ./charms-bundles.html#binding-endpoints-of-applications-within-a-bundle
[deployspaces]: ./charms-deploying.html#deploying-to-spaces
[charms-constraints]: ./charms-constraints.html
[clouds-maas]: ./clouds-maas.html
[LP-1747998]: https://bugs.launchpad.net/juju/+bug/1747998
