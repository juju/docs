Title: Removing services, units and machines in Juju  


# Removing services, units and environments

Juju can sanely and efficiently remove something when you no longer need it.
This section looks at how to remove services, units and environments. To 
remove a model see the [models documentation][models].


## Removing a service

Once a service is no longer required it can be removed with:

```bash
juju remove-service <service-name>
```

!!! Note: Removing a service which has active relations with another
running service will terminate that relation. Charms are written
to handle this, but be aware that the other service may no 
longer work as expected.

This is the order of events for removing a service:

1. The Juju client tells the state server that every unit (in this service) is
to be destroyed.
1. The state server signals to the service (charm) that it is going to be
destroyed.
1. The charm breaks any relations to its service by calling `relationship-broken`
and `relationship-departed`.
1. The charm calls its 'stop hook' which **should**:
    - Stop the service
    - Remove any files/configuration created during the service lifecycle
    - Prepare any backup(s) of the service that are required for restore purposes.
1. The service and all its units are then removed.

A service can take a while to "die", but if `juju status` reveals that the
service is listed as dying, but also reports an error state, then the removed
service will not go away. See the 'Caveats' section below for how to manage services
stuck in a dying state.


## Removing units

It is possible to remove individual units instead of the entire service:

```bash
juju remove-unit mediawiki/1
```

To remove multiple units:

```bash
juju remove-unit mediawiki/1 mediawiki/2 mediawiki/3 mysql/2
```

In the case that these are the only units running on a machine, unless that machine
was created manually with `juju add machine`, the machine will also be removed.

See section 'Caveats' below for how to manage units in a dying state.


## Removing machines

Machines (instances) can be removed like this:

```bash
juju remove-machine <number>
```

However, it is not possible to remove an instance which is currently allocated
to a service. If attempted, this message will be emitted:

```no-highlight
error: no machines were destroyed: machine 3 has unit "mysql/0" assigned
```


## Removing relations

To remove relations between deployed services, see
[Charm relations](charms-relations.html#removing-relations).


## Caveats

These are caveats which you may encounter while removing items.

### state of *life: dying*

If you have a unit or service that persists in a dying state check to see if
that unit, or any units within the associated service, are in an error state. A
"removal" is an event within the queue of a unit's lifecycle so when a unit
enters an error state all events within the queue are blocked. To unblock the
unit's error you need to resolve it. Do so like this:

```bash
juju resolved <unit>
```

The above command may need to be repeated to resolve other errors on the unit.

There may be errors on other units caused by the breaking of relations that
occur when removing a unit or service. Therefore also verify that the
associated units are not in an error state and apply the above command to them
if they are.


[models]: ./models-destroying.html
