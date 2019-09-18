<!--
Todo:
- Need examples for each command that does not link to another page.
-->

A *controller* is the management node of a Juju cloud environment. It runs the API server and the underlying database. Its overall purpose is to keep state of all the [models](/t/models/1155), [applications](/t/applications/1034), and machines in that environment. Although it is a special node, it is a machine that gets created by Juju and, in that sense, is similar to any other Juju machine.

During controller creation two *models* are also created, the 'controller' model and the 'default' model. Additional models may be added by the user very easily.

<!--
Additional models may be added by the user and, since `v.2.6.?`, such a model can be hosted in another cloud (i.e. a controller can manage multiple clouds).
-->

The minimum resources required for a controller are 3.5 GiB of memory and 1 vCPU.

Common controller management tasks are summarised below. The most important one is [Creating a controller](/t/creating-a-controller/1108).

[details=Back up a controller]
Juju allows one to create, restore and manage backup files containing the controller configuration/metadata. If the controller or its host machine fails, it is possible to recreate the controller from the backup. See [Controller backups](/t/controller-backups/1106) for assistance.
[/details]

[details=Configure a controller]
There are many settings available for configuring a controller, such as whether the controller will record auditing information. Controller configuration must be passed at controller-creation time, although some exceptions exist (i.e. some changes can be made after creation). This topic is covered in more depth in [Configuring controllers](/t/configuring-controllers/1107).
[/details]

[details=Controller high availability]
Each controller can be made highly available to add resilience to the operations of the controller itself. This topic is covered on the [Controller high availability](/t/controller-high-availability/1110) page.
[/details]

[details=Create a controller]
The creation of a controller is a hallmark step in the setting up of a Juju environment. See [Creating a controller](/t/creating-a-controller/1108) for examples.
[/details]

[details=Destroy a controller]
When a controller is destroyed all associated models and applications are also removed. It is a very destructive process.
See the [Removing things](/t/removing-things/1063) for a full explanation.
[/details]

[details=Disable commands]
A controller administrator can restrict what sorts of changes a user can make across the controller's models. This topic is treated on the [Disabling commands](/t/disabling-commands/1141) page.
[/details]

[details=List controllers]
Use the `controllers` command to list all controllers known to the client. The currently active controller is indicated in the list with an asterisk('*').
[/details]

[details=Log in to a controller]
A user can log in to a controller in various ways. See page [Controller logins](/t/controller-logins/1389) for details.
[/details]

[details=Show controller details]
Use the `show-controller` command to show details for a controller. Information includes UUID, API endpoints, certificates, and bootstrap configuration.
[/details]

[details=Use the Juju GUI]
Each controller creates a web GUI as an alternative method of management. The GUI is capable of deploying, scaling, and monitoring applications, as well as more advanced operations. More details can be found on the [Juju GUI](/t/juju-gui/1109) page.
[/details]
