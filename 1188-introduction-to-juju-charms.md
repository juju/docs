<!--
Todo:
- Add images
- To add (notes from PR #1093):
- 1. charms may be different depending on target OS
- 2. can choose which charm to use; can deploy on a series that it doesn't claim to
- support
- 3. however, to have things 'just work', don't bother specifying anything and the
- charm will decide which OS/version to use
- Should probably link to charms-exposing.md instead of repeating
- The Scaling back section should just reference /t/scaling-applications/1075
- The Removing applications section should just reference /t/removing-things/1063
- This looks like a journey/walkthrough. Consider making a real one and modifying this page
- Removing mediawiki gives the sense that we're back to square one but mariadb and haproxy are left dangling
-->
The magic behind Juju is a collection of software components called *Charms*. They contain all the instructions necessary for deploying and configuring cloud-based applications. The charms publicly available in the online [charm store](/t/the-juju-charm-store/1045) represent the distilled DevOps knowledge of experts. Charms make it easy to reliably and repeatedly deploy applications, then scale up as required with minimal effort.

There are a variety of topics related to charms to be found in the left navigation pane under **Charms**. The three main topics you should get to know well are:

-   **[Deploying charms](/t/deploying-applications/1062)** - which covers how to use charms to deploy applications where and how you want them
-   **[Charm relations](/t/managing-relations/1073)** - which covers connecting applications together
-   **[Scaling](/t/scaling-applications/1075)** - how to seamlessly scale up (or down) your deployed applications.

<h2 id="heading--walkthrough">Walkthrough</h2>

This section will take you through some of the common operations you will want to perform with Juju. By no means will we be using all the features of Juju, but you should gain an understanding of:

-   How to deploy a charm
-   Relating applications
-   Exposing applications
-   Scaling up applications
-   Removing units
-   Removing applications
-   Destroying your model

[note type="caution"]
These instructions assume that you have already added credentials for your cloud. If you have not yet done this, please see [Cloud credentials](/t/credentials/1112) first. You can also learn about clouds on the central [Clouds](/t/clouds/1100) page.
[/note]

A 'default' model is created automatically when you create a controller and it's the model that will be used here. The controller used here is named 'gce-test' and is based on the [Google Compute Engine](/t/using-google-gce-with-juju/1088).

We are going to set up a simple MediaWiki site, then prepare it for high traffic, before scaling it back and finally removing it altogether.

<h3 id="heading--deploying-the-charms">Deploying the charms</h3>

For a MediaWiki site, we will need the 'mediawiki' charm from the charm store. We can deploy that to our model like this:

``` text
juju deploy mediawiki
```

Now, the Mediawiki application needs a database to store information in. There are several appropriate charms we could use, but for this walkthrough we will use MariaDB:

``` text
juju deploy mariadb
```

It may take a few minutes for Juju to actually fetch these charms from the store, create new machines to put them on and install them, but as soon as the command returns we are free to do other things, while Juju continues working in the background.

As we said at the beginning, we are going to scale up this application to cope with a lot of traffic. To do that we will use a common TCP/HTTP load balancing application, HAProxy, so we should also deploy a charm for that now:

``` text
juju deploy haproxy
```

After a while if you check what your model currently contains by running...

``` text
juju status
```

...you should see something like this:

<!-- JUJUVERSION: 2.3.1-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
``` text
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

<h3 id="heading--adding-relations">Adding relations</h3>

The applications may now be running, but they have no idea of the existence of each other, and aren't connected in any meaningful way. In order for MediaWiki to make use of the MariaDB database for a backend, you need to add a relation between them.

``` text
juju add-relation mediawiki:db mariadb
```

Normally, we only need to reference the applications by name. In this case, we also need to add the interface that we would like to connect, as there are two potential ways these charms could be connected.

Behind the scenes, the charms that control these applications will now contact each other and exchange information. In this case, the MediaWiki charm requests a new database to be created; MariaDB obliges, and gives the MediaWiki charm the credentials it needs to be able to access this database.

The other relation we need to add is between MediaWiki and the HAProxy application.

HAProxy will provide loadbalancing for traffic to MediaWiki, but it needs to know where the various MediaWiki applications are on the network. At this stage there is only one, but that will change shortly.

``` text
juju add-relation haproxy mediawiki
```

Now that the relations are set up, there is one more thing to do before the MediaWiki site is "live".

<h3 id="heading--exposing-the-site">Exposing the site</h3>

By default, Juju is very secure. Juju itself, and the applications it deploys can see the other applications in your cloud, but nothing and nobody else can. This isn't much use for a web application we want users to connect to, but Juju can easily make these applications public. With its understanding of the underlying cloud, Juju can make whatever firewall changes are necessary to expose these applications to the wider world:

``` text
juju expose haproxy
```

The below final output to `juju status` represents a successful deployment of the stack:

<!-- JUJUVERSION: 2.3.1-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
``` text
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

Our MediaWiki site is now exposed via HAProxy. You can check this by pointing your browser to the IP address of HAProxy visible in the above output. In this example, it is 35.196.126.59. A confirmation will be in the form of MediaWiki's main page appearing, containing the message 'MediaWiki has been successfully installed'.

<h3 id="heading--scaling-up">Scaling up</h3>

One of Juju's great strengths is that it makes it easy to scale your application to meet fluctuations in demand. We're going to demonstrate this with with the MediaWiki application we've just deployed. Scale is handled by adding and removing units, and you can add 5 units simply with the following command:

``` text
juju add-unit -n 5 mediawiki 
```

When you now check the output of the `juju status mediawiki` command, you'll see that 5 newly provisioned machines have been deployed to run MediaWiki. However, the load balancing is being performed by HAProxy, which is distributing any incoming connections to your cluster of MediaWiki machines, and the complexity of these added connections is being handled automatically by Juju.

<h3 id="heading--scaling-back">Scaling back</h3>

Reducing the scale of a deployment is almost as simple as increasing the scale, although you need to specify which specific units to remove. We currently have a total of 6 units assigned to MediaWiki, for example, as can be seen in the output of the `juju status mediawiki` command:

``` text
Unit          Workload  Agent  Machine  Public address   Ports   Message
mediawiki/0*  active    idle   3        35.196.20.204    80/tcp  Ready
mediawiki/1   active    idle   6        104.196.108.215  80/tcp  Ready
mediawiki/2   active    idle   7        35.227.77.231    80/tcp  Ready
mediawiki/3   active    idle   8        35.196.146.3     80/tcp  Ready
mediawiki/4   active    idle   9        35.196.59.200    80/tcp  Ready
mediawiki/5   active    idle   10       35.196.179.191   80/tcp  Ready
```

To scale back our deployment, use the `remove-unit` command followed by the unit ID of each unit you'd like to remove:

``` text
juju remove-unit mediawiki/3 mediawiki/4 mediawiki/5
```

A hidden part of the above process is that the machines the units were running on will be destroyed automatically if the machine is not a controller and not hosting other Juju managed containers.

<h3 id="heading--removing-applications">Removing applications</h3>

If you no longer require MediaWiki, you can remove the entire application, along with all the units and machines used to operate the application, with a single command:

``` text
juju remove-application mediawiki
```

When the removal has completed, you should see no trace of 'mediawiki' in the output of `juju status`, nor any of the units and machines that were used to run the application.

<h3 id="heading--destroying-the-model">Destroying the model</h3>

Finally, to complete this brief walkthrough, we're going to remove the model we've used to host our applications. If this is a fresh Juju installation, you will have been operating within the 'default' model that's automatically generated when you bootstrap the environment. You can check which models you have available, along with which one is active, marked by the * symbol, with the `juju models` command. Your output should be similar to the following:

``` text
Controller: gce-test

Model       Cloud/Region     Status     Machines  Cores  Access  Last connection
controller  google/us-east1  available         1      4  admin   just now
default*    google/us-east1  available         2      2  admin   4 minutes ago
```

To remove the 'default' model we've been using for the MediaWiki deployment, type `juju destroy-model default` and accept the warning that this step will destroy all machines, applications, data and other resources associated with that model. A few moments later you should find it no longer listed in the output of the `juju models` command.

If you want to start again with a clean model, restoring Juju to the state it was in before we deployed the MediaWiki charm, you can re-create the 'default' model with: `juju add-model default`.

For more information on the subjects we've covered here, see our documentation on **[deploying charms](/t/deploying-applications/1062)**, **[charm relations](/t/managing-relations/1073)** and **[scaling deployed applications](/t/scaling-applications/1075)**.

<!-- LINKS -->
