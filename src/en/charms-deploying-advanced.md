Title: Deploying applications - advanced
TODO:  Verify MAAS spaces example

# Deploying applications - advanced

This page is dedicated to more advanced topics related to deploying
applications with Juju. The main page is
[Deploying applications][charms-deploying].

Topics covered here are:

 - Multi-series charms
 - Deploying to specific machines
 - Deploying to spaces

## Multi-series charms

Charms can be created that support more than one release of a given operating
system distro, such as the multiple Ubuntu releases shown below. It is not
possible to create a charm to support multiple distros, such as one charm for
both Ubuntu and CentOS. Supported series are added to the charm metadata like
this:

```
name: mycharm
summary: "Great software"
description: It works
maintainer: Some One <some.one@example.com>
categories:
   - databases
series:
   - trusty
   - xenial
provides:
   db:
     interface: pgsql
requires:
   syslog:
     interface: syslog
```

The default series for the charm is the first one listed. So, in this example,
to deploy `mycharm` on `trusty`, all you need is:

```bash
juju deploy mycharm
```

You can specify a different series using the `--series` flag:

```bash
juju deploy mycharm --series xenial
```

You can force the charm to deploy using an unsupported series using the
`--force` flag:

```bash
juju deploy mycharm --series bionic --force
```

Here is a more complete example showing a new machine being added that uses
a different series than is supported by our `mycharm` example and then forcing
the charm to install:

```bash
juju add-machine --series bionic
juju deploy mycharm --to 1 --series  bionic --force
```

Multi-series charms may encounter upgrade difficulties if support for the
installed series is dropped. See [Forced upgrades][charms-upgrading-forced] for
details.

## Deploying to specific machines

To deploy to specific, pre-existing machines the `--to` option is used. When
this is done, unless the machine was created via `add-machine`, a charm has
already been deployed to the machine.  

!!! Note:
    When multiple charms are deployed to the same machine there exists the
    possibility of conflicting configuration files (on the machine's
    filesystem). Work is being done to rectify this.

Machines are often referred to by their ID number. This is a simple integer
that is shown in the output to `juju status` (or `juju machines`). For example,
this partial output shows a machine with an ID of '2':

```no-highlight
Machine  State    DNS           Inst id        Series  AZ  Message
2        started  10.132.70.65  juju-79b3aa-0  xenial      Running
```

### deploy --to

To deploy the 'haproxy' application to machine '2' we would do this:

```bash
juju deploy --to 2 haproxy
```

Below, the `--constraints` option is used during controller creation to ensure
that each workload machine will have enough memory to run multiple
applications. MySQL is deployed as the first unit (in the
'default' model) and so ends up on machine '0'. Then Rabbitmq gets deployed to
the same machine:

```bash
juju bootstrap --constraints="mem=4G" localhost lxd
juju deploy mysql
juju deploy --to 0 rabbitmq-server
```

Juju treats a container like any other machine so it is possible to target
specific containers as well. Here we deploy to containers in two different
ways:

```bash
juju deploy nginx --to 24/lxd/3
juju deploy mongodb --to lxd:25
```

In the first case above, nginx is deployed to existing container '3' on machine
'24'. In the second case, MongoDB is deployed to a **new** container on machine
'25'. The latter is an exception to the rule that the `--to` option is always
used in conjunction with a pre-existing machine.

It is also possible to deploy units using *placement directives* as arguments
to the `--to` option. Placement directives are cloud-specific:

```bash
juju deploy mysql --to zone=us-east-1a
juju deploy mediawiki --to host.mass
```

The first example deploys to a specific AWS zone while the second example
deploys to a named machine in MAAS.

### add-unit --to

The `add-unit` command also supports the `--to` option, including placement
directives. This allows one to specifically target an existing machine when
scaling out. For example, to add a unit of 'rabbitmq-server' to machine '1':

```bash
juju add-unit --to 1 rabbitmq-server
```

A comma separated list of directives can be provided to cater for the case
where more than one unit is being added:

```bash
juju add-unit rabbitmq-server -n 4 --to zone=us-west-1a,zone=us-east-1b
juju add-unit rabbitmq-server -n 4 --to host1,host2,host3,host4
```

Any extra placement directives are ignored. If not enough placement directives
are supplied, then the remaining units will be assigned as normal to a new,
clean machine.

## Deploying to network spaces

Using spaces, the operator is able to create a more restricted network topology
for applications at deployment time (see [Network spaces][network-spaces] for
details on spaces). This is achieved with the use of the `--bind` option.

The following will deploy the 'mysql' application to the 'db-space' space:

```bash
juju deploy mysql --bind db-space
```

For finer control, individual endpoints can be connected to specific spaces:

```bash
juju deploy --bind "db=db-space db-admin=admin-space" mysql
```

If a space is mentioned that is not associated with an interface then it will
act as the default space (i.e. will be used for any unspecified interface):

```bash
juju deploy --bind "default-space db=db-space db-admin=admin-space" mysql
```

See [Concepts and terms][concepts-endpoint] for the definition of an endpoint,
an interface, and other closely related terms.

For information on applying bindings to bundles, see
[Binding endpoints within a bundle][charms-bundles-endpoints].

The `deploy` command also allows for the specification of a constraint. Here is
an example of doing this with spaces:

```bash
juju deploy mysql -n 2 --constraints spaces=database
```

See [Adding a machine with constraints][charms-contraints-spaces] for an
example of doing this with spaces.

You can also declare an endpoint for spaces that is not used with relations,
see [Extra-bindings][extra-bindings].

### Spaces example

This example will have MAAS as the backing cloud and use the following
criteria:

 - DMZ space (with 2 subnets, one in each zone), hosting 2
   units of the haproxy application, which is exposed and provides
   access to the CMS application behind it.
 - CMS space (also with 2 subnets, one per zone), hosting 2
   units of mediawiki, accessible only via haproxy (not exposed).
 - Database (again, 2 subnets, one per zone), hosting 2 units of
   mysql, providing the database backend for mediawiki.

First, ensure MAAS has the necessary subnets and spaces. Each subnet has the
"automatic public IP address" attribute enabled on each:

 - 172.31.50.0/24, for space "database"
 - 172.31.51.0/24, for space "database"
 - 172.31.100.0/24, for space "cms"
 - 172.31.110.0/24, for space "cms"
 - 172.31.0.0/20, for the "dmz" space
 - 172.31.16.0/20, for the "dmz" space

Recall that MAAS has native knowledge of spaces. They are created within MAAS
and Juju will become aware of them when the Juju controller is built
(`juju bootstrap`).

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

Once all the units are up, you will be able to get the public IP address of one
of the haproxy units (from `juju status`), and open it in a browser, seeing the
mediawiki page.


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.html
[network-spaces]: ./network-spaces.html
[charms-bundles-endpoints]: ./charms-bundles.html#binding-endpoints-of-applications-within-a-bundle
[extra-bindings]: ./authors-charm-metadata.html#extra-bindings
[clouds-maas]: ./clouds-maas.html
[charms-contraints-spaces]: ./charms-constraints.html#adding-a-machine-with-constraints
[concepts-endpoint]: ./juju-concepts.html#endpoint
[charms-upgrading-forced]: ./charms-upgrading.html#forced-upgrades
