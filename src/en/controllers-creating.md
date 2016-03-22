Title: Creating a Juju Controller
TODO: Review again soon (created: March 2016)


# Creating a controller

Use the `juju bootstrap` command to create a controller (and model) for a given
cloud:

`juju bootstrap [options] <controller name> <cloud name>`

See `juju help bootstrap` for details on this command or see the
[command reference page](./commands.html#juju-bootstrap).


## Notes

The '--upload-tools' option is used to make agent software available that is
more recent than the default binary. This is done when some features may not
yet be compiled in to the agent for the Ubuntu release being installed. Note
that Juju will default to the latest LTS (see `distro-info --lts` command).


## Examples

**1.** Create Rackspace controller 'controller-rackspace':

```bash
juju bootstrap \
	--upload-tools --config=~/config-rackspace.yaml \
	controller-rackspace rackspace
`

**2.** Create LXD controller 'lxd-trusty':

```bash
juju bootstrap  --upload-tools lxd-trusty lxd
```
