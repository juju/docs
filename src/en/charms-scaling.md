Title: Scaling applications
TODO:  The Scaling down section should reference charms-destroy.html (remove-unit)
       Critical: review required

# Scaling applications

 - Scaling up
 - Scaling up behind a load balancer
 - Scaling charms with built in horizontal scaling
 - Co-location
 - Adding a unit with new constraints
 - Scaling down

## Scaling up

To scale up an application up is via the `add-unit` command:


## Scaling up behind a load balancer

In many cases you just can't add more units to an application and have it magically
scale - you need to use a load balancer. In this case you can just deploy a
proxy in front of your units; let's deploy a load balanced MediaWiki:

```bash
juju deploy haproxy
juju deploy mediawiki
juju deploy mysql
juju add-relation mediawiki:db mysql
juju add-relation mediawiki haproxy
juju expose haproxy
```

The haproxy charm configures and installs an
HAProxy ([http://haproxy.1wt.eu/](http://haproxy.1wt.eu/)) application, the
widely used TCP/HTTP load balancer. When you add a relation between the
MediaWiki instance and HAProxy, it will be configured to load balance requests
to that application. Note that this means the web traffic should be directed to
the HAProxy instance. Running:

```bash
juju status haproxy
```

will return the public IP for the load balancer. This is the IP you want to
point your DNS to.

Now that you are behind a load balancer, you can grow the MediaWiki instances
behind the proxy as you see fit, let's add 5 more:

```bash
juju add-unit -n 5 mediawiki
```

You don't need to worry about manually adding your units to the load balancer.
You've made the relationship at the _application level_, so the new units know
exactly how to relate. Juju is also smart enough to ensure that the new units
are installed and configured _before_ adding them to the load balancer,
ensuring minimal user disruption of the application.


## Scaling charms with built in horizontal scaling

Some charms have native scaling built in. For instance, the WordPress charm
has built in load balancing. In this case, scaling up applications is really as
simple as requesting more instances. Note that this feature is charm specific,
not all charms can scale this way. Consider the following setup for a WordPress:

```bash
juju deploy mysql
juju deploy wordpress
juju add-relation mysql wordpress
juju expose wordpress
```

When you notice the WordPress instance is struggling under the load, you can
simply scale up the application:

```bash
juju add-unit wordpress
```

This will cause a new instance to be run and configured to work alongside the
currently running one. Behind the scenes, Juju is adding an instance to the
model and provisioning the specified application
onto that instance/machine.

Now suppose your MySQL application needs hyperscale, you can use the `-n` or
`--num-units` options to `add-unit` to specify the desired number of units you
want added to the application. For example, to scale up your application by 100
units simply do:

```bash
juju add-unit -n 100 mysql
```

or you can use `--num-unit` which has the same result, but is more readable:

```bash
juju add-unit --num-unit 100 mysql
```

### Co-location

As with the `juju deploy` command, it is possible to co-locate applications on
machines.
If you would like to add a unit to a specific machine just append the `--to`
option, for example:

```bash
juju add-unit mysql --to 23
```
...adds a unit to machine 23,

```bash
juju add-unit mysql --to 24/lxc/3
```
...adds a unit to lxc container 3 on host machine 24.

It is worth noting that not all applications will happily co-exist and it is much
safer to create a new container when co-locating:

```bash
juju add-unit mysql --to lxc:25
```
...add unit of mysql to a new lxc container on host machine 25

## Adding a unit with new constraints

It is possible to scale out an application by adding a unit with different
hardware requirements than those set with the initial deployment.

For example, to add a unit with 16 GiB of memory to the MySQL application if
the initial deployment was only 4 GiB:

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

Scaling down is the act of reducing an application's resource footprint. In the
context of Juju, it is scaling down horizontally (as opposed to vertically).
This mean reducing the number of individual application instances. It is
accomplished with the `remove-unit` command.

To scale down the MediaWiki application by removing a specific unit:

```bash
juju remove-unit mediawiki/1
```

Note that because this is the only unit running on the underlying machine, the
machine will also be removed.

A machine can be manually removed via the `remove-machine` command unless any
of the following is true for that machine:

 - it has no running units
 - it is not being used as the only controller
 - it is not hosting Juju-managed containers (KVM guests or LXD containers) 

For example, to remove a machine with ID of '6':

```bash
juju remove-machine 6
```

For more information on removing applications and machines, see the
[Removing Juju objects][charms-destroy] page.


<!-- LINKS -->

[charms-destroy]: ./charms-destroy.md
