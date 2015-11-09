Title: Viewing Juju logs

# Viewing logs

Logs in Juju are intended to be inspected with the `juju debug-log` command. This
method provides logs on a per-model basis and is therefore more convenient than
reading individual logs on multiple (Juju) machines directly on the file system.
The latter can nonetheless be done in exceptional circumstances and some explanation
is provided here.

## The debug-log command

The `juju debug-log` command shows the consolidated logs of all Juju agents
(machines and units) running in a model. The `juju switch` command is used
to change models. Alternatively, a model can be chosen with the '-m' option.
The currently select model is used by default.

The 'admin' model captures logs related to internal management (controller
activity) such as adding machines and services to the database. Whereas a
hosted model will provide logs concerning activities that take place post-
provisioning. When deploying a service, it is normal for there to be an
absence of logging in the hosted model since logging first takes place in the
'admin' model.

By default, the debug-log command will output the 10 most recent log lines and
then stream new lines as they appear. 'Ctrl-C' can be used to terminate the
command in order to regain the shell prompt.

The number of initial lines to output can be controlled by the --lines / -n
option. Using the --replay option will cause all available logs to be emitted.

The --no-tail / -T option can be used to have the debug-log command exit
immediately after the initial log lines have been output.

For complete syntax, see the [command reference page](./commands.html). The
`juju help debug-log` command also provides reminders and more examples.

### Examples:

To begin with the last ten log messages:

```bash
juju debug-log
```

To begin with the last thirty log messages:

```bash
juju debug-log -n 30
```

To dump all available log messages and exit:

```bash
juju debug-log --replay --no-tail
```

To begin with the last twenty log messages for the 'lxd-pilot' model:

```bash
juju debug-log -m lxd-pilot -n 20
```

To begin with the last 500 lines. The 'grep' utility is used as a text filter:

```bash
juju debug-log -n 500 | grep amd64
```


### Advanced filtering

A Juju log line is written in this format:

`<entity> <timestamp> <log-level> <module>:<line-no> <message>`

The '--include' and '--exclude' options select and deselect, respectively, the
entity that logged the message. An entity is a Juju machine or unit agent. The
entity names are similar to the names shown by `juju status`.

Similarly, the '--include-module' and '--exclude-module' options can be used to
influence the type of message displayed based on a (dotted) module name prefix.

The filtering options combine as follows:

  * --include options are logically ORed together
  * --exclude options are logically ORed together
  * --include-module options are logically ORed together
  * --exclude-module options are logically ORed together
  * the combined --include, --exclude, --include-module and --exclude-module
    selections are then logically ANDed

Log levels are cumulative; each lower level (more verbose) contains the
preceding higher level (less verbose). The '--level' option restricts messages
to the specified log-level or greater. The levels from lowest to highest are
TRACE, DEBUG, INFO, WARNING, and ERROR.

### Examples

To begin with the last 1000 lines that aren't related to machine 3:

```bash
juju debug-log -n 1000 --exclude machine-3
```

To select all the messages emitted by a particular unit or a particular
machine in the entire log:

```bash
juju debug-log --replay --include unit-mysql-0 --include machine-1
```

!!! Note: The unit can also be written 'mysql/0' (as shown by `juju status`).

To see all WARNING and ERROR messages in the entire log:

```bash
juju debug-log --replay --level WARNING
```

To progressively exclude more content from the entire log:

```bash
juju debug-log --replay --exclude-module juju.state.apiserver
juju debug-log --replay --exclude-module juju.state
juju debug-log --replay --exclude-module juju
```

To begin with the last 2000 lines which pertaining to either the juju.cmd and
juju.worker modules but not for machine 2 and not for the "foo" worker:

```bash
juju debug-log --lines 2000 \
    --include-module juju.cmd \
    --include-module juju.worker \
    --exclude-module juju.worker.foo \
    --exclude machine-2
```

## Log files

Juju's log files are located at `/var/log/juju` on each Juju managed
machine. This directory contains the Juju's logs for the machine and
any [service units](./glossary.html) running on the machine.

The Juju machine log files are named `machine-N.log` where `N` is the
integer machine identifier. Unit logs files are named `unit-<unit
name>.log`.

Log files can be accessed using the `juju ssh` command. For example,
to see the log files on machine 2, which is running a unit of the
mysql charm:

```no-highlight
$ juju ssh 2
...
$ ls -lh /var/log/juju
drw------- 2 root root 4.0K Sep  2 02:17 machine-2.log
drw------- 4 root root 4.0K Sep  2 02:19 unit-mysql-0.log
$ sudo less /var/log/juju/machine-2.log
$ sudo grep foo /var/log/juju/unit-mysql-0.log
```

### logsink.log

There is a special log file on each controller machine called `logsink.log` that
records the log messages received by that controller machine. This file will
contain log files for all models hosted by the controller. It is intended only
as a last resort in the case of the logs stored in Juju's database not being
available.

Example:

```bash
juju ssh -m admin 0 ls -lh /var/log/juju
```

Output:

```no-highlight
-rw------- 1 syslog syslog 2.3M Apr 28 17:05 logsink.log
-rw------- 1 syslog syslog  85K Apr 28 17:03 machine-0.log
```

!!! Note: in a [High availability](./juju-ha.html) scenario, the `logsink.log`
on each controller machine will only contain a subset of all the logs for the
controller's models because each agent has a choice of several controllers to
send their logs to. Merging the logsink.log from each controller host will
provide the full set of logs.
