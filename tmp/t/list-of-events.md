(list-of-events)=
# List of events

> <small> {ref}`Event <event>` > List of events </small>

In charms, events are of two basic kinds -- Juju events and Ops events.

- [Juju events](#heading--juju-events)
- [Ops events](#heading--ops-events)

<a href="#heading--juju-events"><h2 id="heading--juju-events">Juju events</h2></a>

The complete list of Juju events includes the following statically-named events:

- {ref}`Lifecycle events <lifecycle-events>`                              
    - {ref}``collect-metrics` (deprecated) <event-collect-metrics-deprecated>`                       
    - {ref}``config-changed` <event-config-changed>`                        
    - {ref}``install` <event-install>`                               
    - {ref}``leader-elected` <event-leader-elected>`                        
    - {ref}``leader-settings-changed` <event-leader-settings-changed>`               
    - {ref}``post-series-upgrade` <event-post-series-upgrade>`                   
    - {ref}``pre-series-upgrade` <event-pre-series-upgrade>`                    
    - {ref}``remove` <event-remove>`                                
    - {ref}``start` <event-start>`                                 
    - {ref}``stop` <event-stop>`                                  
    - {ref}``update-status` <event-update-status>`                         
    - {ref}``upgrade-charm` <event-upgrade-charm>`      
- {ref}`Secret events <secret-events>`                                
    - {ref}``secret-changed` <event-secret-changed>`       
    - {ref}``secret-expired` <event-secret-expired>`
    - {ref}``secret-remove` <event-secret-remove>`
    - {ref}``secret-rotate` <event-secret-rotate>`

And the following dynamically-named events:

```{note}

The placeholder element stands for the names defined in the `charmcraft.yaml` file of the charm. 

```

For each action supported by the charm:
- {ref}``<action name>-action` <event-action-name-action>`

For each `container` attached to the charm:
- {ref}``<container>-pebble-custom-notice` <event-container-pebble-custom-notice>`
- {ref}``<container>-pebble-ready` <event-container-pebble-ready>`
- [`<container>-pebble-check-failed`](https://ops.readthedocs.io/en/latest/#ops.PebbleCheckFailedEvent) (in Juju 3.6 and above)
- [`<container>-pebble-check-recovered`](https://ops.readthedocs.io/en/latest/#ops.PebbleCheckRecoveredEvent) (in Juju 3.6 and above)

For each `relation` endpoint supported by the charm, five relation events:

- {ref}`Relation events <relation-events>`                               
    - {ref}``<relation name>-relation-broken` <event-relation-name-relation-broken>`       
    - {ref}``<relation name>-relation-changed` <event-relation-name-relation-changed>`      
    - {ref}``<relation name>-relation-created` <event-relation-name-relation-created>`      
    - {ref}``<relation name>-relation-departed` <event-relation-name-relation-departed>`     
    - {ref}``<relation name>-relation-joined` <event-relation-name-relation-joined>`       

For each `storage` endpoint supported by the charm, two storage events:

- {ref}`Storage events <storage-events>`                                
    - {ref}``<storage name>-storage-attached` <event-storage-name-storage-attached>`       
    - {ref}``<storage name>-storage-detaching` <event-storage-name-storage-detaching>`

<a href="#heading--ops-events"><h2 id="heading--ops-events">Ops events</h2></a>

The operator framework defines some events to facilitate the charm lifecycle management.
These events are internal in the sense that Juju is completely unaware of them. Juju emits, say, a `start` event, but the operator framework can emit on the charm, on top of `start`, any number of events. Deferred events, or any of these `ops` events:

- {ref}``collect-app-status` <events-collect-app-status-and-collect-unit-status>`      
- {ref}``collect-unit-status` <events-collect-app-status-and-collect-unit-status>`      
- `pre-commit`
- `commit`

In addition to this, every Framework object (including charms) can define its own custom events.

> See more: {ref}`Custom event <custom-event>`