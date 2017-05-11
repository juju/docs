Title: Glossary  

# Glossary of terms

**Bootstrap** - Initialize a Juju environment so that applications may be
deployed.  Bootstrapping an environment will provision a new machine in the
environment and run the Juju controller (also called the bootstrap node).

**Bundle** - A set of Juju charms, their configuration, and corresponding relations
that can be deployed in a single step. Bundles are defined in the YAML format.

**Charm** - The definition of an application, including its metadata,
dependencies with other applications, required packages, and application
management logic. It is the layer that integrates an external application
component like PostgreSQL or WordPress, traditionally available via APT,
into Juju.

**Charm URL** - A resource locator for a charm, with the following format and
restrictions:

    <schema>:[~<user>/]<collection>/<name>[-<revision>]

  - `schema` must be either "cs", for a charm from the Juju charm store, or
  "local", for a charm from a local repository.

  - `user` is only valid in charm store URLs, and allows you to source charms
  from individual users (rather than from the main charm store); it must be a
  valid Launchpad user name.

  - `collection` denotes a charm's purpose and status, and is derived from the
  Ubuntu series targeted by its contained charms: examples include "precise",
  "trusty", "vivid-universe".

  - `name` is the name of the charm; it must start and end with lowercase
  (ascii) letters, and can otherwise contain any combination of lowercase
  letters, digits, and "-"s.

  - `revision`, if specified, points to a specific revision of the charm
  pointed to by the rest of the URL. It must be a non-negative integer.

**Endpoint** - The combination of a application name and a relation name.

**Environment** - A configured location where applications can be deployed. An
environment typically has a name, which can usually be omitted when there's a
single environment configured, or when a default is explicitly defined.
Depending on the type of environment, it may have to be bootstrapped before
interactions with it may take place (e.g. EC2). The local environment
configuration is defined in the [environments.yaml](getting-started.html#configuring)
file.

**Machine Agent** - Software which runs inside each machine that is part of an
environment, and is able to handle the needs of deploying and managing
application units in this machine.

**Provisioning Agent** - Software responsible for automatically allocating and
terminating machines in an environment, as necessary for the requested
configuration.

**Relation** - The way in which Juju enables applications to communicate with each
other, and the way in which the topology of applications is assembled. The charm
defines which relations it offers to other applications (provides), and what kind
of relations it can make with other applications (requires).

In many cases, the establishment of a relation will result into an actual TCP
connection being created between the application units, but that's not
necessarily the case. Relations may also be established to inform applications
of configuration parameters, to request monitoring information, or any other
details which the charm author has chosen to make available.

**Repository** - A location where multiple charms are stored. Repositories may
be as simple as a directory structure on a local disk, or as complex as a rich
smart server supporting remote searching and so on.

**Application** - Juju operates in terms of applications. A Juju application
is any application (or set of applications) that is integrated into the
framework as an individual component which should generally be joined with
other components to perform a more complex task.

As an example, WordPress could be deployed as an application and, to perform
its tasks properly, might communicate with a database and load
balancer applications.

**Application Configuration** - There are many different settings in a Juju
deployment, but the term `Application Configuration` refers to the settings which a
user can define to customize the behaviour of an application.

The behaviour of an application when its application configuration changes is
entirely defined by its charm.

**Application Unit** - A running instance of a given Juju Application. Simple
applications may be deployed with a single unit, but it is possible for an
individual application to have multiple units running in independent machines.
All units for a given application will share the same charm, the same
relations, and the same user-provided configuration.

For instance, one may deploy a single MongoDB application, and specify that it
should run 3 units, so that the replica set is resilient to failures.
Internally, even though the replica set shares the same user-provided
configuration, each unit may be performing different roles within the replica
set, as defined by the charm.

**Application Unit Agent** - Software which manages the entire lifecycle of a
single application unit.

**Subnet** - A broadcast address range identified by a CIDR like 10.1.2.0/24,
or 2001:db8::/32.

**Space** - A collection of subnets which must be routable between each other
without firewalls. A subnet can be in one and only one space. Connections
between spaces instead are assumed to go through firewalls.

Spaces and their subnets can span multiples zones, if supported by the
cloud provider.

**Zone** - Zones, also known as Availability Zones, are running on physically
distinct, independent infrastructure. They are engineered to be highly reliable.
Common points of failures like generators and cooling equipment are not shared
across Zones. Additionally, they are physically separate, such that even extremely
uncommon disasters would only affect a single Zone.
