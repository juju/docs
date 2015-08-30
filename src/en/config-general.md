Title: General configuration options
Commands: get-env, set-env

# General configuration options

There may be times, particularly when dealing with complex cloud environments
or running multiple instances of Juju, where it would be useful to control
further aspects of the Juju environment. Many options can be changed by adding
extra key:value pairs to the environments.yaml file which Juju uses to initiate
environments. Options which are specific to certain cloud providers are
detailed in the individual configuration pages, but there are additional
settings which can be applied to any environment. Some of these may be useful
for particular use cases as outlined in the sections below, or you can
[skip to the table](#alphabetical-list-of-general-configuration-values) of all
the values.


## Getting and setting individual values

You can display the environment settings of a running Juju environment by
running the command:

```bash
juju get-env
```

This will include all the currently set options - whether they were set
by the individual configuration in the environments.yaml file, set specifically
by you or inherited as a default value. 

You may also set individual values for the current environment using the
corresponding ```juju set-env``` command, and providing a key=value pair:

```bash
juju set-env noproxy=jujucharms.com
```

Some values will need to be specified via the environments.yaml file, as not
all values can be applied to a running environment.

!!! Note: Juju does not currently check that the provided key is a valid
setting, so make sure you spell it correctly.


## Apt mirror

The APT packaging system is used to install and upgrade software on
machines provisioned in the environment, and many charms also use APT to
install software for the services they deploy. It is possible to set a
specific mirror for the APT packages to use, by setting "apt-mirror" in the
environments.yaml file or directly in a running environment:

```bash
juju set-env apt-mirror=http://archive.ubuntu.com/ubuntu/
```

It is also possible to set this to a local mirror if desired.

You may also run:

```bash
juju unset-env apt-mirror
```
to restore the default behaviour in a running environment.


## Versions and Streams

The ```agent-stream``` option selects the versions of Juju which an environment
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

### Updating from versions prior to 1.21.1

If you have an existing test environment using tools-metadata-url or
agent-metadata-url to test proposed versions, you can still upgrade to 1.21.1+.
After you upgrade, you can update the environment to use the devel streams at
the default stream location:

```bash
juju unset-env agent-metadata-url
juju set-env agent-stream=proposed
```

Subsequent upgrades will "just work".


## Provision machines faster by disabling software upgrades

When Juju provisions a machine, its default behaviour is to upgrade existing
packages to their latest version. If your OS images are fresh and/or your
deployed services do not require the latest package versions, you can disable
upgrades in order to provision machines faster.

Two Boolean configuration options are available to disable APT updates and
upgrades: `enable-os-refresh-update` (apt-get update) and `enable-os-upgrade`
(apt-get upgrade), respectively. By default, these are both set to 'true'.
To disable them set them to 'false' in environments.yaml like so:

```yaml
enable-os-refresh-update: false
enable-os-upgrade: false
```

You may also want to just update the package list to ensure a Charm has the
latest software available to it by disabling upgrades but enabling updates.

### Local Provider

The Local Provider, however, skips upgrades by default for faster provisioning.
If you wish to enable upgrades in your local development, you will need to
explicitly set enable-os-upgrade to "true".

If you are using the Local Provider to develop Charms or test, you will want to
regularly purge the Juju LXC template and LXC host cache to be certain you are
using fresh images. See
[Installing and configuring Juju for LXC (Linux)](./config-LXC.html#ensuring-a-fresh-cache).


## NUMA

The Juju state server can be run in a mode tuned to be efficient on NUMA
hardware. To enable this feature you should add the following to your
environments.yaml file:

```yaml
set-numa-control-policy: true
```

It is not desirable to set this feature on hardware which is not NUMA
compatible.


## Juju lifecycle and harvesting

Juju keeps state on the running environment from which it builds a model.
Based on that model, it can harvest machines which it deems are no longer
required. This can help reduce running costs and keep the environment 'tidy'.
Harvesting is guided by what "harvesting mode" has been set by the
system administrator. 

Before explaining the different modes, it is useful to understand how Juju
perceives machines. As far as it is concerned, machines are in one of four
states:

- **Alive:** The machine is running and being used.
- **Dying:** The machine is in the process of being terminated by Juju, but hasn't
yet finished.
- **Dead:** The machine has been successfully brought down by Juju, but is still
being tracked for removal.
- **Unknown:** The machine exists, but Juju knows nothing about it.

### Harvesting modes
With the above in mind, Juju can use one of several strategies to delete or harvest
machines from the environment

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


## Alphabetical list of general configuration values

| Key                        | Type   | Default| Valid values             | Purpose |
|:----------------------------|--------|--------|--------------------------|:---------|
admin-secret | string |  |  | The password for the administrator user
agent-metadata-url | string |  |  | URL of private stream
agent-stream | string | released | released/devel/proposed | Version of Juju to use for deploy/upgrades
agent-version | string |  |  | The desired Juju agent version to use
allow-lxc-loop-mounts | bool | false |  | whether loop devices are allowed to be mounted inside lxc containers
api-port | int | 17070 |  | The TCP port for the API servers to listen on
apt-ftp-proxy | string |  |  | The APT FTP proxy for the environment
apt-http-proxy | string |  |  | The APT HTTP proxy for the environment
apt-https-proxy | string |  |  | The APT HTTPS proxy for the environment
apt-mirror | string |  |  | The APT mirror for the environment
authorized-keys | string |  |  | Any authorized SSH public keys for the environment, as found in a ~/.ssh/authorized_keys file
authorized-keys-path | string |  |  | Path to file containing SSH authorized keys
block-all-changes | bool |  |  | Whether all changes to the environment will be prevented
block-destroy-environment | bool |  |  | Whether the environment will be prevented from destruction
block-remove-object | bool |  |  | Whether remove operations (machine, service, unit or relation) will be prevented
bootstrap-addresses-delay | int | 10 |  | The amount of time between refreshing the addresses in seconds. Not too frequent as we refresh addresses from the provider each time
bootstrap-retry-delay | int | 5 |  | Time between attempts to connect to an address in seconds.
bootstrap-timeout | int | 600 |  | The amount of time to wait contacting a state server in seconds
ca-cert | string |  |  | The certificate of the CA that signed the state server certificate, in PEM format
ca-cert-path | string |  |  | Path to file containing CA certificate
ca-private-key | string |  |  | The private key of the CA that signed the state server certificate, in PEM format
ca-private-key-path | string |  |  | Path to file containing CA private key
default-series | string |  | valid series name, e.g. 'trusty' | The default series of Ubuntu to use for deploying charms
development | bool | false |  | Whether the environment is in development mode
disable-network-management | bool | false |  | Whether the provider should control networks (on MAAS environments, set to true for MAAS to control networks
enable-os-refresh-update | bool | true |  | Whether newly provisioned instances should run their respective OS's update capability.
enable-os-upgrade | bool | true |  | Whether newly provisioned instances should run their respective OS's upgrade capability
firewall-mode | string | instance | instance/global/none | The mode to use for network firewalling.  'instance' requests the use of an individual firewall per instance.  'global' uses a single firewall for all instances (access for a network port is enabled to one instance if any instance requires that port).  'none' requests that no firewalling should be performed inside the environment. It's useful for clouds without support for either global or per instance security groups
ftp-proxy | string |  | url | The FTP proxy value to configure on instances, in the FTP_PROXY environment variable
http-proxy | string |  | url  | The HTTP proxy value to configure on instances, in the HTTP_PROXY environment variable
https-proxy | string |  | url | The HTTPS proxy value to configure on instances, in the HTTPS_PROXY environment variable
image-metadata-url | string |  | url | The URL at which the metadata used to locate OS image ids is located
image-stream | string |  |  | The simplestreams stream used to identify which image ids to search when starting an instance
logging-config | string |  |  | The configuration string to use when configuring Juju agent logging (see [this link](http://godoc.org/github.com/juju/loggo#ParseConfigurationString) for details)
lxc-clone | bool |  |  | Whether to use lxc-clone to create new LXC containers
lxc-clone-aufs | bool | false |  | Whether the LXC provisioner should create an LXC clone using AUFS if available
lxc-default-mtu | int |  |  | The MTU setting to use for network interfaces in LXC containers
name | string |  |  | The name of the current environment
no-proxy | string |  |  | List of domain addresses not to be proxied (comma-separated)
prefer-ipv6 | bool | false |  | Whether to prefer IPv6 over IPv4 addresses for API endpoints and machines
provisioner-harvest-mode | string | destroyed | all/none/unknown/destroyed | What to do with unknown machines. See [harvesting section](#juju-lifecycle-and-harvesting)
proxy-ssh | bool |  |  | Whether SSH commands should be proxied through the API server
resource-tags | string | none | | Space-separated list of key=value pairs used to apply as tags on supported cloud environments
rsyslog-ca-cert | string |  |  | The certificate of the CA that signed the rsyslog certificate, in PEM format
rsyslog-ca-key | string |  |  | The private key of the CA that signed the rsyslog certificate, in PEM format
set-numa-control-policy | bool | false |  | Tune Juju state-server to work with NUMA if present
ssl-hostname-verification | bool | true |  | Whether SSL hostname verification is enabled 
state-port | int | 37017 |  | Port for the API server to listen on
storage-default-block-source | string |  |  | The default block storage source for the environment
syslog-port | int | 6514 |  | Port for the syslog UDP/TCP listener to listen on
test-mode | bool | false |  | Whether the environment is intended for testing. If true, accessing the charm store does not affect statistical data of the store
type | string |  | any of the supported provider types | Type of environment, e.g. local, ec2
uuid | string |  |  | The UUID of the environment

These keys are now deprecated:

| Key               | Reason/replacement                                   |
|-------------------|------------------------------------------------------|
|lxc-use-clone | replaced by lxc-clone|
|provisioner-safe-mode | Whether to run the provisioner in "destroyed" harvest mode (deprecated, superseded by provisioner-harvest-mode)|
|tools-metadata-url | replaced by agent-metadata-url, see [release notes for 1.21.1](reference-release-notes.html)|
|tools-stream | superseded by agent-stream |
