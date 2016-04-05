Title: Juju concepts


!!! Note: This page is a work in progress, as part of the work towards 
documenting Juju 2.0.

# Juju concepts

## The Juju client

The Juju package which you install and run from your local computer is sometimes
referred to as the Juju client. This is the software which manages your 
connection to Juju controllers in the cloud, and from which you issue commands
to deploy and manage services.

## Clouds

In Juju terms, the cloud is the environment which provides resources to be used
by Juju - machines and storage. This includes traditional public clouds, such
as Amazon Web Services, Google Compute Engine and Microsoft Azure, as well as
(possibly private) clouds such as OpenStack.

It also includes things which may not strictly speaking be clouds, but Juju can
treat as a cloud, such as [MAAS][maas] and your local computer using LXD.


## The Juju controller

The controller is a special instance which Juju will create in a cloud when you
run the bootstrap command. The controller is effectively a Juju agent which runs
inside the cloud, and it maintains the models that you create there. You can run
multiple controllers with Juju, and each can maintain multiple models.

## Models

A model is the space within which you can deploy services. A controller can 
manage several models, and the models themselves can even be shared amongst
multiple users.

## Charms

The magic behind Juju is a collection of software components called Charms. They
contain all the instructions necessary for deploying and configuring 
cloud-based services. The charms publicly available in the online Charm Store 
represent the distilled DevOps knowledge of experts. Charms make it easy to 
reliably and repeatedly deploy services, then scale up as required with minimal 
effort.

## Relations

Few services are designed to be run in isolation. Juju charms also contain the
knowledge of how to connect services together using common interfaces they
share. For example, WordPress supports an 'http' interface (for serving the 
website) and a 'db' interface (for the database which stores the content of
the site). Any other service which can support these interfaces(e.g haproxy for
the website and MySQL for the database) can connect to the WordPress charm in 
a meaningful way.

## Bundles

A bundle is a ready-to-run collection of services that have been modelled to 
work together - this can include particular configurations and relations
between the services to be deployed. For example, a WordPress bundle may include
the Wordpress charm, the MySQL charm, and the relation between them. When
deployed, the services are set up and relations are made as per the bundles 
instructions. This is a great way to quickly deploy complex groups of services
reliably, and of course you can still use Juju to manage them after deployment 
to scale them any way you wish.

Juju can deploy bundles directly from the command line or the Juju GUI can both
deploy and save bundles. See the [documentation on bundles][bundles] for more
information.

## Machines

A machine is the term used to describe a running instance in the cloud. Machines
will usually house a single unit of a deployed service, but this is not always 
the case. If directed by the user a machine may house several units (e.g. to 
conserve resources) or possibly no units at all: a machine can be created 
independently of services, though usually this is with the intention of 
eventually running a service on it!

## Units

A unit is a running instance of a given Juju service. Simple services may be 
deployed with a single service unit, but it is possible for an individual 
service to have multiple service units running in independent machines. All 
service units for a given service will share the same charm, the same 
relations, and the same user-provided configuration.

For instance, one may deploy a single MongoDB service, and specify that it 
should run 3 units, so that the replica set is resilient to failures. 
Internally, even though the replica set shares the same user-provided 
configuration, each unit may be performing different roles within the replica 
set, as defined by the charm.

[maas]: https://maas.io "Metal as a Service"
[bundles]: ./charms-bundles.html
