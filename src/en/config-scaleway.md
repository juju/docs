# Configuring for Scaleway

!!! **Note:** This provider is in "beta"
and makes use of [manual provisioning](config-manual.html). Manual provisioning
allows Juju users to implement any cloud provider's API calls and act similar to
a provider implemented in the Juju Core code base.
You can access the provider source-code on [github](https://github.com/scaleway/juju-scaleway)

This package provides a CLI plugin for Juju that allows automated
provisioning of C1 BareMetal SSD servers on Scaleway.

Scaleway is the first IaaS provider worldwide to offer an ARM based cloud.
It’s the ideal platform for horizontal scaling.
The solution provides on demand resources: it comes with on-demand SSD storage, movable IPs
, images, security group and an Object Storage solution.
https://scaleway.com

This plugin is highly inspired from [kAPIlt](https://github.com/kAPIlt) Juju plugins.

## Requirements

!!! **Note:** This process requires you to have an Scaleway account.

- You have an account and are logged into [cloud.scaleway.com](https://cloud.scaleway.com)
- You have configured your [SSH Key](https://www.scaleway.com/docs/configure_new_ssh_key)
- You have installed libffi-dev and libssl-dev

## Installation

Plugin installation is done via pipi, the Python package manager, available by default on Ubuntu.
a [virtualenv](http://virtualenv.readthedocs.org/en/latest/index.html) is also recommanded to sandbox this install from your system packages:

```
pip install -U juju-scaleway
```

## Configuration

### Scaleway API keys

Before you can start using Juju with Scaleway, you will need to get an API token.
API tokens are unique identifiers associated with your Scaleway account.

To get one, open the pull-down menu on your account name and click on "My Credentials" link.

![Credentials](http://i.imgur.com/3rZpnTJ.png)

Then, to generate a new token, click the "Create New Token" button on the right corner.

![Tokens](http://i.imgur.com/cJcnO9S.png)

In a terminal, export your credentials required by the plugin using environment variables:

```
export SCALEWAY_ACCESS_KEY=<organization_key>
export SCALEWAY_SECRET_KEY=<secret_token>
```

!!! **Note:** As environment variables are not shared between shells, you will need to repeat this operation for every shell.
You can avoid this repetition by adding this environment variables in your shell's rc files, for instance append them to your `~/.bashrc` or `~/.zshrc`

### Juju configuration

The next step is to add an environment for Scaleway in your '~/.juju/environments.yaml'. This environment will look like the following:

```
    # https://jujucharms.com/docs/config-scaleway.html
    scaleway:
        type: manual
        bootstrap-host: null
        bootstrap-user: root
```

Then, you have to tell Juju which environment to use.
To do this, in a terminal use the following command:

```
export JUJU_ENV=scaleway
```

To set Scaleway as your default provider, run the following command in your terminal:

```
juju switch scaleway
```

## Bootstrapping

Now you can bootstrap your Scaleway environment.
You need to route the command through the scaleway plugin that we installed via pip.

```
juju scaleway bootstrap
```

All machines created by this plugin will have the Juju environment
name as a prefix for their servers name, for instance `scaleway-XXXYYYZZZ`

After your environment is bootstrapped you can add additional machines
to it via the `add-machine` command, for instance the following will
add 2 additional machines:

```
juju scaleway add-machine -n 2
juju status
```

You can now use standard Juju commands to deploy service workloads (also known as charms):

```
juju deploy wordpress
```

If you don't specify a machine to place the workload on, the machine
will automatically go to an unused machine within the environment.

You can use manual placement to deploy target particular machines:

```
juju deploy mysql --to=2
```

This command deploys a mysql unit to the server number #2

Assemble these workloads together via relations like lego blocks:

```
juju add-relation wordpress mysql
```

You can list all machines in Scaleway that are part of the Juju
environment with the list-machines command. This directly queries the Scaleway
API and does not interact with the Juju API.

```
juju scaleway list-machines

Id       Name               Status   Created      Address
6222349  scaleway-0            active   2014-11-25   212.47.239.232
6342360  scaleway-ef19ad5cc... active   2014-11-25   212.47.228.28
2224321  scaleway-145bf7a80... active   2014-11-25   212.47.228.79
```

You can terminate allocated machines via their machine id. By default, the
Scaleway plugin forces the terminatiom of machines, which also terminates any service unit running on on those machines:

```
juju scaleway terminate-machine 1 2
```

And you can destroy the entire environment via:

```
juju scaleway destroy-environment
```

destroy-environment also takes a --force option which only uses the
Scaleway API. It's helpful if the state server or other machines are
killed independently of Juju.

