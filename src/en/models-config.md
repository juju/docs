Title: General configuration options  
TODO: check options haven't changed

# Configuring models

There may be times, particularly when dealing with complex cloud environments
or running multiple instances of Juju, where it would be useful to control
further aspects of the models you create with Juju. 


## Getting and setting individual values

You can display the current model settings by
running the command:

```bash
juju get-model-config
```

This will include all the currently set options - whether they were set
by you, inherited as a default value or dynamically set by Juju. 

You may also set values for the current environment using the
corresponding ```juju set-model-config``` command, and providing a key=value 
pair:

```bash
juju set-model-config noproxy=jujucharms.com
```
It is possible to specify a list of space-delimited key-value pairs to set more
than one configuration at a time:
  
```bash
juju set-model-config test-mode=true enable-os-upgrade=false
```
!!! Note: Juju does not currently check that the provided key is a valid
setting, so make sure you spell it correctly.

To return a value to the default setting the `unset-model-config` command is
used, specifying the key names:
  
```bash
juju unset-model-config test-mode
```

The list of possible values which may be configured is set out in the table
below, followed by specific notes detailing some of those options


## Alphabetical list of general configuration values

| Key                        | Type   | Default| Valid values             | Purpose |
|:----------------------------|--------|--------|--------------------------|:---------|
admin-secret | string |  |  | The password for the administrator user
agent-metadata-url | string |  |  | URL of private stream
agent-stream | string | released | released/devel/proposed | Version of Juju to use for deploy/upgrades
agent-version | string |  |  | The desired Juju agent version to use
allow-lxc-loop-mounts | bool | false |  | whether loop devices are allowed to be mounted inside lxc containers
api-port | int | 17070 |  | The TCP port for the API servers to listen on
apt-ftp-proxy | string |  |  | The APT FTP proxy for the model
apt-http-proxy | string |  |  | The APT HTTP proxy for the model
apt-https-proxy | string |  |  | The APT HTTPS proxy for the model
apt-mirror | string |  |  | The APT mirror for the model
authorized-keys | string |  |  | Any authorized SSH public keys for the model, as found in a ~/.ssh/authorized_keys file
authorized-keys-path | string |  |  | Path to file containing SSH authorized keys
block-all-changes | bool |  |  | Whether all changes to the model will be prevented
block-destroy-model | bool |  |  | Whether the model will be prevented from destruction
block-remove-object | bool |  |  | Whether remove operations (machine, service, unit or relation) will be prevented
bootstrap-addresses-delay | int | 10 |  | The amount of time between refreshing the addresses in seconds. Not too frequent as we refresh addresses from the provider each time
bootstrap-retry-delay | int | 5 |  | Time between attempts to connect to an address in seconds.
bootstrap-timeout | int | 600 |  | The amount of time to wait contacting a state server in seconds
ca-cert | string |  |  | The certificate of the CA that signed the state server certificate, in PEM format
ca-cert-path | string |  |  | Path to file containing CA certificate
ca-private-key | string |  |  | The private key of the CA that signed the state server certificate, in PEM format
ca-private-key-path | string |  |  | Path to file containing CA private key
default-series | string |  | valid series name, e.g. 'trusty' | The default series of Ubuntu to use for deploying charms
development | bool | false |  | Whether the model is in development mode
disable-network-management | bool | false |  | Whether the provider should control networks (only applies to MAAS models, this should usually be set to false(default) otherwise Juju will not be able to create containers)
enable-os-refresh-update | bool | true |  | Whether newly provisioned instances should run their respective OS's update capability.
enable-os-upgrade | bool | true |  | Whether newly provisioned instances should run their respective OS's upgrade capability
firewall-mode | string | instance | instance/global/none | The mode to use for network firewalling.  'instance' requests the use of an individual firewall per instance.  'global' uses a single firewall for all instances (access for a network port is enabled to one instance if any instance requires that port).  'none' requests that no firewalling should be performed inside the model. It's useful for clouds without support for either global or per instance security groups
ftp-proxy | string |  | url | The FTP proxy value to configure on instances, in the FTP_PROXY environment variable
http-proxy | string |  | url  | The HTTP proxy value to configure on instances, in the HTTP_PROXY environment variable
https-proxy | string |  | url | The HTTPS proxy value to configure on instances, in the HTTPS_PROXY environment variable
image-metadata-url | string |  | url | The URL at which the metadata used to locate OS image ids is located
image-stream | string |  |  | The simplestreams stream used to identify which image ids to search when starting an instance
logging-config | string |  |  | The configuration string to use when configuring Juju agent logging (see [this link](http://godoc.org/github.com/juju/loggo#ParseConfigurationString) for details)
lxc-clone | bool |  |  | Whether to use lxc-clone to create new LXC containers
lxc-clone-aufs | bool | false |  | Whether the LXC provisioner should create an LXC clone using AUFS if available
lxc-default-mtu | int |  |  | The MTU setting to use for network interfaces in LXC containers
name | string |  |  | The name of the current model
no-proxy | string |  |  | List of domain addresses not to be proxied (comma-separated)
prefer-ipv6 | bool | false |  | Whether to prefer IPv6 over IPv4 addresses for API endpoints and machines
provisioner-harvest-mode | string | destroyed | all/none/unknown/destroyed | What to do with unknown machines. See [harvesting section](#juju-lifecycle-and-harvesting)
proxy-ssh | bool |  |  | Whether SSH commands should be proxied through the API server
resource-tags | string | none | | Space-separated list of key=value pairs used to apply as tags on supported cloud models
rsyslog-ca-cert | string |  |  | The certificate of the CA that signed the rsyslog certificate, in PEM format
rsyslog-ca-key | string |  |  | The private key of the CA that signed the rsyslog certificate, in PEM format
set-numa-control-policy | bool | false |  | Tune Juju state-server to work with NUMA if present
ssl-hostname-verification | bool | true |  | Whether SSL hostname verification is enabled 
state-port | int | 37017 |  | Port for the API server to listen on
storage-default-block-source | string |  |  | The default block storage source for the model
syslog-port | int | 6514 |  | Port for the syslog UDP/TCP listener to listen on
test-mode | bool | false |  | Whether the model is intended for testing. If true, accessing the charm store does not affect statistical data of the store
type | string |  | any of the supported provider types | Type of model, e.g. local, ec2
uuid | string |  |  | The UUID of the model


## Apt mirror

The APT packaging system is used to install and upgrade software on
machines provisioned in the model, and many charms also use APT to
install software for the services they deploy. It is possible to set a
specific mirror for the APT packages to use, by setting "apt-mirror":

```bash
juju set-model-config apt-mirror=http://archive.ubuntu.com/ubuntu/
```

It is also possible to set this to a local mirror if desired.

You may also run:

```bash
juju unset-model-config apt-mirror
```
to restore the default behaviour in a running model.


## Versions and Streams

The ```agent-stream``` option selects the versions of Juju which an model
can deploy and upgrade to. This defaults to "released", indicating that only
the latest stable versions of Juju should be used, which is the recommended
setting.

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

## Provision machines faster by disabling software upgrades

When Juju provisions a machine, its default behaviour is to upgrade existing
packages to their latest version. If your OS images are fresh and/or your
deployed services do not require the latest package versions, you can disable
upgrades in order to provision machines faster.

Two Boolean configuration options are available to disable APT updates and
upgrades: `enable-os-refresh-update` (apt-get update) and `enable-os-upgrade`
(apt-get upgrade), respectively. By default, these are both set to 'true'.

```yaml
enable-os-refresh-update: false
enable-os-upgrade: false
```

You may also want to just update the package list to ensure a Charm has the
latest software available to it by disabling upgrades but enabling updates.

## Juju lifecycle and harvesting

Juju keeps state on the running model from which it builds a model.
Based on that model, it can harvest machines which it deems are no longer
required. This can help reduce running costs and keep the model 'tidy'.
Harvesting is guided by what "harvesting mode" has been set by the
system administrator. 

Before explaining the different modes, it is useful to understand how Juju
perceives machines. As far as it is concerned, machines are in one of four
states:

- **Alive:** The machine is running and being used.
- **Dying:** The machine is in the process of being terminated by Juju, but 
  hasn't yet finished.
- **Dead:** The machine has been successfully brought down by Juju, but is still
  being tracked for removal.
- **Unknown:** The machine exists, but Juju knows nothing about it.

### Harvesting modes
With the above in mind, Juju can use one of several strategies to delete or harvest
machines from the model:

- **None:** Using this method, Juju won't harvest any machines. This is the
most conservative, and a good choice if you manage your machines
using a separate process outside of Juju.
- **Destroyed:** This is the default setting. Juju will harvest only machine
instances that are dead, and that Juju knows about. Unknown instances will
not be harvested.
- **Unknown:** With this method, Juju will harvest only instances that Juju
doesn't know about. Use this with caution in a mixed environment or one which 
may contain multiple instances of Juju.
- **All:** This is the most aggressive setting. In this mode Juju will
terminate all instances which it considers to be "destroyed" or "unknown". 
This is a good option if you are only utilising Juju for your
environment.

The default mode can be overridden by setting the 

```yaml
provisioner-harvest-mode:
```
to any of the above values.

