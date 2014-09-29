# Relationships


## Simple relations

The `provides` and `requires` keys are used to define pairings of charms that
are likely to be fruitful. Consider a simple mongodb charm's metadata:

    name: my-mongodb
    ...
    provides:
      server: mongodb

...and that of a simple node.js application charm:

    name: my-node-app
    ...
    requires:
      database: mongodb
    provides:
      website: http

Put together, these files indicate that a relation can be made between services
running the respective charms. The my-mongodb charm `provides` a relation named
`server` with the `mongodb` interface, and the my-node-app charm `requires` a
relation named `database` with the `mongodb` interface.

The my-node-app charm also `provides` a relation named `website` with the `http`
interface, but that's irrelevant to the mongodb charm. (But an haproxy charm
might well define, say, `reverseproxy`, that `requires` the `http` interface
provided by my-node-app.)


## Relation interfaces

An interface is a string that must only contain `a-z` and `-`, and neither start
nor end with `-`. It's the single determiner of compatibility between charms;
and it carries with it nothing more than a mutual promise that the provider and
requirer somehow know the communication protocol implied by the name.

So, the relation namespace is essentially unrestricted (with one enforced
exception: you may not _provide_ a relation named `juju`, or starting with
`juju-`). This allows for rapid development in some situations; but, in the
example above, there is a potential problem: we've picked _two_ interface names
that already have meanings in the charm ecosystem, and that means we have to be
[compatible](./authors-charm-interfaces.html); but that's a concern for a bit
later, when we're actually writing the relation hooks.

## Peer relations

Alongside `provides` and `requires`, charms can declare relations under `peers`.
Where `provides` relations integrate with `requires` ones, such that providers
respond to requirers and vice versa, the `peers` relation causes each unit of a
single service to respond to the other units in the same service. A peer
relation is otherwise defined in exactly the same way as any other relation.

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
  [Subordinate](authors-charm-subordinates.html) charms are only valid if they
  have at least one `requires` relation with `container` scope.

  - `limit` is ignored by juju, but if present should be a positive integer N
  indicating that the charm is not designed to use this interface in more than N relations at once.
  For example, if you're writing a really simple exploratory charm for your
  particular data store, you could just create a single shared store and write
  the same access credentials for every relation. A limit of 1 is thus useful
  in that it does _document_ the restriction, even though it's not automatically
  enforced today.

  - `optional` is ignored by juju, but if present should only be set to true,
  on `requires` relations, to indicate that the charm can still function
  effectively without having those relations added. For example, the my-node-app
  charm might also define:

        requires:
          database: mongodb
          memcache:
            interface: memcached
            optional: true

  ...to indicate that it can integrate with memcached if it's available, but that
  it can't be expected to do anything useful without a mongodb service available.

  - `gets` and `sets` are ignored by juju at present, but are valuable
  [documentation](./authors-charm-interfaces.html).

## Sample metadata.yaml files

The MySQL charm metadata:

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

# Creating Relationships

One of the best aspects of juju is how dead-simple it is to write a charm. You
write a handful of hooks in your favorite language and then go to town. However,
there's a subtle hump in the charming learning curve... interfaces.

Interface names are what juju checks when trying to determine if two services
can be related. For example, wordpress's `metadata.yaml` contains:

    requires:
      database:
        interface: mysql

which is a statement that wordpress has a relation that's locally named
"database" which is an implementation of the "mysql" interface.

Mysql's `metadata.yaml` contains a not-too-surprising:

    provides:
      db:
        interface: mysql

When services are related, Juju decides which hooks to call within each charm
based on this local relation name. When wordpress is related to mysql, the
"database-relation-joined, database-relation-changed, etc" hooks are called on
the wordpress end. Corresponding hooks will be called on the mysql end "db-
relation-joined, db-relation-changed" (based on the mysql relation names).

Juju decides which services can be related based on the interface names only.
They have to match.

At the end of the day, what's a juju interface? Simply a name.

Now, having gotten that out of the way, there is an _implicit_ notion of an
interface that charmers have to pay attention to in addition to just matching
names.

In some sense, relations are two-way channels of communications between
services. They're not actually talking directly, the agents communicate via the
state server, but it helps to think of it as direct communication between the
services. Relation hooks can call tools such as `relation-get` and `relation-
set` to pass information back and forth between the service endpoints.

For example, wordpress and mysql might have a conversation like the following:

    wordpress:
      I'm here and my service name is "wordpress"
    mysql:
      I'm here, let me create a db for you
      your database/schema name is "wordpress"
      your credentials are "admin/pass1234"
      you access the db on "my.host.addr:port"
    wordpress:
      cool, let me write the wordpress config files needed to access that database (and bounce the server to pick up those changes)
      later
    mysql:
      cool, later

We'll go over some more detailed versions of this, but this is the high-level
conversation that occurs between two services when they are related in a
relation implementing the `mysql` interface.

At first glance, it would appear that the _interface_ called `mysql` might be
defined simply by the set of variables that get passed along the channel.
Something like:

    interface:
      name: mysql
      variables_set:
        - service_name
        - database_host
        - database_port
        - database_name
        - database_user
        - database_password
        - encoding

but really, that's not complete. In fact, it's not even enough information to
implement hooks for a new service that needs to talk to mysql. The timing and
sequencing are critical components of this conversation! They can't be left out.

So let's dig a little deeper into this interface. Consider only the `relation-
joined` and `relation-changed` hooks for now. The remaining `broken` and
`departed` hooks are covered elsewhere.

Actually, if we start from provisioning, the hooks that are called for wordpress
are

    # juju deploy wordpress
    install
    config-changed
    start
    # juju add-relation wordpress mysql
    database-relation-joined
    database-relation-changed

similarly, for mysql

    # juju deploy mysql
    install
    config-changed
    start
    # juju add-relation wordpress mysql
    db-relation-joined
    db-relation-changed

and we can fill in a little of what the relation hooks are doing

    # wordpress
    database-relation-joined
      <no-op>
    database-relation-changed
      relation-get database_name, creds, host/port
      write config for wordpress
      bounce wordpress
    # mysql
    db-relation-joined
      relation-get service-name
      create db, creds
      relation-set db, creds, host/port
    database-relation-changed
      <no-op>

_This_ conversation is the actual interface.

## Interface Documentation

Although we have described above that interfaces arrive by convention, there are several well-used interfaces which have enough implementations to define a
defacto standard.

Below is a list of the interfaces for which we have compiled documentation and
reference implementations.

  - [ mysql ](/interface-mysql.html) - the database interface used by MySQL and client services.
