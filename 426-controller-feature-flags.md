# Controller Feature Flags

Controller feature flags were introduced with Juju 2.4. This is a part of the controller configuration and allows for testing new features that are being implemented that haven't been fully released.

Most of these feature flags are very developer focused, and should not be necessary for normal Juju controller operation.

## Setting and resetting the flags

Flags are set using the `controller-config` command, and as such can only be changed by those that have permission to change the controller config. Zero or more values can be specified, and the values set replace any that may be there already.

By default there are no features specified for a new controller.

    $ juju controller-config features
    ERROR key "features" not found in "test" controller

Setting a single value needs to be done inside square brackets:

    $ juju controller-config features=[some-feature]
    $ juju controller-config features
    - some-feature

Mutiple values can be specified, separated by a comma:

    $ juju controller-config features=[foo,bar]
    $ juju controller-config features
    - foo
    - bar

To clear out the features, just specify no values between the square brackets. This is currently requried due to a bug in controller-config where there is no `--reset` option.

    $ juju controller-config features=[]
    $ juju controller-config features
    []


## Features

### old-presence v2.5 only

The default presence implementation changed in 2.5. Presence is how Juju knows whether agents are alive or not. If there are issues with the new implementation the old implementation can be switched to by setting this feature.

    $ juju controller-config features=[old-presence]

### legacy-leases v2.5 only

As with presence, the default leases implementation also changed in 2.5. The leases feature is used to manage unit leadership. This is the code that determins which unit is the leader, and how long that unit stays the leader. As with any new feature there is the potential for problems, so the old behaviour can be used by specifying the `legacy-leases` feature. Once this feature is set the controllers need to be restarted.

    $ juju controller-config features=[legacy-leases]

### disable-state-metrics v2.4 and later

There is an inefficient implementation used to gather some of the metrics that are exposed for Prometheus to collect. This is especially evident with large controllers. This flag disables those metrics to make the gathering much faster. The metrics that are disabled all start with `juju_state_`. This is a temporary measure as the team reworks how to gether these metrics efficiently.

    $ juju controller-config features=[disable-state-metrics]

### new-presence v2.4 only

The feature allows the new presence implementation that is the default in 2.5 to be tested in 2.4 controllers.

    $ juju controller-config features=[new-presence]


### disable-raft v2.4 only

Raft workers were added to managed the distributed concensus that is to be used for the new leadership implementation that is in 2.5. This feature allowed for those workers to be switched off. There should be no impact to having the workers running, and this feature was added as an insurance mechanism.

    $ juju controller-config features=[disable-raft]
