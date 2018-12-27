Title: General configuration options
TODO: Check accuracy of key table: https://github.com/juju/juju/blob/ec89c99e51fa83cd1a2cb5e5f24e73d5b096de20/controller/config.go#L29)
      Check accuracy of key table: https://github.com/juju/juju/provider/*/config.go 
      error: table's default value keys do not show up with controller-config (e.g. bootstrap-). See above note.
      "dynamically set by Juju" could use some explaination
      ReadOnlyMethods: https://github.com/juju/juju/blob/2.3/apiserver/observer/auditfilter.go#L130
      Include ability to set configuration key:value pairs by file
      Show how to use spaces 'juju-mgmt-space' and 'juju-ha-space' (wth 'juju bootstrap' and 'juju enable-ha')
      Reformat table: monospace the key names, new column for RT
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

A key can be assigned a value during controller-creation time or post-creation
time. The vast majority of keys are set in the former way.

To set a key at controller-creation time the `--config` option is used. For
example:

```bash
juju bootstrap --config bootstrap-timeout=700 localhost lxd
```

See [Creating a controller][controllers-creating] for examples on
controller creation.

To set a key at post-creation time the `controller-config` command is used. For
example:

```bash
juju controller-config -c aws max-prune-txn-batch-size=1.2e+06 max-prune-txn-passes=120
```

## List of controller keys

This table lists all the controller keys. Those keys that can be assigned in
real-time (post-bootstrap) is tagged with **[RT]**.

| Key                        | Type    | Default  | Valid values             | Purpose |
|:---------------------------|---------|----------|--------------------------|:---------|
api-port                     | integer | 17070    |                          | The port to use for connecting controller and non-controller agents to controller agents (the controller API). See 'controller-api-port'.
api-port-open-delay **[RT]** | string  |          | 10s, etc.                | The delay before the controller API port will accept non-controller agent connections. Enabled only if 'controller-api-port' is set.
auditing-enabled **[RT]**    | bool    | true     | false/true               | Sets whether audit logging is enabled. Can be toggled for an existing controller.
audit-log-capture-args **[RT]** | bool    | false    | false/true               | Sets whether the audit log will contain the arguments passed to API methods. Can be toggled for an existing controller.  
audit-log-exclude-methods **[RT]** | string  | ReadOnlyMethods | [Some.Method,...] | What information to exclude from the audit log. Can be set for an existing controller. See [additional info][#excluding-information-audit-log].
audit-log-max-backups        | integer | 10       |                          | The maximum number of backup audit log files to keep.
audit-log-max-size           | integer | 300      |                          | The maximum size for an audit log file (units: MiB).
autocert-dns-name            | string |          |                          | Sets the DNS name of the controller. If a client connects to this name, an official certificate will be automatically requested. Connecting to any other host name will use the usual self-generated certificate.
autocert-url                 | string |          |                          | Sets the URL used to obtain official TLS certificates when a client connects to the API. By default, certificates are obtained from LetsEncrypt. A good value for testing is "https://acme-staging.api.letsencrypt.org/directory".
allow-model-access           | bool   |          | false/true               | Sets whether the controller will allow users to connect to models they have been authorized for even when they don't have any access rights to the controller itself.
bootstrap-timeout            | integer | 600     |                          | How long in seconds to wait for a connection to the controller
bootstrap-retry-delay        | integer | 5       |                          | How long in seconds to wait between connection attempts to a controller
bootstrap-address-delay      | integer | 10      |                          | How often in seconds to refresh controller addresses from the API server
ca-cert                      | string |          |                          | The certificate of the CA that signed the controller's CA certificate, in PEM format
charmstore-url               | string | https://api.jujucharms.com/charmstore | | Sets the Charm Store URL.
controller-api-port **[RT]** | integer |         |                          | The port to use for connecting controller agents to one another. See 'api-port-open-delay'.
controller-uuid              | string |          |                          | The UUID of the controller
external-network             | string |          |                          | An OpenStack external network UUID.
juju-ha-space		     | string |          |			    | The name of a network space used used for MongoDB replica-set communication in a controller HA context. Effectively acts as a machine constraint. See [additional info below](#controller-related-spaces).
juju-mgmt-space		     | string |          |			    | The name of a network space used by Juju agents to communicate with controllers. Effectively acts as a machine constraint. See [additional info below](#controller-related-spaces).
identity-public-key          | string |          |                          | Sets the public key of the identity manager. Feature not yet implemented.
identity-url                 | string |          |                          | Sets the URL of the identity manager. Feature not yet implemented.
max-logs-age                 | string | 72h      | 72h, etc.                | Sets the maximum age for log entries before they are pruned, in human-readable time format
max-logs-size                | string | 4G       | 400M, 5G, etc.           | Sets the maximum size for the log collection, in human-readable memory format
max-prune-txn-batch-size **[RT]** | integer | 1e+06   | 100000, 1e+05, etc.      | Sets the maximum number of database transaction records to be pruned during each cleanup pass.
max-prune-txn-passes **[RT]** | integer | 100     |                          | Sets the maximum number of passes to make during each automatic hourly database transaction record cleanup procedure.
max-txn-log-size             | string | 10M      | 100M, 1G, etc.           | Sets the maximum size for the capped txn log collection, in human-readable memory format
mongo-memory-profile         | string | low      | low/default              | Sets whether MongoDB uses the least possible memory or the default MongoDB memory profile
network                      | string |          |                          | An OpenStack network UUID.
set-numa-control-policy      | bool   | false    | false/true               | Sets whether numactl is preferred for running processes with a specific NUMA (Non-Uniform Memory Architecture) scheduling or memory placement policy for multiprocessor systems where memory is divided into multiple memory nodes
policy-target-group          | string |          |                          | An OpenStack PTG ID. Use with 'use-openstack-gbp'.
state-port                   | integer | 37017   |                          | The port to use for mongo connections
use-floating-ip              | bool   | false    |                          | Use with OpenStack. Sets whether a floating IP address is required in order for nodes to be assigned a public IP address.
use-openstack-gbp            | bool   | false    |                          | Sets whether OpenStack GBP (Group-Based Policy) is enabled. Use with 'policy-target-group'.

### Controller-related spaces

There are two network spaces that can be applied to controllers and this is
done by assigning a space name to options `juju-mgmt-space` and `juju-ha-space`.
See [Network spaces][network-spaces] for background information on spaces.

The space associated with `juju-mgmt-space` affects the communication between
[Juju agents][concepts-agents] and their controllers by limiting the IP
addresses of controller API endpoints to those in the space. If the chosen
space results in a lack of agent:controller communication then a fallback
default allows for any IP address to be contacted by the agent. Juju client
communication with controllers is unaffected by this option.

The space associated with `juju-ha-space` is used for MongoDB replica-set
communication when [Controller high availability][controllers-ha] is in use.
When enabling HA, this option must be set when cluster members have more than
one IP address available for MongoDB use, otherwise an error will be reported.
Existing HA replica sets with multiple available addresses will report a
warning instead of an error provided the members and addresses remain
unchanged.

Using these options with the `bootstrap` or `enable-ha` commands effectively
adds constraints to machine provisioning. These commands will emit an error if
such constraints cannot be satisfied.

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

[controllers-creating]: ./controllers-creating.md
[#excluding-information-audit-log]: #excluding-information-from-the-audit-log
[audit-logging]: ./troubleshooting-logs.md#audit-logging
[network-spaces]: ./network-spaces.md
[controllers-ha]: ./controllers-ha.md
[concepts-agents]: ./juju-concepts.md#agent
