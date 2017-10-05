Title: Subordinate applications  

# Subordinate applications

Applications are composed of one or more application units. An application unit runs the
application's software and is the smallest entity managed by Juju. Application units
are typically run in an isolated container on a machine with no knowledge or
access to other applications deployed onto the same machine. Subordinate applications
allows for units of different applications to be deployed into the same container
and to have knowledge of each other.

## Why use a subordinate?

Applications such as logging, monitoring, backups and some types of storage often
require some access to the runtime of the application they wish to operate on.
Under the current modeling of applications it is only possible to relate applications
to other applications with an explicit interface pairing. Requiring a specified
relation implies that every charm author need be aware of any and all applications
a deployment might wish to depend on, even if the other application can operate
without any explicit cooperation. For example a logging application may only
require access to the container level logging directory to function.

The following changes are designed to address these issues and allow a class
of charm that can execute in the context of an existing container while still
taking advantage of the existing relationship machinery.

## Terms

**Principal application**: A traditional application or charm in whose container
subordinate applications will execute.

**Subordinate application/charm**: An application designed for and deployed to the
running container of another application unit.

**Container relation**: A scope:container relationship. While modeled
identically to traditional, scope: global, relationships, juju only implements
the relationship between the units belonging to the same container.

## Relations

When a traditional relation is added between two applications, all the application units
for the first application will receive relation events about all application units for
the second application. Subordinate applications have a very tight relationship with
their principal application, so it makes sense to be able to restrict that
communication in some cases so that they only receive events about each other.
That's precisely what happens when a relation is tagged as being a scoped to the
container. See [Relations lifecycle](./authors-relations-in-depth.html).

Container relations exist because they simplify responsibilities for the
subordinate application charm author who would otherwise always have to filter units
of their relation before finding the unit they can operate on.

If a subordinate application needs to communicate with all units of the principal
application, it can still establish a traditional (non-container) relationship to
it.

In order to deploy a subordinate application a scope: container relationship is
required. Even when the principal applications' charm author doesn't provide an
explicit relationship for the subordinate to join, using an 
[_implicit relation_](authors-implicit-relations.html) with scope: container 
will satisfy this constraint.

## Addressability

No special changes are made for the purpose of naming or addressing subordinate
units. If a subordinate logging application is deployed with a single unit of
wordpress we would expect the logging unit to be addressable as logging/0, if
this application were then related to a mysql application with a single unit we'd expect
logging/1 to be deployed in its container. Subordinate units inherit the
public/private address of the principal application. The container of the principal
defines the network setup.

## Declaring subordinate charms

When a charm author wishes to indicate their charm should operate as a
subordinate application only a small change to the subordinate charm's metadata is
required. Adding subordinate: true as a top-level attribute indicates the charm
is intended only to deploy in an existing container. Subordinate charms should
then declare a required interface with scope: container in the relation
definition of the charms metadata. Subordinate applications may still declare
traditional relations to any application. The deployment is delayed until a
container relation is added.

subordinate: false charms (the default) may still declare relations as scope:
container. Principal charms providing or requiring scope: container relations
will only be able to form relations with subordinate: true charms.

The example below shows adding a container relation to a charm.

```yaml
    requires:
      logging-directory:
        interface: logging
        scope: container
```

## Usage

Assume the following deployment:

```bash
juju deploy mysql
juju deploy wordpress
juju add-relation mysql wordpress
```

Now we'll request a subordinate rsyslog-forwarder application:

```bash
juju deploy rsyslog-forwarder
juju add-relation rsyslog-forwarder mysql
juju add-relation rsyslog-forwarder wordpress
```

This will create a rsyslog-forwarder application unit inside each of the
containers holding the mysql and wordpress units. The rsyslog-forwarder
application has a standard client-server relation to both wordpress and mysql
but these new relationships are implemented only between the principal unit and
the subordinate unit. A subordinate unit may still have standard relations
established with any unit as usual.

## Status of subordinates

The status output contains details about subordinate units under the status of
the principal application unit that it is sharing the container with. The
subordinate unit's output matches the formatting of existing unit entries but
omits machine, public-address and subordinates (which are all the same as the
principal unit).

Shown below are two partial excerpts from the output to command
`juju status --format yaml` after the 'wordpress' charm and the
'rsyslog-forwarder' subordinate charm were deployed and a relation added
between the two.

Firstly, the **rsyslog-forwarder** application will show to what application it
is a subordinate of:

```yaml
applications:
  rsyslog-forwarder:
    subordinate-to:
    - wordpress
```

Secondly, in the units sub-section to the **wordpress** application the
subordinate unit will be listed:

```yaml
applications:
  wordpress:
    units:
        subordinates:
          rsyslog-forwarder/0:
```

## Caveats

When a subordinate is related to a single principal application, the
subordinate may be removed by removing the principal-subordinate
relation. This will remove all of the subordinate units from the
principal application's containers. (There's no way to only remove one
of the subordinate units.)


