# Removal within Juju

Juju isn't just about magically spinning up services as and when you need them,
it is also about quickly, sanely and efficiently removing something when you no
longer need it. This section deals with the sort of things you can ruthlessly
destroy, and how to go about it.

## Removing Services

Once a service is no longer required it can be removed with a simple command.

    juju remove-service <service-name>

**Warning!:** Removing a service which has active relations with another running service will break that relation. This can cause errors in both services, as such review and potentially remove any relationships first.

A service can take a while to "die", but if running a juju status reveals that
the service is listed as dying, but also reports an error state, then the
zombied service will still be hanging around. See caveats for how to manage
services in a dying state.

**Note:** Destroying a service removes that service, but not any nodes which may have been created for it to run on. This is juju's way of preserving data to the best of its ability. See Destroying Machines for additional details.

## Removing Units

It is also possible to spin down individual units, or a sequence of units
running within a service:

    juju remove-unit mediawiki/1

If you wish to remove more than one unit, you may list them all following the
command:

    juju remove-unit mediawiki/1 mediawiki/2 mediawiki/3 mysql/2 ...

**Note:** As with removing a service, removing units will NOT actually remove any instances which were created, it only removes the service units. More details can be found in the [Scaling Services](charms-scaling.html) section.

As with removing services, See caveats for how to manage units in a dying state.

## Removing Machines

Instances or machines which have no currently assigned workload can be removed
from your cloud using the following command:

    juju remove-machine <number>

A machine which is currently idle will be removed almost instantaneously from
the cloud, along with anything else which may have been on the instance which
juju was not aware of. To prevent accidents and awkward moments with running
services, it is not possible to remove an instance which is currently allocated
to a service. If you try to do so, you will get a polite error message in the
form:

    error: no machines were destroyed: machine 3 has unit "mysql/0" assigned

## Destroying Environments

To completely remove and terminate all running services, the instances they were
running on and the bootstrap node itself, you need to run the command:

    juju destroy-environment <environment>

This will completely remove all instances running under the current environment
profile. As there is no 'undo' capability, some further safety precautions have
been added to this command.

- You will be prompted to confirm the destruction of the environment

## Removing Relations

To remove relations between deployed services, you should see [ the docs section on charm relationships](charms-relations.html#removing).

## Caveats

These are caveats which you may encounter while trying to remove items within
Juju

### life: dying

If you have a unit or serving in a dying state that has not gone away check to
see if that unit, or any units within the service, are in an error state. Since
Juju is an event driven orchestration client, the "removal" of a unit and
service is also modeled as an event within Juju. As such, when a unit enters an
error state all other events within that unit's lifecycle are queued. To clear
this run

    juju resolved <unit>

to have the next event processed. You may need to run the `resolved` command run several times against a unit.

If the unit isn't in an error state, there may be an error elsewhere in the
environment. Since removing a unit or destroying a service also breaks the
relation, if there's an error in the relation-removal event on one or more of
the connected services that may also halt the event loop for that unit. Check to make sure no other units are in an error state and clear those using the `juju resolved` command.
