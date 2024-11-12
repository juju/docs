(how-to-manage-actions)=
# How to manage actions

<!--
SOURCE: https://discourse.charmhub.io/t/juju-actions-opt-in-to-new-behaviour-from-juju-2-8/2255
TODO: Add more example outputs. (The doc above has many but they're from 2020, so they might not be the latest. And I don't quite get the first bit about the custom-defined action -- how does it get attached to the charm?
-->

> See also: {ref}`Action <action>`

This document demonstrates how to manage actions.

<!--
```{note}

This doc reflects the state of affairs n `juju v.3.0`, with the following breaking changes:

- `juju run` has become `juju exec`<br>
- `juju run-action` has become `juju run`<br>
 

```
-->
**Contents:**
- [List all actions](#heading--list-all-actions)
- [Show details about an action](#heading--show-details-about-an-action)
- [Run an action](#heading--run-an-action)
- [Manage action tasks](#heading--manage-action-tasks)
- [Manage action operations](#heading--manage-action-operations)
- [Debug an action](#heading--debug-an-action)



<a href="#heading--list-all-actions"><h2 id="heading--list-all-actions">List all actions</h2></a>

[tabs]
[tab version="juju"]

To list the actions defined for a deployed application, use the `actions` command followed by the deployed charm's name. For example, assuming you've already deployed the `git` charm, you can find out the actions it supports as below:

```text
juju actions git
```

This should output:

```text
Action            Description
add-repo          Create a git repository.
add-repo-user     Give a user permissions to access a repository.
add-user          Create a new user.
get-repo          Return the repository's path.
list-repo-users   List all users who have access to a repository.
list-repos        List existing git repositories.
list-user-repos   List all the repositories a user has access to.
list-users        List all users.
remove-repo       Remove a git repository.
remove-repo-user  Revoke a user's permissions to access a repository.
remove-user       Remove a user.
```

By passing various options, you can also do a number of other things such as specify a model or an output format or request the full schema for all the actions of an application. Below we demonstrate the `--schema` and `--format` options:

```text
juju actions git --schema --format yaml
```

Partial output:

```text
add-repo:
  additionalProperties: false
  description: Create a git repository.
  properties:
    repo:
      description: Name of the git repository.
      type: string
  required:
  - repo
  title: add-repo
  type: object
```

```{note}

The full schema is under the `properties` key of the root action. Actions rely on [JSON-Schema](http://json-schema.org) for validation. The top-level keys shown for the action (`description` and `properties`) may include future additions to the feature.

```

> See more: {ref}``juju actions` <command-juju-actions>`

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
To list the actions defined for a deployed application, use the `get_actions()` method on the `Application` object to get all the actions defined for this application.

```python
await my_app.get_actions()
```

> See more: [`Application (object)`](https://pythonlibjuju.readthedocs.io/en/latest/narrative/application.html), [`get_actions (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_actions)

{ref}`/tab]
[/tabs]


<a href="#heading--show-details-about-an-action"><h2 id="heading--show-details-about-an-action">Show details about an action</h2></a>

[tabs]
[tab version="juju"]

To see detailed information about an application action, use the `show-action` command followed by the name of the charm and the name of the action. For example, the code below will show detailed information about the `backup` action of the `postgresql` application.

```text
juju show-action postgresql backup
```

<!--add sample output-->

> See more: [`juju show-action` <command-juju-show-action>`

{ref}`/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--run-an-action"><h2 id="heading--run-an-action">Run an action</h2></a>

```{important}

**Did you know?** When you run an action, how the action is run depends on the type of the charm. If your charm is a machine charm, actions are executed on the same machine as the application. If your charm is a Kubernetes charm implementing the sidecar pattern, the action is run in the charm container.

```

[tabs]
[tab version="juju"]

To run an action on a unit, use the `run` command followed by the name of the unit and the name of the action you want to run. 

```text
juju run mysql/3 backup
```

<!--add sample output-->

By using various options, you can choose to run the action in the background, specify a timeout time, pass a list of actions in the form of a YAML file, etc. See the command reference doc for more.

Running an action returns the overall operation ID as well as the individual task ID(s) for each unit.

<!--
```{important}

Starting with `juju v.3.0`,  actions are composed of **tasks** and **operations** , where an action defines a named unit of work (e.g., back up the database) that can be executed on selected units, a task is the execution of the action on each target unit, and an operation is the group of tasks queued by running an action across one or more units.

```

-->

> See more: [`juju run` <command-juju-run>` (before `juju v.3.0`, `run-action`)

[/tab]
[tab version="terraform juju"]

[/tab]
[tab version="python libjuju"]
To run an action on a unit, use the `run_action()` method on a Unit object of a deployed application.

Note that "running" an action on a unit, enqueues an action to be performed. The result will be an Action object to interact with. You will need to call `action.wait()` on that object to wait for the action to complete and retrieve the results.

```python
# Assume we deployed a git application
my_app = await model.deploy('git', application_name='git', channel='stable')
my_unit = my_app.units[0]

action = await my_unit.run_action('add-repo', repo='myrepo')
await action.wait() # will return the result for the action
```
> See more: [`Unit (object)`](https://pythonlibjuju.readthedocs.io/en/latest/narrative/unit.html), [`Action (object)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.action.html#juju.action.Action), [`Unit.run_action (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.unit.html#juju.unit.Unit.run_action), [`Action.wait() (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.action.html#juju.action.Action.wait)

{ref}`/tab]
[/tabs]

<a href="#heading--manage-action-tasks"><h2 id="heading--manage-action-tasks">Manage action tasks</h2></a>
> See also: [Task <task>`

- [Show details about a task](#heading--show-details-about-a-task)
- [Cancel a task](#heading--cancel-a-task)

<a href="#heading--show-details-about-a-task"><h3 id="heading--show-details-about-a-task">Show details about a task</h3></a>

{ref}`tabs]
[tab version="juju"]

To drill down to the result of running an action on a specific unit (the stdout, stderror, log messages, etc.), use the `show-task` command followed by the task ID (returned by the `run` command). For example,

```text
juju show-task 1
```

> See more: [`juju show-task` <command-juju-show-task>`

{ref}`/tab]
[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--cancel-a-task"><h3 id="heading--cancel-a-task">Cancel a task</h3></a>

[tabs]
[tab version="juju"]

Suppose you've run an action but would now like to cancel the resulting pending or running task. You can do so using the `cancel-task` command. For example:

```text
juju cancel-task 1
```

> See more: [`juju cancel-task` <command-juju-cancel-task>`

{ref}`/tab]
[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--manage-action-operations"><h2 id="heading--manage-action-operations">Manage action operations</h2></a>
> See also: [Operation <operation>`

- [View the pending, running, or completed operations](#heading--view-the-pending-running-or-completed-operations)
- [Show details about an operation](#heading--show-details-about-an-operation)

<a href="#heading--view-the-pending-running-or-completed-operations"><h3 id="heading--view-the-pending-running-or-completed-operations">View the pending, running, or completed operations</h3></a>

{ref}`tabs]
[tab version="juju"]

To view the pending, running, or completed status of each `juju run ... <action>` invocation, run the `operations` command:

```text
juju operations
```

This will show the operations corresponding to the actions for all the application units. You can filter this by passing various options (e.g., `--actions backup`, `--units mysql/0`, `--machines 0,1`, `--status pending,completed`, etc.).

> See more: [`juju operations` <command-juju-operations>`

{ref}`/tab]
[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--show-details-about-an-operation"><h3 id="heading--show-details-about-an-operation">Show details about an operation</h3></a>

[tabs]
[tab version="juju"]

To see the status of the individual tasks belonging to a given operation,  run the `show-operation` command followed by the operation ID.

```text
juju show-operation 1
```

As usual, by adding various options, you can specify an output format, choose to watch indefinitely or specify a timeout time, etc.

> See more: [`juju show-operation` <command-juju-show-operation>`

{ref}`/tab]
[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--debug-an-action"><h2 id="heading--debug-an-action">Debug an action</h2></a>

[tabs]
[tab version="juju"]

To debug an action (or more), use the `debug-hooks` command followed by the name of the unit and the name(s) of the action(s). For example, if you want to check the `add-repo` action of the `git` charm, use:

```text
juju debug-hooks git/0 add-repo
```

> See more: [`juju debug-code` <command-juju-debug-code>`, {ref}``juju debug-hooks` <command-juju-debug-hooks>`, [Charm SDK | How to debug a charm](https://juju.is/docs/sdk/debug-a-charm)

[/tab]
[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]
[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @pedroleaoc, @pmatulis, @tmihoc, @wallyworld</small>