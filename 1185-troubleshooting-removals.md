<!--
Todo:
- Elaborate on "restore purposes"
-->

This page provides background information on how Juju removes objects as this can help diagnose a general problem. It also offers specific troubleshooting tips when you try to remove a Juju object and it doesn't go the way you expect. For the main page on how to remove objects see the [Removing things](/t/removing-things/1063) page.

<h2 id="heading--background-information">Background information</h2>

<h3 id="heading--removing-applications">Removing applications</h3>

Internally, this is how Juju processes the removal of an application:

1.  The Juju client tells the controller to destroy all the application's units.
2.  The controller signals to the application (charm) that it is going to be destroyed.
3.  The charm breaks any relations to its application by calling `relationship-broken` and `relationship-departed`.
4.  The charm calls its 'stop hook' which **should**:
    -   Stop the application
    -   Remove any files/configuration created during the application lifecycle
    -   Prepare any backup(s) of the application that are required for restore purposes.
5.  The application and all its units are then removed.

It can take a while for the application to be completely removed but if `juju status` reveals that the application is listed as 'dying', but also reports an error state, then the removed application will not go away. See the section below for how to manage applications stuck in a dying state.

<h2 id="heading--troubleshooting-tips">Troubleshooting tips</h2>

<h3 id="heading--dying-state">dying state</h3>

If you have a unit or application that persists in a state 'life: dying' check to see if that unit, or any units within the associated application, are in an error state. A 'removal' is an event within the queue of a unit's lifecycle so when a unit enters an error state all events within the queue are blocked. To unblock the unit's error you need to resolve it. Do so like this:

``` text
juju resolved <unit>
```

The above command may need to be repeated to resolve other errors on the unit.

There may be errors on other units caused by the breaking of relations that occur when removing a unit or application. Therefore, also verify that the associated units are not in an error state and apply the above command to them if they are. This command can also be applied to multiple units:

``` text
juju resolved mysql/0 mysql/1
```

Additionally, option `--all` can be used to attempt to resolve errors on all units.

<!-- LINKS -->
