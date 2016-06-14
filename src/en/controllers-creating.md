Title: Creating a Juju Controller
TODO: Review again soon (created: March 2016)


# Creating a controller

Use the `juju bootstrap` command to create a controller (and model) for a given
cloud:

`juju bootstrap [options] <controller name> <cloud name>`

See `juju help bootstrap` for details on this command or see the
[command reference page](./commands.html#juju-bootstrap).


## Notes

Bootstrap has many options. Some commonly used options are described here with
examples.

## Create an LXD Xenial controller

Because Xenial is the current LTS release, we do not have to mention it
specifically. For our example, we name the controller lxd-xenial and instruct
it to use the local lxd cloud.

```bash
juju bootstrap lxd-xenial lxd
```

## Create an LXD Trusty controller using more recent tools

The '--upload-tools' option is used to make agent software available that is
more recent than the default binary. This is done when some features may not
yet be compiled in to the agent for the Ubuntu release being installed. Note
that Juju will default to the latest LTS (see `distro-info --lts` command).


```bash
juju bootstrap --upload-tools --config default-series=trusty \
	lxd-trusty lxd
```

## Create a Rackspace controller

The example uses a previously defined configuration file called 
config-rackspace.yaml. Many clouds are available, see [Clouds](./clouds.html).

```bash
juju bootstrap \
	--upload-tools --config=~/config-rackspace.yaml \
	controller-rackspace rackspace
```

## Create a controller with constraints

This example provides 4G of RAM to the local lxd controller we create. For
more details about constraints, see [Constraints](./reference-constraints.html).

```bash
juju bootstrap --constraints="mem=4G" lxd-xenial lxd
```

## Create a controller using a non-default region

The [Clouds](./clouds.html) page details listing available clouds and
how the list denotes default regions for each. To specify a different
region during controller creation, use:

```bash
juju bootstrap mycontroller aws/us-west-2
```
