# Configuring for Online Labs

!!! **Note:** This provider is in "beta"
and makes use of [manual provisioning](config-manual.html). Manual provisioning
allows Juju users to implement any cloud provider's API calls and act similar to
a provider implemented in the Juju Core code base.
You can access the provider source-code on [github](https://github.com/online-labs/juju-onlinelabs)

This package provides a CLI plugin for Juju that allows automated
provisioning of physical servers on Online Labs.

Online Labs is the first worldwide hosting provider to offer dedicated arm servers in the cloud.
It’s the ideal platform for horizontal scaling.
The solution provides on demand resources: it comes with on-demand SSD storage, movable IPs and an S3 compatible object storage service.
http://labs.online.net

This plugin is highly inspired from [kAPIlt](https://github.com/kAPIlt) Juju plugins.

## Requirements

!!! **Note:** This process requires you to have an Online Labs account.
The service is in preview for a few weeks and an invitation is required.
To get one, ask [@online_en](http://twitter.com) on twitter.

- You have an account and are logged into [cloud.online.net](https://cloud.online.net)
- You have configured your [SSH Key](https://doc.cloud.online.net/howto/ssh_keys.html)


## Installation

Plugin installation is done via pipi, the Python package manager, available by default on Ubuntu.
a [virtualenv](http://virtualenv.readthedocs.org/en/latest/index.html) is also recommanded to sandbox this install from your system packages:

```
pip install -U juju-onlinelabs
```

## Configuration

### Online Labs API keys

Before you can start using Juju with Online Labs, you will need to get an API token.
API tokens are unique identifiers associated with your Online Labs account.

To get one, open the pull-down menu on your account name and click on "My Credentials" link.

![Credentials](http://i.imgur.com/3rZpnTJ.png)

Then, to generate a new token, click the "Create New Token" button on the right corner.

![Tokens](http://i.imgur.com/cJcnO9S.png)

In a terminal, export your credentials required by the plugin using environment variables:

```
export ONLINELABS_ACCESS_KEY=<organization_key>
export ONLINELABS_SECRET_KEY=<secret_token>
```

!!! **Note:** As environment variables are not shared between shells, you will need to repeat this operation for every shell.
You can avoid this repetition by adding this environment variables in your shell's rc files, for instance append them to your `~/.bashrc` or `~/.zshrc`

### Juju configuration

The next step is to add an environment for Online Labs in your '~/.juju/environments.yaml'. This environment will look like the following:

```
    # https://juju.ubuntu.com/docs/config-onlinelabs.html
    onlinelabs:
        type: manual
        bootstrap-host: null
        bootstrap-user: root
```

Then, you have to tell Juju which environment to use.
To do this, in a terminal use the following command:

```
export JUJU_ENV=onlinelabs
```

To set Online Labs as your default provider, run the following command in your terminal:

```
juju switch onlinelabs
```

## Bootstrapping

Now you can bootstrap your Online Labs environment.
You need to route the command through the onlinelabs plugin that we installed via pip.

```
juju onlinelabs bootstrap
```

All machines created by this plugin will have the Juju environment
name as a prefix for their servers name, for instance `onlinelabs-XXXYYYZZZ`

After your environment is bootstrapped you can add additional machines
to it via the `add-machine` command, for instance the following will
add 2 additional machines:

```
juju onlinelabs add-machine -n 2
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

You can list all machines in Online Labs that are part of the Juju
environment with the list-machines command. This directly queries the Online
Labs API and does not interact with the Juju API.

```
juju onlinelabs list-machines

Id       Name               Status   Created      Address
6222349  onlinelabs-0            active   2014-11-25   212.47.239.232
6342360  onlinelabs-ef19ad5cc... active   2014-11-25   212.47.228.28
2224321  onlinelabs-145bf7a80... active   2014-11-25   212.47.228.79
```

You can terminate allocated machines via their machine id. By default, the
Online Labs plugin forces the terminatiom of machines, which also terminates any service unit running on on those machines:

```
juju onlinelabs terminate-machine 1 2
```

And you can destroy the entire environment via:

```
juju onlinelabs destroy-environment
```

destroy-environment also takes a --force option which only uses the
Online Labs API. It's helpful if the state server or other machines are
killed independently of Juju.

