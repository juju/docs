Title: Creating a Juju Model
TODO: Review again soon (created: March 2016)
      Remove Note re bug 1552469 when fixed; remove Note and --config option from Rackspace example


# Creating a model

Use the `juju create-model` command to create a *hosted model* for a given
provider:

`juju create-model [options] <model name> [key=[value] ...]`

See `juju help create-model` for details on this command or see the
[command reference page](./commands.html#juju-create-model).

## Notes

!!! Note: Due to
[LP #1552469](https://bugs.launchpad.net/juju-core/+bug/1552469) credentials
already set during the creation of the controller model are not utilised
automatically when creating a model. Depending on provider, you may need to
supply credentials.


## Examples

**1.** Create model 'rackspace-prod' for the current (Rackspace) controller:

!!! Note: Because of 
[LP #1552469](https://bugs.launchpad.net/juju-core/+bug/1552469) 
you will need to create a 3-line file for these parameters:
`username`, `password`, and `tenant-name` and then refer to it.

```bash
juju create-model --config=~/config-rackspace_creds.yaml rackspace-prod
```

**2.** Create model 'lxd-trusty-staging' for the current (LXD) controller:

```bash
juju create-model lxd-trusty-staging
```
