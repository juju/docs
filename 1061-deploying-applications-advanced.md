<!--
Todo:
- Verify MAAS spaces example
- Reconcile 'add-unit' with /t/scaling-applications/1075
-->

This page is dedicated to more advanced topics related to deploying applications with Juju. The main page is [Deploying applications](/t/deploying-applications/1062).

Topics covered here are:

- Charms and series
- Deploying to specific machines
- Deploying to spaces
- Trusting an application with a credential

<h2 id="heading--charms-and-series">Charms and series</h2>

Charms can be created that support more than one release of a given operating system distro, such as the multiple Ubuntu releases shown below. It is not possible to create a charm to support multiple distros, such as one charm for both Ubuntu and CentOS. Supported series are added to the charm metadata like this:

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

The default series for the charm is the first one listed. So, in this example, to deploy `mycharm` on `trusty`, all you need is:

``` text
juju deploy mycharm
```

You can specify a different series using the `--series` flag:

``` text
juju deploy mycharm --series xenial
```

You can force the charm to deploy using an unsupported series using the `--force` flag:

``` text
juju deploy mycharm --series bionic --force
```

Here is a more complete example showing a new machine being added that uses a different series than is supported by our `mycharm` example and then forcing the charm to install:

``` text
juju add-machine --series bionic
juju deploy mycharm --to 1 --series  bionic --force
```

Multi-series charms may encounter upgrade difficulties if support for the installed series is dropped. See [Forced upgrades](/t/upgrading-applications/1080#heading--forced-upgrades) for details.

<h2 id="heading--deploying-to-specific-machines">Deploying to specific machines</h2>

To deploy to specific machines the `--to` option is used. It is supported by commands `bootstrap`, `deploy`, and `add-unit`.

The argument to the `--to` option is called a *placement directive*.

When this option is used, unless the machine was created via `add-machine`, a charm has already been deployed to the machine. When multiple charms are deployed to the same machine there exists the chance of conflicting configuration files (on the machine's filesystem).

[note]
There is one type of placement directive that can also be used as a constraint: availability zones. If used together, the placement directive takes precedence. See [Using constraints][charms-constraints] for details.
[/note]

To apply this option towards an existing Juju machine, the machine ID is used. This is an integer that is shown in the output to `juju status` (or `juju machines`). For example, this partial output shows a machine with an ID of '2':

``` text
Machine  State    DNS           Inst id        Series  AZ  Message
2        started  10.132.70.65  juju-79b3aa-0  xenial      Running
```

The above works well with `deploy` and `add-unit` as will be shown below. As for `bootstrap` the `--to` option is limited to either pointing to a MAAS node or, starting in `v.2.5.0`, to a LXD cluster node.

Assuming a MAAS cloud named 'maas-prod' exists and has a node called 'node2.maas':

``` text
juju bootstrap maas-prod --to node2.maas
```

Assuming a LXD cluster cloud named 'lxd-cluster' exists and has a node called 'node3':

``` text
juju bootstrap lxd-cluster --to node3
```

<h3 id="heading--deploy---to">deploy --to</h3>

To deploy the 'haproxy' application to machine '2' we would do this:

``` text
juju deploy --to 2 haproxy
```

Below, the `--constraints` option is used during controller creation to ensure that each workload machine will have enough memory to run multiple applications. MySQL is deployed as the first unit (in the 'default' model) and so ends up on machine '0'. Then Rabbitmq gets deployed to the same machine:

``` text
juju bootstrap --constraints mem=4G localhost lxd
juju deploy mysql
juju deploy --to 0 rabbitmq-server
```

Juju treats a container like any other machine so it is possible to target specific containers as well. Here we deploy to containers in three different ways:

``` text
juju deploy mariadb --to lxd
juju deploy mongodb --to lxd:25
juju deploy nginx --to 24/lxd/3
```

In the first case, mariadb is deployed to a container on a new machine. In the second case, MongoDB is deployed to a new container on existing machine '25'. In the third case, nginx is deployed to existing container '3' on existing machine '24'.

Some clouds support special arguments to the `--to` option, where instead of a machine you can specify a zone. In the case of MAAS or a LXD cluster a node can be specified:

``` text
juju deploy mysql --to zone=us-east-1a
juju deploy mediawiki --to node1.maas
juju deploy mariadb --to node1.lxd
```

For a Kubernetes-backed cloud, a Kubernetes node can be targeted based on matching labels. The label can be either built-in or one that is user-defined and added to the node. For example:

``` text
juju deploy mariadb-k8s --to kubernetes.io/hostname=somehost
```

<h3 id="heading--add-unit---to">add-unit --to</h3>

To add a unit of 'rabbitmq-server' to machine '1':

``` text
juju add-unit --to 1 rabbitmq-server
```

A comma separated list of directives can be provided to cater for the case where more than one unit is being added:

``` text
juju add-unit rabbitmq-server -n 3 --to host1.maas,host2.maas,host3.maas
```

If the number of values is less than the number of requested units the remaining units, as per normal behaviour, will be deployed to new machines:

``` text
juju add-unit rabbitmq-server -n 4 --to zone=us-west-1a,zone=us-east-1b
```

Any surplus values are ignored:

``` text
juju add-unit rabbitmq-server -n 2 --to node1.lxd,node2.lxd,node3.lxd
```

The `add-unit` command is often associated with scaling out. See the [Scaling applications](/t/scaling-applications/1075) page for information on that topic.

<h2 id="heading--deploying-to-specific-availability-zones">Deploying to specific availability zones</h2>

To deploy to specific availability zones the `--constraints` option is used. It is supported by commands `bootstrap`, `deploy`, and `add-machine`.

The constraint type that is used to do this is 'zones'. This is not to be confused with the 'zone' placement directive, which happens to take precedence over the constraint.

For instance, here we create two Trusty machines in a certain zone:

``` text
juju add-machine -n 2 --series trusty --constraints zones=us-east-1a
```

We then deploy an application on two new machines in a different zone:

``` text
juju deploy redis -n 2 --constraints zones=us-east-1c
```

Finally, in order to deploy units to the two empty machines in the initial zone we first change the application constraint default (set implicitly with the `deploy` command):

``` text
juju set-constraints redis zones=us-east-1a
juju add-unit redis -n 2
```

When multiple (comma separated) values are used, the constraint is interpreted as being a range of zones where a machine must end up in.

<h2 id="heading--deploying-to-network-spaces">Deploying to network spaces</h2>

Using spaces, the operator is able to create a more restricted network topology for applications at deployment time (see [Network spaces](/t/network-spaces/1157) for details on spaces). This is achieved with the use of the `--bind` option.

The following will deploy the 'mysql' application to the 'db-space' space:

``` text
juju deploy mysql --bind db-space
```

For finer control, individual endpoints can be connected to specific spaces:

``` text
juju deploy --bind "db=db-space db-admin=admin-space" mysql
```

If a space is mentioned that is not associated with an interface then it will act as the default space (i.e. will be used for any unspecified interface):

``` text
juju deploy --bind "default-space db=db-space db-admin=admin-space" mysql
```

See [Concepts and terms](/t/concepts-and-terms/1144#heading--endpoint) for the definition of an endpoint, an interface, and other closely related terms.

For information on applying bindings to bundles, see [Binding endpoints within a bundle](/t/charm-bundles/1058#heading--binding-endpoints-within-a-bundle).

The `deploy` command also allows for the specification of a constraint. Here is an example of doing this with spaces:

``` text
juju deploy mysql -n 2 --constraints spaces=database
```

See [Adding a machine with constraints](/t/using-constraints/1060#adding-a-machine-with-constraints) for an example of doing this with spaces.

You can also declare an endpoint for spaces that is not used with relations, see [Extra-bindings](/t/charm-metadata/1043#heading--extra-bindings-field).

<h3 id="heading--spaces-example">Spaces example</h3>

This example will have MAAS as the backing cloud and use the following criteria:

-   DMZ space (with 2 subnets, one in each zone), hosting 2 units of the haproxy application, which is exposed and provides access to the CMS application behind it.
-   CMS space (also with 2 subnets, one per zone), hosting 2 units of mediawiki, accessible only via haproxy (not exposed).
-   Database (again, 2 subnets, one per zone), hosting 2 units of mysql, providing the database backend for mediawiki.

First, ensure MAAS has the necessary subnets and spaces. Each subnet has the "automatic public IP address" attribute enabled on each:

-   172.31.50.0/24, for space "database"
-   172.31.51.0/24, for space "database"
-   172.31.100.0/24, for space "cms"
-   172.31.110.0/24, for space "cms"
-   172.31.0.0/20, for the "dmz" space
-   172.31.16.0/20, for the "dmz" space

Recall that MAAS has native knowledge of spaces. They are created within MAAS and Juju will become aware of them when the Juju controller is built (`juju bootstrap`).

Second, add the MAAS cloud to Juju. See [Using a MAAS cloud](/t/using-maas-with-juju/1094) for guidance.

Third, create the Juju controller, assuming a cloud name of 'maas-cloud':

``` text
juju bootstrap maas-cloud
```

Finally, deploy the applications into their respective spaces (here we use the constraints method), relate them, and expose haproxy:

``` text
juju deploy haproxy -n 2 --constraints spaces=dmz
juju deploy mediawiki -n 2 --constraints spaces=cms
juju deploy mysql -n 2 --constraints spaces=database
juju add-relation haproxy mediawiki
juju add-relation mediawiki mysql
juju expose haproxy
```

Once all the units are up, you will be able to get the public IP address of one of the haproxy units (from `juju status`), and open it in a browser, seeing the mediawiki page.

<h2 id="heading--trusting-an-application-with-a-credential">Trusting an application with a credential</h2>

Some applications may require access to the backing cloud in order to fulfill their purpose (e.g. storage-related tasks). In such cases, the remote credential associated with the current model would need to be shared with the application. When the operator allows this to occur the application is said to be *trusted*. An application can be trusted during deployment or after deployment.

To trust the AWS integrator application during deployment:

```text
juju deploy --trust cs:~containers/aws-integrator
```

To trust the application after deployment:

```text
juju deploy cs:~containers/aws-integrator
juju trust aws-integrator
```
