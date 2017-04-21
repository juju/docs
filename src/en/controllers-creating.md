Title: Creating a Juju Controller
TODO: Add better examples


# Creating a controller

Use the `juju bootstrap` command to create a controller (and model) for a given
cloud:

`juju bootstrap [options] <cloud name> <controller name>`

See `juju help bootstrap` for details on this command or see the
[command reference page](./commands.html#juju-bootstrap).

The `<controller name>` is optional. If one is not supplied, then a name is
assigned based on the cloud and region.

```bash
juju bootstrap aws/us-east-1
```

This creates a new controller called `aws-us-east-1` in that cloud and region.

Bootstrap has many options. Some of the more commonly used ones are detailed
here. 

## Create an LXD Xenial controller

Because Xenial is the current LTS release, we do not have to mention it
specifically. For our example, we name the controller lxd-xenial and instruct
it to use the local lxd cloud.

```bash
juju bootstrap lxd lxd-xenial
```

## Create an LXD Trusty controller 


The '--bootstrap-series' option allows you to specify a particular series 
to use for the controller

```bash
juju bootstrap --bootstrap-series=trusty lxd lxd-trusty
```

## Create a Rackspace controller using a daily image

The example uses a previously defined configuration file called 
config-rackspace.yaml. 

Note that values passed using '--config' will take precedence
over values included in a file. This is important if you use both a config
file and state one or more config values while bootstrapping.

```bash
juju bootstrap \
	--config=~/config-rackspace.yaml   \
	--config image-stream=daily        \
	rackspace controller-rackspace
```

## Create a controller with constraints

This example provides 4G of RAM to the local lxd controller we create. For
more details about constraints, see [Constraints](./reference-constraints.html).

```bash
juju bootstrap --constraints="mem=4G" lxd lxd-xenial
```

If you omit the optional controller name here, the new controller will be
named using the name of the cloud, `lxd`:

```bash
juju bootstrap --constraints="mem=4G" lxd
```

## Create a controller using a non-default region

The [Clouds](./clouds.html) page details listing available clouds and
how the list denotes default regions for each. To specify a different
region during controller creation, use:

```bash
juju bootstrap aws/us-west-2 mycontroller
```

This is an instance where using the default controller name could be especially
handy, as omitting the `mycontroller` name will cause your new controller to
be named using the non-default region, specifically naming it `aws-us-west-2`:

```bash
juju bootstrap aws/us-west-2
```

## Create a controller using a different MongoDB profile

MongoDB has two memory profile settings available, `default` and `low`. The
first setting is the profile shipped by default with MongoDB. The second is a
more conservative memory profile that uses less memory. To select which one
your controller uses when it is created, use:

```bash
juju bootstrap --config mongo-memory-profile=low
```

## Change timeout and retry delays

You can change the default timeout and retry delays used by Juju 
by setting the following keys in your configuration:

| Key                        | Default (seconds) | Purpose |
|:---------------------------|:------------------|:---------|
bootstrap-timeout            | 600    | How long to wait for a connection to the controller
bootstrap-retry-delay        | 5      | How long to wait between connection attempts to a controller
bootstrap-address-delay      | 10     | How often to refresh controller addresses from the API server
 
For example, to increase the timeout between the client and the controller
from 10 minutes to 15, enter the value in seconds:

```bash
juju bootstrap --config bootstrap-timeout=900 lxd lxd-faraway
```

To learn more about configuration options available at bootstrap time, see
[Configuring controllers][controlconfig].

[controlconfig]: ./controllers-config.html "Configuring Juju controllers"
