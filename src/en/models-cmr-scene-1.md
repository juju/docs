Title: CMR scenario #1
TODO:  Update 'juju status' output to show release versions

# CMR scenario #1

This page refers to [Cross model relations][models-cmr]. See that page for
background information.

In this example, we *build* a simple CMR infrastructure in step by step
fashion, explaining each step along the way. A method of verifying the
deployment is provided at the end.

This scenario describes a MediaWiki deployment, based within the same (LXD)
controller; used by the admin user, and consumed by multiple models.

## Create a controller

Create a controller, called 'aws-cmr' here. In this example, the controller
(and its models) will use the AWS public cloud:

```bash
juju add-credential aws
juju bootstrap aws aws-cmr
```

## Add the shared model and application

Add the shared CMR model and application in the usual way. Extra resources have
been requested via constraints, since this shared MySQL should be capable of
servicing several remote applications.

```bash
juju add-model cmr-model
juju deploy mysql --constraints "cores=4 mem=16G root-disk=1T"
```

The output to `juju status` will eventually look similar to:

```no-highlight
Model      Controller  Cloud/Region   Version      SLA
cmr-model  aws-cmr     aws/us-east-1  2.3-beta2.1  unsupported

App    Version  Status  Scale  Charm  Store       Rev  OS      Notes
mysql  5.7.19   active      1  mysql  jujucharms   58  ubuntu  

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/0*  active    idle   0        54.81.205.47    3306/tcp  Ready

Machine  State    DNS           Inst id              Series  AZ          Message
0        started  54.81.205.47  i-0f9f15e276ec3b5c2  xenial  us-east-1a  running

Relation provider  Requirer       Interface  Type  Message
mysql:cluster      mysql:cluster  mysql-ha   peer
```

Now make the mysql application, and only that application, available to other
models by referring to interface 'mysql:db' with the `juju offer` command:

```bash
juju offer mysql:db
```

!!! Note:
    See [Managing relations][charms-relations] for how to determine the
    interface used in the `juju offer` command.

The output will include the shared application's endpoint:

```no-highlight
Application "mysql" endpoints [db] available at "admin/cmr-model.mysql"
```

Where the offer URL is `admin/cmr-model.mysql`.

All available offer endpoints (per model) can be listed like so:

```bash
juju find-offers
```

In this example, the output is:

```no-highlight
Store    URL                    Access  Interfaces
aws-cmr  admin/cmr-model.mysql  admin   mysql:db
```

## Add a first consumer model and application

Add a consumer model and application. The application in this example will
require a MySQL database and the objective is that it will use the one in the
shared (CMR) model. The application we've chosen here is WordPress and we'll
refer to the MySQL offer URL in the `juju relate` command:

```bash
juju add-model wordpress-model
juju deploy wordpress
juju expose wordpress
juju relate wordpress:db admin/cmr-model.mysql
```

The last command has made use of a *cross model relation*.

The output to `juju status` for this model will eventually settle down to look
very much like:

```no-highlight
Model            Controller  Cloud/Region   Version      SLA
wordpress-model  aws-cmr     aws/us-east-1  2.3-beta2.1  unsupported

SAAS   Status   Store    URL
mysql  unknown  aws-cmr  admin/cmr-model.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
wordpress           active      1  wordpress  jujucharms    5  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
wordpress/0*  active    idle   0        54.198.91.120   80/tcp  

Machine  State    DNS            Inst id              Series  AZ          Message
0        started  54.198.91.120  i-00332775f5f83d886  trusty  us-east-1a  running

Relation provider       Requirer                Interface     Type     Message
mysql:db                wordpress:db            mysql         regular  
wordpress:loadbalancer  wordpress:loadbalancer  reversenginx  peer
```

Notice how the remote MySQL application shows up as a SAAS object. The
relation is also described:

```no-highlight
Relation provider       Requirer                Interface     Type     Message
mysql:db                wordpress:db            mysql         regular
```

Applying the `juju status` command to the CMR model we see that the offer is
now connected:

```bash
juju status -m cmr-model
```

Output:

```no-highlight
.
.
.
Offer  Application  Charm  Rev  Connected  Endpoint  Interface  Role
mysql  mysql        mysql  58   1/1        db        mysql      provider
```

## Add a second consumer model and application

Add a second consumer model and MySQL-based application. The application we've
chosen now is MediaWiki.

```bash
juju add-model mediawiki-model
juju deploy mediawiki
juju expose mediawiki
juju relate mediawiki:db admin/cmr-model.mysql
```

The output to `juju status` for this model will eventually become:

```no-highlight
Model            Controller  Cloud/Region   Version      SLA
mediawiki-model  aws-cmr     aws/us-east-1  2.3-beta2.1  unsupported

SAAS   Status   Store    URL
mysql  unknown  aws-cmr  admin/cmr-model.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mediawiki/0*  active    idle   0        54.80.49.62     80/tcp  Ready

Machine  State    DNS          Inst id              Series  AZ          Message
0        started  54.80.49.62  i-0b7530071c6242c19  trusty  us-east-1a  running

Relation provider  Requirer      Interface  Type     Message
mysql:db           mediawiki:db  mysql      regular
```

As expected, this is very similar to the output we saw with model
'wordpress-model'.

The new output for model 'cmr-model' is also not surprising. There are now two
connections to the original offer:

```no-highlight
.
.
.
Offer  Application  Charm  Rev  Connected  Endpoint  Interface  Role
mysql  mysql        mysql  58   2/2        db        mysql      provider
```

## Verification

Verify that the remote application has responded to the two cross model
relations by creating/preparing the necessary resources. In this example, we
log in to the mysql unit via SSH, connect to MySQL, and list its databases:

```bash
juju ssh -m cmr-model mysql/0
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
| remote-9414c94f21db456d822045bb216c3b33 |
| remote-9cc8d09e87674e3487442a64751eb386 |
| sys                                     |
+-----------------------------------------+
6 rows in set (0.00 sec)
```

From the output we can see evidence of two databases that got created, one for
each consumer application.


<!-- LINKS -->

[models-cmr]: ./models-cmr.html
[charms-relations]: ./charms-relations.html
