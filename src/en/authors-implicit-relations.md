[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

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

`rsyslog` is a [ _subordinate charm_](authors-subordinate-services.html) and
requires a valid `scope: container` relationship in order to deploy. It can take
advantage of optional support from the principal charm but in the event that the
principal charm doesn't provide this support it will still require a `scope:
container` relationship. In this event the logging charm author can take
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

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

