Title: CMR scenario #2

# CMR scenario #2

This page refers to [Cross model relations][models-cmr]. See that page for
background information.

In this example, we *supply* a CMR infrastructure "out of the box" with a few
nimble commands and then proceed to query, poke, analyse, and finally extend it
by exploring multi-user functionality and firewall concerns.

This scenario describes a MediaWiki deployment, based upon multiple (LXD)
controllers, used by a non-admin user, and consumed by a single model.

## Build the infrastructure

The infrastructure is built in this way:

```bash
juju bootstrap localhost ctrl1
juju deploy mysql
juju offer mysql:db
juju bootstrap localhost ctrl2
juju deploy mediawiki
juju relate mediawiki:db ctrl1:admin/default.mysql
```

### Viewing offers summary

Offer summary information shows up in status.

```bash
juju status
```

```no-highlight
Model    Controller  Cloud/Region   Version       SLA
default  ianaws      aws/us-east-1  2.3-alpha1.1  unsupported

App    Version  Status  Scale  Charm  Store       Rev  OS      Notes
mysql  5.5.57   active      1  mysql  jujucharms   57  ubuntu  

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/1*  active    idle   1        54.237.63.211   3306/tcp  Ready

Machine  State    DNS            Inst id              Series  AZ Message
1        started  54.237.63.211  i-0e819d97de8943e38  trusty  us-east-1b running

Offer  Application  Charm  Rev  Connected  Endpoint  Interface  Role
mysql  mysql        mysql  57   1/1        db        mysql      provider

Relation provider  Requirer       Interface  Type  Message
mysql:cluster      mysql:cluster  mysql-ha   peer  
```

The connected counts show the number of active connections to the offer and the
total number of connections including those suspended.

### Viewing offers and any connections

There's also a list-offers command. The summary format shows the same
information as in status.

```bash
juju offers --format summary
```

```no-highlight
Offer  Application  Charm        Connected  Store   URL 		 Endpoint  Interface  Role
mysql  mysql        cs:mysql-57  1/1        ianaws  admin/default.mysql  db  	   mysql      provider
```

The YAML format shows additional information, such as who is allowed to access
the offer (see managing offer access) and what ingress subnets are required to
allow traffic from the consuming model.

```bash
juju offers --format yaml
```

```no-highlight
mysql:
  application: mysql
  store: ianaws
  charm: cs:mysql-57
  offer-url: admin/default.mysql
  endpoints:
    db:
      interface: mysql
      role: provider
  connections:
  - source-model-uuid: b9d3db4c-49c9-4802-8269-a9b03216fc34
    username: admin
    relation-id: 2
    endpoint: db
    status:
      current: joined
      since: 1 hour ago
    ingress-subnets:
    - 69.193.151.51/32
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read
```

The tabular format (the default) shows each relation (connection) to the offer
from a consuming model.

```bash
juju offers
```

```no-highlight
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress subnets
mysql  admin  2            joined  db        mysql      provider  69.193.151.51/32
```

The list offers command can filter the offers included in the result.

All offers for a given application:

```bash
juju offers --application mysql
```

All offers for a given interface:

```bash
juju offers --interface mysql
```

All offers for a given user who has related to the offer:

```bash
juju offers --connected-user fred
```

All offers for a given user who can consume the offer:

```bash
juju offers --format summary --allowed-consumer mary 
```

The above command is best run with --format summary as the intent is to see,
for a given user, what offers they might relate to, regardless of whether there
are existing relations (which is what the tabular view shows).

A specific offer:

```bash
juju offers mysql
```

### Viewing offers details

The show-offer command gives details about a given offer.

```bash
juju show-offer default.mysql
```

```no-highlight
Store   URL                  Access  Description 				   Endpoint  Interface  Role
ianaws  admin/default.mysql  admin   MySQL is a fast, stable and true multi-user,  db        mysql      provider
                                     multi-threaded SQL database server. SQL                             
                                     (Structured Query Language) is the most                             
                                     popular database query language in the world.                       
                                     The ma...                                                           
```

For more details, including which users can access the offer, the YAML
format.

```bash
juju show-offer default.mysql --format yaml
```

```no-highlight
ianaws:admin/default.mysql:
  description: |
    MySQL is a fast, stable and true multi-user, multi-threaded SQL database
    server. SQL (Structured Query Language) is the most popular database query
    language in the world. The main goals of MySQL are speed, robustness and
    ease of use.
  access: admin
  endpoints:
    db:
      interface: mysql
      role: provider
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read
```

A non-admin user with read/consume access can also view an offer's details, but
they won't see the information for users with access.

## Finding offers to use

Offers can be searched based on various criteria:
URL (or part thereof)
offer name
model name
interface

The results will show information about the offer, including the level of
access the user making the query has on each offer.

To find all offers on a specified controller:

```bash
juju find-offers ian:
```

```no-highlight
Store  URL                         Access  Interfaces
ian    admin/default.hosted-mysql  admin   mysql:db
ian    admin/default.mysql-admin   admin   mysql-root:db-admin, mysql:db
ian    admin/default.postgresql    admin   pgsql:db
```

As with the list-offers command, the YAML output will show extra information,
including users who can access the offer (if an admin makes the query).

```bash
juju find-offers --offer hosted-mysql --format yaml
```

```no-highlight
ian:admin/default.hosted-mysql:
  access: admin
  endpoints:
    db:
      interface: mysql
      role: provider
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read
```

To find offers in a specified model:

```bash
juju find-offers admin/default
juju find-offers ian:admin/default
```

To find offers with a specified interface on the current controller:

```bash
juju find-offers --interface mysql
```

To find offers with a specified interface on a specific controller:

```bash
juju find-offers --interface mysql ian:
```

To find offers with "sql" in the name:

```bash
juju find-offers --offer sql ian:
```

### Relating to offers from behind a firewall

Sometimes, the consuming application is deployed behind a firewall where NAT is
used, such that traffic egresses via a different address/network to that on
which the consuming application is hosted.

In this case, the relate --via option is used to inform the offering side so
that the correct firewall rules can be set up.

```bash
juju relate mediawiki:db ian:admin/default.mysql --via 69.32.56.0/8
```

The --via value is a comma separated list of subnets in CIDR notation. This
includes the /32 case where a single NATed IP address is used for egress.

It's also possible to set up egress subnets as a model configuration value so
that all cross model relations use those subnets without needing to use the
`--via` option.

```bash
juju model-config egress-subnets=69.32.56.0/8
```

## Inspecting relations to an offer

The offers command is used to see all connections to one more offers.

```bash
juju offers mysql
```

```no-highlight
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress subnets
mysql  admin  2            joined  db        mysql      provider  69.193.151.51/32
```

The (default) tabular view shows the connected user and ingress subnets in user
with that connection. Use the YAML output to see extra detail such as the UUID
of the consuming model.

The list offers command can filter the offers included in the result.

All offers for a given application:

```bash
juju offers --application mysql
```

All offers for a given interface:

```bash
juju offers --interface mysql
```

All offers for a given user who has related to the offer:

```bash
juju offers --connected-user fred
```

All offers for a given user who can consume the offer:

```bash
juju offers --format summary --allowed-consumer mary 
```

The above command is best run with --format summary as the intent is to see,
for a given user, what offers they might relate to, regardless of whether there
are existing relations (which is what the tabular view shows).

A specific offer:

```bash
juju offers mysql
```


<!-- LINKS -->

[models-cmr]: ./models-cmr.html
