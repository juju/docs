<!--
Todo:
- Warning: Ubuntu release versions hardcoded
-->

When your computer has LXD installed, Juju can operate the "`localhost`" cloud. The localhost cloud provides the experience of working with a public cloud without needing to incur any financial cost.

Reasons to use Juju on localhost:

- creating a repeatable deployment: Juju enables you to quickly iterate to construct the optimal deployment for your situation, then distribute that across your team
- local development: Juju's localhost cloud can mirror the production ops environment (without incuring the costs involved with duplicating it)
- learning Juju: LXD is a lightweight tool for exploring Juju and how it operates
- rapid prototyping: LXD is great for when you're creating a new charm and want to be able to quickly provision capacity and tear it down  

[note]
If you would like to run Kubernetes workloads on your computer with Juju, we recommend [MicroK8s](https://microk8s.io/) with the [MicroK8s cloud](/t/using-juju-with-microk8s/1194).
[/note]

[note]
If you are looking to connect to a LXD server, rather than accessing LXD installed locally, then read [Adding a remote LXD cloud](/t/using-lxd-with-juju-advanced/1091#heading--adding-a-remote-lxd-cloud).  
[/note]



## About LXD

LXD is an open source hypervisor that is secure, lightweight, and very easy to use. For Juju users, LXD makes it easy to create a cloud in your laptop.
It provides secure system containers based on the LXC functionality within the Linux kernel and virtual machines via QEMU.

[details="Need to install LXD?"]
See LXD's [Getting Started](https://linuxcontainers.org/lxd/getting-started-cli/) page at linuxcontainers.org for installation instructions for Windows, macOS, and Linux.
[/details]

[details="Why not Docker, Vagrant or another option?"]
Docker containers are a great solution for running a single application within a container.
Its model has some weaknesses when used more widely.
LXD focuses on system-level virtualization, offering an operating system-like like environment within a container.
More importantly though, LXD offers greater security.
LXD does not require privileged containers, unlike Docker.

Vagrant requires resource-intensive virtual machines.
This can make it difficult to simulate large models.
[/details]

## Setting up the localhost cloud

The localhost cloud requires minimal setup. Neither registering LXD with Juju, nor security credentials are required.

### Configure LXD

If you have not already done so, you will need to run `lxd init` to carry out from post-installation tasks. For most environments, using the default parameters is usually preferred:

```text
lxd init --auto
```

There are several options, however. See the [Getting Started with LXD](https://linuxcontainers.org/lxd/getting-started-cli/#initial-configuration) webpage and the output from `lxd init --help` for more details. 


### Configure Networking

Currently, Juju does not support IPv6. Therefore, you will need to request that LXD does not allocate IPv6 addresses for containers and virtual machine instances that it creates.

```text
lxc network set lxdbr0 ipv6.address none
```

## Deploying workloads

Workloads live within a "model" that is managed by the "Juju controller". 

### Creating a controller

Use the `juju bootstrap` command to provision a machine within LXD and create a controller running within it.

```text
juju bootstrap localhost
```


The bootstrap process is highly configurable, but changing the settings is rarely required while evaluating Juju. See the [Creating a controller](/t/creating-a-controller/1108) page for further details.


### Adding a model

A model is a workspace for a set of inter-related applications. It houses machines and applications (often referred to as "workloads"), as well as associated resources such as firewall rules and storage volumes.

```text
juju add-model <model>
```

Models are tied to Juju user accounts. This allows Juju administrators to create fine-grained access controls over the infrastructure used by their team. 

Adding a model does not create compute resources. They are provisioned on-demand with the `juju deploy` and `juju add-machine` commands. 


### Deploying a workload

The `juju deploy` command deploys a charm as an application. To explore how this works, consider following through 1 or more of these tutorials:

- [A high-availability PostgreSQL cluster](https://juju.is/tutorials/deploy-postgres-on-ubuntu-server)
- [A multi-node RabbitMQ cluster](https://juju.is/tutorials/deploy-rabbitmq-cluster-on-ubuntu-server)
- [Nextcloud and Collabora both backed by HTTPS](https://juju.is/tutorials/deploy-nextcloud-and-collabora-on-ubuntu)

## Next steps

### Learn Juju's core commands

Juju includes lots of functionality (see `juju help commands` for a full list). Here is a brief list of the most helpful commands to use when you are getting started:

- `juju dashboard` provides a real-time web dashboard of all the models managed by the controller
- `juju status` provides a view of a model, its applications, their units and other resources
- `juju deploy` deploys a new charm (or bundle) as application(s) within a model 
- `juju ssh` allows you to access a secure shell into any machine or unit within the model
- `juju switch` allows you to switch between models and controllers 

Use `juju help <command>` for detailed usage instructions on every command provided by Juju.


### Learn Juju's concepts

Becoming familiar with Juju involves learning some new terminology:

- [Models](/t/models/1155) house applications
- [Applications](/t/applications-and-charms/1034)  are "instances" of charms that are comprised of units. A unit occupies a machine. That machine may be also be used by other units.
- [Relations](/t/managing-relations/1073) are a data exchange system between applications facilitated by the Juju controller

## Common Questions

### How do I find charms to deploy?

Visit the [Charm Store](https://jaas.ai/store ). 

### How do I access help?

We recommend creating an account in the [Juju Discourse forum](https://discourse.juju.is/).

### How do I inspect the model?

Use the `juju dashboard` and/or the `juju status` command.

## How do Juju machines correspond to LXC containers?

There is a 1:1 correspondence between machine and container. From the command-line, we can request that Juju report the list of machines within the controller model:

``` text
juju machines -m controller
```

``` text
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.243.67.177  juju-c795fe-0  bionic      Running
```

The "Inst id" column corresponds to the "NAME" column from LXC's output:

``` text
lxc list
```

``` text
+---------------+---------+----------------------+------+------------+-----------+
|     NAME      |  STATE  |         IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
+---------------+---------+----------------------+------+------------+-----------+
| juju-c795fe-0 | RUNNING | 10.243.67.177 (eth0) |      | PERSISTENT |           |
+---------------+---------+----------------------+------+------------+-----------+
```

## Considerations with the localhost cloud

Juju aims to abstract away the differences between individual cloud providers. LXD offers the following differences:

### Constraints

Constraints are applied differently to containers. When deploying containers, constraints are interpreted as resource maximums as opposed to minimums. See [Constraints and LXD containers](/t/using-constraints/1060#heading--constraints-and-lxd-containers) for further details.

## Advanced usage

### LXD tips

For more information relating to an optimal experience with LXD—especially in cases where there might be unique requirements—read the [Additional LXD resources](/t/additional-lxd-resources/1092) page. It covers:

- Using LXD with custom container images
- LXD and group membership
- Adding non-admin user credentials
- Useful LXD client commands
- Using the LXD snap from Ubuntu Server older series
- Accessing LXD log files directly

### Juju-specific advice

Juju can make use of several advanced features within LXD. They are explained on the [Using LXD with Juju - Advanced](/t/using-lxd-with-juju-advanced/1091) page. It includes:

- Add resilience to your models through LXD clustering
- Registering a remote LXD server as a LXD cloud
- Charms and LXD profiles
