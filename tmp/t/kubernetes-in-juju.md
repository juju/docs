(kubernetes-in-juju)=
# Kubernetes in Juju

Juju supports both traditional machine clouds as well as Kubernetes clouds. If you are familiar with Kubernetes, there's a mapping between Kubernetes and Juju concepts:

| Kubernetes | Juju |
|-|-|
| [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) | {ref}`model <model>` |
|  [node](https://kubernetes.io/docs/concepts/architecture/nodes/) | {ref}`machine <machine>`; Juju does not manage this for Kubernetes |
| [pod](https://kubernetes.io/docs/concepts/workloads/pods/) | {ref}`unit <unit>`  |
| container | process in a unit |
| [service](https://kubernetes.io/docs/concepts/services-networking/service/) | {ref}`application <application>` |


The rest of this document expands on this mapping.

**Contents:**

- [Namespace and Model](#heading--namespace-and-model)
- [Node and Machine](#heading--node-and-machine)
- [Pod and Unit](#heading--pod-and-unit)
- [Service and Application](#heading--service-and-application)

<a href="#heading--namespace-and-model"><h2 id="heading--namespace-and-model">Namespace and Model</h2></a>

Both namespaces and models allow for the aggregation of a set of resources into a common "context". However, a model must be part of a Juju {ref}`cloud <cloud-substrate>`, whereas a namespace is
not part of any higher grouping; there is not an equivalent concept of a cloud on Kubernetes.

<a href="#heading--node-and-machine"><h2 id="heading--node-and-machine">Node and Machine</h2></a>

While **nodes** and **machines** are equivalent in definition
(a physical or virtual machine where you can run a workload on), Juju does not internally represent
nodes as machines. Instead, it delegates the work of handling nodes to the Kubernetes cluster,
and only manages **pods** directly.

<a href="#heading--pod-and-unit"><h2 id="heading--pod-and-unit">Pod and Unit</h2></a>

**Pods** and **units** are essentially the same, since they
deploy code into a container or process. However, units in an **application** will always have a leader unit, which will be the unit handling the lifecycle of the application. Pods lack this functionality, meaning you would need to manually implement leader election to enable this type of pod architecture in Kubernetes.

<a href="#heading--service-and-application"><h2 id="heading--service-and-application">Service and Application</h2></a>

Both similar in concept, **services** and **applications** allow the integration of other services/applications within the cluster and can also
be exposed to enable access from the external world to the cluster.
A key difference is that applications can be automatically integrated with other applications, provided that the applications' {ref}`endpoints <endpoint>` are
compatible with each other. On the other hand, the integration between services must be done
manually, using the services' IP addresses or DNS names as their integration points.

<br>

<small>**Contributors:** @anvial, @jedel , @tmihoc </small>