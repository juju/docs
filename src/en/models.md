Title: Models

# Models

A *model* is an environment associated with a *controller* (see
[Controllers][controllers]). When a controller is created two models are
provisioned along with it. These initial models are named 'controller' and
'default'. The 'controller' model is for internal Juju management and is not
intended for general workloads. The 'default' model, however, is ready for
immediate use. Models can be added easily at any time.

## Model management

Common model management tasks are summarised below.

The most important ones are [Adding a model][models-adding] and
[Configuring models][models-config].


^# Add a model
  
   Models can be quickly and easily added to a controller with the `add-model`
   command.
   
   The [Adding a model][models-adding] page provides a full explanation and
   includes examples.


^# Change models
   
   Use the `switch` command to change from one model to another:
   
   `juju switch [<controller or model>|<:model>|<controller>:<model>|<controller:>]`
   
   Running the command with no arguments will return the currently active 
   controller and model:
     
         juju switch
   
   To change to a model:
   
   `juju switch foo`  
   Selects the last used model in controller 'foo' (if the latter exists),
   otherwise model 'foo' in the current controller.

   `juju switch :foo`  
   Selects model 'foo' in the current controller.

   `juju switch foo:bar`  
   Selects model 'bar' in controller 'foo'.
   
   `juju switch foo:`  
   Selects the last used model in controller 'foo'

   For command line help and syntax run `juju help switch`.


^# Compare a bundle to a model

   A useful tool is the `diff-bundle` command. It allows the operator to
   compare a model with a charm bundle.
   
   This topic is treated on the [Charm bundles][charms-bundles-diff] page.


^# Configure a model

   Configuration can occur at the model level. This will affect all Juju
   machines in the model. For instance, a logging level and API port can be
   stipulated.

   See the [Configuring models][models-config] page for explanations.


^# Cross model relations
   
   Traditionally, when adding a relation between two applications (see
   [Charm relations][charms-relations]) the applications reside within the same
   model and controller. It is possible to overcome this limitation by
   employing *cross model relations*.

   This topic is covered on the [Cross model relations][models-cmr] page.


^# Destroy a model

   Use the `destroy-model` command to remove a model from a controller:
   
   `juju destroy-model [options] <model name>`
   
   For command line help and syntax run `juju help destroy-model`.


^# Disable commands

   It is possible to curtail command use for Juju users on a per-model basis
   with the use of command `disable-command`.
   
   The [Disabling commands][juju-block] page gives more information.


^# Examine a model

   Use the `show-model` command to examine a specific model:
   
   `juju show-model [options]`
   
   For command line help and syntax run `juju help show-model`.


^# List all models

   Use the `models` command to list all models for a controller:
   
   `juju models [options]`
   
   For command line help and syntax run `juju help models`.


^# List SSH access keys
   
   Use the `ssh-keys` command to list SSH keys currently permitting access to
   all machines, present and future, in a model:
   
   `juju ssh-keys [options]`
   
   For command line help and syntax run `juju help ssh-keys`.
   

^# Manage user access
   
   If you're using multiple Juju users you will need to manage access to your
   models. See page [Working with multiple users][multiuser] for a full
   explanation.
   

^# Migrate models

   Use the `migrate` command to migrate a model from one controller to another.

   `juju migrate [options] <model name> <target controller name>`
   
   For command line help and syntax run `juju help migrate`.

   For a complete explanation see the [Migrating models][models-migrate] page.
   

^# Provide SSH access
   
   Use the `add-ssh-key` and `import-ssh-key` commands to provide SSH access to
   all machines, present and future, in a model:
   
   `juju add-ssh-key <ssh-key>`

   OR

   `juju import-ssh-key <lp|gh>:<user identity>`
   
   For command line help and syntax run `juju help add-ssh-key` or
   `juju help import-ssh-key`.
   
   For in-depth coverage see page [Machine authentication][machine-auth].


^# Remove SSH access
   
   Use the `remove-ssh-key` command to remove SSH access to all machines,
   present and future, from a model:
   
   `juju remove-ssh-key <ssh-key-id> ...`
   
   For command line help and syntax run `juju help remove-ssh-key`.


^# Set constraints for a model

   Charm constraints can be managed at the model level. This will affect all
   charms used in the model unless overridden. Constraints are used to select
   minimum requirements for any future machines Juju may create.

   This subject is covered on page 
   [Setting constraints for a model][charms-constraints-models].


^# Upgrade a model
   
   Juju software is upgraded at the model level with the `upgrade-model`
   command. This affects the Juju agents running on every machine Juju creates.
   This upgrade process does not pertain to the Juju software package installed
   on a client system.

   See [Upgrading models][models-upgrade] for complete coverage.


^# View logs
   
   Use the `debug-log` command to examine logs on a per-model basis. This
   allows inspection of activities occurring on multiple Juju machines
   simultaneously. Due to the expected large volume of data, advanced filtering
   is available.

   A full explanation is provided on the [Juju logs][juju-logs] page.


^# View model status
   
   Use the `status` command to view the status of a model:

   `juju status [options] [filter pattern ...]`
   
   For command line help and syntax run `juju help status`.


<!-- LINKS -->

[controllers]: ./controllers.md
[models-cmr]: ./models-cmr.md
[models-adding]: ./models-adding.md
[models-config]: ./models-config.md
[models-migrate]: ./models-migrate.md
[models-upgrade]: ./models-upgrade.md
[charms-relations]: ./charms-relations.md
[charms-bundles-diff]: ./charms-bundles.md#comparing-a-bundle-to-a-model
[charms-constraints-models]: ./charms-constraints.md#setting-constraints-for-a-model
[juju-logs]: ./troubleshooting-logs.md
[multiuser]: ./multiuser.md
[juju-block]: ./juju-block.md
[machine-auth]: ./machine-auth.md
