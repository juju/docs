# Juju Actions

Juju Charms can describe Actions that users can take on deployed services.

Actions are scripts that can be triggered on a unit via the CLI or the
[Juju web UI](howto-gui-management.html). Parameters for an action are passed as
a map, either defined in a YAML file or given through the UI, and are validated
against the schema defined in actions.yaml. See
[Actions for the charm author](authors-charm-actions.html) for more information.

Actions are sub-commands of the `juju action` command. To get more on their
usage, use `juju help action`.

The following subcommands are specified:

```no-highlight
defined - show actions defined for a service
do      - queue an action for execution
fetch   - show results of an action by ID
status  - show results of all actions filtered by optional ID prefix
```

## Action commands 

### `juju action defined`

List the actions defined on a service.

 > Example
```bash
juju action defined git
```

Output:

```no-highlight
add-repo: Create a git repository.
add-repo-user: Give a user permissions to access a repository.
add-user: Create a new user.
get-repo: Return the repository's path.
list-repo-users: List all users who have access to a repository.
list-repos: List existing git repositories.
list-user-repos: List all the repositories a user has access to.
list-users: List all users.
remove-repo: Remove a git repository.
remove-repo-user: Revoke a user's permissions to access a repository.
remove-user: Remove a user.
```

To show the full schema for all the actions on a service, append the `--schema`
argument to the above command. For example, here's the beginning of the output
when this is done:

 > Example
```bash
juju action defined git --schema
```

Output:

```yaml
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

> Note that the full schema is under the `properties` key of the root Action.
> Juju Actions rely on [JSON-Schema](http://json-schema.org) for validation.
> The top-level keys shown for the Action (`description` and `properties`) may
> include future additions to the feature.

### `juju action do`

Trigger an action (the ID of the action will be displayed, for use with `juju
action fetch <ID>` or `juju action status <ID>`; see below):

```bash
juju action do git/0 list-users
```

This will return the ID for the new action:

```no-highlight
Action queued with id: cf0ec3d5-ce5b-4256-87c3-e5b05a0df724
```

Parameters can be passed directly:

```bash
juju action do git/0 add-repo repo=myproject
```

This will return the ID for the new action:

```no-highlight
Action queued with id: 4f4fdc54-d8d9-4d0f-842a-b1dcc0c9eaca
```

You can also set parameters indirectly via a YAML file (those provided directly
take precedence):

 > Example params.yaml
```yaml
repo: myproject
sure: no
```

With the above example params.yaml file, we could remove the myproject git
repository with the following command:

```bash
juju action do git/0 remove-repo --params=params.yaml sure=yes
```

### `juju action fetch`

Fetch the results of an action identified by its ID:

```bash
juju action fetch 4f4fdc54-d8d9-4d0f-842a-b1dcc0c9eaca
```

Output:

```yaml
results:
  dir: /var/git/myproject.git
status: completed
timing:
  completed: 2017-08-22 18:37:14 +0000 UTC
  enqueued: 2017-08-22 18:37:12 +0000 UTC
  started: 2017-08-22 18:37:13 +0000 UTC
```

### `juju action status`

Query the status of an action identified by its ID:

```bash
juju action status 4f4fdc54-d8d9-4d0f-842a-b1dcc0c9eaca
```

Output:

```yaml
actions:
- id: 4f4fdc54-d8d9-4d0f-842a-b1dcc0c9eaca
  status: completed
  unit: git/0
```
