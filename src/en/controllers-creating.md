Title: Creating a Juju Controller
TODO:  Improve examples
       Hardcoded: Ubuntu code names


# Creating a controller

Use the `juju bootstrap` command to create a controller (and model) for a given
cloud:

`juju bootstrap [options] <cloud name> [<controller name>]`

See `juju help bootstrap` for details on this command or see the
[Juju command reference][commands] page.

The `<controller name>` is optional. If one is not supplied, then a name is
assigned based on the cloud and region.

To learn about configuration options available at bootstrap time, see
[Configuring controllers][controlconfig] and [Configuring models][modelconfig].

## Model constraints

Model constraints are set during the creation of the controller and are used to
set minimum specifications for all machines in the models managed by the
controller. They are set via the `--constraints` option

For example, below, all machines in the LXD controller's models will have at
least 4GiB of memory:

```bash
juju bootstrap --constraints="mem=4G" localhost
```

For more details on constraints, see [Constraints][constraints].

## Controller constraints

Constraints can also affect solely the controller by using the
`--bootstrap-constraints` option. The eligible values are identical to those
available as model constraints (explained above).

This example shows how to request at least 4GiB of memory for a LXD controller:

```bash
juju bootstrap --bootstrap-constraints="mem=4G" localhost
```

## Other examples

### Create a controller of a specific series

The controller will run the latest LTS Ubuntu release by default. At the time
of writing, Xenial will be selected.

For our example, we name the resulting LXD controller 'lxd-xenial' to reflect
that:

```bash
juju bootstrap localhost lxd-xenial
```

To select a different series the `--bootstrap-series` option is used.

Below, a google (GCE) controller based on Ubuntu 14.04 LTS (Trusty) is
requested (and is given the name 'gce-trusty'):

```bash
juju bootstrap --bootstrap-series=trusty google gce-trusty
```

### Create a Rackspace controller using a daily image

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

### Create a controller using a non-default region

The [Clouds][clouds] page details listing available clouds and how the list
denotes default regions for each. To specify a different region during
controller creation, use:

```bash
juju bootstrap aws/us-west-2 mycontroller
```

This is an instance where using the default controller name could be especially
handy, as omitting the `mycontroller` name will cause your new controller to be
named using the non-default region, specifically naming it `aws-us-west-2`:

```bash
juju bootstrap aws/us-west-2
```

### Create a controller using a different MongoDB profile

MongoDB has two memory profile settings available, 'default' and 'low'. The
first setting is the profile shipped by default with MongoDB. The second is a
more conservative memory profile that uses less memory. To select which one
your controller uses when it is created, use:

```bash
juju bootstrap --config mongo-memory-profile=low
```

### Change timeout and retry delays

You can change the default timeout and retry delays used by Juju by setting the
following keys in your configuration:

| Key                        | Default (seconds) | Purpose |
|:---------------------------|:------------------|:---------|
bootstrap-timeout            | 600    | How long to wait for a connection to the controller
bootstrap-retry-delay        | 5      | How long to wait between connection attempts to a controller
bootstrap-address-delay      | 10     | How often to refresh controller addresses from the API server
 
For example, to increase the timeout between the client and the controller
from 10 minutes to 15, enter the value in seconds:

```bash
juju bootstrap --config bootstrap-timeout=900 localhost lxd-faraway
```

### Changing the current model/controller

By default, when Juju bootstraps a new controller, it will also 'switch' to
that controller and the default model created with it. Any subsequent Juju
commands which do not specify a controller/model will be assumed to apply to
this model.

In some cases (e.g. when scripting Juju) this may not be desirable. It is
possible to add a `--no-switch` option to the bootstrap command to prevent the
new controller from being automatically selected. For example:

```bash
juju bootstrap --no-switch localhost lxd-new
```


<!-- LINKS -->

[clouds]: ./clouds.html
[constraints]: ./charms-constraints.html
[commands]: ./commands.html#juju-bootstrap
[controlconfig]: ./controllers-config.html "Configuring Juju controllers"
[modelconfig]: ./models-config.html "Configuring Juju models"
