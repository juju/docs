Title: Juju concepts

# Juju concepts

## Clouds

To Juju, a *cloud* (or backing cloud) is a resource which provides machines
(instances), and possibly storage, in order for application units to be
deployed upon them. This includes public clouds such as Amazon Web Services,
Google Compute Engine, and Microsoft Azure as well as private OpenStack-based
clouds. Juju can also make use of environment which are not clouds per se, but
which Juju can treat as a cloud. [MAAS][maas] and [LXD][lxd] fit into this
latter category.

See [Clouds][clouds] to learn more.

## Controller

The Juju *controller* is the initial cloud instance which is created in order
for Juju to gain access to a cloud. It is created by having the Juju client
contact the cloud's API. The controller is a central management node for the
chosen cloud, taking care of all operations requested by the Juju client.
Multiple clouds (and thus controllers) are possible and each one may contain
multiple models and users.

For more information see [Controllers][controllers].

## Client

The Juju *client* is command line interface (CLI) software that is used to
manage Juju, whether as an administrator or as a regular user. It is installed
onto one's personal workstation. This software connects to Juju controllers and
is used to issue commands that deploy and manage application units running on
cloud instances.

![machine][img__client-2]

In the case of the localhost cloud (LXD), the cloud is housed within the same
system as the Juju client:

![machine][img__client-3]

Although LXD itself can operate over the network, Juju does not support this.
The client *must* be local to the LXD containers.

## Models

A *model* is associated with a single controller and is the space within which
application units are deployed. A controller can have an indefinite number of
models and each model can have an indefinite number of machines (and thus
applications). Models themselves can be shared amongst Juju users.

The controller model is the management model and is intended to contain a
single machine, the actual controller. All other models are considered regular
and are used to run workloads.

![machine][img__models]

See [Juju models][models] for more information.

## Juju agent

The *agent* is software that runs on every Juju machine. There is a *machine
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

## Charms

A Juju *charm* contains all the instructions necessary for deploying and
configuring application units. Charms are publicly available in the online
[Charm Store][charm-store] and represent the distilled knowledge of experts.
Charms make it easy to reliably and repeatedly deploy applications, then scale
up (and down) as desired with minimal effort.

The simplest scenario is when a charm is deployed (by the Juju client) with the
`juju deploy` command without any options to qualify the request. By default, a
new instance will be created in the backing cloud and the application will be
installed within it:

![machine][img__charms]

To learn more about charms see [Introduction to Juju Charms][charms].

## Bundles

A *bundle* is a collection of charms which have been carefully combined and
configured in order to automate a multi-charm solution. For example, a
WordPress bundle may include the 'wordpress' charm, the 'mysql' charm, and the
relation between them. The operations are transparent to Juju and so the
deployment can continue to be managed by Juju as if everything was performed
manually. See [Using and creating bundles][charms-bundles] for more
information.

## Machine

A Juju *machine* is the term used to describe a cloud instance that was
requested by Juju. Machines will usually house a single unit of a deployed
application, but this is not always the case. If directed by the user a machine
may house several units (e.g. to conserve resources) or possibly no units at
all: a machine can be created independently of applications (
`juju add-machine`), though usually this is with the intention of eventually
running an application on it!

Represented below is a very standard Juju machine. It has a single deployed
charm:

![machine][img__machine]

Here we have a machine with a deployed charm in addition to a charm deployed on
a LXD container within that machine:

![machine-lxd][img__machine-lxd]

## Units and applications

A *unit* (or application unit) is deployed software. Simple applications may be
deployed with a single application unit, but it is possible for an individual
application to have multiple units running in different machines. All units
for a given application will share the same charm, the same relations, and the
same user-provided configuration.

For example, one may deploy a single MongoDB application, and specify that it
should run three units (with one machine per unit), so that the replica set is
resilient to failures. Internally, even though the replica set shares the same
user-provided configuration, each unit may be performing different roles within
the replica set, as defined by the charm.

The following diagram represents the scenario described above. For simplicity,
the agents have been omitted:

![units][img__units]

## Relations

The above section described the possibility of running several instances of the
same application. In general, however, few applications are designed to be run
in isolation and charms contain the knowledge of how to connect different
applications together. These inter-application connections are called
*relations* and they are formed by connecting *interfaces* of the same type.

For example, the 'wordpress' charm supports, among others, an 'http' interface
(for serving the website) and a 'db' interface (for the database which stores
the content of the site). Any other application which supports these interface
types can connect to the 'wordpress' charm in a meaningful way.

Below we see WordPress with relations set up between both MySQL and Apache (a
potential relation is shown with HAProxy):

![relations][img__relations]

Some of the above application units show unused interfaces. It is the overall
purpose of the installation which will dictate what interfaces get used. Some
relation types are required by the main charm ('wordpress' here) while some
relation types are optional. A charm's `metadata.yaml` file will expose such
details. See [Managing relations][charms-relations] for more details on
relations.


<!-- LINKS -->

[maas]: https://maas.io "Metal as a Service"
[lxd]: https://linuxcontainers.org/lxd/
[charm-store]: https://jujucharms.com/store
[charms]: ./charms.html
[charms-bundles]: ./charms-bundles.html
[charms-relations]: ./charms-relations.html 
[clouds]: ./clouds.html
[models]: ./models.html

[img__relations]: ./media/juju-relations.png
[img__units]: ./media/juju-machine-units.png
[img__machine-lxd]: ./media/juju-machine-lxd.png
[img__machine]: ./media/juju-machine.png
[img__charms]: ./media/juju-charms.png
[img__models]: ./media/juju-models.png
[img__client-2]: ./media/juju-client-2.png
[img__client-3]: ./media/juju-client-3.png
