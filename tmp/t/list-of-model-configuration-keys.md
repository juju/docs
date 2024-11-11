(list-of-model-configuration-keys)=
# List of model configuration keys

<!-- Moved out of https://discourse.charmhub.io/t/how-to-configure-a-model/1151 
 <h2 id="heading--list-of-model-keys">List of model keys</h2>
-->
<!--Sources: juju model-config, https://github.com/juju/juju/blob/develop/environs/config/config.go
-->

> <small> {ref}`Configuration > Model configuration <7068md>` > List of model configuration keys</small>
>
> See also: {ref}`Model <model>`, {ref}`How to configure a model <7068md>`
>
> [Source](https://github.com/juju/juju/blob/f0aceb9ab82a542d99403230d7c54480e7d43e8d/environs/config/config.go)

This document gives a list of all the configuration keys that can be applied to a Juju model.

```{important}

Some are only defined for a given cloud; see [`<cloud specific key>`](#heading--cloud-specific-key). Others are defined generally but may still only be available for some clouds; e.g., [`container-inherit-properties`](#heading--container-inherit-properties).

```

**Contents:**


- [`<cloud-specific key>`](#heading--cloud-specific-key)	
- [`agent-metadata-url`](#heading--agent-metadata-url)
- [`agent-stream`](#heading--agent-stream)
- [`agent-version`](#heading--agent-version)
- [`apt-ftp-proxy*`](#heading--apt-ftp-proxy)
- [`apt-http-proxy*`](#heading--apt-http-proxy)
- [`apt-https-proxy*`](#heading--apt-https-proxy)
- [`apt-mirror`](#heading--apt-mirror)
- [`apt-no-proxy`](#heading--apt-no-proxy)
- [`automatically-retry-hooks`](#heading--automatically-retry-hooks)
- [`backup-dir`](#heading--backup-dir)
- [`charmhub-url`](#heading--charmhub-url)
- [`cloudinit-userdata`](#heading--cloudinit-userdata)
- [`container-image-metadata-url`](#heading--container-image-metadata-url)
- [`container-image-stream`](#heading--container-image-stream)
- [`container-inherit-properties`](#heading--container-inherit-properties)
- [`container-networking-method`](#heading--container-networking-method)
- [`default-base`](#heading--default-base)
- [`default-space`](#heading--default-space)
- [`development`](#heading--development)
- [`disable-network-management`](#heading--disable-network-management)
- [`disable-telemetry`](#heading--disable-telemetry)
- [`egress-subnets`](#heading--egress-subnets)
- [`enable-os-refresh-update`](#heading--enable-os-refresh-update)
- [`enable-os-upgrade`](#heading--enable-os-upgrade)
- [`fan-config`](#heading--fan-config)
- [`firewall-mode`](#heading--firewall-mode)
- [`ftp-proxy*`](#heading--ftp-proxy)
- [`http-proxy*`](#heading--http-proxy)
- [`https-proxy*`](#heading--https-proxy)
- [`ignore-machine-addresses`](#heading--ignore-machine-addresses)
- [`image-metadata-url`](#heading--image-metadata-url)
- [`image-stream`](#heading--image-stream)
- [`juju-ftp-proxy*`](#heading--juju-ftp-proxy)
- [`juju-http-proxy*`](#heading--juju-http-proxy)
- [`juju-https-proxy*`](#heading--juju-https-proxy)
- [`juju-no-proxy*`](#heading--juju-no-proxy)
- [`logforward-enabled`](#heading--logforward-enabled)
- [`logging-config`](#heading--logging-config)
- [`logging-output`](#heading--logging-output)
- [`lxd-snap-channel`](#heading--lxd-snap-channel)
- [`max-action-results-age`](#heading--max-action-results-age)
- [`max-action-results-size`](#heading--max-action-results-size)
- [`max-status-history-age`](#heading--max-status-history-age)
- [`max-status-history-size`](#heading--max-status-history-size)
- [`net-bond-reconfigure-delay`](#heading--net-bond-reconfigure-delay)
- [`no-proxy*`](#heading--no-proxy)
- [`num-container-provision-workers`](#heading--num-container-provision-workers)
- [`num-provision-workers`](#heading--num-provision-workers)
- [`provisioner-harvest-mode`](#heading--provisioner-harvest-mode)
- [`proxy-ssh`](#heading--proxy-ssh)
- [`resource-tags`](#heading--resource-tags)
- [`secret-backend`](#heading--secret-backend)
- [`snap-http-proxy*`](#heading--snap-http-proxy)
- [`snap-https-proxy*`](#heading--snap-https-proxy)
- [`snap-store-assertions`](#heading--snap-store-assertions)
- [`snap-store-proxy*`](#heading--snap-store-proxy)
- [`snap-store-proxy-url`](#heading--snap-store-proxy-url)
- [`ssl-hostname-verification`](#heading--ssl-hostname-verification)
- [`storage-default-block-source`](#heading--storage-default-block-source)
- [`storage-default-filesystem-source`](#heading--storage-default-filesystem-source)
- [`transmit-vendor-metrics`](#heading--transmit-vendor-metrics)
- [`update-status-hook-interval`](#heading--update-status-hook-interval)	


<a href="#heading--cloud-specific-key"><h2 id="heading--cloud-specific-key">`<cloud-specific key>`</h2></a>

> See {ref}`List of supported clouds > `<cloud name>` > Cloud > definition <list-of-supported-clouds>` or run `juju show-cloud <cloud> --include-config`.


<a href="#heading--agent-metadata-url"><h2 id="heading--agent-metadata-url">`agent-metadata-url`</h2></a>

`agent-metadata-url` is the URL of the private stream.

**Type:** string

**Default value:** ""


<a href="#heading--agent-stream"><h2 id="heading--agent-stream">`agent-stream`</h2></a>

`agent-stream` is the version of Juju to use for deploy/upgrades.

**Type:** string

**Default value:** ""

**Valid values:** `released`, `devel`, `proposed`

<a href="#heading--agent-version"><h2 id="heading--agent-version">`agent-version`</h2></a>

`agent-version` is the desired Juju agent version to use.

> See more: {ref}`Agent <agent>`

**Type:** string

**Details:**

The `agent-stream` key specifies the "stream" to use when a Juju agent is to be installed or upgraded. This setting reflects the general stability of the software and defaults to 'released', indicating that only the latest stable version is to be used.

To run the upcoming stable release (before it has passed the normal QA process) you can set:

``` yaml
agent-stream: proposed
```

For testing purposes, you can use the latest unstable version by setting:

``` yaml
agent-stream: devel
```

The `agent-version` option specifies a "patch version" for the agent that is to be installed on a new controller relative to the Juju client's current major.minor version (Juju uses a major.minor.patch numbering scheme).

For example, Juju 2.3.2 means major version 2, minor version 3, and patch version 2. On a client system with this release of Juju installed, the machine agent's version for a newly-created controller would be the same. To specify a patch version of 1 (instead of 2), the following would be run:

``` text
juju bootstrap aws --agent-version='2.3.1'
```

If a patch version is available that is greater than that of the client then it can be targeted in this way:

``` text
juju bootstrap aws --auto-upgrade
```

<a href="#heading--apt-ftp-proxy"><h2 id="heading--apt-ftp-proxy">`apt-ftp-proxy*`</h2></a>

`apt-ftp-proxy*` is the APT FTP proxy for the model.

**Type:** string

**Default value:** ""

<a href="#heading--apt-http-proxy"><h2 id="heading--apt-http-proxy">`apt-http-proxy*`</h2></a>

`apt-http-proxy*` is the APT HTTP proxy for the model.

**Type:** string

**Default value:** ""


<a href="#heading--apt-https-proxy"><h2 id="heading--apt-https-proxy">`apt-https-proxy*`</h2></a>

`apt-https-proxy*` is the APT HTTPS proxy for the model.

**Type:** string

**Default value:** ""

<a href="#heading--apt-mirror"><h2 id="heading--apt-mirror">`apt-mirror`</h2></a>

`apt-mirror` is the APT mirror for the model.

**Type:** string

**Default value:** ""

**Details:**

The APT packaging system is used to install and upgrade software on machines provisioned in the model, and many charms also use APT to install software for the applications they deploy. It is possible to set a specific mirror for the APT packages to use, by setting 'apt-mirror':

``` text
juju model-config apt-mirror=http://archive.ubuntu.com/ubuntu/
```

To restore the default behaviour you would run:

``` text
juju model-config --reset apt-mirror
```

The `apt-mirror` option is often used to point to a local mirror. 

<a href="#heading--apt-no-proxy"><h2 id="heading--apt-no-proxy">`apt-no-proxy`</h2></a>


`apt-no-proxy` is the list of domain addresses not to be proxied for APT (comma-separated).

**Type:** string

**Default value:** ""

<a href="#heading--automatically-retry-hooks"><h2 id="heading--automatically-retry-hooks">`automatically-retry-hooks`</h2></a>

`automatically-retry-hooks` determines whether the uniter should automatically retry failed hooks.

**Type:** boolean

**Default value:** true

**Details:** 

Juju retries failed hooks automatically using an exponential backoff algorithm. They will be retried after 5, 10, 20, 40 seconds up to a period of 5 minutes, and then every 5 minutes. The logic behind this is that some hook errors are caused by timing issues or the temporary unavailability of other applications - automatic retry enables the Juju model to heal itself without troubling the user.

However, in some circumstances, such as debugging charms, this behaviour can be distracting and unwelcome. For this reason, it is possible to set the `automatically-retry-hooks` option to 'false' to disable this behaviour. In this case, users will have to manually retry any hook which fails, using the command above, as with earlier versions of Juju.

```{important}

Even with the automatic retry enabled, it is still possible to use the `juju resolved unit-name/#` command to retry manually.

```

<a href="#heading--backup-dir"><h2 id="heading--backup-dir">`backup-dir`</h2></a>

`backup-dir` is the directory used to store the backup working directory.

**Type:** string

**Default value:** "" 


<a href="#heading--charmhub-url"><h2 id="heading--charmhub-url">`charmhub-url`</h2></a>

`charmhub-url`  is the url for Charmhub API calls.

**Type:** 

**Default value:** [https://api.charmhub.io](https://api.charmhub.io)

<a href="#heading--cloudinit-userdata"><h2 id="heading--cloudinit-userdata">`cloudinit-userdata`</h2></a>

```{caution}

This is a sharp knife feature - be careful with it. 

```

`cloudinit-userdata` is the cloud-init user-data (in yaml format) to be added to userdata for new machines created in this model.

**Type:** string

**Default value:** ""

**Details:**

<!--It was added to Juju in version 2.3.1.-->


The `cloudinit-userdata` allows the user to provide additional cloudinit data to be included in the cloudinit data created by Juju.

Specifying a key will overwrite what juju puts in the cloudinit file with the following caveats: 
1. `users` and `bootcmd` keys will cause an error
2. The `packages` key will be appended to the packages listed by juju
3. The `runcmds` key will cause an error.  You can specify `preruncmd` and `postruncmd` keys to prepend and append the runcmd created by Juju.


### Use cases

- setting a default locale for deployments that wish to use their own locale settings
- adding custom CA certificates for models that are sitting behind an HTTPS proxy 
- adding a private apt mirror to enable private packages to be installed
- add SSH fingerprints to a deny list to prevent them from being printed to the console for security-focused deployments

### Background

Juju uses {ref}`cloud-init <7068md>` to customise instances once they have been provisioned by the cloud. The `cloudinit-userdata` model configuration setting (model config) allows you to tweak what happens to machines when they are created up via the "user data" feature.

From the website:

> ![cinit-logo|51x35](upload://ndGkV8MfQVYoMSYDu9OXQQAyVxK.png) 
>
> Cloud images are operating system templates and every instance starts out as an identical clone of every other instance. *It is the user data that gives every cloud instance its personality and cloud-init is the tool that applies user data to your instances automatically.*

### How-to

#### Provide custom user data to cloudinit

Create a file, `cloudinit-userdata.yaml`, which starts with the `cloudinit-userdata` key and data you wish to include in the cloudinit file.  Note: juju reads the value as a string, though formatted as YAML.

Template `cloudinit-userdata.yaml`:

```plain
cloudinit-userdata: |
    <key>: <value>
    <key>: <value>
```

Provide the path your file to the `model-config` command:


```plain
juju model-config --file cloudinit-userdata.yaml
```

#### Read the current setting

To read the current value, provide the `cloudinit-userdata` key to the `model-config` command as a command-line parameter. Adding the `--format yaml` option ensures that it is properly formatted.

```plain
juju model-config cloudinit-userdata --format yaml
```

Sample output:

    cloudinit-userdata: |
      packages:
        - 'python-keystoneclient'
        - 'python-glanceclient'

#### Clear the current custom user data

Use the `--reset` option to the `model-config` command to clear anything that has been previously set.

```plain
juju model-config --reset cloudinit-userdata
```

### Known issues

- custom cloudinit-userdata must be passed via file, not as options on the command line (like the `config` command)


<a href="#heading--container-image-metadata-url"><h2 id="heading--container-image-metadata-url">`container-image-metadata-url`</h2></a>

`container-image-metadata-url` is the URL at which the metadata used to locate container OS image ids is located.

**Type:** string

**Default value:** "

**Valid values:** url 

<a href="#heading--container-image-stream"><h2 id="heading--container-image-stream">`container-image-stream`</h2></a>

`container-image-stream`  is the simplestreams stream used to identify which image ids to search when starting a container.

**Type:** string

**Default value:** `released`

**Valid values:** url

<a href="#heading--container-inherit-properties"><h2 id="heading--container-inherit-properties">`container-inherit-properties`</h2></a>

`container-inherit-properties` is the list of properties to be copied from the host machine to new containers created in this model (comma-separated).

**Type:** string

**Default value:** ""

**Details:**

The `container-inherit-properties` key allows for a limited set of parameters enabled on a Juju machine to be inherited by any hosted containers (KVM guests or LXD containers). The machine and container must be running the same series.

```{important}

This key is only supported by the MAAS provider. 

```

The parameters are:

- apt-primary
- apt-security
- apt-sources
- ca-certs

For MAAS `v.2.5` or greater the parameters are:

- apt-sources
- ca-certs

For example:

```text
juju model-config container-inherit-properties="ca-certs, apt-sources"
```

<!--Old content of this doc. It seems to have been incorporated into the one above, copied from the list of model configs.


This key allows the user to specify cloudinit keys to be copied from host machines to containers on the host from the vendor files.

Included in juju 2.4-beta1 as of early Feb.

Using:
--
Caveats related to series: If using a Trusty machine, only Trusty containers will use this feature.  OS type must be the same between machine and container.

Allowed keys are: ca-certs, apt-primary, apt-security, apt-sources.  In xenial and other series (not trusty):
* apt-primary finds:
    apt:
      primary:
        …
* apt-security finds:
    apt:
      security:
        …
* apt-sources finds:
    apt:
      sources:
        …

In trusty apt-security is ignored (unless someone can provide a map):

* apt-primary finds:
    apt_mirror: ...
    apt_mirror_search: ...
    apt_mirror_search_dns: ...
* apt-sources finds:
    apt_sources: ...


`juju model-config container-inherit-properties=”ca-certs, apt-primary”`
-->

<a href="#heading--container-networking-method"><h2 id="heading--container-networking-method">`container-networking-method`</h2></a>

`container-networking-method` is the method of container networking setup - one of fan, provider, local.

**Type:** string

**Valid values:** `local`, `provider`, `fan`

<a href="#heading--default-base"><h2 id="heading--default-base">`default-base`</h2></a>

`default-base` is the default base image to use for deploying charms, will act like `--base` when deploying charms. 

**Type:** string

**Default value:** ""

<a href="#heading--default-space"><h2 id="heading--default-space">`default-space`</h2></a>

`default-space` is the default network space used for application endpoints in this model.

**Type:** string

**Default value:** ""

<a href="#heading--development"><h2 id="heading--development">`development`</h2></a>

`development` determines whether the model is in development mode.

**Type:** boolean

**Default value:** false

<a href="#heading--disable-network-management"><h2 id="heading--disable-network-management">`disable-network-management`</h2></a>

`disable-network-management` determines whether the provider should control networks (on MAAS models, set to true for MAAS to control networks).

**Type:** boolean

**Default value:** false

**Details:**

This key can only be used with MAAS models and should otherwise be set to 'false' (default) unless you want to take over network control from Juju because you have unique and well-defined needs. Setting this to 'true' with MAAS gives you the same behaviour with containers as you already have with other providers: one machine-local address on a single network interface, bridged to the default bridge.

<a href="#heading--disable-telemetry"><h2 id="heading--disable-telemetry">`disable-telemetry`</h2></a>

`disable-telemetry` disables telemetry reporting of model information.

**Type:** boolean

**Default value:** false

<a href="#heading--egress-subnets"><h2 id="heading--egress-subnets">`egress-subnets`</h2></a>

`egress-subnets` is the source address(es) for traffic originating from this model.

**Type:** string

**Default value:** ""

<a href="#heading--enable-os-refresh-update"><h2 id="heading--enable-os-refresh-update">`enable-os-refresh-update`</h2></a>

`enable-os-refresh-update` determines whether newly provisioned instances should run their respective OS's update capability.

**Type:** boolean

**Default value:** true

**Details:**

When Juju provisions a machine, its default behaviour is to upgrade existing packages to their latest version. If your OS images are fresh and/or your deployed applications do not require the latest package versions, you can disable upgrades in order to provision machines faster.

Two boolean configuration options are available to disable APT updates and upgrades: `enable-os-refresh-update` (apt update) and `enable-os-upgrade` (apt upgrade), respectively.

``` yaml
enable-os-refresh-update: false
enable-os-upgrade: false
```

You may also want to just update the package list to ensure a charm has the latest software available to it by disabling upgrades but enabling updates.

<a href="#heading--enable-os-upgrade"><h2 id="heading--enable-os-upgrade">`enable-os-upgrade`</h2></a>

`enable-os-upgrade` determines whether newly provisioned instances should run their respective OS's upgrade capability.

**Type:** boolean

**Default value:** true

**Details:** 

When Juju provisions a machine, its default behaviour is to upgrade existing packages to their latest version. If your OS images are fresh and/or your deployed applications do not require the latest package versions, you can disable upgrades in order to provision machines faster.

Two Boolean configuration options are available to disable APT updates and upgrades: `enable-os-refresh-update` (apt update) and `enable-os-upgrade` (apt upgrade), respectively.

``` yaml
enable-os-refresh-update: false
enable-os-upgrade: false
```

You may also want to just update the package list to ensure a charm has the latest software available to it by disabling upgrades but enabling updates.

<a href="#heading--fan-config"><h2 id="heading--fan-config">`fan-config`</h2></a>

`fan-config`  is the configuration for fan networking for this model.

**Type:** string

**Default value:** ""

**Valid values:** `overlay_CIDR<par>=<par>underlay_CIDR`


<a href="#heading--firewall-mode"><h2 id="heading--firewall-mode">`firewall-mode`</h2></a>

`firewall-mode` is the mode to use for network firewalling. It's useful for clouds without support for either global or per instance security groups.

**Type:** string

**Default value:** `instance`

**Valid values:** `instance`, `global`, `none`. `instance` requests the use of an individual firewall per instance; `global` uses a single firewall for all instances (access for a network port is enabled to one instance if any instance requires that port); `none` requests that no firewalling should be performed inside the model. 

<a href="#heading--ftp-proxy"><h2 id="heading--ftp-proxy">`ftp-proxy*`</h2></a>

`ftp-proxy*` is the FTP proxy value to configure on instances, in the `FTP_PROXY` environment variable.

**Type:** string

**Default value:** ""

**Valid values:** url


<a href="#heading--http-proxy"><h2 id="heading--http-proxy">`http-proxy*`</h2></a>

`http-proxy*`  is the HTTP proxy value to configure on instances, in the `HTTP_PROXY` environment variable.

**Type:** string

**Default value:** ""

**Valid values:** url


<a href="#heading--https-proxy"><h2 id="heading--https-proxy">`https-proxy*`</h2></a>

`https-proxy*`  is the HTTPS proxy value to configure on instances, in the `HTTPS_PROXY` environment variable.

**Type:** string

**Default value:** ""

**Valid values:** url


<a href="#heading--ignore-machine-addresses"><h2 id="heading--ignore-machine-addresses">`ignore-machine-addresses`</h2></a>

`ignore-machine-addresses` determines whether the machine worker should discover machine addresses on startup.

**Type:** boolean

**Default value:** false

**Valid values:**


<a href="#heading--image-metadata-url"><h2 id="heading--image-metadata-url">`image-metadata-url`</h2></a>

`image-metadata-url` is the URL at which the metadata used to locate OS image ids is located.

**Type:** string

**Default value:** ""

**Valid values:** url


<a href="#heading--image-stream"><h2 id="heading--image-stream">`image-stream`</h2></a>

`image-stream` is the simplestreams stream used to identify which image ids to search when starting an instance.

**Type:** string

**Default value:** `released

**Details:**

Juju, by default, uses the slow-changing 'released' images when provisioning machines. However, the `image-stream` option can be set to 'daily' to use more up-to-date images, thus shortening the time it takes to perform APT package upgrades.

<a href="#heading--juju-ftp-proxy"><h2 id="heading--juju-ftp-proxy">`juju-ftp-proxy*`</h2></a>

`juju-ftp-proxy*` is the FTP proxy value to pass to charms in the `JUJU_CHARM_FTP_PROXY` environment variable.

**Type:** string

**Default value:** ""

<a href="#heading--juju-http-proxy"><h2 id="heading--juju-http-proxy">`juju-http-proxy*`</h2></a>


`juju-http-proxy*` is the HTTP proxy value to pass to charms in the `JUJU_CHARM_HTTP_PROXY` environment variable.

**Type:** string

**Default value:** ""


<a href="#heading--juju-https-proxy"><h2 id="heading--juju-https-proxy">`juju-https-proxy*`</h2></a>

`juju-https-proxy*` is the HTTPS proxy value to pass to charms in the `JUJU_CHARM_HTTPS_PROXY` environment variable.

**Type:** string

**Default value:** ""

<a href="#heading--juju-no-proxy"><h2 id="heading--juju-no-proxy">`juju-no-proxy*`</h2></a>

`juju-no-proxy*` is the list of domain addresses not to be proxied (comma-separated), may contain CIDRs. Passed to charms in the `JUJU_CHARM_NO_PROXY` environment variable.

**Type:** string

**Default value:** `127.0.0.1,localhost,::1`

**Valid values:**


<a href="#heading--logforward-enabled"><h2 id="heading--logforward-enabled">`logforward-enabled`</h2></a>

`logforward-enabled` determines whether syslog forwarding is enabled.

**Type:** boolean

**Default value:** false


<a href="#heading--logging-config"><h2 id="heading--logging-config">`logging-config`</h2></a>

`logging-config` is the configuration string to use when configuring Juju agent logging (see [this link](http://godoc.org/github.com/juju/loggo#ParseConfigurationString) for details).

**Type:** string

**Value:** A (list of semicolon-separated) `<filter>=<verbosity level>` pairs, 

where `<filter>` can be any of the following:

- `<root>` - matches all machine agent logs
- `unit` - matches all unit agent logs
- a module name, e.g. `juju.worker.apiserver`
<br><br>
A module represents a single component of Juju, e.g. a {ref}`worker <worker>`. Generally, modules correspond one-to-one with Go packages in the Juju source tree. The module name is the value passed to `loggo.GetLogger` or `loggo.GetLoggerWithLabels`.
<br><br>
Modules have a nested tree structure - for example, the `juju.api` module includes submodules `juju.api.application`, `juju.api.cloud`, etc. `<root>` is the root of this module tree.

- a label, e.g. `#charmhub` 
<br><br>
*Labels* cut across the module tree, grouping various modules which deal with a certain feature or information flow. For example, the `#charmhub` label includes all modules involved in making a request to Charmhub.
<br><br>
The currently supported labels are:

| Label | Description |
|-|-|
| `#http` | HTTP requests |
| `#metrics` | Metric outputs - use as a fallback when Prometheus isn't available |
| `#charmhub` | Charmhub client and callers. |
| `#cmr` | Cross model relations |
| `#cmr-auth` | Authentication for cross model relations |
| `#secrets` | Juju secrets |

> See more: [https://github.com/juju/juju/blob/main/core/logger/labels.go](https://github.com/juju/juju/blob/main/core/logger/labels.go)

and where `<verbosity level>` can be, in decreasing order of severity:

| Level | Description |
|-|-|
| `CRITICAL` | Indicates a severe failure which could bring down the system. |
| `ERROR` | Indicates failure to complete a routine operation.
| `WARNING` | Indicates something is not as expected, but this is not necessarily going to cause an error.
| `INFO` | A regular log message intended for the user.
| `DEBUG` | Information intended to assist developers in debugging.
| `TRACE` | The lowest level - includes the full details of input args, return values, HTTP requests sent/received, etc. |

When you set `logging-config` to `module=level`, then Juju saves that module's logs for the given severity level **and above.** For example, setting `logging-config` to `juju.worker.uniter=WARNING` will capture all `CRITICAL`, `ERROR` and `WARNING` logs for the uniter, but discard logs for lower severity levels (`INFO`, `DEBUG`, `TRACE`).


> See more: [https://github.com/juju/loggo/blob/master/level.go#L13](https://github.com/juju/loggo/blob/master/level.go#L13)

**Examples:**

To collect debug logs for the `dbaccessor` worker:
```
juju model-config -m controller logging-config="juju.worker.dbaccessor=DEBUG"
```

To collect debug logs for the `mysql/0` unit:
```
juju model-config -m foo logging-config="unit.mysql/0=DEBUG"
```

To collect trace logs for Charmhub requests:
```
juju model-config -m controller logging-config="#charmhub=TRACE"
```

To see what API requests are being made:

```text
juju model-config -m controller logging-config="juju.apiserver=DEBUG"
```

To view details about each API request:

```text
juju model-config -m controller logging-config="juju.apiserver=TRACE"
```


<a href="#heading--logging-output"><h2 id="heading--logging-output">`logging-output`</h2></a>

`logging-output` is the logging output destination: database and/or syslog.

**Type:** string

**Default value:** ""

**Valid values:** 

<a href="#heading--lxd-snap-channel"><h2 id="heading--lxd-snap-channel">`lxd-snap-channel`</h2></a>


`lxd-snap-channel` is the  channel to use when installing LXD from a snap (cosmic and later).

**Type:** string

**Valid values:** `latest`, `stable`

<a href="#heading--max-action-results-age"><h2 id="heading--max-action-results-age">`max-action-results-age`</h2></a>

`max-action-results-age` is the maximum age for action entries before they are pruned, in human-readable time format.

**Default value:** 336h

<a href="#heading--max-action-results-size"><h2 id="heading--max-action-results-size">`max-action-results-size`</h2></a>

`max-action-results-size` is the maximum size for the action collection, in human-readable memory format.

**Default value:** 5G

<a href="#heading--max-status-history-age"><h2 id="heading--max-status-history-age">`max-status-history-age`</h2></a>

`max-status-history-age` the maximum age for status history entries before they are pruned, in human-readable time format.

**Type:** string

**Default value:** 336h

**Valid values:** 72h, etc.


<a href="#heading--max-status-history-size"><h2 id="heading--max-status-history-size">`max-status-history-size`</h2></a>

`max-status-history-size` is the maximum size for the status history collection, in human-readable memory format.

**Type:** string

**Default value:** 5G

**Valid values:** 400M, 5G, etc.


<a href="#heading--net-bond-reconfigure-delay"><h2 id="heading--net-bond-reconfigure-delay">`net-bond-reconfigure-delay`</h2></a>

`net-bond-reconfigure-delay` is the amount of time in seconds to sleep between ifdown and ifup when bridging.

**Default value:** 17


<a href="#heading--no-proxy"><h2 id="heading--no-proxy">`no-proxy*`</h2></a>

`no-proxy*` is the list of domain addresses not to be proxied (comma-separated).

**Type:** string

**Default value:** `127.0.0.1,localhost,::1`

<a href="#heading--num-container-provision-workers"><h2 id="heading--num-container-provision-workers">`num-container-provision-workers`</h2></a>

`num-container-provision-workers` is the number of container provisioning workers to use per machine.

**Default value:** 4


<a href="#heading--num-provision-workers"><h2 id="heading--num-provision-workers">`num-provision-workers`</h2></a>

`num-provision-workers` is the number of provisioning workers to use per model.

**Default value:** 16


<a href="#heading--provisioner-harvest-mode"><h2 id="heading--provisioner-harvest-mode">`provisioner-harvest-mode`</h2></a>

`provisioner-harvest-mode` sets what to do with unknown machines (default destroyed).

**Type:** string

**Default value:** `destroyed`

**Valid values:** `all`, `none`, `unknown`, `destroyed`

**Details:**

Juju keeps state on the running model and it can harvest (remove) machines which it deems are no longer required. This can help reduce running costs and keep the model tidy. Harvesting is guided by what "harvesting mode" has been set.

A Juju machine can be in one of four states:

-   **Alive:** The machine is running and being used.
-   **Dying:** The machine is in the process of being terminated by Juju, but hasn't yet finished.
-   **Dead:** The machine has been successfully brought down by Juju, but is still being tracked for removal.
-   **Unknown:** The machine exists, but Juju knows nothing about it.

Juju can be in one of several harvesting modes, in order of most conservative to most aggressive:

-   **none:** Machines will never be harvested. This is a good choice if machines are managed via a process outside of Juju.
-   **destroyed:** Machines will be harvested if i) Juju "knows" about them and

ii) they are 'Dead'. - **unknown:** Machines will be harvested if Juju does not "know" about them ('Unknown' state). Use with caution in a mixed environment or one which may contain multiple instances of Juju. - **all:** Machines will be harvested if Juju considers them to be 'destroyed' or 'unknown'.

The default mode is **destroyed**.

Below, the harvest mode key for the current model is set to 'none':

``` text
juju model-config provisioner-harvest-mode=none
```


<a href="#heading--proxy-ssh"><h2 id="heading--proxy-ssh">`proxy-ssh`</h2></a>

`proxy-ssh` determines whether SSH commands should be proxied through the API server.

**Type:** boolean

**Default value:** false


<a href="#heading--resource-tags"><h2 id="heading--resource-tags">`resource-tags`</h2></a>

`resource-tags` is a space-separated list of key=value pairs used to apply as tags on supported cloud models.

**Type:** string

**Default value:** none


<a href="#heading--secret-backend"><h2 id="heading--secret-backend">`secret-backend`</h2></a>

`secret-backend` is the name of the secret store backend. 

**Type:** string

**Default value:** `auto`

**Valid values:** `internal`, `auto`, `<>backend name`

<a href="#heading--snap-http-proxy"><h2 id="heading--snap-http-proxy">`snap-http-proxy*`</h2></a>


`snap-http-proxy*`  is the HTTP proxy value to for installing snaps.

**Type:** string

**Default value:** ""


<a href="#heading--snap-https-proxy"><h2 id="heading--snap-https-proxy">`snap-https-proxy*`</h2></a>

`snap-https-proxy*` is the snap-centric HTTPS proxy value. See {ref}`Offline mode strategies <7068md>`.

**Type:** string

**Default value:** ""

<a href="#heading--snap-store-assertions"><h2 id="heading--snap-store-assertions">`snap-store-assertions`</h2></a>


`snap-store-assertions` is the HTTPS proxy value to for installing snaps.
**Type:** string

**Default value:** ""


<a href="#heading--snap-store-proxy"><h2 id="heading--snap-store-proxy">`snap-store-proxy*`</h2></a>

`snap-store-proxy*` is the snap store proxy for installing snaps.

**Type:** string

**Default value:** ""

<a href="#heading--snap-store-proxy-url"><h2 id="heading--snap-store-proxy-url">`snap-store-proxy-url`</h2></a>

`snap-store-proxy-url` is the URL for the defined snap store proxy.

**Type:** string

**Default value:** ""


<a href="#heading--ssl-hostname-verification"><h2 id="heading--ssl-hostname-verification">`ssl-hostname-verification`</h2></a>

`ssl-hostname-verification` determines whether SSL hostname verification is enabled.

**Type:** boolean

**Default value:** true


<a href="#heading--storage-default-block-source"><h2 id="heading--storage-default-block-source">`storage-default-block-source`</h2></a>

`storage-default-block-source`is the default block storage source for the model.

**Type:** string

**Default value:** -

**Valid values:** `loop` or the cloud-specific value


<a href="#heading--storage-default-filesystem-source"><h2 id="heading--storage-default-filesystem-source">`storage-default-filesystem-source`</h2></a>

`storage-default-filesystem-source` is the default filesystem storage source for the model.

**Type:** string

**Default value:** -

**Valid values:** any storage provider (Juju will adjust)


<a href="#heading--transmit-vendor-metrics"><h2 id="heading--transmit-vendor-metrics">`transmit-vendor-metrics`</h2></a>

`transmit-vendor-metrics` determines whether metrics declared by charms deployed into this model are sent for anonymized aggregate analytics.

**Type:** boolean

**Default value:** true

<a href="#heading--update-status-hook-interval"><h2 id="heading--update-status-hook-interval">`update-status-hook-interval`</h2></a>

`update-status-hook-interval` sets how often to run the charm update-status hook, in human-readable time format (default 5m, range 1-60m).

**Type:** string

**Default value:** 5m

**Valid values:** 30s, 6m, 1hr, etc.

<br> 

**<small>Contributors:** @bcarbone, @bran-castillo, @brian-murray, @holmanb<small/>