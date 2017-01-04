Title: Juju actions

# Juju Actions

Juju charms can describe *actions* that users can take on deployed applications.

Actions are scripts that can be triggered on a unit via the command line.
Parameters for an action are passed as a map, either defined in a YAML file
or given through the UI, and are validated against the schema defined in
actions.yaml. See [Actions for the charm author](authors-charm-actions.html) for more information.

The following commands are specified for dealing with actions:

- `juju actions` - list actions defined for a service
- `juju list actions` - alias for `actions`
- `juju run-action` - queue an action for execution
- `juju show-action-output` - show output of an action by ID
- `juju show-action-status` - show status of all actions filtered by optional ID

## Action commands

### `juju actions`

List the actions defined for a service.

For example, with the 'git' charm deployed, you can see which actions it
supports with the following command:

```bash
juju actions git
```

You should see something similar to this:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju actions git -->
```no-highlight
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
To show the full schema for all the actions on a service, append the `--schema`
argument to the `actions` command. 

For example, here's the beginning of the output from `juju actions git
--schema --format yaml`:

```bash
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
...
```

!!! Note: that the full schema is under the `properties` key of the root Action.
Juju Actions rely on [JSON-Schema](http://json-schema.org) for validation.
The top-level keys shown for the Action (`description` and `properties`) may
include future additions to the feature.

### `juju run-action`

Trigger an action. This command takes the unit as an argument and returns an ID
for the action. The ID can be used with `juju show-action-output <ID>` or `juju
show-action-status <ID>.

If an action requires parameters, these can be passed directly. For example, we
could create a new 'git' repository by triggering the 'add-repo' action and
following this with the name we'd like to give the new repository:


```bash
juju run-action git/0 add-repo repo=myproject
```
This will return the ID for the new action:

```bash
Action queued with id: 3a7cc626-4c4c-4f00-820f-f881b79586d10
```

You can also set parameters indirectly via a YAML file, although you can
override the parameters within the file by providing them directly.

*Example params.yml:*
```yaml
repo: myproject
sure: no
```
With the above example `params.yaml` file, we could remove the `myproject` git repository
with the following command:

```bash
juju run-action git/0 remove-repo --params=params.yaml sure=yes
```

### `juju show-action-output`

Shows the results returned from an action with the given ID. To
see the output from the `add-repo` action we executed earlier, for example,
we'd enter the following:

```bash
juju show-action-output 3a7cc626-4c4c-4f00-820f-f881b79586d10
```
This will return something like the following:

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju show-action-output 4cb5c96d-77de-4870-8462-8e4de5b22852
-->
```no-highlight
results:
  dir: /var/git/myproject.git
status: completed
timing:
  completed: 2016-10-27 13:46:12 +0000 UTC
  enqueued: 2016-10-27 13:46:11 +0000 UTC
  started: 2016-10-27 13:46:11 +0000 UTC
```
### `juju show-action-status`

Query the status of an action. For example, We could check on the progress of git's
`add-repo` action with the following command:

```bash
juju show-action-status 3a7cc626-4c4c-4f00-820f-f881b79586d1
```
This will output the status of the action, shown here as 'completed':

<!-- JUJUVERSION: 2.0.0-genericlinux-amd64 -->
<!-- JUJUCOMMAND: juju show-action-status 4cb5c96d-77de-4870-8462-8e4de5b22852
-->
```no-highlight
actions:
- id: 3a7cc626-4c4c-4f00-820f-f881b79586d1
  status: completed
  unit: git/0
```

