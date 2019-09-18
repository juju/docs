This guide introduces you to Juju on MS Windows, macOS and Linux. You'll be deploying a simple web application. Later on, you'll be able to use those same commands to deploy the app into the cloud, whether private or public.  

## Watch this guide

Would you prefer to watch, rather than type? This recording goes through the entire tutorial:

[![juju-getting-started|690x311](upload://qifyQD4CnmZdHsRQI0blAj8hy01.gif)](https://asciinema.org/a/267811?speed=2)

## Juju concepts primer

Working with Juju productively involves understanding some of its terminology.

**Hosting environment**

Juju interacts with a cloud to provide your workload.

- [Machines][] are compute resources, whether bare-metal servers, virtual machines or containers.

- [Providers](/t/glossary/1949#provider), or cloud providers, are the businesses that provide clouds and APIs to access them. 

- [Clouds](/t/glossary/1949#cloud) are targets that Juju can deploy to. Public clouds include AWS, Google Compute Engine and Microsoft Azure. 

**Juju architecture**

Juju uses an active agent architecture, the core of which is a controller. These terms describe how Juju gets its work done.

- [Charms][] are software packages that are invoked during phases of an application's lifecycle by Juju. They implement installation, scaling and configuration negotiation.

- [Client](/t/glossary/1949#client) is a term used for the tool that users use to interact with Juju, such as the `juju` executable.

- [Controllers](/t/glossary/1949#controller) are software agents running in a cloud that manage models.

- [Agents](/t/glossary/1949#relation) are running instances of Juju with responsibility to manage an application, a unit, machine or controller. They interact as a distributed system. Commands that you execute are sent to the controller, which then delegates the command to the responsible agent.

**Software modelling**

Within the Juju ecosystem, an "application" is an abstract entity. These terms describe how Juju enables you to define your software model, so that it can be implemented. 

-  [Applications][] are instances of a charm. Applications do not necessarily corespond to a software package running on a machine, but what the charm defines.

-  [Models][] are user-defined collections of applications. Models are wrappers for all of the components that support the applications running within them, such as relations, storage and network spaces.

-  [Units][] are instances of the software running within an applications. An application's units occupy machines.

- [Relations](/t/glossary/1949#relation) are protocols facilitated by Juju that allow applications to auto-negotiate their configuration. An application's relations are defined by its _charm_.

If you encounter any unfamiliar terms, the Juju project provides a full [glossary](/t/glossary/1949).

## Setting up

[details="Instructions for MS Windows and macOS"]
### Install Multipass

If you're not running Ubuntu, visit [multipass.run](https://multipass.run/). Multipass is a tool for quickly running virtual machines from any host operating system. This will allow you to create a fully-isolated test environment that won't impact your host system.

> Multipass provides a command line interface to launch, manage and generally fiddle about with instances of Linux. The downloading of a minty-fresh image takes a matter of seconds, and within minutes a VM can be up and running.
>&mdash; [The Register](https://www.theregister.co.uk/2019/01/22/multipass/)

### Create virtual machine 

We want to be able to experiment with Juju and evaluate it without the testing impacting on the rest of our system. To enter a shell within a virtual machine `microcloud` that has 8 GB RAM allocated to it, execute this command:

```plaintext
$ multipass launch -n microcloud -m 8g -c 2 -d 20G 
Launched: microcloud
```

Once `multipass` has downloaded the latest Long Term Support version of the Ubuntu operating system, you will be able to enter a command-line shell:

```plain
$ multipass shell microcloud
[...]
multipass@microcloud:~$
```
[/details]

[details="Need to install snap?"]
Visit the [snapcraft homepage](https://snapcraft.io/docs/installing-snapd) for installation instructions. **Snap** makes software installation trivial and secure.
[/details]

### Install Juju

Install Juju locally with [snap](https://snapcraft.io/):

```plain
$ sudo snap install juju --classic
juju 2.6.8 from Canonical✓ installed
```

## Create a cloud on localhost

 **LXD** manages operating system containers and makes the  the ["localhost" cloud](https://discourse.jujucharms.com/t/using-lxd-with-juju/1093) available to Juju.

> LXD is a next generation system container manager. It offers a user experience similar to virtual machines but using Linux containers instead.
> 
> It's image based with pre-made images available for a wide number of Linux distributions
and is built around a very powerful, yet pretty simple, REST API.
>
> &mdash; [LXD website](https://linuxcontainers.org/lxd/)


### Ensure LXD is installed

Install LXD with snap:

```plain
$ sudo snap install lxd
lxd 3.17 from Canonical✓ installed
```

If LXD is already installed, you'll receive this warning:

```plain
snap "lxd" is already installed, see 'snap help refresh'
```

### Configure LXD

LXD needs to be configured for its environment:

```bash
$ lxd init --auto
```

If you omit the `--auto` option, you can tailor your LXD installation. Use  `lxd help init` for a list of all the options.

<!--
Juju's support for IPv6 is in-progress. Disabling it reduces the likelihood of any errors:

```plain
lxc network set lxdbr0 ipv6.address none
```
-->

### Verify that the localhost cloud is available

Our `localhost` cloud is now established. We can verify that  by running `juju clouds`.  Juju should have detected the presence of LXD and has added it as the `localhost` cloud. 

```plain
$ juju clouds
[...]
localhost             1  localhost        lxd         LXD Container Hypervisor
```

## Bootstrap the controller

Juju uses an active software agent, called the controller, to manage applications. The controller is installed on a machine through the bootstrap process.  

During the bootstrap process, Juju connects with the cloud, then provision a machine to install the controller on, then install it.

```plain
$ juju bootstrap localhost overlord
Creating Juju controller "overlord" on localhost/localhost
Looking for packaged Juju agent version 2.6.8 for amd64
[...]
```

[note status="Accessing help"]
The `juju bootstrap` command takes several parameters. Use `juju help bootstrap` to review them.
[/note]


<!--
[note status="Why use the term bootstrap?"]
The `juju` command (usually referred to as the [Juju client][]) expects to talk to a [Juju controller][]. The controller interacts with the cloud on behalf of the client. The controller's not present, the client needs to interact with the [provider][] directly.
[/note]

TODO
 - add link

[note status="Relevant environment variables"]
Several environment variables affect the bootstrap process. 
[/note]
-->

<!--
## Pause

We should stop to review here. Here are quite a few moving parts with some overlapping terminology. 

- `c-hello` is a Juju controller running on the `localhost` cloud
- the `localhost` cloud is provided by LXD containers. LXD containers are "system containers" that mimic an operating system, whereas Docker provides "application containers" that are intended to run a single application. Every container instance created by within `localhost` by `c-hello` is considered a "machine" by Juju.
-->

## First workload: Hello Juju!

The first workload that you'll deploy is a [simple web application](https://github.com/juju/hello-juju). You'll deploy an application that uses the Flask microframework to send "Hello Juju!" via HTTP.

<!---
```bash
$ juju add-model hello
Added 'hello' model on localhost/localhost with credential 'localhost' for user 'admin'
```

It isn't necessary to understand much of that output at this stage. It reads as "Model 'hello' is added to the localhost cloud's localhost region. Access is granted to the 'admin' user using the the credential information stored at 'localhost' controller." 
-->

```plain
$ juju deploy ~hello-juju
Located charm "cs:hello-juju-2".
Deploying charm "cs:hello-juju-2".
```
The charm name `hello-juju` is resolved into an actual charm version by contacting the [Charm Store](https://jaas.ai/store). This charm is then downloaded by the controller and used as the source of the application that was created with the same name.


### Checking the deployment

Now that a workload is in place, use `juju status` to inspect what is happening:

```plain
$ juju status
Model    Controller  Cloud/Region         Version  SLA          Timestamp
default  overlord    localhost/localhost  2.6.8    unsupported  16:24:04+12:00

App         Version  Status  Scale  Charm       Store       Rev  OS      Notes
hello-juju           active      1  hello-juju  jujucharms    4  ubuntu  
  
Unit           Workload  Agent  Machine  Public address  Ports   Message
hello-juju/0*  active    idle   0        10.47.112.215   80/tcp  
 
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.47.112.215  juju-646ac9-0  bionic      Running
```

### Connecting to the application

The `juju status` output above provided the "Public address" of the `hello-juju/0` unit as `10.47.112.215` and its Ports column as `80/tcp`. Let's connect!

```plain
$ curl 10.47.112.215
Hello Juju!
```

[details=Connection refused?]
On non-localhost clouds, the connection may be refused. This is normal. To configure the necessary security groups and firewall rules, use `juju expose`:

[code]juju expose hello-juju[/code]
[/details]

  [unit]: /t/glossary/1949#unit
  [units]: /t/glossary/1949#units
  [machine]: /t/glossary/1949#machine
  [machines]: /t/glossary/1949#machine
  [application]: /t/glossary/1949#application
  [applications]: /t/glossary/1949#application
  [cloud]: /t/glossary/1949#cloud
  [charm]: /t/glossary/1949#charm
  [charms]: /t/glossary/1949#charm
  [model]: /t/glossary/1949#model
  [models]: /t/glossary/1949#model
  [provider]: /t/glossary/1949#provider
  [juju client]: /t/glossary/1949#client
  [juju controller]: /t/glossary/1949#controller

### Access a secure shell

Juju provides some useful functionality for SREs and operators who need to interact with units and machines out of the box.

The `ssh` command accepts unit (and machine) names. They will be substituted for the relevant IP address. 

Access the machine via the unit name: 

```plain
$ juju ssh hello-unit/0
ubuntu@juju-646ac9-0:~$
```
Or via the machine ID:

```plain
$ juju ssh 0
ubuntu@juju-646ac9-0:~$
```

Once you've connected, you can access the `hello-juju` web server:

```plain
$ curl localhost
Hello Juju!
```

## Relating another application: adding PostgreSQL to the deployment

Relations are Juju's defining concept and its main point of difference with other systems in its class. They enable the simplicity, security and stability offered by the whole project. 

The `hello-juju` web server maintains a count for each greeting that it has sent out via the `/greetings` endpoint.

```plain
$ curl 10.47.112.215/greetings
{"greetings": 2}
```

By default, this state is maintained within a SQLite database that is set up by the `hello-juju` charm itself. To move to PostgreSQL as the data store, two commands are required:

```plain
$ juju deploy postgresql
Located charm "cs:postgresql-199".
Deploying charm "cs:postgresql-199".
```

```plain
$ juju relate postgresql:db hello-juju
```

### About relations and how they work

`hello-juju` includes support for the `pgsql` relation, which is provided by the `postgresql` charm and others that present the same interface, such as `pg_bouncer`. 

Relations are protocols that enable applications to auto-configure. In the case of `pgsql`, the requiring charm (`hello-juju`) requests that a database be created on its behalf and the provider charm (`postgresql`) carries that step out and also creates the user account. `postgresql` then sends the 

The data sent between charms is facilitated by the Juju controller. The Juju controller establishes a certificate authority and ensures that all data transported is fully encrypted. Relations prevent secrets from being stored insecurely because they're not needed by application developers.


### What  relations are not

Relations are _not_ a networking construct, such as a tunnel between two applications. Instead, they're a data sharing protocol defined for charm to charm negotiation. As charms are executed by Juju agents, data is shared between agent to agent.  


### Re-checking the deployment status

Now that the new application and a relation are in place, the `juju status` output has expanded. Add the `--relations` option include relations infomation.

```plain
$ juju status --relations
Model    Controller  Cloud/Region         Version  SLA          Timestamp
default  overlord    localhost/localhost  2.6.8    unsupported  16:24:04+12:00

App         Version  Status  Scale  Charm       Store       Rev  OS      Notes
hello-juju           active      1  hello-juju  jujucharms    3  ubuntu  
postgresql  10.10    active      1  postgresql  jujucharms  199  ubuntu
  
Unit           Workload  Agent  Machine  Public address  Ports    Message
hello-juju/0*  active    idle   0        10.47.112.215   80/tcp  
postgresql/0*  active    idle   0        10.47.112.216   5432/tcp  Live master (10.10)
 
Machine  State    DNS            Inst id        Series  AZ  Message
0        started  10.47.112.215  juju-646ac9-0  bionic      Running
1        started  10.47.112.216  juju-646ac9-1  bionic      Running

Relation provider       Requirer                Interface    Type     Message
postgresql:coordinator  postgresql:coordinator  coordinator  peer
postgresql:db           hello-juju:db           pgsql        regular
postgresql:replication  postgresql:replication  pgpeer       peer

```


<!--
## Add storage capacity to the PostgreSQL database

Transient compute resources, such as virtual machines and containers, are not great places to store data long-term. 

Allocating 10GB of disk space to to the database that we've created takes a single command:

```plain
$ juju add-storage postgresql/0 pgdata=lxd,10GB
added storage pgdata/0 to postgresql/0
```

This has created the "storage instance" `pgdata/0`. It will persist even after the unit "postgresql/0" is removed. The name `pgdata` originates from the charm. The authors of the `postgresql` charm have defined a storage label within their charm's metadata.


[note status="Storage label discoverability"]
At present,  discovering which storage labels that a charm supports requires inspecting the charm's source files. Charms define a `metadata.yaml` file that may include a `storage` key. Items underneath `storage` can have storage allocated to them. To access the `metadata.yaml` file, visit the charm's webpage, then navigate to the "Files" box.
[/note]

To inspect the current state of the all of your storage instances, add the `--storage` option to the `juju status` command:

```
$ juju status --storage
```

### About storage management within Juju

Juju acts as an intermediary to allow any charm author to make use of file system and block storage on any provider. This involves working with many moving parts. To understand how this works, it can help to learn these three Juju terms:

- storage label: defined by the charm in its `metadata.yaml`
- storage instance: created from a storage pool and allocated to a unit 
- storage pools: provide storage instances from the provider

Charms can define "storage labels". Clouds provide "storage pools", tied to the capabilities of the underlying provider. The "storage instance" is linked with a specific unit.

Inspecting the storage pools available to your units is provided by the `juju storage-pools` command: 

```plain
$ juju storage-pools
Name       Provider  Attrs
loop       loop      
lxd        lxd       
lxd-btrfs  lxd       driver=btrfs lxd-pool=juju-btrfs
lxd-zfs    lxd       driver=zfs lxd-pool=juju-zfs zfs.pool_name=juju-lxd
rootfs     rootfs    
tmpfs      tmpfs     
```


[note status="Block storage relation"]
Before Juju created storage as a first-class entity, storage was managed on a per-charm basis via relations.
[/note]

## Removing the magic

What has `juju deploy` actually done? How has it enabled us to connect to an application that it has deployed?  

&nbsp; | Step | Desc 
--|--|--
1 | `juju deploy ~juju/hello-juju`
```bash

```

## Workload 2: Deploying a three-tiered web application

```bash
juju add-model m-webapp
juju deploy <flask> web-api
juju deploy postgresql pg
juju relate web-api pg
```

Models are affected by `model-config` parameters.


## Adding a second app

```
juju switch m-webapp
```

```bash
juju deploy <flask> web-app
juju relate web-app pg
```


# Clean up

```
multipass delete microcloud
```
-->
