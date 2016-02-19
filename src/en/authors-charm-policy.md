Title: Charm store policy  

# Charm store policy

This document serves to record the policies around charms and bundles included
in the charm store, and the management of said collection. Charms and bundles in
the store are peer reviewed by the community and are considered ready for
consumption. These charms are marked as reviewed in the GUI and must follow
these quality guidelines in ordered to be considered for the Store. These charms
and bundles must:

  - Must follow the spirit of the [Ubuntu Philosophy](http://www.ubuntu.com/about/about-ubuntu/our-philosophy).
  - Must serve a useful purpose and have well defined behaviour.
  - Must also be valid for the charm and/or bundle format defined in Juju's
    documentation.
  - Must verify that any software installed or utilized is verified as coming
    from the intended source. Any software installed from the Ubuntu archive
    satisfies this due to the apt sources including cryptographic signing
    information.
  - Must be entirely self contained or depend only on reliable external services.
  - Must include a full description of what the software does in the metadata.
  - Must provide a means to protect users from known security vulnerabilities in
    a way consistent with best practices as defined by either Ubuntu policies or
    upstream documentation. Basically this means there must be instructions on
    how to apply updates if you use software not from Ubuntu.
  - Must pass "[charm proof](./tools-charm-tools.html#proof)" or 
    "[bundle proof](./tools-charm-tools.html#proof)" with no Errors or Warnings
    (lines prefixed with E: or W:).
  - Must have a maintainer email address in metadata.yaml attached to a team or
    individual who are responsive to contact.
  - Must include a license. Call the file 'copyright' and make sure all files'
    licenses are specified clearly.
  - Must be under a [Free license](http://opensource.org/osd).
  - Must have hooks that are [idempotent](http://en.wikipedia.org/wiki/Idempotence).
  - Must not run any network services using default passwords.
  - Must call Juju API tools (`relation-*`, `unit-*`, `config-*`, etc) without a
    hard coded path. Should default to use software that is included in the
    Ubuntu archive, however we encourage that charm authors have a config
    options for allowing users to deploy from newer upstream releases, or even
    right from VCS if it's useful to users.
  - Should not use anything infrastructure-provider specific (i.e. querying EC2
    metadata service) symlinks must be self contained within a charm.
  - Should make use of 
    [AppArmor](https://help.ubuntu.com/12.04/serverguide/apparmor.html) to
    increase security.
  - Bundles must only use charms which are already in the store, they cannot
    reference charms in personal namespaces.
  - Must include tests for trusty series and any series afterwards. Testing is
    defined as unit tests, functional tests, or integration tests.

The charm store referred to in this document is the collection of Juju charms
and bundles hosted at
[https://launchpad.net/charms](https://launchpad.net/charms).

If a charm is no longer being properly maintained and is failing to adhere to
policy the charm will undergo the
[unmaintained charm process](./charm-unmaintained-process.html). This process
confirms the charm is no longer being maintained, fails to adhere to Charm Store
policy, and thus is removed from the recommended status in the Juju Charm Store. 

# Charm metadata

## metadata.yaml

This file is an [important component](authors-charm-components.html) of a charm.

Check out the [MySQL metadata.yaml](https://bazaar.launchpad.net/~charmers/charm
s/precise/mysql/trunk/view/head:/metadata.yaml) as an example.

## config.yaml

Any de-facto config options must be kept at least until the next major charm
series release. Removed config options should be deprecated first by noting that
they are deprecated, and why, in their description. Instructions for converting
values must be added to README as well.

Each [configuration option](authors-charm-config.html#charm-configuration)
must have `type`, `description`, and `default` fields that give users more
information about the option and how it can be used.

## README.md

Charms that want to display instructions to users can do so in either plain text
by including a file called README. If the author would like to use markdown, the
file should be called README.md, and if the author would like to use
restructured text, the file should be called README.rst. Only one of these files
can be included in the charm. We recommend Markdown due to its popularity and
tooling.

Remember that the README is used by the GUI and website as the default "front
page" of the charm: it is user facing and should include easy to read
instructions for deployment.

A bundle's README is use by the GUI and the website as the default "front page"
of the bundle, so it should not only include information on how to use the
bundle, but also mention which charms the bundle contains and how the bundle is
meant to be used.

## Interfaces

Charms should only implement a new interface when existing interfaces are
insufficient to achieve the goal of the charm. Interfaces that have an official
requires/provides in the charm store cannot be changed by adding required fields
or removing existing fields. New optional fields can be added at any time.

The charm store series denotes the OS release that the charms which are
contained within it are intended to run on.

## State

Each series can be in one of these states:

  - Experimental - Charms can be added, but are in a state of flux.
  - Active - The Charm store is actively accepting new charms and changes.
  - Frozen - Only critical fixes are accepted.
  - EOL - The OS version is not supported by the vendor, and thus, neither are
    the charms.

## Experimental

Experimental series charms should adhere to the charm policy except that
interfaces are never made 'de-facto' in an experimental series.

  - Active - When a series is active, all changes are subject to the de-facto
    rules above.
  - Frozen - The charmers team on launchpad has discretion when a series is
    frozen as to whether or not a change should be accepted.
  - EOL - No changes will be accepted except those which help users who need to
    migrate to a supported series.
  - Process - Charm store releases will be moved from Active to Frozen
    periodically to allow de-facto changes to settle and allow testing of
    infrastructure. New releases of target OS's will be reflected in the Charm
    Store as an experimental series. There can be multiple Active series at one
    time. Maintainers can choose whether or not to support their charm in all of
    the Active series, as long as the charm is maintained in at least one Active
    series.
