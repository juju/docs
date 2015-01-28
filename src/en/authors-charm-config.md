# Charm configuration

The optional `config.yaml` file defines how a service running the charm can be
configured by its user.

If `config.yaml` exists, it must contain a dictionary of `options`, in which
each possible setting is named by the key and defined by the value. An option
definition must contain all of the following fields:

  - `type` can be `string`, `int`, `float`, or `boolean`. The default type is `string`.
  - `description` should contain an explanation of what the user might achieve by altering the setting along with valid values.
  - `default` should contain a value of the appropriate type. If set as `default:` with no trailing characters, it is treated as null (which is always a valid value in this context).

Any option without these three fields will generate a Warning from the the
[charm proof tool](tools-charm-tools.html#proof)
indicating the option is not compliant with charm store policy. This policy
allows older versions of juju to safely unset values.

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
        default:
        description: URL to fetch logo from
        type: string
      admins:
        default:
        description: Admin users to create, user:pass
        type: string
      debug:
        default: false
        type: boolean
        description: turn on debugging features of mediawiki
