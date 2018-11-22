Title: Deploying applications - advanced
TODO:  Verify MAAS spaces example
       Reconcile 'add-unit' with charms-scaling.md

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

To deploy to specific machines the `--to` option is used. When this is done,
unless the machine was created via `add-machine`, a charm has already been
deployed to the machine.  

!!! Warning:
    When multiple charms are deployed to the same machine there exists the
    possibility of conflicting configuration files (on the machine's
    filesystem).

The `--to` option can be used with commands `bootstrap`, `deploy`, and
`add-unit`.

To apply this option towards an existing Juju machine, the machine ID is used.
This is an integer that is shown in the output to `juju status` (or
`juju machines`). For example, this partial output shows a machine with an ID
of '2':

```no-highlight
Machine  State    DNS           Inst id        Series  AZ  Message
2        started  10.132.70.65  juju-79b3aa-0  xenial      Running
```

The above works well with `deploy` and `add-unit` as will be shown below. As
for `bootstrap` the `--to` option is limited to either pointing to a MAAS node
or, starting in `v.2.5`, to a LXD cluster node.

Assuming a MAAS cloud named 'maas-prod' exists and has a node called
'node2.maas':

```bash
juju bootstrap maas-prod --to node2.maas
```

Assuming a LXD cluster cloud named 'lxd-cluster' exists and has a node called
'node3':

```bash
juju bootstrap lxd-cluster --to node3
```

### deploy --to

To deploy the 'haproxy' application to machine '2' we would do this:

```bash
juju deploy --to 2 haproxy
```

Below, the `--constraints` option is used during controller creation to ensure
that each workload machine will have enough memory to run multiple
applications. MySQL is deployed as the first unit (in the 'default' model) and
so ends up on machine '0'. Then Rabbitmq gets deployed to the same machine:

```bash
juju bootstrap --constraints mem=4G localhost lxd
juju deploy mysql
juju deploy --to 0 rabbitmq-server
```

Juju treats a container like any other machine so it is possible to target
specific containers as well. Here we deploy to containers in three different
ways:

```bash
juju deploy mariadb --to lxd
juju deploy mongodb --to lxd:25
juju deploy nginx --to 24/lxd/3
```

In the first case, mariadb is deployed to a container on a new machine. In the
second case, MongoDB is deployed to a new container on existing machine '25'.
In the third case, nginx is deployed to existing container '3' on existing
machine '24'.

Some clouds support special arguments to the `--to` option, where instead of a
machine you can specify a zone. In the case of MAAS or a LXD cluster a node can
be specified:

```bash
juju deploy mysql --to zone=us-east-1a
juju deploy mediawiki --to node1.maas
juju deploy mariadb --to node1.lxd
```

For a Kubernetes-backed cloud, a Kubernetes node can be targeted based on
matching labels. The label can be either built-in or one that is user-defined
and added to the node. For example:

```bash
juju deploy mariadb-k8s --to kubernetes.io/hostname=somehost
```

### add-unit --to

To add a unit of 'rabbitmq-server' to machine '1':

```bash
juju add-unit --to 1 rabbitmq-server
```

A comma separated list of directives can be provided to cater for the case
where more than one unit is being added:

```bash
juju add-unit rabbitmq-server -n 3 --to host1.maas,host2.maas,host3.maas
```

If the number of values is less than the number of requested units the
remaining units, as per normal behaviour, will be deployed to new machines:

```bash
juju add-unit rabbitmq-server -n 4 --to zone=us-west-1a,zone=us-east-1b
```

Any surplus values are ignored:

```bash
juju add-unit rabbitmq-server -n 2 --to node1.lxd,node2.lxd,node3.lxd
```

The `add-unit` command is often associated with scaling out. See the
[Scaling applications][charms-scaling] page for information on that topic.

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

[charms-deploying]: ./charms-deploying.md
[network-spaces]: ./network-spaces.md
[charms-bundles-endpoints]: ./charms-bundles.md#binding-endpoints-of-applications-within-a-bundle
[extra-bindings]: ./authors-charm-metadata.md#extra-bindings-field
[clouds-maas]: ./clouds-maas.md
[charms-contraints-spaces]: ./charms-constraints.md#adding-a-machine-with-constraints
[concepts-endpoint]: ./juju-concepts.md#endpoint
[charms-upgrading-forced]: ./charms-upgrading.md#forced-upgrades
[charms-scaling]: ./charms-scaling.md
