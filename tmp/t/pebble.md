(pebble)=
# Pebble

**Pebble** is a lightweight, API-driven process supervisor. In the charm SDK, it is used through {ref}`Ops <ops-ops>` ({ref}``ops.pebble.Client` <13070md>`) to give workload containers something akin to an `init` system that will allow the charm container to interact with them. 

> See more: [GitHub | Pebble](https://github.com/canonical/pebble)


Pebble is the recommended way to create Kubernetes charms using the sidecar pattern.

## Pebble notices

> See also: {ref}`How to use custom notices from the workload container <13070md>`

In Pebble, a **notice** is an aggregated event to record when custom events happen in the workload container or in Pebble itself. 

> See more: [GitHub | Pebble > Notices](https://github.com/canonical/pebble#notices) 

Pebble notices are supported in Juju starting with version 3.4. Juju polls each workload container's Pebble server for new notices, and fires an event to the charm when a notice first occurs as well as each time it repeats.

Each notice has a *type* and *key*, the combination of which uniquely identifies it. A notice's count of occurrences is incremented every time a notice with that type and key combination occurs.

Currently, the only notice type is "custom". These are custom notices recorded by a user of Pebble; in future, other notice types may be recorded by Pebble itself. When a custom notice occurs, Juju fires a [`PebbleCustomNoticeEvent`](https://ops.readthedocs.io/en/latest/#ops.PebbleCustomNoticeEvent) event whose [`workload`](https://ops.readthedocs.io/en/latest/#ops.WorkloadEvent.workload) attribute is set to the relevant container.

Custom notices allow the workload to wake up the charm when something interesting happens with the workload, for example, when a PostgreSQL backup process finishes, or some kind of alert occurs.