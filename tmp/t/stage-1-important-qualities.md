(stage-1-important-qualities)=
# Stage 1: Important qualities

> <small> {ref}`Charm maturity <charm-maturity>` > Stage 1: Important qualities</small>

<!-- THIS IS MAYBE TOO MUCH DETAIL HERE.
Publishing charms refers to two elements:

1. Publishing the charm to Charmhub. If the charm is on Charmhub, Juju can automatically fetch the charm for deployments. Please note that Juju can deploy charms from the local filesystem as well.
2. Publishing the software project which produces the charm as an open source project.

Publishing a charm to Charmhub makes it available for a wider audience - thus, two things are essential:

Either way, to 

1. A charm must provide sound functionality and works reliably.
2. The provided charm is approachable for interested users, both for using, testing and/or contributing to its development.

The following guidelines are crucial for ensuring reliable and approachable charms. Thus, we consider these guidelines for public listing on Charmhub. Please note that public listing refers to the listing of search results, which is a separate setting for charms on Charmhub. Published charms are always available for Juju controllers and can be found using their URL but they are not automatically listed. For more details on how to publish a charm, please consider [the documentation about the publication of charms](https://juju.is/docs/sdk/publishing).

The guideline lists essential goals to be covered. In addtion, it refers to the [best practice documentation](https://juju.is/docs/sdk/styleguide), the documentation about the technical implementation, and examples that serve as a template.

-->

<!-- packages expert knowledge about how to manage an application in the cloud in a way that makes i-->

The power of a charm lies in the fact that it packages expert knowledge in a way that is shareable and reusable. But, for this to work as intended, the charm must meet certain quality standards. This document outlines the first round of standards -- standards intended to ensure that your charm is ready to be shared with others. 

```{important}

While every charm can be published on {ref}`Charmhub <charmhub>`, only charms that meet this first set of standards will be *listed*, that is, be visible when a user browses or searches for content on Charmhub.

```


```{caution}

These standards keep evolving. Revisit this doc to get the latest updates.

```

**Contents:**

- [The charm is reliable](#heading--the-charm-is-reliable)
    - [Unit testing](#heading--unit-testing)
    - [Integration testing](#heading--integration-testing)
- [The charm is collaboration-ready](#heading--the-charm-is-collaboration-ready)
    - [Consistent naming](#heading--consistent-naming)
    - [Icon](#heading--icon)
    - [Documentation](#heading--documentation)
    - [Readable code](#heading--readable-code)
- [The charm is compliant](#heading--the-charm-is-compliant)
- [The charm stays up-to-date](#heading--the-charm-stays-up-to-date) 
- [The charm maintainers are reachable](#heading--the-charm-maintainers-are-reachable)
    - [Contact and URLs](#heading--contact-and-urls)
    - [Community discussions](#heading--community-discussions)

<a href="#heading--the-charm-is-reliable"><h2 id="heading--the-charm-is-reliable">The charm is reliable</h2></a>

A charm is no good if it does not work reliably as intended. To that end, make sure that your charm has unit testing and integration testing.

<a href="#heading--unit-testing"><h3 id="heading--unit-testing">Unit testing</h3></a>


| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
|The charm has appropriate unit tests. These tests cover all the actions of the charm and are executed as part of a CI/CD pipeline.  |  {ref}`:link: Get started with charm testing <getting-started-with-charm-testing>` <p> {ref}`:link: Charm development best practices - Unit tests <6930md>` |

<!--Reasonable refers to covering the actions of the charm. It does not refer to reaching a specific code coverage metric.
Unit tests cover, for example, handling of events with a mocked application.
-->

<a href="#heading--integration-testing"><h3 id="heading--integration-testing">Integration testing</h3></a>

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| The charm has suitable integration tests. These tests cover installation and basic functionality and are executed automatically as part of a CI/CD pipeline.<p>The implementation of a basic integration test or a smoke test (“turn on and see if smoke comes out”) is not crucial, but the definition of basic or minimal functionality testing is required.<p>To make integration tests possible in the ecosystem, charm authors provide the following information:<p>&#8226; Definition of the project’s reference setup, such as substrate version and required settings. Testers need to understand the setup which developers have considered.<br/>&#8226; In addition to the reference setup, the test documentation lists anticipated substrates/platforms/setups to show the community opportunities for additional testing.<br/>&#8226; Description about the use and expected behaviour of relevant integration points subject to testing, e.g. API, service endpoints, relations.Integration tests should be executed automatically and visible to the community.| {ref}`:link: Charm development best practices - Functional tests <6930md>` <p> Real-world examples for an integration test:<br/>&#8226; [traefik-route-k8s tests](https://github.com/PietroPasotti/traefik-route-k8s-operator/tree/main/tests/integration)<br/>&#8226; [prometheus-k8s tests](https://github.com/canonical/prometheus-k8s-operator/tree/main/tests/integration)|


<a href="#heading--the-charm-is-collaboration-ready"><h2 id="heading--the-charm-is-collaboration-ready">The charm is collaboration-ready</h2></a>

The power of a charm compounds every time someone else finds it, uses it, and contributes to it. As such, make sure that your charm has a good name and icon, is well documented, and has readable code. 

<a href="#heading--consistent-naming"><h3 id="heading--consistent-naming">Consistent naming</h3></a>

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| The charm is named similarly to existing charms, in accordance with the naming guidelines.<p>The name of the publisher identifies the organisation responsible for publishing the charm.| {ref}`:link: Charm naming guidelines <charm-naming-guidelines>`|

<a href="#heading--icon"><h3 id="heading--icon">Icon</h3></a>


| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| The charm has an appropriate and recognizable icon that can be displayed on Charmhub or the Juju dashboard as a symbol instead of the charm name. | The icon helps users identify the charm both when searching and selecting on Charmhub and when using the charm in models displayed in the juju dashboard. <p> The workload/application icon is considered for the charm in many cases. If the publisher of the charm and the publisher of the workload/application do not belong to the same legal entity, trademark rules may apply when using existing icons. <p>  {ref}`:link: How to create an icon for your charm <how-to-create-an-icon-for-your-charm>`| 

<a href="#heading--documentation"><h3 id="heading--documentation">Documentation</h3></a>

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
|The charm has documentation that covers:<p>1. how to use the charm <p>2. how to modify the charm<p>3. how to contribute to the development<p> Usage documentation covers configuration, limitations, and deviations in behaviour from the “non-charmed” version of the application.<p>There is a concise `summary` field, with a more detailed description field in the `charmcraft.yaml`.| For contributions, many OSS projects have adopted the best practice of providing a CONTRIBUTING.md’ file at the project’s root level.|

<a href="#heading--readable-code"><h3 id="heading--readable-code">Readable code</h3></a>

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| The code favours a simple, readable approach. There is sufficient documentation for any integration points with the charm, such as libraries, to aid the forming of relations.| [PEP 8](https://peps.python.org/pep-0008/) for general code style:<p>[PEP 257](https://peps.python.org/pep-0257/) for in-code documentation style<p>{ref}`:link: Charm development best practices - Code style <6930md>`|



<a href="#heading--the-charm-is-compliant"><h2 id="heading--the-charm-is-compliant">The charm is compliant</h2></a>

When publishing charms as open source, on Charmhub or other public places, the published content must comply with copyright and trademarks usage rights.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| If trademarks and/or logos are used, their use must comply with the permissions of the trademark holder. <p> If 3rd party software or content is used in the charm repository, it must be handled as such. <p> In the detailed view of the charm in Charmhub.io: The "by"- entry should identify the charm's author, not the application's author.| For trademarks: <p> &#8226; Use of trademarks in accordance with the trademark guidelines by the trademark owner. <p> For third-party content (source, images, texts, etc.): <p> &#8226; Use of the content only according to the licence of the copyright owner.

<a href="#heading--the-charm-stays-up-to-date"><h2 id="heading--the-charm-stays-up-to-date">The charm stays up-to-date</h2></a>

Charms cover applications which need to be updated regularly. In today’s world of vulnerabilities and cyber security threats, efficient ways of updating software are crucial. Therefore, the automated production of charms is essential.

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| The charm is up-to-date, that is, it has build, test and delivery automation. This automation is important to ensure the project can roll out updates quickly.<p>For this, you need CI/CD in place, including publishing edge and beta/candidate builds.<p>CI/CD is important to ensure that the most recent developments are also accessible to the community for testing.| &#8226; CI/CD builds are triggered ideally at a commit to the main line / master of the charm code.<p>&#8226; In the sense of “CD”, the charm is being published to its beta or edge channel on Charmhub<p>&#8226; The charm development best practices provide an introduction about [integration tests](https://juju.is/docs/sdk/styleguide#heading--continuous-integration). |

<a href="#heading--the-charm-maintainers-are-reachable"><h2 id="heading--the-charm-maintainers-are-reachable">The charm maintainers are reachable</h2></a>

Users must know where to reach out to ask questions or find relevant information.
 

<a href="#heading--contact-and-urls"><h3 id="heading--contact-and-urls">Contact and URLs</h3></a>


| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
|The charm homepage provides links that are important to the user. Interested developers should be able to contact the charming project and directions on where and how to submit questions and issues must be provided.| URLs must be provided to enable collaboration and exchange on the charm, ideally as metadata on Charmhub.<br/>A best practice is to have an issue template configured for the issue tracker! (Example see, e.g., [alertmanager-k8s issue template](https://github.com/canonical/alertmanager-k8s-operator/issues/new/choose))<br/>The homepage should point to the source code repository, providing an entry point to charm development and contributions.<br/> :warning: Further support is coming for the distinct identification of the project homepage, source code repository and issue tracker in charm metadata, and on Charmhub.|

<a href="#heading--community-discussions"><h3 id="heading--community-discussions">Community discussions</h3></a>

| Objectives  | Tips, examples, further reading | 
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | 
| A Discourse link or Mattermost channel must be available for discussion, announcements and the exchange of ideas, as well as anything else which would not fit into an issue.<p>For the application, links to the referring forums can also be provided. | Discourse is preferred because framework topics and other charms are also discussed there. It is the most popular place for the community of charms. Therefore, technical questions are most likely covered there.<p>For the forum, get started with an [introduction](https://discourse.charmhub.io/t/read-me-first-admin-quick-start-guide/10).<br/>Issues can also be discussed in the [public chat](https://chat.charmhub.io/).