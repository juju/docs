(event)=
# Event

```{caution}

Reference to this set of docs will soon be replaced everywhere by reference to https://ops.readthedocs.io/en/latest/# (which, wherever applicable, will further link to https://juju.is/docs/juju/hook, reflecting the correct content dependency).

```


In {ref}`Ops <ops-ops>`, an **event** is a data structure that encapsulates part of the execution context of a charm. In particular, it contains information regarding *why* this specific execution is taking place. When creating a charm, you write charms and implement handlers that respond to events and state changes communicated by [Juju](https://juju.is/docs/olm) [controller](https://juju.is/docs/olm/controllers) using the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern).


<!--make it clear that the events are triggered by Ops-->

```{note}

The execution context of a charm is expressed in environment variables. For more, see {ref}`Charm environment variables <charm-environment-variables>`.


```


For example:
 - A `config-changed` event is the data structure used to communicate to the charm that its configuration has changed.
- A `http-relation-departed` event is the data structure used to tell the charm that a particular unit is departing the `http` relation.

> See more: 
> - {ref}`List of events <list-of-events>`
> - {ref}`Charm lifecycle <charm-lifecycle>`

<!-- We need to be consistent

https://discourse.charmhub.io/t/a-charms-life/5938

The colors of the event nodes represent a logical but practically meaningless grouping of the events. green for leadership events red for storage events purple for relation events blue for generic lifecycle events
-->