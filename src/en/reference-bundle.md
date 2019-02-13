Title: Bundle reference

# Bundle reference

*This reference page applies to non-Kubernetes bundles only.*

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

 - the series stated for an application (see `series` under the
   `<application name>` element)
 - the series given by the top level `series` element
 - the top-most series specified in a charm's `metadata.yaml` file
 - the most recent LTS release

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
# description:
#
# Provides a description for the bundle. Visible in the Charm Store only.
#

description: This is a test bundle.

description: |

  This description is long and has multiple lines. Use the vertical bar as
  shown in this example.

#
# series:
#
# Sets the default series for all applications in the bundle. This also affects
# machines devoid of applications. See 'Charm series' above for how a final
# series is determined.
#

series: bionic

#
# tags:
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
    # charm:
    #
    # States what charm to use for the application. A fully qualified charm URI
    # should be used for public bundles. In particular, the revision number
    # should be appended to the charm name (e.g. name-123).
    #

    charm: cs:~containers/easyrsa-195

    #
    # series:
    #
    # Sets the series for the application. See 'Charm series' above for how a
    # final series is determined.
    #

    series: bionic

    #
    # resources:
    #
    # States what charm resource to use. The keys are application-specific and
    # are found within the corresponding charm's metadata.yaml file. To refer
    # to the resource revision stored in the Charm Store an integer value is
    # used. To refer to a local resource a string (file path) is used. For the
    # latter, both absolute and relative (to the bundle file) paths are
    # supported.
    #

    resources:
      easyrsa: 5

    resources:
      easyrsa: ./relative/path/to/file

    resources:
      easyrsa: /absolute/path/to/file

    #
    # num_units:
    #
    # Specifies the number of units to deploy. The default value is '0'. 
    #

    num_units: 2

    #
    # to:
    #
    # Dictates the placement (destination) of the deployed units in terms of
    # machines, applications, units, and containers that are defined elsewhere
    # in the bundle. The number of destinations cannot be greater than the
    # number of requested units (see 'numb_units' above). Zones are not
    # supported; see the 'constraints' element instead. The value types are
    # given below.
    #
    #  new
    #     Unit is placed on a new machine. This is the default value type; it
    #     does not require stating. This type also gets used if the number of
    #     destinations is less than than 'num_units'.
    #
    #  <machine>
    #     Unit is placed on an existing machine denoted by its (unquoted) ID.
    #

    to: 3, new

    #
    #  <unit>
    #     Unit is placed on the same machine as the specified unit. Doing so
    #     must not create a loop in the placement logic. The specified unit
    #     must be for an application that is different from the one being
    #     placed.
    #
    
    to: ["django/0", "django/1", "django/2"]

    #
    #  <application>
    #     The application's existing units are iterated over in ascending
    #     order, with each one being assigned as the destination for a unit to
    #     be placed. New machines are used when 'num_units' is greater than the
    #     number of available units. The same results can be obtained by
    #     stating the units explictily with the 'unit' type above.
    #

    to: ["django"]

    #
    #  <container-type>:new
    #     Unit is placed inside a container on a new machine. The value for
    #     `<container-type>` can be either 'lxd' or 'kvm'. A new machine is the
    #     default and does not require stating, so ["lxd:new"] or just ["lxd"].
    #

    to: ["lxd"]

    #
    #  <container-type>:<machine>
    #     Unit is placed inside a new container on an existing machine.
    #

    to: ["lxd:2", "lxd:3"]

    #
    #  <container-type>:<unit>
    #     Unit is placed inside a container on the machine that hosts the
    #     specified unit. If the specified unit itself resides within a
    #     container, then the resulting container becomes a peer (sibling) of
    #     the other (i.e. no nested containers).
    #

    to: ["lxd:nova-compute/2", "lxd:glance/3"]

    #
    # expose:
    #
    # Exposes the application using a boolean value. The default value is
    # 'false'.
    #

    expose: true

    #
    # options:
    #
    # Sets configuration options for the application. The keys are
    # application-specific and are found within the corresponding charm's
    # metadata.yaml file.
    #

    options:
      osd-devices: /dev/sdb
      worker-multiplier: 0.25

    #
    # annotations:
    #
    # Affects the GUI only. It provides horizontal and vertical placement of
    # the application's icon on the GUI's canvas. Annotations are expressed in
    # terms of 'x' and 'y' coordinates.
    #

    annotations:
      gui-x: 450
      gui-y: 550

    #
    # constraints:
    #
    # Sets standard constraints for the application. As per normal behaviour,
    # these become the application's default constraints (i.e. units added
    # subsequent to bundle deployment will have these constraints applied).
    #

    constraints: root-disk=8G

    constraints: cores=4 mem=4G root-disk=16G

    constraints: zones=us-east-1a

    #
    # storage:
    #
    # Sets storage constraints for the application. There are three such
    # constraints: 'pool', 'size', and 'count'. The key (label) is
    # application-specific and are found within the corresponding charm's
    # metadata.yaml file. A value string is one that would be used in the
    # argument to the `--storage` option for the `deploy` command.
    #

    storage:
      database: ebs,10G,1

    #
    # bindings:
    #
    # Maps endpoints to network spaces. Used to constrain relations to specific
    # subnets in environments where machines have multiple network devices.
    #

    bindings:
      kube-api-endpoint: internal
      loadbalancer: dmz
    
    #
    # plan:
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
# pair of lines, where one line begins with two dashes and the other begins
# with a single dash. Eache side of a relation (each line) has the format
# '<application>:<endpoint>', where 'application' must also be represented
# under the 'applications' element. Including the endpoint is not stricly
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
