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
# Provides a description for the bundle. Visible in the Charm Store only.
#

description: This is a test bundle.

description: |

  This description is long and has multiple lines. Use the vertical bar as
  shown in this example.

#
# series: <string>
#
# Sets the default series for any machine or application in the bundle that
# does not have a series set explicitly via a charm URL (see 'charm' under
# 'applications'). Optional.
#

series: bionic

#
# tags: [<comma delimited list of strings>]
#
# Sets descriptive tags. A tag is used for organisational purposes in the
# Charm Store. See https://docs.jujucharms.com/authors-charm-metadata for the
# list of valid tags. Optional.
#

tags: [monitoring]

tags: [database, utility]

#
# applications:
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
#     constraints: <space delimited list of strings>
#     storage:
#       <charm key>: <list of storage constraints>
#     devices:
#       <charm key>: <list of device constraints> ?
#     bindings:
#       <endpoint>: <network-space>
#       <endpoint>: <network-space>
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

    #
    # charm: <string>
    #
    # States what charm to use. Use a fully qualified charm URI for public
    # bundles. In particular, include the revision number by appending
    # '-<revision-id>' to the charm name.
    #

    charm: cs:~containers/easyrsa-195

    #
    # series: <string>
    #
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
    # Exposes the applilcation. Default value is 'false'.
    #

    expose: true

    #
    # options: <map of string to string>
    #
    # Sets configuration options for the application. The keys are
    # application-specific and are found within the corresponding charm's
    # metadata.yaml file.
    #

    options:
       osd-devices: /dev/sdb
       worker-multiplier: 0.25

    #
    # annotations: <map of string to string>
    #
    # Affects the GUI only. It provides horizontal and vertical placement of
    # the application's icon on the GUI's canvas. Annotations are expressed in
    # terms of 'x' and 'y' coordinates.
    #

    annotations:
      gui-x: 450
      gui-y: 550

    #
    # constraints: <space delimited list of strings>
    #
    # Sets constraints for the application. As per normal behaviour, these
    # constraints become the application's default constraints (i.e. units
    # added subsequent to bundle deployment will have these constraints
    # applied.
    #

    constraints: root-disk=8G

    constraints: cores=4 mem=4G root-disk=16G

    #
    # storage:
    #

    storage:
      database: ebs,10G,1

    #
    # devices:
    #

    #
    # bindings:
    #
    # Maps endpoints to network spaces. Used to constrain relations to specific
    # underlying network devices in environments where machines have multiple
    # devices.
    #

    bindings:
      kube-api-endpoint: int
      loadbalancer: dmz
    
    #
    # plan: <string>
    #
    # This is for third-party Juju support only. It sets the "managed
    # solutions" plan for the application. The string has the format
    # '<reseller-name>/<plan name>'.
    #

    plan: acme-support/default

#
# machines:
#
# Provides machines that have been targeted by the 'to' key under the
# '<application name>' element. A machine is denoted by that same machine ID,
# and must be quoted. Keys for 'constraints', 'annotations', and 'series' can
# optionally be added to each machine. Containers are not valid machines in
# this context.
#

machines:
  "1":
  "2":
    series: bionic
    constraints: cores=2 mem=2G
  "3":
    constraints: cores=3 root-disk=1T

#
# relations:
#
# States the relations to add between applications. Each relation consists of a
# pair of lines, where one line begins with double dashes and the other begins
# with a single dash. Eache side of a relation (each line) has the format
# '<application>:<endpoint>', where 'application' must also be represented
# under the 'applications' element. Including 'endpoint' is not stricly
# necessary as it might be determined automatically. However, it is best
# practice to do so.
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
