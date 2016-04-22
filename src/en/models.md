Title: Juju Models
TODO: Review again soon (created: March 2016)


# Models

A Juju *model* is an environment associated with a cloud provider type. When
the **initial** model is added a *controller* (see
[Controllers](./controllers.html)) is provisioned along with it. It is not
possible to add a second controller for the same cloud provider type (an
error will be returned).

Once the initial model has been created, multiple subsequent models can be
added. Indeed, it is considered best practice to add additional models for
deploying workloads, leaving the controller model for Juju's own
infrastructure. Services can still be deployed to the controller model, but it
is generally expected that these be solely for management and monitoring
purposes (e.g. Nagios, Landscape).

See [Adding a model](./models-adding.html).


## Related commands

`juju list-models`<br/ >
`juju add-model`<br/ >
`juju use-model`<br/ >
`juju share-model`<br/ >
`juju list-shares`<br/ >
`juju destroy-model`<br/ >
`juju switch`<br/ >
`juju switch <model>`<br/ >

See the [command reference page](./commands.html) for all Juju commands.
