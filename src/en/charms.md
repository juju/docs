Title: Introduction to Juju charms  
Todo: Add images

# Introduction to Juju Charms

The magic behind Juju is a collection of software components called *Charms*.
They contain all the instructions necessary for deploying and configuring
cloud-based services. The charms publicly available in the online
[Charm Store](authors-charm-store.html) represent the distilled DevOps knowledge
of experts. Charms make it easy to reliably and repeatedly deploy services, 
then scale up as required with minimal effort.

There are a variety of topics realted to charms to be found in the left navigation 
pane under **Charms**. The three main topics you should get to know well are:

 - **[Deploying charms][deploy]** - which covers how to use charms to deploy 
   services where and how you want them
 - **[Charm relations][relations]** - which covers connecting services together
 - **[Scaling services][scaling]** - how to seamlessly scale up (or down) your deployed services


## Walkthrough

This section will take you through some of the common operations you will want
to perform with Juju. By no means will we be using all the features of Juju, but 
you should gain an understanding of:
 
 - How to deploy a charm
 - Relating services
 - Exposing services
 - Scaling up services
 - Removing units
 - Removing services
 - Destroying your model

!!! Note: this walkthrough assumes you have already installed Juju, connected to a 
cloud and created a model. If you have not yet done these things, please see
the [Getting Started page][started] first.

For this walkthrough we are going to set up a simple MediaWiki site, then 
prepare it for high traffic, before scaling it back and finally removing it 
altogether.

### Deploying the charms

For a MediaWiki site, we will need the 'mediawiki' charm from the charm store. 
We can deploy that to our model like this:

```bash
juju deploy mediawiki
```

Now, the Mediawiki service needs a database to store information in. There are
several appropriate charms we could use, but for this walkthrough we will
use MariaDB:

```bash
juju deploy mariadb
```
It may take a few minutes for Juju to actually fetch these charms from the store,
create new machines to put them on and install them, but as soon as the command
returns we are free to do other things, while Juju continues working in the 
background.

As we said at the beginning, we are going to scale up this service to cope with
a lot of traffic. To do that we will use a common TCP/HTTP load balancing 
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
[Services] 
NAME       STATUS      EXPOSED CHARM                 
haproxy    maintenance false   cs:trusty/haproxy-18  
mariadb    maintenance false   cs:trusty/mariadb-2   
mediawiki  maintenance false   cs:trusty/mediawiki-5 
[Relations] 
SERVICE1    SERVICE2 RELATION TYPE 
haproxy     haproxy  peer     peer 
mariadb     mariadb  cluster  peer 
[Units]     
ID          WORKLOAD-STATUS JUJU-STATUS VERSION   MACHINE PORTS PUBLIC-ADDRESS MESSAGE                                    
haproxy/0   maintenance     executing   2.0        2             10.0.3.177     installing charm software               
mariadb/0   maintenance     executing   2.0        1             10.0.3.158     (config-changed) installing charm software 
mediawiki/0 maintenance     executing   2.0        0             10.0.3.105     (install) installing charm software        
[Machines] 
ID         STATE   DNS        INS-ID                                              SERIES AZ 
0          started 10.0.3.105 juju-8f5c4f24-0d90-4441-8870-072420559f08-machine-0 trusty    
1          started 10.0.3.158 juju-8f5c4f24-0d90-4441-8870-072420559f08-machine-1 trusty    
2          started 10.0.3.177 juju-8f5c4f24-0d90-4441-8870-072420559f08-machine-2 trusty 
```

### Adding relations

The services may now be running, but they have no idea of the existence of each 
other, and aren't connected in any meaningful way. In order for the MediaWiki 
service to make use of the MariaDB database for a backend, you need to add a 
relation between them.

```bash
juju add-relation mediawiki mariadb:db
```

Normally, we only need to reference the services by name. In this case, we also 
need to add the interface that we would like to connect, as there are two
potential ways these charms could be connected.

Behind the scenes, the charms that control these services will now contact each 
other and exchange information. In this case, the MediaWiki charm requests a 
new database to be created; MariaDB obliges, and gives the MediaWiki charm the
credentials it needs to be able to access this database. 

The other relation we need to add is between MediaWiki and the HAProxy service.
The HAProxy service will provide loadbalancing for traffic to MediaWiki, but it 
needs to know where the various MediaWiki services are on the the network. At 
this stage there is only one, but that will change shortly.

```bash
juju add-relation haproxy mediawiki
```

Now that the relations are set up, there is one more thing to do before the 
mediawiki site is 'live'. 

### Exposing the site

By default, Juju is very secure. Juju itself, and the services it deploys can 
see the other services in your cloud, but nothing and nobody else can. This
isn't much use for a web service we want users to connect to, but Juju can
easily make these services public. With it's understanding of the underlying 
cloud, juju can make whatever firewall changes are necessary to expose these
services to the wider world:

```bash
juju expose haproxy
```

### Scaling up 
### Scaling back
### Removing services
### Destroying the model


[deploy]: ./charms-deploying.html
[relations]: ./charms-relations.html
[scaling]: ./charms-scaling.html
