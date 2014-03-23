# Subordinate services

Services are composed of one or more service units. A service unit runs the
service's software and is the smallest entity managed by juju. Service units are
typically run in an isolated container on a machine with no knowledge or access
to other services deployed onto the same machine. Subordinate services allows
for units of different services to be deployed into the same container and to
have knowledge of each other.

## Motivations

Services such as logging, monitoring, backups and some types of storage often
require some access to the runtime of the service they wish to operate on. Under
the current modeling of services it is only possible to relate services to other
services with an explicit interface pairing. Requiring a specified relation
implies that every charm author need be aware of any and all services a
deployment might wish to depend on, even if the other service can operate
without any explicit cooperation. For example a logging service may only require
access to the container level logging directory to function.

The following changes are designed to address these issues and allow a class of
charm that can execute in the context of an existing container while still
taking advantage of the existing relationship machinery.

## Terms

 - Principal service: A traditional service or charm in whose container subordinate services will execute.

 - Subordinate service/charm: A service designed for and deployed to the running container of another service unit.

 - Container relation: A scope: container relationship. While modeled identically to traditional, scope: global, relationships, juju only implements the relationship between the units belonging to the same container.

## Relations

When a traditional relation is added between two services, all the service units
for the first service will receive relation events about all service units for
the second service. Subordinate services have a very tight relationship with
their principal service, so it makes sense to be able to restrict that
communication in some cases so that they only receive events about each other.
That's precisely what happens when a relation is tagged as being a scoped to the
container. See *[scoped relations*](charm.html).

Container relations exist because they simplify responsibilities for the
subordinate service charm author who would otherwise always have to filter units
of their relation before finding the unit they can operate on.

If a subordinate service needs to communicate with all units of the principal
service, it can still establish a traditional (non-container) relationship to
it.

In order to deploy a subordinate service a scope: container relationship is
required. Even when the principal services' charm author doesn't provide an
explicit relationship for the subordinate to join, using an *[implicit relation
*](implicit-relations.html) with scope: container will satisfy this constraint.

## Addressability

No special changes are made for the purpose of naming or addressing subordinate
units. If a subordinate logging service is deployed with a single unit of
wordpress we would expect the logging unit to be addressable as logging/0, if
this service were then related to a mysql service with a single unit we'd expect
logging/1 to be deployed in its container. Subordinate units inherit the
public/private address of the principal service. The container of the principal
defines the network setup.

## Declaring subordinate charms

When a charm author wishes to indicate their charm should operate as a
subordinate service only a small change to the subordinate charm's metadata is
required. Adding subordinate: true as a top-level attribute indicates the charm
is intended only to deploy in an existing container. Subordinate charms should
then declare a required interface with scope: container in the relation
definition of the charms metadata. Subordinate services may still declare
traditional relations to any service. The deployment is delayed until a
container relation is added.

subordinate: false charms (the default) may still declare relations as scope:
container. Principal charms providing or requiring scope: container relations
will only be able to form relations with subordinate: true charms.

The example below shows adding a container relation to a charm.

    requires:
      logging-directory:
        interface: logging
        scope: container

## Status of subordinates

The status output contains details about subordinate units under the status of
the principal service unit that it is sharing the container with. The
subordinate unit's output matches the formatting of existing unit entries but
omits machine, public-address and subordinates (which are all the same as the
principal unit).

The subordinate service is listed in the top level services dictionary in an
abbreviated form. The subordinate-to: [] list is added to the service which
contains the names of all services this service is subordinate to.

    services:
      rsyslog:
        charm: cs:precise/rsyslog-0
        exposed: false
        relations:
          rsyslog-directory:
          - wordpress
        subordinate-to:
        - wordpress
      wordpress:
        charm: cs:precise/wordpress-13
        exposed: true
        relations:
          rsyslog-directory:
          - rsyslog
        units:
          wordpress/0:
            agent-state: started
            agent-version: 1.14.1.1
            machine: "3"
            open-ports:
            - 80/tcp
            public-address: 10.0.3.11
            subordinates:
              rsyslog/0:
                agent-state: started
                agent-version: 1.14.1.1
                public-address: 10.0.3.11

## Usage

Assume the following deployment:

    juju deploy mysql
    juju deploy wordpress
    juju add-relation mysql wordpress

Now we'll create a subordinate rsyslog service:

    juju deploy rsyslog
    juju add-relation rsyslog mysql
    juju add-relation rsyslog wordpress

This will create a rsyslog service unit inside each of the containers holding
the mysql and wordpress units. The rsyslog service has a standard client-server
relation to both wordpress and mysql but these new relationships are implemented
only between the principal unit and the subordinate unit . A subordinate unit
may still have standard relations established with any unit in its environment
as usual.

## Restrictions

The initial release of subordinates doesn't include support for removing
subordinate units from their principal service apart from removing the principal
service itself. This limitation stems from the current policy around service
shutdown and the invocation of stop hooks.
