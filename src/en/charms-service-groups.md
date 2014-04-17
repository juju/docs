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

# Groups of Services

Juju deploys units of a service from a charm. The simplest way to do this is

    juju deploy mysql

which will take the latest version of the mysql charm straight from the store
and create a single service unit.

By default, juju creates a unit of a service named after the charm; `mysql` in
the above example.

You can specify the name for the service when deploying

    juju deploy mysql wikidb

which will create a unit of the `wikidb` service. It creates the unit exactly as
before, except instead of `mysql`, the service is called `wikidb`.

Why specify names for services? The simplest reason is organizational... it lets
you stay organized as your infrastructure gets more complex:

    juju deploy mysql website-db
    juju deploy mysql app-master-db
    juju deploy mysql app-slave-db -n2

But there're other reasons to do this - service groups. Really service groups
are nothing other than named services. They're called out as a separate feature
because they're quite useful in a few different ways.

## Roles

Some services acquire a role at runtime based on the relations that are joined.

A great example of this is the hadoop charm. It can instantiate services

    juju deploy hadoop namenode
    juju deploy hadoop datacluster -n40

which are identical at this point except for the service name that juju's using
for the various units.

The services these acquire roles at relation-time via

    juju add-relation namenode:namenode datacluster:datanode
    juju add-relation namenode:jobtracker datacluster:tasktracker

The relations determine the service role.

Another example of this is mysql replication.

    juju deploy mysql masterdb
    juju deploy mysql slavedb -n2

where the different services are related to each other

    juju add-relation masterdb:master slavedb:slave

and to other services via

    juju deploy mediawiki mywiki
    juju add-relation mywiki:db masterdb:db
    juju add-relation mywiki:slave slavedb:db

## Upgrade Groups and/or Config Groups

There are also interesting use-cases for breaking large services down into
separate groups of units. Instead of a single 5000-node hadoop service named
_hadoop-slave_, you might build that cluster from multiple smaller service
groups.

    juju deploy hadoop hadoop-master
    juju deploy hadoop hadoop-slave-A -n2500
    juju deploy hadoop hadoop-slave-B -n2500
    juju add-relation hadoop-master:namenode hadoop-slave-A:datanode
    juju add-relation hadoop-master:namenode hadoop-slave-B:datanode
    ...

These service groups can be managed independently by Juju for upgrades and
configuration

    juju set hadoop-slave-B some_param=new_value

This technique can potentially be a way for Juju to manage rolling upgrades for
a service. Of course, this depends heavily on the services in question and how
well they support version management, schema changes, etc.

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

