The `network-get` hook tool allows charms to discover important network related information. There are 2 key things a charm needs to know about its local units:

1.  What address to bind to
2.  What address to use to connect to the workload of an external source (i.e. the ingress address of that external source)

For remote units, a charm needs to know:

1.  What address to use connect to the workload from an external source
2.  The egress subnets for incoming traffic

Both ingress address and egress subnets may vary depending on the relation. This is because if the relation is cross model, the ingress address is the public / floating address of the unit to allow ingress from outside the model. And a given relation may see traffic originate from different egress subnets.

The space bindings for a given endpoint also affect that address information. Juju will take this into account when populating the address information below.

<h2 id="heading--network-get">network-get</h2>

The `network-get` hook tool is used to get networking information about the local unit.

`network-get` is relation aware. As with other hook tools, it is either run in a relation context or accepts a relation id passed using the `-r` switch. It may also be run outside of a relation context, in which case only the binding address information is relevant.

By default it prints a block of YAML with the 3 pieces of address information:

-   binding address(es)
-   ingress address(es)
-   egress subnets

Flags may be used to request only a specific address value.

Usage:

`network-get [options] <binding-name> [--ingress-address] [--bind-address] [--egress-subnets]`

Summary:

``` text
get network config

Options:
--bind-address  (= false)
    get the address for the binding on which the unit should listen
--egress-subnets  (= false)
    get the egress subnets for the binding
--format  (= smart)
    Specify output format (json|smart|yaml)
--ingress-address  (= false)
    get the ingress address for the binding
-o, --output (= "")
    Specify an output file
--primary-address  (= false)
    (deprecated) get the primary address for the binding
-r, --relation  (= )
    specify a relation by id
```

Details:

``` text
network-get returns the network config for a given binding name. By default
it returns the list of interfaces and associated addresses in the space for
the binding, as well as the ingress address for the binding. If defined, any
egress subnets are also returned.
If one of the following flags are specified, just that value is returned.
If more than one flag is specified, a map of values is returned.

--bind-address: the address the local unit should listen on to serve
connections, as well as the address that should be advertised to its peers.

--ingress-address: the address the local unit should advertise as being
used for incoming connections.

--egress_subnets: subnets (in CIDR notation) from which traffic on this
relation will originate.
```

<h3 id="heading--examples">Examples</h3>

<h4 id="heading--deploy-mysql-in-an-aws-model-with-no-relation-context">Deploy MySQL in an AWS model with no relation context</h4>

To deploy MySQL in an AWS model with no relation context:

``` text
juju run --unit mysql/1 "network-get --format yaml db"
```

Output:

``` yaml
bind-addresses:
- macaddress: ""
  interfacename: ""
  addresses:
  - address: 10.136.107.33
    cidr: ""
ingress-addresses:
- 10.136.107.33
```

<h4 id="heading--deploy-mediawiki-in-a-local-cloud-model">Deploy MediaWiki in a local cloud model</h4>

To deploy MediaWiki in a local cloud model. Relate to mysql using relation `--via` to explicitly specify an egress subnet on the relation:

``` text
juju relate mediawiki:db ianaws:admin/default.mysql --via 69.192.151.51/32
```

In the mysql model, we can see the offer connections.

``` text
juju switch ianaws:default
juju offers 
```

Output:

``` text
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress subnets
mysql  admin  2            joined  db        mysql      provider  69.193.151.51/32
```

On the AWS mysql model, the relation id is 'db:2', or simply just '2', for the mediawiki relation.

Let's get address information for a local unit:

``` text
juju run --unit mysql/1 "network-get --format yaml db -r db:2"
```

The endpoint prefix to relation id is optional, so this works as well:

``` text
juju run --unit mysql/1 "network-get --format yaml db -r 2"
```

Output:

``` yaml
bind-addresses:
- macaddress: ""
  interfacename: ""
  addresses:
  - address: 10.136.107.33
    cidr: ""
ingress-addresses:
- 54.237.63.211
```

Note that the ingress address is now set to the public address, since for this relation ingress will be from an external source:

``` text
juju run --unit mysql/1 "network-get --format yaml db -r db:2 --ingress-address"
```

Output:

``` text
54.237.63.211
```

The egress subnets for the remote unit are obtained using `relation-get`. This takes the name of the remote unit for which to get the relation data. When run in a relation context, the remote unit is $JUJU_REMOTE_UNIT. Outside of a relation context, we can use `relation-list` to get the remote unit (for this example there is only one):

``` text
juju run --unit mysql/1 "relation-get -r db:2 egress-subnets `relation-list -r db:2`"
```

Output:

``` text
69.193.151.51/32
```

To get the ingress address of the remote unit. Because the test model is using a local LXD cloud, we only get a 10.x.x.x address; ingress from an AWS cloud to a local LXD cloud isn't supported in this case, but the example illustrates how a charm can get the ingress address of the remote unit:

``` text
juju run --unit mysql/1 "relation-get -r db:2 ingress-address `relation-list -r db:2`"
```

Output:

``` text
10.200.103.121
```

On the model hosting mediawiki:

``` text
juju run --unit mediawiki/0 "relation-get -r 0 - mysql/1"
```

Output:

``` text
database: remote-8193c748ad3c4f6382c7baeb44dcb2f3
egress-subnets: 54.237.63.211/32
host: 10.136.107.33
ingress-address: 54.237.63.211
password: dahlahbouchoose
private-address: 54.237.63.211
slave: "False"
user: sieyaijeediohie
```

Note the correct ingress-address is given to allow mediawiki to know how to reach mysql in the offering model. As we retain private-address for backwards compatibility.

So long as charms evolve to use these new primitives to access the key address values, they will work in both cross model and non cross model scenarios.
