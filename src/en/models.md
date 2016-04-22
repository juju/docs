Title: Juju Models
TODO: Review again soon (created: April 2016)

# Models

A Juju *model* is an environment associated with a cloud. When
a *controller* (see [Controllers](./controllers.html)) is 
created by bootstrapping a cloud, two models are provisioned along 
with it. 

These initial models are named '**admin**' and '**default**'. The 'admin'
model is not intended for general workloads but solely for monitoring
and management purposes.

The '**default**' model however is ready for immediate use, and multiple 
subsequent models can also be created. 
See [Creating a model](./models-creating.html).

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
