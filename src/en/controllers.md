Title: Controllers
TODO:  Need examples for each command that does not link to another page.

# Controllers

A *controller* is the management node of a Juju cloud environment. In
particular, it houses the database and keeps track of all the models in that
environment. Although it is a special node, it is a machine that gets created
by Juju and, in that sense, is similar to any other Juju machine.

During controller creation two *models* are also created, the 'controller'
model and the 'default' model. The primary purpose of the 'controller' model is
to run and manage the API server and the underlying database. Additional models
may be created by the user (see [Models][models]).

Since a controller can host multiple models, the destruction of a controller
must be done with ample consideration since all its models will be destroyed
along with it.

In some circumstances you may wish to share a controller or one of its
associated models. See page [Working with multiple users][multiuser] for
guidance.

The minimum resources required for a controller are 3.5 GiB of memory and 1
vCPU.

## Controller management

Common controller management tasks are summarised below.

The most important one is [Creating a controller][controllers-creating].


^# Back up a controller

   Juju allows one to create, restore and manage backup files containing the
   controller configuration/metadata. If the controller or its host machine
   fails, it is possible to recreate the controller from the backup.

   See [Controller backups][controllers-backup] for assistance.


^# Configure a controller

   There are many settings available for configuring a controller, such as
   whether the controller will record auditing information. Controller
   configuration must be passed at controller-creation time, although some
   exceptions exist (i.e. some changes can be made after creation).

   This topic is covered in more depth in
   [Configuring controllers][controllers-config].


^# Controller high availability

   Each controller can be made highly available to add resilience to the
   operations of the controller itself. This topic is covered on the
   [Controller high availability][controllers-ha] page.


^# Create a controller

   The creation of a controller is a hallmark step in the setting up of a Juju
   environment.
   
   See [Creating a controller][controllers-creating] for examples.


^# Disable commands

   A controller administrator can restrict what sorts of changes a user can
   make across the controller's models.

   This topic is treated on the [Disabling commands][juju-block] page.


^# List controllers

   Use the `controllers` command to list all controllers known to the client.

   `juju controllers [options]`

   The currently active controller is indicated in the list with an
   asterisk('*').

   For command line help and syntax run `juju help controllers`.


^# Remove a controller

   When a controller is removed all associated models and applications are also
   removed. It is a very destructive process.

   See the [Removing things][charms-destroy] for a full explanation.


^# Show controller details

   Use the `show-controller` command to show details for a controller.
   Information includes UUID, API endpoints, certificates, and bootstrap
   configuarion.

   `juju show-controller [options]`

   For command line help and syntax run `juju help show-controller`.


^# Use the Juju GUI

   Each controller creates a web GUI as an alternative method of management.
   The GUI is capable of deploying, scaling, and monitoring applications, as
   well as more advanced operations.

   More details can be found on the [Juju GUI][controllers-gui] page.


<!-- LINKS -->

[models]: ./models.md
[multiuser]: ./multiuser.md
[juju-block]: ./juju-block.md
[charms-destroy]: ./charms-destroy.md
[controllers-backup]: ./controllers-backup.md
[controllers-config]: ./controllers-config.md
[controllers-creating]: ./controllers-creating.md
[controllers-gui]: ./controllers-gui.md
[controllers-ha]: ./controllers-ha.md
