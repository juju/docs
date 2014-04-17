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

# Charm configuration

The optional `config.yaml` file defines how a service running the charm can be
configured by its user.

If it exists, it must contain a dictionary of `options`, in which each possible
setting is named by the key and defined by the value. An option definition may
contain any number of the following fields:

  - `type` can be `string`, `int`, `float`, or `boolean`. If not present, it defaults to `string`.
  - `description` should contain an explanation of what the user might achieve by altering the setting.
  - `default` should, if present, contain a value of the appropriate type. If not present it is treated as null (which is always a valid value in this context); an option with no default will not normally be reported by the config-get [hook tool](./authors-hook-environment.html) unless it has been explicitly set.

## What to expose to users

The charm configuration is deliberately somewhat restrictive, in the hope of
encouraging charmers to expose only features that are clear and comprehensible.
The user doesn't want to configure the software - they want to configure the
_service_, which exists at a higher level of abstraction. A charm with a single
opinionated `tuning` option is, from this perspective, infinitely superior to
one that exposes 6 arcane options that correspond directly to flags or config
settings for the software.

In short, the config is part of the user interface for the charm - it needs to
be concise and as easy to understand and use as possible. If you're considering
using base64 encoding to slip structured data through the deliberately
restrictive configuration language, you're probably "Doing It Wrong".

## Default configuration

Your charm should operate correctly with no explicit configuration settings. The
first time someone uses your charm, they're likely to run `juju deploy
yourcharm` and see what happens; if it doesn't work out of the box ont the first
go, many potential users won't give it a second try.

## Warning

**Warning: ** There's a [bug](https://bugs.launchpad.net/juju-core/+bug/1194945) in the service configuration CLI at the moment; if a string-typed option has an explicit default that is _not_ the empty string, it will become impossible to set the value to the empty string at runtime. If your option needs to accept an empty string value, it should make the empty string the explicit default value.

## Sample config.yaml files

The MediaWiki has some simple but useful configuration options:

      options:
        name:
          default: Please set name of wiki
          description: The name, or Title of the Wiki
          type: string
        skin:
          default: vector
          description: skin for the Wiki
          type: string
        logo:
          description: URL to fetch logo from
          type: string
        admins:
          description: Admin users to create, user:pass
          type: string
        debug:
          default: false
          type: boolean
          description: turn on debugging features of mediawiki

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

