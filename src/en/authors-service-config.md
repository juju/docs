Title: Application configuration  

# Application configuration

## Introduction

A [Charm](./charms.html) often will require access to specific options or
configuration. Charms allow for the manipulation of the various configuration
options which the charm author has chosen to expose. juju provides tools to
help manage these options and respond to changes in these options over the
lifetime of the application deployment. These options apply to the entire
application, as opposed to only a specific unit or relation. Configuration is
modified by an administrator at deployment time or over the lifetime of the
applications.

As an example a wordpress application may expose a 'blog-title' option. This option
would control the title of the blog being published. Changes to this option
would be applied to all units implementing this application through the invocation
of a hook on each of them.

## Using configuration options

Configuration options are manipulated using a command line interface. juju
provide a set command to aid the administrator in changing values.

    juju set <application name> option=value [option=value]

This command allows changing options at runtime and takes one or more
name/value pairs which will be set into the application options. Configuration
options which are set together are delivered to the applications for handling
together. E.g. if you are changing a username and a password, changing them
individually may yield bad results since the username will temporarily be set
with an incorrect password.

While its possible to set multiple configuration options on the command line
its also convenient to pass multiple configuration options via the --file
argument which takes the name of a YAML file. The contents of this file will
be applied as though these elements had been passed to juju set.

A configuration file may be provided at deployment time using the --config
option, as follows:

    juju deploy [--config local.yaml] wordpress myblog
    juju deploy [--config local.yaml] postgres

The application name is looked up inside the YAML file to allow for related
application configuration options to be collected into a single file for the
purposes of deployment and passed repeated to each juju deploy invocation.

Below is an example local.yaml containing options which would be used during
deployment of an application named myblog.

    myblog:
       blog-roll: ['http://foobar.com', 'http://testing.com']
       blog-title: Awesome Sauce
       password: n0nsense
    postgres:
       port: 5432
       cluster-name: main

## Creating charms

Charm authors create a config.yaml file which resides in the charm's top-level
directory. The configuration options supported by an application are defined
within its respective charm. juju will only allow the manipulation of options
which were explicitly defined as supported.

The specification of possible configuration values is intentionally minimal,
but still evolving. Currently the charm define a list of names which they
react. Information includes a human readable description and an optional
default value. Additionally type may be specified. All options have a default
type of 'str' which means its value will only be treated as a text
string. Other valid options are 'int' and 'float'.

The following config.yaml would be included in the top level directory of a
charm and includes a list of option definitions:

    options:
        port:
            default: 80
            type: int
            description: Port to listen on
        admin-email:
            # type: str is implied
            default: null
            description: Email address for the site administrator.

To access these configuration options from a hook we provide the following:

    config-get [option name]

config-get returns all the configuration options for an application as JSON data
when no option name is specified. If an option name is specified the value of
that option is output according to the normal rules and obeying the --output
and --format arguments. Hooks implicitly know the application they are
executing for and config-get always gets values from the application of the
hook.

Changes to options (see previous section) trigger the charm's config-changed
hook. The config-changed hook is guaranteed to run after any changes are made
to the configuration, but it is possible that multiple changes will be
observed at once. Because its possible to set many configuration options on a
single command line invocation it is easily possible to ensure related options
are available to the service at the same time.

The config-changed hook must be written in such a way as to deal with changes
to one or more options and deal gracefully with options that are required by
the charm but not yet set by an administrator. Errors in the config-changed
hook force juju to assume the service is no longer properly configured. If the
service is not already in a stopped state it will be stopped and taken out of
service. The status command will be extended in the future to report on
workflow and unit agent status which will help reveal error conditions of this
nature.

When options are passed using juju deploy their values will be read in from a
file and made available to the service prior to the invocation of the its
install hook. The install and start hooks will have access to config-get and
thus complete access to the configuration options during their execution. If
theinstall or start hooks don't directly need to deal with options they can
simply invoke the config-changed hook.

## Internals

**Note**: This section explains details useful to the implementation but not
  of interest to the casual reader.

Hooks normally attempt to provide a consistent view of the shared state of the
system and the handling of config options within hooks (config-changed and the
relation hooks) is no different. The first access to the configuration data of
an application will retain a cached copy of the application options. Cached
data will be used for the duration of the hook invocation.
