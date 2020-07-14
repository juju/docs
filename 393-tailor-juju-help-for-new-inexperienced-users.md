The current output of `juju help` is below. It strikes me that this could be improved for users who are experimenting with Juju, but don't have a solid grasp of its fundamentals:

```plain
Usage: juju [help] <command>

Summary:
Juju is model & application management software designed to leverage the power
of existing resource pools, particularly cloud-based ones. It has built-in
support for cloud providers such as Amazon EC2, Google GCE, Microsoft
Azure, OpenStack, and Rackspace. It also works very well with MAAS and
LXD. Juju allows for easy installation and management of workloads on a
chosen resource pool.

See https://jujucharms.com/docs/stable/help for documentation.

Common commands:

    add-cloud           Adds a user-defined cloud to Juju.
    add-credential      Adds or replaces credentials for a cloud.
    add-model           Adds a hosted model.
    add-relation        Adds a relation between two applications.
    add-unit            Adds extra units of a deployed application.
    add-user            Adds a Juju user to a controller.
    bootstrap           Initializes a cloud environment.
    controllers         Lists all controllers.
    deploy              Deploys a new application.
    expose              Makes an application publicly available over the network.
    models              Lists models a user can access on a controller.
    status              Displays the current status of Juju, applications, and units.
    switch              Selects or identifies the current controller and model.

Example help commands:

    `juju help`          This help page
    `juju help commands` Lists all commands
    `juju help deploy`   Shows help for command 'deploy'
```

Here are some ideas:

- provide a series of commands for getting started locally
-  break "Common commands" into sections, such as getting started, inspecting state, deploying applications (in the layman sense of the word)
- describe Juju terminology very briefly: model, cloud, charm, bundle, relation, ...
- tweak the intro, adding "locally" and/or "bare metal" before MAAS/LXD in case someone doesn't know what those two things are

Will add a strawman for discussion if there is any support for the idea.
