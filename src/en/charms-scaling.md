Title: Scaling applications
TODO:  More direction ito how users discover "built-in scaling" (e.g. the store is not clear on wordpress)
       Write a tutorial on Kubernetes scaling

# Scaling applications

The capability of a service to adjust its resource footprint to a level
appropriate for fulfilling client demands placed upon it is known as
*scalability*. Scaling *vertically* affects the resources of existing machines
(memory, CPU, disk space) whereas scaling *horizontally*, in Juju, involves the
number of application units available.

Units are not always synonymous with machines however. Multiple units can be
placed onto a single machine (co-location) and still be considered horizontal
scaling if sufficient resources are present on the machine.

This page will describe how rudimentary scaling works with Juju as well as
mention some less common situations.

## Scaling up

In the context of Juju, scaling up means increasing the number of application
units and always involves the `add-unit` command. The exception is for a
Kubernetes-backed cloud where the `scale-application` command is used.

Closely resembling scaling up is the addition of a machine devoid of a unit.
This is accomplished via the `add-machine` command:
  
```bash
juju add-machine
```

!!! Note:
    A machine provisioned via the `add-machine` command that does not yet house
    an application unit will, by default, be used for any subsequent
    application deployment (via the `deploy` command).

### Scaling up behind a load balancer

In many cases simply adding more units will not make an application scale
properly. A load balancer or proxy is often required.

Below is an example of deploying a load balanced
[MediaWiki][store-mediawiki] application by placing the
[HAProxy][store-haproxy] application in front of it:

```bash
juju deploy mediawiki
juju deploy mysql
juju deploy haproxy
juju add-relation mediawiki:db mysql
juju add-relation mediawiki haproxy
juju expose haproxy
```

When a relation is made between MediaWiki and HAProxy, the latter will be
configured to load balance requests to the MediaWiki application. This means
that client requests should go to the HAProxy instance. To get the proxy's
IP address run the following:

```bash
juju status haproxy
```

You can now scale up the MediaWiki application behind the proxy as you see fit.
To add five more units (with each running in its own machine):

```bash
juju add-unit -n 5 mediawiki
```

### Scaling up within a Kubernetes model

To scale up while in a Kubernetes model the total number of desired units for
the application is simply stated. Here we want a total of three units:

```bash
juju scale-application mediawiki 3
```

### Scaling up using a charm with built-in scaling

Some charms have scaling built-in where scaling up really *is* as simple as
adding more units.

An example of this is the [WordPress][store-wordpress] charm:

```bash
juju deploy mysql
juju deploy wordpress
juju add-relation mysql wordpress
juju expose wordpress
```

To scale up by adding an extra unit one can simply do:

```bash
juju add-unit wordpress
```

This will cause a new unit (and machine) to be spawned and configured to work
alongside the existing one.

By default, `add-unit` will add a single unit. To request multiple units the
`-n` option is needed. For example, to further scale up our current application
by adding 100 units of MySQL one would run:

```bash
juju add-unit -n 100 mysql
```

### Scaling up through co-location

Like the `deploy` command, it is possible to co-locate multiple applications on
a single machine. This is done via the `--to` option.

For example, to add a unit of MySQL to the machine with an ID of '23':

```bash
juju add-unit mysql --to 23
```

To add a unit of the same application to existing LXC container '3' residing on
host machine '24':

```bash
juju add-unit mysql --to 24/lxc/3
```

!!! Note:
    Not all applications will happily co-exist (usually due to conflicting
    configuration files). It is therefore generally safer to place units on
    dedicated machines or containers.

Here we add a unit of MySQL to a **new** LXC container on host machine 25:

```bash
juju add-unit mysql --to lxc:25
```

### Scaling up by specifying new constraints

It is possible to scale out an application by adding a unit with different
hardware requirements (constraints) than those set with the initial deployment.
The default behaviour is for new units to use the same, if any, constraints.

This is done by indirectly creating a machine with a constraint and then adding
the unit to it. For example, to add a unit with 16 GiB of memory to the MySQL
application if the initial deployment was only, say, 4 GiB:

```bash
juju add-machine --constraints mem=16G
juju machines
juju add-unit mysql --to 3
```

Above, it is presumed that `juju machines` informed us that the new machine was
assigned an ID of '3'.

Read the [Using constraints][charms-constraints] page for details on
constraints.

## Scaling down

In the context of Juju, scaling down means decreasing the number of application
units and always involves the `remove-unit` command. The exception is for a
Kubernetes-backed cloud where the `scale-application` command is used.

Closely resembling scaling down is the direct removal of a machine. This is
therefore also covered here and is accomplished via the `remove-machine`
command.
  
To scale down the MediaWiki application by removing a specific unit:

```bash
juju remove-unit mediawiki/1
```

Note that if this is the only unit running on the underlying machine, the
machine will also be removed.

A machine cannot be manually removed if any of the following is true:

 - it houses a unit
 - it is being used as the only controller
 - it is hosting Juju-managed containers (KVM guests or LXD containers) 

For example, to remove a machine with ID of '6':

```bash
juju remove-machine 6
```

For more information on removing applications and machines, see the
[Removing Juju objects][charms-destroy] page.

### Scaling down within a Kubernetes model

To scale down while in a Kubernetes model the total number of desired units for
the application is simply stated. Here we want a total of two units:

```bash
juju scale-application mediawiki 2
```

<!-- LINKS -->

[charms-constraints]: ./charms-constraints.md
[charms-destroy]: ./charms-destroy.md
[upstream-haproxy]: http://haproxy.org
[store-mediawiki]: https://jujucharms.com/mediawiki
[store-wordpress]: https://jujucharms.com/wordpress
[store-haproxy]: https://jujucharms.com/haproxy
