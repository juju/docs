(stage-2-important-capabilities)=
# Stage 2: Important capabilities

> <small> {ref}`Charm maturity <charm-maturity>` > Stage 2: Important capabilities</small>

Your charm looks right, right enough for you to share it with the world. What next? Time to make sure it also works right! This document spells out the second round of standards that you should try to meet -- standards designed to ensure that your charm is good enough to be used in production, at least for some use cases.

```{tip}

Assuming you've already published your charm on [Charmhub](https://charmhub.io/), and passed the review to have it publicly listed, these standards are the way to ensure that your charm gains recognition as a noteworthy charm.

```
  

<!--That is, publishing a charm on Charmhub is just the beginning. Now that you've made it available to the broader open source developer community, you should plan to evolve it together with this community, so that it best meets everyone's needs and standards. But what are these needs and standards? Which operations implemented by a charm take priority? This document lists a core set of target capabilities for every software operator. 
-->

<!--
evolve it so it meets this community's scrutiny, to address their needs and standards, in short, to make it *evaluation* ready! But how do you know what the community's needs and standards are? And which one should take priority? This document lists a core set of target capabilities for every software operator. We recommend you use it to make your charm evaluation-ready.

Publishing a charm on Charmhub is just the beginning. Now that you've made it available to the broader community, you should plan to evolve it together with this community so it best meets everyone's needs and standards. But what are these needs? Which ones tend to take priority? This document lists a core set of target capabilities for every software operator. We recommend you use it to make your charm evaluation-ready.
-->

<!--
[Publishing a charm](https://juju.is/docs/sdk/publishing) on Charmhub makes it available to a broader audience - the charm community. A charm that’s published on Charmhub must provide proper functionality and work reliably for the benefit of the community. We have [guidelines](https://juju.is/docs/sdk/charm-publication-checklist) to ensure all published charms meet our standards of quality and reliability.

After the first release of a charm, the development team will cover additional capabilities and functionalities. But which are the most relevant? Which should the development team prefer? This document lists and explains a core set of capabilities for every software operator. In addition, it contains links to the [best practice documentation](https://juju.is/docs/sdk/styleguide), the [technical documentation pages](https://juju.is/docs/sdk), and example [templates](https://github.com/canonical/template-operator) or [implementations](https://github.com/canonical/charming-actions).
-->

```{caution}

These standards keep evolving. Revisit this doc to get the latest updates.

```

**Contents:**

- [The charm has sensible defaults](#heading--sensible-defaults)
- [The charm is compatible with the ecosystem](#heading--ecosystem-compatibility)
- [The charm upgrades the application safely](#heading--safe-upgrades)
- [The charm scales up and down](#heading--scaling) 
- [The charm is integrated with observability](#heading--observability)
<!--MOVED THIS DOWN BECAUSE OTHERWISE IT CREATES A GAP IN THE WEBSITE VERSION:
- [The charm supports backup and restore](#heading--backup)
-->


<a href="#heading--sensible-defaults"><h2 id="heading--sensible-defaults">The charm has sensible defaults</h2></a>

A user can deploy the charm with a sensible default configuration.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| The purpose is to provide a fast and reliable entry point for evaluation. Of course, optimised deployments will require configurations.  |  Often applications require initial passwords to be set, which should be auto-generated and retrievable using an action or [Juju Secrets](https://discourse.charmhub.io/t/juju-secrets-early-access-preview/5150) once available. <p> Hostnames and load balancer addresses are examples that often cannot be set with a sensible default. But they should be covered in the documentation and indicated clearly in the status messages on deployment when not properly set.|

<a href="#heading--ecosystem-compatibility"><h2 id="heading--ecosystem-compatibility">The charm is compatible with the ecosystem</h2></a>

The charm can expose provides/requires interfaces for integration ready to be adopted by the ecosystem.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| Newly proposed relations have been reviewed and approved by experts to ensure:<p>&#8226; The relation is ready for adoption by other charmers from a development best practice point of view.<p>&#8226;  No conflicts with existing relations of published charms.<p>&#8226;  Relation naming and structuring are consistent with existing relations.<p>&#8226; Tests cover integration with the applications consuming the relations. | A [Github project](https://github.com/canonical/charm-relation-interfaces) structures and defines the implementation of relations.<p>No new relation should conflict with the ones covered by the relation integration set [published on Github](https://github.com/canonical/charm-relation-interfaces).<p>&#8226; [Getting started with relations in Juju](https://discourse.charmhub.io/t/implementing-relations/1051)<p>&#8226; [Discussion about consistency](https://discourse.charmhub.io/t/popular-charm-library-index/5732) |

<a href="#heading--safe-upgrades"><h2 id="heading--safe-upgrades">The charm upgrades the application safely</h2></a>

The charm supports upgrading the workload and the application. An upgrade task preserves data and settings of both.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| A best practice is to support upgrades sequentially, meaning that users of the charm can regularly apply upgrades in the sequence of released revisions. | &#8226; [How to upgrade applications with Juju](https://juju.is/docs/olm/manage-applications#heading--upgrade-an-application)| 

<a href="#heading--scaling"><h2 id="heading--scaling">The charm supports scaling up and down</h2></a>
**If the application permits or supports it,** the charm does not only scale up but also supports scaling down.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| Scale-up and scale-down can involve the number of deployment units and the allocated resources (such as storage or computing). | <p>&#8226;  [Scaling applications with Juju](https://juju.is/docs/olm/manage-applications#heading--scale-an-application)<p>Note that the cited links also point to how to deal with relations when instances are added or removed:<p>&#8226;[SDK Docs - Relations](https://discourse.charmhub.io/t/relations/4465)<p>&#8226; [SDK Docs - Peer Relation Example](https://juju.is/docs/sdk/relations#heading--peer-relation-example) |
<!--
<a href="#heading--backup"><h2 id="heading--backup">The charm supports backup and restore</h2></a>

**If the application supports it,** the charm should be recoverable to a working state after a unit is redeployed, migrated, or lost, and a backup copy of the workload's state is attached.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| As a best practice, charms…<p>&#8226; … are as stateless as possible (or just stateless), and<p>&#8226; … store in a storage that can be backed up.<p> If the application provides backup functionality already, the charm uses this functionality. | Consider [this example](https://...) as an example of backup operations to be covered. |
-->
<a href="#heading--observability"><h2 id="heading--observability">The charm is integrated with observability</h2></a>

Engineers and administrators who operate an application at a production-grade level need to capture and interpret the application’s state.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| Integrating observability refers to providing:<p>&#8226; a metrics endpoint,<p>&#8226; alert rules,<p>&#8226; Grafana dashboards, and<p>&#8226; integration with a log sink (e.g. [Loki](https://charmhub.io/loki-k8s)).| Consider the [Canonical Observability Stack](https://charmhub.io/topics/canonical-observability-stack) (COS) for covering observability in charms. Several endpoints are available from the COS to integrate with charms:<p>&#8226; Provide metrics endpoints using the MetricsProviderEndpoint<p>&#8226; Provide alert rules to Prometheus<p>&#8226; Provide dashboards using the GrafanaDashboardProvider<p>&#8226; Require a logging endpoint using the LogProxyConsumer or LokiPushApiConsumer<p>More information is available on the [Canonical Observability Stack homepage](https://charmhub.io/topics/canonical-observability-stack).<p>Consider the zinc charm implementation as [an example for integrations with Prometheus, Grafana and Loki](https://github.com/jnsgruk/zinc-k8s-operator/blob/main/metadata.yaml). |