Title: Managing relationships
TODO:  Critical: review required

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
juju add-relation mysql mediawiki 
error: ambiguous relation: "mediawiki mysql" could refer to
  "mediawiki:db mysql:db"; "mediawiki:slave mysql:db"
```

The solution is to specify the nature of the relation using the
relation interface identifier. In this case, we want MySQL to provide the 
backend database for mediawiki ('db' relation), so this is what we need to 
enter:

```bash
juju add-relation mysql mediawiki:db
```

<!-- REMOVED FROM PR 2248, TO BE REVIEWED LATER

The solution is to be explicit when referring to an *endpoint*, where the
latter has a format of `<application>:<application endpoint>`. In this case, it
is 'db' for both applications. However, it is not necessary to specify the
mysql endpoint because only the mediawiki endpoint is ambiguous (according to
the error message). Therefore, the command becomes:

```bash
juju add-relation mysql mediawiki:db
```

!!! Note:
    An application endpoint can be discovered by looking at the metadata of the
    corresponding charm. This can be done by examining the charm on the
    [Charm Store][charm-store] or by querying the Store with the
    [Charm Tools][charm-tools] (using a command like
    `charm show <application> charm-metadata`).

-->

The output to `juju status --relations` will display the relations:

<!-- JUJUVERSION: 2.4-beta4-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status --relations -->
```no-highlight
Model    Controller  Cloud/Region         Version    SLA          Timestamp
default  lxd         localhost/localhost  2.4-beta4  unsupported  20:22:45Z

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  
mysql      5.7.22   active      1  mysql      jujucharms   58  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports     Message
mediawiki/0*  active    idle   2        10.115.37.227   80/tcp    Ready
mysql/0*      active    idle   1        10.115.37.45    3306/tcp  Ready

Machine  State    DNS            Inst id        Series  AZ  Message
1        started  10.115.37.45   juju-db874f-1  xenial      Running
2        started  10.115.37.227  juju-db874f-2  trusty      Running

Relation provider  Requirer       Interface  Type     Message
mysql:cluster      mysql:cluster  mysql-ha   peer     
mysql:db           mediawiki:db   mysql      regular
```

The final section of the status output shows all current established relations.

## Removing relations

There are times when a relation just isn't working and it is time to move on.
See [Removing Juju objects][charms-destroy] for how to do this.

## Cross model relations

Relations can also work across models, even across multiple controllers. See
[Cross model relations][models-cmr] for more information.


<!-- LINKS -->

[models-cmr]: ./models-cmr.html
[charm-tools]: ./tools-charm-tools.html
[charm-store]:  https://jujucharms.com
[charms-destroy]: ./charms-destroy.html#removing-relations
