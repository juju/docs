Working with Juju productively involves understanding some of its terminology. This page is a 2 minute summary of the main things to learn.

**Hosting environment**

Juju interacts with a hosting environment to deploy and manage your workload.

- [Machines](/t/glossary/1949#machine) are compute resources, whether bare-metal servers, virtual machines or containers.

- [Providers](/t/glossary/1949#provider), or cloud providers, are the businesses that provide clouds and APIs to access them. 

- [Clouds](/t/glossary/1949#cloud) are targets that Juju can deploy to. Public clouds include AWS, Google Compute Engine and Microsoft Azure. 

**Juju's software architecture**

Juju uses an active agent architecture, the core of which is a controller. These terms describe how Juju gets its work done.

- [Charms](/t/glossary/1949#charm) are software packages that are invoked during phases of an application's lifecycle by Juju. They implement installation, scaling and configuration negotiation.

- [Client](/t/glossary/1949#client) is a term used for the tool that users use to interact with Juju, such as the `juju` executable.

- [Controllers](/t/glossary/1949#controller) are software agents running in a cloud that manage models.

- [Agents](/t/glossary/1949#relation) are running instances of Juju with responsibility to manage an application, a unit, machine or controller. They interact as a distributed system. Commands that you execute are sent to the controller, which then delegates the command to the responsible agent.

**Software modelling**

Within the Juju ecosystem, an "application" is an abstract entity. These terms describe how Juju enables you to define your software model, so that it can be implemented. 

-  [Applications](/t/glossary/1949#application) are instances of a charm. Applications do not necessarily corespond to a software package running on a machine, but what the charm defines.

-  [Models](/t/glossary/1949#model) are user-defined collections of applications. Models are wrappers for all of the components that support the applications running within them, such as relations, storage and network spaces.

-  [Units](/t/glossary/1949#unit) are instances of the software running within an applications. An application's units occupy machines.

- [Relations](/t/glossary/1949#relation) are protocols facilitated by Juju that allow applications to auto-negotiate their configuration. An application's relations are defined by its _charm_.

If you encounter any unfamiliar terms, the Juju project provides a full [glossary](/t/glossary/1949).
