Title: Juju plugins

# Juju plugins

Plugins are commands which work with Juju, but which are not part of the core
code. Some plugins are provided with your Juju install (e.g. 'juju-metadata') 
because they contain functionality essential to some operations, others are
just useful tools created by the community.

## Community plugins

There is a github project collecting all sorts of useful plugins created for
the Juju ecosystem. You can check out further documentation on the plugins
and how to install them [on the Github project page][plugin].

## Running a plugin

A Juju plugin is any executable code in your $PATH which begins 'juju-'. 
Although you can run these independently of the Juju command line, Juju
will also wrap these commands so they can be run within Juju. For example:

```bash 
juju-metadata generate
```

Can be executed within Juju by entering:

```bash
juju metadata generate
```

### Switches, flags and arguments

There is potential confusion when a plugin accepts a switch or flag; Juju needs
to be able to differentiate between options intended for Juju and ones intended
for the plugin. In this case any options for the plugin should be preceeded by 
' -- '. For example:

```bash
juju foo -- -bar --baz qux
```

[plugin]: https://github.com/juju/plugins#install "Juju plugins on Github"
