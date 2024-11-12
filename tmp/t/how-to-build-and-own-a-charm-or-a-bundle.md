(how-to-build-and-own-a-charm-or-a-bundle)=
# How to build and own a charm or a bundle

When you build and own a charm, you wear multiple hats -- developer, QA specialist, technical author, marketing specialist. This document walks you through these roles. 

```{important}
 

Although the rough steps associated with these roles are presented sequentially, reflecting the logic "you need to develop something before  test, document, and publish", we strongly recommend you iterate -- develop something, test right away, document right away, market right away, repeat.

```

<!--Make this more comprehensive to prepare people for all the hats they'll have to wear in order to truly own a charm: developer, qa, technical author, marketer

yaml+code -> developer
testing -> qa
yaml+docs -> technical author
icon, announcements on Discourse, requesting public listing, holding a community workshop -> marketer

Basically, setting up a charm project should be more than running charmcraft init and then moving on -- you should maybe take a moment to create an Discourse doc that can act as the index page for your Charmhub -- even if it's only to say "This is a machine charm for <workload>".
-->


<!-- Need to find a more general way to surface this, as this is really just one example of how to set things up inside your charm.py.
## Configure logging
-->

## Set things up

> See more: 
> - {ref}`How to set up your development environment <set-up-your-development-environment>`
> - {ref}`How to set up a charm project <how-to-set-up-a-charm-project>`
> - {ref}`How to create a bundle <13953md>`

## Develop

For a charm, consider resources, application lifecycle management, actions, configurations, relations (integrations), secrets.

> See more: 
> - {ref}`How to use resources <how-to-manage-charm-resources>` 
> - {ref}`How to run workloads - machines <how-to-run-workloads-with-a-charm---machines>`, {ref}`How to run workloads - Kubernetes <how-to-run-workloads-with-a-charm---kubernetes>`
> - {ref}`How to support actions <how-to-add-an-action-to-a-charm>`
> - {ref}`How to support configurations <how-to-add-a-configuration-option-to-a-charm>`
> - {ref}`How to support relations (integrations) <how-to-add-an-integration-to-a-charm>` 
> - {ref}`How to support secrets <how-to-use-secrets-in-a-charm>`

For a bundle, iterate on the `bundle.yaml` file to optimise.


## Test and debug

For a charm, consider unit, scenario, integration, and end-to-end tests.

> See more: 
> - {ref}`How to get started with charm testing <getting-started-with-charm-testing>`
> - {ref}`How to write unit test for a charm <how-to-write-unit-tests-for-a-charm>`
> - {ref}`How to write scenario tests for a charm <how-to-write-scenario-tests-for-a-charm>`
> - {ref}`How to write integration tests for a charm <how-to-write-integration-tests-for-a-charm>`
> - the testing sections at the end of some of the "support {ref}`feature]" docs
> - [How to pack <how-to-pack-a-charm>`
> - {ref}`How to deploy <how-to-deploy-a-charm>`
> - {ref}`How to debug <how-to-debug-a-charm>` 

<!--upcoming feature: 

charmcraft test -- runs end to end tests for you

spread -- sets up a background for you
charmcraft test -> wrapper for that, will set up a juju environment and then you can run tests for you (it'll run any unit tests for you using tox as well, but that's incidental, the main focus is on end-to-end testing = you treat the charm itself as a blackbox and you prod at it in a real environment)

not sure when it's coming out
-->

## Document

You should always document each feature of your charm as you develop (e.g., as you define an action in `charmcraft.yaml`, make sure to provide a useful description). However, at the end, also take stock of your charm overall and add any other materials that you think might be needed. 

> See more: {ref}`How to add docs to a charm on Charmhub <how-to-add-docs-to-your-charm-or-charm-bundle-on-charmhub>`


## Market

### Add an icon

> See more: {ref}`How to add an icon <how-to-create-an-icon-for-your-charm>`

### Register a name in Charmhub

> See more: {ref}`How to publish> Register <how-to-publish-your-charm-on-charmhub>`

### Create a channel track

> See more: 
> - {ref}`How to create a channel track for a charm <how-to-create-a-track-for-your-charm>`


### Publish on Charmhub

> See more: 
> - {ref}`How to publish > Upload <how-to-publish-your-charm-on-charmhub>`
> - {ref}`How to publish > Release <how-to-publish-your-charm-on-charmhub>`

### Promote to a more stable channel risk level

To promote a charm to a more stable channel risk level of the same track, release it again specifying the revision number and the channel, including track and, especially, the target risk level. For example:

```text
charmcraft release --revision 118 --channel=5/candidate
```

To promote a bundle to a more stable risk level of the same track, run `charmcraft promote-bundle`.

### Request review and public listing

> See more: {ref}`Requirements for public listing <13953md>`

### Advertise

[Write a Discourse post to announce your release.](https://discourse.charmhub.io/tags/c/announcements-and-community/33/none) 

[Schedule a community workshop to demo your charm's capabilities.](https://discourse.charmhub.io/tag/community-workshop)

[Chat about it with your charmer friends.](https://matrix.to/#/#charmhub-charmdev:ubuntu.com)


<br>

> <small> Contributors: @lengau, @jdkandersson, @mmkay, @tmihoc, @weii-wang </small>