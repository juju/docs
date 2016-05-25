Title: Writing charms using resources

# Writing charms that use resources

Many services require binary resources in order to be installed. While it is
possible for a charm to download the software from the package repositories, or
other locations, some charms may be deployed network restricted environments
that do not allow access to the Internet.

Starting with version 2 of Juju, users can upload resources to the controller
that charms can download. This is useful for Juju models in restrictive
network environments and when you want to careful control the versions of
software you deploy.

# How it works

## Developing a charm with resources

Charm developers can add a `resources` key to the metadata.yaml file to define
one or more resources.

```yaml
resources:
  software:
    type: file
    filename: software.zip
    description: "One line description that is useful when operators need to push it."
```
The `filename` is the name of the resource after it has been retrieved. Juju
will check extension on files and will prevent files with other extensions
to be uploaded.

# Managing resources

Resources can be uploaded to a local Juju controller, where only charms from
that controller can access the resources, or the Juju charm store where access
is controlled by permissions.

## Listing resources

### juju list-resources

Users can list the resources that are currently available on the Juju
controller by using the `juju list-resources` command. The command shows
resources for a service or a unit.

```sh
$ juju list-resources resources-example
[Service]
RESOURCE SUPPLIED BY REVISION
software admin@local 2016-25-05T18:37

$ juju list-resources resources-example/0
[Unit]
RESOURCE REVISION
software 2016-25-05T18:37
```

## charm list-resources

Users can display the resources tat are currently available in Juju Charm Store
for a charm or a specific revision number with the `charm list-resources`
command.

```sh
$ charm list-resources cs:~lazypower/etcd
[Service]
RESOURCE REVISION
etcd     0
etcdctl  0
```

## Adding resources

## juju attach

The `juju attach` command uploads a file from local disk to the Juju controller
to be used as a resource for a service. You must specify the charm name, the
resource name and the path to the file.

```sh
juju attach charm-name resource-name=filepath
```

## juju deploy

Resources may be uploaded to the Juju controller at deploy time by specifying
the --resource flag followed by resource-name=filepath pair. This flag may be
repeated more than once to upload more than one resource.

```sh
juju deploy charm-name --resource foo=/some/file.tgz --resource bar=./docs/cfg.xml
```
Where "foo" and "bar" are the resource names in metadata.yaml file for the
charm-name charm.

### charm attach

The `charm attach` command uploads a file to the Juju Charm Store as a new
resource for the charm.

```sh
charm attach ~mbruzek/trusty/consul software=./consul_0.6.4_linux_amd64.zip
```

# Using resources in a charm

## resource-get

There is a charm command that will fetch the resource from the Juju controller
or the Juju Charm store called `resource-get`. The `resource-get` command
returns a local path to the file for a named resource.

If `resource-get` for a resource has not been run before (for the unit) then the
resource is downloaded from the controller at the revision associated with the
unit's service. That file is stored in the unit's local cache. If `resource-get`
*has* been run before then each subsequent run syncs the resource with the
controller. This ensures that the revision of the unit-local copy of the
resource matches the revision of the resource associated with the unit's
service.

The path provided by `resource-get` references the up-to-date file for the
resource. Note that the resource may get updated on the controller for the
service at any time, meaning the cached copy *may* be out of date at any time
after you call `resource-get`. Consequently, the command should be run at every
point where it is critical that the resource be up to date.

```sh
# resource-get software
/var/lib/juju/agents/unit-resources-example-0/resources/software/software.zip
```
