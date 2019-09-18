A model is upgraded by upgrading the version of Juju running within it, in the form of machine agents and unit agents. Agents are pieces of software that run on each machine spawned by Juju, including controllers. See the [Concepts](/t/concepts-and-terms/1144#agent) page for more information on agents.

A model upgrade is performed with the `upgrade-model` command and acts on all machine and unit agents running on all machines in the model.

Notes:

- Upgrades must be applied to the 'controller' model before upgrading other models. An error will be emitted if this is not done.
- By default, the latest stable version will be selected.
- Juju machines request the new agent software from the controller. If the latter's cache cannot satisfy the request the controller will attempt a download from the internet.
- A controller admin can upgrade any model within that controller.
- A model owner can upgrade that model.

See [Notes on upgrading Juju software](/t/notes-on-upgrading-juju-software/1153) for upgrading details, including what to do when the controller lacks internet access.

In `v.2.6.0` the `upgrade-controller` command can target a controller by name, as opposed to using the controller model name (of 'controller') with `upgrade-model`.

<a name="preparing-for-the-upgrade"></a>
## Preparing for the upgrade

This is a lit of some pre-upgrade tasks that should be considered:

-   Perform a backup (see [Controller backups](/t/controller-backups/1106)).
-   Ensure the models that are to be upgraded are in good working order by applying the `status` command to them.
-   See what version is currently running with `juju model-config agent-version` or `juju status`.

<a name="performing-the-upgrade"></a>
## Performing the upgrade

This section contains examples on upgrading a model.

To upgrade the 'controller' model for the 'aws' controller with the latest stable version:

``` text
juju upgrade-model -m aws:controller
```

To upgrade the current model by specifying the version:

``` text
juju upgrade-model --agent-version 2.4.1
```

To upgrade the current model by specifying the agent stream:

``` text
juju upgrade-model --agent-stream proposed
```

<a name="verifying-the-upgrade"></a>
## Verifying the upgrade

The verification of a successful upgrade is obtained by the `status` command. Here we check whether a 'controller' model was properly upgraded:

``` text
juju status -m aws:controller
```

If this command does not complete properly or if there are errors displayed in its output then proceed to the next section.

<a name="troubleshooting-the-upgrade"></a>
## Troubleshooting the upgrade

A model upgrade that does not lead to 100% success will require attention. See [Troubleshooting model upgrades](/t/troubleshooting-model-upgrades/1186).

<!-- LINKS -->
