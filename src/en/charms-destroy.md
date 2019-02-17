Title: Removing things
TODO:  remove-application|unit should mention in what circumstances the associated machine is removed (other units or containers will prevent this)
       remove-machine should mention in what circumstances the machine is not removed (other units or containers will prevent this)

# Removing things

This page shows how to remove Juju objects.

 - [Removing applications][#removing-applications]
 - [Removing controllers][#removing-controllers]
 - [Removing machines][#removing-machines]
 - [Removing models][#removing-models]
 - [Removing relations][#removing-relations]
 - [Removing units][#removing-units]
 - [Removing users][#removing-users]
 
Also covered are the meanings of certain removal terms.

For guidance on what to do when a removal does not apply cleanly consult the
[Troubleshooting removals][troubleshooting-removals] page.

## Detach vs Remove vs Destroy vs Kill

In Juju, there is a distinction between the similar sounding terms "detach",
"remove", "destroy", and "kill". These terms are used consistently and are also
ordered such that their meaning or effect increases in extent or severity.

 - *Detach* means to decouple a resource from a logical entity (such as an
   application) within the model. The resource will remain available in the
   model for later access with Juju, and underlying cloud resources used by it
   also remain in place.
 - *Remove* means to cleanly remove a single logical entity from the model.
   This is a destructive process, meaning the entity will no longer be
   available via Juju, and any underlying cloud resources used by it will be
   freed (however, this can often be overridden on a case-by-case basis to
   leave the underlying cloud resources in place).
 - *Destroy* means to cleanly tear down an entire model, or even an entire
   controller, along with everything in it. There are some safe-guards to help
   avoid accidentally destroying models that are in use, but this is inherently
   a destructive process.
 - *Kill* means to forcibly tear down an entire controller, along with
   everything in it. This is a very destructive process and is reserved for
   cleaning up resources used by broken or otherwise unresponsive controllers.
   It is also recommended to manually check the backing cloud to ensure that
   all resources were found and cleaned up.

## Removing applications

An application can be removed with:

`juju remove-application <application-name>`

If dynamic storage is in use, the storage will, by default, be detached and
left alive in the model. However, the `--destroy-storage` option can be used to
instruct Juju to destroy the storage once detached. See
[Using Juju storage][charms-storage] for details on dynamic storage.

!!! Note: 
    Removing an application which has active relations with another running
    application will terminate that relation. Charms are written to handle
    this, but be aware that the other application may no longer work as
    expected. To remove relations between deployed applications, see the
    section below.

## Removing controllers

A controller is removed with:

`juju destroy-controller <controller-name>`

Use the `kill-controller` command as a last resort if the controller is not
accessible for some reason:

`juju kill-controller <controller-name>`

In this case, the controller will be removed by communicating directly with the
cloud provider. Any other Juju machines residing within any of the controller's
models will not be destroyed and will need to be removed manually using
provider tools/console. This command will first attempt to mimic the behaviour
of the `destroy-controller` command and failover to the more drastic behaviour
if that attempt fails.

## Removing machines

A machine can be removed with:

`juju remove-machine <machine ID>`

However, it is not possible to remove a machine which is currently allocated
to a unit. If attempted, this message will be emitted:

```no-highlight
error: no machines were destroyed: machine 3 has unit "mysql/0" assigned
```

By default, when a machine is removed, the backing system, typically a cloud
instance, is also destroyed. The `--keep-instance` option overrides this; it
allows the instance to be left running.

## Removing models

A model is removed with:

`juju destroy-model <model-name>`

## Removing units

It is possible to remove individual units instead of the entire application
(i.e. all the units):

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


<!-- LINKS-->

[charms-storage]: ./charms-storage.md
[troubleshooting-removals]: ./troubleshooting-removals.md

[#removing-applications]: #removing-applications
[#removing-controllers]: #removing-controllers
[#removing-machines]: #removing-machines
[#removing-models]: #removing-models
[#removing-relations]: #removing-relations
[#removing-units]: #removing-units
[#removing-users]: #removing-users
