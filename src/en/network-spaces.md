Title: How to configure more complex networks using spaces
TODO: Could do with a re-write and further simplification

# How to configure more complex networks using spaces

Juju models networks using "spaces". A space is made up of one or more routable
subnets with common ingress and egress rules. The Juju operator can model this
topology in such a way that applications have the required network connectivity
without generating complex network IP maps that are not portable. This gives
the operator much better and finer-grained control over all networking aspects
of a model and its application deployments. 

Spaces represent sets of disjoint subnets that are available for running cloud
instances that may span one or more availability zones ("zones"). Any given
subnet can be part of one and only one space. All subnets within a space are
considered "equal" in terms of access control, firewall rules, and routing.
Communication between spaces will be subject to access restrictions and
isolation, such as between instances running within subnets which are members
of different spaces.

!!! Note: Advanced networking features, such as 'spaces`, are currently only
supported by MAAS.

Having multiple subnets spanning different zones within the same space
enables Juju to perform automatic distribution of units of a service across
zones inside the same space. This allows for the high-availability of
applications and the spreading of instances evenly across subnets and zones.

As an example, consider a model divided into three segments with
distinct security requirements:

- The "dmz" space for publicly-accessible services (e.g. HAProxy) providing
  access to the CMS application behind it.
- The "cms" space for content-management applications accessible via the "dmz"
  space only.
 -The "database" space for backend database services, which should be accessible
  only by the applications.

HAProxy is deployed inside the "dmz" space, it is accessible from the Internet
and proxies HTTP requests to one or more Joomla units in the "cms" space.
The backend MySQL for Joomla is running in the "database" space. All subnets
within the "cms" and "database" spaces provide no access from outside the
environment for security reasons. Using spaces for deployments like this allows
Juju to have the necessary information about how to configure the firewall and
access control rules. In this case, instances in "dmz" can only communicate
with instances in "apps", which in turn are the only ones allowed to access
instances in "database".

!!! Note: Juju does not yet enforce these security restrictions. Having spaces
and subnets available makes it possible to implement restrictions and access
control in a future release.

## Adding and listing spaces and subnets

Spaces are created with the `add-space` command:

```bash
juju add-space [options] <name> [<CIDR1> <CIDR2> ...]
```
The following command would add a space called 'db-space` with a single subnet,
192.168.123.0/24, as a member:

```bash
juju add-space db-space 192.168.123.0/24
```

The CIDR subnet arguments are optional.

To see which spaces have been added, along with any subnets belonging to those
spacves, use the `juju spaces` command. Its output will look similar to the
following:

```no-highlight
Space    Subnets
db-space 192.168.123.0/24
public
undefined  192.168.122.0/24
```

Subnets share a similar command-set to spaces. To add an existing subnet, for
example, use the `add-subnet` command:

```bash
juju add-subnet [options] <CIDR>|<provider-id> <space> [<zone1> <zone2> ...]
```

Similar to the `spaces` command, typing `juju subnets` will list all subnets known
to Juju with default output similar to the following:

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

## Binding models to spaces

When deploying a charm or a bundle, specify a space using the `--bind` argument
with the `juju deploy` command. The following, for example, will deploy the
'mysql' application to the 'db-space' space:

```bash
juju deploy mysql --bind db-space
```
Using the `--bind` argument, you can also specify how char-defined endpoints
are connected to spaces. The following command also includes a default option
for any other interfaces not specified:

```bash
juju deploy mysql --bind "db:db-space db-admin:admin-space default-space"
```

Alternatively, both the `add-machine` and `deploy` commands allow the specification of a
spaces constraint using the `--constraints` argument:

```bash
juju add-machine --constraints spaces=db-space
```

The spaces constraint allows you to select an instance for the new machine or unit,
connected to one or more existing spaces. Both positive and negative entries are
accepted, the latter prefixed by "^", in a comma-delimited list. For example, 
given the following:

```
--constraints spaces=db-space,^storage,^dmz,internal
```

Juju will provision instances connected to (with IP addresses on) one of the subnets
of both db-space and internal spaces, and NOT connected to either the storage or dmz spaces.

For more information regarding constraints in general, see "juju help constraints".

### Network bridges

Prior to Juju 2.1, all deployed machines were regarded as potential hosts for
containers, and as a result, all network interfaces connected to those machines
were bridged by default, even if a container such as LXD or Docker, was never
placed on a machine. If a container was placed on a machine, all of a machine's
network devices were made available to each container. Starting with Juju 2.1,
this will no longer be true. Juju will only create the bridges which are
necessary for a container to operate in the model.


This led to issues where the operator wanted a much cleaner model where the containers only had access to
networks that the model required.

Starting from Juju 2.1 this will no longer be true. Juju will only create the
bridges which are necessary for a container to operate in the model.



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
$ juju bootstrap
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

Now we can deploy the services into their respective spaces,
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

In an upcoming release, Juju will provide much better visibility
of which services and units run in which spaces/subnets.


