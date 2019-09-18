<!--
Todo:
- Hardcoded: Ubuntu code names
- Remove gerunds from example listings (fix links from other pages)
-->

This page collects together examples that show the various ways a controller can be created. They also demonstrate configurations that can be applied to a cloud environment at controller-creation time.

- [Common invocation](#heading--common-invocation)
- [Create a controller interactively](#heading--create-a-controller-interactively)
- [Set default model constraints](#heading--set-default-model-constraints)
- [Set constraints for a controller](#heading--set-constraints-for-a-controller)
- [Create a controller of a specific series](#heading--create-a-controller-of-a-specific-series)
- [Set model configuration kyes](#heading--set-model-configuration-keys)
- [Set model configuration keys both with a file and individually](#heading--set-model-configuration-keys-both-with-a-file-and-individually)
- [Create a controller using a non-default region](#heading--create-a-controller-using-a-non-default-region)
- [Create a controller using a different MongoDB profile](#heading--create-a-controller-using-a-different-mongodb-profile)
- [Use a custom charm store](#heading--use-a-custom-charm-store)
- [Change timeout and retry delays](#heading--change-timeout-and-retry-delays)
- [Create a new controller without changing contexts](#heading--create-a-new-controller-without-changing-contexts)
- [Configuring/enabling a remote syslog server](#heading--configuringenabling-a-remote-syslog-server)
- [Placing a controller on a specific MAAS node](#heading--placing-a-controller-on-a-specific-maas-node)
- [Specifying an agent version](#heading--specifying-an-agent-version)
- [Passing a cloud-specific setting](#heading--passing-a-cloud-specific-setting)
- [Include configuration options at the cloud level](#heading--include-configuration-options-at-the-cloud-level)

[note]
A requirement for creating a controller is that a cloud has been chosen and that credentials have been added for it. See the [Clouds](/t/clouds/1100) page for guidance.
[/note]

To learn more about configuration options available at bootstrap time, see these resources:

- [Configuring controllers](/t/configuring-controllers/1107)
- [Configuring models](/t/configuring-models/1151)
- [Using constraints](/t/using-constraints/1060)

A controller is created with the `bootstrap` command.

<h3 id="heading--common-invocation">Common invocation</h3>

A very common way to create a controller is by just specifying a cloud name and a controller name:

``` text
juju bootstrap aws aws-controller
```

Note that if a controller name is not specified one will be assigned based on the cloud name and the cloud's default region.

<h3 id="heading--create-a-controller-interactively">Create a controller interactively</h3>

You can create a controller interactively by omitting a cloud name altogether:

``` text
juju bootstrap
```

You will be prompted for what cloud and region to use as well as the controller name. Do not use this method if you intend on specifying anything else.

<h3 id="heading--set-default-model-constraints">Set default model constraints</h3>

Default constraints can be set for every model within a controller. This, in turn, affects the machines that will be created within those models.

Here, every machine, including the controller itself, will have at least 4GiB of memory:

```text
juju bootstrap --constraints mem=4G localhost
```

See page [Using constraints](/t/using-constraints/1060) for details on constraints.

<h3 id="heading--set-constraints-for-a-controller">Set constraints for a controller</h3>

To request at least 4GiB of memory and two CPUs for an AWS controller:

``` text
juju bootstrap --bootstrap-constraints "mem=4G cores=2" aws
```

If any of the constraints are also used with `--constraints` then the ones given via `--bootstrap-constraints` will be used.

<h3 id="heading--create-a-controller-of-a-specific-series">Create a controller of a specific series</h3>

The controller will be deployed upon Ubuntu 18.04 LTS (Bionic) by default.

Here, we name the resulting LXD controller 'lxd-bionic' to reflect that:

``` text
juju bootstrap localhost lxd-bionic
```

To select a different series the `--bootstrap-series` option is used.

Below, a google (GCE) controller based on Ubuntu 16.04 LTS (Xenial) is requested explicitly (and is given the name 'gce-xenial'):

``` text
juju bootstrap --bootstrap-series=xenial google gce-xenial
```

<h3 id="heading--set-model-configuration-keys">Set model configuration keys</h3>

Model configuration keys can be set using either of the following two options:

1. `--config`
1. `--model-default`

The `--config` option affects the initial models, 'controller' and 'default'.

The `--model-default` option affects the initial models as well as any subsequently added models (`add-model` command) . The `model-defaults` command can be used once the controller is created in order to achieve the same result.

To create a controller (named "vsp") for cloud "vsphere" while specifying the vSphere datastore "xtian-ds1" for every model, including any future ones:

```text
juju bootstrap --model-default datastore=xtian-ds1 vsphere vsp
```

<h3 id="heading--set-model-configuration-keys-both-with-a-file-and-individually">Set model configuration keys both with a file and individually</h3>

This example demonstrates how to use both a previously defined configuration file (`~/config-rackspace.yaml`) and individual configuration values. The latter values take precedence over those that may be included in the file:

``` text
juju bootstrap \
    --config=~/config-rackspace.yaml \
    --config image-stream=daily \
    rackspace controller-rackspace
```

<h3 id="heading--create-a-controller-using-a-non-default-region">Create a controller using a non-default region</h3>

The `clouds` command lists available clouds and denotes a default region for each. To specify a different region during controller creation:

``` text
juju bootstrap aws/us-west-2 mycontroller
```

This is where omitting a custom controller name could be appropriate, as doing so will result in a name based on the non-default region. Here the controller would be named 'aws-us-west-2':

``` text
juju bootstrap aws/us-west-2
```

<h3 id="heading--create-a-controller-using-a-different-mongodb-profile">Create a controller using a different MongoDB profile</h3>

MongoDB has two memory profile settings available, 'default' and 'low'. The first setting is the profile shipped by default with MongoDB. The second is a more conservative memory profile that uses less memory. To select which one your controller uses when it is created, use:

``` text
juju bootstrap --config mongo-memory-profile=low
```

<h3 id="heading--use-a-custom-charm-store">Use a custom charm store</h3>

Sometimes the charms you're interested in do not yet reside in the default production charm store (`https://api.jujucharms.com/charmstore`). In this case you can configure Juju to pull charms from an alternate source at controller creation time. Below, we create an OCI controller and pass the staging store URL:

``` text
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore oci
```

<h3 id="heading--change-timeout-and-retry-delays">Change timeout and retry delays</h3>

You can change the default timeout and retry delays used by Juju by setting the following keys in your configuration:

<table style="width:82%;">
<colgroup>
<col width="40%" />
<col width="27%" />
<col width="13%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Key</th>
<th align="left">Default (seconds)</th>
<th align="left">Purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">bootstrap-timeout</td>
<td align="left">600</td>
<td align="left">How long to wait for a connection to the controller</td>
</tr>
<tr class="even">
<td align="left">bootstrap-retry-delay</td>
<td align="left">5</td>
<td align="left">How long to wait between connection attempts to a controller</td>
</tr>
<tr class="odd">
<td align="left">bootstrap-address-delay</td>
<td align="left">10</td>
<td align="left">How often to refresh controller addresses from the API server</td>
</tr>
</tbody>
</table>

For example, to increase the timeout between the client and the controller from 10 minutes to 15, enter the value in seconds:

``` text
juju bootstrap --config bootstrap-timeout=900 localhost lxd-faraway
```

<h3 id="heading--create-a-new-controller-without-changing-contexts">Create a new controller without changing contexts</h3>

When a new controller is created, by default, the context will change to the 'default' model of that controller. In some cases (e.g. when scripting) this may not be desirable. The `--no-switch` option disables this behaviour:

``` text
juju bootstrap --no-switch localhost lxd-new
```

<h3 id="heading--configuringenabling-a-remote-syslog-server">Configuring/enabling a remote syslog server</h3>

Create an Azure controller and configure for log forwarding:

``` text
juju bootstrap azure --config logconfig.yaml
```

To enable forwarding on all the controller's models by default:

``` text
juju bootstrap azure --config logforward-enabled=true --config logconfig.yaml
```

See [Remote logging](/t/juju-logs/1184#heading--remote-logging) for a more thorough treatment of log forwarding.

<h3 id="heading--placing-a-controller-on-a-specific-maas-node">Placing a controller on a specific MAAS node</h3>

To create a controller and have it run on a specific MAAS node:

``` text
juju bootstrap maas-prod --to <host>.maas
```

<h3 id="heading--specifying-an-agent-version">Specifying an agent version</h3>

When a controller is created, it is possible to influence what agent version will be used across the controller and its models. This is covered in [Agent versions and streams](/t/configuring-models/1151#heading--agent-versions-and-streams).

<h3 id="heading--passing-a-cloud-specific-setting">Passing a cloud-specific setting</h3>

A cloud setting can be done locally or, since `v.2.6.0`, remotely (on a live cloud). Here, we'll show how to do it locally (client cache).

[note]
In versions prior to `v.2.6.0` the `show-cloud` command only operates locally (there is no `--local` option).
[/note]

View if your chosen backing cloud has any special features and then pass the feature as an option.

Firstly, reveal any features:

``` text
juju show-cloud --local --include-config aws
```

The bottom portion of the output looks like this:

``` text
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

[note]
The VPC ID is obtained from the AWS web UI.
[/note]

Secondly, create the controller by placing it (and its models) within it:

``` text
juju boootstrap --config vpc-id=vpc-86f7bbe1 aws
```

[note]
Cloud-specific features can also be passed to individual models during their creation (`add-model`).
[/note]

<h3 id="heading--include-configuration-options-at-the-cloud-level">Include configuration options at the cloud level</h3>

Any settings passed via the `--config` option can be included in the definition of a cloud. See [General cloud management](/t/clouds/1100#heading--general-cloud-management) for how to do this.

<!-- LINKS -->
