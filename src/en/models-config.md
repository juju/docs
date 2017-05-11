Title: General configuration options
TODO: Check accuracy of key table
      Confirm 'all' harvest mode state. Seems it should be "'Dead' or
	'Unknown'" OR "a combination of modes 'destroyed' and 'unknown'".
      Make the table more space-efficient. Damn it's bulbous.
      Provide an example of using model-defaults to set a per-region attribute.


# Configuring models

A model influences all the machines that Juju creates within it and, in turn, the
applications that get deployed onto those machines. It is therefore a very powerful
feature to be able to configure at the model level.

Model configuration consists of a collection of keys and their respective
values. An explanation of how to both view and set these key:value pairs is
provided below. Notable examples are provided at the end.


## Getting and setting values

You can display the current model settings by running the command:

```bash
juju model-config
```

This will include all the currently set key values - whether they were set
by you, inherited as a default value or dynamically set by Juju. 

A key's value may be set for the current model using the same command:

```bash
juju model-config noproxy=jujucharms.com
```

It is also possible to specify a list of key-value pairs:
  
```bash
juju model-config test-mode=true enable-os-upgrade=false
```

!!! Note: Juju does not currently check that the provided key is a valid
setting, so make sure you spell it correctly.

To return a value to the default setting the `--reset` flag is used,
specifying the key names:
  
```bash
juju model-config --reset test-mode
```

After deployment, the `model-defaults` command allows a user to display the
configuration values for a model as well as set and unset those values for use
with any new models. These values can even be specified for each cloud region
instead of just the controller.

To set a value for `ftp-proxy`, for instance, you would enter the following:

```bash
juju model-defaults ftp-proxy=10.0.0.1:8000
```

To see both the default values and what they've been changed to, you
would use:

```bash
juju model-defaults
```

To set default values for all models in a specific controller region, state
the region in the command, shown here using the same example settings as our
previous `model-config` key-value pairs example above:

```bash
juju model-defaults us-east-1 test-mode=true enable-os-upgrade=false
```

These values can also be passed to a new controller for use with the default
model it creates. To do this, use the `--config` argument with bootstrap:

```bash
juju bootstrap --config image-stream=daily lxd lxd-daily
```

## List of model keys

The table below lists all the model keys which may be assigned a value. Some
of these keys deserve further explanation. These are explored in the sections
below the table.

| Key                        | Type   | Default  | Valid values             | Purpose |
|:---------------------------|--------|----------|--------------------------|:---------|
agent-metadata-url           | string |          |                          | The URL of the private stream.
agent-stream                 | string | released | released/devel/proposed  | The version of Juju to use for deploy/upgrades. See [additional info below](#versions-and-streams).
agent-version                | string |          |                          | The desired Juju agent version to use. See [additional info below](#versions-and-streams).
apt-ftp-proxy                | string |          |                          | The APT FTP proxy for the model.
apt-http-proxy               | string |          |                          | The APT HTTP proxy for the model.
apt-https-proxy              | string |          |                          | The APT HTTPS proxy for the model.
apt-mirror                   | string |          |                          | The APT mirror for the model. See [additional info below](#apt-mirror).
automatically-retry-hooks    | bool   | true     |                          | Set the policy on retying failed hooks. See [additional info below](#retrying-failed-hooks).
default-series               | string |          | valid series name, e.g. 'xenial' | The default series of Ubuntu to use for deploying charms.
development                  | bool   | false    |                          | Set whether the model is in development mode.
disable-network-management   | bool   | false    |                          | Set whether to give network control to the provider instead of Juju controlling configuration. See [additional info below](#disable-network-management).
enable-os-refresh-update     | bool   | true     |                          | Set whether newly provisioned instances should run their respective OS's update capability. See [additional info below](#apt-updates-and-upgrades-with-faster-machine-provisioning).
enable-os-upgrade            | bool   | true     |                          | Set whether newly provisioned instances should run their respective OS's upgrade capability. See [additional info below](#apt-updates-and-upgrades-with-faster-machine-provisioning).
extra-info                   | string |          |                          | This is a string to store any user-desired additional metadata.
firewall-mode                | string | instance | instance/global/none     | The mode to use for network firewalling. See [additional info below](#firewall-mode).
ftp-proxy                    | string |          | url                      | The FTP proxy value to configure on instances, in the FTP_PROXY environment variable.
http-proxy                   | string |          | url                      | The HTTP proxy value to configure on instances, in the HTTP_PROXY environment variable.
https-proxy                  | string |          | url                      | The HTTPS proxy value to configure on instances, in the HTTPS_PROXY environment variable.
ignore-machine-addresses     | bool   | false    |                          | When true, the machine worker will not look up or discover any machine addresses.
image-metadata-url           | string |          | url                      | The URL at which the metadata used to locate OS image ids is located.
image-stream                 | string |          |                          | The simplestreams stream used to identify which image ids to search when starting an instance.
logforward-enabled           | bool   | false    |                          | Set whether the log forward function is enabled.
logging-config               | string |          |                          | The configuration string to use when configuring Juju agent logging (see [this link](http://godoc.org/github.com/juju/loggo#ParseConfigurationString) for details).
max-status-history-age       | string |          | 72h, etc.                | The maximum age for status history entries before they are pruned, in a human-readable time format.
max-status-history-size      | string |          | 400M, 5G, etc.           | The maximum size for the status history collection, in human-readable memory format.
no-proxy                     | string |          |                          | List of domain addresses not to be proxied (comma-separated).
provisioner-harvest-mode     | string | destroyed| all/none/unknown/destroyed | Set what to do with unknown machines. See [additional info below](#juju-lifecycle-and-harvesting).
proxy-ssh                    | bool   | false    |                          | Set whether SSH commands should be proxied through the API server.
resource-tags                | string | none     |                          | A space-separated list of key=value pairs used to apply as tags on supported cloud models.
ssl-hostname-verification    | bool   | true     |                          | Set whether SSL hostname verification is enabled.
test-mode                    | bool   | false    |                          | Set whether the model is intended for testing. If true, accessing the charm store does not affect statistical data of the store.
transmit-vendor-metrics      | bool   | true     |                          | Set whether the controller will send metrics collected from this model for use in anonymized aggregate analytics.
vpc-id                       | string |          |                          | The virtual private cloud (VPC) ID for use when configuring a new model to be deployed to a specific VPC during `add-model`.


### Apt mirror

The APT packaging system is used to install and upgrade software on machines
provisioned in the model, and many charms also use APT to install software for
the applications they deploy. It is possible to set a specific mirror for the APT
packages to use, by setting 'apt-mirror':

```bash
juju model-config apt-mirror=http://archive.ubuntu.com/ubuntu/
```

It is also possible to set this to a local mirror if desired.

You may also run:

```bash
juju model-config --reset apt-mirror
```

to restore the default behaviour in a running model.


### APT updates and upgrades with faster machine provisioning

When Juju provisions a machine, its default behaviour is to upgrade existing
packages to their latest version. If your OS images are fresh and/or your
deployed applications do not require the latest package versions, you can
disable upgrades in order to provision machines faster.

Two Boolean configuration options are available to disable APT updates and
upgrades: `enable-os-refresh-update` (apt-get update) and `enable-os-upgrade`
(apt-get upgrade), respectively.

```yaml
enable-os-refresh-update: false
enable-os-upgrade: false
```

You may also want to just update the package list to ensure a charm has the
latest software available to it by disabling upgrades but enabling updates.


### Disable network management

This can only be used with MAAS models and should otherwise be set to
false(default) unless you want to take over network control from Juju because
you have unique and well-defined needs. Setting this to 'true' with MAAS gives
you the same behavior with containers as you already have with other
providers: one machine-local address on a single network interface, bridged
to the default bridge.


### Firewall mode

Modes available include:
- **instance:** Requests the use of an individual firewall per instance
- **global:** Uses a single firewall for all instances (access for a network
  port is enabled to one instance if any instance requires that port)
- **none:** Requests that no firewalling should be performed inside the model,
  which is useful for clouds without support for either global or per instance
  security groups


### Juju lifecycle and harvesting

Juju keeps state on the running model and it can harvest (remove) machines
which it deems are no longer required. This can help reduce running costs and
keep the model tidy. Harvesting is guided by what "harvesting mode" has been
set. 

A Juju machine can be in one of four states:

- **Alive:** The machine is running and being used.
- **Dying:** The machine is in the process of being terminated by Juju, but 
  hasn't yet finished.
- **Dead:** The machine has been successfully brought down by Juju, but is still
  being tracked for removal.
- **Unknown:** The machine exists, but Juju knows nothing about it.

Juju can be in one of several harvesting modes, in order of most conservative
to most aggressive:

- **none:** Machines will never be harvested. This is a good choice if machines
  are managed via a process outside of Juju.
- **destroyed:** Machines will be harvested if i) Juju "knows" about them and
  ii) they are 'Dead'.
- **unknown:** Machines will be harvested if Juju does not "know" about them
  ('Unknown' state). Use with caution in a mixed environment or one which may
  contain multiple instances of Juju.
- **all:** Machines will be harvested if Juju considers them to be 'destroyed'
  or 'unknown'.

The default mode is **destroyed**.

Below, the harvest mode key for the current model is set to 'none':

```bash
juju model-config provisioner-harvest-mode=none
```


### Retrying failed hooks

Prior to version 2.0, hooks returning an error would block until the user
ran a command to retry them manually:
`juju resolved unit-name/#`
  
From version 2.0, Juju will automatically retry hooks periodically - there is 
an exponential backoff, so hooks will be retried after 5, 10, 20, 40 seconds up
to a period of 5 minutes, and then every 5 minutes. The logic behind this is
that some hook errors are caused by timing issues or the temporary 
unavailability of other applications - automatic retry enables the Juju model
to heal itself without troubling the user.

However, in some circumstances, such as debugging charms, this behaviour can be
distracting and unwelcome. For this reason, it is possible to set the 
`automatically-retry-hooks` option to 'false' to disable this behaviour. In this
case, users will have to manually retry any hook which fails, using the command
above, as with earlier versions of Juju.

!!! Note: Even with the automatic retry enabled, it is still possible to use
the  `juju resolved unit-name/#` command to retry manually.


### Versions and streams

The `agent-stream` option selects the versions of Juju which a model can deploy
and upgrade to. This defaults to 'released', indicating that only the latest
stable versions of Juju should be used, which is the recommended setting.

To run the upcoming stable release (before it has passed the normal QA process)
you can set:

```yaml
agent-stream: proposed
```

Alternatively, for testing purposes, you can use the latest unstable version of
Juju by setting:

```yaml
agent-stream: devel
```

The `agent-version` option selects a specific client version to be used, with
some constraints. It is used as a parameter during bootstrap and permits you
to tell Juju to bootstrap a new controller using the same major and minor
version already in use, but with a different patch number. For example, Juju
uses the major.minor.patch numbering scheme, so Juju 2.1.3 means major version
2, minor version 1, and patch version 3. On a system with this release of Juju
installed, you can bootstrap a controller on aws using a different patch release,
like this:

```bash
juju bootstrap aws aws --agent-version='2.1.2'
```

You cannot bootstrap a controller on this system using Juju 1.x, Juju 2.2, and
so on. Only different patch numbers may be used with `agent-version`
