Title: How to configure more complex networks using spaces
TODO: Could do with a re-write and further simplification
      Diagrams needed

# How to configure more complex networks using spaces

Juju models networks using "spaces". A space is made up of one or more routable
subnets with common ingress and egress rules. The Juju operator can model this
topology in such a way that applications gain the required network connectivity
without generating complex network IP maps that are not portable. This gives
the operator much better and finer-grained control over all networking aspects
of a model and its application deployments. 

Spaces represent sets of subnets that are available for running cloud instances
that may span one or more availability zones ("zones"). There are a few simple
considerations when using spaces:

- Any given subnet can be part of one and only one space.
- All subnets within a space are considered "equal" in terms of access control,
  firewall rules, and routing.
- Communication between spaces will be subject to access restrictions and
  isolation, such as between instances running within subnets which are members
  of different spaces.

!!! Note:
    Network spaces are currently only supported by the MAAS and EC2 providers.


!!! Note:
    Juju's knowledge of the available spaces on the underlying cloud may lag
    behind recent changes. To force Juju to re-examine the spaces it can use,
    you should run the command `juju reload-spaces`.  

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
and proxies HTTP requests to one or more Joomla units in the "cms" space.
The backend MySQL for Joomla is running in the "database" space. All subnets
within the "cms" and "database" spaces provide no access from outside the
environment for security reasons. Using spaces for deployments like this allows
Juju to have the necessary information about how to configure the firewall and
access control rules. In this case, instances in "dmz" can only communicate
with instances in "apps", which in turn are the only ones allowed to access
instances in "database".

!!! Note: 
    Juju does not yet enforce these security restrictions. Having spaces
    and subnets available makes it possible to implement restrictions and access
    control in a future release.

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

For details on how to deploy applications to specific spaces, and how to bind
specific charm-defined endpoints to specific spaces, see [Deploying to
spaces][deployspaces]. To create bundles with specific bindings, see [Using and
Creating Bundles][createbundles].

### Bridges

Prior to Juju 2.1, all deployed machines were regarded as potential hosts for
containers, and as a result, all network interfaces connected to those machines
were bridged by default. This happened even if no containers were placed on a
machine. If a container was placed on a machine, all of a machine's network
devices were made available to each container. 

Juju now creates bridges for containers *only* when Juju knows the spaces an
application may require, and the container's bridge for that application will
only connect to the required network interfaces. 

## Spaces and subnets example

Let's model the following deployment in Juju:

- DMZ space (with 2 subnets, one in each zone), hosting 2
  units of the haproxy application, which is exposed and provides
  access to the CMS application behind it.
- CMS space (also with 2 subnets, one per zone), hosting 2
  units of mediawiki, accessible only via haproxy (not exposed).
- Database (again, 2 subnets, one per zone), hosting 2 units of
  mysql, providing the database backend for mediawiki.

First, we need to create additional subnets using MAAS, and enable
the "automatic public IP address" attribute on each subnet:

- 172.31.50.0/24, for space "database"
- 172.31.51.0/24, for space "database"
- 172.31.100.0/24, for space "cms"
- 172.31.110.0/24, for space "cms"

We also assume MAAS already has 2 default subnets (one per
zone), configured like this:

- 172.31.0.0/20, for the "dmz" space
- 172.31.16.0/20, for the "dmz" space

Once MAAS has those subnets, we can bootstrap as usual:

```bash
juju bootstrap
```

After that, we can create the 3 spaces and add the subnets we
created to each one. These steps will be automated, and the subnet
creation will be possible directly from Juju in a future release.

```bash
juju add-space dmz
juju add-space cms
juju add-space database
juju add-subnet 172.31.0.0/20 dmz
juju add-subnet 172.31.16.0/20 dmz
juju add-subnet 172.31.50.0/24 database
juju add-subnet 172.31.51.0/24 database
juju add-subnet 172.31.100.0/24 cms
juju add-subnet 172.31.110.0/24 cms
```

Now we can deploy the applications into their respective spaces,
relate them and expose haproxy:

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
