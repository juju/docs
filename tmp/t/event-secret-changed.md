(event-secret-changed)=
# Event 'secret-changed'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Secret events <secret-events>` > `secret-changed`</small>

```{note}
 This feature is scheduled for release in `ops` 2.0, and is only available when using Juju 3.0.2 or greater.
```

The `secret-changed` event is fired on all units observing a secret after the owner of a secret has published a new revision for it. Upon receiving that event (or at any time after that) an observer can choose to:

 - Start tracking the latest revision ("refresh")
 - Inspect the latest revision values, without tracking it just yet ("peek")

Once all observers have stopped tracking a specific outdated revision, the owner will receive a secret-remove event to be notified of that fact, and can then remove that revision.


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

Like all secret events, `secret-changed` is automatically triggered by Juju. It is up to the secret owner to create a new revision.

|   Scenario   | Example Code                          | Resulting Events                     |
| :---------------: | ---------------------------------------- | ----------------------------------------- |
|  Owner creates a new revision   | `secret.set_content(<new_payload>)`  | (all observers) `secret-changed` |


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in `ops`</h2></a>

In the Python Operator Framework, you can observe the event like you would any other:

```
self.framework.observe(charm.on.secret_changed, self._on_secret_changed)
```

The [`SecretChangedEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretChangedEvent) exposes no additional attributes on top of those it inherits from [`SecretEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretEvent).

A typical implementation of `_on_secret_changed` might look like this:

```python
def _on_secret_changed(self, event: SecretChangedEvent):
    secret = event.secret

    # validate latest revision's content (optional)
    new_content = secret.peek_content()
    if self._verify_that_password_works(new_content['password']):
        # start tracking the latest revision
        new_content = secret.get_content(refresh=True)
        self._reconfigure_workload_credentials(new_content)
```