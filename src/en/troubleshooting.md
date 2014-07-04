Title: Juju troubleshooting

# Troubleshooting the Local Provider

The local provider uses LXC containers under the hood to provide nodes for you
to deploy on. Sometimes things go wrong and you need to debug what is happening
on your machine. This section is a collection of best practices from the communtiy
on diagnosing and solving Juju local provider issues.

## Bootstrap fails

Every time bootstrap fails, you'll need to run `juju destroy-environment -e
local` prior to continuing. First let's rerun a bootstrap in debug mode:

    juju bootstrap --show-log --debug

This will print very verbose output. If you're receiving `connection failed,
will retry: dial tcp 127.0.0.1:37017: connection refused` error at the end of
the run, proceed with the troubleshooting guide. If not the error presented will 
inform you what went wrong.

In certain cases you might get this something similar to this error: `Get
http://10.0.3.1:8040/provider-state: dial tcp 10.0.3.1:8040: connection
refused`.

This can be solved by removing miscellaneous .jenv files in
`~/.juju/environments` and rerunning the bootstrap command.

## Connection failed, will retry

This occurs when the juju API server and Database server fail to start within
the alloted timeout. This can occur for one of several reasons. After the
bootstrap command fails run the following command:

    sudo initctl list | grep juju

You should see two jobs listed. One that starts with `juju-db` the other `juju-
agent`. If these are both in a start/running state then your machine took longer
than juju expected to get these services started.

If either of these have stopped, investigate the logs at 
`/var/log/upstart/juju-db*.log` or `/var/log/upstart/juju-agent*.log` If the 
juju-db service failed to start with messages of unsupported command-line 
options, check the version of mongodb installed:

    dpkg -l | grep mongodb-server

If you have a version less than 1:2.2.4-0ubuntu1 make sure you have either the
[Cloud Tools Archive](https://wiki.ubuntu.com/ServerTeam/CloudToolsArchive) or
ppa:juju/stable added to your system. `sudo apt-get update` then install juju-
local package. Before retrying, make sure you run `juju destroy-environment`

## No machines start

If you get a successful bootstrap, but services you deploy never come up,
there's a chance that you have an older version of the Ubuntu Cloud Image 
cached on your machine. To verify this, check the timestamp of the contents in
`/var/cache/lxc/cloud-precise/`

    ls -lh /var/cache/lxc/cloud-precise/

If the contents of this directory are older than a few weeks, delete files
present, destroy the environment with `juju destroy-environment`, rebootstrap
and attempt deployment again.

# Troubleshooting with debug-log

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
