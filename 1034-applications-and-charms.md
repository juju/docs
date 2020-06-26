An *application* is typically a long-running service that is accessible over the network. Applications are the centre of a Juju deployment. Everything within the Juju ecosystem exists to facilitate them. 

It's easiest to think of the term "application" in Juju in the same way you would think of using it day-to-day. Middleware such as database servers (PostgreSQL, MySQL, Percona Cluster, etcd, ...), message queues (RabbitMQ) and other utilities (Nagios, Prometheus, ...) are all applications. The term has a specialist meaning within the Juju community, however. It is broader than the ordinary use of the term in computing.

### A Juju application is more than a software application 

Juju takes care of ensuring that the compute node that they're being deployed to satisfies the size constraints that you specify, installing them, increasing their scale, setting up their networking and storage capacity rules. This, and other functionality, is provided within software packages called charms.

Alongside your application, Juju executes charm code when triggered.  Triggers are typically requests from the administrator, such as:

- "The configuration needs to change" via `juju config`. The [spark charm](https://jaas.ai/spark) provides the ability to dynamically change the memory available to the driver and executors:  `juju config spark executor_memory=2g`

- "Please scale-up this application" via `juju add-unit`. The [postgresql charm](https://jaas.ai/postgresql) can detect when its scale is more than 1 and automatically switches itself into a high-availability cluster: `juju add-unit --num-units 2 postgresql`

- "Allocate a 20GB storage volume to the application unit 0" via `juju add-storage`. The [etcd charm](https://jaas.ai/etcd) can provide an SSD-backed volume on AWS to the etcd application with:  `juju add-storage etcd/0 data=ebs-ssd,20G` 

[note] 
The Juju project uses an active agent architecture. Juju software agents are running alongside your applications. They periodically execute commands that are provided in software packages called charms. 
[/note]


###  Differences between a stock software application and a Juju application

#### Applications are scale-independent

An application in the Juju ecosystem can span multiple operating system processes. An HTTP API would probably be considered a Juju application, but that might bundle together several other components.

Some examples:

- A Ruby on Rails web application might be deployed behind Apache2 and Phusion Passenger. 
- All workers within a Hadoop cluster are considered a single application, although each worker its own _unit_

A Juju application can also span multiple compute nodes and/or containers.  Within the Juju community, we use the term _machine_ to cover physical hardware, virtual machines and containers. 

To make this clearer, consider an analogy from the desktop. An Electron app is composed of an Internet browser, a node.js runtime and application code. Each of those components is distinct, but they exist as a single unit.  That unit is an application.

A final iteration of scale-independence is that Juju will maintain a record for applications that have a scale of 0. Perhaps earlier in the application's lifecycle it was wound down, but the business required that the storage volumes were to be retained.


#### Applications are active

Applications automatically negotiate their own configuration depending on their situation. Through the business logic encoded within charms,  two applications can create user accounts and passwords between themselves without leaking secrets.

#### Applications are responsive

Juju applications can indicate their status, run actions and provide metrics. An action is typically a script that is useful for running a management task. 



<!--
To make this clearer, consider an analogy from the desktop. An Electron app is composed of an Internet browser, a node.js runtime and application code. Each of those components are distinct, but they exist as a single unit.  That unit is an application.

in Juju is a collection of identical application *units* that is installed and configured via a *charm*. A charm represent the distilled knowledge of experts for its corresponding application. They make it easy to reliably and repeatedly deploy applications, which can then be scaled up and down with minimal effort.

Charms are available in the public online [Charm Store](https://jujucharms.com/store) but they can also be developed and run locally. See the [Charm writing guide](/t/charm-writing/1260) if you want to write your own charms.
-->

### Application management tasks

Common application and charm management tasks are summarised below. The most important ones are [Deploying applications](/t/deploying-applications/1062) and [Managing relations](/t/managing-relations/1073).


#### Configure applications
Applications can have their configuration options set during, or after, deployment. The [Configuring applications](/t/configuring-applications/1059) page explains how this is done.

#### Credentials and application trust

Some applications may require access to the backing cloud in order to fulfill their purpose. In such cases, the credential associated with the current model would need to be shared with the application. See section [Trusting an application with a credential](/t/deploying-applications-advanced/1061#heading--trusting-an-application-with-a-credential) for details.


#### Deploy applications

The [Deploying applications](/t/deploying-applications/1062) page covers an array of methods for getting your applications deployed.

The [Deploying applications - advanced](/t/deploying-applications-advanced/1061) page contains more advanced use cases.

See the [Deploying charms offline](/t/deploying-charms-offline/1069) page for guidance when deploying in a network-restricted environment.

Applications can be deployed and configured as a collection of charms. This subject is treated on the [Charm bundles](/t/charm-bundles/1058) page.

#### Display information for deployed applications

Once an application is deployed it is possible to display information on it. This is done with the `show-application` command. For example:

```text
juju deploy postgresql pgsql
juju show-application pgsql
```

[Details=Sample output]

```text
pgsql:
  charm: postgresql
  series: bionic
  channel: stable
  principal: true
  exposed: false
  remote: false
  endpoint-bindings:
    coordinator: ""
    data: ""
    db: ""
    db-admin: ""
    local-monitors: ""
    master: ""
    nrpe-external-master: ""
    replication: ""
    syslog: ""
```
[/details]

#### Relate applications

When an application requires another application in order to fulfil its purpose they need to be logically linked together. In Juju, such a link is called a *relation*. The [Managing relations](/t/managing-relations/1073) page explains this important concept.

#### Remove applications
Removing an application is a simple process. See the [Removing things](/t/removing-things/1063) page for guidance.




#### Scale applications

Juju horizontally scales applications up and down by adding and removing application units. See the [Scaling applications](/t/scaling-applications/1075) page for details.

#### Upgrade an application

Upgrading an application in Juju means to upgrade the application's charm. See the [Upgrading applications](/t/upgrading-applications/1080) page for in-depth coverage.


### Related Concepts

#### Actions
Actions are charm-specific bits of code which can be called at will from the command line. The [Working with actions](/t/working-with-actions/1033) page provides full coverage of the subject.

#### Application groups
Application groups allow an administrator to manage groups of the same application by providing custom application names during deployment. See the [Application groups](/t/application-groups/1076) page for details.

#### Application high availability

Application high availability pertains to the distribution of units over availability zones. See the [Application high availability](/t/application-high-availability/1066) page for full information.

#### Application metrics

Metrics for applications can be collected for the purposes of model-level assessment of application utilisation and capacity planning. See the [Application metrics](/t/application-metrics/1067) page to learn more.

#### Constraints
Constraints are used to specify minimum requirements for the machine that will host an application. See page [Using constraints](/t/using-constraints/1060) for details.

#### Resources

A Juju resource is additional content/files that a charm can make use of, or may even require in order to run. See the [Working with resources](/t/juju-resources/1074) page for details.

#### Storage
[Using storage](/t/using-juju-storage/1079)
