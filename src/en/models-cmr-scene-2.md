Title: CMR scenario #2
TODO:  Update 'juju status' output to show release versions
       Review required

# CMR scenario #2

This page refers to [Cross model relations][models-cmr]. See that page for
background information.

In this example, we *supply* a CMR infrastructure "out of the box" with a few
nimble commands and then proceed to query, poke, analyse, and finally extend it
by addressing firewall concerns.

This scenario describes a MediaWiki deployment, based upon multiple (LXD)
controllers, used by a non-admin user, and consumed by a single model.

## Build the infrastructure

The infrastructure is built in this way:

```bash
juju bootstrap localhost lxd-cmr-1
juju add-model cmr-model-1
juju deploy mysql
juju offer mysql:db
juju bootstrap localhost lxd-cmr-2
juju add-model cmr-model-2
juju deploy mediawiki
juju add-relation mediawiki:db lxd-cmr-1:admin/cmr-model-1.mysql
```

## juju status

The `juju status` command provides a summary of what offers have been made.
Here we'll apply it to the model 'cmr-model-1' in the 'lxd-cmr-1' controller:

```bash
juju status -m lxd-cmr-1:cmr-model-1
```

Output:

```no-highlight
Model        Controller  Cloud/Region         Version      SLA
cmr-model-1  lxd-cmr-1   localhost/localhost  2.3-beta2.1  unsupported

App    Version  Status  Scale  Charm  Store       Rev  OS      Notes
mysql  5.7.19   active      1  mysql  jujucharms   58  ubuntu

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/0*  active    idle   0        10.87.144.223   3306/tcp  Ready

Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.87.144.223  juju-22a641-0  xenial      Running

Offer  Application  Charm  Rev  Connected  Endpoint  Interface  Role
mysql  mysql        mysql  58   1/1        db        mysql      provider

Relation provider  Requirer       Interface  Type  Message
mysql:cluster      mysql:cluster  mysql-ha   peer
```

In the 'Offer' section, the 'Connected' column shows the number of active
connections to the offer and the total number of connections/relations
(including those suspended).

## juju offers

The `juju offers` command (alias `juju list-offers`) shows similar information.
However, it also allows for several formats, each of which displays different
kinds of information.

The 'summary' format provides information very similar to that gained via the
`juju status` command (it adds the offer URL):

```bash
juju offers --format summary
```

Output:

```no-highlight
Offer  Application  Charm        Connected  Store      URL                      Endpoint  Interface  Role
mysql  mysql        cs:mysql-58  1/1        lxd-cmr-1  admin/cmr-model-1.mysql  db        mysql      provider
```

The 'yaml' format shows additional information, such as who is allowed to
access the offer and what ingress subnets are required to allow traffic from
the consuming model:

```bash
juju offers -m lxd-cmr-1:cmr-model-1 --format yaml
```

Output:

```no-highlight
mysql:
  application: mysql
  store: lxd-cmr-1
  charm: cs:mysql-58
  offer-url: admin/cmr-model-1.mysql
  endpoints:
    db:
      interface: mysql
      role: provider
  connections:
  - source-model-uuid: e0aaf3d9-0547-4ec3-8106-75615e48a419
    username: admin
    relation-id: 1
    endpoint: db
    status:
      current: joined
      since: 4 hours ago
    ingress-subnets:
    - 10.87.144.189/32
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read
```

The 'tabular' format (the default) shows each relation (connection) to the
offer from the consuming model:

```bash
juju offers -m lxd-cmr-1:cmr-model-1
```

Output:

```no-highlight
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress subnets
mysql  admin  1            joined  db        mysql      provider  10.87.144.189/32
```

!!! Note:
    This command can also filter what offers are included in the result. Note
    that, for brevity, the scenario model is not specified in the below
    examples.

To list all offers for a given application:

```bash
juju offers --application mysql
```

To list all offers for a given interface:

```bash
juju offers --interface mysql
```

To list all offers for a given user who has created a relation to the offer:

```bash
juju offers --connected-user <user name>
```

To list all offers for a given user who can consume the offer:

```bash
juju offers --format summary --allowed-consumer <user name>
```

The above command is best run with `--format summary` as the intent is to see,
for a given user, what offers they might relate to, regardless of whether there
are existing relations (which is what the tabular view shows).

To list a specific offer:

```bash
juju offers mysql
```

## juju show-offer

The `juju show-offer` command gives details about a specific offer:

```bash
juju show-offer lxd-cmr-1:admin/cmr-model-1.mysql
```

Output:

```no-highlight
Store      URL                      Access  Description                                    Endpoint  Interface  Role
lxd-cmr-1  admin/cmr-model-1.mysql  admin   MySQL is a fast, stable and true multi-user,   db        mysql      provider
                                            multi-threaded SQL database server. SQL
                                            (Structured Query Language) is the most
                                            popular database query language in the world.
                                            The ma...
```

Notice how this command takes the offer URL as the argument. The controller
portion ('lxd-cmr-1') can be omitted if the current controller contains the
offer. In the same vein, if the offer resides in the current model then just
the short name can be used ('cmr-model-1.mysql').

For more details, including which users can access the offer, use the 'yaml'
format.

A non-admin user with read/consume access can also view an offer's details, but
they won't see user ACL information.

## juju find-offers

Offers can be searched based on various criteria:

 - URL (or part thereof)
 - offer name
 - model name
 - interface name

The results will show information about the offer, including the ACL
permissions (of the user making the query).

To find all offers on controller `lxd-cmr-1`:

```bash
juju find-offers lxd-cmr-1:
```

Output:

```no-highlight
Store      URL                      Access  Interfaces
lxd-cmr-1  admin/cmr-model-1.mysql  admin   mysql:db
```

The 'yaml' format will display extra information, including users who can
access the offer (if an admin is making the query). Below we show this, in
addition to searching by offer name:

```bash
juju find-offers lxd-cmr-1: --offer mysql --format yaml
```

Output:

```no-highlight
lxd-cmr-1:admin/cmr-model-1.mysql:
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

To find offers in model `cmr-model-1` on controller `lxd-cmr-1`:

```bash
juju find-offers lxd-cmr-1:cmr-model-1
```

## Relating to offers from behind a firewall

Let the consuming model in this scenario be protected by a firewall that NATs
all outgoing traffic to the single IPv4 address of 69.32.56.10/32.

Here, the admin on the offering side decided to create a whitelist consisting
of a range of addresses known to cover the consuming side:

```bash
juju set-firewall-rule juju-application-offer --whitelist 69.32.0.0/16
```

Now request to have the single NAT address contact the offer:

```bash
juju add-relation mediawiki:db lxd-cmr-1:admin/cmr-model-1.mysql --via 69.32.56.10/32
```


<!-- LINKS -->

[models-cmr]: ./models-cmr.html
