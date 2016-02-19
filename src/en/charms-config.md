Title: Service configuration  

# Service configuration

When deploying a service, the charm you use will often support or even require
specific configuration options to be set.

Juju provides tools to help manage these options and respond to changes over
the lifetime of the service deployment. These options apply to the entire
service, as opposed to only a specific unit or relation. The configuration can
be modified by an administrator at deployment time or after the services are
operational.


## Discovering service configuration options

Each charm will have its own set of options and possible values. You can
discover these in several ways:

  - By running the `juju get-config` command.
  - By viewing the charm in the [charm store](https://jujucharms.com).
  - By examining the **config.yaml** file in the charm itself.


## Configuring a service at deployment

It is possible to set configuration values when deploying a service by
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

We can then use this configuration when we deploy the service:

```bash
juju deploy --config myconfig.yaml mediawiki
```

!!! WARNING: If the yaml configuration file cannot be read or contains some
syntax errors or invalid options, you will receive an error message to this
effect. However, **the service will still be deployed **. 


## Configuring a service which is already deployed

It is possible to set or change configuration of a service which is already
deployed.

Before you set any of these options, you may want to check what current options
are already set, using the `juju get-config <service>` command. For example:

```bash
juju get-config mediawiki
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
  use_suffix:
    description: If we should put '/mediawiki' suffix on the url
    type: boolean
    value: false
```

You can set the options using the `juju set-config <service>`, specifying
multiple space-separated key=value pairs if necessary:

```bash
juju set-config mediawiki skin=monoblock name='Juju Wiki' 
```
It is also possible to set the configuration options from a YAML file after
the service has been deployed:
  
```bash
juju set-config --config=m.yaml mediawiki
```

  
Setting an option back to its default value is achieved by using the 
`set-config` command, but with the `--to-default` switch, followed by the 
service and a space separated list of the values to return to the default
setting:

```bash
juju set-config --to-default mediawiki admins name
```


[yaml]: http://yaml.org/spec/1.1/current.html "YAML spec page"
