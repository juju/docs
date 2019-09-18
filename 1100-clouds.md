<!--
TODO

- Bug tracking: https://bugs.launchpad.net/juju/+bug/1749302
- Bug tracking: https://bugs.launchpad.net/juju/+bug/1749583
- INFO: Auth types found at ~/.local/share/juju/public-clouds.yaml
- There is contention whether access-key can be used with keystone v3 (see https://github.com/juju/docs/issues/2868)
-->

Juju supports a wide variety of clouds. In addition, many of these are known to Juju out of the box. The remaining supported clouds do need to be added to Juju, and, as will be shown, it is simply done.

Once your cloud is known to Juju, whether by default or due to it being added, the next step is to add your cloud credentials to Juju. The exception is for a local LXD cloud; credentials are added automatically.

This rest of this page covers general cloud management and an overview of how clouds are added. However, you can get started right away by selecting your cloud here:

- [Amazon AWS](/t/using-amazon-aws-with-juju/1084) *
- [Microsoft Azure](/t/using-microsoft-azure-with-juju/1086) *
- [Google GCE](/t/using-google-gce-with-juju/1088) *
- [Oracle](/t/using-oracle-oci-with-juju/1096) *
- [Rackspace](/t/using-rackspace-with-juju/1098) *
- [Joyent](/t/using-joyent-with-juju/1089) *
- [LXD](/t/using-lxd-with-juju/1093) (local) *
- [LXD](/t/using-lxd-with-juju/1093) (remote)
- [Kubernetes](/t/using-kubernetes-with-juju/1090)
- [VMware vSphere](/t/using-vmware-vsphere-with-juju/1099)
- [OpenStack](/t/using-openstack-with-juju/1097)
- [MAAS](/t/using-maas-with-juju/1094)
- [Manual](/t/using-the-manual-cloud-with-juju/1095)

Those clouds known to Juju out of the box are denoted by an asterisk (*).

<h2 id="heading--general-cloud-management">General cloud management</h2>

To get the list of clouds that the client is aware of use the `clouds` command:

```text
juju clouds --local
```

This will return a list very similar to:

```text
Cloud           Regions  Default          Type        Description
aws                  15  us-east-1        ec2         Amazon Web Services
aws-china             2  cn-north-1       ec2         Amazon China
aws-gov               1  us-gov-west-1    ec2         Amazon (USA Government)
azure                27  centralus        azure       Microsoft Azure
azure-china           2  chinaeast        azure       Microsoft Azure China
cloudsigma           12  dub              cloudsigma  CloudSigma Cloud
google               18  us-east1         gce         Google Cloud Platform
joyent                6  us-east-1        joyent      Joyent Cloud
oracle                4  us-phoenix-1     oci         Oracle Cloud Infrastructure
oracle-classic        5  uscom-central-1  oracle      Oracle Cloud Infrastructure Classic
rackspace             6  dfw              rackspace   Rackspace Cloud
localhost             1  localhost        lxd         LXD Container Hypervisor
```

[note]
In versions prior to `v.2.6.1` the `clouds` command only operates locally (there is no `--local` option).
[/note]

Each line represents a cloud that Juju can interact with. It gives the cloud name, the number of cloud regions Juju is aware of, the default region (for the current Juju client), the type/API used to control it, and a brief description.

[note]
The cloud name (e.g. 'aws', 'localhost') is what you will use in any subsequent commands to refer to a cloud.
[/note]

To see which regions Juju is aware of for any given cloud use the `regions` command. For the 'aws' cloud then:

```text
juju regions aws
```

This returns a list like this:

``` text
us-east-1
us-east-2
us-west-1
us-west-2
ca-central-1
eu-west-1
eu-west-2
eu-central-1
ap-south-1
ap-southeast-1
ap-southeast-2
ap-northeast-1
ap-northeast-2
sa-east-1
```

To change the default region for a cloud:

```text
juju set-default-region aws eu-central-1
```

You can also specify a region to use when [Creating a controller](/t/creating-a-controller/1108).

To get more detail about a particular cloud:

```text
juju show-cloud --local azure
```

[note]
In versions prior to `v.2.6.1` the `show-cloud` command only operates locally (there is no `--local` option).
[/note]

To learn of any special features a cloud may support the `--include-config` option can be used with `show-cloud`. These can then be passed to either of the `bootstrap` or the `add-model` commands. See [Passing a cloud-specific setting](/t/creating-a-controller/1108#heading--passing-a-cloud-specific-setting) for an example.

To synchronise the Juju client with changes occurring on public clouds (e.g. cloud API changes, new cloud regions) or on Juju's side (e.g. support for a new cloud):

```text
juju update-public-clouds
```

The definition of an existing cloud can be done locally or, since `v.2.5.3`, remotely (on a controller).

For the 'oracle' cloud, for instance, create a [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) file, say `oracle.yaml`, with contents like:

```text
clouds:
   oracle:
      type: oci
      config:
         compartment-id: <some value>
```

Here, the local (client cache) definition is modified:

```text
juju update-cloud --local oracle -f oracle.yaml
```

This will avoid having to include `--config compartment-id=<some value>` at controller-creation time (`bootstrap`).

Here, the remote definition is updated by specifying the controller:

```text
juju update-cloud oracle -f oracle.yaml -c oracle-controller
```

If you specify a controller without supplying a YAML file then the remote cloud will be updated according to the client's current knowledge of that cloud.

<h2 id="heading--adding-clouds">Adding clouds</h2>

Adding a cloud is done with the `add-cloud` command, which has both interactive and manual modes.

<!--
With `v.2.6.1` a cloud can be added to a controller that is native to another cloud (manual mode only).
-->

<h3 id="heading--adding-clouds-interactively">Adding clouds interactively</h3>

For new users, interactive mode is the recommended method for adding a cloud. This mode currently supports the following clouds: MAAS, Manual, OpenStack, Oracle, and vSphere.

<h3 id="heading--adding-clouds-manually">Adding clouds manually</h3>

More experienced operators can add their clouds manually. This can assist with automation.

The manual method necessitates the use of a [YAML-formatted](http://www.yaml.org/spec/1.2/spec.html) configuration file. It has the following format:

``` yaml
clouds:
  <cloud_name>:
    type: <cloud type>
    auth-types: [<authenticaton types>]
    regions:
      <region-name>:
        endpoint: <https://xxx.yyy.zzz:35574/v3.0/>
```

The table below shows the authentication types available for each cloud type. It does not include the `interactive` type as it does not apply in the context of adding a cloud manually.

| cloud type   | authentication types         |
|--------------|------------------------------|
| `azure`      | `service-principal-secret`   |
| `cloudsigma` | `userpass`                   |
| `ec2`        | `access-key`                 |
| `gce`        | `jsonfile,oauth2`            |
| `joyent`     | `userpass`                   |
| `lxd`        | n/a, `certificate` (`v.2.5`) |
| `maas`       | `oauth1`                     |
| `manual`     | n/a                          |
| `oci`        | `httpsig`                    |
| `openstack`  | `access-key,userpass`        |
| `oracle`     | `userpass`                   |
| `rackspace`  | `userpass`                   |
| `vsphere`    | `userpass`                   |

<!--
Adding a cloud manually can be done locally or, since `v.2.6.1`, remotely (on a controller). Here, we'll explain how to do it locally (client cache).
-->

To add a cloud in this way we supply an extra argument to specify the relative (or absolute) path to the file:

`juju add-cloud --local <cloud-name> -f <cloud-file>`

[note]
In versions prior to `v.2.6.1` the `add-cloud` command only operates locally (there is no `--local` option).
[/note]

Here are some examples of manually adding a cloud:

- [Manually adding MAAS clouds](/t/using-maas-with-juju/1094#heading--manually-adding-maas-clouds)
- [Manually adding an OpenStack cloud](/t/using-openstack-with-juju/1097#heading--manually-adding-an-openstack-cloud)
- [Manually adding a vSphere cloud](/t/using-vmware-vsphere-with-juju/1099#heading--manually-adding-a-vsphere-cloud)

<h3 id="heading--managing-multiple-clouds-with-one-controller">Managing multiple clouds with one controller</h3>

With `v.2.6.1`  you can add a cloud to an existing controller, thereby saving a machine and the trouble of setting up a controller within that cloud.

[note type="caution"]
Multi-cloud functionality via `add-cloud` (not `add-k8s`) is available as "early access" and requires the use of a feature flag. Once the controller is created, you can enable it with: `juju controller-config features="[multi-cloud]"`
[/note]

For example, to manage a MAAS cloud with a LXD controller:

```text
juju bootstrap localhost lxd
juju add-cloud --local maas -f maas-cloud.yaml
juju add-credential maas -f maas-credentials.yaml
juju add-cloud --controller lxd maas
```

The output to the `list-clouds` command becomes:

```text
Clouds on controller "lxd":

Cloud      Regions  Default    Type  Description
localhost        1  localhost  lxd   
maas             0             maas
```

The 'lxd' controller is said to be a *multi-cloud controller*.

A limiting factor to multi-cloud controllers is that both controller machine and workload machine(s) must be able to initiate a TCP connection to one another. There are also latency issues that may make some scenarios unfeasible.

New cloud-based 'add-model' permissions can be set up via new commands `grant-cloud` and `revoke-cloud`.

When adding a model on a multi-cloud controller specifying the cloud name is mandatory. To continue with the example above then, to add model 'xanadu' to the 'maas' cloud:

```text
juju add-model xanadu maas
```
