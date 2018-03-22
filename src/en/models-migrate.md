Title: Migrating models
TODO: Needs adding to navigation
      How are subnet and end point bindings handled?
      Check and add migration resources for different controllers


# Migrating models

Model migration allows you to easily move a live model from one controller to
another. The same configuration of machines, units and their relationships will
be replicated on a secondary controller, while your applications continue
uninterrupted. 

Migration is useful when upgrading a controller, for load balancing, and for
providing additional flexibility.

When upgrading a controller, you can bootstrap a new controller running a newer
version of Juju and then migrate each model across one at a time. This is
safer than upgrading a controller while its running many applications. 

Migration is equally useful for load balancing. If a controller hosting
multiple models reaches capacity, you can now move the busiest models to a new
controller, reducing load without affecting your applications.

For migration to work:

  - The source and destination controllers need to be in the same cloud environment. 
  - The destination controller needs to be running on the same cloud substrate
    as the source controller.
  - Destination controllers on different regions or VPCs need direct
    connectivity to the source controller.
  - The version of Juju running on the destination controller needs to be the
    same or newer than the version on the source controller.

!!! Note: A controller model can not be migrated.

## Usage

To start a migration, the target controller must be in the Juju client's local
configuration cache. See the '[clouds][clouds]' documentation for details on
how to do this.

While the migration process itself is robust, thanks to extensive checks before
and during the process, we still recommend creating a backup of your source
controller before performing a migration. 

To create a backup that's both stored on the controller and downloaded
locally, type the following:

```bash
juju switch controller
juju create-backup
```
See '[Backing Up and Restoring Juju][backup]' if you need further details.

To migrate a model on the current controller to a model on another controller,
you simply name the model as the first argument followed by the target
controller (a model with the same name can't exist on the target controller):

```bash
juju migrate <model-name> <target-controller-name>
```

This will initiate the migration with output similar to the following:

<!-- JUJUVERSION: 2.1-beta2-genericlinux-amd64  -->
<!-- JUJUCOMMAND: juju migrate newwiki lxd-back -->
```no-highlight
Migration started with ID "d1924666-1b00-4805-89b5-5ed5a6744426:0"
```

You can monitor the migration progress from the output of the `juju status`
command run against the source model. You may want to use a command such
as `watch` to automatically refresh the status output, rather than manually
running status each time:

```bash
watch --color -n 1 juju status --color
```

In the status output, a 'Notes' column is appended to the model overview line
at the top of the output. The migration will step through various states, from
'starting' to 'successful', while the migration is in progress.

The 'status' section in the output from the `juju show-model` command also
includes details on the current or most recently run migration. It adds extra
information too, such as the migration start time, and is a good place to start
if you need to determine why a migration has failed. 

This section will look similar to the following after starting a
migration:

```no-highlight
  status:
    current: available
    since: 23 hours ago
    migration: uploading model binaries into target controller
    migration-start: 21 seconds ago
```

If the migration fails at any point, the model will be safely reinstated on its
original controller in the same state it was in before the migration process
was started.

The duration of a migration will obviously depend on the complexity of the
model, the resources it uses and the capabilities of the hosted environment.
Most migrations will take minutes, and even large deployments are unlikely to
take hours. 

When complete, the model will no longer exist on the source controller, and the
model, all its applications, machines and units will be running on the
secondary controller. 

Use `juju switch` to select the migrated model in the destination controller:

```bash
juju switch <target controller>:<model>
juju status
```

[clouds]: ./clouds.html
[backup]: ./controllers-backup.html
