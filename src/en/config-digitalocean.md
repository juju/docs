Title: Configuring for DigitalOcean  

# Configuring for DigitalOcean

!!! **Note:** This particular provider is in "beta" as it is developed by
community member [Kapil Thangavelu](http://github.com/kapilt/juju-digitalocean)
and makes use of [manual provisioning](config-manual.html). Manual provisioning
allows Juju users to implement any cloud provider's API calls and acts similar
to a standard provider implemented via the Juju project.

This process requires you to have a DigitalOcean account. If you have not
signed up for one yet, it can obtained at
[http://digitalocean.com](http://digitalocean.com).


## Prerequisites

You should start by installing Juju, as well as the juju-docean plugin from pip.
This will require you to install python-pip if it is not already installed.

```bash
add-apt-repository ppa:juju/stable
apt-get update
apt-get install juju python-pip
pip install juju-docean
```


## Configuration

Now generate a generic configuration file for Juju:

```bash
juju generate-config
```

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

!!! **Note:** If you have an existing configuration, you can use `juju
generate-config --show` to output the new config file, then copy and paste
relevant areas in a text editor etc.

You will need to add a section for DigitalOcean which will look like the
following:

```yaml
# https://jujucharms.com/docs/config-digitalocean.html
    digitalocean:
        type: manual
        bootstrap-host: null
        bootstrap-user: root
```


This is a simple configuration intended to run on DigitalOcean. When
bootstrapped, the tools will be served from the bootstrap-host on storage port
8040.

You will also need to obtain your account's `ClientID` and `APIKey` from the
Apps & API page.

![DigitalOcean Apps and API page v2 Listing](./media/getting_started_do_api_v2.png)
![DigitalOcean Apps and API page v1 Listing](./media/getting_started_do_api_v1.png)

You will additionally need to set your API Key and ID in your shell's rc files,
for example append the following to `~/.bashrc`

```no-highlight
export DO_CLIENT_ID="XXX"
export DO_API_KEY="XXX"
```

then source the file so it's loaded in your current environment:

```bash
source ~/.bashrc
```

## DigitalOcean configuration

In order for Juju to access the nodes, you will need an SSH key populated
within the DigitalOcean Control panel.

![DigitalOcean SSH Key Listing](./media/getting_started_do_ssh_key.png)


## Bootstrapping

In order to make DigitalOcean the default provider in which all subsequent
commands issued will be performed against

```bash
juju switch digitalocean
```

To bootstrap a DigitalOcean environment, you will need to route the command
through the docean plugin that we installed via `pip`.

```bash
juju docean bootstrap
```

This command also respects [constraints](charms-constraints.html) so you can
size your bootstrap node should your deployment be larger than the default
instance type can handle

```bash
juju docean bootstrap --constraints="mem=2G, region=nyc2"
```
This will create a droplet with 2GB of memory in the 'nyc2' data centre.

All machines created by this plugin will have the Juju environment name as a
prefix for their droplet name if you're looking at the DO control panel.

We can now use standard Juju commands for deploying service workloads via
charms:

```bash
juju deploy wordpress
```

Without specifying the machine to place the workload on, the machine will
automatically go to an unused machine within the environment.


## Constraints

Constraints are selection criteria used to determine what type of machine to
allocate for an environment. Those criteria can be related to size of the
machine, its location, or other provider specific criteria.

This plugin accepts these standard Juju constraints:

- cpu-cores
- memory
- root-disk

!!! **Note:** Additionally it supports the following provider specific
constraints. **region** and **transfer**

- region - to denote the DigitalOcean data centre to utilize. All DigitalOcean
  data centres are supported and various short hand aliases are defined. ie.
  valid values include ams2, nyc1, nyc2, sfo1, sg1. The plugin defaults to 'nyc2'.

- transfer - to denote the terabytes of transfer included in the instance
  monthly cost (integer size in gigabytes).
