This page is devoted to the topic of removing objects in Juju. We first cover the meanings of certain removal terms and then provide information and steps for how different kinds of objects are removed.

For guidance on what to do when a removal does not apply cleanly consult the [Troubleshooting removals](/t/troubleshooting-removals/1185) page.

<h2 id="heading--removal-terms">Removal terms</h2>

There is a distinction between the similar sounding terms "unregister", "detach", "remove", "destroy", and "kill". These terms are ordered such that their effect increases in severity:

-   *Unregister* means to decouple a resource from a logical entity for the client. The affect is local to the client only and does not affect the logical entity in any way.

-   *Detach* means to decouple a resource from a logical entity (such as an application). The resource will remain available and the underlying cloud resources used by it also remain in place.

-   *Remove* means to cleanly remove a single logical entity. This is a destructive process, meaning the entity will no longer be available via Juju, and any underlying cloud resources used by it will be freed (however, this can often be overridden on a case-by-case basis to leave the underlying cloud resources in place).

-   *Destroy* means to cleanly tear down a logical entity, along with everything within these entities. This is a very destructive process.

-   *Kill* means to forcibly tear down an unresponsive logical entity, along with everything within it. This is a very destructive process that does not guarantee associated resources are cleaned up.

[note]
These command terms/prefixes do not apply to all commands in a generic way. Instead, the explanation of them is meant to convey how a command generally operates and what its severity level is. 
[/note]

<h2 id="heading--kill-controller">The kill-controller command</h2>

The `kill-controller` command deserves some attention as it is very destructive and also has exceptional behaviour modes. This command will first attempt to remove a controller and its models in an orderly fashion. That is, it will behave like `destroy-controller`. If this fails, usually due the controller itself being  unreachable then the controller machine and the workload machines will be destroyed by having the client contact the backing cloud's API directly.

<h2 id="heading--forcing-removals">Forcing removals</h2>

Juju object removal commands do not succeed when there are errors in the multiple steps that are required to remove the underlying object. For instance, a unit will not remove properly if it has a hook error or a model cannot be removed if application units are in an error state. This is a conservative approach to the deletion of things, which is good.

However, this policy can also be a source of frustration for users in certain situations (i.e. "I don't care, I just want my model gone!"). Because of this, several commands have a `--force` option.

Secondly, even when utilising the `--force` option the process may take more time than an administrator is willing to accept (i.e. "Just go away as quickly as possible!").  Because of this, several commands that support the `--force` option have, in addition, support for a `--no-wait` option.

[note type=caution status=Caution]
The `--force` and `--no-wait` options should be regarded as tools to wield as a last resort. Using them introduces a chance of associated parts (e.g. relations) not being cleaned up, which can lead to future problems.
[/note]

As of `v.2.6.1`, this is the state of affairs for those commands that support at least the `--force` option:

command | `--force` | `--no-wait`
---------------|---------------|---------------
`destroy-model` | yes | yes
`detach-storage` | yes | no
`remove-application` | yes | yes
`remove-machine` | yes | yes
`remove-offer` | yes | no
`remove-relation` | yes | no
`remove-storage` | yes | no
`remove-unit` | yes | yes

When a command has `--force` but not `--no-wait` it indicates that the combination of those options simply does not apply.

<h2 id="heading--object-removal-list">Object removal list</h2>

- [Destroying controllers](#heading--destroying-controllers)
- [Destroying models](#heading--destroying-models)
- [Detaching storage](#heading--detaching-storage)
- [Removing applications](#heading--removing-applications)
- [Removing charms or bundles](#heading--removing-charms-or-bundles)
- [Removing clouds](#heading--removing-clouds)
- [Removing machines](#heading--removing-machines)
- [Removing offers](#heading--removing-offers)
- [Removing relations](#heading--removing-relations)
- [Removing storage](#heading--removing-storage)
- [Removing units](#heading--removing-units)
- [Removing users](#heading--removing-users)
- [Unregistering controllers](#heading--unregistering-controllers)

<h3 id="heading--destroying-controllers">Destroying controllers</h3>

A controller is removed with:

`juju destroy-controller <controller-name>`

You will always be prompted to confirm this action. Use the `-y` option to override this.

As a safety measure, if there are any models (besides the 'controller' model) associated with the controller you will need to pass the `--destroy-all-models` option.

Additionally, if there is persistent [storage](/t/using-juju-storage/1079) in any of the controller's models you will be prompted to either destroy or release the storage, using the `--destroy-storage` or `--release-storage` options respectively.

For example:

```text
juju destroy-controller -y --destroy-all-models --destroy-storage aws
```

Use the `kill-controller` command as a last resort if the controller is not accessible for some reason.

<h3 id="heading--destroying-models">Destroying models</h3>

To destroy a model, along with any associated machines and applications:

`juju destroy-model <model-name>`

You will always be prompted to confirm this action. Use the `-y` option to override this.

Additionally, if there is persistent [storage](/t/using-juju-storage/1079) in the model you will be prompted to either destroy or release the storage, using the `--destroy-storage` or `--release-storage` options respectively.

For example:

```text
juju destroy-model -y --destroy-storage beta
```

As a last resort, use the `--force` option (in `v.2.6.1`).

<h3 id="heading--detaching-storage">Detaching storage</h3>

To detach a storage instance:

`juju detach-storage <storage-instance>`

For example:

```text
juju detach-storage osd-devices/2
```

Detaching storage does not destroy the storage.

<h3 id="heading--removing-applications">Removing applications</h3>

An application can be removed with:

`juju remove-application <application-name>`

For example:

```text
juju remove-application apache2
```

This will remove all of the application's units. All associated machines will also be removed providing they are not hosting containers or another application's units.

If persistent [storage](/t/using-juju-storage/1079) is in use by the application it will be detached and left in the model. However, the `--destroy-storage` option can be used to instruct Juju to destroy the storage once detached.

Removing an application which has relations with another application will terminate that relation. This may adversely affect the other application. See section [Removing relations](#heading--removing-relations) below for how to selectively remove relations.

As a last resort, use the `--force` option (in `v.2.6.1`).

<h3 id="heading--removing-charms-or-bundles">Removing charms or bundles</h3>

A **charm** is the *means* by which an application is installed. There is therefore no method to remove a charm. Removal should be done at either the unit or application level.

A **bundle** is not a logical entity that can be removed. Once a bundle is deployed, applications can evolve in numerous ways that are not tracked and associated with the original bundle. For complex deployments, the recommendation is to deploy on a per-model basis so the removal of a complex deployment becomes equivalent to the removal of a model.

<h3 id="heading--removing-clouds">Removing clouds</h3>

Removing a cloud definition can be done locally or, since `v.2.6.1`, remotely (on a controller). Here, we'll show how to do it locally (client cache).

A cloud definition can be removed with:

`juju remove-cloud [options] <cloud-name>`

For example:

```text
juju remove-cloud --local lxd-remote
```

The following attempted removals will cause the command to error out, accompanied by appropriate messaging:

1. a remote private cloud currently in use
1. a local or remote built-in cloud

[note]
In versions prior to `v.2.6.1` the `remove-cloud` command only operates locally (there is no `--local` option).
[/note]

<h3 id="heading--removing-machines">Removing machines</h3>

A machine can be removed with:

`juju remove-machine <machine ID>`

For example:

```text
juju remove-machine 3
```

However, it is not possible to remove a machine that is currently hosting either a unit or a container. Either remove all of its units (or containers) first or, as a last resort, use the `--force` option.

[note type="caution"]
In some situations, even with the `--force` option, the machine on the backing cloud may be left alive. Examples of this include the Manual cloud or if harvest provisioning mode is not set. In addition to those situations, if the client has lost connectivity with the backing cloud, any backing cloud, then the machine may not be destroyed, even if the machine's record has been removed from the Juju database and the client is no longer aware of it.
[/note]

By default, when a machine is removed, the backing system, typically a cloud instance, is also destroyed. The `--keep-instance` option overrides this; it allows the instance to be left running.

<h3 id="heading--removing-offers">Removing offers</h3>

An application offer (for a cross model relation) is removed with:

`juju remove-offer <offer url>`

For example:

```text
juju remove-offer hosted-mysql
```

The attempt will fail if a relation has already been made to the offer. To override this behaviour the `--force` option is required, in which case the relation is also removed.

Note that if the offer does not reside in the current model then the full URL must be used:

```text
juju remove-offer prod.model/hosted-mysql
```

<h3 id="heading--removing-relations">Removing relations</h3>

A relation is removed by calling out both (application) sides of the relation:

`juju remove-relation <application-name> <application-name>`

For example:

```text
juju remove-relation mediawiki mysql
```

In cases where there is more than one relation between the two applications, it is necessary to specify the interface at least once:

```text
juju remove-relation mediawiki mysql:db
```

<h3 id="heading--removing-storage">Removing storage</h3>

To remove a storage instance from a model first detach it and then:

`juju remove-storage <storage-instance>`

For example:

```text
juju detach-storage osd-devices/3
juju remove-storage osd-devices/3
```

The `--force` option can be used to avoid having to first detach the storage.

The removal of storage is, by default, a destructive process (destroyed on the cloud provider). To prevent this, the `--no-destroy` option is available. Note that, by using this option, the storage will no longer be visible to Juju.

<h3 id="heading--removing-units">Removing units</h3>

To remove individual units instead of the entire application (i.e. all the units):

`juju remove-unit <unit>`

For example:

```text
juju remove-unit postgresql/2
```

In the case that the removed unit is the only one running the corresponding machine will also be removed unless any of the following is true for that machine:

- it was created with `juju add-machine`
- it is not being used as the only controller
- it is not hosting Juju-managed containers (KVM guests or LXD containers)

To remove multiple units:

```text
juju remove-unit mediawiki/1 mediawiki/3 mediawiki/5 mysql/2
```

The `--destroy-storage` option is available for this command as it is for the `remove-application` command above.

As a last resort, use the `--force` option (in `v.2.6.1`).

<h3 id="heading--removing-users">Removing users</h3>

A user can be removed from a controller with:

`juju remove-user <user-name>`

For example:

```text
juju remove-user teo
```

<h3 id="heading--unregistering-controllers">Unregistering controllers</h3>

A controller can be removed from a client with:

`juju unregister <controller-name>`

For example:

```text
juju unregister aws-controller
```

This removes local connection information from the local client. This command does not affect the controller itself in any way.

<!-- LINKS-->
