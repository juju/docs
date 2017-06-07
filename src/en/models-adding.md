Title: Adding a model

# Adding a model

A Juju [controller][controller] can host multiple models to accommodate
different workloads or use cases. When a controller is created, it creates
an initial model called 'default', but more models can be added to the
controller using the `juju add-model` command:

```
juju add-model [options] <model name>
```

Model names can be the same when hosted on different controllers, but they must
be unique when hosted on a single controller. For example, two users could both
have a model called 'secret', but each user could only host one model names
'secret' on a single controller. 

Model names may only contain lowercase letters, digits and hyphens, and may not
start with a hyphen.

See `juju help add-model` for details on this command or see the
[command reference page][commands].

## Examples

Add a model named 'lxd-trusty-staging' for the current (LXD) controller:

```bash
juju add-model lxd-trusty-staging
```

It is possible to add a model for a controller different to the current one, by 
specifying the controller to use. To add a model named 'gce-test' for the 
non-current 'gce' controller:

```bash
juju add-model gce-test --controller gce 
```

Add a model named 'rackspace-prod' for the current (Rackspace) controller,
specifying an existing credential ('mysecret'):

```bash
juju add-model rackspace-prod --credential mysecret
```

By default, Juju will automatically select the newly created model as the
default, so that subsequent commands (unless using the `-m` switch to 
choose a specific model) will operate on this model. This can be confirmed
by running the `juju switch` command with no arguments. So, for example,
after the above command, running:

```bash
juju switch
```

...will return output like this:

```bash
rackspace:admin/rackspace-prod
```

In some cases (e.g. when scripting), this behaviour may be undesirable. In
this case, you can add `--no-switch` to the command to keep the currently
selected model as the default:

```bash
juju add-model rackspace-dev --no-switch
juju switch
```

...will still return:

```bash
rackspace:admin/rackspace-prod
```


 



[controller]: ./controllers.html
[commands]: ./commands.html#juju-add-model
