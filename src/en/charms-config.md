Title: Application configuration

# Application Configuration

When deploying an application, the charm you use will often support or even
require specific configuration options to be set.

Juju provides tools to help manage these options and respond to changes over
the lifetime of the application deployment. These options apply to the entire
application, as opposed to only a specific unit or relation. The configuration
can be modified by an administrator at deployment time or after the applications
are operational.


## Discovering application configuration options

Each charm will have its own set of options and possible values. You can
discover these in several ways:

  - By running the `juju get-config` command.
  - By viewing the charm in the [charm store](https://jujucharms.com).
  - By examining the **config.yaml** file in the charm itself.


## Configuring an application at deployment

It is possible to set configuration values when deploying an application by
providing a [yaml-formatted][yaml] file containing configuration values.

For example, upon investigation we discover that the Mediawiki charm allows us
to set values for the name of the wiki and the 'skin' to use. We can put these
inside a configuration file.

```yaml
mediawiki:
  name: Juju Wiki
  skin: monobook
  admins: admin:admin
```

We can then use this configuration when we deploy the application:

```bash
juju deploy --config myconfig.yaml mediawiki
```

!!! WARNING: If the yaml configuration file cannot be read or contains some
syntax errors or invalid options, you will receive an error message to this
effect. However, **the application will still be deployed **. 


## Configuring an application which is already deployed

It is possible to set or change configuration of an application which is
already deployed.

Before you set any of these options, you may want to check what current options
are already set, using the `juju get-config <application>` command. For example:

```bash
juju get-config mediawiki
```

Should return something like this:

```no-highlight
charm: mediawiki
application: mediawiki
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
  use_suffix:
    description: If we should put '/mediawiki' suffix on the url
    type: boolean
    value: false
```

You can set the options using `juju config <application>`, specifying
multiple space-separated key=value pairs if necessary:

```bash
juju config mediawiki skin=monoblock name='Juju Wiki' 
```
It is also possible to set the configuration options from a YAML file after
the application has been deployed:
  
```bash
juju config mediawiki --file path/to/myconfig.yaml
```
  
Setting an option back to its default value is achieved by using the same
command, with the `--reset` switch, followed by a comma-separated list of the
values to return to the default setting:

```bash
juju config mediawiki --reset admins,name
```


[yaml]: http://yaml.org/spec/1.1/current.html "YAML spec page"
