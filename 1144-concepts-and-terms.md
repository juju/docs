<!--
Todo:
- /t/interface-layers/1121 also includes definitions
- Update LXD image to reflect remote LXD clouds and multi-cloud controllers
-->

<h2 id="heading--cloud">Cloud</h2>

To Juju, a *cloud* (or backing cloud) is a resource which provides machines (instances), and possibly storage, in order for application units to be deployed upon them. This includes public clouds such as Amazon Web Services, Google Compute Engine, and Microsoft Azure as well as private OpenStack-based clouds. Juju can also make use of environments which are not clouds per se, but which Juju can nonetheless treat as a cloud. [MAAS](https://maas.io) and [LXD](https://linuxcontainers.org/lxd/) fit into this last category.

See [Clouds](/t/clouds/1100) to learn more.

<h2 id="heading--controller">Controller</h2>

The Juju *controller* is the initial cloud instance which is created in order for Juju to gain access to a cloud. It is created by having the Juju client contact the cloud's API. The controller is a central management node for the chosen cloud, taking care of all operations requested by the Juju client. Multiple clouds (and thus controllers) are possible and each one may contain multiple models and users. Furthermore, since `v.2.6.0`, a controller can add to it a model which is hosted in another cloud.

For more information see [Controllers](/t/controllers/1111).

<h2 id="heading--model">Model</h2>

A *model* is associated with a single controller and is the space within which application units are deployed. A controller can have an indefinite number of models and each model can have an indefinite number of machines (and thus applications). Models themselves can be shared amongst Juju users.

The 'controller' model is the management model and is intended to contain a single machine, the actual controller. If controller high availability is enabled then multiple machines would reside in the 'controller' model. All other models are considered regular and are used to run workloads.

From `v.2.6.0` onwards, a model can be added to a controller that is hosted on a cloud other than the one that hosts the 'controller' model.

![machine](https://assets.ubuntu.com/v1/6d21bb7c-juju-models.png)

See [Models](/t/models/1155) for more information.

<h2 id="heading--charm">Charm</h2>

A Juju *charm* contains all the instructions necessary for deploying and configuring application units. Charms are publicly available in the online [Charm Store](https://jujucharms.com/store) and represent the distilled knowledge of experts. Charms make it easy to reliably and repeatedly deploy applications, then scale up (and down) as desired with minimal effort.

The simplest scenario is when a charm is deployed (by the Juju client) with the `deploy` command without any options to qualify the request. By default, a new instance will be created in the backing cloud and the application will be installed within it:

![machine](https://assets.ubuntu.com/v1/411232ff-juju-charms.png)

To see what you can do with charms visit the [Applications and charms](/t/applications-and-charms/1034) page.

### Subordinate charm

A *subordinate* charm is a charm that augments the functionality of another regular charm, which in this context becomes known as the *principle* charm. When a subordinate charm is deployed no units are created. This happens only once a relation has been established between the principal and the subordinate.

<h2 id="heading--container">Container</h2>

In Juju, a *container* is a generic term that is used to refer to either a LXD-based machine or a KVM-based machine.

<h2 id="heading--bundle">Bundle</h2>

A Juju *bundle* is a collection of charms which have been carefully combined and configured in order to automate a multi-charm solution. For example, a WordPress bundle may include the 'wordpress' charm, the 'mysql' charm, and the relation between them. The operations are transparent to Juju and so the deployment can continue to be managed by Juju as if everything was performed manually. See [Charm bundles](/t/charm-bundles/1058) for more information.

<h2 id="heading--machine">Machine</h2>

A Juju *machine* is the term used to describe a cloud instance that was requested by Juju. Machines will usually house a single unit of a deployed application, but this is not always the case. If directed by the user a machine may house several units (e.g. to conserve resources) or possibly no units at all: a machine can be created independently of applications ( `juju add-machine`), though usually this is with the intention of eventually running an application on it!

Represented below is a very standard Juju machine. It has a single deployed charm:

![machine](https://assets.ubuntu.com/v1/948ad198-juju-machine.png)

Here we have a machine with a deployed charm in addition to a charm deployed on a LXD container within that machine:

![machine-lxd](https://assets.ubuntu.com/v1/9e28a6ea-juju-machine-lxd.png)

<h2 id="heading--unit-and-application">Unit and application</h2>

A Juju *unit* (or application unit) is deployed software. Simple applications may be deployed with a single application unit, but it is possible for an individual application to have multiple units running in different machines. All units for a given application will share the same charm, the same relations, and the same user-provided configuration.

For example, one may deploy a single MongoDB application, and specify that it should run three units (with one machine per unit), so that the replica set is resilient to failures. Internally, even though the replica set shares the same user-provided configuration, each unit may be performing different roles within the replica set, as defined by the charm.

The following diagram represents the scenario described above. For simplicity, the agents have been omitted:

![units](https://assets.ubuntu.com/v1/244e4890-juju-machine-units.png)

<h2 id="heading--leader">Leader</h2>

A *leader* (or application leader) is the application unit that is the authoritative source for an application's status and configuration. Every application is guaranteed to have at most one leader at any given time. Unit agents will each seek to acquire leadership, and maintain it while they have it or wait for the current leader to drop out. The leader is denoted by an asterisk in the output to `juju status`. See [Implementing leadership](/t/implementing-leadership/1124) for more details.

<h2 id="heading--endpoint">Endpoint</h2>

An *endpoint* (or application endpoint) is used to connect to another application's endpoint in order to form a relation. An endpoint is defined in a charm's `metadata.yaml` by the collection of three properties: a *role*, a *name*, and an *interface*.

There are three types of roles:

-   `requires`: The endpoint can optionally make use of services represented by another charm's endpoint over the given interface.
-   `provides`: The endpoint represents a service that another charm's endpoint can make use of over the given interface.
-   `peers`: The endpoint can coexist with another charm's endpoint in a peer-to-peer manner (i.e. only between units of the same application). This role is often used in a cluster or high availability context.

For example, the pertinent excerpt of the `metadata.yaml` file for the 'wordpress' charm is as follows:

``` text
requires:
  db:
    interface: mysql
  nfs:
    interface: mount
  cache:
    interface: memcache
provides:
  website:
    interface: http
peers:
  loadbalancer:
    interface: reversenginx
```

Here, there are three 'requires' endpoints ('db', 'nfs', and 'cache'), one 'provides' endpoint ('website'), and one 'peers' endpoint ('loadbalancer'). For instance, we can say that "the 'db' endpoint can make use of services offered by another charm over the 'mysql' interface".

Despite the term 'requires', the three cited endpoints are not hard requirements for the 'wordpress' charm. You will need to read the charm's entry in the Charm Store (e.g. [wordpress](https://jujucharms.com/wordpress/)) to discover actual requirements as well as how the charm works. For instance, it is not obvious that the 'wordpress' charm comes bundled with an HTTP server (`nginx`), making a separate HTTP-based charm not strictly necessary.

<h2 id="heading--interface">Interface</h2>

An *interface* is the communication protocol used over a relation between applications. In the example shown in the Endpoint section, the interfaces for the corresponding endpoints are clearly discerned.

<h2 id="heading--relation">Relation</h2>

Charms contain the intelligence necessary for connecting different applications together. These inter-application connections are called *relations*, and they are formed by connecting the applications' endpoints. Endpoints can only be connected if they support the same interface and are of a compatible role (requires to provides, provides to requires, peers to peers).

For example, the 'wordpress' charm supports, among others, an 'http' interface ("provides" the website) and a 'mysql' interface ("requires" a database). Any other application which also has such interfaces can connect to this charm in a meaningful way.

Below we see WordPress with relations set up between both MySQL and Apache (a potential relation is shown with HAProxy):

![relations](https://assets.ubuntu.com/v1/4f0eba09-juju-relations.png)

Some of the above application units show unused interfaces. It is the overall purpose of the installation which will dictate what interfaces get used. Some relation types are required by the main charm ('wordpress' here) while some relation types are optional. A charm's entry in the Charm Store (e.g. [wordpress](https://jujucharms.com/wordpress/)) will expose such details.

See [Managing relations](/t/managing-relations/1073) for more details on relations.

<h2 id="heading--client">Client</h2>

The Juju *client* is command line interface (CLI) software that is used to manage Juju, whether as an administrator or as a regular user. It is installed onto one's personal workstation. This software connects to Juju controllers and is used to issue commands that deploy and manage application units running on cloud instances.

![machine](https://assets.ubuntu.com/v1/865acefc-juju-client-2.png)

In the case of the localhost cloud (LXD), the cloud is a local LXD daemon housed within the same system as the Juju client:

![machine](https://assets.ubuntu.com/v1/1f5ba83e-juju-client-3.png)

LXD itself can operate over the network and Juju does support this (`v.2.5.0`).

See the [Client](/t/client/1083) page for how to backup and upgrade the Juju client.

<h2 id="heading--agent">Agent</h2>

A Juju *agent* is software that runs on every Juju machine. There is a *machine agent* that operates at the machine level and a *unit agent* that works at the application unit level. Thus there are typically at least two agents running on each regular (non-controller) machine: one for the machine and one for a deployed application/charm. The controller normally has a single machine agent running.

A machine agent manages its respective unit agents as well as any containers that may be requested on that machine. In particular, it is the machine agent that creates the unit agent. The unit agents are responsible for all charm related tasks.

In general, all agents track state changes, respond to those changes, and pass updated information back to the controller. A model's status (`status` command) is built up from the communication between a controller and all the agents running in that model. Agents are also responsible for all logging that goes on in Juju (see [Model logs](/t/juju-logs/1184#heading--juju-agents) for details).

The agent's software version is generally consistent across a controller (and its models) and is thus determined at controller-creation time. By default the agent uses the same version as that of the local Juju client but this can be tweaked if desired. See [Agent versions and streams](/t/configuring-models/1151#heading--agent-versions-and-streams) for how to do this.

An agent is managed manually by accessing the machine it's running on and referring to its systemd service. For example, to restart the machine agent on machine '2':

```text
juju ssh 2 sudo service jujud-machine-2 restart
```
