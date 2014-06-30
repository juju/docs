# Working with debug-log

The `debug-log` command shows the consolidate logs of all juju agents 
running on all machines in the environment. The command operates like 
`tail -f` to stream the logs to the your terminal.

The `lines` and `limit` options allow you to select the starting log 
line and how many additional lines to display. The default behaviour is 
to show the last 10 lines of the log. The `lines` option selects the 
starting line from the end of the log. The `limit` option restricts the 
number of lines to show. For example, you can see just 20 lines from 
last 100 lines of the log like this:

    juju debug-log --lines 100 --limit 20

There are many ways to filter the juju log to see just the pertinent 
information. A juju log line is written in this format:

    <entity> <timestamp> <log-level> <module>:<line-no> <message>

The `include` and `exclude` options select the entity that logged the 
message. An entity is a juju machine or unit agent. The entity names are 
similar to the names shown by `juju status'. You can exclude all the log 
messages from the bootstrap machine that hosts the state-server like 
this:

    juju debug-log --exclude machine-0

The options can be used multiple times to select the log messages. This 
example selects all the message from a unit and its machine as reported 
by status:

    juju debug-log --include unit-mysql-0 --include machine-1

The `level` option restricts messages to the specified log-level or 
greater. The levels from lowest to highest are TRACE, DEBUG, INFO, 
WARNING, and ERROR. The WARNING and ERROR messages from the log can seen 
thusly:

    juju debug-log --level WARNING

The `include-module` and `exclude-module` are used to select the kind of
message displayed. The module name is dotted. You can specify all or
some of a module name to include or exclude messages from the log. This
example progressively excludes more content from the logs:

    juju debug-log --exclude-module juju.state.apiserver
    juju debug-log --exclude-module juju.state
    juju debug-log --exclude-module juju

The `include-module` and `exclude-module` options can be used multiple 
times to select the modules you are interested in. For example, you can 
see the juju.cmd and juju.worker messages like this:

    juju debug-log --include-module juju.cmd --include-module juju.worker

The `debug-log` command output can be piped to grep to filter the 
message like this:

    juju debug-log --lines 500 | grep amd64

You can learn more by running `juju debug-log --help` and `juju help 
logging`.
