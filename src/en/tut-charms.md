Title: Working with charms, applications, and series
TODO: To add (notes from PR #1093):
      1. charms may be different depending on target OS
      2. can choose which charm to use; can deploy on a series that it doesn't claim to
	support
      3. however, to have things 'just work', don't bother specifying anything and the
	charm will decide which OS/version to use

# Working with charms, applications, and series

In this tutorial you will apply knowledge of key Juju concepts detailed
elsewhere in this documentation. These concepts are charms, applications,
units, and series. Specifically, you will gain experience in the following:
 
 - Deploying an application
 - Creating relations between applications
 - Exposing an application
 - Scaling up an application
 - Scaling down an application
 - Removing applications, units, and machines

Although you can follow along by using any backing cloud, for simplicity this
tutorial will use a local LXD cloud where the controller is named 'lxd' and the
model is named 'default'. If you are using a different cloud we'll assume
credentials have been added and that you have an empty model at your disposal.
Refer to the following resources if this is not the case:

 - [Clouds][clouds]
 - [Credentials][credentials]
 - [Models][models]

We are going to set up a simple MediaWiki site, then prepare it for high
traffic, before scaling it back and finally removing it altogether.

### Deploying an application

For a MediaWiki site, we will need the 'mediawiki' charm from the charm store. 
We can deploy that to our model like this:

```bash
juju deploy mediawiki
```

Now, the Mediawiki application needs a database to store information in. There
are several appropriate charms we could use, but for this walkthrough we will
use MariaDB:

```bash
juju deploy mariadb
```

We are now going to scale up this application in order to cope with a high
level of traffic. We will do so by using the HAProxy load balancer:

```bash
juju deploy haproxy
```

After a while if you check what your model currently contains by running...

```bash
juju status
```

...you should see something like this:

<!-- JUJUVERSION: 2.3.1-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
```no-highlight
Model    Controller  Cloud/Region     Version  SLA
default  gce-test    google/us-east1  2.3.1    unsupported

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
haproxy             unknown      1  haproxy    jujucharms   41  ubuntu  
mariadb    10.1.30  active       1  mariadb    jujucharms    7  ubuntu  
mediawiki  1.19.14  blocked      1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports  Message
haproxy/1*    unknown   idle   5        35.227.115.170         
mariadb/1*    active    idle   4        35.227.122.71          ready
mediawiki/0*  blocked   idle   3        35.196.20.204          Database required

Machine  State    DNS             Inst id        Series  AZ          Message
3        started  35.196.20.204   juju-5b2986-3  trusty  us-east1-b  RUNNING
4        started  35.227.122.71   juju-5b2986-4  trusty  us-east1-c  RUNNING
5        started  35.227.115.170  juju-5b2986-5  xenial  us-east1-d  RUNNING

Relation provider  Requirer         Interface     Type  Message
haproxy:peer       haproxy:peer     haproxy-peer  peer  
mariadb:cluster    mariadb:cluster  mysql-ha      peer
```

### Creating relations between applications

The applications may now be running, but they aren't connected in any
meaningful way. In order for MediaWiki to make use of the MariaDB database
a *relation* needs to be added between them.

```bash
juju add-relation mediawiki:db mariadb
```

Normally, we only need to reference the applications by name. In this case, we
also need to add the interface that we would like to connect, as there are two
potential ways these charms could be connected.

The other relation we need to add is between MediaWiki and HAProxy:

```bash
juju add-relation haproxy mediawiki
```

HAProxy will provide traffic load balancing to MediaWiki, but it needs to know
where the various MediaWiki applications are on the network. At this stage
there is only one, but that will change shortly.

### Exposing an application

Make HAProxy available to the world by making changes to the backing cloud's
firewall:

```bash
juju expose haproxy
```

The below final output to `juju status` represents a successful deployment of
the stack:

<!-- JUJUVERSION: 2.3.1-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
```no-highlight
Model    Controller  Cloud/Region     Version  SLA
default  gce-test    google/us-east1  2.3.1    unsupported

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
haproxy             unknown      1  haproxy    jujucharms   41  ubuntu  exposed
mariadb    10.1.30  active       1  mariadb    jujucharms    7  ubuntu  
mediawiki  1.19.14  active       1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports   Message
haproxy/1*    unknown   idle   5        35.227.115.170  80/tcp  
mariadb/1*    active    idle   4        35.227.122.71           ready
mediawiki/0*  active    idle   3        35.196.20.204   80/tcp  Ready

Machine  State    DNS             Inst id        Series  AZ          Message
3        started  35.196.20.204   juju-5b2986-3  trusty  us-east1-b  RUNNING
4        started  35.227.122.71   juju-5b2986-4  trusty  us-east1-c  RUNNING
5        started  35.227.115.170  juju-5b2986-5  xenial  us-east1-d  RUNNING

Relation provider  Requirer              Interface     Type     Message
haproxy:peer       haproxy:peer          haproxy-peer  peer     
mariadb:cluster    mariadb:cluster       mysql-ha      peer     
mariadb:db         mediawiki:db          mysql         regular  
mediawiki:website  haproxy:reverseproxy  http          regular

Relation  Provides  Consumes   Type
peer      haproxy   haproxy    peer
website   haproxy   mediawiki  regular
cluster   mariadb   mariadb    peer
db        mariadb   mediawiki  regular
```

Our MediaWiki site is now exposed via HAProxy. You can check this by pointing
your browser to the IP address of HAProxy visible in the above output. In this
example, it is 35.196.126.59.

### Scaling up an application

Scale is handled by adding and 
removing units, and you can add 5 units simply with the following command:

```bash
juju add-unit -n 5 mediawiki 
```

There are now five newly provisioned machines that have been deployed to run
MediaWiki. However, the load balancing is still being performed by HAProxy,
which is distributing any incoming connections to your cluster of MediaWiki
machines, and the complexity of these added connections is being handled
automatically by Juju. 

### Scaling down an application

Reducing the scale of a deployment is almost as simple as increasing the scale.
When scaling down you need to specify which specific units to remove. We
currently have a total of six units assigned to MediaWiki, as can be seen in
the output to `juju status mediawiki`:

```no-highlight
Unit          Workload  Agent  Machine  Public address   Ports   Message
mediawiki/0*  active    idle   3        35.196.20.204    80/tcp  Ready
mediawiki/1   active    idle   6        104.196.108.215  80/tcp  Ready
mediawiki/2   active    idle   7        35.227.77.231    80/tcp  Ready
mediawiki/3   active    idle   8        35.196.146.3     80/tcp  Ready
mediawiki/4   active    idle   9        35.196.59.200    80/tcp  Ready
mediawiki/5   active    idle   10       35.196.179.191   80/tcp  Ready
```

To scale down a deployment, use the `remove-unit` command followed by the unit
ID of each unit you'd like to remove:

```bash
juju remove-unit mediawiki/3 mediawiki/4 mediawiki/5
```

A hidden part of the above process is that the machines the units were running
on will be destroyed automatically if the machine is not a controller and not
hosting any other application's units.

### Removing applications, units, and machines

When an application is removed, all the associated units are removed as well:

```bash
juju remove-application mediawiki
juju remove-application mariadb
juju remove-application haproxy
```

When the removals have completed, you should see no trace of any applications
in the output of `juju status`. The machines that were used to run these
applications should also be gone since that is the default behaviour: if there
are no other application units running on a machine then the machine itself
will be removed.

Alternatively, you can simply remove the model with:

```bash
juju destroy-model default
```

## Further reading

For more information on the subjects we've covered in this tutorial, see the
definitive documentation:

 - [Deploying charms][charms-deploy]
 - [Managing relations][charms-relations]
 - [Scaling applications][charms-scaling]
 - [Removing things][charms-destroy]


<!-- LINKS -->

[clouds]: ./clouds.md
[models]: ./models.md
[credentials]: ./credentials.md
[charms-deploy]: ./charms-deploying.md
[charms-relations]: ./charms-relations.md
[charms-scaling]: ./charms-scaling.md
[charms-destroy]: ./charms-destroy.md
