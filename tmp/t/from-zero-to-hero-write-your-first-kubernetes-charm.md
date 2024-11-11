(from-zero-to-hero-write-your-first-kubernetes-charm)=
# From zero to hero: Write your first Kubernetes charm

This tutorial will introduce you to the official way to write a Kubernetes charm --- that is, how to equip an application with all the operational logic that it needs so that you can manage it on any Kubernetes cloud with just a few commands, using [Juju](https://juju.is/docs/olm).

```{important}

**Did you know?** Writing a charm is also known as 'charming'!

```

<!--
We will charm a simple web application  based on the Python FastAPI framework.

The web application uses the PostgreSQL database and has a Prometheus metrics scrape target. As such, we will also integrate it with -->

<!--You will go through the process of *charming a web application.  
What does *charming* and *Charmed Operator* mean? *Charmed Operator* means all of the domain knowledge and expertise about an application distilled in clean and maintainable Python code.  

The  application that we will charm in this tutorial is based on the Python FastAPI framework, uses the PostgreSQL database, and has a Prometheus metrics scrape target. Once it is *charmed*, we will integrate our charm with the existing PostgreSQL charm and the Canonical Observability Stack (COS) bundle, for monitoring purposes.
-->

**What you'll need:** 

- A working station, e.g., a laptop with amd64 architecture. 
- Familiarity with [Juju](https://juju.is/docs/juju)
- Familiarity with the Python programming language, Object-Oriented Programming, Event Handlers
- Understanding of Kubernetes fundamentals


**What you'll do:**

- {ref}`Study your application <study-your-application>`
- {ref}`Set up your development environment <set-up-your-development-environment>`  
- Develop your charm:
    1. {ref}`Create a minimal Kubernetes charm <create-a-minimal-kubernetes-charm>`
    1. {ref}`Make your charm configurable <make-your-charm-configurable>`
    1. {ref}`Expose the version of the application behind your charm <expose-the-version-of-the-application-behind-your-charm>`
    1. {ref}`Integrate your charm with PostgreSQL <integrate-your-charm-with-postgresql>`
    1. {ref}`Preserve your charm's data <preserve-your-charms-data>`
    1. {ref}`Expose your charm's operational tasks via actions <expose-operational-tasks-via-actions>`
    1. {ref}`Observe your charm with COS Lite and set up cross-model integrations <observe-your-charm-with-cos-lite>`
    1. {ref}`Write unit tests for your charm <write-unit-tests-for-your-charm>`
    1. {ref}`Write scenario tests for your charm <write-scenario-tests-for-your-charm>`
    1. {ref}`Write integration tests for your charm <write-integration-tests-for-your-charm>`
    1. {ref}`Open a Kubernetes port in your charm <open-a-kubernetes-port-in-your-charm>`
    1. {ref}`Publish your charm on Charmhub <publish-your-charm-on-charmhub>`


<!--
- {ref}`Deploy your charm <7113md>`
 
----------------
-->

**Next steps:**

By the end of this tutorial you will have built a Kubernetes charm and evolved it in a number of typical ways. But there is a lot more to explore:

| If you are wondering...| visit...|
|--|--|
| "How do I...?" | {ref}`SDK How-to docs <sdk-how-to-guides>` |
| "What is...?" | {ref}`SDK Reference docs <sdk-reference>` |
| "Why...?", "So what?" |  {ref}`SDK Explanation docs <sdk-explanation>` |

<!--
|"How do I deploy a charm?" | [Juju docs](https://juju.is/docs/olm) |
|"How do I contribute to Juju?"| [Dev docs](https://juju.is/docs/dev) |
-->

<br>

> <small> **Contributors:** @beliaev-maksim </small>