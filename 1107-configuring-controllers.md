<!--
Todo:
- Check accuracy of key table: https://github.com/juju/juju/blob/ec89c99e51fa83cd1a2cb5e5f24e73d5b096de20/controller/config.go#L29)
- Check accuracy of key table: https://github.com/juju/juju/provider/*/config.go
- error: table's default value keys do not show up with controller-config (e.g. bootstrap-). See above note.
- "dynamically set by Juju" could use some explaination
- ReadOnlyMethods: https://github.com/juju/juju/blob/2.3/apiserver/observer/auditfilter.go#L130
- Include ability to set configuration key:value pairs by file
- Show how to use spaces 'juju-mgmt-space' and 'juju-ha-space' (wth 'juju bootstrap' and 'juju enable-ha')
- Reformat table: monospace the key names, new column for RT
-->

A Juju controller is the management node of a Juju cloud environment. It houses the database and keeps track of all the models in that environment.

Controller configuration consists of a collection of keys and their respective values. An explanation of how to both view and set these key:value pairs is provided below.

<h2 id="heading--getting-values">Getting values</h2>

A controller's configuration key values can be listed by running this command:

``` text
juju controller-config
```

The key-value pairs that are shown will include those that were set during controller creation (see below), inherited as a default value (see table), or dynamically set by Juju.

<h2 id="heading--setting-values">Setting values</h2>

A key can be assigned a value during controller-creation time or post-creation time. The vast majority of keys are set in the former way.

To set a key at controller-creation time the `--config` option is used. For example:

``` text
juju bootstrap --config bootstrap-timeout=700 localhost lxd
```

See [Creating a controller](/t/creating-a-controller/1108) for examples on controller creation.

To set a key at post-creation time the `controller-config` command is used. For example:

``` text
juju controller-config -c aws max-prune-txn-batch-size=1.2e+06 max-prune-txn-passes=120
```

<h2 id="heading--list-of-controller-keys">List of controller keys</h2>

This table lists all the controller keys. Those keys that can be assigned in real-time (post-bootstrap) is tagged with **[RT]**.

<table style="width:100%;">
<colgroup>
<col width="32%" />
<col width="11%" />
<col width="12%" />
<col width="30%" />
<col width="12%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Key</th>
<th>Type</th>
<th>Default</th>
<th>Valid values</th>
<th align="left">Purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">api-port</td>
<td>integer</td>
<td>17070</td>
<td></td>
<td align="left">The port to use for connecting controller and non-controller agents to controller agents (the controller API). See 'controller-api-port'.</td>
</tr>
<tr class="even">
<td align="left">api-port-open-delay <strong>[RT]</strong></td>
<td>string</td>
<td></td>
<td>10s, etc.</td>
<td align="left">The delay before the controller API port will accept non-controller agent connections. Enabled only if 'controller-api-port' is set.</td>
</tr>
<tr class="odd">
<td align="left">auditing-enabled <strong>[RT]</strong></td>
<td>bool</td>
<td>true</td>
<td>false/true</td>
<td align="left">Sets whether audit logging is enabled. Can be toggled for an existing controller.</td>
</tr>
<tr class="even">
<td align="left">audit-log-capture-args <strong>[RT]</strong></td>
<td>bool</td>
<td>false</td>
<td>false/true</td>
<td align="left">Sets whether the audit log will contain the arguments passed to API methods. Can be toggled for an existing controller.</td>
</tr>
<tr class="odd">
<td align="left">audit-log-exclude-methods <strong>[RT]</strong></td>
<td>string</td>
<td>ReadOnlyMethods</td>
<td>[Some.Method,...]</td>
<td align="left">What information to exclude from the audit log. Can be set for an existing controller. See <a href="#excluding-information-from-the-audit-log">additional info</a>.</td>
</tr>
<tr class="even">
<td align="left">audit-log-max-backups</td>
<td>integer</td>
<td>10</td>
<td></td>
<td align="left">The maximum number of backup audit log files to keep.</td>
</tr>
<tr class="odd">
<td align="left">audit-log-max-size</td>
<td>integer</td>
<td>300</td>
<td></td>
<td align="left">The maximum size for an audit log file (units: MiB).</td>
</tr>
<tr class="even">
<td align="left">autocert-dns-name</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">Sets the DNS name of the controller. If a client connects to this name, an official certificate will be automatically requested. Connecting to any other host name will use the usual self-generated certificate.</td>
</tr>
<tr class="odd">
<td align="left">autocert-url</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">Sets the URL used to obtain official TLS certificates when a client connects to the API. By default, certificates are obtained from LetsEncrypt. A good value for testing is &quot;https://acme-staging.api.letsencrypt.org/directory&quot;.</td>
</tr>
<tr class="even">
<td align="left">allow-model-access</td>
<td>bool</td>
<td></td>
<td>false/true</td>
<td align="left">Sets whether the controller will allow users to connect to models they have been authorized for even when they don't have any access rights to the controller itself.</td>
</tr>
<tr class="odd">
<td align="left">bootstrap-timeout</td>
<td>integer</td>
<td>600</td>
<td></td>
<td align="left">How long in seconds to wait for a connection to the controller</td>
</tr>
<tr class="even">
<td align="left">bootstrap-retry-delay</td>
<td>integer</td>
<td>5</td>
<td></td>
<td align="left">How long in seconds to wait between connection attempts to a controller</td>
</tr>
<tr class="odd">
<td align="left">bootstrap-address-delay</td>
<td>integer</td>
<td>10</td>
<td></td>
<td align="left">How often in seconds to refresh controller addresses from the API server</td>
</tr>
<tr class="even">
<td align="left">ca-cert</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The certificate of the CA that signed the controller's CA certificate, in PEM format</td>
</tr>
<tr class="odd">
<td align="left">charmstore-url</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">Sets the Charm Store URL.</td>
</tr>
<tr class="even">
<td align="left">controller-api-port <strong>[RT]</strong></td>
<td>integer</td>
<td></td>
<td></td>
<td align="left">The port to use for connecting controller agents to one another. See 'api-port-open-delay'.</td>
</tr>
<tr class="odd">
<td align="left">controller-uuid</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The UUID of the controller</td>
</tr>
<tr class="even">
<td align="left">external-network</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">An OpenStack external network UUID.</td>
</tr>
<tr class="odd">
<td align="left">juju-ha-space</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The name of a network space used used for MongoDB replica-set communication in a controller HA context. Effectively acts as a machine constraint. See <a href="#controller-related-spaces">additional info below</a>.</td>
</tr>
<tr class="even">
<td align="left">juju-mgmt-space</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The name of a network space used by Juju agents to communicate with controllers. Effectively acts as a machine constraint. See <a href="#controller-related-spaces">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">identity-public-key</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">Sets the public key of the identity manager. Feature not yet implemented.</td>
</tr>
<tr class="even">
<td align="left">identity-url</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">Sets the URL of the identity manager. Feature not yet implemented.</td>
</tr>
<tr class="odd">
<td align="left">max-logs-age</td>
<td>string</td>
<td>72h</td>
<td>72h, etc.</td>
<td align="left">Sets the maximum age for log entries before they are pruned, in human-readable time format</td>
</tr>
<tr class="even">
<td align="left">max-logs-size</td>
<td>string</td>
<td>4G</td>
<td>400M, 5G, etc.</td>
<td align="left">Sets the maximum size for the log collection, in human-readable memory format</td>
</tr>
<tr class="odd">
<td align="left">max-prune-txn-batch-size <strong>[RT]</strong></td>
<td>integer</td>
<td>1e+06</td>
<td>100000, 1e+05, etc.</td>
<td align="left">Sets the maximum number of database transaction records to be pruned during each cleanup pass. DEPRECATED</td>
</tr>
<tr class="even">
<td align="left">max-prune-txn-passes <strong>[RT]</strong></td>
<td>integer</td>
<td>100</td>
<td></td>
<td align="left">Sets the maximum number of passes to make during each automatic hourly database transaction record cleanup procedure. DEPRECATED</td>
</tr>
<tr class="odd">
<td align="left">max-txn-log-size</td>
<td>string</td>
<td>10M</td>
<td>100M, 1G, etc.</td>
<td align="left">Sets the maximum size for the capped txn log collection, in human-readable memory format</td>
</tr>
<tr class="even">
<td align="left">mongo-memory-profile</td>
<td>string</td>
<td>low</td>
<td>low/default</td>
<td align="left">Sets whether MongoDB uses the least possible memory or the default MongoDB memory profile</td>
</tr>
<tr class="odd">
<td align="left">network</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">An OpenStack network UUID.</td>
</tr>
<tr class="even">
<td align="left">prune-txn-query-count <strong>[RT]</strong></td>
<td>integer</td>
<td>1000</td>
<td>10000, 1e+04, etc.</td>
<td align="left">Sets the number of database transaction records to evaluate for pruning in a single query. Minimum value of '10'. A value of '0' indicates the default.</td>
</tr>
<tr class="odd">
<td align="left">prune-txn-sleep-time <strong>[RT]</strong></td>
<td>string</td>
<td>10ms</td>
<td>5ms, 100ms, etc.</td>
<td align="left">Sets the amount of time to sleep between each database transaction pruning query. A value of '0' indicates no sleep time. A negative value indicates the default.</td>
</tr>
<tr class="even">
<td align="left">set-numa-control-policy</td>
<td>bool</td>
<td>false</td>
<td>false/true</td>
<td align="left">Sets whether numactl is preferred for running processes with a specific NUMA (Non-Uniform Memory Architecture) scheduling or memory placement policy for multiprocessor systems where memory is divided into multiple memory nodes</td>
</tr>
<tr class="odd">
<td align="left">policy-target-group</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">An OpenStack PTG ID. Use with 'use-openstack-gbp'.</td>
</tr>
<tr class="even">
<td align="left">state-port</td>
<td>integer</td>
<td>37017</td>
<td></td>
<td align="left">The port to use for mongo connections</td>
</tr>
<tr class="odd">
<td align="left">use-floating-ip</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Use with OpenStack. Sets whether a floating IP address is required in order for nodes to be assigned a public IP address.</td>
</tr>
<tr class="even">
<td align="left">use-openstack-gbp</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Sets whether OpenStack GBP (Group-Based Policy) is enabled. Use with 'policy-target-group'.</td>
</tr>
</tbody>
</table>

<h3 id="heading--controller-related-spaces">Controller-related spaces</h3>

There are two network spaces that can be applied to controllers and this is done by assigning a space name to options `juju-mgmt-space` and `juju-ha-space`. See [Network spaces](/t/network-spaces/1157) for background information on spaces.

The space associated with `juju-mgmt-space` affects the communication between [Juju agents](/t/concepts-and-terms/1144#heading--agent) and their controllers by limiting the IP addresses of controller API endpoints to those in the space. If the chosen space results in a lack of agent:controller communication then a fallback default allows for any IP address to be contacted by the agent. Juju client communication with controllers is unaffected by this option.

The space associated with `juju-ha-space` is used for MongoDB replica-set communication when [Controller high availability](/t/controller-high-availability/1110) is in use. When enabling HA, this option must be set when cluster members have more than one IP address available for MongoDB use, otherwise an error will be reported. Existing HA replica sets with multiple available addresses will report a warning instead of an error provided the members and addresses remain unchanged.

Using these options with the `bootstrap` or `enable-ha` commands effectively adds constraints to machine provisioning. These commands will emit an error if such constraints cannot be satisfied.

<h3 id="heading--excluding-information-from-the-audit-log">Excluding information from the audit log</h3>

See [Audit logging](/t/juju-logs/1184#heading--audit-logging) for background information on this topic.

Excluding information from the audit log is done via the `audit-log-exclude-methods` key above, which refers to API calls/methods. The recommended approach for configuring the filter is to view the log and make a list of those calls deemed undesirable. There is no definitive API call list available in this documentation.

The default value of key `audit-log-exclude-methods` is the special value of 'ReadOnlyMethods'. As the name suggests, this represents all read-only events.

For example, to remove the following log message:

``` text
"request-id":4428,"when":"2018-02-12T20:03:45Z","facade":"Pinger","method":"Ping","version":1}}
```

we provide a `facade.method` of 'Pinger.Ping', while keeping the default value described above, in this way:

``` text
juju model-config -m controller audit-log-exclude-methods=[ReadOnlyMethods,Pinger.Ping]
```

[note type="caution"]
Only those Conversations whose methods have *all* been excluded will be omitted. For instance, assuming a default filter of 'ReadOnlyMethods', if a Conversation contains several read-only events and a single write event then all these events will appear in the log. A Conversation is a collection of API methods associated with a single top-level CLI command.
[/note]

Click the heading below to reveal a listing of API methods designated by the key value of 'ReadOnlyMethods'.

[details=ReadOnlyMethods]
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
[/details]
