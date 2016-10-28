Title: Managing relationships  

# Managing relationships

Few applications you might want to run can do so completely independently - most of
them rely on some other software components to be present and running too (e.g.
a database). There would be little point in Juju making it supremely easy to
deploy applications if it didn't also make it easy to connect them up to other
applications they need to get running! The Juju magic in this case involves the
**hooks** built in to each charm which allow them to communicate. Unless you
are writing charms, there is no need to go into detail on hooks, but these are
the parts that make creating relationships between applications so easy.

The charm for WordPress, for example, knows that it requires a database. It
therefore has some code to deal with creating that connection and configuring
the WordPress instance appropriately when it is told which database to connect
to. Similarly, the MySQL charm knows that it is a database, and has code to
create different types of database depending on what is required. The act of
joining these applications together causes this code to run, the WordPress charm
saying what tables, users and data it requires, and the MySQL charm fulfilling
that and acknowledging the task. As you will see though, adding a relationship
is much easier than even this brief explanation.


## Creating Relations

Creating relationships is usually very straightforward. Simply deploy the two
applications:

```bash
juju deploy wordpress
juju deploy mysql
```

Then you create the relationship by specifying these two applications with the
`add-relation` command:

```bash
juju add-relation mysql wordpress
```

These applications will then communicate and establish an appropriate
connection, in this case WordPress using MySQL for its database
requirement, and MySQL is generating and providing the necessary tables required
for WordPress.

In some cases, there may be ambiguity about how the applications should connect.
For example, in the case of specifying a database for the Mediawiki charm.

```bash
juju add-relation mediawiki mysql
error: ambiguous relation: "mediawiki mysql" could refer to 
  "mediawiki:db mysql:db"; "mediawiki:slave mysql:db"
```

The solution is to specify the nature of the relation using the
relation interface identifier. In this case, we want MySQL to provide the 
backend database for mediawiki ('db' relation), so this is what we need to 
enter:

```bash
juju add-relation mediawiki:db mysql
```

We can check the output from `juju status` to make sure the correct relationship
has been established:

<!-- JUJUVERSION: 2.0.0-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
```no-highlight
Model    Controller  Cloud/Region         Version
default  lxd-test    localhost/localhost  2.0.0

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
mediawiki           unknown      1  mediawiki  jujucharms    5  ubuntu
mysql               unknown      1  mysql      jujucharms   55  ubuntu

Unit          Workload  Agent      Machine  Public address  Ports     Message
mediawiki/0*  unknown   executing  0        10.154.173.35   80/tcp
mysql/0*      unknown   idle       1        10.154.173.232  3306/tcp

Machine  State    DNS             Inst id        Series  AZ
0        started  10.154.173.35   juju-4a3f2a-0  trusty
1        started  10.154.173.232  juju-4a3f2a-1  trusty

Relation  Provides   Consumes  Type
db        mediawiki  mysql     regular
cluster   mysql      mysql     peer

```
The final section of the status output shows all current established relations.

## Removing relations

There are times when a relationship just isn't working and it is time to move
on. Fortunately, it is a simple single-line command to break off these
relationships:

```bash
juju remove-relation mediawiki mysql
```

In cases where there is more than one relation between the two applications, it
is necessary to specify the interface at least once:
  
```bash
juju remove-relation mediawiki mysql:db
```
