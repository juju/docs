(secret-events)=
# Secret events

> <small> {ref}`Event <event>` > {ref}`List of events <list-of-events>` > Secret events</small>
>
> See also: {ref}`How to add a secret to your charm <how-to-use-secrets-in-a-charm>`

**Contents:**

- [Complete list of secret events](#heading--complete-list-of-secret-events)
- [Secret event triggers](#heading--secret-event-triggers)
- [Secret events in `ops`](#heading--secret-events-in-ops)

<a href="#heading--complete-list-of-secret-events"><h2 id="heading--complete-list-of-secret-events">Complete list of secret events</h2></a>

- {ref}``secret-changed` <event-secret-changed>` is emitted to the observer of a secret to notify it that a new revision is available.
- {ref}``secret-expired` <event-secret-expired>` is emitted to the owner of a secret to notify it that the expiration time has been hit and a new revision should be created.
- {ref}``secret-remove` <event-secret-remove>` is emitted to the owner of a secret to notify it that all observers have updated to a new revision and the old revision can be safely removed.
- {ref}``secret-rotate` <event-secret-rotate>` is emitted to the owner of a secret to notify it that the rotation time has elapsed and a new revision should be created.

<a href="#heading--secret-event-triggers"><h2 id="heading--secret-event-triggers">Secret event triggers</h2></a>

Secret events can't be directly triggered by Juju admin operations. Most other events occur because someone did something on the Juju CLI (created a relation, scaled something down, and so on); secret events are, however, exclusively triggered either by charm code or an internal Juju timeout (similar to `update-status`).

<a href="#heading--secret-events-in-ops"><h2 id="heading--secret-events-in-ops">Secret events in `ops`</h2></a>

In `ops`, all secret events inherit from [`ops.charm.SecretEvent`](https://ops.readthedocs.io/en/latest/#ops.SecretEvent), which has a `secret` attribute that provides the [`Secret`](https://ops.readthedocs.io/en/latest/#ops.Secret) instance this event refers to. The `Secret` object has various attributes and methods that can be used to interact with the secret -- see the [API reference](https://ops.readthedocs.io/en/latest/#ops.Secret) for details.