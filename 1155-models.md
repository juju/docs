A *model* is a workspace. Models wrap your infrastructure and allow you to think of every infrastructure component as a single entity.  Applications, storage volumes, network spaces and other components managed by Juju are housed within models.

All Juju models are managed by a Juju controller. This enables clients to have a single point of contact with the system and allows commands to be executed independently from the workloads. 

### What is application modelling?

Juju provides simplicity, stability and security. Models reduce the cognitive gap between the whiteboard picture of your service and how it is implemented. An application model is a definition of which applications are providing a service and how they inter-relate.

Technical details such as CPU core counts, disk write throughput, and IP addresses are secondary. They are accessible to administrators, but an application model places the applications at the front.

### What models offer

The primary function of a model is to enable you to maintain an uncluttered view of your service. Operational simplicity improves communication and understanding. Models provide an abstract view of the infrastructure that's hosting your service. 

Juju models enforce service isolation. A model maintains exclusive access of the resources under its control.

Models provide access control. Juju enables you to create user accounts that have limited ability to alter the deployment. 

Models provide repeatable infrastructure deployments. Once your model is in-place and functional, it becomes simple to export a model's definition as a bundle, then re-deploy that model in another host. 

Models respect bureaucratic boundaries. Models enable you to partition compute resources according to your internal guidelines. You may wish to keep a central set of databases in the same model. Juju's access controls are model-specific, enabling you to know exactly who has permissions to peform direct database admininstration. Those databases could be made available to various consuming applications from other models via relations (which can span models). Other use cases for central models include secrets (using the [vault charm](https://jaas.ai/vault/)) and identity management (using the [keystone charm](https://jaas.ai/keystone)).


<!--
A *model* is an environment associated with a [controller](/t/controllers/1111). When a controller is created two models are provisioned along with it. These initial models are named 'controller' and 'default'. The 'controller' model is for internal Juju management and is not intended for general workloads. The 'default' model, however, is ready for immediate use. Further workload models can be added at any time.
-->

<!--
In `v.2.6.?`, a user-added model can be hosted by a cloud that is different than the one that hosts the two default models ('controller' and 'default'). A controller thus has the possibility of being "multi-cloud".
-->

<!--
In `v.2.6.4`, a model can be referred to by its UUID in many commands. This is primarily for troubleshooting purposes as logs expose UUIDs and not names.
-->

## Model management tasks

Common model management tasks are summarised below. The most important ones are [Adding a model](/t/adding-a-model/1147) and [Configuring models](/t/configuring-models/1151).

### Add a model

Models can be added easily to a controller. The [Adding a model](/t/adding-a-model/1147) page provides a full explanation and includes examples.

```plain
juju add-model <model-name> [[<cloud>/]<region>]
```

### Change models

Use the `switch` command to change from one model to another. Running the command with no arguments will return the currently active controller and model.

```plain
juju switch <controller>[:<model>]
```


[Details="Examples for juju switch"]
Here are different ways to change to a model:

`juju switch foo`  
   Selects the last used model in controller 'foo' (if the latter exists), otherwise model 'foo' in the current controller.

`juju switch :foo`  
   Selects model 'foo' in the current controller.

`juju switch foo:bar`  
   Selects model 'bar' in controller 'foo'.

`juju switch foo:`  
   Selects the last used model in controller 'foo'.
[/details]

### Compare a bundle to a model

A Juju administrator can compare a model with a charm bundle. This is useful for determining what has changed since the bundle was deployed or just how a model differs from a bundle that was not yet used. This topic is covered on the [Charm bundles](/t/charm-bundles/1058#heading--comparing-a-bundle-to-a-model) page.

```plain
juju diff-bundle <bundle>
```

### Configure a model

Configuration can occur at the model level. This will affect all Juju machines in the model. For instance, a logging level and API port can be stipulated. See the [Configuring models](/t/configuring-models/1151) page for explanations.

### Destroy a model

When a model is destroyed all associated applications and machines are also destroyed. It is a very destructive process. See page [Removing things](/t/removing-things/1063#heading--destroying-models) for details.

```plain
juju destroy-model <model>
```

### Disable commands

It is possible to curtail command use for Juju users on a per-model basis. The [Disabling commands](/t/disabling-commands/1141) page gives more information.

### Examine a model

Use the `show-model` command to examine a specific model.

```plain
juju show-model <model>
````

### List all models

Use the `models` command to list all models for a controller.

```plain
juju models
```

### Manage user access

If you're using multiple Juju users you will need to manage access to your models. See page [Working with multiple users](/t/working-with-multiple-users/1156) for a full explanation.

### Migrate models

Model can be migrated from one controller to another. Model migration is useful when upgrading a controller and for load balancing. For a complete explanation see the [Migrating models](/t/migrating-models/1152) page.


### Enable secure shell (SSH) access

SSH access can be provided to all machines, present and future, on a per-model basis. For in-depth coverage see page [Machine authentication](/t/machine-authentication/1146).


### Set constraints for a model

Charm constraints can be managed at the model level. This will affect all charms used in the model unless overridden. Constraints are used to select minimum requirements for any future machines Juju may create. This subject is covered on page [Setting constraints for a model](/t/using-constraints/1060#heading--setting-and-displaying-constraints-for-a-model).

### Upgrade a model

Juju software is upgraded at the model level with the `upgrade-model` command. This affects the Juju agents running on every machine Juju creates. This does not pertain to the Juju software package installed on a client system. See [Upgrading models](/t/upgrading-models/1154) for complete coverage.

### View logs

Use the `debug-log` command to examine logs on a per-model basis. This allows inspection of activities occurring on multiple Juju machines simultaneously. Due to the expected large volume of data, advanced filtering is available. A full explanation is provided on the [Juju logs](/t/juju-logs/1184) page.


### View model status

Use the `status` command to view the status of a model. Tutorial [Basic client usage](/t/basic-client-usage-tutorial/1191#heading--viewing-the-model-status) gives an overview of the various elements of this command's output.

```plain
juju status [--storage] [--relations]
```

## Related concepts


### Cross model relations

Traditionally, when adding a relation between two applications (see [Managing relations](/t/managing-relations/1073)) the applications reside within the same model and controller. It is possible to overcome this limitation by employing *cross model relations*. This topic is covered on the [Cross model relations](/t/cross-model-relations/1150) page.
