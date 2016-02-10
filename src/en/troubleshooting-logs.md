Title: Viewing logs  


# Viewing logs

Logs can be inspected via the traditional method of reading log files directly
on the filesystem. The administrator can also view logs via the `juju
debug-log` command. Both methods are described below.

See [Juju high availability](./juju-ha.html#ha-and-logging) when viewing logs
in an HA context.


## Log files

The log files are located on the state server under `/var/log/juju*`. The exact
directory name depends on the type of environment in use. Below is listed the
contents of the `/var/log/juju-ubuntu-lxc` directory where the Local Provider
(LXC) is in use:

```no-highlight
-rw------- 1 syslog adm    34K Sep  2 00:49 all-machines.log
-rw------- 1 syslog syslog 883 Sep  2 00:49 ca-cert.pem
-rw------- 1 syslog syslog 600 Sep  2 00:49 logrotate.conf
-rwx------ 1 syslog syslog 105 Sep  2 00:49 logrotate.run
-rw------- 1 syslog syslog 32K Sep  2 00:49 machine-0.log
-rw------- 1 syslog syslog 928 Sep  2 00:49 rsyslog-cert.pem
-rw------- 1 syslog syslog 891 Sep  2 00:49 rsyslog-key.pem
```

The file `machine-0.log` is the log for machine '0' which is always the state
server (bootstrap node).

The file `all-machines.log` is the log for all the machines/instances in this
particular environment.

Adding an instance (issuing `juju add-machine`) gives us:

```no-highlight
-rw------- 1 syslog adm     34K Sep  2 00:49 all-machines.log
-rw-r--r-- 1 root   root    883 Sep  2 00:54 ca-cert.pem
-rw------- 1 syslog syslog  600 Sep  2 00:49 logrotate.conf
-rwx------ 1 syslog syslog  105 Sep  2 00:49 logrotate.run
-rw------- 1 syslog syslog  32K Sep  2 00:49 machine-0.log
-rw------- 1 syslog syslog 3.4K Sep  2 00:54 machine-1.log
-rw------- 1 syslog syslog  928 Sep  2 00:49 rsyslog-cert.pem
-rw------- 1 syslog syslog  891 Sep  2 00:49 rsyslog-key.pem
```

Where `machine-1.log` is the log file for the new machine.

There are also log files for [service units](./glossary.html). For instance, if
MySQL is deployed (`juju deploy mysql`) a log file will appear for the machine
that is spawned (`machine-2.log`) in addition to the file for the unit itself
(`unit-mysql-0.log`):

```no-highlight
-rw------- 1 syslog adm     63K Sep  2 00:58 all-machines.log
-rw-r--r-- 1 root   root    883 Sep  2 00:57 ca-cert.pem
-rw------- 1 syslog syslog  600 Sep  2 00:49 logrotate.conf
-rwx------ 1 syslog syslog  105 Sep  2 00:49 logrotate.run
-rw------- 1 syslog syslog  32K Sep  2 00:49 machine-0.log
-rw------- 1 syslog syslog 3.4K Sep  2 00:54 machine-1.log
-rw------- 1 syslog syslog 3.3K Sep  2 00:57 machine-2.log
-rw------- 1 syslog syslog  928 Sep  2 00:49 rsyslog-cert.pem
-rw------- 1 syslog syslog  891 Sep  2 00:49 rsyslog-key.pem
-rw------- 1 syslog syslog  22K Sep  2 00:58 unit-mysql-0.log
```

### Logging agents

The entity doing the logging is the *Juju agent*, `jujud`, which runs for each
Juju machine and unit. For instance, for machine #2, we see evidence of the two
agents:

```bash
juju ssh 2 'ls -lh /var/lib/juju/agents'
```

This will provide output similar to:

```no-highlight
drwxr-xr-x 2 root root 4.0K Sep  2 02:17 machine-2
drwxr-xr-x 4 root root 4.0K Sep  2 02:17 unit-mysql-0
```

The contents of one of these directories

```bash
juju ssh 2 'ls -lh /var/lib/juju/agents/machine-2'
```
reveals the agent's configuration file:

```no-highlight
-rw------- 1 root root 1.4K Sep  2 02:17 agent.conf
```

Consider keeping backups of these files, especially prior to upgrading the
environment. See
[Upgrading Juju software](./juju-upgrade.html#upgrading-the-server-software).


## The debug-log command

The `debug-log` command shows the consolidate logs of all Juju agents (machine
and unit logs) running in the environment.

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

To begin with the last ten log messages:

```bash
juju debug-log
```

To begin with the last thirty log messages:

```bash
juju debug-log -n 30
```

To begin with all the log messages:

```bash
juju debug-log --replay
```

To begin with the last twenty log messages for the 'local' environment:

```bash
juju debug-log -n 20 -e local
```

To begin with the last 500 lines filtered by the string 'amd64':

```bash
juju debug-log --lines 500 | grep amd64
```

To begin with the first 20 lines from last 3000 lines of the entire log:

```bash
juju debug-log --lines 3000 --limit 20
```


## Advanced filtering

A Juju log line is written in this format:

`<entity> <timestamp> <log-level> <module>:<line-no> <message>`

The `include` and `exclude` options select and deselect, respectively, the
entity that logged the message. An entity is a juju machine or unit agent. The
entity names are similar to the names shown by `juju status`.

Similarly, the `include-module` and `exclude-module` options can be used to
influence the type of message displayed based on a (dotted) module name. The
module name can be truncated.

### Examples:

To exclude all the log messages from the bootstrap machine (the
state-server; always machine "0") in the last 1000 lines:

```bash
juju debug-log --lines 1000 --exclude machine-0
```

To select all the messages emitted from a particular unit and a particular
machine in the entire log:

```bash
juju debug-log --replay --include unit-mysql-0 --include machine-1
```

!!! Note: The unit can also be written `mysql/0` (as shown by 'juju status').

To see all WARNING and ERROR messages in the entire log:

```bash
juju debug-log --replay --level WARNING
```

!!! Note: The `level` option restricts messages to the specified log-level or
greater. The levels from lowest to highest are TRACE, DEBUG, INFO, WARNING, and
ERROR.

To progressively exclude more content from the entire log:

```bash
juju debug-log --replay --exclude-module juju.state.apiserver
juju debug-log --replay --exclude-module juju.state
juju debug-log --replay --exclude-module juju
```

To see messages pertaining to both the juju.cmd and juju.worker modules
from the last 2000 lines of the log:

```bash
juju debug-log --lines 2000 \
	--include-module juju.cmd \
	--include-module juju.worker
```
