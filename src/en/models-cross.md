Title: Cross model relations

<!--

Very brief definition of 'models' and 'relations'. Provide links to their
respective pages.

Explain how the above are limiting. Provide a real-world example such as:

Often times, your infrastructure consists of shared resources outside of the
different models that are operated. Examples might be a shared object storage
service providing space for data backups, or a central Nagios service.

-->

# Cross Model Relations

Cross Model Relations (CMR) pertain to Juju inter-model relations. They are
relations that can be used across models.

!!! Note:
    The CMR feature is currently limited to a single controller.

Here, we'll provide an example of offering a centrally operated MySQL to other
company employees.

## Enable CMR

First, enable CMR via a feature flag:

```bash
export JUJU_DEV_FEATURE_FLAGS=cross-model
```

## Create a controller

Next, create a controller. Here, the controller (and its model) will be based
on AWS:

```bash
juju add-credentials aws
juju bootstrap aws aws-cross-controller
```

See ' ' and ' ' for details.

## Add the cross relations model and application

Add the cross relations model and application in the usual way. Here we've
decided to include some constraints: 

```bash
juju add-model cross-model
juju deploy mysql --constraints "mem=16G root-disk=512G"
```

The output to `juju status` should look similar to:

```no-highlight
```

Now make the MySQL service, and only this service, available to other models
with the `juju offer` command:

```bash
juju offer mysql:db
```

The output will include the shared service's endpoint:

```no-highlight
mysqlservice Application "mysql" endpoints [db] available at
"admin/prod-db.mysqlservice"
```

Where the endpoint is `admin/prod-db.mysqlservice`.

Note that a model's endpoints can be queried with the `juju find-endpoints`
command:

```bash
juju find-endpoints
```

In this example, the output would like like:

```no-highlight
URL                         Access  Interfaces
admin/prod-db.mysqlservice  admin   mysql:db
```

## Add the consumer model and application

Add a consumer model and application. The application in this example will
require a MySQL database and will use the one in the shared (CMR) model. The
chosen application here is WordPress.

```bash
juju add-model consumer-model-1
juju deploy wordpress
juju expose wordpress
juju relate wordpress:db admin/prod-db.mysqlservice
```

The output to `juju status` for this model should look something like:

```no-highlight
```

Notice how the remote MySQL application shows up as a SAAS object (Software as
a Service). The relation is also noted down in the Relation section.

We can repeat the same process for a team wiki using Mediawiki which will also
use a MySQL database backend. While setting it up notice how the Mediawiki unit
complains about a database is required in the first status output. Once we add
the relation to the offered service it heads to ready status.

```bash
juju add-model wiki
juju deploy mediawiki
juju status
```

```no-highlight
...  Unit          Workload  Agent Machine  Public address  Ports  Message mediawiki/0*  blocked   idle   0
54.160.86.216          Database required

```bash
juju relate mediawiki:db admin/prod-db.mysqlservice
juju status
```

```no-highlight
...  SAAS
name     Status   Store  URL mysqlservice  unknown  local
admin/prod-db.mysqlservice

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms    9  ubuntu ...

Relation  Provides   Consumes      Type db        mediawiki  mysqlservice regular
```

## Verification

It should be possible to verify that the remote application has responded to
the cross model relation by creating the necessary bits. In this example, we
begin by switching to the CMR model and connecting to the mysql unit via SSH:

```bash
juju switch cross-model
juju ssh mysql/1
```

We now log in to MySQL and list its databases:

```bash
mysql -u root --password=$(sudo cat /var/lib/mysql/mysql.passwd)
mysql> show databases;
```

The output should look similar to:

```no-highlight
+-----------------------------------------+
| Database                                |
+-----------------------------------------+
| information_schema                      |
| mysql                                   |
| performance_schema                      |
| remote-61d57d41768646a1827d90efa675462d |
| remote-eec7726f8a5540a2830a48348860f340 |
| sys                                     |
+-----------------------------------------+
6 rows in set (0.00 sec)
```

From the output we can see the databases (`remote-`) that correspond to
each of the models:


<!-- LINKS -->

[commands-offer]: ./commands.html#offer
[commands-find-endpoints]: ./commands.html#find-endpoints
