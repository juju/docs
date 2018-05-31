Title: CMR scenario #1
TODO:  Update 'juju status' output to show release versions

# CMR scenario #1

This page refers to [Cross model relations][models-cmr]. See that page for
background information.

In this example, we *build* a simple CMR infrastructure in step by step
fashion, explaining each step along the way. A method of verifying the
deployment is provided at the end.

This scenario describes a MediaWiki deployment, based within the same
controller; used by the admin user, and consumed by multiple models.

The controller is called 'aws-cmr' and the model name is 'cmr-model'.

## Deploy the application

Deploy the application in the usual way. Extra resources have been requested
via constraints, since this shared MySQL should be capable of servicing several
remote applications.

```bash
juju deploy mysql --constraints "cores=4 mem=16G root-disk=1T"
```

The output to `juju status --relations` will eventually look similar to:

<!-- JUJUVERSION: 2.4-beta4-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status --relations -->
```no-highlight
Model      Controller  Cloud/Region   Version    SLA          Timestamp
cmr-model  aws-cmr     aws/us-east-1  2.4-beta4  unsupported  21:38:59Z

App    Version  Status  Scale  Charm  Store       Rev  OS      Notes
mysql  5.7.22   active      1  mysql  jujucharms   58  ubuntu  

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/0*  active    idle   0        107.22.17.48    3306/tcp  Ready

Machine  State    DNS           Inst id              Series  AZ          Message
0        started  107.22.17.48  i-05dc6ef01fd41735b  xenial  us-east-1a  running

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
refer to the MySQL offer URL in the `juju add-relation` command:

```bash
juju add-model wordpress-model
juju deploy wordpress
juju expose wordpress
juju add-relation wordpress:db admin/cmr-model.mysql
```

The last command has made use of a *cross model relation*.

The output to `juju status` for this model will eventually settle down to look
very much like:

<!-- JUJUVERSION: 2.4-beta4-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status --relations -->
```no-highlight
Model            Controller  Cloud/Region   Version    SLA          Timestamp
wordpress-model  aws-cmr     aws/us-east-1  2.4-beta4  unsupported  17:55:45Z

SAAS   Status  Store    URL
mysql  active  aws-cmr  admin/cmr-model.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
wordpress           active      1  wordpress  jujucharms    5  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
wordpress/0*  active    idle   0        54.166.154.178  80/tcp  

Machine  State    DNS             Inst id              Series  AZ          Message
0        started  54.166.154.178  i-0f73b697d5aaef377  trusty  us-east-1a  running

Relation provider       Requirer                Interface     Type     Message
mysql:db                wordpress:db            mysql         regular  
wordpress:loadbalancer  wordpress:loadbalancer  reversenginx  peer
```

Notice how the remote MySQL application shows up as a SAAS object. Its
corresponding relation is also described:

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
juju add-relation mediawiki:db admin/cmr-model.mysql
```

The output to `juju status --relations` for this model will eventually become:

<!-- JUJUVERSION: 2.4-beta4-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status --relations -->
```no-highlight
Model            Controller  Cloud/Region   Version    SLA          Timestamp
mediawiki-model  aws-cmr     aws/us-east-1  2.4-beta4  unsupported  18:07:38Z

SAAS   Status  Store    URL
mysql  active  aws-cmr  admin/cmr-model.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mediawiki/0*  active    idle   0        54.224.9.240    80/tcp  Ready

Machine  State    DNS           Inst id              Series  AZ          Message
0        started  54.224.9.240  i-0905beabb62c21ee9  trusty  us-east-1a  running

Relation provider  Requirer      Interface  Type     Message
mysql:db           mediawiki:db  mysql      regular
```

The new `juju status` output for model 'cmr-model' is not surprising. There are
now *two* connections to the original offer:

```no-highlight
.
.
.
Offer  Application  Charm  Rev  Connected  Endpoint  Interface  Role
mysql  mysql        mysql  58   2/2        db        mysql      provider
```

We can also inquire into currently shared endpoints within the 'cmr-model':

```bash
juju offers -m cmr-model
```

```no-highlight
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress subnets
mysql  admin  1            joined  db        mysql      provider  54.166.154.178/32
       admin  2            joined  db        mysql      provider  54.224.9.240/32
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
each consumer application. Cool.


<!-- LINKS -->

[models-cmr]: ./models-cmr.html
[charms-relations]: ./charms-relations.html
