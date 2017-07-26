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

First, enable CMR via a feature flag:

```bash
export JUJU_DEV_FEATURE_FLAGS=cross-model
```

Next, create a controller. This sample controller/model will be based on AWS.

```bash
juju bootstrap aws crossing-models
```

```bash
juju add-model prod-db
juju deploy mysql --constraints "mem=16G root-disk=1T"
```

Now let’s offer that MySQL service to other models.

```bash
juju offer mysql:db
```

mysqlservice Application "mysql" endpoints [db] available at
"admin/prod-db.mysqlservice"

We’ve offered to other models the db endpoint that
the MySQL application provides. The only bit of our entire prod-db model that’s
exposed to other folks is the endpoint we’ve selected to provide.

Also note that there’s a URL generated to reference this endpoint. We can ask
Juju to tell us about offers that are available for use:

```bash
juju find-endpoints
```

Sample output:

```no-highlight
URL                         Access  Interfaces
admin/prod-db.mysqlservice  admin   mysql:db
```

We’ll now set up a blog for the engineering team using Wordpress which leverages a
MySQL db back end. Let’s set up the blog model and give them a user account for
managing it.

```bash
juju add-model engineering-blog
juju add-user engineering-folks
juju grant engineering-folks write engineering-blog
```

Now they’ve got their own model for managing their blog. If they’d like, they can
set up caching, load balancing, etc. However, we’ll let them know to use our
database where we’ll manage db backups, scaling, and monitoring.

```bash
juju deploy wordpress
juju expose wordpress
juju relate wordpress:db admin/prod-db.mysqlservice
```

This now sets up some interesting things in the status output:

```bash
juju status
```

Sample output:

```no-highlight
Model              Controller       Cloud/Region
Version  SLA engineering-blog   crossing-models  aws/us-east-1  2.2.1 unsupported

SAAS name     Status   Store  URL mysqlservice  unknown  local
admin/prod-db.mysqlservice

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
wordpress           active      1  wordpress  jujucharms    5  ubuntu

Unit          Workload  Agent  Machine  Public address  Ports   Message
wordpress/0*  active    idle   0        54.237.120.126  80/tcp

Machine  State    DNS             Inst id              Series  AZ
Message 0        started  54.237.120.126  i-0cd638e443cb8441b  trusty us-east-1a  running

Relation      Provides      Consumes   Type db            mysqlservice
wordpress  regular loadbalancer  wordpress     wordpress  peer
```

Notice the new section above App called SAAS. What we’ve done is provided a
SAAS-like offering of a MySQL service to users. The end users can see they're
leveraging the offered service. On top of that the relation is noted down in
the Relation section. With that our blog is up and running. 

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

We can prove things are working by actually checking out the databases
in our MySQL instance:

```bash
juju switch prod-db
juju ssh mysql/0
```

```no-highlight
mysql> show databases;
....
```

There we go. Two remote-xxxx databases for each of our models that are using
our shared service. This is going to make operating our infrastructure at scale
so much better!
