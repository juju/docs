Title: Juju Controllers
TODO: Review again soon (created: March 2016)


# Controllers

A Juju *controller* is a machine that gets provisioned when the initial cloud
provider *model* is created. The controller is therefore also called the
*controller model* due to it being associated with that initial model.  It
describes this model whose primary purpose is to run and manage the Juju API
servers and underlying database.

Once a controller model has been created you can define multiple models within
that environment. See [Models](./models.html).

When a controller is intended to be used by multiple people, it is recommended
that Juju's [multi-user functionality](./juju-multiuser-environments.html) be
leveraged.

It is not possible to create a second controller model for the same cloud
provider type (an error will be returned).

Since a controller can now *host* multiple models, the destruction of a
controller must be done with extreme caution as all models will be destroyed
along with it.

See [Creating a controller](./controllers-creating.html).


## Related commands

`juju bootstrap`<br/ >
`juju list-controllers`<br/ >
`juju show-controller`<br/ >
`juju destroy-controller`<br/ >
`juju kill-controller`<br/ >
`juju switch`<br/ >
`juju switch <controller>`

See the [command reference page](./commands.html) for all Juju commands.
