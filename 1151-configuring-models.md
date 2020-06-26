<!--
Todo:
- Check accuracy of key table
- Confirm 'all' harvest mode state. Seems it should be "'Dead' or
- 'Unknown'" OR "a combination of modes 'destroyed' and 'unknown'".
- Provide an example yaml file in a model-config or model-defaults context
- Re yaml files, which takes precedence? CLI-specified or file?
-->

A model's configuration influences all the machines residing within it and, in turn, the applications that get deployed onto those machines. It is therefore a very powerful feature to be able to configure at the model level. Model configuration consists of a collection of keys and their respective values. An explanation of how to both view and set these key:value pairs is provided below. Notable examples are provided at the end.

<h2 id="heading--getting-and-setting-values">Getting and setting values</h2>

You can display the current model settings by running the command:

``` text
juju model-config
```

This will include all the currently set key values - whether they were set by you, inherited as a default value or dynamically set by Juju.

A key's value may be set for the current model using the same command:

``` text
juju model-config no-proxy=jujucharms.com
```

It is also possible to specify a list of key-value pairs:

``` text
juju model-config test-mode=true enable-os-upgrade=false
```

[note]
Juju does not currently check that the provided key is a valid setting, so make sure you spell it correctly.
[/note]

To set a null value:

``` text
juju model-config apt-mirror=""
```

To return a value to the default setting the `--reset` flag is used, along with the key name:

``` text
juju model-config --reset test-mode
```

After deployment, the `model-defaults` command allows a user to display the configuration values for a model as well as set default values that all **new** models will use. These values can even be specified for each cloud region instead of just the controller.

To set a default value for 'ftp-proxy', for instance, you would enter the following:

``` text
juju model-defaults ftp-proxy=10.0.0.1:8000
```

To see both the default values and what they've been changed to, you would use:

``` text
juju model-defaults
```

To set default values for all new models in a specific controller region, state the region in the command, shown here using the same example settings as our previous `model-config` key-value pairs example above:

``` text
juju model-defaults us-east-1 test-mode=true enable-os-upgrade=false
```

Model settings can also be made when creating a new controller via either the `--config` or `--model-default` options. The difference being that `--config` affects just the 'controller' and 'default' models while `--model-default` affects **all** models, including any future ones. Below we use the `--config` option:

``` text
juju bootstrap --config image-stream=daily localhost lxd-daily
```

See [Creating a controller](/t/creating-a-controller/1108) for in-depth coverage on how to create a controller.

Note that these defaults can be overridden, on a per-model basis, during the invocation of the `add-model` command (option `--config`) as well as by resetting specific options to their original defaults through the use of the `model-config` command (option `--reset`).

Both the `model-config` and `model-defaults` commands can read key value pairs from a YAML-formatted file. For example:

``` text
juju model-config no-proxy=jujucharms.com more-config-values.yaml
```

<h2 id="heading--list-of-model-keys">List of model keys</h2>

The table below lists all the model keys which may be assigned a value. Some of these keys deserve further explanation. These are explored in the sections below the table.

<table>
<colgroup>
<col width="32%" />
<col width="10%" />
<col width="12%" />
<col width="32%" />
<col width="12%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Key</th>
<th>Type</th>
<th>Default</th>
<th>Valid values</th>
<th align="left">Purpose</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">agent-metadata-url</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The URL of the private stream.</td>
</tr>
<tr class="even">
<td align="left">agent-stream</td>
<td>string</td>
<td>released</td>
<td>released/devel/proposed</td>
<td align="left">The stream to use for deploy/upgrades of agents. See <a
href="#heading--agent-versions-and-streams">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">agent-version</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The patch number to use for agents. See <a href="#heading--agent-versions-and-streams">additional info below</a>.</td>
</tr>
<tr class="even">
<td align="left">apt-ftp-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The APT FTP proxy for the model. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">apt-http-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The APT HTTP proxy for the model. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="even">
<td align="left">apt-https-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The APT HTTPS proxy for the model. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">apt-mirror</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The APT mirror for the model. See <a href="#heading--apt-mirror">additional info below</a>.</td>
</tr>
<tr class="even">
<td align="left">automatically-retry-hooks</td>
<td>bool</td>
<td>true</td>
<td></td>
<td align="left">Set the policy on retying failed hooks. See <a href="#heading--retrying-failed-hooks">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">container-image-metadata-url</td>
<td>string</td>
<td></td>
<td>url</td>
<td align="left">Corresponds to 'image-metadata-url' (see below) for cloud-hosted KVM guests or LXD containers. Not needed for the localhost cloud.</td>
</tr>
<tr class="even">
<td align="left">container-image-stream</td>
<td>string</td>
<td></td>
<td>url</td>
<td align="left">Corresponds to 'image-stream' (see below) for cloud-hosted KVM guests or LXD containers. Not needed for the localhost cloud.</td>
</tr>
<tr class="odd">
<td align="left">container-inherit-properties</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">Set parameters to be inherited from a machine to its
hosted containers (KVM or LXD). See <a href="#heading--container-inheritance">additional info below</a>.</td>
</tr>
<tr class="even">
<td align="left">container-networking-method</td>
<td>string</td>
<td></td>
<td>local/provider/fan</td>
<td align="left">The FAN networking mode to use. Default values can be provider-specific.</td>
</tr>
<tr class="odd">
<td align="left">datastore</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">A vSphere datastore name.</td>
</tr>
<tr class="odd">
<td align="left">default-series</td>
<td>string</td>
<td></td>
<td>valid series name, e.g. 'xenial'</td>
<td align="left">The default series of Ubuntu to use for deploying charms.</td>
</tr>
<tr class="even">
<td align="left">development</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Set whether the model is in development mode.</td>
</tr>
<tr class="odd">
<td align="left">disable-network-management</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Set whether to give network control to the provider instead of Juju controlling configuration. See <a href="#heading--disable-network-management">additional info below</a>.</td>
</tr>
<tr class="even">
<td align="left">enable-os-refresh-update</td>
<td>bool</td>
<td>true</td>
<td></td>
<td align="left">Set whether newly provisioned instances should run their respective OS's update capability. See <a href="#heading--apt-updates-and-upgrades-with-faster-machine-provisioning">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">enable-os-upgrade</td>
<td>bool</td>
<td>true</td>
<td></td>
<td align="left">Set whether newly provisioned instances should run their respective OS's upgrade capability. See <a href="#heading--apt-updates-and-upgrades-with-faster-machine-provisioning">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">external-network</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">A vSphere external network name.</td>
</tr>
<tr class="even">
<td align="left">extra-info</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">This is a string to store any user-desired additional metadata.</td>
</tr>
<tr class="odd">
<td align="left">fan-config</td>
<td>string</td>
<td></td>
<td>overlay_CIDR=underlay_CIDR</td>
<td align="left">The FAN overlay and underlay networks in CIDR notation (space-separated).</td>
</tr>
<tr class="even">
<td align="left">firewall-mode</td>
<td>string</td>
<td>instance</td>
<td>instance/global/none</td>
<td align="left">The mode to use for network firewalling. See <a href="#heading--firewall-mode">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">ftp-proxy</td>
<td>string</td>
<td></td>
<td>url</td>
<td align="left">The FTP proxy value to configure on instances, in the FTP_PROXY environment variable. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="even">
<td align="left">http-proxy</td>
<td>string</td>
<td></td>
<td>url</td>
<td align="left">The HTTP proxy value to configure on instances, in the HTTP_PROXY environment variable. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">https-proxy</td>
<td>string</td>
<td></td>
<td>url</td>
<td align="left">The HTTPS proxy value to configure on instances, in the HTTPS_PROXY environment variable. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="even">
<td align="left">juju-ftp-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The charm-centric FTP proxy value. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">juju-http-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The charm-centric HTTP proxy value. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="even">
<td align="left">juju-https-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The charm-centric HTTPS proxy value. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">juju-no-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The charm-centric no-proxy value. CIDR notation supported. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="even">
<td align="left">ignore-machine-addresses</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">When true, the machine worker will not look up or discover any machine addresses.</td>
</tr>
<tr class="odd">
<td align="left">image-metadata-url</td>
<td>string</td>
<td></td>
<td>url</td>
<td align="left">The URL at which the metadata used to locate OS image ids is located.</td>
</tr>
<tr class="even">
<td align="left">image-stream</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The simplestreams stream used to identify which image ids to search when starting an instance. See <a href="#heading--image-streams">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">logforward-enabled</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Set whether the log forward function is enabled.</td>
</tr>
<tr class="even">
<td align="left">logging-config</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The configuration string to use when configuring Juju agent logging (see <a href="https://godoc.org/github.com/juju/loggo#ParseConfigString">this link</a> for details).</td>
</tr>
<tr class="odd">
<td align="left">max-status-history-age</td>
<td>string</td>
<td></td>
<td>72h, etc.</td>
<td align="left">The maximum age for status history entries before they are pruned, in a human-readable time format.</td>
</tr>
<tr class="even">
<td align="left">max-status-history-size</td>
<td>string</td>
<td></td>
<td>400M, 5G, etc.</td>
<td align="left">The maximum size for the status history collection, in human-readable memory format.</td>
</tr>
<tr class="odd">
<td align="left">no-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">List of domain addresses not to be proxied (comma-separated). See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">primary-network</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">A vSphere primary network name.</td>
</tr>
<tr class="even">
<td align="left">provisioner-harvest-mode</td>
<td>string</td>
<td>destroyed</td>
<td>all/none/unknown/destroyed</td>
<td align="left">Set what to do with unknown machines. See <a href="#heading--juju-lifecycle-and-harvesting">additional info below</a>.</td>
</tr>
<tr class="odd">
<td align="left">proxy-ssh</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Set whether SSH commands should be proxied through the API server.</td>
</tr>
<tr class="even">
<td align="left">resource-tags</td>
<td>string</td>
<td>none</td>
<td></td>
<td align="left">A space-separated list of key=value pairs used to apply as tags on supported cloud models.</td>
</tr>
<tr class="odd">
<td align="left">snap-http-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The snap-centric HTTP proxy value. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="even">
<td align="left">snap-https-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The snap-centric HTTPS proxy value. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">snap-store-assertions</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The collection of snap store assertions. Each entry should contain the snap store ID.</td>
</tr>
<tr class="even">
<td align="left">snap-store-proxy</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The snap store ID. See <a href="/t/offline-mode-strategies/1071">Offline mode strategies</a>.</td>
</tr>
<tr class="odd">
<td align="left">ssl-hostname-verification</td>
<td>bool</td>
<td>true</td>
<td></td>
<td align="left">Set whether SSL hostname verification is enabled.</td>
</tr>
<tr class="even">
<td align="left">test-mode</td>
<td>bool</td>
<td>false</td>
<td></td>
<td align="left">Set whether the model is intended for testing. If true, accessing the charm store does not affect statistical data of the store.</td>
</tr>
<tr class="odd">
<td align="left">transmit-vendor-metrics</td>
<td>bool</td>
<td>true</td>
<td></td>
<td align="left">Set whether the controller will send metrics collected from this model for use in anonymized aggregate analytics.</td>
</tr>
<tr class="even">
<td align="left">update-status-hook-interval</td>
<td>string</td>
<td>5m</td>
<td>30s, 6m, 1hr, etc.</td>
<td align="left">The run frequency of the update-status hook. The value has a random +/- 20% offset applied to avoid hooks for all units firing at once. Value change only honoured during controller and model creation (<code>bootstrap --config</code> and <code>add-model --config</code>).</td>
</tr>
<tr class="odd">
<td align="left">vpc-id</td>
<td>string</td>
<td></td>
<td></td>
<td align="left">The virtual private cloud (VPC) ID for use when configuring a new model to be deployed to a specific VPC during <code>add-model</code>.</td>
</tr>
</tbody>
</table>

<h3 id="heading--apt-mirror">APT mirror</h3>

The APT packaging system is used to install and upgrade software on machines provisioned in the model, and many charms also use APT to install software for the applications they deploy. It is possible to set a specific mirror for the APT packages to use, by setting 'apt-mirror':

``` text
juju model-config apt-mirror=http://archive.ubuntu.com/ubuntu/
```

To restore the default behaviour you would run:

``` text
juju model-config --reset apt-mirror
```

The `apt-mirror` option is often used to point to a local mirror. The [Working offline](/t/working-offline/1072) page covers mirrors, proxies, and other aspects related to network-restricted environments.

<h3 id="heading--apt-updates-and-upgrades-with-faster-machine-provisioning">APT updates and upgrades with faster machine provisioning</h3>

When Juju provisions a machine, its default behaviour is to upgrade existing packages to their latest version. If your OS images are fresh and/or your deployed applications do not require the latest package versions, you can disable upgrades in order to provision machines faster.

Two Boolean configuration options are available to disable APT updates and upgrades: `enable-os-refresh-update` (apt update) and `enable-os-upgrade` (apt upgrade), respectively.

``` yaml
enable-os-refresh-update: false
enable-os-upgrade: false
```

You may also want to just update the package list to ensure a charm has the latest software available to it by disabling upgrades but enabling updates.

<h3 id="heading--disable-network-management">Disable network management</h3>

This can only be used with MAAS models and should otherwise be set to 'false' (default) unless you want to take over network control from Juju because you have unique and well-defined needs. Setting this to 'true' with MAAS gives you the same behaviour with containers as you already have with other providers: one machine-local address on a single network interface, bridged to the default bridge.

<h3 id="heading--firewall-mode">Firewall mode</h3>

Modes available include:

-   **instance:** Requests the use of an individual firewall per instance.
-   **global:** Uses a single firewall for all instances (access for a network port is enabled to one instance if any instance requires that port).
-   **none:** Requests that no firewalling should be performed inside the model, which is useful for clouds without support for either global or per instance security groups.

<h3 id="heading--juju-lifecycle-and-harvesting">Juju lifecycle and harvesting</h3>

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

<h3 id="heading--retrying-failed-hooks">Retrying failed hooks</h3>

Juju retries failed hooks automatically using an exponential backoff algorithm. They will be retried after 5, 10, 20, 40 seconds up to a period of 5 minutes, and then every 5 minutes. The logic behind this is that some hook errors are caused by timing issues or the temporary unavailability of other applications - automatic retry enables the Juju model to heal itself without troubling the user.

However, in some circumstances, such as debugging charms, this behaviour can be distracting and unwelcome. For this reason, it is possible to set the `automatically-retry-hooks` option to 'false' to disable this behaviour. In this case, users will have to manually retry any hook which fails, using the command above, as with earlier versions of Juju.

[note]
Even with the automatic retry enabled, it is still possible to use the `juju resolved unit-name/#` command to retry manually.
[/note]

<h3 id="heading--image-streams">Image streams</h3>

Juju, by default, uses the slow-changing 'released' images when provisioning machines. However, the `image-stream` option can be set to 'daily' to use more up-to-date images, thus shortening the time it takes to perform APT package upgrades.

<h3 id="heading--agent-versions-and-streams">Agent versions and streams</h3>

A full definition of an agent is provided on the [Concepts and terms](/t/concepts-and-terms/1144#heading--agent) page.

The `agent-stream` option specifies the "stream" to use when a Juju agent is to be installed or upgraded. This setting reflects the general stability of the software and defaults to 'released', indicating that only the latest stable version is to be used.

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

<h3 id="heading--container-inheritance">Container inheritance</h3>

The `container-inherit-properties` key allows for a limited set of parameters
enabled on a Juju machine to be inherited by any hosted containers (KVM guests
or LXD containers). The machine and container must be running the same series.

[note]
This key is only supported by the MAAS provider. 
[/note]

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
