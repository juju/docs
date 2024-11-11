(design-goals)=
# Design Goals

## Why a new stack?

At Canonical, we have been referring to LMA as a system of machine charms currently in use to monitor Canonical and customer systems.

COS draws a lot of learning from years of operational experience with LMA, but it is also different enough that we felt we needed to make a distinction from the previous iteration.

## Design goals

There are several design goals we want to accomplish with COS:

* Provide a set of high-quality observability charmed operators that are designed to work well on their own, and better together.

* Make COS run on Kubernetes, with specific focus on [MicroK8s](https://microk8s.io/), to achieve a very "appliance-like" user experience.

* Ensure a consistent, cohesive experience: all alerts go through Alertmanager, Grafana can plot all telemetry, etc.

* Provide a highly-integrated observability stack with the simplest possible deployment experience.

* Take the toil out of setting up monitoring of your Juju workloads: monitoring your Juju applications should be as simple as establishing a couple of relations with the COS charms.

* Showcase the declarative power of the Juju model: for example, if some can be modelled as relation, rather that a configuration, _it should be_. Also, relations must be semantically meaningful: by looking at [`juju status --relations`](https://discourse.charmhub.io/t/command-status/1836), you should intuitively understand what comes out of two charms relating with one another.

## Non-Goals

While an observability stack naturally lends itself to a multitude of different use cases, like capacity and utilization monitoring, monitoring domain-specific data from a business perspective, these use cases are not goals of COS Lite and COS HA.

The charms that make up the stack, like Prometheus or Grafana, can of course be used for these use cases as well. However, they do not currently influence the roadmap of these charms to any significant degree.