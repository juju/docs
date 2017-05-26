Title: Introduction to Juju charms  
TODO: Add images
      To add (notes from PR #1093):
      1. charms may be different depending on target OS
      2. can choose which charm to use; can deploy on a series that it doesn't claim to
	support
      3. however, to have things 'just work', don't bother specifying anything and the
	charm will decide which OS/version to use


# Introduction to Juju Charms

The magic behind Juju is a collection of software components called *Charms*.
They contain all the instructions necessary for deploying and configuring
cloud-based applications. The charms publicly available in the online
[charm store](authors-charm-store.html) represent the distilled DevOps knowledge
of experts. Charms make it easy to reliably and repeatedly deploy applications, 
then scale up as required with minimal effort.

There are a variety of topics related to charms to be found in the left 
navigation pane under **Charms**. The three main topics you should get to know
well are:

 - **[Deploying charms][deploy]** - which covers how to use charms to deploy 
   applications where and how you want them
 - **[Charm relations][relations]** - which covers connecting applications 
   together
 - **[Scaling][scaling]** - how to seamlessly scale up (or down) your deployed 
   applications.


## Walkthrough

This section will take you through some of the common operations you will want
to perform with Juju. By no means will we be using all the features of Juju, but 
you should gain an understanding of:
 
 - How to deploy a charm
 - Relating applications
 - Exposing applications
 - Scaling up applications
 - Removing units
 - Removing applications
 - Destroying your model

!!! Note: this walkthrough assumes you have already installed Juju, connected 
to a cloud and created a model. The 'default' model is created automatically 
when you bootstrap your environment. If you have not yet done these things, 
please see the [Getting Started page][started] first.

For this walkthrough we are going to set up a simple MediaWiki site, then 
prepare it for high traffic, before scaling it back and finally removing it 
altogether.

### Deploying the charms

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
It may take a few minutes for Juju to actually fetch these charms from the store,
create new machines to put them on and install them, but as soon as the command
returns we are free to do other things, while Juju continues working in the 
background.

As we said at the beginning, we are going to scale up this application to cope 
with a lot of traffic. To do that we will use a common TCP/HTTP load balancing 
service, HAProxy, so we should also deploy a charm for that now:

```bash
juju deploy haproxy
```

If you check what you model currently contains by running...

```bash
juju status
```

...you should see something like this:

```no-highlight
App        Version  Status       Scale  Charm      Store       Rev  OS      Notes
haproxy             maintenance      1  haproxy    jujucharms   37  ubuntu  
mariadb             maintenance      1  mariadb    jujucharms    6  ubuntu  
mediawiki           maintenance      1  mediawiki  jujucharms    5  ubuntu  

Unit          Workload     Agent      Machine  Public address  Ports  Message
haproxy/0*    maintenance  executing  2        10.0.8.85              (install) installing charm software
mariadb/0*    maintenance  executing  1        10.0.8.136             (config-changed) installing charm software
mediawiki/0*  maintenance  executing  0        10.0.8.118             (install) installing charm software

Machine  State    DNS         Inst id        Series  AZ
0        started  10.0.8.118  juju-26f0f1-0  trusty  
1        started  10.0.8.136  juju-26f0f1-1  trusty  
2        started  10.0.8.85   juju-26f0f1-2  xenial  

Relation  Provides  Consumes  Type
peer      haproxy   haproxy   peer
cluster   mariadb   mariadb   peer
```

### Adding relations

The applications may now be running, but they have no idea of the existence of 
each other, and aren't connected in any meaningful way. In order for MediaWiki 
to make use of the MariaDB database for a backend, you need to add a 
relation between them.

```bash
juju add-relation mediawiki:db mariadb
```

Normally, we only need to reference the applications by name. In this case, we
also need to add the interface that we would like to connect, as there are two
potential ways these charms could be connected.

Behind the scenes, the charms that control these applications will now contact 
each other and exchange information. In this case, the MediaWiki charm requests
a new database to be created; MariaDB obliges, and gives the MediaWiki charm the
credentials it needs to be able to access this database. 

The other relation we need to add is between MediaWiki and the HAProxy 
application.

HAProxy will provide loadbalancing for traffic to MediaWiki, but it 
needs to know where the various MediaWiki services are on the the network. At 
this stage there is only one, but that will change shortly.

```bash
juju add-relation haproxy mediawiki
```

Now that the relations are set up, there is one more thing to do before the 
mediawiki site is 'live'. 

### Exposing the site

By default, Juju is very secure. Juju itself, and the applications it deploys 
can see the other applications in your cloud, but nothing and nobody else can. 
This isn't much use for a web service we want users to connect to, but Juju can
easily make these applications public. With its understanding of the underlying 
cloud, Juju can make whatever firewall changes are necessary to expose these
applications to the wider world:

```bash
juju expose haproxy
```

Our example MediaWiki site is now exposed via HAProxy. You can
check this by first getting the IP address of HAProxy from the output of
`juju status haproxy` (beneath the 'Units' section):


```bash
Unit        Workload  Agent  Machine  Public address  Ports   Message
haproxy/0*  unknown   idle   2        10.0.8.85       80/tcp  
```

Use the IP address, 10.175.11.250 in the example above, within a web 
browser running on your client machine.  With everything working correctly, 
MediaWiki's main page will appear, containing the message 'MediaWiki has been 
successfully  installed'.


### Scaling up

One of Juju's great strengths is that it makes it easy to scale your application
to meet fluctuations in demand. We're going to demonstrate this with with the 
MediaWiki application we've just deployed. Scale is handled by adding and 
removing units, and you can add 5 units simply with the following command:

```bash
juju add-unit -n 5 mediawiki 
```

When you now check the output of the `juju status mediawiki` command, you'll see
that 5 newly provisioned machines have been deployed to run MediaWiki. However,
the load balancing is being performed by HAProxy, which is distributing any
incoming connections to your cluster of MediaWiki machines, and the complexity
of these added connections is being handled automatically by Juju. 


### Scaling back

Reducing the scale of a deployment is almost as simple as increasing the scale,
although you need to specify which specific units to remove. We currently have
a total of 6 units assigned to MediaWiki, for example, as can be seen in the
output of the `juju status mediawiki` command:


```no-highlight
Unit          Workload  Agent  Machine  Public address  Ports   Message
mediawiki/0*  unknown   idle   0        10.0.8.118      80/tcp  
mediawiki/1   unknown   idle   3        10.0.8.146      80/tcp  
mediawiki/2   unknown   idle   4        10.0.8.124      80/tcp  
mediawiki/3   unknown   idle   5        10.0.8.49       80/tcp  
mediawiki/4   unknown   idle   6        10.0.8.81       80/tcp  
mediawiki/5   unknown   idle   7        10.0.8.97       80/tcp  
```

To scale back our deployment, use the `remove-unit` command followed by the 
unit ID of each unit you'd like to remove:


```bash
juju remove-unit mediawiki/3 mediawiki/4 mediawiki/5
```

A hidden part of the above process is that the machines the units were
running on will be destroyed automatically if the machine is not a 
controller and not hosting other Juju managed containers.


### Removing applications

If you no longer require MediaWiki, you can remove the entire application, along
with all the units and machines used to operate the application, with a single
command:


```bash
juju remove-application mediawiki
```

When the removal has completed, you should see no trace of 'mediawiki' in the
output of `juju status`, nor any of the units and machines that
were used to run the application.

### Destroying the model

Finally, to complete this brief walkthough, we're going to remove the model
we've used to host our applications. If this is a fresh Juju installation, you
will have been operating within the 'default' model that's automatically
generated when you bootstrap the environment. You can check which models you
have available, along with which one is active, marked by the * symbol, 
with the `juju list-models` command. Your output should be similar to the 
following:

```bash
Model       Owner  Status     Machines  Cores  Access  Last connection
controller  admin  available         1      -  admin   just now
default*    admin  available         2      -  admin   just now
```

To remove the default model, type `juju destroy-model default` and enter 'Y' to 
accept the warning that this step will destroy all machines, applications,
data and other resources associated with the default model. A few moments
later, depending on the complexity of your model, you should find it no longer
listed in the output of the `list-models` command. 

If you want to start again with a clean default model, restoring Juju to the
state it was in before we deployed the MediaWiki charm, you can create one 
with:

```bash
juju add-model default
```

For more information on the subjects we've covered in this walkthough, see our 
documentation on **[deploying charms][deploy]**, **[charm relations][relations]** 
and **[scaling deployed applications][scaling]**.


[deploy]: ./charms-deploying.html
[relations]: ./charms-relations.html
[scaling]: ./charms-scaling.html
[started]: ./getting-started.html
