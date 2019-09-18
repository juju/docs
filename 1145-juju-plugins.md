Plugins are commands which work with Juju, but which are not part of the core code. Some plugins are provided with your Juju install (e.g. `juju-metadata`) and others are tools created by the community. The community tools are collected by the [Juju Plugins](https://github.com/juju/plugins) GitHub project.

<h2 id="heading--running-a-plugin">Running a plugin</h2>

A plugin is any executable code in your `$PATH` which begins `juju-`. Although you can run these independently of the Juju command line, Juju will also wrap these commands so they can be run within Juju. For example:

``` text
juju-metadata generate
```

The above can be executed within Juju in this way:

``` text
juju metadata generate
```

<h2 id="heading--switches-flags-and-arguments">Switches, flags, and arguments</h2>

There is potential confusion when a plugin accepts a switch or flag. Juju needs to be able to differentiate between options intended for Juju and ones intended for the plugin. In this case any options for the plugin should be preceded by ' -- '. For example:

``` text
juju foo -- -bar --baz qux
```

<!-- LINKS -->
