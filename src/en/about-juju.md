Title: What is Juju?  

# What is Juju?

Juju is a state-of-the-art, open source modelling tool for operating software
in the cloud. Juju allows you to deploy, configure, manage, maintain, and
scale cloud applications quickly and efficiently on public clouds, as well as
on physical servers, OpenStack, and containers. You can use Juju from the
command line or through its beautiful GUI.

## What is application modelling?

In modern environments, applications are rarely deployed in isolation. Even
simple applications may require several other applications in order to
function - like a database and a web server for example. For modeling a more
complex system, e.g. OpenStack, many more applications need to be installed,
configured and connected to each other. Juju's application modelling provides
tools to express the intent of how to deploy such applications and to
subsequently scale and manage them.

At the lowest level, traditional configuration management tools like Chef and
Puppet, or even general scripting languages such as Python or bash, automate
the configuration of machines to a particular specification. With Juju, you
create a model of the relationships between applications that make up your
solution and you have a mapping of the parts of that model to machines. Juju
then applies the necessary configuration management scripts to each machine
in the model.

Application-specific knowledge such as dependencies, scale-out practices,
operational events like backups and updates, and integration options with
other pieces of software are encapsulated in Juju's 'charms'. This knowledge
can then be shared between team members, reused everywhere from laptops to
virtual machines and cloud, and shared with other organisations.

The charm defines everything you all collaboratively know about deploying that
particular application brilliantly. All you have to do is use any available
charm (or write your own), and the corresponding application will be deployed
in seconds, on any cloud or server or virtual machine.

## Can I use Juju with Puppet or Chef or Ansible?

Yes! Puppet, Chef, and Ansible are great tools for writing configuration
files. Juju works a layer above that by focusing on the long term operations
required to keep that software running over time, regardless of the machine on
which it runs. So the Juju charm for an application includes (amongst other
things) all the logic for writing configuration files for that
application - that logic itself can be written in whatever language or tool
the author of the charm prefers.

It is common for people to start creating a charm by bringing together
Puppet or Chef or other scripts which they currently use to automate the
writing of the necessary configuration files. If the charm is going to be
writing and updating configuration for the application, and there are already
tools to abstract that configuration file nicely in your preferred language,
then use that in the charm!

Even better, two different charms from different teams that use different
tools will still happily work together to deploy a solution. In a large
organisation, it is common for different teams choose different tools; Juju
allows teams to pick whatever works for them and their expertise in their
application, but still reuse whatever they want from other teams.

![charm diagram](./media/about-charms.png)

Different charms can use entirely different configuration management tools.

The main change in moving configuration management scripts into a charm is
that one wants to focus only on a single application for each charm. If your
application is made up of many independent services, you will want to split
out each logical application into a different charm to increase the quality
and re-use of that charm.

## What about Docker?

Yes, Docker is a popular delivery mechanism and you can create Juju charms
that use Docker to run your application. The choice of internal tooling is
entirely up to the author of the charm. If Docker is the easiest way to
fetch and run the application you are charming, then go ahead and use that.

Juju is about connecting different applications - from different teams,
in a way that is independent of the particular choices that were best
for those teams, and which can be reused by different organisations on
different clouds.

## Why are charms event-driven?

The goal of Juju is the reuse of common operational code in widely different
environments. For example, you want to have a single operational codebase that
drives your database install, whether the particular deployment is for test or
development, whether it is in the cloud or on a virtual machine cluster. You
also want to use the same database operational code when that database is
being deployed as part of wildly different application models. Sometimes you
will be monitoring the database with Nagios, sometimes with Boundary,
sometimes with Tivoli.

For this reason, the same charm contains operational code for all of the
*possible* things one might want to do. When a user links the database service
up to the Nagios service, an event is triggered which executes the necessary
integration steps automatically.

Taking an event-driven approach allows the charms to respond dynamically to
the particular needs of a particular deployment. That makes them more widely
useful, more likely to be reused, and ultimately of better quality.

## What are Juju bundles?

A bundle is a collection of charms and their relationships, designed to give
you an entire working deployment in one easy to use collection.

Modern applications are typically composed of many applications - databases,
front-ends, big data stores, logging systems, key value stores…
service-oriented architecture has become the norm. Each application will be
defined by a single charm. To describe the whole application you need to
describe the set of charms and their relationships - what is connected to
what - and we use a bundle for that.

For instance, a content-management system bundle could specify a database and
a content management server, together with key-value stores and front-end
load-balancing systems. Each of those applications are described by a charm; the
bundle describes the set of charms, their configuration, and the relationships
between them. This allows teams to share not only the core primitive for each
application, but also enables sharing higher-level models of several
applications. It allows you to replicate complex application models in a
cloud just by dropping the same bundle onto your Juju GUI.

Bundles can also be deployed in-memory, which allows your developers to spin
up workloads on their laptops to simulate an environment similar to a real
production deployment.

Bundles can be shared publicly or privately. New bundles are added to the
public collection every week. And you can now bootstrap Juju, launch the GUI
and deploy a bundle with a single command. That means you can go from zero to
a full cloud deployment in seconds with the right bundle.

## What about Windows or other Linux operating systems?

Yes, charms can be written to deploy Windows applications. And those can be
deployed right alongside Linux applications (albeit in different machines!) in
the same large-scale application model. If you need to integrate
Active Directory on Windows with Hadoop on Linux, this is the way to do it.

The Juju client can run on Linux, Windows, or macOS. And of course, once you
have the Juju GUI up, all you need is a web browser to manage your environment
and deploy more software, or scale up your existing applications.

## Can I use Juju to move applications across clouds?

You can use Juju to recreate application architectures on a wide number of
clouds and platforms. In other words, if you have deployed a set of
applications on one cloud, you can recreate all the same applications with the
same relationships and the same configuration, on any other cloud or
“substrate” that Juju supports. If you are migrating from cloud to cloud,
this solves at least part of your problem, which is the operational lock-in to
that cloud. However, you will still need to copy the data across from cloud to
cloud manually.

## What language are charms written in?

Charms can be written in any language or configuration management scripting
system. Chef and Puppet are common, more complex charms tend to use Python.
Charms have been written in Ruby, PHP, and many charms are a collection of
simple bash scripts.

Your choice of language would be influenced first by what’s already been
done - if there is an existing charm for the application you need and you just
want to add a feature, it’s probably best to contribute to that existing
charm. Also, if there is not yet a reasonable charm for your application, but you
have existing scripts yourself - for Puppet or Chef, or in Bash or Python -
then use those as the starting point of your new charm.
A charm is also a collection of scripts that handle different kinds of events.
Those scripts do not all have to be in the same language. If there is an
existing charm, mostly in Ruby, but it does not handle a connection to your
favourite monitoring system, you could add the scripts that provide the
integration you need in the language of your choice.

## What charms are currently available?

Charms are available for hundreds of common and popular cloud-oriented
applications such as MySQL, MongoDB, and others, with new ones being added
every day. Check out the public charm store for an up to the minute list of
charms:
[Juju Charm Store](https://jujucharms.com)

## Are charms open source? Under what license?

Charms can be released under whatever license the author prefers, there are
charms under just about every kind of license out there today. In many cases,
charms follow the license of the applications that they deploy, but this is
not a requirement. There are open source charms that deploy proprietary
software, for example, and the reverse would be possible as well.

Juju itself imposes no requirements on the license of the charm. Check out the
details in the charm store.
We do encourage the charming community to keep their charms open source in
order to stimulate the sharing of best practices and better code, and most
charmers have followed that guidance, picking a license that works for them.

## Can I write my own charms? How?

Absolutely. A charm is just a collection of scripts and metadata. You can get
started quickly by copying existing charms - respecting their license if they
are copyleft!

Use the language of your choice. It’s normal to get something
quick-and-dirty working in bash, then switch to a more sophisticated language
as the charm takes shape or becomes more complex. Charms are code -
operational code - so you want to think of them that way. Use revision control
from the start, collaborate with colleagues, and consider including test
suites so you can automate quality control for deployments very easily. There
are extra [Juju charm tools](tools-charm-tools.html) to make it easier to test
charms, and templates that get you started quickly.

If you want, you can also share your charm with the world and gain feedback
and contributions from others! In our experience, the more widely a charm is
used the more useful it becomes. Different teams bring different expertise -
security, performance, scale, and all of those things make for improvements in
the charm that are very hard for a single team to achieve.

## What are the best workloads to try with Juju?

Juju excels with scale-out workloads like big data, PAAS, cloud infrastructure
such as OpenStack, or container management systems. Pick your favourite cloud
and launch a Juju server. From the integrated GUI, you can drop one of the
bundles from the charm store into the blank canvas.

<style>.tableicon{width:100px;height:100px;float:right;margin: 5px 5px 40px
20px;}</style>
<table>
  <tr>
    <td width=400>
     <img src="./media/hadoop-icon-160.png" alt="icon" class="tableicon">
     <strong>Hadoop &reg;</strong><br>
     Try one of the simple HDFS bundles or deploy a more complex
sentiment-analysis application to scan twitter streams for brands you are
interested in.
    </td>
    <td width=400>
     <img src="./media/cfoundry-icon-160.png" alt="icon" class="tableicon" >
     <strong>Cloud Foundry &trade;</strong><br>
     Spin up a multi-service PAAS on whichever cloud you like!
    </td>
  </tr>
  <tr>
    <td>
     <img src="./media/docker-icon-160.png" alt="icon" class="tableicon" >
     <strong>Docker</strong><br>
     Try Kubernetes, the Docker management system from Google, on any cloud
supported by Juju.
    </td>
    <td>
     <img src="./media/openstack-icon-160.png" alt="icon" class="tableicon" >
     <strong>OpenStack &trade;</strong><br>
     Deploy your own private cloud on bare metal servers. If you want to
evaluate OpenStack, you can use Juju to spin it up on VMware too.
    </td>
  </tr>
</table>

## How does Juju use containers?

Juju can use both Docker-style application containers and LXD-style system
containers. Charms can use Docker to deliver, start, and stop the workload
they are deploying. Juju administrators can use system containers just like
virtual machines but without the overhead of virtualisation. For example,
to deploy three different charms onto three separate system containers on
“machine:0”:
```
juju deploy mysql --to machine:0/lxc
juju deploy wordpress --to machine:0/lxc
juju deploy haproxy --to machine:0/lxc
```
And if any of those charms use Docker then you would have Docker running the
app inside an LXC system container! For extremely dense deployment on clouds
or on laptops, containers offer much greater utilisation of the system
capacity than traditional virtual machines.

## Where can I get enterprise-grade support for Juju and charms?

Canonical, the company behind Ubuntu, provides commercial professional support
for Juju.

Landscape, our enterprise systems management tool, is included in all of our
support packages. Check out Ubuntu Advantage, Canonical’s support programme,
and choose the level of service you need:

[www.ubuntu.com/cloud/management](http://www.ubuntu.com/cloud/management)

## Where can I learn more?

The Ubuntu Cloud pages give you an overview of our cloud suite and how Juju
fits in:

[www.ubuntu.com/cloud](http://www.ubuntu.com/cloud)

The Juju community pages include information on charms, getting started, and
lots more:

[jujucharms.com/community](https://jujucharms.com/community)

Ready to speak to us? Get in touch with Canonical now:

[www.ubuntu.com/management/contact-us](http://www.ubuntu.com/management/contact-us)
