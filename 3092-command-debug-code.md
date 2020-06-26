### Usage

```
juju debug-code [options] <unit name> [hook or action names]
```

### Summary

Launch a tmux session to debug hooks and/or actions.

### Description

Interactively debug hooks and actions on a unit.

Similar to '[juju debug-hooks](/t/command-debug-hooks/1705)' but rather than dropping you into a shell prompt, 
it runs the hooks and sets the `JUJU_DEBUG_AT` environment variable.  Charms that implement support for this should use it to set breakpoints based on the environment variable.

See the "juju help ssh" for information about SSH related options
accepted by the debug-hooks command.

### Options

#### Global Options

```plain
--debug  (= false)
    equivalent to --show-log --logging-config=<root>=DEBUG
-h, --help  (= false)
    Show help on a command or other topic.
--logging-config (= "")
    specify log levels for modules
--quiet  (= false)
    show no informational output
--show-log  (= false)
    if set, write the log file to stderr
--verbose  (= false)
    show more verbose output
```

#### Command Options:

```plain
-B, --no-browser-login  (= false)
    Do not use web browser for authentication
--at (= "all")
    interpreted by the charm for where you want to stop, defaults to 'all'
-m, --model (= "")
    Model to operate in. Accepts [<controller name>:]<model name>|<model UUID>
--no-host-key-checks  (= false)
    Skip host key checking (INSECURE)
--proxy  (= false)
    Proxy through the API server
--pty  (= <auto>)
    Enable pseudo-tty allocation
```
