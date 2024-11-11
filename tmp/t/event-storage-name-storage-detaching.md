(event-storage-name-storage-detaching)=
# Event '<storage name>-storage-detaching'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Storage events <storage-events>` > `<storage name>-storage-detaching`</small>


This document describes the `<storage name>-storage-detaching` event. The event allows a charm to perform cleanup tasks on a storage volume before that storage is dismounted and possibly destroyed. 

**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

This event is emitted when a request to detach storage has been processed. After the hook completes, the storage will be removed, and the charm will not have further opportunities to interact with it.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In `ops`, you can observe the `remove` event like you would any other:

```
self.framework.observe(self.on.<storage-name>-storage-detaching, self._on_<storage-name>-storage-detaching)
```

The event object contains information about which volume was detached.