Title: Notes on upgrading Juju software  


# Notes on upgrading Juju software

This is an addendum to the main page describing Juju software upgrades:
[Upgrading Juju software](./models-upgrade.html).


## Agent software and related components

In general, the upgrade of the agent software is independent of the following:

- Client software

    Although client and server software are independent, an upgrade of the
    agents is an opportune time to first upgrade the client software.

- Charms

    Charms and agent versions are orthogonal to one another. There is no
    necessity to upgrade charms before or after an upgrade of the agents.

- Running workloads

    Workloads running are independent of Juju so a downtime maintenance window
    is not normally required in order to perform an upgrade.


## Version nomenclature and the auto-selection algorithm

A version is denoted by:

`major.minor.patch`

For instance: `2.0.1`

When not specifying a version to upgrade to ('--version') an algorithm will be
used to auto-select a version.

Rules:

1. If the agent major version matches the client major version, the version
   selected is minor+1. If such a minor version is not available then the next
   patch version is chosen.

1. If the agent major version does not match the client major version, the
   version selected is that of the client version.

To demonstrate, let the available online versions be: 1.25.1, 2.02, 2.03, 2.1, 
and 2.2. This gives:

- client 2.03, agent 2.01 -> upgrade to 2.02
- client 1.25, agent 1.25 -> upgrade to 1.25.1
- client 2.1, agent 1.25 -> upgrade to 2.1

The stable online agent software is found here:
https://streams.canonical.com/juju/tools/releases/


## The sync-tools command

This pertains to the lack of internet connectivity for the controller.

If the controller cannot contact the above URL then the client, which
presumably does have access, will need to download and transfer the software
to the controller prior to requesting an upgrade. This is accomplished with
the `sync-tools` command.

Examples:

Transfer the server software (auto-selected) to the state server:

```bash
juju sync-tools
```

Transfer the specified server software (all patch versions of 1.23) to the
state server:

```bash
juju sync-tools --version 1.23 --debug
```

!!! Note: the `sync-tools --version` command only accepts `major[.minor]`
("e.g. use '1.24' not '1.24.5').

For complete syntax, see the [command reference page](./commands.html#sync-tools)
or by running `juju help sync-tools`.
