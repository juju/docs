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

# Service Configuration

When deploying a service, the charm you use will often support or even require
specific configuration options to be set.

Juju provides tools to help manage these options and respond to changes over the
lifetime of the service deployment. These options apply to the entire service,
as opposed to only a specific unit or relation. The configuration can modified
by an administrator at deployment time or after the services are operational.

## Discovering service configuration options

You can discover what configuration options are available for a specific charm
in various ways

  - By running the `juju get &LT;service&GT;` command.
  - By viewing the charm in the [charm store.](http://jujucharms.com)
  - By examining the __config.yaml__ file in the charm itself.

The configurations setting names and the values they take will obviously vary
between charms. The options and possible values are all well documented however,
so you should consult one of the above sources to find out particular details.

## Configuring a service at deployment

It is possible to set configuration values when deploying a service by providing
a yaml-formatted file containing configuration values.

For example, upon investigation we discover that the Mediawiki charm allows us
to set values for the name of the wiki and the 'skin' to use. We can put these
inside a configuration file.

    
    
    mediawiki:
      name: Juju Wiki
      skin: monobook
      admins: admin:admin
    

We can then use this configuration when we deploy the service:

    
    
    juju deploy --config myconfig.yaml mediawiki
    

__Caution:__ If the yaml configuration file cannot be read or contains some
syntax errors or invalid options, you will receive an error message to this
effect. However, __the service will still be deployed __.

## Configuring a service which is already deployed

It is possible to set or change configuration of a service which is already
deployed.

Before you set any of these options, you may want to check what current options
are already set, using the `juju get &LT;service&GT;` command. For example:

    
    
    juju get mediawiki
    

Should return something like this:

    
    
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
    

You can set the options using the `juju set &LT;service&GT;`, specifying
multiple key=value pairs if necessary:

    
    
    juju set mediawiki skin=monoblock name='Juju Wiki' 
    

Setting options back to their default value is done using the `unset` command
followed by the service and the respective options:

    
    
    juju unset mediawiki admins name 
    

  - ## [Juju](/)

    - [Charms](/charms)
    - [Features](/features)
    - [Deployment](/deployment)
  - ## [Resources](/resources)

    - [Overview](/resources/juju-overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/the-juju-gui/)
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
    - [Juju Labs](/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://canonical.com).

