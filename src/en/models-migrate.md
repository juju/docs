Title: Migrating models
TODO: Needs adding to navigation
      What are the rules for model migration across clouds?
      How are subnet and end point bindings handled?
      What kind of user access is needed on source/dest controllers?
      Check and add migration resources for different controllers


# Migrating models

Model migration allows you to easily move a fully operational model from one
controller to another. The same configuration of machines, units and their
relationships will be replicated on a secondary controller, allowing your
applications to continue unhindered. 

Migration is brilliant when updating Juju because you can migrate a model to a
different controller, update the original controller, and migrate the model
back without risking your deployment. 

But it's also useful for load balancing. A controller might have reached
capacity running 10 different models, for example. You can now take the most
intensive of those models and migrate them to a new controller, reducing the
load without affecting your applications. 

For migration to work, the secondary controller needs to be running on the same
cloud substrate as the source controller. Migration doesn't work across
different regions or VPCs without direct connectivity to the source controller,
and migration doesn't currently work across different cloud environments. 

!!! Note: Only hosted models can be migrated. The controller can not be
migrated.

## Usage

In order to start a migration, the target controller must be in the Juju
client's local configuration cache. See the '[clouds][clouds]' documentation 
for details on how to do this.

Before initiating a migration, make sure the model isn't in a transitional
state such as deploying new applications or resources. You can check with the
`juju status <model>` command. 

While the migration process itself is robust, we'd also highly recommend
creating a backup of your source controller before performing a migration. 

To create a backup that's both stored on the controller and downloaded
locally, type the following:

```bash
juju switch controller
juju create backup
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

In the status output, a 'Notes' column will be appended to the model overview
line at the top of the output. This new column will step through the following
'migrating' states during the process:

1. starting
2. exporting model
3. importing model into target controller
4. uploading model binaries into target controller
5. validating, waiting for agents to report back
6. successful, transferring logs to target controller (0 sent)
7. successful, removing model from source controller

If the migration does fail at any point, the model will be returned to its
original controller in the same state it was in before the migration process
was started.

The duration of a migration will obviously depend on the complexity of the model, the
resources it uses and the capabilities of the hosted environment, but smaller deployments
should take minutes rather than hours. 

When complete, the model will no longer exist on the source controller, and the
model, all its applications, machines and units will be running on the
secondary controller. 

[clouds]: ./clouds.html
[backup]: ./controllers-backup.html
