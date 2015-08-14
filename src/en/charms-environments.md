Title: Managing environments

# Managing environments

Juju can be used to manage multiple clouds on different environments. The
environments themselves need only be defined in the `environments.yaml` file as
more fully described in the configuration section of the documentation. It is
entirely possible to have multiple environments with the same cloud provider
(providing they are of course separate environments on the cloud too) or across
all the different types of supported cloud providers.

## Identifying the current environment

The order of precedence for determining the environment a command will be
executed on is:

1. The environment specified by the use of the `-e` switch.
1. The environment set by the `JUJU_ENV` environment variable.
1. The environment last specified with the `switch` command.
1. The environment specified as the default in `environments.yaml`.

To determine which environment a command will act on, you can issue the `switch`
command with no parameters:

```bash
juju switch
Current environment: "amazon" (from JUJU_ENV)
```

It is also possible to determine the current environment by checking the
`JUJU_ENV` variable, and if that is empty, the contents of the file `~/.juju
/current-environment`:

```bash
echo $JUJU_ENV
cat ~/.juju/current-environment
```

## Specifying an environment

You can use the `-e` switch with a Juju command, followed by a valid environment
label, to specify that the command should be run against that environment. Using
the `-e` switch takes precedence over any other setting.

For example:

```no-highlight
juju bootstrap                 # bootstraps the default environment
juju switch amazon             # switches the environment to the cloud defined by 'amazon'
juju deploy mysql -e mycloud   # deploys mysql charm on the cloud defined by 'mycloud'
```

**Note: ** Unlike many switches used with juju, `-e` must come at the end of the
command in order to be parsed correctly.

## Switching environments

When managing several cloud environments, it can be bothersome to issue a long
list of commands and remember to prepend the `-e` switch to each one. For this
reason, you can switch the current environment using the `switch` command:

```bash
juju switch hpcloud
juju bootstrap
```

... will bootstrap the environment defined by the 'hpcloud' label

This command will return with an error message if `JUJU_ENV`is set (as this
takes precedence).

**Note:** The environment selected with `switch` is persistent. Even if you log
out, switch your computer off, travel into space or sail around the world, when
you start using Juju again, it will still point at the last environment you
specified with `switch`.

## Default environment

The default environment is the environment which will be used if you have not
issued a `switch` command and do not specify an environment to use with the `-e`
switch or alter the `JUJU_ENV` environment variable. The default environment is
specified at the top of the `environments.yaml` file, before the environment
specifications themselves, like this:

```yaml
    ...
    default: amazon
    environments:
      ## https://jujucharms.com/docs/config-openstack.html
      openstack:
    ...
```

## Updating running environments

Juju has a set of commands that permit you to view and change the configuration
of a running environment. The commands can be used to make temporary changes,
such as to logging, or permanent changes, such as to take advantage of new
features after juju is upgraded.

The `get-environment` command will display all the environment's configured
options. You can pass the name of an option to see just the one value. For
example, to see the default series that charms are deployed with, type:

```bash
juju get-environment default-series
```

The `set-environment` command will set a configuration option to the specified
value. For example, you can set the default series that charms are deployed with
to trusty like this:

```bash
juju set-environment default-series=trusty
```

The `unset-environment` command will set a configuration option to the default
value. It acts as a reset. Options without default value are removed. It is an
error to unset a required option. For example, you can unset the default series
that charms are deployed with (so that the juju store can choose the best series
for a charm) like this:

```bash
juju unset-environment default-series
```

## Upgrading environments

The `upgrade-juju` command upgrades a running environment. It selects the most
recent supported version of juju compatible with the command-line version. The
juju machine and unit agents will be updated to the new version. The `--version`
option can be used to select a specific version to upgrade to.

```bash
juju upgrade-juju
```

## Updating environments

Juju will attempt to maintain a high degree of legacy compatibility for the
environments.yaml definitions, so you should be able to update to stable
versions of the software without worrying about reconfiguring your environments
each time. However, new releases do sometimes add support for new cloud
providers, add additional settings or change to adapt to configuration changes
for the providers themselves. In these cases it can be useful to generate a new
boilerplate `environments.yaml` so you can easily manually edit your own
configurations or cut and paste new environments into your existing
configuration.

To generate a new boilerplate `environments.yaml` file direct to the console you
can use:

```bash
juju generate-config --show
```

## Destroying environments

To terminate a running environment, including removing all services and
allocated machines, please see the section
[on removing things with Juju](./charms-destroy.html#destroying-environments)

**Note:** Destroying the environment means that it will destroy all the running
assets related to that environment, including the bootstrap node. It does not
remove the configuration from the `environments.yaml` file.
