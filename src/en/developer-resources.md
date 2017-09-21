Title: Using resources | Developer guide

# Using resources

Many applications require binary resources to complete the install process.
While it is possible for a charm to download this software from package
repositories or other locations, some charms may be deployed in data centers
with restrictive firewalls that do not allow access to all areas of the
Internet. It may also be desirable to more strictly control what specific
resources are deployed.

Starting with Juju 2.0, users can upload resources to the controller or the
Juju Charm Store from where they are accessible to charms.

Use discrete files for resources. That is, if your charm requires a software
package and a dependency, then use one resource for each. Juju optimizes
distribution of resources. If resources are grouped into one file (resource)
then they are larger and must be updated everywhere when they are updated.

Also see [Juju resources][charms-resources] in the User guide for an end-user
perspective.

## Developing a charm with resources

Charm developers can add a `resources` key to the `metadata.yaml` file to
define one or more resources.

```yaml
resources:
  software:
    type: file
    filename: software.zip
    description: "One line description that is useful when operators need to push it."
```

The 'filename' is what Juju will name the file locally when it is downloaded.
Juju will check the extension on the file being uploaded and will prevent files
with different extensions from being uploaded.

## Managing resources

Resources can be uploaded to a local Juju controller, where only charms from
that controller can access the resources, or to the Juju Charm Store where
access is controlled by permissions assigned to the charms to which the
resources are attached.

## Listing resources

### juju resources

Users can list the resources that are currently available on the controller by
using the `juju resources` command. The command shows resources for a service
or a unit.

Examples,

```bash
juju resources resources-example
```

Sample output:

```no-highlight
[Service]
RESOURCE SUPPLIED BY REVISION
software admin@local 2016-25-05T18:37
```

Or

```bash
juju resources resources-example/0
```

Sample output:

```no-highlight
[Unit]
RESOURCE REVISION
software 2016-25-05T18:37
```

### charm list-resources

Users can display the resources that are currently available in Charm Store for
a charm or a specific revision number with the `charm list-resources` command
(from the [Charm tools][charm-tools]).

For example,

```bash
charm list-resources cs:~lazypower/etcd
```

Sample output:

```no-highlight
[Service]
RESOURCE REVISION
etcd     0
etcdctl  0
```

## Adding resources

### juju attach-resource

The `juju attach-resource` command uploads a file from local disk to the Juju
controller to be used as a resource for an application. You must specify the
charm name, the resource name, and the path to the file.

```bash
juju attach-resource charm-name resource-name=filepath
```

If you attach a resource to a running charm the `upgrade-charm` hook is run.
This gives charm authors the ability to handle new resources appropriately.

### juju deploy

Resources may be uploaded to the Juju controller at deploy time by specifying
the `--resource` flag followed by a `<resource-name>=<filepath>` pair. This
flag may be repeated more than once to upload more than one resource.

```bash
juju deploy charm-name --resource foo=/some/file.tgz --resource bar=./docs/cfg.xml
```

Where "foo" and "bar" are the resource names in the `metadata.yaml` file for
the charm-name charm.

### charm attach

The `charm attach` command ([Charm tools][charm-tools]) uploads a file to the
Charm Store as a new resource for the charm. The default channel is the stable
channel. You must specify the fully qualified charm name, including the version
(e.g.  ~you/mycharm-0 instead of just ~you/mycharm when using the stable
channel).

```bash
charm attach ~mbruzek/trusty/consul-0 software=./consul_0.6.4_linux_amd64.zip
```

A revision number is not required when using another channel.

```bash
charm attach ~mbruzek/trusty/consul-0 software=./consul_0.6.4_linux_amd64.zip -c unpublished
```

## Using resources in a charm

### resource-get

The hook tool `resource-get` will fetch a resource from the Juju controller or
the Charm Store. The command returns a local path to the file for a named
resource.

If `resource-get` has not been run for the named resource previously, then the
resource is downloaded from the controller at the revision associated with the
unit's application. That file is stored in the unit's local cache. If it *has*
been run before then each subsequent run synchronizes the resource with the
controller. This ensures that the revision of the unit-local copy of the
resource matches the revision of the resource associated with the unit's
application.

The output (path) provided by `resource-get` references the up-to-date file for
the resource. Note that the resource may get updated on the controller for the
service at any time, meaning the cached copy *may* be out of date at any time
after the command is called. Consequently, the command should be run whenever
it is critical for the resource to be up-to-date.

For example,

```bash
resource-get software
```

Sample output:

```no-highlight
/var/lib/juju/agents/unit-resources-example-0/resources/software/software.zip
```


<!-- LINKS -->

[charm-tools]: ./tools-charm-tools.html
[charms-resources]: ./charms-resources.html
