Title: Implicit relations  

# Implicit relations

Implicit relations allow for interested services to gather lifecycle-oriented
events and data about other services without expecting or requiring any
modifications on the part of the author of the other service's charm.

Implicit relationships are named in the reserved juju-* namespace. Both the
relation name and interface names provided by Juju are prefixed with `juju-`.
Charms attempting to provide new relationships in this namespace will trigger an
error.

Juju currently provides one implicit relationship to all deployed services:

`juju-info`, if specified would look like:

    provides:
      juju-info:
        interface: juju-info

The charm author should not declare the `juju-info` relation and is provided
here only as an example. The `juju-info` relation is implicitly provided by all
charms, and enables the requiring unit to obtain basic details about the
related-to unit. The following settings will be implicitly provided by the
remote unit in a relation through its `juju-info` relation

    private-address
    public-address

## Relationship resolution

`rsyslog` is a [_subordinate charm_](./authors-subordinate-applications.html) and
requires a valid `scope: container` relationship in order to deploy. It can take
advantage of optional support from the principal charm but in the event that the
principal charm doesn't provide this support it will still require a
`scope: container` relationship. In this event the logging charm author can take
advantage of the implicit relationship offered by all charms, `juju-info`.

    requires:
      logging:
          interface: logging-directory
          scope: container
      juju-info:
          interface: juju-info
          scope: container

The admin then issues the following

    juju add-relation wordpress rsyslog

If the wordpress charm author doesn't define the `logging-directory` interface,
Juju will use the less-specific (in the sense that it likely provides less
information) `juju-info` interface. Juju always attempts to match user provided
relations outside the `juju-*` namespace before looking for possible
relationship matches in the `juju-*` namespace.
