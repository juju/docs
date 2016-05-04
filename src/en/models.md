Title: Juju models
TODO: Previous warning (add-model): "For 'ec2' and 'openstack' cloud types, the
      access and secret keys need to be provided." I tested ec2 and did not
      need to do this. OpenStack?


# Juju models

A Juju *model* is an environment associated with a *controller* (see
[Controllers](./controllers.html)). When a controller is created two models are
provisioned along with it. These initial models are named 'admin' and
'default'. The 'admin' model is not intended for general workloads but solely
for monitoring and management purposes. The 'default' model, however, is ready
for immediate use. Models can be added easily at any time (see below). 


## Model management

Common model management tasks are summarized below.


^# View status
   
   Use the `juju status` command to view the status a model:

   `juju status [options] [filter pattern ...]`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#status) or the `juju help
   status` command.
   


^# Add a model
  
   Use the `juju add-model` command to add a model to a controller:
   
   `juju add-model [options] <model name> [key=[value] ...]`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#add-model) or the `juju help
   add-model` command.
   


^# List models

   Use the `juju list-models` command to list all models for a controller:
   
   `juju list-models [options]`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#list-models) or the `juju help
   list-models` command.



^# Configure a model

   Configuration can occur at the model level. This will affect all Juju
   machines in the model. For instance, a logging level and API port can be
   stipulated.

   This is a complex subject. See [Model configuration](./models-config.html).
   


^# Destroy a model

   Use the `juju destroy-model` command to remove a model from a controller:
   
   `juju destroy-model [options] <model name>`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#destroy-model) or the `juju help
   destroy-model` command.
   


^# Switch models
   
   Use the `juju switch` command to go from one model to another:
   
   `juju switch [<controller>|<model>|<controller>:<model>]`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#switch) or the `juju help switch`
   command.
   


^# Provide SSH access
   
   Use the `juju add-ssh-key` command to provide SSH access to all machines,
   present and future, in a model:
   
   `juju add-ssh-key <ssh-key>`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#add-ssh-key) or the `juju help
   add-ssh-key` command.
   


^# List SSH access keys
   
   Use the `juju list-ssh-keys` command to list SSH keys currently permitting
   access to all machines, present and future, in a model:
   
   `juju list-ssh-keys [options]`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#list-ssh-keys) or the `juju help
   list-ssh-keys` command.
   


^# Remove SSH access
   
   Use the `juju remove-ssh-key` command to remove SSH access to all machines,
   present and future, from a model:
   
   `juju remove-ssh-key <ssh-key-id> ...`
   
   For complete explanation and syntax, see the
   [command reference page](./commands.html#remove-ssh-key) or the `juju help
   remove-ssh-key` command.
   
   

^# Grant and revoke user access
   
   This topic is treated in
   [Users and models](./users-models.html#models-and-user-access).



^# View logs

   Juju logs are viewed at the model level. This allows inspection of
   activities occuring on multiple Juju machines simultaneously. Due to the
   expected large volume of data, advanced filtering is available.

   This is a complex subject. See [Juju logs](./troubleshooting-logs.html).



^# Upgrade a model
   
   Juju software is upgraded at the model level. This affects the Juju agents
   running on every machine Juju creates. This upgrade process does not pertain
   to the Juju software package installed on a client system.

   This is a complex subject. See [Juju upgrades](./models-upgrade.html).
