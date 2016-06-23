Title: Groups of applications  

# Grouping applications

Juju deploys units of an application from a charm. The simplest way to do this 
is

```bash
juju deploy mysql
```

which will take the latest version of the MySQL charm straight from the store
and create a single application unit.

By default, Juju creates a unit of an application named after the charm; `mysql` 
in the above example.

You can specify the name for the application when deploying:

```bash
juju deploy mysql wikidb
```

which will create a unit of the `wikidb` application. It creates the unit 
exactly as before, except instead of `mysql`, the application is called 
`wikidb`.

Why specify names for applications? The simplest reason is organizational. It 
lets you stay organized as your infrastructure gets more complex:

```bash
juju deploy mysql website-db
juju deploy mysql app-master-db
juju deploy mysql app-slave-db -n2
```

But there are other reasons to do this: application groups, which are nothing 
other than named applications. They are called out as a separate feature because 
they're quite useful in a few different ways.


## Roles

Some applications acquire a role at runtime based on the relations that are 
joined.

A great example of this is the hadoop charm. It can instantiate applications

```bash
juju deploy hadoop namenode
juju deploy hadoop datacluster -n40
```

which are identical at this point except for the application name that Juju's 
using for the various units.

These applications acquire roles at relation-time via

```bash
juju add-relation namenode:namenode datacluster:datanode
juju add-relation namenode:jobtracker datacluster:tasktracker
```

The relations determine the application role.

Another example of this is mysql replication.

```bash
juju deploy mysql masterdb
juju deploy mysql slavedb -n2
```

where the different applications are related to each other

```bash
juju add-relation masterdb:master slavedb:slave
```

and to other applications via

```bash
juju deploy mediawiki mywiki
juju add-relation mywiki:db masterdb:db
juju add-relation mywiki:slave slavedb:db
```


## Upgrade Groups and/or Config Groups

There are also interesting use-cases for breaking large applications down into
separate groups of units. Instead of a single 5000-node hadoop application named
_hadoop-slave_, you might build that cluster from multiple smaller application
groups.

```bash
juju deploy hadoop hadoop-master
juju deploy hadoop hadoop-slave-A -n2500
juju deploy hadoop hadoop-slave-B -n2500
juju add-relation hadoop-master:namenode hadoop-slave-A:datanode
juju add-relation hadoop-master:namenode hadoop-slave-B:datanode
...
```

These application groups can be managed independently by Juju for upgrades and
configuration

```bash
juju set hadoop-slave-B some_param=new_value
```

This technique can potentially be a way for Juju to manage rolling upgrades for
an application. Of course, this depends heavily on the applications in question 
and how well they support version management, schema changes, etc.
