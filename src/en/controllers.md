Title: Juju Controllers
TODO:  Figure out the 'block command' situation (including CLI help
         text). See 'Restricting command usage' section. The old page lives on.
       Need examples for each command.
       .


# Controllers

A Juju *controller* is the management node of a Juju cloud environment. In
particluar, it houses the database and keeps track of all the models in that
environment. Although it is a special node, it is a machine that
gets created by Juju (during the "bootstrap" stage) and, in that sense, is
similar to other Juju machines.

During controller creation two *models* are also created, the 'controller' model
and the 'default' model. The primary purpose of the 'controller' model is to
run and manage the Juju API server and the underlying database. Additional
models may be created by the user - see [Models](./models.html).

Since a controller can host multiple models, the destruction of a controller
must be done with ample consideration since all its models will be destroyed
along with it.

In some circumstances you may wish to share a controller or one of its associated
models. Juju provides [multi-user functionality](./users.html) for this purpose.


## Controller management

Common tasks are summarized below.


^# Create a controller
   
   Use the `juju bootstrap` command to create a controller.

         juju bootstrap [options] [filter pattern ...]
   
   For examples see [Creating a controller](./controllers-creating.html).

   For complete explanation, syntax and examples see the
   [command reference page](./commands.html#bootstrap) or the `juju help
   bootstrap` command.


^# List controllers
   
   Use the `juju list-controllers` command to list all controllers knowable by
   the current system user.

         juju list-controllers [options] 
   
   The currently active controller is indicated in the list with an asterisk('*').
   
   For complete explanation, syntax and examples see the
   [command reference page](./commands.html#list-controllers) or the `juju help
   list-controllers ` command.



^# Show controller details
   
   Use the `juju show-controller` command to show details for a controller.
   Information includes UUID, API endpoints, certificates, and bootstrap
   configuarion.

         juju show-controller [options]
   
   For complete explanation, syntax and examples see the
   [command reference page](./commands.html#show-controller) or the `juju help
   show-controller` command.



^# Remove a controller
   
   Use the `juju destroy-controller` command to remove a controller.

         juju destroy-controller [options]
   
   For complete explanation, syntax and examples see the
   [command reference page](./commands.html#destroy-controller) or the `juju help
   destroy-controller` command.
   
   Use the `juju kill-controller` command as a last resort if the controller is
   not accessible for some reason.

   The controller will be removed by communicating directly with the cloud
   provider. Any other Juju machines residing within any of the controller's
   models will not be destroyed and will need to be removed manually using
   provider tools/console. This command will first attempt to mimic the behaviour
   of the `juju destroy-controller` command and failover to the more drastic
   behaviour if that attempt fails.
   
         juju kill-controller [options]
   
   For complete explanation, syntax and examples see the
   [command reference page](./commands.html#kill-controller) or the `juju help
   kill-controller` command.


^# Use the Juju GUI
   
   Each Juju controller creates a web-driven GUI as an alternative method of
   management. The GUI is capable of deploying, scaling and monitoring
   applications, as well as more advanced operations.
   
   More details on the GUI can be found in the [Juju GUI section][gui].
   

   
^# Back up a controller
   
   Juju allows one to create, restore and manage backup files containing the
   controller configuration/metadata. If the controller or its host machine
   fails, it is possible to recreate the controller from the backup.

   This is a complex subject. See [Juju backups](./controllers-backup.html).

   Note: coverage of client backups are included in the above resource.

   
 
 
^# Implement HA (high availability)

   Each Juju controller can be made 'Highly Available' to add resilience to the
   operations of the controller itself. This topic is covered in more detail in
   the [Juju HA][ha] documentation.
   HA for the applications deployed is a matter for the charms, and is covered
   in a separate topic,[charm HA][charm-ha].

   

^# Restricting command usage
   
   A controller administrator is responsible for granting permissions to
   users registered with a controller. This can be done by restricting what
   sorts of changes a user can make across the controller's models.

   This topic is treated in
   [Restricting changes to the running Juju environment](./juju-block.html).


[gui]: ./controllers-gui.html
[ha]: ./controllers-ha.html
[charm-ha]: ./charms-ha
