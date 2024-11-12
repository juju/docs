(plugin)=
# Plugin

> See also: {ref}`How to manage plugins <how-to-manage-plugins>`

A `juju` plugin is an external command that works with  `juju` but which is not part of the `juju` core code. 

<!--Plugins are a way for Juju users to extend the `juju` CLI with their own custom commands, which are not part of the core `juju` code. -->

At a more technical level, a `juju` plugin is any executable file in your `$PATH` that begins with `juju-`. Although you can run these independently of the Juju command line (`juju-<plugin-name>`), Juju will also wrap these commands so they can be run within Juju (`juju <plugin-name>`). 

<!--
Some plugins are provided with your `juju` install (e.g., {ref}``juju-metadata` <plugin-juju-metadata>`) and others are tools created by the community ({ref}`here <list-of-known-juju-plugins>` is a list). You can also {ref}`create your own plugins <how-to-manage-plugins>`.
-->

> See more:
> - {ref}`List of known Juju plugins <list-of-known-juju-plugins>`
> - {ref}`Plugin flags <plugin-flags>`

<!--NOT COMPLETE. MANY NOT ACTIVELY MAINTAINED.
The community tools are collected by the [Juju Plugins](https://github.com/juju/plugins) GitHub project.
-->