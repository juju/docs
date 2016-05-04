Title: Scaling charms  
TODO: Check final note still relevant for 2.0 release  

# Scaling Charms

One of the killer features of computing in the cloud is that it (should)
seamlessly allow you to scale up or down your services to meet your needs and
whims. Juju not only makes it simple to deploy services, but crucially makes it
easy to manage them too. It won't anticipate you getting slashdotted or on the
front page of hacker news (yet), but it does mean that when you do you can
reliably scale your services to meet the demand.


##  Adding Units

The general usage to scale a service up is via the `add-unit` command:

```bash
juju add-unit [options] <service-name>
```

The command options are:

```no-highlight
#juju environment to operate in
-e, --environment <environment_name>
# number of service units to add
-n, --num-units [integer]
# the machine or container to deploy the unit in, bypasses constraints
--to <machine>
```


## Scaling behind a Load Balancer

Usually you just can't add more units to a service and have it magically scale
- you need to use a load balancer. In this case you can just deploy a proxy in
front of your units; let's deploy a load balanced mediawiki:

```bash
juju deploy haproxy
juju deploy mediawiki
juju deploy mysql
juju add-relation mediawiki:db mysql
juju add-relation mediawiki haproxy
juju expose haproxy
```

The haproxy charm configures and installs an
HAProxy ([http://haproxy.1wt.eu/](http://haproxy.1wt.eu/)) service, the widely
used TCP/HTTP load balancer. When you add a relation between the MediaWiki
instance and HAProxy, it will be configured to load balance requests to that
service. Note that this means the web traffic should be directed to the HAProxy
instance. Running:

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
You've made the relationship at the _service level_, so the new units know
exactly how to relate. Juju is also smart enough to ensure that the new units
are installed and configured _before_ adding them to the load balancer,
ensuring minimal user disruption of the service.


## Scaling Charms with built in Horizontal scaling

Some charms have native scaling built in. For instance, the WordPress charm
has built in load balancing. In this case, scaling up services is really as
simple as requesting more instances. Note that this feature is charm specific,
not all charms can scale this way. Consider the following setup for a WordPress:

```bash
juju deploy mysql
juju deploy wordpress
juju add-relation mysql wordpress
juju expose wordpress
```

When you notice the WordPress instance is struggling under the load, you can
simply scale up the service:

```bash
juju add-unit wordpress
```

This will cause a new instance to be run and configured to work alongside the
currently running one. Behind the scenes, Juju is adding an instance to the
environment (also called a 'machine') and provisioning the specified service
onto that instance/machine.

Now suppose your MySQL service needs hyperscale, you can use the `-n` or `--num-
units` options to `add-unit` to specify the desired number of units you want
added to the service. For example, to scale up your service by 100 units simply
do:

```bash
juju add-unit -n 100 mysql
```

or you can use `--num-unit` which has the same result, but is more readable:

```bash
juju add-unit --num-unit 100 mysql
```

### Co-location

As with the `juju deploy` command, it is possible to co-locate services on machines.
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

It is worth noting that not all services will happily co-exist and it is much 
safer to create a new container when co-locating:
  
```bash
juju add-unit mysql --to lxc:25
```
...add unit of mysql to a new lxc container on host machine 25

## Constraints

The `add-unit` command deploys a machine matching the constraints of the
initially deployed service. For example, if MySQL was deployed with the
defaults (i.e. no `--constraints` option) you would have MySQL on an instance
that matches the closest to 1 Gigabyte of memory and 1 CPU available. If you
would like to add a unit with more resources to the MySQL service you will
first need to issue a `add-machine` with the desired constraint followed by a
`add-unit`. For example, the following command adds a 16 Gigabyte unit to the
MySQL service (note in this example `juju status` returns machine 3 for the
`add-machine` command):

```bash
juju add-machine --constraints="mem=16G"
juju add-unit mysql --to 3
```


## Scaling Back

Sometimes you may want to scale back some of your services, and this too is
easy with Juju.

The general usage to scale down a service is with the `remove-unit` command:

```bash
juju remove-unit [options] <unit> [...]
```

For example, the following scales down the MediaWiki service by removing a
specific unit:

```bash
juju remove-unit mediawiki/1
```

If you have scaled-up the MediaWiki service by more than one unit you can
remove multiple units in the same command:

```bash
juju remove-unit mediawiki/1 mediawiki/2 mediawiki/3 mediawiki/4 mediawiki/5
```
!!! Note: the unit numbers may not necessarily be sequential, see the
[notes on machine/unit numbering](./reference-numbering)


The `remove-unit` command can be run to remove running units safely. The
running services should automatically adjust to the change. If the machine the
removed unit was running on is not being used as a controller, or hosting other
Juju managed containers, it will be destroyed automatically.

!!! Note: If a machine has no running units, controllers or containers, and 
hasn't been removed automatically, it can be removed with the `remove-machine`
command. For example, to remove machine 1 that the unit `mediawiki/1` was
housed on, use the command: 
    
```bash
juju remove-machine 1
```

For more information on removing services, please see the section on
[destroying services](charms-destroy.html).
