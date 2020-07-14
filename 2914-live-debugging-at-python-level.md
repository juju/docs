The Operator framework offers the possibility of debugging running code, very similar to what any Python developer is used to when doing `pdb.set_trace()` in their code.

That concept is carried to charm processes running inside live systems, where breakpoints will be enabled while handling Juju events and/or actions.

This feature is used through the Juju command `debug-code`; you can [learn more about it here](https://discourse.juju.is/t/command-debug-code), but in a nutshell it will leave you in a [Python debugger](https://docs.python.org/3/library/pdb.html) console, interrupting the running charm on specific breakpoints, and allowing you to do any in-process inspection.

The basic command is:

    juju debug-code <unit> <events and/or actions>

The running charm will be interrupted in all specified breakpoints that are found when handling those events and/or actions.

To set a breakpoint in the charm code, all you need to do is call the framework:

    self.framework.breakpoint()

Since Python 3.7, you can also use the builtin [`breakpoint`]( https://docs.python.org/3/library/functions.html#breakpoint) to get the same behaviour.

You can include as many breakpoints as you want, and you can even name them to be able to decide later which ones activate; e.g.:

    self.framework.breakpoint('some-name')
    self.framework.breakpoint('other-name')

These names must start and end with lowercase alphanumeric characters, and only contain lowercase alphanumeric characters or the hyphen ("`-`"); note that special names `all` and `hook` are reserved.

By default, when you run `juju debug-code` as shown above it will stop in all the breakpoints, named or not. If you want to activate specific breakpoints, you can use the `--at` parameter; for example to only interrupt the code in the first of the two breakpoints above, you would do:

    juju debug-code --at=some-name <unit> <events and/or actions>

Multiple breakpoint names can be specified separated by comma.

You can really leave these breakpoints in the code, because they will be activated only if a debugging session is set up with `juju debug-code`. Furthermore, you can use these breakpoints locally or when running the charm tests, by setting the `JUJU_DEBUG_AT` environment variable to any of the following values (or combination of them, separated by comma):

- `all`: will activate all the breakpoints
- `name1[,name2[,...]]`: will activate the breakpoints specified by that(those) name(s)
- `hook`: special value to automatically interrupt the charm on every registered method (see below)

Alternatively to manually specify breakpoints in the code, you can jump into debugging without needing to change the charm code at all, by specifying `hook` to the Juju command:

    juju debug-code --at=hook <unit> <events and/or actions>

This will make the Operator framework to automatically interrupt the running charm exactly at the beginning of the registered callback method(s) for the specified events and/or actions.
