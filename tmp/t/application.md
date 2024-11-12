(application)=
# Application

> See also: {ref}`How to manage applications <how-to-manage-applications>`
<!--
> - {ref}`About controllers <controller>`
> - {ref}`About agents <agent>`
> - {ref}`About models <model>`
> - {ref}`About charmed operators ('charms') <charm>`
> - {ref}`About applications and charmed operators <5471md>`
> - {ref}`About units <unit>`
> - {ref}`About relations <relation-integration>`
> - {ref}`How to debug charm hooks <5471md>`
> - {ref}`How to deploy to a specific machine <5471md>`
-->

In Juju, an **application** is a running abstraction of a {ref}`charm <charm>` in the Juju model. It is whatever software is defined by the charm. This could correspond to a traditional software package but it could also be less or more.

An application is always hosted within a {ref}`model <model>` and consists of one or more {ref}`units <unit>`. 
<!--Applications have non-exclusive access to their units, as a placement directive can place multiple applications on the same unit.-->

An application can have {ref}`resources <resource-charm>`, a {ref}`configuration <5471md>`, the ability to form {ref}`relations (integrations) <relation-integration>`, and {ref}`actions <action>`.

<!--
**Contents:**

- [What is an application](#heading--what-is-an-application)
- [A Juju application is more than a software application](#heading--a-juju-application-is-more-than-a-software-application)
- [Differences between a stock software application and a Juju application](#heading--differences-between-a-stock-software-application-and-a-juju-application)
    - [Juju applications are scale-independent](#heading--juju-applications-are-scale-independent)
    - [Juju applications are active](#heading--juju-applications-are-active)
    - [Juju applications are responsive](#heading--juju-applications-are-responsive)



<a href="#heading--what-is-an-application"><h2 id="heading--what-is-an-application">What is an application?</h2></a>


An *application* is typically a long-running service that is accessible over the network. Applications are the centre of a Juju deployment. Everything within the Juju ecosystem exists to facilitate them.

It’s easiest to think of the term “application” in Juju in the same way you would think of using it day-to-day. Middleware such as database servers (PostgreSQL, MySQL, Percona Cluster, etcd, …), message queues (RabbitMQ) and other utilities (Nagios, Prometheus, …) are all applications. The term has a special meaning within the Juju community, however. It is broader than the ordinary use of the term in computing.

<a href="#heading--a-juju-application-is-more-than-a-software-application"><h2 id="heading--a-juju-application-is-more-than-a-software-application">A Juju application is more than a software application</h2></a>

Juju takes care of ensuring that the compute node that they’re being deployed to satisfies the size constraints that you specify, installing them, increasing their scale, setting up their networking and storage capacity rules. This, and other functionality, is provided within software packages called **charmed operators**.

Alongside your application, Juju executes charm code when triggered. Triggers are typically requests from the administrator, such as:

||“The configuration needs to change”|
|--|--|
|*command*|`juju config`|
|*description*|The [spark charm](https://jaas.ai/spark) provides the ability to dynamically change the memory available to the driver and executors|
|*example*|`juju config spark executor_memory=2g`|

||“Please scale-up this application”|
|--|--|
|*command*|`juju add-unit`|
|*description*|The [postgresql charm](https://jaas.ai/postgresql) can detect when its scale is more than 1 and automatically switches itself into a high-availability cluster|
|*example*|`juju add-unit --num-units 2 postgresql`|

||“Allocate a 20GB storage volume to the application unit 0”|
|--|--|
|*command*|`juju add-storage`|
|*description*|The [etcd charm](https://jaas.ai/etcd) can provide an SSD-backed volume on AWS to the etcd application with|
|*example*|`juju add-storage etcd/0 data=ebs-ssd,20G`|

```{important}

The Juju project uses an active agent architecture. Juju software agents are running alongside your applications. They periodically execute commands that are provided in software packages called charmed operators.

```

<a href="#heading--differences-between-a-stock-software-application-and-a-juju-application"><h2 id="heading--differences-between-a-stock-software-application-and-a-juju-application">Differences between a stock software application and a Juju application</h2></a>


<a href="#heading--juju-applications-are-scale-independent"><h3 id="heading--juju-applications-are-scale-independent">Juju applications are scale-independent</h3></a>

An application in the Juju ecosystem can span multiple operating system processes. An HTTP API would probably be considered a Juju application, but that might bundle together several other components.

Some examples:

* A Ruby on Rails web application might be deployed behind Apache2 and Phusion Passenger.
* All workers within a Hadoop cluster are considered a single application, although each worker has its *unit*.

A Juju application can also span multiple compute nodes and/or containers (machines). 

```{important}

Within the Juju community, we use the term *machine* to cover physical hardware, virtual machines and containers.

```

To make this clearer, consider an analogy from the desktop. An Electron app is composed of an Internet browser, a node.js runtime and application code. Each of those components is distinct, but they exist as a single unit. That unit is an application.

A final iteration of scale-independence is that Juju will maintain a record for applications that have a scale of 0. Perhaps earlier in the application’s life cycle it was wound down, but the business required that the storage volumes were to be retained.

<a href="#heading--juju-applications-are-active"><h3 id="heading--juju-applications-are-active">Juju applications are active</h3></a>


Applications automatically negotiate their configuration depending on their situation. Through the business logic encoded within charmed operators, two applications can create user accounts and passwords between themselves without leaking secrets.

<a href="#heading--juju-applications-are-responsive"><h3 id="heading--juju-applications-are-responsive">Juju applications are responsive</h3></a>


Juju applications can indicate their status, run actions and provide metrics. An action is typically a script that is useful for running a management task.

-->