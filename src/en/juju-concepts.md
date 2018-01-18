Title: Juju concepts
TODO:  Review required

# Juju concepts

## The Juju client

The Juju client is command line interface (CLI) software that is used to
manage Juju, whether as an administrator or as a regular user. It is 
installed, via an APT package ('juju'), onto your personal workstation. 
This software manages your connection to Juju controllers in the cloud, 
and is used to issue commands to deploy and manage applications.

![machine][img__client-2]
[img__client-2]: ../media/juju-client-2.png

In the case of the localhost cloud (LXD), the cloud is housed within the same
system as the Juju client:

![machine][img__client-3]
[img__client-3]: ../media/juju-client-3.png

Although LXD itself can function over the network, Juju does not support this
feature.

## Juju agent

The Juju agent is software that runs on every Juju machine. There is a *machine
agent* that operates at the machine level and a *unit agent* that works at the
application unit level. Thus there are typically at least two agents running on
each regular (non-controller) machine: one for the machine and one for a
deployed application/charm. The controller normally has a single machine agent
running.

A machine agent manages its respective unit agents as well as any containers
that may be requested on that machine. In particular, it is the machine agent
that creates the unit agent. The unit agents are responsible for all charm
related tasks.

In general, all agents track state changes, respond to those changes, and pass
updated information back to the controller. A model's status (`juju status`
command) is built up from the communication between a controller and all the
agents running in that model.

## Clouds

In Juju terms, the cloud is the environment which provides resources to be used
by Juju - machines and storage. This includes traditional public clouds, such
as Amazon Web Services, Google Compute Engine and Microsoft Azure, as well as
(possibly private) clouds such as OpenStack.

It also includes things which may not strictly speaking be clouds, but Juju can
treat as a cloud, such as [MAAS][maas] and your local computer using [LXD][lxd].


## The Juju controller

The controller is a special instance which Juju will create in a cloud when you
run the bootstrap command. The controller manages the internals of Juju for the
chosen cloud, including the models (see next section) you create within it.
Multiple clouds (and thus controllers) are possible and each one may contain
multiple models.

## Models

A model is the space within which you can deploy applications. A controller can 
manage several models, and the models themselves can even be shared amongst
multiple users.

![machine][img__models]
[img__models]: ../media/juju-models.png

## Charms

The magic behind Juju is a collection of software components called Charms. They
contain all the instructions necessary for deploying and configuring 
cloud-based applications. The charms publicly available in the online 
[Charm Store][charmstore] 
represent the distilled DevOps knowledge of experts. Charms make it easy to 
reliably and repeatedly deploy applications, then scale up as required with
minimal effort.

The simplest charm scenario is when one is deployed (by the Juju client) with
the `juju deploy` command without any options to qualify the request. By
default, a new instance will be created in the backing cloud and the
application will be installed within it:

![machine][img__charms]
[img__charms]: ../media/juju-charms.png

## Bundles

A bundle is a ready-to-run collection of applications which have been modelled
to work together - this can include particular configurations and relations
between the software to be deployed. For example, a WordPress bundle may include
the Wordpress charm, the MySQL charm, and the relation between them. When
deployed, the software is set up and relations are made as per the bundle's 
instructions. This is a great way to quickly and reliably deploy complex groups
of applications, and of course you can still use Juju to manage them after 
deployment to scale them any way you wish.

Juju can deploy bundles directly from the command line or the Juju GUI can both
deploy and save bundles. See the [documentation on bundles][bundles] for more
information.

## Machines

A machine is the term used to describe a running instance in the cloud. Machines
will usually house a single unit of a deployed application, but this is not
always the case. If directed by the user a machine may house several units (e.g.
to conserve resources) or possibly no units at all: a machine can be created 
independently of applications, though usually this is with the intention of 
eventually running an application on it!

Represented below is a very standard Juju machine. It has a single deployed
charm:

![machine][img__machine]
[img__machine]: ../media/juju-machine.png

Here we have a machine with a deployed charm in addition to a charm deployed on
a LXD container within that machine:

![machine-lxd][img__machine-lxd]
[img__machine-lxd]: ../media/juju-machine-lxd.png

## Units/Applications

A unit is a running instance of a given Juju application. Simple applications
may be deployed with a single application unit, but it is possible for an
individual application to have multiple units running in independent machines.
All units for a given application will share the same charm, the same
relations, and the same user-provided configuration.

For instance, one may deploy a single MongoDB application, and specify that it
should run three units (with one machine per unit), so that the replica set is
resilient to failures. Internally, even though the replica set shares the same
user-provided configuration, each unit may be performing different roles within
the replica set, as defined by the charm.

The following diagram represents the scenario described above. For simplicity,
the agents have been omitted:

![units][img__units]
[img__units]: ../media/juju-machine-units.png

## Relations

The above section described the possibility of running several instances of the
same application. In general, however, few applications are designed to be run
in isolation and charms contain the knowledge of how to connect different
applications together. These inter-application connections are called
*relations* and they are formed by connecting *interfaces* of the same type.

For example, WordPress supports, among others, an 'http' interface (for serving
the website) and a 'db' interface (for the database which stores the content of
the site). Any other application which supports these interface types can
connect to the WordPress charm in a meaningful way.

Below we see WordPress with relations set up between both MySQL and Apache (a
potential relation is shown with HAProxy):

![relations][img__relations]
[img__relations]: ../media/juju-relations.png

Some of the above application units show unused interfaces. It is the overall
purpose of the installation which will dictate what interfaces get used. Some
relation types are required by the main charm (WordPress here) while some
relation types are optional. A charm's `metadata.yaml` file will expose such
details. See [Managing relations][charms-relations] for more details on
relations.

[maas]: https://maas.io "Metal as a Service"
[bundles]: ./charms-bundles.html
[lxd]: http://www.ubuntu.com/cloud/lxd
[charmstore]: https://jujucharms.com/store
[charms-relations]: ./charms-relations.html 
