Title: Juju concepts

# Juju concepts

## The Juju client

The Juju client is CLI software that is used to manage Juju, whether as an 
administrator or as a regular user. It is installed, via an APT package 
('juju'), onto your personal workstation. This software manages your 
connection to Juju controllers in the cloud, and is used to issue
commands to deploy and manage applications.

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

## Charms

The magic behind Juju is a collection of software components called Charms. They
contain all the instructions necessary for deploying and configuring 
cloud-based applications. The charms publicly available in the online 
[Charm Store][charmstore] 
represent the distilled DevOps knowledge of experts. Charms make it easy to 
reliably and repeatedly deploy applications, then scale up as required with
minimal effort.

## Relations

Few applications are designed to be run in isolation. Juju charms also contain 
the knowledge of how to connect applications together using common interfaces 
they share. For example, WordPress supports an 'http' interface (for serving the 
website) and a 'db' interface (for the database which stores the content of
the site). Any other service which can support these interfaces (e.g haproxy for
the website and MySQL for the database) can connect to the WordPress charm in 
a meaningful way.

## Bundles

A bundle is a ready-to-run collection of applications which have been modelled
to  work together - this can include particular configurations and relations
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

## Units/Applications

A unit is a running instance of a given Juju application. Simple applications 
may be deployed with a single application unit, but it is possible for an
individual application to have multiple units running in independent machines.
All units for a given application will share the same charm, the same 
relations, and the same user-provided configuration.

For instance, one may deploy a single MongoDB application, and specify that it 
should run 3 units, so that the replica set is resilient to failures. 
Internally, even though the replica set shares the same user-provided 
configuration, each unit may be performing different roles within the replica 
set, as defined by the charm.

[maas]: https://maas.io "Metal as a Service"
[bundles]: ./charms-bundles.html
[lxd]: http://www.ubuntu.com/cloud/lxd
[charmstore]: https://jujucharms.com/store
