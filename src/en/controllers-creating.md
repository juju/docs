Title: Creating a Juju Controller
TODO:  Improve examples
       Hardcoded: Ubuntu code names
       Update default controller release (to "latest LTS") and remove Note once 18.04.1 released


# Creating a controller

Use the `juju bootstrap` command to create a controller (and 'default' model)
for a given cloud:

`juju bootstrap [options] <cloud name> [<controller name>]`

See `juju help bootstrap` for details on this command or see the
[Juju command reference][commands] page.

The `<controller name>` is optional. If one is not supplied, then a name is
assigned based on the cloud and region.

To learn about configuration options available at bootstrap time, see:

 - [Configuring controllers][controlconfig]
 - [Configuring models][modelconfig]
 - [Using constraints][charms-constraints]

## Examples

### Set default model constraints for a given controller

Below, all machines in the LXD controller's models will have at least 4GiB of
memory:

```bash
juju bootstrap --constraints mem=4G localhost
```

### Set controller constraints for a new controller

This example shows how to request at least 4GiB of memory and two CPUs for an
AWS controller:

```bash
juju bootstrap --bootstrap-constraints "mem=4G cores=2" aws
```

### Create a controller of a specific series

The controller will be deployed upon Ubuntu 16.04 LTS (Xenial) by default.
    
For our example, we name the resulting LXD controller 'lxd-xenial' to reflect
that:

```bash
juju bootstrap localhost lxd-xenial
```

To select a different series the `--bootstrap-series` option is used.

Below, a google (GCE) controller based on Ubuntu 18.04 LTS (Bionic) is
requested explicitly (and is given the name 'gce-bionic'):

```bash
juju bootstrap --bootstrap-series=bionic google gce-bionic
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

### Configuring/enabling a remote syslog server

Create an Azure controller and configure for log forwarding:

```bash
juju bootstrap azure --config logconfig.yaml
```

To enable forwarding on all the controller's models by default:

```bash
juju bootstrap azure --config logforward-enabled=true --config logconfig.yaml
```

See [Remote logging][troubleshooting-logs-remote] for a more thorough treatment
of log forwarding.

### Specifying an agent version

When a controller is created, it is possible to influence what agent version
will be used across the controller and its models. This is covered in
[Agent versions and streams][agent-versions-and-streams].

### Passing a cloud-specific setting

View if your chosen backing cloud has any special features and then pass the
feature as an option.

Firstly, reveal any features:

```bash
juju show-cloud --include-config aws
```

The bottom portion of the output looks like this:

```no-highlight
The available config options specific to ec2 clouds are:
vpc-id:
  type: string
  description: Use a specific AWS VPC ID (optional). When not specified, Juju requires
    a default VPC or EC2-Classic features to be available for the account/region.
vpc-id-force:
  type: bool
  description: Force Juju to use the AWS VPC ID specified with vpc-id, when it fails
    the minimum validation criteria. Not accepted without vpc-id
```

!!! Note:
    The VPC ID is obtained from the AWS web UI.

Secondly, create the controller by placing it (and its models) within it:

```bash
juju boootstrap --config vpc-id=vpc-86f7bbe1 aws
```

!!! Note:
    Cloud-specific features can also be passed to individual models during
    their creation (`add-model`).


<!-- LINKS -->

[clouds]: ./clouds.html
[charms-constraints]: ./charms-constraints.html
[commands]: ./commands.html#juju-bootstrap
[controlconfig]: ./controllers-config.html "Configuring Juju controllers"
[modelconfig]: ./models-config.html "Configuring Juju models"
[troubleshooting-logs-remote]: ./troubleshooting-logs-remote.html
[agent-versions-and-streams]: ./models-config.html#agent-versions-and-streams
