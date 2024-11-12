(storage-events)=
# Storage events

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>`> Storage events </small>
>
> See also: {ref}`A charm's life <charm-lifecycle>`,  {ref}`How to access storage <6499md>`

Storage events are those events that are about the lifecycle of juju storage.

**Contents:**
- [Complete list of storage events](#heading--complete-list-of-storage-events)
- [Storage event triggers](#heading--storage-event-triggers)
- [Storage events in `ops`](#heading--storage-events-in-ops)

<a href="#heading--complete-list-of-storage-events"><h2 id="heading--complete-list-of-storage-events">Complete list of storage events</h2></a>

 - {ref}``<storage-name>-storage-attached` <event-storage-name-storage-attached>`; emitted when a storage mount is attached.
 - {ref}``<storage-name>-storage-detaching` <event-storage-name-storage-detaching>`; emitted when a storage mount is detached.


<a href="#heading--storage-event-triggers"><h2 id="heading--storage-event-triggers">Storage event triggers</h2></a>

TO BE ADDED

<a href="#heading--storage-events-in-ops"><h2 id="heading--storage-events-in-ops">Storage events in `ops`</h2></a>

In `ops`, all storage events inherit from [`ops.charm.StorageEvent`](https://ops.readthedocs.io/en/latest/index.html?highlight=storageevent#ops.charm.StorageEvent), which gives them the following attributes:
- {ref}``storage` <6499md>`: the `ops.model.Storage` instance this event is about.