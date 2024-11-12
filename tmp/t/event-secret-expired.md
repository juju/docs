(event-secret-expired)=
# Event 'secret-expired'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Secret events <secret-events>` > `secret-expired`</small>

```{note}
 This feature is scheduled for release in `ops` 2.0, and is only available when using Juju 3.0.2 or greater.
```

If a secret was added with the `expire` argument set to some future time, when that time elapses, Juju will notify the owner charm that the expiration time has been reached by firing a `secret-expired` event on the owner unit. 

```{note}
 The owner can be a specific unit, in which case only that unit will receive the event, or it can be the application as a whole, in which case the leader unit will receive it.
```

Upon receiving that event (or at any time after that) the owner will typically want to create a new secret revision. When a new revision is created, the observer units will be notified with a `secret-changed` event and can update to the new revision.

Once all observers have done so, and there are therefore no observers left tracking the old revision, the owner will receive a `secret-remove` event. At this point the revision can be removed.


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

Like all secret events, `secret-expired` is automatically triggered by Juju. It is fired by Juju whenever the expiration timeout is reached.

|   Scenario   | Example Code                          | Resulting Events                     |
| :---------------: | ---------------------------------------- | ----------------------------------------- |
|  Secret timeout reached   | n/a  | (all owners) `secret-expired` |


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in `ops`</h2></a>

In the Python Operator Framework, you can observe the event like you would any other:

```
self.framework.observe(charm.on.secret_expired, self._on_secret_expired)
```

The [`SecretExpiredEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretExpiredEvent) exposes the attributes it inherits from [`SecretEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretEvent) as well as a [`revision`](https://ops.readthedocs.io/en/latest/#ops.SecretExpiredEvent.revision) attribute which specifies which revision this event refers to.

A typical implementation of `_on_secret_expired` might look like this:

```python
def _on_secret_expired(self, event: SecretExpiredEvent):
    secret = event.secret
    # create a new revision:
    secret.set_content({'new_password': self._generate_new_password()})
```