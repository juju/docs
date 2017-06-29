Title: Juju actions

# Juju Actions

Juju charms can describe *actions* that users can take on deployed applications.

Actions are scripts that can be triggered on a unit via the command line.
Parameters for an action are passed as a map, either defined in a YAML file
or given through the UI, and are validated against the schema defined in
actions.yaml. See [Actions for the charm author][charmactions] for more information.

The following commands are specified for dealing with actions:

- `juju actions` - list actions defined for a service
- `juju list-actions` - alias for `actions`
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

For example, here's the beginning of the output from 
`juju actions git --schema --format yaml`:

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

!!! Note: 
    the full schema is under the `properties` key of the root Action.  Juju
    Actions rely on [JSON-Schema][jsonschema] for validation.  The
    top-level keys shown for the Action (`description` and `properties`) may
    include future additions to the feature.

### `juju run-action`

Trigger an action. This command takes the unit as an argument and returns an ID
for the action. The ID can be used with `juju show-action-output <ID>` or 
`juju show-action-status <ID>`.

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

When running short-lived actions from the command line, it is more convenient to
add the `--wait` option to this command. This causes the Juju client to wait for
the action to run, and then return the results and other information in YAML
format.

For example, running the command:

```bash
juju run-action git/0 list-repo --wait
```

Will return something like:

```bash
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

This avoids having to run a separate command to see the results of the action 
(although you can still run `show-action-output` using the action-id that 
was returned). 

For actions which may take longer to return, it is also possible to specify a 
'timeout' value, expressed in hours(h), minutes(m), seconds(s), milliseconds(ms)
or nanoseconds(ns). In this case, if the action has completed before the 
specified period is up, it will return the results as before. If the action has
not completed, the command will simply return the id and status, enabling the
user to continue issuing commands. E.g.:

```bash
juju run-action git/0 list-repo --wait=10ns
```
Ten nanoseconds isn't much time to get anything done, so in this case the output
will be similar to:

```bash
action-id: 10fb05d9-d220-4a07-825e-a1258b1a868b
status: pending
timing:
  enqueued: 2017-06-18 11:27:15 +0000 UTC
```

You can also set parameters indirectly via a YAML file, although you can
override the parameters within the file by providing them directly.

*Example params.yml:*
```yaml
repo: myproject
sure: no
```
With the above example `params.yaml` file, we could remove the `myproject` git
repository with the following command:

```bash
juju run-action git/0 remove-repo --wait --params=params.yaml sure=yes
```

If you have an action that requires multiple lines, use YAML quoting to make
sure the whitespace is not collapsed into one line, like in this example where
`foo` is an action and the parameter `bar` is defined in the `actions.yaml` file
shown just after the example:

```bash
juju run-action unit/0 foo bar="'firstline
secondline
thirdline
fourthline'"
```

YAML quoting uses both single ' and double " quotes to surround the part that
should not be moved to one line.

*Example actions.yaml:*
```yaml
#!/usr/bin/python3

from subprocess import call
import sys
with open("/tmp/out", mode='w') as out:
  call(['action-get','bar'],stdout=out)
sys.exit(0)
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
  completed: 2018-06-18 13:46:12 +0000 UTC
  enqueued: 2018-06-18 13:46:11 +0000 UTC
  started: 2018-06-18 13:46:11 +0000 UTC
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

There are 5 different values for the status of an action:

- **pending**; the default status when an action is first queued.
- **running**; the action is currently running.
- **completed**; the action ran to completion as intended.
- **failed**; the action did not complete successfully.
- **cancelled**; the action was cancelled before being run.

### Debugging actions

To debug actions, use the `debug-hooks` command, like this:
 
```bash
juju debug-hooks <service/unit> [action-name action-name2 ...]
```
 
For example, if you want to check the `add-repo` action of the `git` charm,
use:
 
```bash
juju debug-hooks git/0 add-repo
```
 
Learn more about debugging Juju charms in [Debugging hooks][devdebug].

<!-- LINKS -->

[charmactions]: ./authors-charm-actions.html
[jsonschema]: http://json-schema.org
[devdebug]: ./developer-debugging.html
