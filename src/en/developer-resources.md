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
    filename: software.tgz
    description: "One line description that is useful when operators need to push it."
```

# Managing resources

Resources can be uploaded to a local Juju controller, where only charms from
that controller can access the resources, or the Juju charm store where access
is controlled by permissions.

## Listing resources

### juju list-resources

Operators can list the resources that are currently available by using the
`juju list-resources` command. The command shows resources in a model.

```sh
juju list-resources charm-name
```

## charm list-resources

Operators can display the resources tat are currently available for a charm in
the charm store with the `charm list-resources` command.

```sh
charm list-resources cs:~user/trusty/charm-name
```

## Adding resources

### charm attach

Operators can upload a file as a new resource for a charm.

```sh
charm attach ~user/trusty/charm-name website-data ./foo.zip
```

## charm deploy
You can specify resources when you deploy a charm with the `--resource` command
line flag. The resource should be specified in a name=filepath pair. You can
specify multiple resources on one deploy command:

```sh
juju deploy charm-name --resource foo=/some/file.tgz --resource bar=./docs/cfg.xml
```
Where "foo" and "bar" are the resource names in metadata.yaml file for the
charm-name charm.

## juju attach
The `juju attach` command uploads a file from local disk to the juju controller
to be used as a resoruce for a service.

```sh
juju attach charm-name name=filepath
```

## Upgrading resources

TODO: ask natefinch about this: A resource update will trigger the `upgrade-charm` hook.

# Using resources in a charm

## resource-get

Get the resource by name.

```sh
resource-get software
```

# Caveats

TODO: Document the limitations if any for this feature.
