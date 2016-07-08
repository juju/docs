Title: Adding a model

# Adding a model

A Juju [controller][controller] can host multiple models to accomodate
different workloads or use cases. When a controller is created, it creates
an initial model called 'default', but more models can be added to the
controller using the `juju add-model` command:

```
juju add-model [options] <model name>
```

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




[controller]: ./controllers.html
[commands]: ./commands.html#juju-add-model