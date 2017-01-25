Title: Charm store policy

# Charm store policy

This document serves to record the policies around charms and bundles included
in the charm store, and the management of said collection. Charms and bundles in
the store are peer-reviewed by the community and are considered ready for
production grade consumption. These charms are marked as reviewed in the GUI and
must follow these quality guidelines in ordered to be considered for the Store,
otherwise they can live in personal name spaces.

These guidelines include things the charm/bundle MUST do, requirements that will
return an ERROR if not properly followed are listed first in each section. The
guidelines also include things charm/bundle SHOULD do, strong recommendations
that are not hard requirements but which will return a WARNING if not properly
followed are listed second in each section.

## General guidelines

Not following these guidelines will result in an ERROR (E:) in `charm test`:

- Must follow the spirit of the [Ubuntu Philosophy](http://www.ubuntu.com/about/about-ubuntu/our-philosophy).
- Must serve a useful purpose and have well defined behaviour.
- Must also be valid for the charm and/or bundle format defined in Juju's
    documentation.
- Must verify that any software installed or utilized is verified as coming
    from the intended source.
    - Any software installed from the Ubuntu or CentOS default archives
        satisfies this due to the apt and yum sources including cryptographic
        signing information.
    - Third party repositories must be listed as a configuration option that
        can be overridden by the user and not hard coded in the charm itself.
    - Launchpad PPAs are acceptable as the `add-apt-repository` command
        retrieves the keys securely.
    - Other third party repositories are acceptable if the signing key is
        embedded in the charm.
- Must provide a means to protect users from known security vulnerabilities in
    a way consistent with best practices as defined by either operating system
    policies or upstream documentation. Basically, this means there must be
    instructions on how to apply updates if you use software not from distribution
    channels.
- Must have hooks that are [idempotent](http://en.wikipedia.org/wiki/Idempotence).

<hr>

Not following these guidelines will result in a WARNING (W:) in `charm test`:

- Should be built using [charm layers](authors-charm-building.html).
- Should be delivered using Juju Resources by default.

## Testing and quality guidelines

Not following these guidelines will result in an ERROR (E:) in `charm test`:

- Must pass `charm test`.
  - Results must not result in errors or warnings. These are shown as an E: or W:
      in `charm test`'s output.
- Must include tests. Testing is defined as unit tests, functional tests, or
    integration tests. The tests must exercise:
  - Relations
    - Validate all relations that the charm provides and requires
  - Configuration
    - `set-config`, `unset-config`, and `re-set` must be tested as a minimum
  - Deployment testing
    - Scale test: Production deployment test with multiple units and recommended
        config.
    - Smoke test: Bare minimum to have the application working
- Must not use anything infrastructure-provider specific (i.e. querying EC2
    metadata service) or symlinks. Must be self contained within a charm unless
   the charm is a proxy for an existing cloud service, eg. `ec2-elb` charm.
- Bundles must only use charms which are already in the store, they cannot
           reference charms in personal namespaces.
- Must call Juju API tools (`relation-*`, `unit-*`, `config-*`, etc) without a
             hard coded path.

<hr>

Not following these guidelines will result in a WARNING (W:) in `charm test`:

- Should include `tests.yaml` for all integration tests

## Metadata guidelines

Not following these guidelines will result in an ERROR (E:) in `charm test`:

- Must include a full description of what the software does in the metadata.
- Must have a maintainer email address in metadata.yaml attached to a team or
    individual who are responsive to contact.
- Must include a license. Call the file 'copyright' and make sure all files'
    licenses are specified clearly.
- Must be under a [Free license](http://opensource.org/osd).
- Must have a well documented and valid `README.md`.
  - Fill out the relevant sections as provided by `charm add readme`.
  - Must describe the application.
  - Must describe how it interacts with other applications, if applicable.
  - Must document the interfaces.
  - Must show how to deploy the charm.
  - Must define external dependencies, if applicable.

  <hr>

Not following these guidelines will result in a WARNING (W:) in `charm test`:

- Should link to a recommend production usage bundle and recommended
    configuration if this differs from the default.
- Should reference and link to upstream documentation and best practices.


## Security guidelines

Not following these guidelines will result in an ERROR (E:) in `charm test`:

- Must not run any network applications using default passwords.
- Must verify and validate any external payload
  - Known and understood packaging systems that verify packages like apt,
      pip, and yum are ok.
  - `wget | sh` style is not ok.

  <hr>

Not following these guidelines will result in a WARNING (W:) in `charm test`:

- Should make use of whatever Mandatory Access Control system is provided by
    the distribution:
  - [AppArmor](https://help.ubuntu.com/lts/serverguide/apparmor.html) for Ubuntu.
  - [SELinux](https://wiki.centos.org/HowTos/SELinux) for CentOS systems.
- Should avoid running applications as root.

## Other

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

Check out the [MySQL metadata.yaml]
(https://bazaar.launchpad.net/~charmers/charms/precise/mysql/trunk/view/head:/metadata.yaml) 
as an example.

## config.yaml

Any de-facto config options must be kept at least until the next major charm
series release. Removed config options should be deprecated first by noting that
they are deprecated, and why, in their description. Instructions for converting
values must be added to README as well.

Each [configuration option](authors-charm-config.html#charm-configuration)
must have `type`, `description`, and `default` fields that give users more
information about the option and how it can be used.

## README.md

Charms that want to display instructions to users can do so in plain text
by including a file called README. If the author would like to use Markdown, the
file should be called README.md, and if the author would like to use
restructured text, the file should be called README.rst. Only one of these files
can be included in the charm. We recommend Markdown due to its popularity and
tooling.

Remember that the README is used by the GUI and website as the default "front
page" of the charm: it is user facing and should include easy to read
instructions for deployment.

A bundle's README is used by the GUI and the website as the default "front page"
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
