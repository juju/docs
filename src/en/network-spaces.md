Title: How to configure more complex networks using spaces

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

!!! Note: Advanced networking features, such as 'spaces`, are currently only
supported by MAAS and EC2 providers.

Having multiple subnets spanning different zones within the same space enables
Juju to perform automatic distribution of an application's units across zones
inside the same space. This allows for high-availability and the spreading of
instances evenly across subnets and zones.

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

Please note, Juju does not yet enforce those security restrictions, but having
spaces and subnets available makes it possible to implement those restrictions
and access control in a future release.

Due to the ability of spaces to span multiple zones services can be distributed
across these zones. This allows high available setup for services within the
environment.

Spaces are created like this:

```bash
juju space create <name> [ <CIDR1> <CIDR2> ... ] [--private|--public]
```

They can be listed in various formats using the "list" subcommand. See
also "juju space help" for more information. Other space subcommands are
"list", "rename", and "remove".

Existing subnets can be added using:

```bash
juju subnet add <CIDR>|<subnet-provider-id> <space> [<zone1> <zone2> ...]
```

Like spaces they can be listed by the subcommand "list". See
also "juju subnet help" for more information.

The commands "add-machine" and "deploy" allow the specification of a
spaces constraint for the selection of a matching instance. It is done by
adding:

```
--constraints spaces=<allowedspace1>,<allowedspace2>,^<disallowedspace>
```

The spaces constraint allows to select an instance for the new machine or unit,
connected to one or more existing spaces. Both positive and negative entries are
accepted, the latter prefixed by "^", in a comma-delimited list. For example, 
given the following:

```
--constraints spaces=db,^storage,^dmz,internal
```

Juju will provision instances connected to (with IP addresses on) one of the subnets
of both db and internal spaces, and NOT connected to either the storage or dmz spaces.

For more information regarding constraints in general, see "juju help constraints".

## Example

Let's model the following deployment in Juju:

- DMZ space (with 2 subnets, one in each zone), hosting 2
  units of the haproxy service, which is exposed and provides
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
juju space create dmz
juju space create cms
juju space create database
juju subnet add 172.31.0.0/20 dmz
juju subnet add 172.31.16.0/20 dmz
juju subnet add 172.31.50.0/24 database
juju subnet add 172.31.51.0/24 database
juju subnet add 172.31.100.0/24 cms
juju subnet add 172.31.110.0/24 cms
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
IP address of one of the haproxy units (from ```juju status```), and
open it in a browser, seeing the mediawiki page.

In an upcoming release, Juju will provide much better visibility
of which services and units run in which spaces/subnets.

Please note, Juju supports the described syntax but currently ignores
all but the first allowed space in the list. This behavior will change
in a future release.
