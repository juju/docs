# Service Configuration

When deploying a service, the charm you use will often support or even require
specific configuration options to be set.

Juju provides tools to help manage these options and respond to changes over
the lifetime of the service deployment. These options apply to the entire
service, as opposed to only a specific unit or relation. The configuration can
be modified by an administrator at deployment time or after the services are
operational.

## Discovering application configuration options

Each charm will have its own set of options and possible values. You can
discover these in several ways:

  - By running the `juju get <service>` command.
  - By viewing the charm in the [charm store.](https://jujucharms.com)
  - By examining the **config.yaml** file in the charm itself.

## Configuring an application at deployment time

Configuration values for an application can be set during deployment in several
ways:

 - by using a [yaml-formatted][yaml] file
 - by passing options/values directly on the command line
 - a combination of the above
 
All these methods use the `--config=` switch.

For example, upon investigation we discover that the Mediawiki charm allows us
to set values for the 'name' of the wiki and the 'skin' to use. We can put
these inside a configuration file.

```yaml
mediawiki:
  name: Juju Wiki
  skin: monobook
```

Assuming the file is called `myconfig.yaml`, the application can be deployed
and configured in this way:

```bash
juju deploy --config myconfig.yaml mediawiki
```

!!! Warning:
    If the configuration file cannot be read or contains syntax errors or
    invalid options, an error message will be printed to this effect. However,
    **the application will still be deployed **.

To pass the options directly:

```bash
juju deploy --config name='Juju Wiki' --config skin='monobook'
```

A combination can also be used. If a duplication arises, the last-mentioned
value gets used. For instance, below, the wiki will be assigned the name of
'Juju Wiki':

```bash
juju deploy --config name='Juju Wookie' --config myconfig.yaml
```

## Configuring a service which is already deployed

It is possible to set or change configuration of a service which is already
deployed.

Before you set any of these options, you may want to check what current options
are already set, using the `juju get <service>` command. For example:

```bash
juju get mediawiki
```

Should return something like this:

```no-highlight
charm: mediawiki
service: mediawiki
settings:
  admins:
    default: true
    description: Admin users to create, user:pass
    type: string
    value: null
  debug:
    default: true
    description: turn on debugging features of mediawiki
    type: boolean
    value: false
  logo:
    default: true
    description: URL to fetch logo from
    type: string
    value: null
  name:
    default: true
    description: The name, or Title of the Wiki
    type: string
    value: Please set name of wiki
  skin:
    default: true
    description: skin for the Wiki
    type: string
    value: vector
```

You can set the options using the `juju set <service>`, specifying
multiple key=value pairs if necessary:

```bash
juju set mediawiki skin=monoblock name='Juju Wiki' 
```

Setting an option back to its default value is done using the `unset` command
followed by the service and the respective options:

```bash
juju unset mediawiki admins name 
```
