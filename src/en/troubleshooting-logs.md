Title: Juju logs  
TODO:  Remote logging: strongly consider adding a sub-page (rsyslog TLS tutorial)
       Remote logging: need to state whether server-side and/or client-side auth is a requirement


# Juju logs

There are various logging resources available to the Juju operator. This page will
explain these and show how to use them. It will cover:

 - [Model logs][#model-logs]
 - [Remote logging][#remote-logging]
 - [Audit logging][#audit-logging]

## Model logs

Model logs can be considered as Juju's "regular logs" and are intended to be
inspected with the `juju debug-log` command. This method provides logs on a
per-model basis and is therefore more convenient than reading individual logs
on multiple (Juju) machines directly on the file system. The latter can
nonetheless be done in exceptional circumstances and some explanation is
provided here.

See [Juju high availability](./controllers-ha.html#ha-and-logging) when viewing
logs in an HA context.

### Juju agents

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

So there are two agents running on this Juju machine. One for the machine
itself and one for a service unit.

The contents of one of these directories

```bash
juju ssh 2 ls -lh /var/lib/juju/agents/machine-2
```

reveals the agent's configuration file:

```no-highlight
-rw------- 1 root root 2.1K Apr 28 00:42 agent.conf
```

Consider keeping backups of these files, especially prior to upgrading the
agents. See [Model upgrades][models-upgrade].

### The debug-log command

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

#### Examples:

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

To begin with the last 500 lines. The `grep` utility is used as a text filter:

```bash
juju debug-log -n 500 | grep amd64
```

### Logging levels

You can verify the current logging level like this:

```bash
juju model-config logging-config
```

Output will be similar to the following:

```no-highlight
<root>=WARNING;unit=DEBUG
```

The above is the default configuration. It sets the machine agent log level at
'WARNING' and the unit agent log level at 'DEBUG'.

The logging levels, from most verbose to least verbose, are as follows:

 - TRACE
 - DEBUG
 - INFO
 - WARNING
 - ERROR

### Increase the logging level

When diagnosing an issue (and possibly filing a bug), the first step is to make
logging more verbose. For instance, to increase the logging level of the unit
agents to 'TRACE' you would enter the following command:

```bash
juju model-config logging-config="<root>=WARNING;unit=TRACE"
```

To avoid filling up the database unnecessarily, when verbose logging is no
longer needed, do not forget to return logging to normal levels.

### Advanced filtering

A Juju log line is written in this format:

`<entity> <timestamp> <log-level> <module>:<line-no> <message>`

The `--include` and `--exclude` options select and deselect, respectively, the
entity that logged the message. An entity is a Juju machine or unit agent. The
entity names are similar to the names shown by `juju status`.

Similarly, the `--include-module` and `--exclude-module` options can be used to
influence the type of message displayed based on a (dotted) module name. The
module name can be truncated.

A combination of machine and unit filtering uses a logical OR whereas a
combination of module and machine/unit filtering uses a logical AND.

The `--level` option places a limit on logging verbosity (e.g. `--level INFO`
will allow messages of levels 'INFO', 'WARNING', and 'ERROR' to be shown).

#### Examples:

To begin with the last 1000 lines and exclude messages from machine 3:

```bash
juju debug-log -n 1000 --exclude machine-3
```

To select all the messages emitted from a particular unit and a particular
machine in the entire log:

```bash
juju debug-log --replay --include unit-mysql-0 --include machine-1
```

!!! Note: 
    The unit can also be written 'mysql/0' (as shown by `juju status`).

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

### Agent logging override

As we've seen, the logging level for machine agents and unit agents are
specified as a single model configuration setting. However, in some situations
(e.g. targeted verbose debugging) it may be desirable to increase the logging
level on a per-agent basis. This can also be done after having reduced the
model-wide log level (as explained [above][#increase-the-logging-level]).

For example, let's enable 'TRACE' logging level to a unit of MySQL. We begin by
logging in to the unit's machine ('0' in this example):

```bash
juju ssh mysql/0
```

File `/var/lib/juju/agents/unit-mysql-0/agent.conf` is then edited by adding
the line `LOGGING_OVERRIDE=juju=trace` to the 'values' section.

To be clear, the bottom of the file now looks like:

```no-highlight
loggingconfig: <root>=WARNING;unit=DEBUG
values:
  CONTAINER_TYPE: ""
  NAMESPACE: ""
  LOGGING_OVERRIDE=juju=trace
mongoversion: "0.0"
```

The affected agent will need to be restarted to have this change take effect:

```bash
sudo systemctl restart jujud-unit-mysql-0.service
```

### Log files

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

There is one extra log file on each controller: `logsink.log`:

```bash
juju ssh -m controller 0 ls -lh /var/log/juju
```

Output:

```no-highlight
-rw------- 1 syslog syslog 2.3M Apr 28 17:05 logsink.log
-rw------- 1 syslog syslog  85K Apr 28 17:03 machine-0.log
```

File `logsink.log` contains logs for all models managed by the controller. Its
contents get sent to the database where it is consumed by the `debug-log`
command.

!!! Note: 
    In a [High availability][controllers-ha] scenario, `logsink.log` is not
    guaranteed to contain all messages since agents have a choice of several
    controllers to send their logs to. The `debug-log` command should be used
    for accessing consolidated data across all controllers.

## Remote logging

On a per-model basis log messages can optionally be forwarded to a remote
syslog server over a secure TLS connection.

See [Rsyslog documentation][upstream-rsyslog-tls-tutorial] for help with
security-related files (certificates, keys) and the configuration of the
remote syslog server.

### Configuring

Remote logging is configured during the controller-creation step by supplying
a YAML format configuration file:

```bash
juju bootstrap <cloud> --config logconfig.yaml
```

The contents of the YAML file is of the form:

```no-highlight
syslog-host: <host>:<port>
syslog-ca-cert: |
-----BEGIN CERTIFICATE-----
 <cert-contents>
-----END CERTIFICATE-----
syslog-client-cert: |
-----BEGIN CERTIFICATE-----
 <cert-contents>
-----END CERTIFICATE-----
syslog-client-key: |
-----BEGIN PRIVATE KEY-----
 <cert-contents>
-----END PRIVATE KEY-----
```

### Enabling

To actually enable remote logging for a model a configuration key needs to be
set for that model:

`juju model-config -m <model> logforward-enabled=True`

An initial 100 (maximum) existing log lines will be forwarded.

See [Configuring models][models-config] for extra help on configuring a model.

Note that it is possible to configure *and* enable forwarding on *all* the
controller's models in one step:

`juju bootstrap <cloud> --config logforward-enabled=True --config logconfig.yaml`

## Audit logging

Juju audit logging provides a chronological account of all events by capturing
invoked user commands. These logs reside on the controller involved in the
transmission of commands affecting the Juju client, Juju machines, and the
controller itself.

The audit log filename is `/var/log/juju/audit.log` and contains records which
are either:

 - a *Conversation*, a collection of API methods associated with a single
   top-level CLI command
 - a *Request* , a single API method
 - a *ResponseErrors*, errors resulting from an API method

Information can be filtered out of the audit log to prevent its file(s) from
growing without bounds and making it difficult to read. See
[Excluding information from the audit log][excluding-information-log-audit].

The log is typically viewed by connecting to the controller over SSH and
looking at the file:

```bash
juju ssh -m controller 0
more /var/log/juju/audit.log
```


<!-- LINKS -->

[#model-logs]: #model-logs
[#remote-logging]: #remote-logging
[#audit-logging]: #audit-logging
[#increase-the-logging-level]: #increase-the-logging-level
[controllers-ha]: ./controllers-ha.html 
[excluding-information-log-audit]: ./controllers-config.html#excluding-information-from-the-audit-log
[upstream-rsyslog-tls-tutorial]: http://www.rsyslog.com/doc/v8-stable/tutorials/tls_cert_summary.html
[models-config]: ./models-config.html
[models-upgrade]: ./models-upgrade.html
