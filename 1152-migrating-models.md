<!--
Todo:
- How are subnet and end point bindings handled?
- Check and add migration resources for different controllers
- Review required
-->

Model migration is the movement of a model from one controller to another. The same configuration of machines, units, and their relations will be replicated on the destination controller, while your applications continue uninterrupted. Note that a controller model cannot be migrated.

Model migrations can be used to simulate a controller upgrade where models are migrated to a newly-created controller (running with a more recent Juju version).

Migration is equally useful for load balancing. If a controller hosting multiple models reaches capacity, you can move the busiest models to a new controller, reducing load without affecting your applications.

For migration to work:

- The source and destination controllers need to be in the same cloud environment.
- The destination controller needs to be running on the same cloud substrate as the source controller.
- Destination controllers on different regions or VPCs need direct connectivity to the source controller.
- The version of Juju running on the destination controller needs to be the same or newer than the version on the source controller.
- A model intended to be migrated must have all of its users set up on the destination controller. The operation will be aborted, and an advisory message displayed, if this is not the case.

<h2 id="heading--usage">Usage</h2>

To start a migration, the destination controller must be in the client's local configuration cache. See the [Clouds](/t/clouds/1100) page for details on how to do this.

While the migration process is robust, a backup of the source controller before performing a migration is recommended. See [Controller backups](/t/controller-backups/1106) for assistance.

To migrate a model on the current controller to a destination controller:

```text
juju migrate <model-name> <destination-controller>
```

[note]
A model with the same name as the migrated model cannot exist on the destination controller
[/note]

You can monitor progress from the output of the `status` command run against the source model. You may want to use a command such as `watch` to automatically refresh the status output, rather than manually running status each time:

```text
watch --color -n 1 juju status --color
```

In the output, a 'Notes' column is appended to the model overview line at the top of the output. The migration will step through various states, from 'starting' to 'successful'.

The 'status' section in the output from the `show-model` command also includes details on the current or most recently run migration. It adds extra information too, such as the migration start time, and is a good place to start if you need to determine why a migration has failed.

This section will look similar to the following after starting a migration:

```text
  status:
    current: available
    since: 23 hours ago
    migration: uploading model binaries into destination controller
    migration-start: 21 seconds ago
```

Migration time depends on the complexity of the model, the resources it uses, and the capabilities of the backing cloud.

If failure occurs during the migration process, the model, in its original state, will be reverted to the original controller.

<h2 id="heading--verification">Verification</h2>

When the migration has completed successfully, the model will no longer reside on the source controller. It, and its applications, machines and units, will be running on the destination controller.

Inspect the migrated model with the `status` command:

```text
juju status -m <destination-controller>:<model>
```

On `v.2.6.0` (both client and source controller) if the model is accessed using the old/source controller the operator is guided to the new controller:

```text
juju status -m <source-controller>:<model>
```

In this case, the following responses are possible:

a) if the controller is known to the client:

```text
ERROR Model "migrate" has been migrated to controller "dst".
To access it run 'juju switch dst:migrate'.
```

b) if the controller is unknown to the client:

```text
ERROR Model "migrate" has been migrated to another controller.
To access it run one of the following commands (you can replace the -c argument with your own preferred controller name):
 'juju login 10.65.47.40:17070 -c dst'

New controller fingerprint [93:73:88:C9:9A:AA:EC:C8:85:AE:D1:33:E5:92:CE:95:0F:B6:00:82:21:CB:8C:A0:42:16:29:77:CF:6D:B6:D4]
```

See [Controller logins](/t/controller-logins/1389) for background information.
