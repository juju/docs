Title: CMR scenario #1

# CMR scenario #1

In this example, we *build* a simple CMR infrastructure in step by step
fashion, explaining each step along the way. A method of verifying the
deployment is provided at the end.

This scenario describes a MediaWiki deployment, based within the same (LXD)
controller; used by the admin user, and consumed by multiple models.

## Create a controller

Create a controller. Here, the controller (and its model) will use the AWS
public cloud:

```bash
juju add-credentials aws
juju bootstrap aws aws-cmr-controller
```

## Add the shared model and application

Add the shared CMR model and application in the usual way. Extra resources have
been requested via constraints, since this shared MySQL should be capable of
servicing several remote applications.

```bash
juju add-model cmr-model
juju deploy mysql --constraints "mem=16G root-disk=1T"
```

The output to `juju status` should eventually look similar to:

```no-highlight
Model      Controller          Cloud/Region   Version       SLA
cmr-model  aws-cmr-controller  aws/us-east-1  2.3-alpha1.1  unsupported

App    Version  Status  Scale  Charm  Store       Rev  OS      Notes
mysql  5.7.19   active      1  mysql  jujucharms   57  ubuntu

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/0*  active    idle   0        23.20.241.57    3306/tcp  Ready

Machine  State    DNS           Inst id              Series  AZ          Message
0        started  23.20.241.57  i-065bddb4cf8843540  xenial  us-east-1a  running

Relation  Provides  Consumes  Type
cluster   mysql     mysql     peer
```

Now make this MySQL service, and only this service, available to other models
by referring to interface 'mysql:db' with the `juju offer` command:

```bash
juju offer mysql:db
```

The output will include the shared service's endpoint:

<!-- Below output is wrong! -->

```no-highlight
Application "mysql" endpoints [db] available at "admin/cmr-model."
```

Where the endpoint is `admin/cmr-model.mysql`.

Note that a model's endpoints can be queried with the `juju find-endpoints`
command:

```bash
juju find-endpoints
```

In this example, the output would like like:

```no-highlight
Store               URL                    Access  Interfaces
aws-cmr-controller  admin/cmr-model.mysql  admin   mysql:db
```

## Add a first consumer model and application

Add a consumer model and application. The application in this example will
require a MySQL database and the objective is that it will use the one in the
shared (CMR) model. The application we've chosen here is WordPress and we'll
refer to the mysql unit's endpoint in the `juju relate` command:

```bash
juju add-model wordpress-model
juju deploy wordpress
juju expose wordpress
juju relate wordpress:db admin/cmr-model.mysql
```

The output to `juju status` for this model will eventually settle down to look
very much like:

```no-highlight
Model            Controller          Cloud/Region   Version       SLA
wordpress-model  aws-cmr-controller  aws/us-east-1  2.3-alpha1.1  unsupported

SAAS   Status   Store               URL
mysql  unknown  aws-cmr-controller  admin/cmr-model.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
wordpress           active      1  wordpress  jujucharms    5  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
wordpress/0*  active    idle   0        54.196.30.61    80/tcp

Machine  State    DNS           Inst id              Series  AZ          Message
0        started  54.196.30.61  i-0ce70d25f1d08500c  trusty  us-east-1a  running

Relation      Provides   Consumes   Type
db            mysql      wordpress  regular
loadbalancer  wordpress  wordpress  peer
```

Notice how the remote MySQL application shows up as a SAAS object. The
relation is also included in the Relation section.

Looking at the `juju status` of the CMR model we see a new entry in the
Relation section that corresponds to the consuming model relation:

```bash
juju status -m cmr-model
```

Output:

```no-highlight
.
.
.
Relation  Provides  Consumes                                 Type
cluster   mysql     mysql                                    peer
db        mysql     remote-19001893317b486080b99f806797d51f  regular
```

In the above, 'remote-19001893317b486080b99f806797d51f' is the actual name of
a database that got created. We'll make use of this information later on.

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
Model            Controller          Cloud/Region   Version       SLA
mediawiki-model  aws-cmr-controller  aws/us-east-1  2.3-alpha1.1  unsupported

SAAS   Status   Store               URL
mysql  unknown  aws-cmr-controller  admin/cmr-model.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mediawiki/0*  active    idle   0        54.224.30.3     80/tcp  Ready

Machine  State    DNS          Inst id              Series  AZ          Message
0        started  54.224.30.3  i-04a4f1613a4224aa0  trusty  us-east-1a  running

Relation  Provides   Consumes  Type
db        mediawiki  mysql     regular
```

As expected, this is very similar to the output we saw with model
'wordpress-model'.

The new output for model 'cmr-model' is also not surprising:

```no-highlight
.
.
.
Relation  Provides  Consumes                                 Type
cluster   mysql     mysql                                    peer
db        mysql     remote-19001893317b486080b99f806797d51f  regular
db        mysql     remote-640e658f832c4d1682abb9228823e6d6  regular
```

Clearly, a second database ('remote-640e658f832c4d1682abb9228823e6d6') is now
present.

## Verification

Verify that the remote application has responded to the cross model relation by
creating/preparing the necessary resources. In this example, we log in to the
mysql unit via SSH, connect to MySQL, and list its databases:

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
| remote-19001893317b486080b99f806797d51f |
| remote-640e658f832c4d1682abb9228823e6d6 |
| sys                                     |
+-----------------------------------------+
6 rows in set (0.00 sec)
```

From the output we can see evidence of the two databases that got created.
