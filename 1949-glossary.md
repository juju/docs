<a id="action"></a><a id="actions"></a>
**Action**

An _action_ is functionality defined by a charm for its applications. [Operators](#operator) can run actions via the [client](#client).


<a id="admin"></a><a id="administrator"></a><a id="admin-user"></a>
**Admin user**

The `admin` user is created during the [bootstrap](#bootstrap) process. This account has all privileges across all models.


<a id="agent"></a>
**Agent**

An _agent_ is a running instance of `jujud`. Agents perform different roles and are often described in those terms. There are controller agents, unit agents, and machine agents.


<a id="agent-binary"></a><a id="agent-binaries"></a>
**Agent binary**

The `jujud` executable binary that's produced at each release is known as the _agent binary_. Every [agent](#agent) is a running instance of the agent binary.


<a id="application"></a>
**Application**

An application is typically something that's installable, such as a database. However, there are exceptions. It's possible for charm authors to write a charm that treats a collection of utilities that are presented to the [controller](#controller) [agent](#arent) as a single application. 

Applications are managed by [charms](#charm). When [operators](#operator) signal updates, such as configuration changes, new relations, upgrades or removal, the charm's [hooks](#charm-hook) are triggered.

An application contains 1 or more [units](#unit) and is always hosted within a [model](#model). Applications have non-exclusive access to their units, as a [placement directive](#placement-directive) can place multiple applications on the same unit.

Interation between applications is handled by [relations](#relation).

[note]
Before Juju 2.0, applications were known as services.
[/note]

<a id="bootstrap"></a><a id="bootstrap-process"></a>
**Bootstrap**

The bootstrap process establishes the controller on the [cloud](#cloud).


<a id="bootstrap-constraint"></a>
**Bootstrap Constraint**

A [constraint](#constraint) placed on the [bootstrap machine](#bootstrap-machine).


<a id="bootstrap-machine"></a>
**Bootstrap machine**

The machine used to host the [controller](#controller) [agent](#agent) and essential infrastructure, such as [`juju-db`](#juju-db), is the _bootstrap machine_. This is machine 0 of the [controller model](#controller-model).


<a id="bundle"></a>
**Bundle**

A bundle is a YAML file that describes a complete [deployment](#deployment). That deployment may consist of multiple charms, their applications, constraints, and relations.


<a id="charm"></a>
**Charm**

A charm is software that responds to [hooks](#charm-hooks) triggered by [agents](#agent).  Charms also define [actions](#actions), [relations](#relations) and [metrics](#metrics).

There are two strategies for charm writing. The recommended approach is to use the reactive charm framework. An alternative strategy is to use individual scripts to respond to each [charm hook](#charm-hook).  


<a id="charm-hook"></a><a id="charm-hooks"></a>
**Charm hook**

Charm hooks are an important implementation detail of how [charms](#charm) work. During the lifecycle of an application and its units, the controller execute files within a charm's `hooks` directory. 

Charm hooks have access to [hook tools](#hook-tools) for implementing their business logic.

<a id="client"></a>
**Client**

The `juju` executable binary. Command-line client that [operators](#operator) interact with. 

The client/server terminology originates from Juju's technical architecture. Running a Juju sub-command, such as `juju status`, involves connecting to a [controller](#controller) [agent](#agent).


<a id="constraint"></a>
**Constraint**

Constraints are minimum specifications that operators indicate to Juju. When adding units, Juju attempts to use the smallest instance type on the cloud that satisfies all of the constraints.

Constraints are not specific to individual machines, but the whole [application](#application). [Bootstrap constraints](#bootstrap-constraints) can also be applied during the [bootstrap](#bootstrap) process.



<a id="controller"></a>
**Controller**

The controller, sometimes referred to as the _controller [agent](#agent)_, is responsible for implementing changes that are defined by [operators](#operators). The controller is central to Juju. As well as altering 

The controller's privilege level is restricted when the [user](#user)'s does not have admin responsibilities.


<a id="credential"></a>
**Credential** 

Authentication credentials to allow Juju to interact programatically with a [cloud](#cloud). 


<a id="default-model"></a>
**Default model**

The [model](#model) created as part of the [bootstrap](#bootstrap) process.


<a id="deployment"></a>
**Deployment**

A _Juju deployment_ consists of the [controller model](#controller) and all of the [models](#model) models under its control.

The term _deployment_ is also used in a second sense. When an [operator](#operator) uses Juju to deploy a product or service, the deployment covers all models that work to provide that product or service.  

 
<a id="instance"></a>
**Instance**

An _instance_ is an [machine](#machine). Normally associated with virtual hardware and tied to an [instance type](#instance-type). 


<a id="instance-type"></a>
**Instance type**

_Instance types_ are identifiers designated by cloud providers that relate to specifications.
When adding [units](#unit), Juju will attempt to pick the smallest&mdash;and therefore cheapest&mdashinstance type that satisfies the unit's [constraints](#constraints).


<a id="hook-tools"></a>
**Hook tools**

[Charm hooks](#charm-hooks) interact with the [model](#model) via _hook tools_. They are utilities which  query and set  

<a id="juju"></a>
**`juju`**

The [client](#client) binary that [operators](#operator) interact with on the command line.


<a id="jujud"></a>
**`jujud`**

The [agent binary](#agent-binary).


<a id="metric"></a><a id="metrics"></a>
**Metric**

A _metric_ is a key/value pair defined by a [charm](#charm). Typically the value is numeric.

Juju polls charms every 5 minutes via the `collect-metrics` [charm hook](#charm-hook). 


<a id="model"></a>
**Model**

The _model_ is the central abstraction provided by Juju. Models house [applications](#application), manage their [relations](#relations). Models allow a set of applications to be treated as a single entity.

A digital product, such as a website or web service, typically requires several interdependent components to all be available for the product to function. A typical web application sits behind multiple caching layers and stores its data within a database. An ecommerce web application might talk to a fraud detection system, a payment gateway and perhaps also interact with an customer relationship management (CRM) and/or enterprise resource plannind (ERP) system. A Juju model encapsulates all of the components and allows you to treat them as a cohesive unit.

Consider a whiteboard drawing of a digital product. The model is the whiteboard itself, the applications are the main circles and relations are the lines between them.

The model's main roles are to decrease the cognitive load of understanding the deployment and to allow seperate concerns to be treated differently.

All applications are affected by the model's `model-config` settings.

A model maintains exclusive access to the [machines](#machine) that its applications' units use.   

[note]
Before Juju 2.0, models were known as environments.
[/note]


<a id="operator"></a>
**Relation**

A relation is a relationship between two [applications](#application). Relations are directed. One application is the _provider_ and the other is the _consumer_. 


<a id="space"></a><a id="spaces"></a><a id="network-space"></a><a id="network-spaces"></a>
**Space**

A (network) space is a network partition, protected by firewall rules.

Spaces can use used as a [constraint](#constraint).


<a id="storage"></a>
**Storage**

Storage, within Juju, means a machine-independent data volume that is provided by the [cloud](#cloud). 

Charms can be made to be storage-aware, allowing data storage that persists beyond the lifetime of any given machine.

<a id="operator"></a>
**Operator**

A [user](#user) the [Juju client](#client). 


<a id="placement-directive"></a>
**Placement Directive**

A _placement directive_ specifies which [unit](#unit) to deploy an [application](#application) to. Commonly used to deploy multiple applications in the same unit.


<a id="plugin"></a>
**Plugin**

An external command that works with Juju. When the [client](#client) subcommand  Juju looks for any executable with the prefix `juju-<plugin>` For example, when an [operator](#operator) executes `juju smoketest`, Juju will look for an executable named `juju-smoketest` on your `$PATH`.


<a id="user"></a>
**User**

The term "user" has two meanings within Juju. The plain language definition of "a person interacting with Juju" is most common. A more technical definition is that of a registered user, who has access levels constrained on a per model basis.
To distinguish the two senses of the word, we also use the term [operator](#operator) to refer to people.

The alternative meaning relates to accounts. For example, the account created the [bootstrap](#bootstrap) process is known as the [admin user](#admin-user).
