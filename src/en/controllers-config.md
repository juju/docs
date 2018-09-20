Title: General configuration options
TODO: Check accuracy of key table (https://github.com/juju/juju/blob/ec89c99e51fa83cd1a2cb5e5f24e73d5b096de20/controller/config.go#L29)
      error: table's default value keys do not show up with controller-config (e.g. bootstrap-). See above note.
      "dynamically set by Juju" could use some explaination
      ReadOnlyMethods updated from https://github.com/juju/juju/blob/2.3/apiserver/observer/auditfilter.go#L130
      Include ability to set configuration key:value pairs by file
table_of_contents: True


# Configuring controllers

A Juju controller is the management node of a Juju cloud environment. It houses
the database and keeps track of all the models in that environment.

Controller configuration consists of a collection of keys and their respective
values. An explanation of how to both view and set these key:value pairs is
provided below.

## Getting values

A controller's configuration key values can be listed by running this command:

```bash
juju controller-config
```

The key-value pairs that are shown will include those that were set during
controller creation (see below), inherited as a default value (see table), or
dynamically set by Juju. 

## Setting values

To set a key's value use the `--config` option during the controller creation
process (see [Creating a controller][controllers-creating]). For example, to
create and configure a cloud named 'lxd':

```bash
juju bootstrap --config bootstrap-timeout=700 lxd
```

In general, once a controller is created, all its settings become immutable.
Exceptions to this rule are three of the keys related to audit logging:

 - auditing-enabled
 - audit-log-capture-args
 - audit-log-exclude-methods
 
!!! Note:
    The `--config` option may also be used to configure the 'default' model.
    In addition, the `model-default` option can usually always be used in place
    of the `--config` option. See [Configuring models][models-config] for more
    information on how models get configured and how these two options differ.

## List of controller keys

This table lists all the controller keys which may be assigned a value.

| Key                        | Type    | Default  | Valid values             | Purpose |
|:---------------------------|---------|----------|--------------------------|:---------|
api-port                     | integer | 17070    |                          | The port to use for connecting to the API
auditing-enabled             | bool    | false    | false/true               | Sets whether audit logging is enabled. Can be toggled for an existing controller.
audit-log-capture-args       | bool    | false    | false/true               | Sets whether the audit log will contain the arguments passed to API methods. Can be toggled for an existing controller.  
audit-log-exclude-methods    | string  | ReadOnlyMethods | [Some.Method,...] | What information to exclude from the audit log. Can be set for an existing controller. See [additional info][#excluding-information-audit-log].
audit-log-max-backups        | integer | 10       |                          | The maximum number of backup audit log files to keep.
audit-log-max-size           | integer | 300      |                          | The maximum size for an audit log file (units: MiB).
autocert-dns-name            | string |          |                          | Sets the DNS name of the controller. If a client connects to this name, an official certificate will be automatically requested. Connecting to any other host name will use the usual self-generated certificate.
autocert-url                 | string |          |                          | Sets the URL used to obtain official TLS certificates when a client connects to the API. By default, certificates are obtained from LetsEncrypt. A good value for testing is "https://acme-staging.api.letsencrypt.org/directory".
allow-model-access           | bool   |          | false/true               | Sets whether the controller will allow users to connect to models they have been authorized for even when they don't have any access rights to the controller itself.
bootstrap-timeout            | integer | 600     |                          | How long in seconds to wait for a connection to the controller
bootstrap-retry-delay        | integer | 5       |                          | How long in seconds to wait between connection attempts to a controller
bootstrap-address-delay      | integer | 10      |                          | How often in seconds to refresh controller addresses from the API server
ca-cert                      | string |          |                          | The certificate of the CA that signed the controller's CA certificate, in PEM format
controller-uuid              | string |          |                          | The key for the UUID of the controller
identity-public-key          | string |          |                          | Sets the public key of the identity manager. Feature not yet implemented.
identity-url                 | string |          |                          | Sets the URL of the identity manager. Feature not yet implemented.
max-logs-age                 | string | 72h      | 72h, etc.                | Sets the maximum age for log entries before they are pruned, in human-readable time format
max-logs-size                | string | 4G       | 400M, 5G, etc.           | Sets the maximum size for the log collection, in human-readable memory format
max-prune-txn-batch-size     | integer | 1e+06   | 100000, 1e+05, etc.      | Sets the maximum number of database transaction records to be pruned during each cleanup pass.
max-prune-txn-passes         | integer | 100     |                          | Sets the maximum number of passes to make during each automatic hourly database transaction record cleanup procedure.
max-txn-log-size             | string | 10M      | 100M, 1G, etc.           | Sets the maximum size for the capped txn log collection, in human-readable memory format
mongo-memory-profile         | string | low      | low/default              | Sets whether MongoDB uses the least possible memory or the default MongoDB memory profile
network                      | string |          |                          | An OpenStack network UUID.
set-numa-control-policy      | bool   | false    | false/true               | Sets whether numactl is preferred for running processes with a specific NUMA (Non-Uniform Memory Architecture) scheduling or memory placement policy for multiprocessor systems where memory is divided into multiple memory nodes
policy-target-group          | string |          |                          | An OpenStack PTG ID. Use with key 'use-openstack-gbp'.
state-port                   | integer | 37017   |                          | The port to use for mongo connections
use-floating-ip              | bool   | false    |                          | Use with OpenStack. Sets whether a floating IP address is required in order for nodes to be assigned a public IP address.
use-openstack-gbp            | bool   | false    |                          | Sets whether OpenStack GBP (Group-Based Policy) is enabled. Use with key 'policy-target-group'.

### Excluding information from the audit log

See [Audit logging][audit-logging] for background information on this topic.

Excluding information from the audit log is done via the
`audit-log-exclude-methods` key above, which refers to API calls/methods. The
recommended approach for configuring the filter is to view the log and make a
list of those calls deemed undesirable. There is no definitive API call list
available in this documentation.

The default value of key `audit-log-exclude-methods` is the special value of
'ReadOnlyMethods'. As the name suggests, this represents all read-only events.

For example, to remove the following log message:

```no-highlight
"request-id":4428,"when":"2018-02-12T20:03:45Z","facade":"Pinger","method":"Ping","version":1}}
```

we provide a `facade.method` of 'Pinger.Ping', while keeping the default value
described above, in this way:
  
```bash
juju model-config -m controller audit-log-exclude-methods=[ReadOnlyMethods,Pinger.Ping]
```

!!! Important:
    Only those Conversations whose methods have *all* been excluded will be
    omitted. For instance, assuming a default filter of 'ReadOnlyMethods', if a
    Conversation contains several read-only events and a single write event
    then all these events will appear in the log. A Conversation is a
    collection of API methods associated with a single top-level CLI command.

Click the triangle below to reveal a listing of API methods designated by the
key value of 'ReadOnlyMethods'. 

^# ReadOnlyMethods 

  ```
  Action.Actions
  Action.ApplicationsCharmsActions
  Action.FindActionsByNames
  Action.FindActionTagsByPrefix
  Application.GetConstraints
  ApplicationOffers.ApplicationOffers
  Backups.Info
  Client.FullStatus
  Client.GetModelConstraints
  Client.StatusHistory
  Controller.AllModels
  Controller.ControllerConfig
  Controller.GetControllerAccess
  Controller.ModelConfig
  Controller.ModelStatus
  MetricsDebug.GetMetrics
  ModelConfig.ModelGet
  ModelManager.ModelInfo
  ModelManager.ModelDefaults
  Pinger.Ping
  UserManager.UserInfo
  Action.ListAll
  Action.ListPending
  Action.ListRunning
  Action.ListComplete
  ApplicationOffers.ListApplicationOffers
  Backups.List
  Block.List
  Charms.List
  Controller.ListBlockedModels
  FirewallRules.ListFirewallRules
  ImageManager.ListImages
  ImageMetadata.List
  KeyManager.ListKeys
  ModelManager.ListModels
  ModelManager.ListModelSummaries
  Payloads.List
  PayloadsHookContext.List
  Resources.ListResources
  ResourcesHookContext.ListResources
  Spaces.ListSpaces
  Storage.ListStorageDetails
  Storage.ListPools
  Storage.ListVolumes
  Storage.ListFilesystems
  Subnets.ListSubnets
  ```

<!-- LINKS -->

[controllers-creating]: ./controllers-creating.html "Creating a controller"
[models-config]: ./models-config.html "Configuring models"
[#excluding-information-audit-log]: #excluding-information-from-the-audit-log
[audit-logging]: ./troubleshooting-logs.html#audit-logging
