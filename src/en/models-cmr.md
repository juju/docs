Title: Cross Model Relations

<!--

Commands 'find-endpoints' and 'offer' are not yet available in commands.md.

Introduced terms "shared model" and "consumer model".

How to determine a unit's interface (e.g. mysql:db)?

Need to add links from other pages.

Also 'show-endpoints' and 'offers' (admin sees more).

Multi CMR controllers are now allowed it seems.

See wallyworld

-->

# Cross Model Relations

Cross Model Relations (CMR) allow applications in different models to be
related. Recall that traditional relations must abide within the same model.
This extends to models hosted on different controllers, and thus in different
clouds.

CMR addresses the case where one may wish to centralize services within one
model and share them with disparate models. One can imagine models dedicated to
tasks such as service monitoring, block storage, and database backends.

The commands related specifically to this subject are:

[`consume`][commands-consume]
: Adds a remote offer to a model.

[`find-offers`][commands-find-offers]
: Find offered application endpoints.

[`list-firewall-rules`][commands-list-firewall-rules]
: Prints the firewall rules.

[`list-offers`][commands-list-offers]
: Lists shared endpoints.

[`offer`][commands-offer]
: Offers application endpoints for use in other models.

[`remove-offer`][commands-remove-offer]
: Removes one or more offers.

[`resume-relation`][commands-resume-relation]
: Resumes a suspended relation to an application offer.

[`set-firewall-rule`][commands-set-firewall-rule]
: Sets a firewall rule.

[`show-offer`][commands-show-offer]
: Shows offered applications' endpoints details.

[`suspend-relation`][commands-suspend-relation]
: Suspends a relation to an application offer.

See [Models][models] and [Managing relations][charms-relations] for beginner
information on those topics.

## Example scenarios

The following CMR scenarios will be examined:

- A centrally operated MySQL application, modelled within the **same** controller, and
  used by the **admin** user.
- A proof of concept application ('hello world'), modelled on **two** controllers, and
  used by the **admin** user.
- A centrally operated MySQL application, modelled within the **two**
  controllers, and used by a **non-admin** user.

## Create a controller

Next, create a controller. Here, the controller (and its model) will use the
AWS public cloud:

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


<!-- LINKS -->

[models]: ./models.html
[charms-relations]: ./charms-relations.html

[commands-consume] ./commands.html#consume
[commands-find-offers] ./commands.html#find-offers
[commands-list-firewall-rules] ./commands.html#list-firewall-rules
[commands-list-offers] ./commands.html#list-offers
[commands-offer]: ./commands.html#offer
[commands-remove-offer] ./commands.html#remove-offer
[commands-resume-relation] ./commands.html#resume-relation
[commands-set-firewall-rule] ./commands.html#set-firewall-rule
[commands-show-offer] ./commands.html#show-offer
[commands-suspend-relation] ./commands.html#suspend-relation


Cross model relations works for both "provides" and "requires" endpoints.
The provides case, eg offer the mysql "db" endpoint.
The requires case, eg offer the prometheus "target" endpoint.

Hello World

So let's get to a working cross model relation straight up.

$ juju bootstrap lxd ctrl1
$ juju deploy mysql
$ juju offer mysql:db

$ juju bootstrap lxd ctrl2
$ juju deploy mediawiki
$ juju relate mediawiki:db ctrl1:admin/default.mysql

Offers

Cross model relations require that an application be offered for use by others.
An offer consists of one or more endpoints for a given application. Model
admins can make offers.
Making an Offer
To offer just the db endpoint for use by others:

$ juju deploy mysql
$ juju offer mysql:db

To offer both the db and db-admin endpoints:

$ juju deploy mysql
$ juju offer mysql:db,db-admin

An offer may be given a different name to that of the underlying application.

$ juju deploy mysql
$ juju offer mysql:db,db-admin hosted-mysql

Once an offer is made, it has a URL which can be used to reference the offer,
either when relating to it or displaying details about it. The URL is of the
form:

controller:user/model.offername

eg
ctrl:admin/default.hosted-mysql

Deleting An Offer

So long as no relations to an offer currently exist, an offer can be removed.

$ juju remove-offer mysql

Note also that if an application is being offered, it cannot be deleted until
the offer is first removed.
Viewing Offers Summary
Offer summary information shows up in status.

$ juju status
Model    Controller  Cloud/Region   Version       SLA
default  ianaws      aws/us-east-1  2.3-alpha1.1  unsupported

App    Version  Status  Scale  Charm  Store       Rev  OS      Notes
mysql  5.5.57   active      1  mysql  jujucharms   57  ubuntu  

Unit      Workload  Agent  Machine  Public address  Ports     Message
mysql/1*  active    idle   1        54.237.63.211   3306/tcp  Ready

Machine  State    DNS            Inst id              Series  AZ
Message
1        started  54.237.63.211  i-0e819d97de8943e38  trusty  us-east-1b
running

Offer  Application  Charm  Rev  Connected  Endpoint  Interface  Role
mysql  mysql        mysql  57   1/1        db        mysql      provider

Relation provider  Requirer       Interface  Type  Message
mysql:cluster      mysql:cluster  mysql-ha   peer  

The connected counts show the number of active connections to the offer and the
total number of connections including those suspended.

Viewing Offers and any Connections
There's also a list-offers command. The summary format shows the same
information as in status.

$ juju offers --format summary
Offer  Application  Charm        Connected  Store   URL
Endpoint  Interface  Role
mysql  mysql        cs:mysql-57  1/1        ianaws  admin/default.mysql  db
mysql      provider

The YAML format shows additional information, such as who is allowed to access
the offer (see managing offer access) and what ingress subnets are required to
allow traffic from the consuming model.

$ juju offers --format yaml
mysql:
  application: mysql
  store: ianaws
  charm: cs:mysql-57
  offer-url: admin/default.mysql
  endpoints:
    db:
      interface: mysql
      role: provider
  connections:
  - source-model-uuid: b9d3db4c-49c9-4802-8269-a9b03216fc34
    username: admin
    relation-id: 2
    endpoint: db
    status:
      current: joined
      since: 1 hour ago
    ingress-subnets:
    - 69.193.151.51/32
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read

The tabular format (the default) shows each relation (connection) to the offer
from a consuming model.

$ juju offers
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress
subnets
mysql  admin  2            joined  db        mysql      provider
69.193.151.51/32

The list offers command can filter the offers included in the result.

All offers for a given application:
$ juju offers --application mysql

All offers for a given interface:
$ juju offers --interface mysql

All offers for a given user who has related to the offer:
$ juju offers --connected-user fred

All offers for a given user who can consume the offer:
$ juju offers --format summary --allowed-consumer mary 

The above command is best run with --format summary as the intent is to see,
for a given user, what offers they might relate to, regardless of whether there
are existing relations (which is what the tabular view shows).

A specific offer:
$ juju offers mysql
Viewing Offers Details
The show-offer command gives details about a given offer.

$juju show-offer default.mysql
Store   URL                  Access  Description
Endpoint  Interface  Role
ianaws  admin/default.mysql  admin   MySQL is a fast, stable and true
multi-user,   db        mysql      provider
                                     multi-threaded SQL database server. SQL                             
                                     (Structured Query Language) is the most                             
                                     popular database query language in the
world.                       
                                     The ma...                                                           

For more details, including which users can access the offer, the the YAML
format.

$ juju show-offer default.mysql --format yaml
ianaws:admin/default.mysql:
  description: |
    MySQL is a fast, stable and true multi-user, multi-threaded SQL database
    server. SQL (Structured Query Language) is the most popular database query
    language in the world. The main goals of MySQL are speed, robustness and
    ease of use.
  access: admin
  endpoints:
    db:
      interface: mysql
      role: provider
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read

A non-admin user with read/consume access can also view an offer's details, but
they won't see the information for users with access.

Managing Offers Access
Now that we have made an offer, we need to be able to manage who can access the
offer. There are 3 levels of access:
read (a user can see the offer when searching)
consume (a user can relate an application to the offer)
admin (a user can manage the offer)

Grant/resume works the same way as for models.

To grant bob consume access to an offer:

$ juju grant bob consume admin/default.mysql

To revoke bob's consume access (he will be left with read access):

$ juju revoke bob consume admin/default.mysql

To revoke all of bob's access:

$ juju revoke bob read admin/default.mysql

Note: revoking a user's consume access will result in all relations for that
user to the offer to be suspended (see suspending relations). If the consume
access to the offer is granted again, each relation will need to be
individually resumed by an admin.
Finding Offers To Use
Offers can be searched based on various criteria:
URL (or part thereof)
offer name
model name
interface

The results will show information about the offer, including the level of
access the user making the query has on each offer.

To find all offers on a specified controller:

$ juju find-offers ian:
Store  URL                         Access  Interfaces
ian    admin/default.hosted-mysql  admin   mysql:db
ian    admin/default.mysql-admin   admin   mysql-root:db-admin, mysql:db
ian    admin/default.postgresql    admin   pgsql:db

As with the list-offers command, the YAMl output will show extra information,
including users who can access the offer (if an admin makes the query).

$ juju find-offers --offer hosted-mysql --format yaml
ian:admin/default.hosted-mysql:
  access: admin
  endpoints:
    db:
      interface: mysql
      role: provider
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read

To find offers in a specified model:

$ juju find-offers admin/default
$ juju find-offers ian:admin/default

To find offers with a specified interface on the current controller:

$ juju find-offers --interface mysql

To find offers with a specified interface on a specific controller:

$ juju find-offers --interface mysql ian:

To find offers with "sql" in the name:

$ juju find-offers --offer sql ian:

Relating To (Consuming) Offers
If a user has consume access to an offer, they can deploy an application in
their model and establish a relation to the offer. The offer is referenced
using its URL. The controller part of the URL is optional if the other model is
in the same controller. Assuming a "mysql" offer has been made in other model
called "admin/default":

$ juju deploy mediawiki
$ juju relate mediawiki:db admin/default.mysql

The user part of the offer's model path is optional if the same user who made
the offer is now also consuming it.

When an offer is related to in this way, a proxy application is made in the
consuming model, named after the offer, in this case "mysql". 

It's possible to consume an offer without relating to it. This creates the
proxy application in the consuming model, which can then be related to
afterwards. Doing it this way enables an alias to be used for the offer, if
there's a need to avoid conflicts with an existing application already deployed
to the consuming model.

$ juju consume admin/default.mysql mysql-alias
$ juju relate mediawiki:db mysql-alias

Offers which have been consumed show up in status under the SAAS block.

$ juju status
Model    Controller  Cloud/Region  Version       SLA
default  foo         lxdq          2.3-alpha1.1  unsupported

SAAS   Status   Store   URL
mysql  unknown  ianaws  admin/default.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports   Message
mediawiki/0*  active    idle   0        10.200.103.121  80/tcp  Ready

Machine  State    DNS             Inst id        Series  AZ  Message
0        started  10.200.103.121  juju-16fc34-0  trusty      Running

Relation provider  Requirer      Interface  Type     Message
mysql:db           mediawiki:db  mysql      regular 

Note that the relations block in status shows any relevant status information
about the relation to the offer in the Message field. This includes any error
information due to rejected ingress, or if the relation is suspended etc.
Relating To Offers From Behind a Firewall
Sometimes, the consuming application is deployed behind a firewall where NAT is
used, such that traffic egresses via a different address/network to that on
which the consuming application is hosted.

In this case, the relate --via option is used to inform the offering side so
that the correct firewall rules can be set up.

$ juju relate mediawiki:db ian:admin/default.mysql --via 69.32.56.0/8

The --via value is a comma separated list of subnets in CIDR notation. This
includes the /32 case where a single NATed IP address is used for egress.

It's also possible to set up egress subnets as a model config value so that all
cross model relations use those subnets without needing to use the --via
option.

$ juju model-config egress-subnets=69.32.56.0/8

Administering Offers

Restricting Ingress
As we have seen, it's possible for a consuming application to ask for ingress
via an arbitrary subnet. To allow control over what ingress can be applied to
the offering model, an administrator can set up allowed ingress subnets by
creating a firewall rule.

$ juju set-firewall-rule juju-application-offer --whitelist 103.37.0.0/16

"juju-application-offer" is the well known service name that specifies the
firewall rule applies to any offer in the current model. If a consumer attempts
to create a relation with requested ingress outside the bounds of the whitelist
subnets, the relation will fail and be marked as in error.

If the firewall rule is changed, it does not (currently) affect existing
relations. Only new relations will be rejected if the changed firewall rules
preclude the requested ingress.

To see what ingress is currently in use by relations to an offer, use the
list-offers command (below).

To see what firewall rules have currently been defined, use the list
firewall-rules command.

$ juju firewall-rules
Service                 Whitelist subnets
juju-application-offer  103.37.0.0/16

NOTE: beyond a certain number of firewall rules, which have been dynamically
created to allow access from individual relations, Juju will revert to using
the whitelist subnets as the access rules. The number of rules at which this
cutover applies is cloud specific.
Inspecting Relations to an Offer
The offers command is used to see all connections to one more offers.

$ juju offers mysql
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress
subnets
mysql  admin  2            joined  db        mysql      provider
69.193.151.51/32

The (default) tabular view shows the connected user and ingress subnets in user
with that connection. Use the YAML output to see extra detail such as the UUID
of the consuming model.

The list offers command can filter the offers included in the result.

All offers for a given application:
$ juju offers --application mysql

All offers for a given interface:
$ juju offers --interface mysql

All offers for a given user who has related to the offer:
$ juju offers --connected-user fred

All offers for a given user who can consume the offer:
$ juju offers --format summary --allowed-consumer mary 

The above command is best run with --format summary as the intent is to see,
for a given user, what offers they might relate to, regardless of whether there
are existing relations (which is what the tabular view shows).

A specific offer:
$ juju offers mysql

Suspending Relations
Individual relations (connections) to an offer may be temporarily suspended.
Suspended relations will run the relation departed / broken hooks on either
end, and any firewall ingress will be closed.

Relations are suspended by specifying the relation id(s). More than one
relation id can be specified, separated by spaces. Use juju offers to see the
relation ids; active relations have a status "joined". 

$ juju suspend-relation 2 --message "reason for suspension"

or

$ juju suspend-relation 2 3 4 --message "reason for suspension"

$ juju offers mysql
Offer  User   Relation id  Status     Endpoint  Interface  Role      Ingress
subnets
mysql  admin  2            suspended  db        mysql      provider
69.193.151.51/32

The message is optional. If specified, it will be reflected in the relation
status in the consuming model.

$ juju status -m foo
Model    Controller  Cloud/Region  Version       SLA
default  foo         lxdq          2.3-alpha1.1  unsupported

SAAS   Status   Store   URL
mysql  unknown  ianaws  admin/default.mysql

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  blocked      1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports  Message
mediawiki/0*  blocked   idle   0        10.200.103.121         Database
required

Machine  State    DNS             Inst id        Series  AZ  Message
0        started  10.200.103.121  juju-16fc34-0  trusty      Running

Relation provider  Requirer      Interface  Type     Message
mysql:db           mediawiki:db  mysql      regular  suspended   - reason for
suspension 

Suspended relations can be resumed by an admin on the offering side.

$ juju resume-relation 2

or

$ juju resume-relation 2 3 4
Removing Relations to an Offer
If a relation needs to be removed entirely, instead of just being suspended:
$ juju remove-relation 2

Removing a relation on the offering side will propagate the deletion to the
consuming side. The relation can also be removed from the consuming side. Also
on the consuming side, the application proxy can be removed, resulting in all
relations also being removed.
