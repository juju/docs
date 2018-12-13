Title: Adding a model
TODO:  What "appropriate command options"?

# Adding a model

A controller can host multiple models to accommodate different workloads or use
cases. When a controller is created, it creates two initial models called
'controller' and 'default', but more models can be added with the `add-model`
command.

A new model inherits, by default, the cloud credentials used to create the
controller and the SSH keys copied across the model will be those of the
controller model. The administrator can override these defaults with the
appropriate command options.

Model names can be the same when hosted on different controllers, but they must
be unique when hosted on a single controller. Model names can consist only of
lowercase letters, digits, and hyphens (but cannot start with a hyphen).

See section [Managing models in a multi-user context][multiuser-models] for
information on that subject.

## Examples

Add a model named 'lxd-staging' to the current controller:

```bash
juju add-model lxd-staging
```

It is possible to add a model to a controller different to the current one. To
add a model named 'gce-test' for the non-current 'gce' controller:

```bash
juju add-model gce-test -c gce 
```

Add a model named 'rackspace-prod' to the current controller, specifying an
existing credential name of 'jon':

```bash
juju add-model rackspace-prod --credential jon
```

By default, Juju will automatically change to the newly created model.
Subsequent commands, unless the `-m` option is used to select a specific model,
will operate on this model. This can be confirmed by running the `switch`
command with no arguments. So, for example, after the above command, running:

```bash
juju switch
```

will return output like this:

```no-highlight
rackspace:admin/rackspace-prod
```

In some cases (e.g. when scripting), this behaviour may be undesirable. In this
case, you can add `--no-switch` option to keep the current model selected.


<!-- LINKS -->

[multiuser-models]: ./multiuser.md#managing-models-in-a-multi-user-context
