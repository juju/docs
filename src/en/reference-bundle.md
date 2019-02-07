Title: Bundle reference

# Bundle reference

 Comments start with a hash
# There are six top level

#
# series: <string>
#
# Optional
#
# It sets the default series for any machine or application that does not have
# a series set explicitly in some other way.
#

series: bionic

#
# description: <string>
#
# description is used primarily for information purposes and shown in
# the charm store, and isn't currently shown anywhere in Juju once
# the bundle is deployed

description: This bundle does something very cool

# tags: (list of strings)
# tags are again used just for the charmstore, and I believe that these
# items are a particular curated list that is understood by the
# charmstore, but I'm not entirely sure. The examples here just show how
# multiple values would look, not actual useful tags.
tags: [database, utility]
# tags: [one-item]

# applications: (map of string to application data)
# The application data is a nested structure, which I'll document by
# example. The key value is used as the name of the application.
applications:
  easyrsa:
    # charm: (string)
    # This is required, and should be a fully qualify charm URI for
    # public bundles. This means it has the -<revid> at the end of the
    # charm name.
    charm: cs:~containers/easyrsa-195

    # series: (string) - optional
    # This series would define which series to use for deploying the
    # application. The determination of the series actually used
    # starts with this value, if not this one, the top level series
    # should be used, if there isn't one there, the recommended series
    # from the charm is used (the first in the list of supported series)
    # if there isn't one there, the model default series is used.
    series: bionic

    # resources: (map of string to [int or string])
    # The key in the map is the name of the resource defined by the
    # charm. If the value is an integer it refers to the resource
    # revision stored in the charmstore for the specified charm
    # resource.
    # If the value is a string, it is the path to a local file to
    # upload as the resource for the application.
    resources:
      easyrsa: 5
      # paths are relative to where the bundle file is
      # easyrsa: ./relative/path/to/file
      # easyrsa: /absolute/path/to/file

    # num_units: (int)
    # Specifies the number of units to deploy.
    # There have long been arguments around whether we should treat a
    # missing value as one or zero. Currently it is treated as zero.
    # The reason we haven't made the default one is that subordinate
    # charms cannot have any units added the normal way, and the code
    # that pulls the bundle apart into actions doesn't have access to
    # the charm internals, so can't know if the charm is a subordinate
    # or not.
    num_units: 1

    # to: (list of strings)
    # This controls the placement of the specified number of units.
    # The list can be up to <num_units> long, but not longer.
    # The string value should match the regular-expression-like
    # patthern:
    #    (<containertype>:)?(<unit>|<application>|<machine>|new)
    # Any specified application, machine or unit must be defined
    # in the bundle.
    # Here are the meanings of the values:
    #  new - units are placed on new machines
    #  <container>:new - units are placed inside a container on a
    #      new machine (e.g.  lxd:new, kvm:new)
    #  <machine> - place a unit on the specified machine. (e.g.  [1])
    #     Note, the 1 doesn't have to be quoted as the list is parsed
    #     as a list of strings, so it won't be identified as an integer.
    #  <container>:<machine> - place the unit inside a new container of
    #     the specified type on the specified machine (e.g. [lxd:1])
    #  <unit> - place a unit next to the specified unit. The specified
    #     unit must be a different application and not have a loop in
    #     placement directives.
    #  <container>:<unit> - put the unit in a container on the machine
    #     that hosts the specified unit. Here is an edge case. If the
    #     specified unit is in a container, then the container is
    #     created on the same host, so the units become siblings.

    # expose: (boolean) - optional
    # If true the application is exposed.
    expose: true

    # options: (map of string to value)
    # This is charm config specified for the application. The keys and
    # values correspond to the config specified by the charm.
    options:
       key: value-1
       other: 23.4

    # annotations: (map of string to string)
    # All application have annotations which are almost always hidden
    # from the user. The GUI uses this to store x,y coordinates for the
    # location of the application on the canvas. Not much else uses
    # annotations at this stage, and there is no CLI to set or read
    # them.
    annotations:
      gui-x: '450'
      gui-y: '550'

    # constraints: (string)
    # if specified, the value needs to be a valid constraints string.
    # Any constraints specified here are saved with the application so
    # additional units added later use the same constraints
    constraints: root-disk=8G

    # storage: (map string to string)
    storage:
      database: ebs,10G,1

    # devices: (map string to string)
    # Also Ian for more details.

    # bindings: (map string to string)
    # Maps how relation endpoints are mapped to spaces.
    # This is used to limit certain relations to certain underly network
    # devices. Only really makes sense in environments where machines
    # have multiple network devices. Like deploying openstack on MAAS.
    # Definitely advanced usage.

    # plan: (string)
    # This is new to me and probably Casey Marshall is the right person
    # to get plan information.

# machines: (map of string to machine data)
# I'll also document the machine doc by example. The keys while strings
# are actually the machine IDs, which are numbers.
# Only top level machines can be specified this way, no containers.
# Since the values are strings, they need to be quoted to disambiguate
# the parsed value from an integer.
machines:
  # It is possible to specify a machine with no extra information by
  # just leaving nothing after the :
  "1":
  "2":
     # Machines can have constraints, annotations, and series keys.
     # They have the same meanings as the application ones.

# relations: (list of list of strings)
# The relations specify the relations to add between applications.
# Each top level list value is a relation, and that top level item
# is to be another list of two string values.
# The applications specified in the relations must be defined in the
# applications section.
# The string values identify <application>:<relation name>.
# The relation name isn't strictly necessary if juju can determine
# which endpoint to use itself. However it is best practice to be
# explicit in bundles and specify the relation name for both ends
# of the relation.
relations:
- - kubernetes-master:kube-api-endpoint
  - kubeapi-load-balancer:apiserver
- - kubernetes-master:loadbalancer
  - kubeapi-load-balancer:loadbalancer
