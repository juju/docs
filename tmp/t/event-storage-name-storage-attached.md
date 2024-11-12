(event-storage-name-storage-attached)=
# Event '<storage name>-storage-attached'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Storage events <storage-events>` > `<storage name>-storage-attached`</small>


This document describes the `<storage name>-storage-attached` event. The event informs a charm that a storage volume has been attached, and is ready to interact with.


**Contents:**
- [Emission sequence](#heading--emission-sequence)
- [Observing this event in Ops](#heading--observing-this-event-in-ops)


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

The event is emitted after a storage volume has been attached to the charm's host machine or container.

<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in Ops</h2></a>

In `ops`, you can observe the `remove` event like you would any other:

```
self.framework.observe(self.on.<storage-name>-storage-attached, self._on_<storage-name>-storage-attached)
```

The event object contains information about what volume was attached, at what path.