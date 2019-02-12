Title: Bundle reference

# Bundle reference

A bundle is defined by a [YAML-formatted][yaml] file with a fixed set of
elements. This document will define the properties allowed in such a file and
give the format of expressing them by way of examples.

A bundle file makes available a number of charm series settings. A section on
how a charm's series is ultimately determined is therefore presented first.

Page [Charm bundles][charms-bundles] gives an overview of bundle usage.

## Charm series

What series a charm will use can be influenced in several ways. Some of these
are set within the bundle file while some are not. When using bundles, the
series is determined using rules of precedence (most preferred to least):

 - the series stated in a charm URL (see `charm` under the
   `<application name>` element)
 - the series stated for an application (see `series` under the
   `<application name>` element)
 - the series given by the top level `series` element
 - the top-most series specified in a charm's `metadata.yaml` file

## Bundle file properties and format

Comments (lines that begin with a '#' character) are used to explain various
parts of the file. In addition, any line that is not a comment should be
considered as an example. If such a line is duplicated it is for the sole
purpose of showing another example. Do not duplicate lines in a real bundle
file.

A bundle file has six top level elements:

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
# Sets the default series for all applications in the bundle. This also affects
# machines devoid of applications. Optional. See 'Charm series' above for how a
# final series is determined.
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
# The top level of a nested structure containing application data.
#

applications:

  #
  # <application name>:
  #
  # Sets the name of the application. It is typically the same as the charm
  # name.
  #
  
  easyrsa:

    #
    # charm: <string>
    #
    # States what charm to use for the application. A fully qualified charm URI
    # should be used for public bundles. In particular, the revision number
    # should be appended to the charm name (e.g. name-123). A series can
    # specified within the URI. See 'Charm series' above for how a final series
    # is determined.
    #

    charm: cs:~containers/easyrsa-195

    charm: cs:xenial/easyrsa-195

    #
    # series: <string>
    #
    # Sets the series for the application. Optional. See 'Charm series' above
    # for how a final series is determined.
    #

    series: bionic

    #
    # resources: <map of string to [int or string]>
    #
    # States what charm resource to use. Optional. The keys are
    # application-specific and are found within the corresponding charm's
    # metadata.yaml file. To refer to the resource revision stored in the Charm
    # Store an integer value is used. To refer to a local resource a string
    # (file path) is used. For the latter, both absolute and relative (to the
    # bundle file) paths are supported.
    #

    resources:
      easyrsa: 5

    resources:
      easyrsa: ./relative/path/to/file

    resources:
      easyrsa: /absolute/path/to/file

    #
    # num_units: <integer>
    #
    # Specifies the number of units to deploy. The default value is '0'. 
    #

    num_units: 2
# Any specified unit, application, or machine must be defined in the
    # bundle. 
    #
    # to: <comma separated list of strings>
    #
    # Dictates the placement (destination) of the deployed units. Optional. The
    # list of destinations cannot be greater than the number of units requested
    # (see 'numb_units' above). The possible values are given below (the
    # examples assume 'num_units: 2'):
    #
    #  new
    #     Units are placed on new machines. This is the default value.

    to: new, new
    
    #  <machine>
    #     Units are placed on existing machines, which are expressed by their
    #     (unquoted) IDs.

    to: 1, 2
    
    #  <unit>
    #     Units are placed next to the specified unit, which must be of a
    #     different application and must not create a loop in the placement
    #     logic.

    to: 1, new
    
    #  <application>
    #     Units are placed inside a container on the machine that hosts the
    #     specified unit. If the specified unit itself resides within a
    #     container, then the resulting container becomes a peer of the other
    #     (no nested containers).

    to: 1, new
    
    #  <container-type>:new
    #     Units are placed inside a container on a new machine. The value for
    #     `<container-type>` can be either 'lxd' or 'kvm'.

    to: 1, new
    
    #  <container-type>:<machine>
    #     Units are placed inside a new container on an existing machine.

    to: 1, new
    
    #  <container-type>:<unit>
    #     Units are placed inside a container on the machine that hosts the
    #     specified unit. If the specified unit itself resides within a
    #     container, then the resulting container becomes a peer of the other
    #     (no nested containers).

    to: 1, new
    
    #
    # expose: <boolean>
    #
    # Exposes the applilcation. The default value is 'false'.
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
    # become the application's default constraints (i.e. units added subsequent
    # to bundle deployment will have these constraints applied).
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
    # bindings: <map of string to string>
    #
    # Maps endpoints to network spaces. Used to constrain relations to specific
    # subnets in environments where machines have multiple network devices.
    #

    bindings:
      kube-api-endpoint: internal
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
# machines: <map of string to machine data>
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


# relations: <list of list of strings>
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
