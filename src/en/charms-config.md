Title: Configuring applications

# Configuring applications

When deploying an application, the charm you use will often support or even
require specific configuration options to be set.

Juju provides tools to help manage these options and respond to changes over
the lifetime of the application. These options apply to the entire application,
as opposed to only a specific unit or relation. The configuration can be
done at deployment time or post-deployment.

## Discovering application configuration options

Each charm will have its own set of options and possible values. You can
discover these in several ways:

 - by running the `config` command
 - by viewing the charm in the [Charm Store][charm-store]
 - by examining the `config.yaml` file in the charm itself

## Configuring an application at deployment time

Configuration values can be set at deployment time using the following methods:

 - by using a [yaml-formatted][yaml] file
 - by passing options/values directly on the command line
 - a combination of the above
 
All these methods use the `--config` option.

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

## Configuring an application post deployment

It is possible to set or change the configuration of an application which is
already deployed.

Before you set any of these options, you may want to check what current options
are already set. For example:

```bash
juju config mediawiki
```

Should return something like this:

```no-highlight
application: mediawiki
charm: mediawiki
settings:
  admins:
    description: Admin users to create, user:pass
    is_default: true
    type: string
    value: ""
  debug:
    description: turn on debugging features of mediawiki
    is_default: true
    type: boolean
    value: false
  logo:
    description: URL to fetch logo from
    is_default: true
    type: string
    value: ""
  name:
    description: The name, or Title of the Wiki
    is_default: true
    type: string
    value: Please set name of wiki
  server_address:
    description: The server url to set "$wgServer". Useful for reverse proxies
    is_default: true
    type: string
    value: ""
  skin:
    description: skin for the Wiki
    is_default: true
    type: string
    value: vector
  use_suffix:
    description: If we should put '/mediawiki' suffix on the url
    is_default: true
    type: boolean
    value: true
```

You can set the options in a very similar way. Simply add space-separated
key=value pairs as arguments:

```bash
juju config mediawiki skin=monoblock name='Juju Wiki'
```

It is also possible to set options from a YAML file:

```bash
juju config mediawiki --file path/to/myconfig.yaml
```

Setting an option back to its default value is achieved with the `--reset`
option. Here, the argument is a comma-separated list of the option names in
question:

```bash
juju config mediawiki --reset admins,name
```


<!-- LINKS -->

[yaml]: http://yaml.org/spec/1.1/current.html
[charm-store]: https://jujucharms.com/q/?type=bundle
