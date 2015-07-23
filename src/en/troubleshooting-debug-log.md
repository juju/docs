Title: Troubleshooting with debug-log

# Troubleshooting with debug-log

When problems arise the first step in determining the cause is to look at the
logs. The `debug-log` command shows the consolidate logs of all Juju agents
running on all machines in the environment.

The output is a fixed number of existing log lines (number specified by
possible options; the default is 10) and a stream of newly appended messages.
Both existing lines and appended lines are filtered by any specified options.
The exception to the streaming is when limiting the output (option `--limit`;
see below) and that limit is attained. In all other cases the command will need
to be interrupted with `Ctrl-C` in order to regain the shell prompt.

For complete syntax, see the [command reference page](./commands.html).

You can also learn more by running `juju debug-log --help` and `juju help 
logging`.


## Examples:

**#1** - To begin with the last ten log messages:

```bash
juju debug-log
```

**#2** - To begin with the last thirty log messages:

```bash
juju debug-log -n 30
```

**#3** - To begin with all the log messages:

```bash
juju debug-log --replay
```

**#4** - To begin with the last twenty log messages for the 'local' environment:

```bash
juju debug-log -n 20 -e local
```

**#5** - To begin with the last 500 lines filtered by the string 'amd64':

```bash
juju debug-log --lines 500 | grep amd64
```

**#6** - To begin with the first 20 lines from last 3000 lines of the entire log:

```bash
juju debug-log --lines 3000 --limit 20
```


## Advanced filtering

A Juju log line is written in this format:

`<entity> <timestamp> <log-level> <module>:<line-no> <message>`

The `include` and `exclude` options select and deselect, respectively, the
entity that logged the message. An entity is a juju machine or unit agent. The
entity names are similar to the names shown by `juju status`.

### Examples:

**#7** - To exclude all the log messages from the bootstrap machine (the
state-server; always machine "0") in the last 1000 lines:

```bash
juju debug-log --lines 1000 --exclude machine-0
```

**#8** - To select all the messages emitted from a particular unit and a particular
machine in the entire log:

```bash
juju debug-log --replay --include unit-mysql-0 --include machine-1
```

**Note:** The unit can also be written `mysql/0` (as shown with status).

**#9** - To see all WARNING and ERROR messages in the entire log:

```bash
juju debug-log --replay --level WARNING
```

**Note**: The `level` option restricts messages to the specified log-level or
greater. The levels from lowest to highest are TRACE, DEBUG, INFO, WARNING, and
ERROR.

**#10** - To progressively exclude more content from the entire log:

```bash
juju debug-log --replay --exclude-module juju.state.apiserver
juju debug-log --replay --exclude-module juju.state
juju debug-log --replay --exclude-module juju
```

**Note:** The `include-module` and `exclude-module` are used to select/deselect the
type of message displayed based on a (dotted) module name. The module name can
be truncated.

**#11** - To see messages pertaining to both the juju.cmd and juju.worker modules
from the last 2000 lines of the log:

```bash
juju debug-log --lines 2000 \
	--include-module juju.cmd \
	--include-module juju.worker
```
