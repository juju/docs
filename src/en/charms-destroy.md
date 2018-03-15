Title: Removing Juju objects

# Removing Juju objects

This section looks at how to remove the various objects you will encounter as
you work with Juju. These are:

 - applications
 - units
 - machines
 - relations
 
To remove a model or a controller see the [Models][models] and
[Controllers][controllers] pages respectively.

For guidance on what to do when a removal does not apply cleanly consult the
[Troubleshooting removals][troubleshooting-removals] page.

## Removing applications

An application can be removed with:

```bash
juju remove-application <application-name>
```

If dynamic storage is in use, the storage will, by default, be detached and
left alive in the model. However, the `--destroy-storage` option can be used to
instruct Juju to destroy the storage once detached. See
[Using Juju Storage][charms-storage] for details on dynamic storage.

!!! Note: 
    Removing an application which has active relations with another running
    application will terminate that relation. Charms are written to handle
    this, but be aware that the other application may no longer work as
    expected. To remove relations between deployed applications, see the
    section below.

## Removing units

It is possible to remove individual units instead of the entire application
(i.e. all the unites):

```bash
juju remove-unit mediawiki/1
```

To remove multiple units:

```bash
juju remove-unit mediawiki/1 mediawiki/2 mediawiki/3 mysql/2
```

In the case that these are the only units running on a machine, unless that 
machine was created manually with `juju add machine`, the machine will also be 
removed.

The `--destroy-storage` option is available for this command as it is for the
`remove-application` command above.

## Removing machines

Juju machines can be removed like this:

```bash
juju remove-machine <number>
```

However, it is not possible to remove a machine which is currently allocated
to a unit. If attempted, this message will be emitted:

```no-highlight
error: no machines were destroyed: machine 3 has unit "mysql/0" assigned
```

By default, when a Juju machine is removed, the backing system, typically a
cloud instance, is also destroyed. The `--keep-instance` option overrides this;
it allows the instance to be left running.

## Removing relations

A relation can be removed easily enough:

```bash
juju remove-relation mediawiki mysql
```

In cases where there is more than one relation between the two applications, it
is necessary to specify the interface at least once:

```bash
juju remove-relation mediawiki mysql:db
```


<!-- LINKS-->

[controllers]: ./controllers.html
[models]: ./models.html
[charms-storage]: ./charms-storage.html
[troubleshooting-removals]: ./troubleshooting-removals.html
