Title: Adding a model

# Adding a model

A controller can host multiple models to accommodate different workloads or use
cases. When a controller is created, it creates two initial models called
'controller' and 'default', but more models can be added with the `add-model`
command. See [Creating a controller][controllers-creating] for details.

It is important to understand that credentials used with Juju are always
associated with a model. When creating a model, therefore, a credential is
either specified explicitly or a default is used. Read the
[Credentials][credentials] page for background information.

When a model is added the associated credential is validated with the backing
cloud. As long as this check passes the model can be created and any of its
subsequent machines will be created using those credentials. Care is therefore
advised if the list of credentials to choose from contains multiple credentials
(accounts) for the same cloud type.

The model creator, by default, is granted 'admin' model access by default. This
includes the two initial models created at controller-creation time. This
assists in connecting to machines within the model with `juju ssh` (see
[SSH keys and models][machine-auth-ssh-keys]). An exception to this is when the
creator explicitly designates another user as 'owner'. In this case, the
creator does not get 'admin' model access.

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

Here we're creating model 'han' in a multi-user context. We assign Juju user
'don' as model owner in addition to specifying credential 'ren':

```bash
juju add-model han --owner don --credential ren
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
[controllers-creating]: ./controllers-creating.md
[credentials]: ./credentials.md
[machine-auth-ssh-keys]: ./machine-auth.md#ssh-keys-and-models
