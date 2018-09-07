Title: Creating a controller
TODO:  Hardcoded: Ubuntu code names

# Creating a controller

The `bootstrap` command is used to create a controller for a given cloud:

`juju bootstrap <cloud name> [<controller name>]`

The controller name is optional. If one is not supplied, then a name is
assigned based on the cloud and region.

To learn about configuration options available at bootstrap time, see:

 - [Configuring controllers][controllers-config]
 - [Configuring models][models-config]
 - [Using constraints][charms-constraints]

## Examples

This list of examples provides a good overview of the different things that can
be done at controller-creation time:

 - [Create a controller interactively][#create-a-controller-interactively]
 - [Set default model constraints for a controller][#set-default-model-constraints-for-a-controller]
 - [Set controller constraints for a new controller][#set-controller-constraints-for-a-new-controller]
 - [Create a controller of a specific series][#create-a-controller-of-a-specific-series]
 - [Create a controller using configuration values][#create-a-controller-using-configuration-values]
 - [Create a controller using a non-default region][#create-a-controller-using-a-non-default-region]
 - [Create a controller using a different MongoDB profile][#create-a-controller-using-a-different-mongodb-profile]
 - [Change timeout and retry delays][#change-timeout-and-retry-delays]
 - [Create a new controller without changing contexts][#create-a-new-controller-without-changing-contexts]
 - [Configuring/enabling a remote syslog server][#configuring/enabling-a-remote-syslog-server]
 - [Placing a controller on a specific MAAS node][#placing-a-controller-on-a-specific-maas-node]
 - [Specifying an agent version][#specifying-an-agent-version]
 - [Passing a cloud-specific setting][#passing-a-cloud-specific-setting]

### Create a controller interactively

You can create a controller interactively like this:

```bash
juju bootstrap
```

You will be prompted for what cloud and region to use as well as the controller
name. Do not use this method if you want to specify anything else.

### Set default model constraints for a controller

Below, all machines (including the controller) in the LXD controller's models
will have at least 4GiB of memory:

```bash
juju bootstrap --constraints mem=4G localhost
```

### Set controller constraints for a new controller

This example shows how to request at least 4GiB of memory and two CPUs for an
AWS controller:

```bash
juju bootstrap --bootstrap-constraints "mem=4G cores=2" aws
```

If any of the constraints are also used with `--constraints` then the ones
given via `--bootstrap-constraints` will be used.

### Create a controller of a specific series

The controller will be deployed upon Ubuntu 18.04 LTS (Bionic) by default.
    
For our example, we name the resulting LXD controller 'lxd-bionic' to reflect
that:

```bash
juju bootstrap localhost lxd-bionic
```

To select a different series the `--bootstrap-series` option is used.

Below, a google (GCE) controller based on Ubuntu 16.04 LTS (Xenial) is
requested explicitly (and is given the name 'gce-xenial'):

```bash
juju bootstrap --bootstrap-series=xenial google gce-xenial
```

### Create a controller using configuration values

This example uses a previously defined configuration file called
config-rackspace.yaml as well as individual configuration values. The latter
values take precedence over those included in the file:

```bash
juju bootstrap \
	--config=~/config-rackspace.yaml   \
	--config image-stream=daily        \
	rackspace controller-rackspace
```

### Create a controller using a non-default region

The `clouds` command lists available clouds and denotes a default region for
each. To specify a different region during controller creation:

```bash
juju bootstrap aws/us-west-2 mycontroller
```

This is where omitting a custom controller name could be appropriate, as doing
so will result in a name based on the non-default region. Here the controller
would be named 'aws-us-west-2':

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

### Create a new controller without changing contexts

When a new controller is created, by default, the context will change to the
'default' model of that controller. In some cases (e.g. when scripting) this
may not be desirable. The `--no-switch` option disables this behaviour:

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

### Placing a controller on a specific MAAS node

To create a controller and have it run on a specific MAAS node:

```bash
juju bootstrap maas-prod --to <host>.maas
```

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

[charms-constraints]: ./charms-constraints.md
[controllers-config]: ./controllers-config.md
[models-config]: ./models-config.md
[troubleshooting-logs-remote]: ./troubleshooting-logs-remote.md
[agent-versions-and-streams]: ./models-config.md#agent-versions-and-streams

[#create-a-controller-interactively]: #create-a-controller-interactively
[#set-default-model-constraints-for-a-controller]: #set-default-model-constraints-for-a-controller
[#set-controller-constraints-for-a-new-controller]: #set-controller-constraints-for-a-new-controller
[#create-a-controller-of-a-specific-series]: #create-a-controller-of-a-specific-series
[#create-a-controller-using-configuration-values]: #create-a-controller-using-configuration-values
[#create-a-controller-using-a-non-default-region]: #create-a-controller-using-a-non-default-region
[#create-a-controller-using-a-different-mongodb-profile]: #create-a-controller-using-a-different-mongodb-profile
[#change-timeout-and-retry-delays]: #change-timeout-and-retry-delays
[#create-a-new-controller-without-changing-contexts]: #create-a-new-controller-without-changing-contexts
[#configuring/enabling-a-remote-syslog-server]: #configuring/enabling-a-remote-syslog-server
[#placing-a-controller-on-a-specific-maas-node]: #placing-a-controller-on-a-specific-maas-node
[#specifying-an-agent-version]: #specifying-an-agent-version
[#passing-a-cloud-specific-setting]: #passing-a-cloud-specific-setting
