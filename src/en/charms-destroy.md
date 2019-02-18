Title: Removing things

# Removing things

This page shows how to remove Juju objects.

 - [Destroying controllers][#destroying-controllers]
 - [Destroying models][#destroying-models]
 - [Detaching storage][#detaching-storage]
 - [Removing applications][#removing-applications]
 - [Removing machines][#removing-machines]
 - [Removing relations][#removing-relations]
 - [Removing units][#removing-units]
 - [Removing users][#removing-users]
 - [Unregistering controllers][#unregistering-controllers]
 
We first cover the meanings of certain removal terms.

For guidance on what to do when a removal does not apply cleanly consult the
[Troubleshooting removals][troubleshooting-removals] page.

## Removal terms

There is a distinction between the similar sounding terms "unregister",
"detach", "remove", "destroy", and "kill". These terms are ordered such that
their effect increases in severity:

 - *Unregister* means to decouple a resource from a logical entity for the
   client. The affect is local to the client only and does not affect the
   logical entity in any way.

 - *Detach* means to decouple a resource from a logical entity (such as an
   application). The resource will remain available and the underlying cloud
   resources used by it also remain in place.

 - *Remove* means to cleanly remove a single logical entity. This is a
   destructive process, meaning the entity will no longer be available via
   Juju, and any underlying cloud resources used by it will be freed (however,
   this can often be overridden on a case-by-case basis to leave the underlying
   cloud resources in place).

 - *Destroy* means to cleanly tear down a logical entity, along with everything
   within these entities. This is a vary destructive process.

 - *Kill* means to forcibly tear down an unresponsive logical entity, along
   with everything within it. This is a very destructive process that does not
   guarantee associated resources are cleaned up.

## Removing applications

An application can be removed with:

`juju remove-application <application-name>`

For example:

```bash
juju remove-application apache2
```

This will remove all of the application's units. All associated machines will
also be removed providing they are not hosting containers or another
application's units.

If persistent [storage][charms-storage] is in use by the application it will be
detached and left in the model. However, the `--destroy-storage` option can be
used to instruct Juju to destroy the storage once detached.

Removing an application which has relations with another application will
terminate that relation. This may adversely affect the other application. See
section [Removing relations][#removing-relations] below for how to selectively
remove relations.

## Destroying controllers

A controller is removed with:

`juju destroy-controller <controller-name>`

You will always be prompted to confirm this action. Use the `-y` option to
override this.

As a safety measure, if there are any models (besides the 'controller' model)
associated with the controller you will need to pass the `--destroy-all-models`
option.

Additionally, if there is persistent [storage][charms-storage] in any of the
controller's models you will be prompted to either destroy or release the
storage, using the `--destroy-storage` or `--release-storage` options
respectively.

For example:

```bash
juju destroy-controller -y --destroy-all-models --destroy-storage aws
```

Use the `kill-controller` command as a last resort if the controller is not
accessible for some reason:

`juju kill-controller <controller-name>`

In this case, the controller will be removed by communicating directly with the
cloud provider. Any other Juju machines residing within any of the controller's
models will not be destroyed and will need to be removed manually using
provider tools/console. This command will first attempt to mimic the behaviour
of the `destroy-controller` command and failover to the more drastic mode if
that attempt fails.

## Detaching storage

To detach a storage instance:

`juju detach-storage <storage-instance>`

For example:

```bash
juju detach-storage osd-devices/2
```

Detaching storage does not destroy the storage.

## Removing machines

A machine can be removed with:

`juju remove-machine <machine ID>`

For example:

```bash
juju remove-machine 3
```

However, it is not possible to remove a machine that is currently hosting
either a unit or a container. Either remove all of its units (or containers)
first or, as a last resort, use the `--force` option.

By default, when a machine is removed, the backing system, typically a cloud
instance, is also destroyed. The `--keep-instance` option overrides this; it
allows the instance to be left running.

## Destroying models

To destroy a model, along with any associated machines and applications:

`juju destroy-model <model-name>`

You will always be prompted to confirm this action. Use the `-y` option to
override this.

Additionally, if there is persistent [storage][charms-storage] in the model you
will be prompted to either destroy or release the storage, using the
`--destroy-storage` or `--release-storage` options respectively.

For example:

```bash
juju destroy-model -y --destroy-storage beta
```

## Removing units

To remove individual units instead of the entire application (i.e. all the
units):

`juju remove-unit <unit>`

For example:

```bash
juju remove-unit postgresql/2
```

In the case that the removed unit is the only one running the corresponding
machine will also be removed unless any of the following is true for that
machine:

 - it was created with `juju add-machine`
 - it is not being used as the only controller
 - it is not hosting Juju-managed containers (KVM guests or LXD containers) 

To remove multiple units:

```bash
juju remove-unit mediawiki/1 mediawiki/3 mediawiki/5 mysql/2
```

The `--destroy-storage` option is available for this command as it is for the
`remove-application` command above.

## Removing relations

A relation is removed by calling out both (application) sides of the relation:

`juju remove-relation <application-name> <application-name>`

For example:

```bash
juju remove-relation mediawiki mysql
```

In cases where there is more than one relation between the two applications, it
is necessary to specify the interface at least once:

```bash
juju remove-relation mediawiki mysql:db
```

## Removing users

A user can be removed from a controller with:

`juju remove-user <user-name>`

For example:

```bash
juju remove-user teo
```

## Unregistering controllers

A controller can be removed from a client with:

`juju unregister <controller-name>`

For example:

```bash
juju unregister aws-controller
```

This removes local connection information from the local client. This command
does not affect the controller itself in any way.


<!-- LINKS-->

[charms-storage]: ./charms-storage.md
[troubleshooting-removals]: ./troubleshooting-removals.md
[charms-storage]: ./charms-storage.md

[#removing-applications]: #removing-applications
[#destroying-controllers]: #destroying-controllers
[#removing-machines]: #removing-machines
[#destroying-models]: #destroying-models
[#removing-relations]: #removing-relations
[#removing-units]: #removing-units
[#removing-users]: #removing-users
