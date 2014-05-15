# Charm metadata

The only file that must be present in a charm is `metadata.yaml`, in the root
directory. A metadata file must be a valid yaml dictionary, containing at least
the following fields:

  - `name` is the charm name, which is used to form the charm URL. It must
  contain only `a-z`, `0-9`, and `-`; must start with `a-z`; must not end
  with a `-`; and may only end with digits if the digits are _not_ directly
  preceded by a space. Stick with names like `foo` and `foo-bar-baz` and you
  needn't pay further attention to the restrictions.
  - `summary` is a one-line description of the charm.
  - `description` is a long-form description of the charm and its features.
  It will also appear in the juju GUI.

Here's a valid metadata file:

    name: minecraft
    summary: Minecraft Server
    description: |
      Will deploy OpenJDK 6 JRE and the latest Minecraft server

With only those fields, a metadata file is valid, but not very useful. Charms
for use in the Charm Store should always set the following fields as well, for
categorization and display in the GUI:

  - `maintainer` is the name and email address for the main point of contact
  for the development and maintenance of the charm. Or, at least, it should be:
  in frequent practice, it's just a name. Please update your charms as you get
  the opportunity.
  - `categories` is a list containing one or more of the following:
    - applications
    - app-servers
    - cache-proxy
    - databases
    - file-servers
    - misc

In almost all cases, only one category will be appropriate. The categories help
keep the Charm Store organised.

Finally, a metadata file defines the charm's relations, and whether it's
designed for deployment as a
[subordinate service](./authors-subordinate-services.html).

  - `subordinate` should be set to true if the charm is a subordinate. If omitted, the charm will be presumed not to be subordinate.
  - `provides`, `requires`, and `peers` define the various relations the charm will participate in.
  - if the charm is subordinate, it must contain at least one `requires` relation with container scope.

Other field names should be considered to be reserved; please don't use any not
listed above to avoid issues with future versions of Juju.

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
