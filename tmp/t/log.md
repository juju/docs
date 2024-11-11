(log)=
# Log

> See also: {ref}`How to manage logs <how-to-manage-logs>`

A **log** is a computer-generated record about entities, activities, usage patterns, etc., within a system. In Juju, logs are produced by {ref}``jujud` <binary-jujud>` and keep track of machine and unit agents, models, controllers, etc.


**Contents:**
- [Juju agent logs - machines](#heading--juju-agent-logs---machines)
- [Juju agent logs - Kubernetes](#heading--juju-agent-logs---kubernetes)

<!--ALREADY COVERED IN https://discourse.charmhub.io/t/list-of-model-configuration-keys/7068#heading--logging-config 
- [Log verbosity levels](#heading--log-verbosity-levels)
- [Log labels](#heading--log-labels)	 
-->

<a href="#heading--juju-agent-logs---machines"><h2 id="heading--juju-agent-logs---machines">Juju agent logs - machines</h2></a>

In machine deployments, Juju agent logs are organised into a number of files. These files are located on every machine that Juju creates, including the controller. Specifically, they can be found under `/var/log/juju`, and may include:

- [Agent log files](#heading--agent-log-files)
- [Model log files](#heading--model-log-files)
- [The audit log file](#heading--the-audit-log-file)
- [The logsink log file](#heading--the-logsink-log-file)
- [The machine-lock log file](#heading--the-machine-lock-log-file)

<a href="#heading--agent-log-files"><h3 id="heading--agent-log-files">Agent log files</h3></a>

Agent log files (e.g., `/var/log/juju/unit-controller-0.log` ) contain the logs for the machine and unit {ref}`agents <agent>`. 


<a href="#heading--model-log-files"><h3 id="heading--model-log-files">Model log files</h3></a>

Model log files (e.g., `/var/log/juju/models/admin-test-3850c8.log`) contain the logs for all the [workers](https://juju.is/docs/dev/worker) on a {ref}`model <model>`. 

<!-- 
Model logs can be considered as Juju's "regular logs" and are intended to be inspected with the `debug-log` command. This method provides logs on a per-model basis and is therefore more convenient than reading individual logs on multiple (Juju) machines directly on the file system. The latter can nonetheless be done in exceptional circumstances and some explanation is provided here.

See {ref}`Controller HA and logging <1184md>` when viewing logs in an HA context.
-->

<a href="#heading--the-audit-log-file"><h3 id="heading--the-audit-log-file">The audit log file</h3></a>

The audit log file (`/var/log/juju/audit.log`) logs all the client commands and all the API calls and errors responses associated with a {ref}`controller <controller>`, classified as one of the following:

-   *Conversation:* A collection of API methods associated with a single top-level CLI command.
-   *Request:* A single API method.
-  *ResponseErrors:* Errors resulting from an API method

The audit log file can be found only on controller machines. 

<!--; you can view it by SSH-ing into the machine (e.g., `juju ssh -m controller 0`) and printing the contents of the file (`more /var/log/juju/audit.log`).-->

<!--
Q: Is there a single `audit.log` file, or do you get one for each controller? If the latter, how are they named? 
A: There's one with the same name on each controller.
Q: Right now I have two controllers, but my `var/log/juju` shows just one `audit.log` file
A: So if a particular client command connects to controller machine 2, it's logged in that machine's audit log.
-->

<!--
The audit log filename is `/var/log/juju/audit.log` and contains records which are either:

-   a *Conversation*, a collection of API methods associated with a single top-level CLI command
-   a *Request* , a single API method
-   a *ResponseErrors*, errors resulting from an API method

Information can be filtered out of the audit log to prevent its file(s) from growing without bounds and making it difficult to read. See {ref}`Excluding information from the audit log <1184md>`.

The log is typically viewed by connecting to the controller over SSH and looking at the file:

``` bash
juju ssh -m controller 0
more /var/log/juju/audit.log
```
-->

 <a href="#heading--the-logsink-log-file"><h3 id="heading--the-logsink-log-file">The logsink log file</h3></a>

The logsink file (`logsink.log`) contains all the agent logs shipped to the {ref}`controller <controller>`, in aggregated form. These logs will end up in Juju's internal database, MongoDB.

<!--
File `logsink.log` contains logs for all models managed by the controller. Its contents get sent to the database where it is consumed by the `debug-log` command.
-->

```{important}

In a {ref}`controller high availability <1184md>` scenario, `logsink.log` is not guaranteed to contain all messages since agents have a choice of several controllers to send their logs to. The `debug-log` command should be used for accessing consolidated data across all controllers.

```

 <a href="#heading--the-machine-lock-log-file"><h3 id="heading--the-machine-lock-log-file">The machine-lock log file</h3></a>

The machine-lock log file (`machine-lock.log`) contains logs for the file lock that synchronises hook execution on Juju {ref}`machines <machine>`. (A machine will only ever run one [hook](https://juju.is/docs/sdk/hook) at a time.)

<!--ALREADY COVERED IN https://discourse.charmhub.io/t/list-of-model-configuration-keys/7068#heading--logging-config

<a href="#heading--log-verbosity-levels"><h2 id="heading--log-verbosity-levels">Log verbosity levels</h2></a>

Juju logs can be filtered (e.g., in the output of `juju debug-log`) by their level of verbosity. 

In decreasing order of severity, these levels are:

| Level | Description |
|-|-|
| `CRITICAL` | Indicates a severe failure which could bring down the system. |
| `ERROR` | Indicates failure to complete a routine operation.
| `WARNING` | Indicates something is not as expected, but this is not necessarily going to cause an error.
| `INFO` | A regular log message intended for the user.
| `DEBUG` | Information intended to assist developers in debugging.
| `TRACE` | The lowest level - includes the full details of input args, return values, HTTP requests sent/received, etc. |

Selecting a certain log level will output the logs with that level as well as the logs with a less verbose level. For example, selecting `WARNING` will show both `WARNING`- and `ERROR`-level logs.

<a href="#heading--log-labels"><h2 id="heading--log-labels">Log labels</h2></a>

Juju logs can be filtered (e.g., in the output of `juju debug-log`) by their topic, or 'label'. 

The currently supported labels are:

| Label | Description |
|-|-|
| `#http` | HTTP requests |
| `#metrics` | Metric outputs - use as a fallback when Prometheus isn't available |
| `#charmhub` | Charmhub client and callers. |
| `#cmr` | Cross model relations |
| `#cmr-auth` | Authentication for cross model relations |
| `#secrets` | Juju secrets |

> See more: [https://github.com/juju/juju/blob/main/core/logger/labels.go](https://github.com/juju/juju/blob/main/core/logger/labels.go)

-->

<a href="#heading--juju-agent-logs---kubernetes"><h2 id="heading--juju-agent-logs---kubernetes">Juju agent logs - Kubernetes</h2></a>

In Kubernetes deployments, logs are written directly to `stdout` of the container and can be retrieved with native Kubernetes methods: `kubectl logs <pod-name> -n <model-name>` . 

By default, it will fetch the logs from the main container `charm` container. When fetching logs from other containers, use additional `-c` flag to specify the container, i.e. `kubectl logs -c <container-name> <pod-name> -n <model-name>` . 


<small><br> **Contributors:** @charlie4284 , @manadart, @reneradoi, @tmihoc </small>