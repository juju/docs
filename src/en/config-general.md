Title:General configuration options
Commands:get-env, set-env

# General configuration options

There may be many cases, particularly when dealing with complex cloud
environments or running multiple instances of Juju, where it would be useful to
control further aspects of the Juju environment.
Many options can be changed by adding extra key:value pairs to the
environments.yaml file which Juju uses to initiate environments. Options which
are specific to certain cloud providers are detailed in the individual 
configuration pages, but there are additional settings which can be applied to
any environment.
Some of these may be useful for particular use cases as outlined in the sections
below, or you can [skip to the table](#alphabetical-list-of-general-configuration-values)
of all the values.


## Getting and setting individual values

If you have a currently initiated Juju environment, you can find out what
environment settings it is using by running the command:
```
juju get-env
```
This will return a list of all the currently set options - whether they were set
by the individual configuration in the environments.yaml file, set specifically
by you or inherited as a default value. 

You may also set individual values for the current environment using the
corresponding ```juju set-env``` command, and providing a key=value pair:
```
juju set-env noproxy=jujucharms.com
```
In some cases it makes more sense to add these values explicity by editing the 
"~/.juju/environments.yaml" file, as not all values can successfully be applied
to a running environment.

!!! Note: Juju does not currently check that the provided key is actually a
valid setting, so make sure you spell it correctly.


## Apt mirror

The apt packaging system is used extensively to install and upgrade software on 
machines provisioned in the environment, and many charms also use apt to 
install the latest versions of services they deploy.
It is possible to set a specific mirror for the apt packages to use, by settting
"apt-mirror" in the environments.yaml file or directly in a running environment:

```
juju set-env apt-mirror=http://archive.ubuntu.com/ubuntu/
```

It is also possible to set this to a local mirror if desired.

You may also run:
```
juju unset-env apt-mirror
```
to restore the default behaviour in a running environment.

## Versions and Streams

The ```agent-stream``` config option selects the versions of Juju which an
environment can deploy and upgrade to. This defaults to "released", indicating
that only the latest stable versions of Juju should be used, which is the 
recommended setting.

If you would prefer to run the upcoming stable release before it has been
accepted you can set:

```
agent-stream: proposed
```
Alternatively, for testing purposes you can use the latest unstable version of
Juju by setting:
```
agent-stream: devel
```

### Updating from versions prior to 1.21.1

If you have an existing test environment using tools-metadata-url or
agent-metadata-url to test proposed versions, you can still upgrade to 1.21.1+
After you upgrade, you can update the environment to use the devel streams at 
the default stream location:
```
juju unset-env agent-metadata-url
juju set-env agent-stream=proposed
```

Subsequent upgrades will "just work".


## NUMA

The Juju state server can be run in a mode tuned to be efficient on NUMA
hardware. To enable this feature you should add the following to your
environments.yaml file:

```
set-numa-control-policy: true
```
It is not desirable to set this feature on hardware which is not NUMA
compatible.

## Juju lifecycle and harvesting

Juju keeps a model of what it thinks the running environment
looks like, and based on that model, can harvest machines which it
deems are no longer required. This can help reduce running costs and
keep the environment 'tidy'.

Before explaining the different modes, it is useful to understand how Juju
percieves machines. As far as it is concerned, machines are in one of four 
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
- **Destroyed:** This is the default setting. Using this methodology, Juju will
harvest only machine instances that are dead, and that Juju knows about. Unknown
instances will not be harvested.
- **Unknown:** With this method, Juju will harvest only instances that Juju
doesn't know about. Use this with caution in a mixed environment or one which 
may contain multiple instances of Juju.
- **All:** This is the most aggressive setting. In this mode Juju will
terminate all instances which it considers to be "destroyed" or "unknown". 
This is a good option if you are only utilizing Juju for your
environment.

The default mode can be overriden by setting the 
```
provisioner-harvest-mode:
```
to any of the above values.

## Alphabetical list of general configuration values

| Key                        | Type   | Default| Valid values             | Purpose |
|----------------------------|--------|--------|--------------------------|---------|
|admin-secret                |String  |        |                          |   |
|agent-version               |String  |        |                          |   |
|agent-metadata-url          |String  |        | url                      | set private stream  |
|agent-stream                |String  |released| released/devel/proposed  | set version of Juju to use for deploy/upgrades|
|api-port                    |ForceInt|17070   |                          | port the API server is listening on|
|apt-mirror                  |String  |        |                          |   |
|apt-ftp-proxy               |String  |        | url                      | proxy for apt sources|
|apt-http-proxy              |String  |        | url                      | proxy for apt sources|
|apt-https-proxy             |String  |        | url                      | proxy for apt sources|
|authorized-keys             |String  |   -    |                          | pasted text of SSH key  |
|authorized-keys-path        |String  |   -    |                          |   |
|bootstrap-addresses-delay   |ForceInt|10      |                          |The amount of time between refreshing the addresses in seconds. Not too frequent as we refresh addresses from the provider each time|
|bootstrap-retry-delay       |ForceInt|5       |                          |Time between attempts to connect to an address in seconds|
|bootstrap-timeout           |ForceInt|600     |                          |The amount of time to wait contacting a state server in seconds|
|ca-cert                     |String  |        |                          |   |
|ca-cert-path                |String  |        |                          |   |
|ca-private-key              |String  |        |                          |   |
|ca-private-key-path         |String  |        |                          |   |
|charm-store-auth            |String  |        |                          |   |
|default-series              |String  |        |series name, e.g "trusty" | The default series of Ubuntu to use for deploying charms |
|development                 |Bool    |FALSE   |                          |   |
|disable-network-management  |Bool    |FALSE   |                          | On MAAS environment, set to TRUE for MAAS to control networks  |
|enable-os-refresh-update    |Bool    |        |                          |   |
|enable-os-upgrade           |Bool    |        |                          |   |
|firewall-mode               |String  |instance|                          | 'instance' requests the use of an individual firewall per instance.|
|ftp-proxy                   |String  |        | url                      | proxy setting|
|http-proxy                  |String  |        | url                      | proxy setting|
|https-proxy                 |String  |        | url                      | proxy setting |
|image-metadata-url          |String  |        |                          |   |
|image-stream                |String  |        |                          |   |
|logging-config              |String  |        |                          |   |
|lxc-clone-aufs              |Bool    |        |                          |   |
|lxc-clone                   |Bool    |        |                          |   |
|name                        |String  |        |                          | the name of the current environment|
|no-proxy                    |String  |        | domain list              | comma delimited list of domain addresses not to be proxied|
|prefer-ipv6                 |Bool    |FALSE   |                          |   |
|provisioner-harvest-mode    |String  |destroyed|all/none/unknown/destroyed| [see the section above](#juju-lifecycle-and-harvesting) |
|proxy-ssh                   |Bool    |TRUE    |                          |   |
|rsyslog-ca-cert             |String  |        |                          |   |
|set-numa-control-policy     |Bool    |FALSE   |                          | Tune Juju state-server to work with NUMA if present |
|ssl-hostname-verification   |Bool    |TRUE    |                          |   |
|state-port                  |ForceInt|37017   |                          | port the state server is listening on|
|syslog-port                 |ForceInt|6514    |                          | port that the syslog UDP/TCP listener is listening on|
|test-mode                   |Bool    |        |                          |   |
|type                        |String  |        | supported cloud types    | type of environment, e.g. local |
|uuid                        |UUID    |        |                          |   |

These keys are now deprecated:

| Key               | Reason/replacement                                   |
|-------------------|------------------------------------------------------|
|tools-metadata-url | replaced by agent-metadata-url, see [release notes for 1.21.1](reference-release-notes.html)|
