Title: Adding a Juju Model
TODO: Review again soon (created: March 2016)
      Remove Note re bug 1552469 when fixed; remove Note and --config option from Rackspace example


# Adding a model

Use the `juju add-model` command to add a *hosted model* for a given
provider:

`juju add-model [options] <model name> [key=[value] ...]`

See `juju help add-model` for details on this command or see the
[command reference page](./commands.html#juju-add-model).

## Notes

!!! Note: Due to
[LP #1552469](https://bugs.launchpad.net/juju-core/+bug/1552469) credentials
already set during the creation of the controller model are not utilised
automatically when adding a new model. Depending on provider, you may need to
supply credentials.


## Examples

**1.** Add model 'rackspace-prod' for the current (Rackspace) controller:

!!! Note: Because of 
[LP #1552469](https://bugs.launchpad.net/juju-core/+bug/1552469) 
you will need to create a 3-line file for these parameters:
`username`, `password`, and `tenant-name` and then refer to it.

```bash
juju add-model --config=~/config-rackspace_creds.yaml rackspace-prod
```

**2.** Add model 'lxd-trusty-staging' for the current (LXD) controller:

```bash
juju add-model lxd-trusty-staging
```
