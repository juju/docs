(charm-sdk-documentation)=
# Charm SDK Documentation

```{important}

The Charm SDK documentation presupposes familiarity with [Juju](https://juju.is/docs/juju).

```

The Charm SDK is a toolkit for building charms.

The SDK provides a Python library for developing and testing charms, `ops`, and a CLI tool for building, packaging and publishing charms, `charmcraft`. 

A charm can be developed in a variety of ways. However, the SDK provides useful abstractions and CLI commands so you can develop and share your charm better and faster.

Whether you are a charm developer or a charm end user, with the Charm SDK you get a smoother experience.

> For a collection of existing charms, see [Charmhub](https://charmhub.io/). To deploy and manage an existing or new charm, see
 [Juju docs](https://juju.is/docs/olm).

---

## In this documentation

|                                                                                                      |                                                                                             |
|------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| {ref}`Tutorials <sdk-tutorials>`</br>  Get started - a hands-on introduction to the Charm SDK for new users </br> | {ref}`How-to guides <sdk-how-to-guides>` </br> Step-by-step guides covering key operations and common tasks |
| {ref}`Explanation <sdk-explanation>` </br> Concepts - discussion and clarification of key topics                   | {ref}`Reference <sdk-reference>` </br> Technical information - specifications, APIs, architecture       |



---

## Project and community

The Juju SDK is an open source project that warmly welcomes community projects, contributions, suggestions, fixes and constructive feedback.

- Learn about the {ref}`Roadmap & Releases <roadmap--releases>`
- Read our [Code of Conduct](https://ubuntu.com/community/code-of-conduct)
- Join our [Matrix chat](https://matrix.to/#/#charmhub-juju:ubuntu.com)
- Join the [Discourse forum](https://discourse.charmhub.io/t/welcome-to-the-charmed-operator-community/8) to talk about [Juju](https://discourse.charmhub.io/tags/c/juju/6/community-workshop), [charms](https://discourse.charmhub.io/c/charm/41), [docs](https://discourse.charmhub.io/c/doc/22), or [to meet the community](https://discourse.charmhub.io/tag/community-workshop)
- Report a bug on [GitHub](https://github.com/canonical/operator/issues) (for code) or [GitHub](https://github.com/juju/docs/issues) (for docs)
- Contribute to the documentation on [Discourse](https://discourse.charmhub.io/t/documentation-guidelines-for-contributors/1245)
- Contribute to the code on [Github](https://github.com/canonical/operator)
- Visit the [Juju careers page](https://juju.is/careers)


<!--COMMENT---doesn't fit here

<h2 id="heading--multi-cloud-models">Multi-cloud models</h2>

One of the most powerful concepts in Juju deployments is the way application deployments are modelled. A single Juju [controller](https://juju.is/docs/olm/controllers) can interact with multiple underlying substrates, be those bare-metal private clouds, public clouds or a hand-crafted Kubernetes cluster. Irrespective of the substrate they are deployed upon, charms can be related using cross-model relations. This enables seamless interoperability between substrates, where the Juju OLM handles all of the networking, permissions and configuration on your behalf.

For example, if you already bootstrapped a database cluster on bare-metal using Juju, but your new web application runs on Kubernetes, you can just `juju relate` your different charms for seamless integration across clouds.

-->

<h2 id="heading--navigation">Navigation</h2>

```{dropdown} Navigation

| Level | Path                                                    | Navlink                                                                             |
|-------|---------------------------------------------------------|-------------------------------------------------------------------------------------|
| 1     |                                                         | {ref}`SDK documentation <charm-sdk-documentation>` |
| 1     | tutorials                                               | {ref}`Tutorials <sdk-tutorials>`                                                                |
| 2     | write-your-first-machine-charm                          | {ref}`Write your first machine charm <write-your-first-machine-charm>`                                          |
| 2     | from-zero-to-hero-write-your-first-kubernetes-charm     | {ref}`Write your first Kubernetes charm <from-zero-to-hero-write-your-first-kubernetes-charm>`                                        |
| 3     | study-your-application                                  | {ref}`Study your application <study-your-application>`                                                   |
| 3     | set-up-your-development-environment                     | {ref}`Set up your development environment <set-up-your-development-environment>`                                      |
| 3     | create-a-minimal-kubernetes-charm                       | {ref}`Create a minimal Kubernetes charm <create-a-minimal-kubernetes-charm>`                                        |
| 3     | make-your-charm-configurable                            | {ref}`Make your charm configurable <make-your-charm-configurable>`                                             |
| 3     | expose-the-version-of-the-application-behind-your-charm | {ref}`Expose the version of the application behind your charm <expose-the-version-of-the-application-behind-your-charm>`                  |
| 3     | integrate-your-charm-with-postgresql                    | {ref}`Integrate your charm with PostgreSQL <integrate-your-charm-with-postgresql>`                                     |
| 3     | preserve-your-charms-data                               | {ref}`Preserve your charm’s data <preserve-your-charms-data>`                                               |
| 3     | expose-your-charms-operational-tasks-via-actions        | {ref}`Expose your charm’s operational tasks via actions <expose-operational-tasks-via-actions>`                        |
| 3     | observe-your-charm-with-cos-lite                        | {ref}`Observe your charm with COS Lite <observe-your-charm-with-cos-lite>`                                         |
| 3     | write-unit-tests-for-your-charm                         | {ref}`Write unit tests for your charm <write-unit-tests-for-your-charm>`                                         |
| 3     | write-scenario-tests-for-your-charm                     | {ref}`Write scenario tests for your charm <write-scenario-tests-for-your-charm>`                                     |
| 3     | write-integration-tests-for-your-charm                  | {ref}`Write integration tests for your charm <write-integration-tests-for-your-charm>`                                  |
| 3     | open-a-kubernetes-port-in-your-charm                    | {ref}`Open a Kubernetes port in your charm <open-a-kubernetes-port-in-your-charm>`                                    |
| 3     | publish-your-charm-on-charmhub                          | {ref}`Publish your charm on Charmhub <publish-your-charm-on-charmhub>`                                          |
| 2     | write-your-first-kubernetes-charm-for-a-flask-app       | {ref}`Write your first Kubernetes charm for a Flask app <write-your-first-kubernetes-charm-for-a-flask-app>`                       |
| 2     | write-your-first-kubernetes-charm-for-a-django-app      | {ref}`Write your first Kubernetes charm for a Django app <write-your-first-kubernetes-charm-for-a-django-app>`                      |
| 2     | write-your-first-kubernetes-charm-for-a-fastapi-app     | {ref}`Write your first Kubernetes charm for a FastAPI app <write-your-first-kubernetes-charm-for-a-fastapi-app>`                     |
| 2     | write-your-first-kubernetes-charm-for-a-go-app     | {ref}`Write your first Kubernetes charm for a Go app <write-your-first-kubernetes-charm-for-a-go-app>`                     |
| 1     | how-to                                                  | {ref}`How-to guides <sdk-how-to-guides>`                                                            |
| 2     | build-a-12-factor-app-charm                             | {ref}`Build a 12-Factor app charm <how-to-build-a-12-factor-app-charm>`                                             |
| 2     | build-and-own-a-charm-or-a-bundle                       | {ref}`Build and own a charm or a bundle <how-to-build-and-own-a-charm-or-a-bundle>`                                       |
| 2     | manage-bundles                                          | {ref}`Manage bundles <how-to-manage-charm-bundles>`                                                           |
| 2     |                                                         | Set things up                                                                       |
| 3     | dev-setup                                               | {ref}`Set up your development environment <set-up-your-development-environment>`                                      |
| 3     | set-up-a-charm-project                                  | {ref}`Set up a charm project <how-to-set-up-a-charm-project>`                                                   |
| 3     | manage-extensions                                       | {ref}`Manage extensions <manage-extensions>`                                                       |
| 3     | manage-charmcraft                                       | {ref}`Manage Charmcraft <how-to-manage-charmcraft>`                                                        |
| 4     | install-charmcraft                                      | {ref}`Install Charmcraft <how-to-install-charmcraft>`                                                       |
| 4     | charmcraft-config                                       | {ref}`Configure Charmcraft <how-to-configure-charmcraft>`                                                     |
| 4     | remote-env-auth                                         | {ref}`Authenticate Charmcraft in remote environments <how-to-authenticate-charmcraft-in-remote-environments>`                           |
| 4     | change-step-behavior-in-a-charm                         | {ref}`Change step behavior when creating a charm <how-to-change-step-behavior-when-creating-a-charm>`                               |
| 3     | include-extra-files-in-a-charm                          | {ref}`Include extra files in a charm <how-to-include-extra-files-in-a-charm>`                                          |
| 2     |                                                         | Develop                                                                             |
| 3     | logging                                                 | {ref}`Configure logging in a charm <how-to-log-a-message-in-a-charm>`                                             |
| 3     | resources                                               | {ref}`Use charm resources <how-to-manage-charm-resources>`                                                      |
| 3     | workloads                                               | {ref}`Run workloads with a charm - machines <how-to-run-workloads-with-a-charm---machines>`                                    |
| 3     | interact-with-pebble                                    | {ref}`Run workloads with a charm - Kubernetes <how-to-run-workloads-with-a-charm---kubernetes>`                                  |
| 3     | set-the-charm-version                                   | {ref}`Set the charm version <how-to-set-the-charm-version>`                                                   |
| 3     | set-the-workload-version                                | {ref}`Set the workload version <how-to-set-the-workload-version>`                                                |
| 3     | actions                                                 | {ref}`Add an action to a charm <how-to-add-an-action-to-a-charm>`                                                 |
| 3     | config                                                  | {ref}`Add a config option to a charm <how-to-add-a-configuration-option-to-a-charm>`                                           |
| 3     | use-storage-in-a-charm                                  | {ref}`Use storage in a charm <how-to-use-storage-in-your-charm>`                                                  |
| 3     | add-a-secret-to-a-charm                                 | {ref}`Use secrets in a charm <how-to-use-secrets-in-a-charm>`                                                   |
| 3     | manage-libraries                                        | {ref}`Use charm libraries <how-to-manage-charm-libraries>`                                                      |
| 4     | find-and-use-a-charm-library                            | {ref}`Find and use a charm library <how-to-find-and-use-a-charm-library>`                                             |
| 4     | create-and-publish-a-charm-library                      | {ref}`Create and publish a charm library <how-to-create-and-share-a-charm-library>`                                       |
| 4     | write-a-scenario-test-for-a-charm-library               | {ref}`Write a scenario test for a charm library <how-to-test-charm-libraries-with-scenario>`                               |
| 4     | document-your-charm-library                             | {ref}`Document a charm library <how-to-document-your-charm-library>`                                                 |
| 3     | handle-leadership                                       | {ref}`Handle leadership <how-to-handle-leadership>`                                                       |
| 3     | implement-integrations-in-a-charm                       | {ref}`Add an integration to a charm <how-to-add-an-integration-to-a-charm>`                                            |
| 3     | instrument-your-charm-with-tracing-telemetry            | {ref}`Observe a charm <how-to-instrument-your-charm-with-tracing-telemetry>`                                                         |
| 3     |                                                         | Manage interfaces                                                                   |
| 4     | register-an-interface                                   | {ref}`Register an interface <how-to-register-an-interface>`                                                   |
| 4     | write-interface-tests                                   | {ref}`Write interface tests <how-to-write-interface-tests>`                                                   |
| 2     |                                                         | Test and debug                                                                      |
| 3     | get-started-with-charm-testing                          | {ref}`Get started with charm testing <getting-started-with-charm-testing>`                                           |
| 3     | write-a-unit-test-for-a-charm                           | {ref}`Write a unit test for a charm <how-to-write-unit-tests-for-a-charm>`                                            |
| 3     | write-a-functional-test-for-a-charm-with-scenario       | {ref}`Write a scenario test for a charm <how-to-write-scenario-tests-for-a-charm>`                                       |
| 3     | write-integration-tests-for-a-charm                     | {ref}`Write integration tests for a charm <how-to-write-integration-tests-for-a-charm>`                                     |
| 3     | pack-a-charm                                            | {ref}`Pack a charm <how-to-pack-a-charm>`                                                             |
| 3     | deploy-a-charm                                          | {ref}`Deploy a charm <how-to-deploy-a-charm>`                                                           |
| 3     | debug-a-charm                                           | {ref}`Debug a charm <how-to-debug-a-charm>`                                                            |
| 3     | get-logs-from-a-kubernetes-charm                        | {ref}`Get logs from a Kubernetes charm <how-to-get-logs-from-a-kubernetes-charm>`                                         |
| 2     |                                                         | Document                                                                            |
| 3     | add-docs-to-your-charmhub-page                          | {ref}`Add docs to a charm on Charmhub <how-to-add-docs-to-your-charm-or-charm-bundle-on-charmhub>`                                          |
| 3     | charm-documentation                                     | {ref}`Document a charm: The README file <how-to-create-an-effective-readme-file-for-your-charm>`                                        |
| 2     |                                                         | Market                                                                              |
| 3     | publishing                                              | {ref}`Publish a charm <how-to-publish-your-charm-on-charmhub>`                                                          |
| 3     | create-a-track-for-your-charm                           | {ref}`Create a track for your charm <how-to-create-a-track-for-your-charm>`                                           |
| 3     | create-an-icon-for-your-charm                           | {ref}`Create an icon for a charm <how-to-create-an-icon-for-your-charm>`                                               |
| 2     |                                                         | Miscellaneous                                                                       |
| 3     |                                                         | Align an old charm with charmcraft and ops                                          |
| 4     | turn-a-hooks-based-charm-into-an-ops-charm              | {ref}`Turn a hooks-based charm into an ops charm <how-to-turn-a-hooks-based-charm-into-an-ops-charm>`                               |
| 4     | pack-a-reactive-based-charm-with-charmcraft             | {ref}`Pack a reactive-based charm with Charmcraft <how-to-pack-your-reactive-based-charm-with-charmcraft>`                              |
| 4     | pack-a-hooks-based-charm-with-charmcraft                | {ref}`Pack a hooks-based charm with Charmcraft <how-to-pack-your-hooks-based-charm-with-charmcraft>`                                 |
| 1     | reference                                               | {ref}`Reference <sdk-reference>`                                                                |
| 2     | bundle                                                  | {ref}`Bundle <bundle>`                                                                   |
| 3     | bundle.yaml                                             | {ref}`File `<bundle>.yaml` <file-bundleyaml>`                                                     |
| 2     | charm                                                   | {ref}`Charm <charm>`                                                                    |
| 3     | list-of-files-in-the-charm-project                      | {ref}`List of files in the charm project <list-of-files-in-a-charm-project>`                                       |
| 4     | contributing-md                                         | {ref}`File 'CONTRIBUTING.md' <file-contributingmd>`                                                   |
| 4     | license                                                 | {ref}`File 'LICENSE' <file-license>`                                                           |
| 4     | readme-md                                               | {ref}`File 'README.md' <file-readmemd>`                                                         |
| 4     | actions-yaml                                            | {ref}`File 'actions.yaml' <file-actionsyaml>`                                                      |
| 4     | charmcraft-yaml                                         | {ref}`File 'charmcraft.yaml' <file-charmcraftyaml>`                                                   |
| 4     | config-yaml                                             | {ref}`config.yaml <file-configyaml>`                                                              |
| 4     | dispatch                                                | {ref}`File 'dispatch' <file-dispatch>`                                                         |
| 4     | icon-svg                                                | {ref}`File 'icon.svg' <file-iconsvg>`                                                          |
| 4     | lxd-profile-yaml                                        | {ref}`File 'lxd-profile.yaml' <file-lxd-profileyaml>`                                                  |
| 4     | manifest-yaml                                           | {ref}`File 'manifest.yaml' <file-manifestyaml>`                                                     |
| 4     | metadata-yaml                                           | {ref}`File 'metadata.yaml' <file-metadatayaml>`                                                     |
| 4     | pyproject-toml                                          | {ref}`File 'pyproject.toml' <file-pyprojecttoml>`                                                   |
| 4     | requirements-dev-txt                                    | {ref}`File 'requirements-dev.txt' <file-requirements-devtxt>`                                              |
| 4     | requirements-txt                                        | {ref}`File 'requirements.txt' <file-requirementstxt>`                                                  |
| 4     | src-charm-py                                            | {ref}`File 'src/charm.py' <file-srccharmpy>`                                                      |
| 4     | tests-unit-test-charm-py                                | {ref}`File 'tests/unit/test_charm.py' <file-testsunittest_charmpy>`                                          |
| 4     | tests-integration-test-charm-py                         | {ref}`File 'tests/integration/test_charm.py' <file-‘testsintegrationtest_charmpy’>`                                  |
| 4     | tox-ini                                                 | {ref}`File 'tox.ini <file-toxini>`                                                           |
| 3     | the-juju-execution-flow-for-a-charm                     | {ref}`The Juju execution flow for a charm <the-juju-execution-flow-for-a-charm>`                                     |
| 3     | charm-taxonomy                                          | {ref}`Charm taxonomy <charm-taxonomy>`                                                           |
| 4     | 12-factor-app-charm                                     | {ref}`12-Factor app charm <12-factor-app-charm>`                                                     |
| 3     | charm-maturity                                          | {ref}`Charm maturity <charm-maturity>`                                                          |
| 4     | charm-maturity-stage-1                                  | {ref}`Charm maturity stage 1 <stage-1-important-qualities>`                                                   |
| 4     | charm-maturity-stage-2                                  | {ref}`Charm maturity stage 2 <stage-2-important-capabilities>`                                                   |
| 3     | naming                                                  | {ref}`Charm naming guidelines <charm-naming-guidelines>`                                                  |
| 3     | styleguide                                              | {ref}`Charm development best practices <charm-development-best-practices>`                                         |
| 2     | charmcraft                                              | {ref}`Charmcraft <charmcraft-charmcraft>`                                                               |
| 3     | charmcraft-cli-commands                                 | {ref}`List of Charmcraft CLI commands <list-of-charmcraft-commands>`                                          |
| 4     | charmcraft-analyse                                      | {ref}``charmcraft analyse` <command-charmcraft-analyse>`                                                     |
| 4     | charmcraft-build                                        | {ref}``charmcraft build` <command-charmcraft-build>`                                                      |
| 4     | charmcraft-clean                                        | {ref}``charmcraft clean` <command-charmcraft-clean>`                                                       |
| 4     | charmcraft-close                                        | {ref}``charmcraft close` <command-charmcraft-close>`                                                       |
| 4     | charmcraft-create-lib                                   | {ref}``charmcraft create-lib` <command-charmcraft-create-lib>`                                                  |
| 4     | charmcraft-expand-extensions                            | {ref}``charmcraft expand-extensions` <command-charmcraft-expand-extensions>`                                          |
| 4     | charmcraft-fetch-lib                                    | {ref}``charmcraft fetch-lib` <command-charmcraft-fetch-lib>`                                                   |
| 4     | charmcraft-fetch-libs                                   | {ref}``charmcraft fetch-libs` <command-charmcraft-fetch-libs>`                                                 |
| 4     | charmcraft-init                                         | {ref}``charmcraft init` <command-charmcraft-init>`                                                        |
| 4     | charmcraft-list-extensions                              | {ref}``charmcraft list-extensions` <command-charmcraft-list-extensions>`                                            |
| 4     | charmcraft-list-lib                                     | {ref}``charmcraft list-lib` <command-charmcraft-list-lib>`                                                    |
| 4     | charmcraft-login                                        | {ref}``charmcraft login` <command-charmcraft-login>`                                                       |
| 4     | charmcraft-logout                                       | {ref}``charmcraft logout` <command-charmcraft-logout>`                                                      |
| 4     | charmcraft-names                                        | {ref}``charmcraft names` <command-charmcraft-names>`                                                       |
| 4     | charmcraft-pack                                         | {ref}``charmcraft pack` <command-charmcraft-pack>`                                                        |
| 4     | charmcraft-prime                                        | {ref}``charmcraft prime` <command-charmcraft-prime>`                                                      |
| 4     | charmcraft-promote-bundle                               | {ref}``charmcraft promote-bundle` <command-charmcraft-promote-bundle>`                                             |
| 4     | charmcraft-pull                                         | {ref}``charmcraft pull` <command-charmcraft-pull>`                                                       |
| 4     | charmcraft-publish-lib                                  | {ref}``charmcraft publish-lib` <command-charmcraft-publish-lib>`                                                 |
| 4     | charmcraft-register                                     | {ref}``charmcraft register` <command-charmcraft-register>`                                                    |
| 4     | charmcraft-register-bundle                              | {ref}``charmcraft register-bundle` <command-charmcraft-register-bundle>`                                             |
| 4     | charmcraft-release                                      | {ref}``charmcraft release` <command-charmcraft-release>`                                                     |
| 4     | charmcraft-remote-build                                 | {ref}``charmcraft remote-build` <command-charmcraft-remote-build>`                                               |
| 4     | charmcraft-resources                                    | {ref}``charmcraft resources` <command-charmcraft-resources>`                                                   |
| 4     | charmcraft-resource-revisions                           | {ref}``charmcraft resource-revisions` <command-charmcraft-resource-revisions>`                                          |
| 4     | charmcraft-revisions                                    | {ref}``charmcraft revisions` <command-charmcraft-revisions>`                                                   |
| 4     | charmcraft-set-resource-architectures                   | {ref}``charmcraft set-resource-architectures` <command-charmcraft-set-resource-architectures>`                                 |
| 4     | charmcraft-stage                                        | {ref}``charmcraft stage` <command-charmcraft-stage>`                                                      |
| 4     | charmcraft-status                                       | {ref}``charmcraft status` <command-charmcraft-status>`                                                      |
| 4     | charmcraft-unregister                                   | {ref}``charmcraft unregister` <command-charmcraft-unregister>`                                                 |
| 4     | charmcraft-upload                                       | {ref}``charmcraft upload` <command-charmcraft-upload>`                                                      |
| 4     | charmcraft-upload-resource                              | {ref}``charmcraft upload-resource` <command-charmcraft-upload-resource>`                                             |
| 4     | charmcraft-version                                      | {ref}``charmcraft version` <command-charmcraft-version>`                                                     |
| 4     | charmcraft-whoami                                       | {ref}``charmcraft whoami` <command-charmcraft-whoami>`                                                      |
| 3     | charmcraft-extension-flask-framework                    | {ref}`Charmcraft extension ‘flask-framework’ <charmcraft-extension-flask-framework>`                                  |
| 3     | charmcraft-extension-django-framework                   | {ref}`Charmcraft extension 'django-framework' <charmcraft-extension-django-framework>`                                 |
| 3     | charmcraft-extension-fastapi-framework                  | {ref}`Charmcraft extension 'fastapi-framework' <charmcraft-extension-fastapi-framework>`                                |
| 3     | charmcraft-extension-go-framework                  | {ref}`Charmcraft extension 'go-framework' <charmcraft-extension-go-framework>`                                |
| 3     | charmcraft-deprecations                                 | {ref}`Charmcraft deprecation notices <charmcraft-deprecation-notices>`                                           |
| 3     | charmcraft-analyzers-and-linters                        | {ref}`Charmcraft analyzers and linters <charmcraft-analyzers-and-linters>`                                         |
| 2     | charmhub                                                | {ref}`Charmhub <charmhub>`                                                                 |
| 2     | charm-relation-interfaces                               | {ref}``charm-relation-interfaces` <charm-relation-interfaces>`                                             |
| 2     | event                                                   | {ref}`Event <event>`                                                                    |
| 3     | list-of-events                                          | {ref}`List of events <list-of-events>`                                                           |
| 4     | events                                                  | {ref}`Lifecycle events <lifecycle-events>`                                                         |
| 4     | secret-events                                           | {ref}`Secret events <secret-events>`                                                            |
| 4     | relation-events                                         | {ref}`Relation events <relation-events>`                                                          |
| 4     | storage-events                                          | {ref}`Storage events <storage-events>`                                                           |
| 3     | custom-event                                            | {ref}`Custom event <custom-event>`                                                             |
| 3     | charm-lifecycle                                         | {ref}`Charm lifecycle <charm-lifecycle>`                                                          |
| 2     | extension                                               | {ref}`Extension <extension>`                                                               |
| 2     | library                                                 | {ref}`Library <library>`                                                                  |
| 2     | jhack                                                   | {ref}``jhack` <jhack>`                                                                  |
| 3     | jhack-tail                                              | {ref}``jhack tail` <explore-event-emission-with-jhack-tail>`                                                             |
| 3     | jhack-show-relation                                     | {ref}``jhack show-relation` <visualize-relation-data-with-show-relation>`                                                    |
| 3     | library-index                                           | {ref}`Popular charm library index <popular-charm-library-index>`                                              |
| 2     | ops                                                     | {ref}`Ops <ops-ops>`                                                                      |
| 2     | pebble                                                  | {ref}`Pebble <pebble>`                                                                  |
| 2     | profile                                                 | {ref}`Profile <profile>`                                                                 |
| 2     | promotion                                               | {ref}`Promotion <promotion>`                                                               |
| 2     | publication                                             | {ref}`Publication <charm-publication>`                                                              |
| 3     | reasons-to-publish-your-charm-on-charmhub               | {ref}`Reasons to publish your charm on Charmhub <reasons-to-publish-your-charm-on-charmhub>`                                |
| 2     | pytest-operator                                         | {ref}``pytest-operator` <library-pytest-operator>`                                                       |
| 2     | revision                                                | {ref}`Revision <revision>`                                                                |
| 2     | rockcraft                                               | {ref}`Rockcraft <rockcraft>`                                                               |
| 3     | rockcraft-extension-flask-framework                     | {ref}`Rockcraft extension ‘flask-framework’ <rockcraft-extension-flask-framework>`                                   |
| 3     | rockcraft-extension-django-framework                    | {ref}`Rockcraft extension 'django-framework' <rockcraft-extension-django-framework>`                                  |
| 3     | rockcraft-extension-fastapi-framework                   | {ref}`Rockcraft extension 'fastapi-framework' <rockcraft-extension-fastapi-framework>`                                 |
| 2     | scenario                                                | {ref}`Scenario <scenario>`                                                                |
| 3     | scenario-context                                        | {ref}`Context <context-scenario>`                                                                 |
| 3     | scenario-event                                          | {ref}`Event <event-scenario>`                                                                   |
| 3     | scenario-state                                          | {ref}`State <state-scenario>`                                                                   |
| 2     | status                                                  | {ref}`Status <status>`                                                                  |
| 2     | storage                                                 | {ref}`Storage <storage>`                                                                  |
| 2     | stored-state-uses-limitations                           | {ref}`StoredState: Uses, Limitations <storedstate-uses-limitations>`                                           |
| 2     | testing                                                 | {ref}`Testing <testing>`                                                                 |
| 3     | interface-tests                                         | {ref}`Interface tests <interface-tests>`                                                         |
| 2     | yaml-anchors-and-aliases                                | {ref}`YAML anchors and aliases <yaml-anchors-and-aliases>`                                                 |
| 1     | explanation                                             | {ref}`Explanation <sdk-explanation>`                                              |
| 2     | history                                                 | {ref}`Charming history <about-charming-history>`                                                         |
| 2     | charmed-operators-vs-kubernetes-operators               | {ref}`Charmed operators vs. Kubernetes operators <charms-vs-kubernetes-operators>`                               |
| 2     | how-and-when-to-defer-events                            | {ref}`How and When to Defer Events <how-and-when-to-defer-events>`                                            |
| 2     | holistic-vs-delta-charms                                | {ref}`Holistic vs delta charms <holistic-vs-delta-charms>`                                                |
| 2     | talking-to-a-workload-control-flow-from-a-to-z          | {ref}`Talking to a workload: control flow from A to Z <talking-to-a-workload-control-flow-from-a-to-z>`                          |
|       | roadmap                                                 | {ref}`Roadmap <roadmap--releases>`                                                                  |
|       |                                                         | Level 4+ items (currently not supported)                                            |
|       | events                                                  | {ref}`Lifecycle events <lifecycle-events>`                                                         |
|       | collect-metrics-event                                   | {ref}``collect-metrics` (deprecated) <event-collect-metrics-deprecated>`                                           |
|       | config-changed-event                                    | {ref}``config-changed` <event-config-changed>`                                                         |
|       | install-event                                           | {ref}``install` <event-install>`                                                                |
|       | leader-elected-event                                    | {ref}``leader-elected` <event-leader-elected>`                                                         |
|       | leader-settings-changed-event                           | {ref}``leader-settings-changed` <event-leader-settings-changed>`                                                |
|       | post-series-upgrade-event                               | {ref}``post-series-upgrade` <event-post-series-upgrade>`                                                    |
|       | pre-series-upgrade-event                                | {ref}``pre-series-upgrade` <event-pre-series-upgrade>`                                                     |
|       | remove-event                                            | {ref}``remove` <event-remove>`                                                                 |
|       | start-event                                             | {ref}``start` <event-start>`                                                                  |
|       | stop-event                                              | {ref}``stop` <event-stop>`                                                                   |
|       | update-status-event                                     | {ref}``update-status` <event-update-status>`                                                          |
|       | upgrade-charm-event                                     | {ref}``upgrade-charm` <event-upgrade-charm>`                                                          |
|       | secret-events                                           | {ref}`Secret events <secret-events>`                                                            |
|       | event-secret-changed                                    | {ref}``secret-changed` <event-secret-changed>`                                                         |
|       | event-secret-expired                                    | {ref}``secret-expired` <event-secret-expired>`                                                         |
|       | event-secret-remove                                     | {ref}``secret-remove` <event-secret-remove>`                                                          |
|       | event-secret-rotate                                     | {ref}``secret-rotate` <event-secret-rotate>`                                                          |
|       | relation-events                                         | {ref}`Relation events <relation-events>`                                                          |
|       | relation-name-relation-broken-event                     | {ref}``<relation name>-relation-broken` <event-relation-name-relation-broken>`                                        |
|       | relation-name-relation-changed-event                    | {ref}``<relation name>-relation-changed` <event-relation-name-relation-changed>`                                       |
|       | relation-name-relation-created-event                    | {ref}``<relation name>-relation-created` <event-relation-name-relation-created>`                                       |
|       | relation-name-relation-departed-event                   | {ref}``<relation name>-relation-departed` <event-relation-name-relation-departed>`                                      |
|       | relation-name-relation-joined-event                     | {ref}``<relation name>-relation-joined` <event-relation-name-relation-joined>`                                        |
|       | storage-events                                          | {ref}`Storage events <storage-events>`                                                           |
|       | storage-name-storage-attached-event                     | {ref}``<storage name>-storage-attached` <event-storage-name-storage-attached>`                                        |
|       | storage-name-storage-detaching-event                    | {ref}``<storage name>-storage-detaching` <event-storage-name-storage-detaching>`                                       |
|       |                                                         | Other events                                                                        |
|       | action-name-action-event                                | {ref}``<action name>-action` <event-action-name-action>`                                                   |
|       | container-name-pebble-custom-notice-event               | {ref}``<container name>-pebble-custom-notice` <event-container-pebble-custom-notice>`                                 |
|       | container-name-pebble-ready-event                       | {ref}``<container name>-pebble-ready` <event-container-pebble-ready>`                                          |
|       |                                                         | Ops events                                                                          |
|       | events-collect-app-status-and-collect-unit-status       | {ref}`Events 'collect-app-status' and 'collect-unit-status' <events-collect-app-status-and-collect-unit-status>`                   |
|       |                                                         | Charmcraft CLI commands                                                             |
|       |                                                         | Files in the charm project                                                          |
|       |                                                         | Charm maturity                                                                      |
|       |                                                         | Developer tools >> Tools for debugging                                              |
|       |                                                         | Ops                                                                                 |
|       | ops-classes                                             | {ref}`Ops classes <ops-classes>`                                                              |
|       | api-reference                                           | [API reference](https://ops.rtfd.io)                                                |
|       |                                                         | Publication                                                                         |
|       |                                                         | Testing                                                                             |
|       |                                                         | Unit testing                                                                        |
|       |                                                         | Integration testing                                                                 |
|       |                                                         | Other                                                                               |
|       | create-an-ubuntu-virtual-machine-with-multipass         | &nbsp;&nbsp;&nbsp; {ref}`Create an Ubuntu virtual machine with Multipass <how-to-create-an-ubuntu-virtual-machine-with-multipass>`       |
|       | hello-world                                             | {ref}`Hello, world <hello-world>`                                                             |
|       | setup                                                   | {ref}`Set-up <how-to-set-up-the-juju-sdk>`                                                                   |
|       |                                                         | INTEGRATE WITH EXISTING MATERIAL                                                    |
|       | libraries                                               | {ref}`Libraries <libraries>`                                                                |


```

<h2 id="heading--navigation">Redirects</h2>

```{dropdown} Mapping table

| Location                                                               | Path                                                                                                            |
|------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| /docs/sdk/charm-types                                                  | /docs/sdk/charm-types-by-destination-type                                                                       |
| /docs/sdk/setting-up-charmcraft                                        | /docs/sdk/install-charmcraft                                                                                    |
| /docs/sdk/bundles                                                      | /docs/sdk/publish-a-charm-bundle-to-charmhub                                                                    |
| /docs/sdk/bundle-reference                                             | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/charmcraft-libraries                                         | /docs/sdk/manage-libraries                                                                                      |
| /docs/sdk/event-hook                                                   | /docs/sdk/event                                                                                                 |
| /docs/sdk/setup                                                        | /docs/sdk/tutorials                                                                                             |
| /docs/sdk/                                                             | /docs/sdk                                                                                                       |
| /docs/sdk/charm-types-by-deployment-type                               | /docs/sdk/charm-types                                                                                           |
| /docs/sdk/charm-types-by-development-type                              | /docs/sdk/charm-types                                                                                           |
| /docs/sdk/charm-pre-publication-checklist                              | /docs/sdk/charm-publication-checklist                                                                           |
| /docs/sdk/initialise-your-charm                                        | /docs/sdk/set-up-a-charm-project                                                                                |
| /docs/sdk/metadata-reference                                           | /docs/sdk/metadata-yaml                                                                                         |
| /docs/sdk/charm-anatomy                                                | /docs/sdk/list-of-files-in-the-charm-project                                                                    |
| /docs/sdk/relations                                                    | /docs/sdk/integration                                                                                           |
| /docs/sdk/the-lifecycle-of-charm-relations                             | /docs/sdk/the-lifecycle-of-charm-integrations                                                                   |
| /docs/sdk/assumes                                                      | /docs/sdk/metadata-yaml                                                                                         |
| /docs/sdk/debugging                                                    | /docs/sdk/debug-a-charm                                                                                         |
| /docs/sdk/build-and-deploy-minimal-kubernetes-charm                    | /docs/sdk/from-zero-to-hero-write-your-first-kubernetes-charm                                                   |
| /docs/sdk/the-location-of-a-charm-library-inside-a-charm               | /docs/sdk/library                                                                                               |
| /docs/sdk/charm-libraries                                              | /docs/sdk/library                                                                                               |
| /docs/sdk/manage-charms                                                | /docs/sdk/how-to                                                                                                |
| /docs/sdk/build-your-charm                                             | /docs/sdk/pack-a-charm                                                                                          |
| /docs/sdk/deploy-your-charm                                            | /docs/sdk/deploy-a-charm                                                                                        |
| /docs/sdk/testing                                                      | /docs/sdk/write-a-unit-test-for-a-charm                                                                         |
| /docs/sdk/write-an-integration-test-for-a-charm                        | /docs/sdk/write-an-integration-test-for-a-charm                                                                 |
| /docs/sdk/pack-your-reactive-based-charm-with-charmcraft               | /docs/sdk/pack-a-reactive-based-charm-with-charmcraft                                                           |
| /docs/sdk/pack-your-hooks-based-charm-with-charmcraft                  | /docs/sdk/pack-a-hooks-based-charm-with-charmcraft                                                              |
| /docs/sdk/understand-your-application                                  | /docs/sdk/study-your-application                                                                                |
| /docs/sdk/charm-types                                                  | /docs/sdk/charm-taxonomy                                                                                        |
| /docs/sdk/charm-publication-checklist                                  | /docs/sdk/charm-maturity-stage-1                                                                                |
| /docs/sdk/charm-evaluation-checklist                                   | /docs/sdk/charm-maturity-stage-2                                                                                |
| /docs/sdk/build-and-deploy-minimal-machine-charm                       | /docs/sdk/write-your-first-machine-charm                                                                        |
| /docs/sdk/run-tests                                                    | /docs/sdk/list-of-files-in-the-charm-project                                                                    |
| /docs/sdk/tests--init--py                                              | /docs/sdk/list-of-files-in-the-charm-project                                                                    |
| /docs/sdk/tests-test-charm-py                                          | /docs/sdk/tests-unit-test-charm-py                                                                              |
| /docs/sdk/version                                                      | /docs/sdk/list-of-files-in-the-charm-project                                                                    |
| /docs/sdk/write-an-integration-test-for-a-charm                        | /docs/sdk/write-integration-tests-for-a-charm                                                                   |
| /docs/sdk/integration-testing-cookbook                                 | /docs/sdk/write-integration-tests-for-a-charm                                                                   |
| /docs/sdk/a-charms-life                                                | /docs/sdk/charm-lifecycle                                                                                       |
| /docs/sdk/charmed-operators                                            | /docs/sdk/charm                                                                                                 |
| /docs/sdk/deferring-events-details-and-dilemmas                        | /docs/sdk/how-and-when-to-defer-events                                                                          |
| /docs/sdk/create-a-charm-bundle                                        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/configure-a-charm-bundle                                     | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/compare-a-bundle-to-a-model                                  | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/pack-a-charm-bundle                                          | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/deploy-a-charm-bundle                                        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/publish-a-charm-bundle-to-charmhub                           | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/configure-a-charm-bundle                                     | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/set-charm-channels-within-a-bundle                           | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/set-charm-constraints-within-a-bundle                        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/set-charm-options-within-a-bundle                            | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/integrate-a-local-charm-into-a-bundle                        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/add-an-overlay-bundle                                        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/append-an-overlay-bundle-to-a-base-bundle                    | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/resolve-a-relative-path-inside-a-bundle                      | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/remove-an-application-from-a-bundle                          | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/replace-machines-in-a-bundle                                 | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/modify-relations-inside-a-bundle                             | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/add-machine-specifications-to-a-bundle                       | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/bind-endpoints-within-a-bundle                               | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/specify-application-expose-parameters-within-a-bundle        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/use-charm-resources-in-a-bundle                              | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/recycle-machines-in-a-bundle                                 | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/add-a-placement-directive-to-a-bundle                        | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/add-storage-directives-to-a-bundle                           | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/set-up-subordinate-charms-inside-a-bundle                    | /docs/sdk/manage-bundles                                                                                        |
| /docs/sdk/charm-bundles                                                | /docs/sdk/bundle                                                                                                |
| /docs/sdk/kubernetes-vs-non-kubernetes-bundles                         | /docs/sdk/bundle.yaml                                                                                           |
| /docs/sdk/charmcraft-analyze                                           | /docs/sdk/charmcraft-analyse                                                                                    |
| /docs/sdk/action                                                       | [https://juju.is/docs/juju/action](https://juju.is/docs/juju/action)                                            |
| /docs/sdk/channel                                                      | [https://juju.is/docs/juju/channel](https://juju.is/docs/juju/channel)                                          |
| /docs/sdk/configuration                                                | [https://juju.is/docs/juju/configuration](https://juju.is/docs/juju/configuration)                              |
| /docs/sdk/hook                                                         | [https://juju.is/docs/juju/hook](https://juju.is/docs/juju/hook)                                                |
| /docs/sdk/hook-tool                                                    | [https://juju.is/docs/juju/hook-tool](https://juju.is/docs/juju/hook-tool)                                      |
| /docs/sdk/charm-environment-variables                                  | {ref}`https://juju.is/docs/juju/charm-environment-variables <4449md>` |
| /docs/sdk/leadership-hook-tools                                        | {ref}`https://juju.is/docs/juju/hook-tool <4449md>`                                     |
| /docs/sdk/integration                                                  | [https://juju.is/docs/juju/relation](https://juju.is/docs/juju/relation)                                        |
| /docs/sdk/the-lifecycle-of-charm-integrations                          | [https://juju.is/docs/juju/relation](https://juju.is/docs/juju/relation)                                        |
| /docs/sdk/about-resources                                              | [https://juju.is/docs/juju/charm-resource](https://juju.is/docs/juju/charm-resource)                            |
| /docs/sdk/secret                                                       | [https://juju.is/docs/juju/secret](https://juju.is/docs/juju/secret)                                            |
| /docs/sdk/define-a-resource-for-your-charm                             | /docs/sdk/resources                                                                                             |
| /docs/sdk/associate-a-resource-to-your-charm                           | /docs/sdk/resources                                                                                             |
| /docs/sdk/publishing-resources                                         | /docs/sdk/resources                                                                                             |
| /docs/sdk/attach-a-resource-to-a-charm-at-release-time                 | /docs/sdk/resources                                                                                             |
| /docs/sdk/access-a-resource-from-your-charm                            | /docs/sdk/resources                                                                                             |
| /docs/sdk/write-your-first-kubernetes-charm-using-the-paas-app-charmer | /docs/sdk/write-your-first-kubernetes-charm-for-a-flask-app                                                     |
| /docs/sdk/constructs                                                   | /docs/sdk/ops                                                                                                   |
| /docs/sdk/framework                                                    | /docs/sdk/ops                                                                                                   |
| /docs/sdk/leadership                                                   | /docs/sdk/ops                                                                                                   |
| /docs/sdk/ops-model                                                    | /docs/sdk/ops                                                                                                   |
| /docs/sdk/ops-pebble                                                   | /docs/sdk/ops                                                                                                   |
| /docs/sdk/developer-tools                                              | /docs/sdk/jhack                                                                                                 |
| /docs/sdk/tools-for-debugging                                          | /docs/sdk/jhack                                                                                                 |
| /docs/sdk/paas-app-charmer                                             | /docs/sdk/12-factor-app-charm                                                                                            |
| /docs/sdk/paas-charm                                             | /docs/sdk/12-factor-app-charm                                                                                            |
| /docs/sdk/build-a-paas-charm                                             | /docs/sdk/build-a-12-factor-app-charm                                                                                           |
|                                                                        |                                                                                                                 |

```


<!--From juju.is/tutorials, the docs relating to the SDK

Meta:
| 1 | how-to-write-a-tutorial | {ref}`How to write a tutorial  <4449md>` |
If linked in SDK docs, gives rise to 500 errors on bundles-reference:
|   | how-to-work-with-bundles-in-charmcraft | {ref}`Work with bundles <4449md>` |
|   |                                        |                              |
Covered better by the existing SDK doc:
|   | publish-on-charmhub | {ref}`Publish your operator in Charmhub <4449md>` |
	Draft tutorial about an unpublished feature on Charmhub:
| 1 | how-to-write-a-topic-page | {ref}`How to write a topic page  <4449md>` |
|   |                           |                                                                 |

| 2     | build-and-deploy-minimal-machine-charm                  | {ref}`Write your first machine charm <4449md>`                                           |

Archived with redirect:
| 2 | manage-charms                         | {ref}`Manage charms <4449md>`                         |
| 3 | write-an-integration-test-for-a-charm | {ref}`Write an integration test for a charm <4449md>` |
| 3 | integration-testing-cookbook          | {ref}`Testing: Integration testing cookbook <4449md>` |
|   |                                       |                                                  |

Replaced without redirect:

https://discourse.charmhub.io/t/build-and-deploy-a-minimal-kubernetes-charm/5551 

>> This was just an overview page for Tutorial-Kubernetes, spanning a video and the doc
[video](https://www.youtube.com/watch?v=yxeJX2WRYjg
[text](/t/3246)                                    

Replaced it with a content page instead, with the new tutorial. Put in redirect from the "text" doc to the new doc. Linked the "video: inside the new doc.

Removed with redirect:
| 3 | charm-types-by-deployment-type            | {ref}`Charms, by deployment type <4449md>`                 |
| 3 | charm-types-by-development-type           | {ref}`Charms, by development type <4449md>`                |
|   | assumes                                   | {ref}`Assumes <4449md>`                                    |
|   |                                           |                                                       |
| 2 | build-and-deploy-minimal-kubernetes-charm | {ref}`Get started with the Juju SDK - Kubernetes <4449md>` |
|   |                                           |                                                       |
| 3     | the-location-of-a-charm-library-inside-a-charm          | {ref}`The location of a charm library inside a charm <4449md>`                                |

| 3     | constructs                                              | {ref}`Framework constructs <4449md>`                                                     |
| 3     | framework                                               | {ref}`Framework <4449md>`                                                                |
| 3     | leadership                                              | {ref}`Leader <4449md>`                                                                   |
| 3     | ops-model                                               | {ref}`Model <4449md>`                                                                    |
| 3     | ops-pebble                                              | {ref}`Pebble (Ops) <4449md>`                                                             |

-->