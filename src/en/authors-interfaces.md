[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Interfaces

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

Although we have described above that interfaces arrive by convention, there are
several well-used interfaces which have enough implementations to define a
defacto standard.

Below is a list of the interfaces for which we have compiled documentation and
reference implementations.

  - [ mysql ](/interface-mysql.html) - the database interface used by MySQL and client services.

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

