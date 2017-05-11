Title: Implementing Relations in Juju charms  

# What is a relation?

Relationships in Juju are a loosely typed definition of how applications
should interact with one another. The definition of a relationship is handled
through an interface, and does not restrict the user to a traditional RFC
approach.

As previously stated, relationships are 'loosely typed' - which means there is
no de-facto specification for:

- What information a relationship must send/receive
- What actions are to be taken with data sent/received over the wire

With that being said, picking an interface is a strong statement; you need to
set the same settings as do all the other charms with the same role for the
interface; and you should only expect to be able to read those settings set by
the other charms with the counterpart role.

Juju decides which applications can be related based on the interface names
only. They have to match.

## Relation Composition

### Provides and Requires

The `provides` and `requires` keys defined in
[metadata.yaml](./authors-charm-metadata.html) are used to define pairings of charms
that are likely to be fruitful. Consider mongodb's metadata:

```no-highlight
name: mongodb
...
provides:
  database:
    interface: mongodb
```

...and that of the node.js charm:

```no-highlight
name: my-node-app
...
requires:
  database:
    interface: mongodb
provides:
  website:
    interface: http
```

Put together, these files indicate that a relation can be made between
applications. The mongodb charm `provides` a relation named `database` with
the `mongodb` interface, and the my-node-app charm `requires` a relation named
`database` with the `mongodb` interface.

The my-node-app charm also `provides` a relation named `website` with the `http`
interface, but that's irrelevant to the mongodb charm. (But an haproxy charm
might well define, say, `reverseproxy`, that `requires` the `http` interface
provided by my-node-app.)


## Relation interfaces

An interface name is a string that must only contain characters `a-z` and `-`,
and neither start nor end with `-`. It's the single determiner of compatibility
between charms; and it carries with it nothing more than a mutual promise that
the provider and requirer somehow know the communication protocol implied by
the name.

So, the relation namespace is essentially unrestricted (with one enforced
exception: you may not _provide_ a relation named `juju`, or starting with
`juju-`). This allows for rapid development in some situations; but, in the
example above, there is a potential problem: we've picked _two_ interface names
that already have meanings in the charm ecosystem, and that means we have to be
compatible. That's a concern for later, when we're actually writing the
relation hooks.

### Peers

Charms can declare relations under `peers` which causes each unit of a
single application to respond to the other units in the same application. A
peer relation is defined in exactly the same way as any other relation.

Looking at the MongoDB peering relationship, we see the charm defines
`replica-set` as the relationship, with the interface `mongodb-replica-set`

```yaml
peers:
  replica-set:
    interface: mongodb-replica-set
```

As outlined in the relationship - peering relationships are particularly useful
when your application supports clustering. Think about the implications of
applications such as MongoDB, PostgreSQL, and ElasticSearch where clusters
must exchange information amongst one another to perform proper clustering.


## Configuring relations

There's an alternative syntax for specifying relations, which allows you to set
additional fields by replacing the interface name with a dictionary. In this
case, the `interface` key must be specified explicitly, and a number of other
possibilities become available:

- `scope` defaults to `global`, but may be set to `container`. The scope
controls the set of remote units that are reported to the unit as members of
the relation: container-scoped relations are restricted to reporting details
of a single principal unit to a single subordinate, and vice versa, while
global relations consider all possible remote units.
[Subordinate](./authors-subordinate-applications.html) charms are only valid if they
have at least one `requires` relation with `container` scope.

- `limit` is ignored by Juju, but if present should be a positive integer N
indicating that the charm is not designed to use this interface in more than N
relations at once.

For example, if you're writing a really simple exploratory charm for your
particular data store, you could just create a single shared store and write
the same access credentials for every relation. A limit of 1 is thus useful
in that it does _document_ the restriction, even though it's not automatically
enforced today.

- `optional` is ignored by Juju, but if present should only be set to true,
on `requires` relations, to indicate that the charm can still function
effectively without having those relations added. For example, the my-node-app
charm might also define:

```yaml
requires:
  database:
    interface: mongodb
  memcache:
    interface: memcached
    optional: true
```

...to indicate that it can integrate with memcached if it's available, but that
it can't be expected to do anything useful without a MongoDB application available.


## Relationship Execution in Charms

When applications are related, Juju decides which hooks to call within each
charm based on this local relation name. When WordPress is related to MySQL,
the "database-relation-joined, database-relation-changed, etc" hooks are
called on the WordPress end. Corresponding hooks will be called on the 'mysql'
charm "db- relation-joined, db-relation-changed" (based on the 'mysql'
relation names).


# Authoring Charm Interfaces

Relations are basically a bidirectional channel of communication between
applications. They're not actually talking directly, the agents communicate
via the state server, but it helps to think of it as direct communication
between the applications. Relation hooks can call tools such as `relation-get`
and `relation- set` to pass information back and forth between the application
endpoints.

### Pseudo Relationship Talk

For example, `wordpress` and `mysql` might have a conversation like the following:

```no-highlight
wordpress:
  I'm here and my application name is "wordpress"
mysql:
  I'm here, let me create a db for you
  your database/schema name is "wordpress"
  your credentials are "admin/pass1234"
  you can access the db on "my.host.addr:port"
wordpress:
  let me write the wordpress config files needed to access that
  database (and bounce the server to pick up those changes)
  bye
mysql:
  see-ya
```

We'll go over some more detailed versions of this, but this is the high-level
conversation that occurs between two applications when they are related in a
relation implementing the `mysql` interface.

At first glance, it would appear that the _interface_ called `mysql` might be
defined simply by the set of variables that get passed along the channel.
Something like:

```no-highlight
interface:
  name: mysql
  variables_set:
    - database_host
    - database_port
    - database_name
    - database_user
    - database_password
    - encoding
```

but really, that's not complete. In fact, it's not even enough information to
implement hooks for a new application that needs to talk to MySQL. The timing
and sequencing are critical components of this conversation! They can't be
left out.

So let's dig a little deeper into this interface. Consider only the `relation-
joined` and `relation-changed` hooks for now. The remaining `broken` and
`departed` hooks are covered elsewhere.

Actually, if we start from provisioning, the hooks that are called for 'wordpress'
are:

```no-highlight
# juju deploy wordpress
install
config-changed
start
# juju add-relation wordpress mysql
database-relation-joined
database-relation-changed
```

similarly, for 'mysql':

```no-highlight
# juju deploy mysql
install
config-changed
start
# juju add-relation wordpress mysql
db-relation-joined
db-relation-changed
```

and we can fill in a little of what the relation hooks are doing:

```no-highlight
# wordpress
database-relation-joined
  <no-op>
database-relation-changed
  relation-get database_name, creds, host/port
  write config for wordpress
  bounce wordpress
# mysql
db-relation-joined
  relation-get application-name
  create db, creds
  relation-set db, creds, host/port
database-relation-changed
  <no-op>
```

_This_ conversation is the actual interface.


## Sample metadata.yaml files

The 'mysql' charm metadata:

```yaml
name: mysql
summary: MySQL is a fast, stable and true multi-user, multi-threaded SQL database
maintainer: Marco Ceppi
description: |
MySQL is a fast, stable and true multi-user, multi-threaded SQL database
server. SQL (Structured Query Language) is the most popular database query
language in the world. The main goals of MySQL are speed, robustness and
ease of use.
categories:
- databases
provides:
  db:
    interface: mysql
  db-admin:
    interface: mysql-root
  shared-db:
    interface: mysql-shared
  master:
    interface: mysql-oneway-replication
  munin:
    interface: munin-node
  monitors:
    interface: monitors
  local-monitors:
    interface: local-monitors
    scope: container
peers:
    cluster:
      interface: mysql-ha
requires:
    slave:
      interface: mysql-oneway-replication
    ceph:
      interface: ceph-client
    ha:
      interface: hacluster
      scope: container
```


## Interface Documentation

Although we have described above that interfaces arrive by convention, there
are several well-used interfaces which have enough implementations to define a
defacto standard.

Below is a list of the interfaces for which we have compiled documentation and
reference implementations:

- [ mysql ](interface-mysql.html) - the database interface used by MySQL and
client services.
