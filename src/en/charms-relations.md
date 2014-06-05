# Managing Relationships

Few services you might want to run can do so completely independently - most of
them rely on some other software components to be present and running too (e.g.
a database). There would be little point in Juju making it supremely easy to
deploy services if it didn't also make it easy to connect them up to services
they need to get running! The Juju magic in this case involves the **hooks**
built in to each charm which allow them to communicate. Unless you are writing
charms, there is no need to go into detail on hooks, but these are the parts
that make creating relationships between services so easy.

The charm for WordPress, for example, knows that it requires a database. It
therefore has some code to deal with creating that connection and configuring
the WordPress instance appropriately when it is told which database to connect
to. Similarly, the MySQL charm knows that it is a database, and has code to
create different types of database depending on what is required. The act of
joining these services together causes this code to run, the WordPress charm
saying what tables, users and data it requires, and the MySQL charm fulfilling
that and acknowledging the task. As you will see though, adding a relationship
is much easier than even this brief explanation.

## Creating Relations

Creating relationships is usually very straightforward. Simply deploy the two
services:

    juju deploy wordpress
    juju deploy mysql

Then you create the relationship by specifying these two services with the `add-
relation` command:

    juju add-relation mysql wordpress

These services will then communicate and establish an appropriate connection, in
this case WordPress using the available MySQL service for its database
requirement, and MySQL generating and providing the necessary tables required
for WordPress.

In some cases, there may be ambiguity about how the services should connect. For
example, in the case of specifying a database for the Mediawiki charm.

    juju add-relation mediawiki mysql
    error: ambiguous relation: "mediawiki mysql" could refer to "mediawiki:db mysql:db"; "mediawiki:slave mysql:db"

the solution in these cases is to specify the nature of the relation using the
hook identifier. In this case, we want MySQL to provide the backend database for
mediawiki, so this is what we need to enter:

    juju add-relation mediawiki:db mysql

we can check the output from `juju status` to make sure the correct relationship
has been established:

    machines:
      "0":
        agent-state: started
        agent-version: 1.10.0
        dns-name: 15.185.88.51
        instance-id: "1736045"
        series: precise
      "1":
        agent-state: started
        agent-version: 1.10.0
        dns-name: 15.185.89.204
        instance-id: "1736065"
        series: precise
      "3":
        agent-state: started
        agent-version: 1.10.0
        dns-name: 15.185.89.236
        instance-id: "1736119"
        series: precise
    services:
      mediawiki:
        charm: cs:precise/mediawiki-8
        exposed: false
        relations:
          db:
          - mysql
        units:
          mediawiki/0:
            agent-state: pending
            agent-version: 1.10.0
            machine: "3"
            public-address: 15.185.89.236
      mysql:
        charm: cs:precise/mysql-24
        exposed: false
        relations:
          cluster:
          - mysql
          db:
          - mediawiki
        units:
          mysql/0:
            agent-state: started
            agent-version: 1.10.0
            machine: "1"
            public-address: 15.185.89.204

## Removing Relations

There are times when a relationship just isn't working and it is time to move
on. Fortunately, it is a simple single-line command to break off these
relationships:

    juju remove-relation mediawiki mysql
