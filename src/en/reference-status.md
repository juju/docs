Title: Charm/Unit statuses and their meanings


# Unit status

As of version 1.24 of Juju, a unit can report its status as one of the
following:

|Status       | colour in GUI* |Meaning                                      |
|=============|================|=============================================|
|blocked      | blue           |This unit needs manual intervention because of a problem associated directly with the unit itself. This may be due to bad or inconsistent configuration of the service, disk space being unavailable for the unit, or missing relations which are essential to service operations. The message should tell a human administrator what is required to unblock the service. For example: “Please provide an object store. Please configure the minimum speed required by users of this service. Please link this service to a database like MySQL or Postgres.”|

|maintenance  |yellow          |The unit is not yet providing services, but is actively doing stuff in preparation for providing those services. This is a “spinning” state, not an error state. It reflects activity on the unit itself, not on peers or related units. The Juju agent will set the unit to maintenance when it begins the process of installing the charm - downloading it, unpacking it and calling the install hook.
The unit may transition to the maintenance state at any time, in any hook. The maintenance state implies that the unit has no reason to think that it will not provide services soon. For example, the software might be formatting block devices, or replicating data from peer units, or handling an action which for whatever reason means that it is not actively providing service, but it is not aware of anything on its own config or in related unit config that will prevent it from bringing up its services.

Counterparts to this unit should expect that service calls to this unit will fail during the period it is in the maintenance state, but unless they have an urgent need to move to another counterpart, they should just wait for this unit to finish churning.

Being in maintenance does not require human intervention.|

|waiting      |yellow         | The unit is unable to progress to an active state because a service to which it is related is not running. That service might be in error, blocked, waiting or maintenance. This unit expects it will be able to proceed towards active as soon as the things it is concerned about are resolved there - it needs no human attention (otherwise its status would be blocked).|
 
|active |green| This unit believes it is correctly offering all the services it is primarily installed to provide. A service can be active even if additional relations are being configured and setup. For example, a ceph osd service that is fully connected up to its controllers is active, even if you then relate it to nagios; setting up the monitoring subordinate does not impinge on the ceph osd functionality which is its primary purpose for existing.|

Additional values may be seen for a unit which have been set by Juju rather
than the charm, under the circumstances explained below:

|Status       | colour in GUI* |Meaning                                      |
|=============|================|=============================================|
| error       | red            |A charm hook for this unit has exited with a non-zero exit code (crashed).

No further hooks will be called or messages delivered until this is resolved; manually resolving or manually asking for the hook to be run, successfully, addresses the issue and resets the state to "unknown" with a message of "Error resolved with no further status from charm".|

| unknown     |yellow         | A unit-agent has finished calling install, config-changed, and start, but the charm has not called status-set yet. Rather than guess as to whether the service is working, Juju will set its status to "unknown". A unit is also marked as “unknown” when the unit agent fails for some reason eg loss of connectivity.|
|terminated |none, CLI-only | This unit used to exist, we have a record of it (perhaps because of storage allocated for it that was flagged to survive it). Nonetheless, it is now gone.|

!!! Note: * The `colour in gui` is included for information at this point, until
this feature is fully supported in the Juju GUI

 
