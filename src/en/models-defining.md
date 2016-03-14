Title: Defining a Juju Model
TODO: Review again soon (created: March 2016)
      Remove bug citation (1552469) when fixed and remove --config option from example command


# Defining a model

Use the `juju create-model` command to create a *hosted model* for a given
cloud provider:

`juju create-model [--options] <name> [key=[value] ...]`

See `juju help create-model` for details on this command or see the
[command reference page](./commands.html#juju-create-model).


## Examples

**1.** Create a model for the current controller. We call the model
'rackspace-prod':

!!! Note: Due to
[LP #1552469](https://bugs.launchpad.net/juju-core/+bug/1552469) credentials
already set during the creation of the controller model are not utilised
automatically. You will need to create a 3-line file for these parameters:
`username`, `password`, and `tenant-name` and then refer to it.

```bash
juju create-model --config=~/config-rackspace_creds.yaml rackspace-prod
```
