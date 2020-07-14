*Actions* are scripts that are manually triggered via the client, and carried out on the unit.

Actions are useful whenever a repeatable task should be available to every deployment of an application. Some examples:

- the [`keystone` charm](https://jaas.ai/keystone) provides the  `security-checklist` action to validate that configuration parameters meet security requirements
- the [`postgresql` charm](https://jaas.ai/postgresql) provides actions to initiate and pause database replication  
- deployments of the [`rabbitmq-server` charm](https://jaas.ai/rabbitmq-server) can get a list of long queues via the `check-queues` action (long queues are a symptom of an unhealthy system)

Charms define actions within a YAML file at the root of the charm directory: `actions.yaml`. That file describes parameters that each action can take. See the related page [Actions for the charm author](/t/actions-for-the-charm-author/1113) for detailed information.

## Finding actions supported by each charm

Inspecting a charm to identify the actions it supports is a quick process. 

* **If you are looking at a charm in the charm store**, then start with a quick scan of the files within the `actions/` directory of the charm's "Files" listing on the right-hand side of the page. Each file is an action and this scan provides a broad view of the actions the charm supports. <br><br> To view more details, inspect the `actions.yaml` file within the charm's root directory. That will provide the parameters that can be supplied to each charm and a description. <br><br> You may also view the source code of each action by looking into the files provided in the `actions/` directory. 

* **If you have deployed a charm**, then use the `juju actions` command. See the next section for details about this command. 

* **If you have a local charm**, then view the source code within the charm's `actions/` directory.

## Terminology involved with actions

-  An _action_ is executable code that can be run within Juju units. When run, actions become _operations_.
- An _operation_ is a specific instance of running an action. Operations are themselves composed into tasks, 1 per unit. An operation represents all tasks created by running an action.
- A _task_ represents the action's effect on a single unit

## Relationship between actions and `juju exec`

[note status="Earlier name"]
`juju exec` was known as `juju run` until Juju 2.8.0.
[/note]

Actions are pre-defined by charm authors. To add a new action to an application, a new charm version must be deployed. `juju exec` behaviour is defined by the person executing the command(s).

Actions provide some advantages over running commands manually via `juju exec`. If you find yourself repeatedly executing a particular command, consider adding it to the charm as an action.

Advantages of actions:

- Actions are easier to run over multiple units
- Juju will store output from any underlying commands 
- Actions provide status output as structured, machine-readable data

<h2 id="heading--action-commands">Action commands</h2>

[note]
Actions commands are moving through a transition. Add the `juju-v3` feature flag to the `JUJU_DEV_FEATURE_FLAGS` environment variable to enable the new behaviour. Without it, Juju will interpret the commands as per "Legacy Action commands"

Under Linux and macOS:
```
export JUJU_DEV_FEATURE_FLAGS=juju-v3
``` 

Under MS Windows:
```
set JUJU_DEV_FEATURE_FLAGS=juju-v3
```
[/note]

The following commands are used to manage actions:

- `actions` : list actions defined for a service
- `run` : queue an action for execution
- `operations`: list the results of past actions
- `show-operation`: show the output produced by an action
- `show-task`: show the output produced by an action within a specific unit 
- `abort`: halt an executing action

[note type=important status=TODO]
Add details about each command.
[/note]

## Legacy Action commands

[note]
These commands are relevant for Juju clients below 2.8.
[/note]


The following commands are used to manage actions:

- `actions` : list actions defined for a service
- `run-action` : queue an action for execution
- `show-action-output` : show output of an action by ID
- `show-action-status` : show status of all actions filtered by optional ID

<h3 id="heading--command-actions">Command 'actions'</h3>

Lists the actions defined for an application.

For example, with the 'git' charm deployed, you can see the actions it supports:

```text
juju actions git
```

Sample output:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju actions git -->
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

To show the full schema for all the actions on an application, append the `--schema` option.

For example:

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

[note]
The full schema is under the `properties` key of the root action. Actions rely on [JSON-Schema](http://json-schema.org) for validation. The top-level keys shown for the action (`description` and `properties`) may include future additions to the feature.
[/note]

<h3 id="heading--command-run-action">Command 'run-action'</h3>

Triggers an action.

This command takes a unit (or multiple units) as an argument and returns an ID for the action. The ID can be used with `juju show-action-output <ID>` or `juju show-action-status <ID>`.

If an action requires parameters, these can be passed directly. For example, we could create a new 'git' repository by triggering the 'add-repo' action and following this with the name we'd like to give the new repository:

```text
juju run-action git/0 add-repo repo=myproject
```

This will return the ID for the new action:

```text
Action queued with id: 3a7cc626-4c4c-4f00-820f-f881b79586d10
```

As mentioned, this command can be applied to more than one unit (of the same application). So if there were two git units you can also do:

```text
juju run-action git/0 git/1 add-repo repo=myproject
```

To run an action on an application leader append the string "/leader" to the application name:

```text
juju run-action postgresql/leader switchover --string-args master=postgresql/1
```

When running short-lived actions from the command line, it is more convenient to use the `--wait` option. This causes the client to wait for the action to run, and then return the results and other information in YAML format.

For example:

```text
juju run-action git/0 list-repos --wait
```

Sample output:

```text
action-id: 09563275-87bc-4224-81ef-8282ad7e9d63
results:
  docs1: /var/git/docs1.git
  myproject: /var/git/myproject.git
status: completed
timing:
  completed: 2017-06-18 11:20:10 +0000 UTC
  enqueued: 2017-06-18 11:20:07 +0000 UTC
  started: 2017-06-18 11:20:10 +0000 UTC
```

This avoids having to run a separate command to see the results of the action (although you can still run `show-action-output` using the action-id that was returned).

For actions which may take longer to return, it is possible to specify a 'timeout' value, expressed in hours(h), minutes(m), seconds(s), milliseconds(ms) or nanoseconds(ns). If the action has completed before the specified period is up, it will return the results as before. If the action has not completed, the command will simply return the ID and status, enabling the user to continue issuing commands. For instance:

```text
juju run-action git/0 list-repos --wait=10ns
```

Ten nanoseconds isn't much time to get anything done, so in this case the output will be similar to:

```text
action-id: 10fb05d9-d220-4a07-825e-a1258b1a868b
status: pending
timing:
  enqueued: 2017-06-18 11:27:15 +0000 UTC
```

You can also set parameters indirectly via a YAML file, although you can override those parameters by providing them directly. Consider the contents of a file `params.yaml`:

```yaml
repo: myproject
sure: no
```

We could then remove the 'myproject' git repository in this way:

```text
juju run-action git/0 remove-repo --wait --params=params.yaml sure=yes
```

If you have an action that requires multiple lines, use YAML quoting. In the below example, 'foo' is an action and 'bar' is a parameter defined in file `actions.yaml` (shown right after):

```text
juju run-action unit/0 foo bar="'firstline
secondline
thirdline
fourthline'"
```

YAML quoting uses both single ' and double " quotes to surround the part that should not be moved to one line.

The contents of `actions.yaml`:

```text
#!/usr/bin/python3

from subprocess import call
import sys
with open("/tmp/out", mode='w') as out:
  call(['action-get','bar'],stdout=out)
sys.exit(0)
```

<h3 id="heading--command-show-action-output">Command 'show-action-output'</h3>

Shows the results returned from an action with the given ID.

To see the output from the `add-repo` action we executed earlier, we'd enter the following:

```text
juju show-action-output 3a7cc626-4c4c-4f00-820f-f881b79586d10
```

Sample output:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju show-action-output 4cb5c96d-77de-4870-8462-8e4de5b22852 -->
```text
results:
  dir: /var/git/myproject.git
status: completed
timing:
  completed: 2018-06-18 13:46:12 +0000 UTC
  enqueued: 2018-06-18 13:46:11 +0000 UTC
  started: 2018-06-18 13:46:11 +0000 UTC
```

<h3 id="heading--command-show-action-status">Command 'show-action-status'</h3>

Queries the status of an action.

We could check on the progress of git's `add-repo` action in this way:

```text
juju show-action-status 3a7cc626-4c4c-4f00-820f-f881b79586d1
```

This will output the status of the action, shown here as 'completed':

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju show-action-status 4cb5c96d-77de-4870-8462-8e4de5b22852 -->
``` text
actions:
- id: 3a7cc626-4c4c-4f00-820f-f881b79586d1
  status: completed
  unit: git/0
```

There are five possible values for the status of an action:

- `pending` : the default status when an action is first queued.
- `running` : the action is currently running.
- `completed` : the action ran to completion as intended.
- `failed` : the action did not complete successfully.
- `cancelled` : the action was cancelled before being run.

<h2 id="heading--debugging-actions">Debugging actions</h2>

To debug actions, use the `debug-hooks` command, like this:

```text
juju debug-hooks <unit> [action-name action-name2 ...]
```

For example, if you want to check the `add-repo` action of the 'git' charm, use:

```text
juju debug-hooks git/0 add-repo
```

Learn more about debugging charms on the [Debugging hooks](/t/debugging-charm-hooks/1116) page.
