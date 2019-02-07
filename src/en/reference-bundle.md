Title: Bundle reference

# Bundle reference

A bundle is defined by a [YAML-formatted][yaml] file with a fixed set of
elements. This document will present and define these elements. See page
[Charm bundles][charms-bundles] for an overview of bundle usage.

In this document, comments (lines that begin with a '#' character) are used to
explain various parts of the file. In addition, any line that is not a comment
should be considered as an example. If such a line is duplicated it is for the
purposes of showing another example. Do not duplicate lines in a real bundle
file.

There are six top level elements:

`description`  
`series`  
`tags`  
`applications`  
`machines`  
`relations`

Some of these are simple key:value pairs while others contain nested
configuration.

```no-highlight
#
# description: <string>
#
# Optional
#
# Provides a description for the bundle. Visible in the Charm Store only.
#

description: This is a test bundle.

description: |

  This description is long and has multiple lines. Use the vertical bar as
  shown in this example.

#
# series: <string>
#
# Optional
#
# Sets the default series for any machine or application in the bundle that
# does not have a series set explicitly via a charm URL (see 'charm' under
# 'applications').
#

series: bionic

#
# tags: [<comma delimited list of strings>]
#
# Optional
#
# Sets descriptive tags. A tag is used for organisational purposes in the
# Charm Store. See https://docs.jujucharms.com/authors-charm-metadata for the
# list of valid tags.
#

tags: [monitoring]

tags: [database, utility]

#
# applications:
#
# Required
#
# The top level of a nested structure containing application data. Immediately
# below is an overview of this structure. It is followed by a detailed
# breakdown of the various elements.
#
# applications:
#   <application name>
#     charm: <string>
#     series: <string>
#     resources:
#       <charm key>: <value>
#     num_units: <integer>
#     to: <string>
#     expose: <boolean>
#     options:
#       <charm key>: <value>
#       <charm key>: <value>
#     annotations:
#       gui-x: <integer>
#       gui-y: <integer>
#     constraints: <list of standard constraints>
#     storage:
#       <charm key>: <list of storage constraints>
#     devices:
#       <charm key>: <list of device constraints> ?
#     bindings:
#       <charm key>: <list of device constraints> ?
#     plan: <string>
#

applications:

  #
  # <application name>
  #
  # Sets the name of the application. It is typically the same as the charm
  # name.
  #
  
  easyrsa:

    # charm: (string)
    # This is required, and should be a fully qualify charm URI for
    # public bundles. This means it has the -<revid> at the end of the
    # charm name.
    #

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

    #
    # expose: <boolean>
    #
    # Optional
    #
    # A value of 'true' exposes the application. Default: 'false'.
    #

    expose: true

    #
    # options:
    #
    # This is charm config specified for the application. The keys and
    # values correspond to the config specified by the charm.
    #

    options:
       key: value-1
       other: 23.4

    #
    # annotations: (map of string to string)
    # All application have annotations which are almost always hidden
    # from the user. The GUI uses this to store x,y coordinates for the
    # location of the application on the canvas. Not much else uses
    # annotations at this stage, and there is no CLI to set or read
    # them.
    #

    annotations:
      gui-x: '450'
      gui-y: '550'

    #
    # constraints: (string)
    # if specified, the value needs to be a valid constraints string.
    # Any constraints specified here are saved with the application so
    # additional units added later use the same constraints
    #

    constraints: root-disk=8G
    constraints: cores=4 mem=4G root-disk=16G

    #
    # storage: (map string to string)
    #

    storage:
      database: ebs,10G,1

    #
    # devices: (map string to string)
    # Also Ian for more details.
    #

    #
    # bindings: (map string to string)
    # Maps how relation endpoints are mapped to spaces.
    # This is used to limit certain relations to certain underly network
    # devices. Only really makes sense in environments where machines
    # have multiple network devices. Like deploying openstack on MAAS.
    # Definitely advanced usage.
    #

    #
    # plan: <string>
    #
    # This is for third-party Juju support only. It sets the Managed Solutions
    # plan for the application. The string has the format
    # <reseller-name>/<plan name>. The plan name of 'default' can be used and
    # is set by the reseller.
    #

#
# machines: (map of string to machine data)
#
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

#
# relations:
#
# Required
#
# States the relations to add between applications. Each relation consists of
# two adjacent lines, where double and single dashes are used to distinguish
# between neighbouring relations. Eache side of a relation (each line) has the
# format '<application>:<endpoint>', where 'application' must be found under
# the 'applications' element in this bundle file. Including 'endpoint' is not
# stricly necessary as it might be determined automatically. However, it is
# best practice to do so.
#

relations:
- - kubernetes-master:kube-api-endpoint
  - kubeapi-load-balancer:apiserver
- - kubernetes-master:loadbalancer
  - kubeapi-load-balancer:loadbalancer
```


<!-- LINKS -->

[charms-bundles]: ./charms-bundles.md
[yaml]: http://www.yaml.org/spec/1.2/spec.html
