Title: Creating a Juju Controller
TODO: Review again soon (created: March 2016)


# Creating a controller

Use the `juju bootstrap` command to create a controller (and model) for a given
cloud provider:

`juju bootstrap <controller name> <provider name> [--options]`

See `juju help bootstrap` for details on this command or see the
[command reference page](./commands.html#juju-bootstrap).


## Examples

**1.** The controller is for Rackspace. We call the controller 'controller-rackspace'
and use `--upload-tools` to make the agent software available to our default
series (specified in the provider's configuration):

```bash
juju bootstrap \
	controller-rackspace rackspace \
	--debug --upload-tools --config=~/config-rackspace.yaml
```
