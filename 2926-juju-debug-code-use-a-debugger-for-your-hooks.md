# Juju debug-code
(added in Juju 2.8)

>Maybe this is just a section of https://discourse.juju.is/t/debugging-charm-hooks/1116

Many of our charms are written in python, which has nice facilities for live debugging of code [pdb](https://docs.python.org/3/library/pdb.html). For the [Operator Framework](https://github.com/canonical/operator), we wanted to provide a nice way to not just get a shell where you can run the hook from bash, but actually drop you all the way into a pdb shell.

For charmers, the main difference between `juju debug-hooks` and `juju debug-code` is that once the tmux session is established, it executes the hook as normal, but with the environment variable `JUJU_DEBUG_AT` set. Charms can look for that environment variable and chose to drop into a debugger based on the value.

## Hook names

Like `juju debug-hooks`, `juju debug-code` takes a list of hooks to debug, and will run all other hooks as normal. (eg, if you just want to debug `config-changed`, you can specify `juju debug-code unit/0 config-changed`.) This helps developers avoid having to manually interact with all the other hooks that Juju might fire before running the one they are interested in debugging.

## JUJU_DEBUG_AT

The Charm is responsible for interpreting the meaning of the environment variable `JUJU_DEBUG_AT`.  The default set by juju is `"all"`. Users can set a different value by supplying `juju debug-code --at LOCATION`.

### Operator Framework
For [Operator Framework](https://github.com/canonical/operator) charms, the framework interprets the string as a comma separated list of named breakpoints, with reserved keywords for `all` and `hook`.  Charm developers can create their own breakpoints by calling `self.framework.breakpoint(name=None)`, passing an optional name.

For the default value of `all`, the python interpreter will drop into pdb for each handler of a hook, and for the all named and unnamed breakpoints that are encountered while running the code.

If the value is set to `hook`, then only the handlers for a given Juju hook will trigger a breakpoint. Unnamed and named breakpoints will be skipped.
