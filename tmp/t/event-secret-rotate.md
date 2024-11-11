(event-secret-rotate)=
# Event 'secret-rotate'

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > {ref}`Secret events <secret-events>` > `secret-changed`</small>

```{note}
 This feature is scheduled for release in `ops` 2.0, and is only available when using Juju 3.0.2 or greater.
```

The `secret-rotate` event is fired on the owner of a secret every time the rotation period elapses (and the event will keep firing until the owner rotates the secret).

Upon receiving that event the owner should create a new secret revision. Once that is done, all observers will be notified that a new revision is present by means of a `secret-changed` event.

If the owner did not specify a rotation policy upon creating the secret, this event will never be fired for that secret.


<a href="#heading--emission-sequence"><h2 id="heading--emission-sequence">Emission sequence</h2></a>

Like all secret events, `secret-rotate` is automatically triggered by Juju. When the owner adds the secret, it can select what the rotation period will be: hourly, daily, weekly, monthly, quarterly, or yearly.

|   Scenario   | Example Code                          | Resulting Events                     |
| :---------------: | ---------------------------------------- | ----------------------------------------- |
|  Owner creates a secret rotating daily   | n/a  | (every day) `secret-rotate` |


<a href="#heading--observing-this-event-in-ops"><h2 id="heading--observing-this-event-in-ops">Observing this event in `ops`</h2></a>

In the Python Operator Framework, you can observe the event like you would any other:

```
self.framework.observe(charm.on.secret_rotate, self._on_secret_rotate)
```

The [`SecretRotateEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretRotateEvent) exposes no additional attributes on top of those it inherits from [`SecretEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretEvent).

A typical implementation of `_on_secret_rotate` might look like this:

```python
def _on_secret_rotate(self, event: SecretRotateEvent):
    secret = event.secret

    # create a new revision
    secret.set_content({'username': secret.get_content()['username'], 
                        'password': self._generate_new_password()})
```