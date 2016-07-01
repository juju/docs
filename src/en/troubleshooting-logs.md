Title: Juju logs  


# Juju logs

Logs in Juju are intended to be inspected with the `juju debug-log` command. This
method provides logs on a per-model basis and is therefore more convenient than
reading individual logs on multiple (Juju) machines directly on the file system.
The latter can nonetheless be done in exceptional circumstances and some explanation
is provided here.

See [Juju high availability](./controllers-ha.html#ha-and-logging) when viewing logs
in an HA context.


## Juju agents

One of the roles of the *Juju agent*, 'jujud', is to perform logging. There is
one agent for every Juju machine and unit. For instance, for a machine with an
id of '2', we see evidence of such agents:

```bash
juju ssh 2 ls -lh /var/lib/juju/agents
```

This example has the following output:

```no-highlight
drwxr-xr-x 2 root root 4.0K Apr 28 00:42 machine-2
drwxr-xr-x 4 root root 4.0K Apr 28 00:42 unit-nfs2-0
```

So there are 2 agents running on this Juju machine. One for the machine itself
and one for a service unit.

The contents of one of these directories

```bash
juju ssh 2 ls -lh /var/lib/juju/agents/machine-2
```

reveals the agent's configuration file:

```no-highlight
-rw------- 1 root root 2.1K Apr 28 00:42 agent.conf
```

Consider keeping backups of these files, especially prior to upgrading the
agents. See
[Upgrading Juju software](./models-upgrade.html#upgrading-the-model-software).


## The debug-log command

The `juju debug-log` command shows the consolidated logs of all Juju agents
(machines and units) running in a model. The `juju switch` command is used
to change models. Alternatively, a model can be chosen with the '-m' option.
The default model is the current model.

The 'controller' model captures logs related to internal management (controller
activity) such as adding machines and services to the database. Whereas a
hosted model will provide logs concerning activities that take place post-
provisioning.

Due to the above, when deploying a service, it is normal for there to be an
absence of logging in the hosted model since logging first takes place in the
'controller' model.

The output is a fixed number of existing log lines (number specified by
possible options; the default is 10) and a stream of newly appended messages.
Both existing lines and appended lines can be filtered by specifying options.

The exception to the streaming is when limiting the output (option '--limit';
see below) and that limit is attained. In all other cases the command will need
to be interrupted with 'Ctrl-C' in order to regain the shell prompt.

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

To begin with all the log messages:

```bash
juju debug-log --replay
```

To begin with the last twenty log messages for the 'lxd-pilot' model:

```bash
juju debug-log -m lxd-pilot -n 20
```

To begin with the last 500 lines. The 'grep' utility is used as a text filter:

```bash
juju debug-log -n 500 | grep amd64
```


## Advanced filtering

A Juju log line is written in this format:

`<entity> <timestamp> <log-level> <module>:<line-no> <message>`

The '--include' and '--exclude' options select and deselect, respectively, the
entity that logged the message. An entity is a Juju machine or unit agent. The
entity names are similar to the names shown by `juju status`.

Similarly, the '--include-module' and '--exclude-module' options can be used to
influence the type of message displayed based on a (dotted) module name. The
module name can be truncated.

A combination of machine and unit filtering uses a logical OR whereas a
combination of module and machine/unit filtering uses a logical AND.

Log levels are cumulative; each lower level (more verbose) contains the
preceding higher level (less verbose). The '--level' option restricts messages
to the specified log-level or greater. The levels from lowest to highest are
TRACE, DEBUG, INFO, WARNING, and ERROR.

### Examples:

To begin with the last 1000 lines and exclude messages from machine 3:

```bash
juju debug-log -n 1000 --exclude machine-3
```

To select all the messages emitted from a particular unit and a particular
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

To begin with the last 2000 lines and include messages pertaining to both the
juju.cmd and juju.worker modules:

```bash
juju debug-log --lines 2000 \
	--include-module juju.cmd \
	--include-module juju.worker
```


## Log files

Log files are located on every machine Juju creates, including the controller.
They reside under `/var/log/juju` and correspond to the machine and any units. 

Using the example from a [previous section](#juju-agents):

```bash
juju ssh 2 ls -lh /var/log/juju
```

Output:

```no-highlight
-rw------- 1 syslog syslog  22K Apr 28 00:42 machine-2.log
-rw------- 1 syslog syslog 345K Apr 28 16:58 unit-nfs2-0.log
```

There is a special log file on each controller (`logsink.log`) that is used for
the consolidated model messages used by `juju debug-log` (its contents get sent
to the database):

```bash
juju ssh -m controller 0 ls -lh /var/log/juju
```

Output:

```no-highlight
-rw------- 1 syslog syslog 2.3M Apr 28 17:05 logsink.log
-rw------- 1 syslog syslog  85K Apr 28 17:03 machine-0.log
```

Notice that the controller model was chosen with `juju ssh`. Also, a combination of
commands `juju list-controllers` and `juju list-machines` yielded that the
controller here has a machine id of '0' (typical).

!!! Note: in a [High availability](./controllers-ha.html) scenario, file `logsink.log`
is not guaranteed to contain all messages since agents have a choice of several
controllers to send their logs to.
