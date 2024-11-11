(juju-documentation)=
# Juju Documentation

```{tip}

This is the documentation for the latest Juju version, with in-line notes about version differences.

To find out what's new, see {ref}`Roadmap & Releases <roadmap--releases>`.

To upgrade, see {ref}`How to upgrade your deployment <how-to-upgrade-your-deployment>`.

```

Welcome to Juju, your entrypoint into the Juju universe!

![JujuLandscape|690x285](upload://kbm3OgYEv554GSK2oXJ8HujmwCU.jpeg)



Juju is an open source orchestration engine for software operators that enables the deployment, integration and lifecycle management of applications at any scale, on any infrastructure, using special software operators called 'charms'.

Juju provides a  model-driven way to install, provision, maintain, update, upgrade, and integrate applications on and across Kubernetes containers, Linux containers, virtual machines, and bare metal machines, on public or private cloud. 

As such, Juju makes it simple, intuitive, and efficient to manage the full lifecycle of complex applications in hybrid cloud.

<!--

Full lifecycle: You can deploy, maintain, update, upgrade. You can also easily scale by simply adding or removing resources (storage, networking, etc.). 

Complex application: You can deploy multiple small applications (charms) and then relate them to build a complex application (charm). When you upgrade a charm, all the dependencies upgrade automatically.

Hybrid cloud: You can deploy to Kubernetes clusters, containers, virtual machines, bare metal machines. One controller can manage models, and their corresponding applications, spanning multiple clouds. 

Intuitive way: To deploy applications, you just need to say `juju deploy <application foo>`, `juju deploy <application bar>`. To connect applications, you just need to say `juju relate <application foo> <application bar>. All applications are hosted on models, and each model is attached to a controller, and you can  see this easily in the terminal using the Juju CLI but also in the browser using the Juju GUI.
-->


For system operators and DevOps who manage applications in the cloud, Juju simplifies code; for CIOs, it helps align code with business decisions.

<!--
“Juju acts as a thin layer on top of your infrastructure that allows all your operational code to talk to each other. And because of this communication layer, a lot of the problems that conventional configuration management systems have just don’t exist anymore.” - Konstantin Boudnik, EPAM Systems
-->

> For a collection of existing charms, see [Charmhub](https://charmhub.io/). To build your own charm, see the [Charm SDK docs](https://juju.is/docs/sdk).


-----------------------------

## In this documentation

|                                                                                             |                                                                                             |
|---------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| {ref}`Tutorial <get-started-with-juju>`</br>  Get started - a hands-on introduction to Juju for new users </br> | {ref}`How-to guides <juju-how-to-guides>` </br> Step-by-step guides covering key operations and common tasks |
| {ref}`Explanation <juju-explanation>` </br> Discussion and clarification of key topics                     | {ref}`Reference <juju-reference>` </br> Technical information - specifications, APIs, architecture       |


-----------

## Project and community

Juju is an open source project that warmly welcomes community projects, contributions, suggestions, fixes and constructive feedback.

- Learn about the {ref}`Roadmap & Releases <roadmap--releases>` 
- Read our [Code of Conduct](https://ubuntu.com/community/code-of-conduct)
- Join our [Matrix chat](https://matrix.to/#/#charmhub-juju:ubuntu.com)
- Join the [Discourse forum](https://discourse.charmhub.io/t/welcome-to-the-charmed-operator-community/8) to talk about [Juju](https://discourse.charmhub.io/tags/c/juju/6/community-workshop), [charms](https://discourse.charmhub.io/c/charm/41), [docs](https://discourse.charmhub.io/c/doc/22), or [to meet the community](https://discourse.charmhub.io/tag/community-workshop)
- Report a bug on [Launchpad](https://bugs.launchpad.net/juju) (for code) or [GitHub](https://github.com/juju/docs/issues) (for docs)
- Contribute to the documentation on [Discourse](https://discourse.charmhub.io/t/documentation-guidelines-for-contributors/1245)
- Contribute to the code on [GitHub](https://github.com/juju/juju/blob/develop/CONTRIBUTING.md)
- Visit the [Juju careers page](https://juju.is/careers)


## Navigation

```{dropdown} Navigation

| Level | Path                                    | Navlink                                              |
|-------|-----------------------------------------|------------------------------------------------------|
| 1     |                                         | {ref}`Juju documentation <juju-documentation>`                        |
| 1     | tutorial                                | {ref}`Get started with Juju <get-started-with-juju>`                     |
| 1     | how-to                                  | {ref}`How-to guides <juju-how-to-guides>`               |
| 2     |                                         | Manage your deployment                               |
| 3     | set-up--tear-down-your-test-environment | {ref}`Set up / Tear down your test environment <set-up--tear-down-your-test-environment>` |
| 3     | harden-your-deployment                  | {ref}`Harden your deployment <how-to-harden-your-deployment>`                   |
| 3     | upgrade-your-juju-deployment            | {ref}`Upgrade your deployment <how-to-upgrade-your-deployment>`                   |
| 3     | troubleshoot-your-deployment            | {ref}`Troubleshoot your deployment <how-to-troubleshoot-your-deployment>`              |
| 4     | debug-bootstrapmachine-failures         | {ref}`Debug bootstrap/machine failures <how-to-debug-bootstrapmachine-failures>`          |
| 3     | take-your-deployment-offline            | {ref}`Take your deployment offline <how-to-take-your-deployment-offline>`             |
| 2     | install-and-manage-the-client           | {ref}`Install and manage the client <how-to-install-and-manage-the-client>`             |
| 2     | manage-the-juju-dashboard               | {ref}`Manage the dashboard <how-to-manage-the-juju-dashboard>`                      |
| 2     | manage-clouds                           | {ref}`Manage clouds <how-to-manage-clouds>`                             |
| 2     | manage-credentials                      | {ref}`Manage credentials <how-to-manage-credentials>`                        |
| 2     | manage-controllers                      | {ref}`Manage controllers <how-to-manage-controllers>`                        |
| 2     | manage-models                           | {ref}`Manage models <how-to-manage-models>`                             |
| 2     | manage-applications                     | {ref}`Manage applications <how-to-manage-applications>`                       |
| 2     | manage-relations                        | {ref}`Manage relations <how-to-manage-relations>`                          |
| 2     | manage-offers                           | {ref}`Manage offers <how-to-manage-offers>`                             |
| 2     | manage-charms-or-bundles                | {ref}`Manage charms or bundles <how-to-manage-charms-or-bundles>`                 |
| 2     | manage-charm-resources                  | {ref}`Manage charm resources <how-to-manage-charm-resources>`                   |
| 2     | manage-machines                         | {ref}`Manage machines <how-to-manage-machines>`                           |
| 2     | manage-storage                          | {ref}`Manage storage <how-to-manage-storage>`                            |
| 2     | manage-storage-pools                    | {ref}`Manage storage pools <how-to-manage-storage-pools>`                      |
| 2     | manage-subnets                          | {ref}`Manage subnets <how-to-manage-subnets>`                            |
| 2     | manage-spaces                           | {ref}`Manage spaces <how-to-manage-spaces>`                             |
| 2     | manage-logs                             | {ref}`Manage agent logs <how-to-manage-logs>`                         |
| 2     | manage-units                            | {ref}`Manage units <how-to-manage-units>`                              |
| 2     | manage-actions                          | {ref}`Manage actions <how-to-manage-actions>`                            |
| 2     | manage-ssh-keys                         | {ref}`Manage SSH keys <how-to-manage-ssh-keys>`                           |
| 2     | manage-users                            | {ref}`Manage users <how-to-manage-users>`                              |
| 2     | manage-secrets                          | {ref}`Manage secrets <how-to-manage-secrets>`                            |
| 2     | manage-secret-backends                  | {ref}`Manage secret backends <how-to-manage-secret-backends>`                    |
| 2     | manage-metadata                         | {ref}`Manage metadata <how-to-manage-metadata>`                          |
| 2     | manage-plugins                          | {ref}`Manage plugins <how-to-manage-plugins>`                            |
| 2     | unsorted                                | Unsorted                                             |
| 3     | define-instance-tags                    | {ref}`Define instance tags in a cloud <how-to-define-cloud-resource-tags-in-a-cloud>`           |
| 3     | fan-container-networking                | {ref}`Fan container networking <fan-container-networking>`                  |
| 3     | supported-features                      | {ref}`Supported features <supported-features>`     |
| 1     | reference                               | {ref}`Reference <juju-reference>`                       |
| 2     | action                                  | {ref}`Action <action>`                                    |
| 2     | agent                                   | {ref}`Agent <agent>`                                     |
| 3     | commands-available-on-a-juju-machine    | {ref}`Commands available on a Juju machine <commands-available-on-a-juju-machine>`      |
| 4     | agent-introspection                     | {ref}`Agent introspection <agent-introspection>`                        |
| 5     | agent-introspection-juju-engine-report  | {ref}`juju_engine_report <agent-introspection-juju_engine_report>`                         |
| 5     | agent-introspection-juju-goroutines     | {ref}`juju_goroutines <agent-introspection-juju_goroutines>`                            |
| 5     | agent-introspection-juju-heap-profile   | {ref}`juju_heap_profile <agent-introspection-juju_heap_profile>`                         |
| 5     | agent-introspection-juju-machine-lock   | {ref}`juju_machine_lock <agent-introspection-juju_machine_lock>`                          |
| 5     | agent-introspection-juju-metrics        | {ref}`juju_metrics <agent-introspection-juju_metrics>`                              |
| 5     | agent-introspection-juju-start-unit     | {ref}`juju_start_unit <agent-introspection-juju_start_unit>`                           |
| 5     | agent-introspection-juju-stop-unit      | {ref}`juju_stop_unit <agent-introspection-juju_stop_unit>`                            |
| 5     | agent-introspection-juju-unit-status    | {ref}`juju_unit_status <agent-introspection-juju_unit_status>`                          |
| 2     | application                             | {ref}`Application <application>`                               |
| 2     | base                                    | {ref}`Base <base>`                                      |
| 2     | binding                                 | {ref}`Binding <binding>`                                   |
| 2     | bootstrapping                           | {ref}`Bootstrapping <bootstrapping>`                             |
| 2     | bundle                                  | {ref}`Bundle <bundle>`				         |
| 2     | channel                                 | {ref}`Channel <channel>`                                   |
| 2     | charmed-operator                        | {ref}`Charm <charm>`                                     |
| 3     | charm-environment-variables             | {ref}`Charm environment variables <charm-environment-variables>`               |
| 2     | client                                  | {ref}`Client <client>`                                   |
| 2     | cloud                                   | {ref}`Cloud <cloud-substrate>`                                     |
| 3     | juju-supported-clouds                   | {ref}`List of supported clouds <list-of-supported-clouds>`                  |
| 4     | amazon-ec2                              | {ref}`Amazon AWS <the-amazon-ec2-cloud-and-juju>`                                |
| 4     | amazon-eks                              | {ref}`Amazon EKS <the-amazon-eks-cloud-and-juju>`                                |
| 4     | equinix-metal                           | {ref}`Equinix Metal <the-equinix-metal-cloud-and-juju>`                             |
| 4     | google-gce                              | {ref}`Google GCE <the-google-gce-cloud-and-juju>`                                |
| 4     | google-gke                              | {ref}`Google GKE <the-google-gke-cloud-and-juju>`                                |
| 4     | lxd                                     | {ref}`LXD <the-lxd-cloud-and-juju>`                                       |
| 4     | maas                                    | {ref}`MAAS <the-maas-cloud-and-juju>`                                      |
| 4     | manual                                  | {ref}`Manual setup <the-manual-cloud-and-juju>`                              |
| 4     | microk8s                                | {ref}`MicroK8s <the-microk8s-cloud-and-juju>`                                  |
| 4     | microsoft-azure                         | {ref}`Microsoft Azure <the-microsoft-azure-cloud-and-juju>`                           |
| 4     | microsoft-aks                           | {ref}`Microsoft AKS <the-microsoft-aks-cloud-and-juju>`                             |
| 4     | openstack                               | {ref}`OpenStack <openstack-and-juju>`                                 |
| 4     | oracle-oci                              | {ref}`Oracle <the-oracle-oci-cloud-and-juju>`                                    |
| 4     | vmware-vsphere                          | {ref}`VMware vSphere <vmware-vsphere-and-juju>`                            |
| 3     | kubernetes-clouds-and-juju              | {ref}`Kubernetes clouds and Juju <kubernetes-clouds-and-juju>`               |
| 2     | configuration                           | {ref}`Configuration <configuration>`                             |
| 3     | list-of-controller-configuration-keys   | {ref}`List of controller configuration keys <list-of-controller-configuration-keys>`     |
| 4     | audit-log-exclude-methods               | {ref}`audit-log-exclude-methods <controller-config-audit-log-exclude-methods>`                 |
| 4     | juju-ha-space                           | {ref}`juju-ha-space <controller-config-juju-ha-space>`                             |
| 4     | juju-mgmt-space                         | {ref}`juju-mgmt-space <controller-config-juju-mgmt-space>`                           |
| 3     | list-of-model-configuration-keys        | {ref}`List of model configuration keys <list-of-model-configuration-keys>`          |
| 2     | constraint                              | {ref}`Constraint <constraint>`                                |
| 2     | containeragent-binary                   | {ref}``containeragent` (binary) <binary-containeragent>`                |
| 2     | controller                              | {ref}`Controller <controller>`                                |
| 2     | credential                              | {ref}`Credential <credential>`                                |
| 2     | deployment                              | {ref}`Deploying <deploying>`                                |
| 2     | endpoint                                | {ref}`Endpoint <endpoint>`                                  |
| 2     | high-availability                       | {ref}`High-availability <high-availability-ha>`                         |
| 2     | hook                                    | {ref}`Hook <hook>`                                      |
| 2     | hook-tool                               | {ref}`Hook tool <hook-tool>`                                 |
| 2     |                                         | Juju                                                 |
| 3     | roadmap                                 | {ref}`Juju roadmap & releases <roadmap--releases>`                   |
| 3     | cross-version-compatibility-in-juju     | {ref}`Cross-version compatibility in Juju <cross-version-compatibility-in-juju>`      |
| 2     | juju-client                             | {ref}``juju` CLI (Juju client) <juju-juju-client>`                  |
| 3     | juju-cli-commands                       | {ref}``juju` CLI commands <juju-cli-commands>`                      |
| 4     | juju-actions                            | {ref}`juju actions <command-juju-actions>`                             |
| 4     | juju-add-cloud                          | {ref}`juju add-cloud <command-juju-add-cloud>`                           |
| 4     | juju-add-credential                     | {ref}`juju add-credential <command-juju-add-credential>`                      |
| 4     | juju-add-k8s                            | {ref}`juju add-k8s <command-juju-add-k8s>`                             |
| 4     | juju-add-machine                        | {ref}`juju add-machine <command-juju-add-machine>`                         |
| 4     | juju-add-model                          | {ref}`juju add-model <command-juju-add-model>`                           |
| 4     | juju-add-secret                         | {ref}`juju add-secret <command-juju-add-secret>`                          |
| 4     | juju-add-secret-backend                 | {ref}`juju add-secret-backend <command-juju-add-secret-backend>`                  |
| 4     | juju-add-space                          | {ref}`juju add-space <command-juju-add-space>`                           |
| 4     | juju-add-ssh-key                        | {ref}`juju add-ssh-key <command-juju-add-ssh-key>`                         |
| 4     | juju-add-storage                        | {ref}`juju add-storage <command-juju-add-storage>`                         |
| 4     | juju-add-unit                           | {ref}`juju add-unit <command-juju-add-unit>`                            |
| 4     | juju-add-user                           | {ref}`juju add-user <command-juju-add-user>`                            |
| 4     | juju-agree                              | {ref}`juju agree <command-juju-agree>`                               |
| 4     | juju-agreements                         | {ref}`juju agreements <command-juju-agreements>`                          |
| 4     | juju-attach-resource                    | {ref}`juju attach-resource <command-juju-attach-resource>`                     |
| 4     | juju-attach-storage                     | {ref}`juju attach-storage <command-juju-attach-storage>`                      |
| 4     | juju-autoload-credentials               | {ref}`juju autoload-credentials <command-juju-autoload-credentials>`                |
| 4     | juju-bind                               | {ref}`juju bind <command-juju-bind>`                                |
| 4     | juju-bootstrap                          | {ref}`juju bootstrap <command-juju-bootstrap>`                           |
| 4     | juju-cancel-task                        | {ref}`juju cancel-task <command-juju-cancel-task>`                         |
| 4     | juju-change-user-password               | {ref}`juju change-user-password <command-juju-change-user-password>`                |
| 4     | juju-charm-resources                    | {ref}`juju charm-resources <command-juju-charm-resources>`                     |
| 4     | juju-clouds                             | {ref}`juju clouds <command-juju-clouds>`                              |
| 4     | juju-collect-metrics                    | {ref}`juju collect-metrics <command-juju-collect-metrics>`                     |
| 4     | juju-config                             | {ref}`juju config <command-juju-config>`                              |
| 4     | juju-constraints                        | {ref}`juju constraints <command-juju-constraints>`                         |
| 4     | juju-consume                            | {ref}`juju consume <command-juju-consume>`                             |
| 4     | juju-controller-config                  | {ref}`juju controller-config <command-juju-controller-config>`                   |
| 4     | juju-controllers                        | {ref}`juju controllers <command-juju-controllers>`                         |
| 4     | juju-create-backup                      | {ref}`juju create-backup <command-juju-create-backup>`                       |
| 4     | juju-create-storage-pool                | {ref}`juju create-storage-pool <command-juju-create-storage-pool>`                 |
| 4     | juju-credentials                        | {ref}`juju credentials <command-juju-credentials>`                         |
| 4     | juju-dashboard                          | {ref}`juju dashboard <command-juju-dashboard>`                           |
| 4     | juju-debug-code                         | {ref}`juju debug-code <command-juju-debug-code>`                          |
| 4     | juju-debug-hook                         | {ref}`juju debug-hook <command-juju-debug-hook>`                          |
| 4     | juju-debug-hooks                        | {ref}`juju debug-hooks <command-juju-debug-hooks>`                         |
| 4     | juju-debug-log                          | {ref}`juju debug-log <command-juju-debug-log>`                           |
| 4     | juju-default-credential                 | {ref}`juju default-credential <command-juju-default-credential>`                  |
| 4     | juju-default-region                     | {ref}`juju default-region <command-juju-default-region>`                      |
| 4     | juju-deploy                             | {ref}`juju deploy <command-juju-deploy>`                              |
| 4     | juju-destroy-controller                 | {ref}`juju destroy-controller <command-juju-destroy-controller>`                  |
| 4     | juju-destroy-model                      | {ref}`juju destroy-model <command-juju-destroy-model>`                       |
| 4     | juju-detach-storage                     | {ref}`juju detach-storage <command-juju-detach-storage>`                      |
| 4     | juju-diff-bundle                        | {ref}`juju diff-bundle <command-juju-diff-bundle>`                         |
| 4     | juju-disable-command                    | {ref}`juju disable-command <command-juju-disable-command>`                     |
| 4     | juju-disable-user                       | {ref}`juju disable-user <command-juju-disable-user>`                        |
| 4     | juju-disabled-commands                  | {ref}`juju disabled-commands <command-juju-disabled-commands>`                   |
| 4     | juju-documentation                      | {ref}`juju documentation <command-juju-documentation>`                       |
| 4     | juju-download                           | {ref}`juju download <command-juju-download>`                            |
| 4     | juju-download-backup                    | {ref}`juju download-backup <command-juju-download-backup>`                     |
| 4     | juju-enable-command                     | {ref}`juju enable-command <command-juju-enable-command>`                      |
| 4     | juju-enable-destroy-controlle           | {ref}`juju enable-destroy-controller <command-juju-enable-destroy-controller>`           |
| 4     | juju-enable-ha                          | {ref}`juju enable-ha <command-juju-enable-ha>`                           |
| 4     | juju-enable-user                        | {ref}`juju enable-user <command-juju-enable-user>`                         |
| 4     | juju-exec                               | {ref}`juju exec <command-juju-exec>`                                |
| 4     | juju-export-bundle                      | {ref}`juju export-bundle <command-juju-export-bundle>`                       |
| 4     | juju-expose                             | {ref}`juju expose <command-juju-expose>`                              |
| 4     | juju-find                               | {ref}`juju find <command-juju-find>`                                |
| 4     | juju-find-offers                        | {ref}`juju find-offers <command-juju-find-offers>`                         |
| 4     | juju-firewall-rules                     | {ref}`juju firewall-rules <command-juju-firewall-rules>`                      |
| 4     | juju-grant                              | {ref}`juju grant <command-juju-grant>`                               |
| 4     | juju-grant-cloud                        | {ref}`juju grant-cloud <command-juju-grant-cloud>`                         |
| 4     | juju-grant-secret                       | {ref}`juju grant-secret <command-juju-grant-secret>`                        |
| 4     | juju-help                               | {ref}`juju help <command-juju-help>`                                 |
| 4     | juju-help-tool                          | {ref}`juju help-tool <command-juju-help-tool>`                           |
| 4     | juju-import-filesystem                  | {ref}`juju import-filesystem <command-juju-import-filesystem>`                   |
| 4     | juju-import-ssh-key                     | {ref}`juju import-ssh-key <command-juju-import-ssh-key>`                      |
| 4     | juju-info                               | {ref}`juju info <command-juju-info>`                                |
| 4     | juju-integrate                          | {ref}`juju integrate <command-juju-integrate>`                           |
| 4     | juju-kill-controller                    | {ref}`juju kill-controller <command-juju-kill-controller>`                     |
| 4     | juju-list-actions                       | {ref}`juju list-actions <command-juju-list-actions>`                        |
| 4     | juju-list-agreements                    | {ref}`juju list-agreements <command-juju-list-agreements>`                     |
| 4     | juju-list-charm-resources               | {ref}`juju list-charm-resources <command-juju-list-charm-resources>`                |
| 4     | juju-list-clouds                        | {ref}`juju list-clouds <command-juju-list-clouds>`                         |
| 4     | juju-list-controllers                   | {ref}`juju list-controllers <command-juju-list-controllers>`                    |
| 4     | juju-list-credentials                   | {ref}`juju list-credentials <command-juju-list-credentials>`                    |
| 4     | juju-list-disabled-commands             | {ref}`juju list-disabled-commands <command-juju-list-disabled-commands>`              |
| 4     | juju-list-firewall-rules                | {ref}`juju list-firewall-rules <command-juju-list-firewall-rules>`                 |
| 4     | juju-list-machines                      | {ref}`juju list-machines <command-juju-list-machines>`                       |
| 4     | juju-list-models                        | {ref}`juju list-models <command-juju-list-models>`                         |
| 4     | juju-list-offers                        | {ref}`juju list-offers <command-juju-list-offers>`                         |
| 4     | juju-list-operations                    | {ref}`juju list-operations <command-juju-list-operations>`                     |
| 4     | juju-list-payloads                      | {ref}`juju list-payloads <command-juju-list-payloads>`                       |
| 4     | juju-list-regions                       | {ref}`juju list-regions <command-juju-list-regions>`                        |
| 4     | juju-list-resources                     | {ref}`juju list-resources <command-juju-list-resources>`                      |
| 4     | juju-list-secret-backends               | {ref}`juju list-secret-backends <command-juju-list-secret-backends>`                |
| 4     | juju-list-secrets                       | {ref}`juju list-secrets <command-juju-list-secrets>`                        |
| 4     | juju-list-spaces                        | {ref}`juju list-spaces <command-juju-list-spaces>`                         |
| 4     | juju-list-ssh-keys                      | {ref}`juju list-ssh-keys <command-juju-list-ssh-keys>`                       |
| 4     | juju-list-storage                       | {ref}`juju list-storage <command-juju-list-storage>`                        |
| 4     | juju-list-storage-pools                 | {ref}`juju list-storage-pools <command-juju-list-storage-pools>`                  |
| 4     | juju-list-subnets                       | {ref}`juju list-subnets <command-juju-list-subnets>`                        |
| 4     | juju-list-users                         | {ref}`juju list-users <command-juju-list-users>`                          |
| 4     | juju-login                              | {ref}`juju login <command-juju-login>`                               |
| 4     | juju-logout                             | {ref}`juju logout <command-juju-logout>`                              |
| 4     | juju-machines                           | {ref}`juju machines <command-juju-machines>`                            |
| 4     | juju-metrics                            | {ref}`juju metrics <command-juju-metrics>`                             |
| 4     | juju-migrate                            | {ref}`juju migrate <command-juju-migrate>`                             |
| 4     | juju-model-config                       | {ref}`juju model-config <command-juju-model-config>`                        |
| 4     | juju-model-constraints                  | {ref}`juju model-constraints <command-juju-model-constraints>`                   |
| 4     | juju-model-default                      | {ref}`juju model-default <command-juju-model-default>`                       |
| 4     | juju-model-defaults                     | {ref}`juju model-defaults <command-juju-model-defaults>`                      |
| 4     | juju-models                             | {ref}`juju models <command-juju-models>`                              |
| 4     | juju-move-to-space                      | {ref}`juju move-to-space <command-juju-move-to-space>`                       |
| 4     | juju-offer                              | {ref}`juju offer <command-juju-offer>`                               |
| 4     | juju-offers                             | {ref}`juju offers <command-juju-offers>`                              |
| 4     | juju-operations                         | {ref}`juju operations <command-juju-operations>`                          |
| 4     | juju-payloads                           | {ref}`juju payloads <command-juju-payloads>`                            |
| 4     | juju-refresh                            | {ref}`juju refresh <command-juju-refresh>`                             |
| 4     | juju-regions                            | {ref}`juju regions <command-juju-regions>`                             |
| 4     | juju-register                           | {ref}`juju register <command-juju-register>`                            |
| 4     | juju-relate                             | {ref}`juju relate <command-juju-relate>`                              |
| 4     | juju-reload-spaces                      | {ref}`juju reload-spaces <command-juju-reload-spaces>`                       |
| 4     | juju-remove-application                 | {ref}`juju remove-application <command-juju-remove-application>`                  |
| 4     | juju-remove-cloud                       | {ref}`juju remove-cloud <command-juju-remove-cloud>`                        |
| 4     | juju-remove-credential                  | {ref}`juju remove-credential <command-juju-remove-credential>`                   |
| 4     | juju-remove-k8s                         | {ref}`juju remove-k8s <command-juju-remove-k8s>`                          |
| 4     | juju-remove-machine                     | {ref}`juju remove-machine <command-juju-remove-machine>`                      |
| 4     | juju-remove-offer                       | {ref}`juju remove-offer <command-juju-remove-offer>`                        |
| 4     | juju-remove-relation                    | {ref}`juju remove-relation <command-juju-remove-relation>`                     |
| 4     | juju-remove-saas                        | {ref}`juju remove-saas <command-juju-remove-saas>`                         |
| 4     | juju-remove-secret                      | {ref}`juju remove-secret <command-juju-remove-secret>`                       |
| 4     | juju-remove-secret-backend              | {ref}`juju remove-secret-backend <command-juju-remove-secret-backend>`               |
| 4     | juju-remove-space                       | {ref}`juju remove-space <command-juju-remove-space>`                        |
| 4     | juju-remove-ssh-key                     | {ref}`juju remove-ssh-key <command-juju-remove-ssh-key>`                      |
| 4     | juju-remove-storage                     | {ref}`juju remove-storage <command-juju-remove-storage>`                      |
| 4     | juju-remove-storage-pool                | {ref}`juju remove-storage-pool <command-juju-remove-storage-pool>`                 |
| 4     | juju-remove-unit                        | {ref}`juju remove-unit <command-juju-remove-unit>`                         |
| 4     | juju-remove-user                        | {ref}`juju remove-user <command-juju-remove-user>`                         |
| 4     | juju-rename-space                       | {ref}`juju rename-space <command-juju-rename-space>`                        |
| 4     | juju-resolve                            | {ref}`juju resolve <command-juju-resolve>`                             |
| 4     | juju-resolved                           | {ref}`juju resolved <command-juju-resolved>`                            |
| 4     | juju-resources                          | {ref}`juju resources <command-juju-resources>`                           |
| 4     | juju-resume-relation                    | {ref}`juju resume-relation <command-juju-resume-relation>`                     |
| 4     | juju-retry-provisioning                 | {ref}`juju retry-provisioning <command-juju-retry-provisioning>`                  |
| 4     | juju-revoke                             | {ref}`juju revoke <command-juju-revoke>`                              |
| 4     | juju-revoke-cloud                       | {ref}`juju revoke-cloud <command-juju-revoke-cloud>`                        |
| 4     | juju-revoke-secret                      | {ref}`juju revoke-secret <command-juju-revoke-secret>`                       |
| 4     | juju-run                                | {ref}`juju run <command-juju-run>`                                 |
| 4     | juju-scale-application                  | {ref}`juju scale-application <command-juju-scale-application>`                   |
| 4     | juju-scp                                | {ref}`juju scp <command-juju-scp>`                                 |
| 4     | juju-secret-backends                    | {ref}`juju secret-backends <command-juju-secret-backends>`                     |
| 4     | juju-secrets                            | {ref}`juju secrets <command-juju-secrets>`                             |
| 4     | juju-set-application-base               | {ref}`juju set-application-base <command-juju-set-application-base>`                |
| 4     | juju-set-constraints                    | {ref}`juju set-constraints <command-juju-set-constraints>`                     |
| 4     | juju-set-credential                     | {ref}`juju set-credential <command-juju-set-credential>`                      |
| 4     | juju-set-default-credentials            | {ref}`juju set-default-credentials <command-juju-set-default-credentials>`             |
| 4     | juju-set-default-region                 | {ref}`juju set-default-region <command-juju-set-default-region>`                  |
| 4     | juju-set-firewall-rule                  | {ref}`juju set-firewall-rule <command-juju-set-firewall-rule>`                   |
| 4     | juju-set-meter-status                   | {ref}`juju set-meter-status <command-juju-set-meter-status>`                    |
| 4     | juju-set-model-constraints              | {ref}`juju set-model-constraints <command-juju-set-model-constraints>`               |
| 4     | juju-show-action                        | {ref}`juju show-action <command-juju-show-action>`                         |
| 4     | juju-show-application                   | {ref}`juju show-application <command-juju-show-application>`                    |
| 4     | juju-show-cloud                         | {ref}`juju show-cloud <command-juju-show-cloud>`                          |
| 4     | juju-show-controller                    | {ref}`juju show-controller <command-juju-show-controller>`                     |
| 4     | juju-show-credential                    | {ref}`juju show-credential <command-juju-show-credential>`                     |
| 4     | juju-show-credentials                   | {ref}`juju show-credentials <command-juju-show-credentials>`                    |
| 4     | juju-show-machine                       | {ref}`juju show-machine <command-juju-show-machine>`                        |
| 4     | juju-show-model                         | {ref}`juju show-model <command-juju-show-model>`                          |
| 4     | juju-show-offer                         | {ref}`juju show-offer <command-juju-show-offer>`                          |
| 4     | juju-show-operation                     | {ref}`juju show-operation <command-juju-show-operation>`                      |
| 4     | juju-show-secret                        | {ref}`juju show-secret <command-juju-show-secret>`                         |
| 4     | juju-show-secret-backend                | {ref}`juju show-secret-backend <command-juju-show-secret-backend>`                 |
| 4     | juju-show-space                         | {ref}`juju show-space <command-juju-show-space>`                          |
| 4     | juju-show-status-log                    | {ref}`juju show-status-log <command-juju-show-status-log>`                     |
| 4     | juju-show-storage                       | {ref}`juju show-storage <command-juju-show-storage>`                        |
| 4     | juju-show-task                          | {ref}`juju show-task <command-juju-show-task>`                           |
| 4     | juju-show-unit                          | {ref}`juju show-unit <command-juju-show-unit>`                           |
| 4     | juju-show-user                          | {ref}`juju show-user <command-juju-show-user>`                           |
| 4     | juju-spaces                             | {ref}`juju spaces <command-juju-spaces>`                              |
| 4     | juju-ssh                                | {ref}`juju ssh <command-juju-ssh>`                                 |
| 4     | juju-ssh-keys                           | {ref}`juju ssh-keys <command-juju-ssh-keys>`                            |
| 4     | juju-status                             | {ref}`juju status <command-juju-status>`                              |
| 4     | juju-storage                            | {ref}`juju storage <command-juju-storage>`                             |
| 4     | juju-storage-pools                      | {ref}`juju storage-pools <command-juju-storage-pools>`                       |
| 4     | juju-subnets                            | {ref}`juju subnets <command-juju-subnets>`                             |
| 4     | juju-suspend-relation                   | {ref}`juju suspend-relation <command-juju-suspend-relation>`                    |
| 4     | juju-switch                             | {ref}`juju switch <command-juju-switch>`                              |
| 4     | juju-sync-agent-binary                  | {ref}`juju sync-agent-binary <command-juju-sync-agent-binary>`                   |
| 4     | juju-trust                              | {ref}`juju trust <command-juju-trust>`                               |
| 4     | juju-unexpose                           | {ref}`juju unexpose <command-juju-unexpose>`                            |
| 4     | juju-unregister                         | {ref}`juju unregister <command-juju-unregister>`                          |
| 4     | juju-update-cloud                       | {ref}`juju update-cloud <command-juju-update-cloud>`                        |
| 4     | juju-update-credential                  | {ref}`juju update-credential <command-juju-update-credential>`                   |
| 4     | juju-update-credentials                 | {ref}`juju update-credentials <command-juju-update-credentials>`                  |
| 4     | juju-update-k8s                         | {ref}`juju update-k8s <command-juju-update-k8s>`                          |
| 4     | juju-update-public-clouds               | {ref}`juju update-public-clouds <command-juju-update-public-clouds>`                |
| 4     | juju-update-secret                      | {ref}`juju update-secret <command-juju-update-secret>`                       |
| 4     | juju-update-secret-backend              | {ref}`juju update-secret-backend <command-juju-update-secret-backend>`               |
| 4     | juju-update-storage-pool                | {ref}`juju update-storage-pool <command-juju-update-storage-pool>`                 |
| 4     | juju-upgrade-controller                 | {ref}`juju upgrade-controller <command-juju-upgrade-controller>`                  |
| 4     | juju-upgrade-machine                    | {ref}`juju upgrade-machine <command-juju-upgrade-machine>`                     |
| 4     | juju-upgrade-model                      | {ref}`juju upgrade-model <command-juju-upgrade-model>`                       |
| 4     | juju-users                              | {ref}`juju users <command-juju-users>`                               |
| 4     | juju-wait-for                           | {ref}`juju wait-for <command-juju-wait-for>`                            |
| 4     | juju-wait-for-application               | {ref}`juju wait-for application <command-juju-wait-for-application>`                |
| 4     | juju-wait-for-machine                   | {ref}`juju wait-for machine <command-juju-wait-for-machine>`                    |
| 4     | juju-wait-for-model                     | {ref}`juju wait-for model <command-juju-wait-for-model>`                      |
| 4     | juju-wait-for-unit                      | {ref}`juju wait-for unit <command-juju-wait-for-unit>`                       |
| 4     | juju-whoami                             | {ref}`juju whoami <command-juju-whoami>`                              |
| 3     | environment-variables                   | {ref}``juju` environment variables <juju-environment-variables>`              |
| 2     | the-juju-dashboard                      | {ref}``juju-dashboard` (the Juju dashboard) <the-juju-dashboard>`     |
| 2     | the-juju-web-cli                        | {ref}``juju` web CLI <the-juju-web-cli>`                            |
| 2     | jujuc-binary                            | {ref}``jujuc` (binary) <binary-jujuc>`                         |
| 2     | jujud-binary                            | {ref}``jujud` (binary) <binary-jujud>`                          |
| 2     | leader                                  | {ref}`Leader <leader>`                                    |
| 2     | log                                     | {ref}`Log <log>`                                       |
| 2     | machine                                 | {ref}`Machine <machine>`                                   |
| 2     | metric                                  | {ref}`Metric <metric>`                                    |
| 2     | model                                   | {ref}`Model <model>`                                     |
| 2     | offer                                   | {ref}`Offer <offer>`                                    |
| 2     | operation                               | {ref}`Operation (script execution) <operation>`              |
| 2     | placement-directive                     | {ref}`Placement directive <placement-directive>`                       |
| 2     | plugins                                 | {ref}`Plugin <plugin>`                                    |
| 3     | list-of-known-plugins                   | {ref}`List of known plugins <list-of-known-juju-plugins>`                     |
| 4     | juju-metadata                           | {ref}`juju-metadata <plugin-juju-metadata>`                             |
| 4     | juju-stash                              | {ref}`juju-stash <juju-stash>`                                |
| 3     | plugin-flags                            | {ref}`Plugin flags <plugin-flags>`                              |
| 2     | python-libjuju-client                   | {ref}``python-libjuju` (Juju client) <python-libjuju-juju-client>`           |
| 2     | removing-things                         | {ref}`Removing things <removing-things>`                           |
| 2     | relation                                | {ref}`Relation (integration) <relation-integration>`                    |
| 2     | charm-resource                          | {ref}`Resource (charm) <resource-charm>`                         |
| 2     | scaling                                 | {ref}`Scaling <scaling>`                                  |
| 2     | secret                                  | {ref}`Secret <secret>`                                    |
| 3     | secret-backend                          | {ref}`Secret backend <secret-backend>`                            |
| 2     | network-spaces                          | {ref}`Space <space>`                                     |
| 2     | ssh-key                                 | {ref}`SSH key <ssh-key>`                                   |
| 2     | status                                  | {ref}`Status <status>`                                    |
| 2     | storage                                 | {ref}`Storage <storage>`                                   |
| 3     | storage-constraint                      | {ref}`Storage constraint <storage-constraint-directive>`                        |
| 3     | storage-pool                            | {ref}`Storage pool <storage-pool>`                              |
| 3     | storage-provider                        | {ref}`Storage provider <storage-provider>`                          |
| 3     | dynamic-storage                         | {ref}`Dynamic storage <dynamic-storage>`                           |
| 3     | storage-support                         | {ref}`Storage support <storage-support>`                            |
| 2     | subnet                                  | {ref}`Subnet <subnet>`                                    |
| 2     | task                                    | {ref}`Task (script execution) <task>`                   |
| 2     | telemetry-and-juju                      | {ref}`Telemetry <telemetry>`                                 |
| 2     | terraform-juju-client                   | {ref}``terraform` CLI (Juju client) <terraform-juju-juju-client>`            |
| 2     | unit                                    | {ref}`Unit <unit>`                                      |
| 2     | upgrading                               | {ref}`Upgrading things <upgrading-things>`                          |
| 2     | user                                    | {ref}`User <user>`                                      |
| 3     | user-permissions                        | {ref}`User access levels <user-access-levels>`                        |
| 2     | worker                                  | {ref}`Worker <worker>`                                   |
| 2     | availability-zone                       | {ref}`Zone <zone>`                                      |
| 1     | explanation                             | {ref}`Explanation <juju-explanation>`                               |
| 2     | application-modelling                   | {ref}`Application modelling <about-application-modelling>`                     |
| 2     | juju-performance                        | {ref}`Performance with Juju <performance-with-juju>`                    |
| 2     | security-with-juju                      | {ref}`Security with Juju <juju-security>`                       |
| 2     | kubernetes-in-juju                      | {ref}`Kubernetes in Juju <kubernetes-in-juju>`                       |
|       | logfile-varlogjujumachine-locklog       | {ref}`Logfile: /var/log/juju/machine-lock.log <logfile-varlogjujumachine-locklog>`    |

```																				   
																						   
## Redirects																			   
																						   
```{dropdown} Mapping table
																	   
| Location                                                                            | Path                                                                                   |
|-------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| /docs/juju/manage-relations                                                         | /docs/juju/relations                                                                   |
| /docs/juju/manage-controllers                                                       | /docs/juju/controllers                                                                 |
| /docs/juju/manage-clouds                                                            | /docs/juju/clouds                                                                      |
| /docs/juju/manage-models                                                            | /docs/juju/models                                                                      |
| /docs/juju/the-juju-web-cli                                                         | /docs/juju/using-the-juju-web-cli                                                      |
| /docs/juju/the-juju-dashboard                                                       | /docs/juju/using-the-dashboard                                                         |
| /docs/juju/constraints                                                              | /docs/juju/about-constraints                                                           |
| /docs/juju/user-types-and-abilities                                                 | /docs/juju/about-user-types-and-abilities                                              |
| /docs/juju/manage-the-client                                                        | /docs/juju/upgrading-client                                                            |
| /docs/juju/migrate-a-model                                                          | /docs/juju/migrating-models                                                            |
| /docs/juju/configure-a-model                                                        | /docs/juju/configuring-models                                                          |
| /docs/juju/additional-how-to-guides                                                 | /docs/juju/other-tutorials                                                             |
| /docs/sdk                                                                           | /t/charm-bundles/1058                                                                  |
| /docs/sdk                                                                           | /t/juju-resources/1074                                                                 |
| /docs/sdk                                                                           | /t/writing-a-kubernetes-v1-charm-updated/3976                                          |
| /docs/sdk                                                                           | /t/charm-writing/1260                                                                  |
| /docs/sdk                                                                           | /t/tools/1181                                                                          |
| /docs/sdk                                                                           | /t/hook-tools/1163                                                                     |
| /docs/sdk                                                                           | /t/charm-metadata/1043                                                                 |
| /docs/sdk                                                                           | /t/bundle-reference/1158                                                               |
| /t/advanced-application-deployment                                                  | /t/deploying-advanced-applications                                                     |
| http://discourse.charmhub.io/                                                       | /docs/juju/community-help                                                              |
| http://discourse.charmhub.io/                                                       | /docs/contact-us                                                                       |
| http://discourse.charmhub.io/                                                       | /docs/juju/community-help                                                              |
| /docs/juju/accessing-the-dashboard                                                  | /docs/juju/accessing-juju’s-web-interface                                              |
| /docs/juju/basic-concepts                                                           | /docs/juju/reference                                                                   |
| /docs/juju/quick-reference                                                          | /docs/juju/reference                                                                   |
| /docs/juju/glossary                                                                 | /docs/juju/reference                                                                   |
| /docs/juju/deploying-applications                                                   | /docs/juju/manage-applications/                                                        |
| /t/5458                                                                             | /t/1158                                                                                |
| /docs/juju/get-started-on-a-localhost                                               | /docs/juju/tutorial                                                                    |
| /docs/juju/get-started-on-kubernetes                                                | /docs/juju/tutorial                                                                    |
| /docs/juju/add-a-relation                                                           | /docs/juju/manage-same-model-relations                                                 |
| /docs/juju/remove-a-relation                                                        | /docs/juju/manage-same-model-relations                                                 |
| /docs/juju/cross-model-relations                                                    | /docs/juju/manage-cross-model-relations                                                |
| /docs/juju/juju-update-clouds                                                       | /docs/juju/juju-update-cloud                                                           |
| /docs/juju/working-with-multiple-users                                              | /docs/juju/manage-users                                                                |
| /docs/juju/applications-and-charmed-operators                                       | /docs/juju/applications                                                                |
| /docs/juju/deploy-charms-offline                                                    | /docs/juju/manage-applications                                                         |
| /docs/juju/juju-sync-agent-binaries                                                 | /docs/juju/juju-sync-agent-binary                                                      |
| /docs/juju/list-of-available-plugins                                                | /docs/juju/list-of-known-plugins                                                       |
| /docs/juju/plugins-wait-for                                                         | /docs/juju/juju-wait-for                                                               |
| /docs/juju/configure-a-controller#heading--excluding-information-from-the-audit-log | /docs/juju/audit-log-exclude-methods                                                   |
| /docs/juju/defining-and-using-persistent-storage                                    | /docs/juju/manage-storage                                                              |
| /docs/juju/remove-storage                                                           | /docs/juju/manage-storage                                                              |
| /docs/juju/juju-show-units                                                          | /docs/juju/juju-show-unit                                                              |
| /docs/juju/remove-units                                                             | /docs/juju/manage-units                                                                |
| /docs/juju/working-with-actions                                                     | /docs/juju/manage-actions                                                              |
| /docs/juju/juju-add-subnet                                                          | /docs/juju/add-unit                                                                    |
| /docs/juju/commands                                                                 | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-add-relation                                                        | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-add-subnet                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-budget                                                              | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-cached-images                                                       | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-cancel-action                                                       | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-create-wallet                                                       | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-get-constraints                                                     | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-get-model-constraints                                               | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-gui                                                                 | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-hook-tool                                                           | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-hook-tools                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-list-cached-images                                                  | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-list-plans                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-plans                                                               | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-remove-cached-images                                                | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-run-action                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-set-plan                                                            | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-set-series                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-set-wallet                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-show-action-output                                                  | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-show-action-status                                                  | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-show-status                                                         | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-show-wallet                                                         | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-sla                                                                 | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-sync-tools                                                          | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-upgrade-charm                                                       | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-upgrade-dashboard                                                   | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-upgrade-gui                                                         | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-upgrade-series                                                      | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-wallets                                                             | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-attach                                                              | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-charm                                                               | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-remove-consumed-application                                         | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/juju-upgrade-juju                                                        | /docs/juju/juju-cli-commands                                                           |
| /docs/juju/manage-relations                                                         | /docs/juju/manage-integrations                                                         |
| /docs/juju/manage-same-model-relations                                              | /docs/juju/manage-same-model-integrations                                              |
| /docs/juju/manage-cross-model-relations                                             | /docs/juju/manage-cross-model-integrations                                             |
| /docs/juju/relations                                                                | /docs/juju/integration                                                                 |
| /docs/juju cross-model-relation                                                     | /docs/juju cross-model-integration                                                     |
| /docs/juju/install-snaps-offline                                                    | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/manage-the-client                                                        | /docs/juju/manage-juju                                                                 |
| /docs/juju/installing-juju                                                          | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/use-the-client                                                           | /docs/juju/use-juju                                                                    |
| /docs/juju/back-up-the-juju-client                                                  | /docs/juju/back-up-juju                                                                |
| /docs/juju/upgrade-the-juju-client                                                  | /docs/juju/upgrade-juju                                                                |
| /docs/juju/accessing-individual-machines-with-ssh                                   | /docs/juju/manage-machines                                                             |
| /docs/juju/set-constraints-for-a-machine                                            | /docs/juju/manage-machines                                                             |
| /docs/juju/upgrade-a-machines-series                                                | /docs/juju/manage-machines                                                             |
| /docs/juju/remove-a-machine                                                         | /docs/juju/manage-machines                                                             |
| /docs/juju/juju-set-default-credential                                              | /docs/juju/juju-set-default-credentials                                                |
| /docs/juju/upgrade-the-dashboard                                                    | /docs/juju/manage-the-juju-dashboard                                                   |
| /docs/juju/accessing-the-dashboard                                                  | /docs/juju/manage-the-juju-dashboard                                                   |
| /docs/juju/restore-a-controller-from-a-backup                                       | /docs/juju/controller-backups                                                          |
| /docs/juju/manage-constraints                                                       | /docs/juju/constraint                                                                  |
| /docs/juju/constraints                                                              | /docs/juju/constraint                                                                  |
| /docs/juju/controllers                                                              | /docs/juju/controller                                                                  |
| /docs/juju/credentials                                                              | /docs/juju/credential                                                                  |
| /docs/juju/endpoints                                                                | /docs/juju/endpoint                                                                    |
| /docs/juju/agents                                                                   | /docs/juju/agent                                                                       |
| /docs/juju/bundles                                                                  | /docs/juju/bundle                                                                      |
| /docs/juju/clouds                                                                   | /docs/juju/cloud                                                                       |
| /docs/juju/leaders                                                                  | /docs/juju/leader                                                                      |
| /docs/juju/machines                                                                 | /docs/juju/machine                                                                     |
| /docs/juju/models                                                                   | /docs/juju/model                                                                       |
| /docs/juju/units                                                                    | /docs/juju/unit                                                                        |
| /docs/juju/create-a-controller                                                      | /docs/juju/manage-controllers                                                          |
| /docs/juju/configure-a-controller                                                   | /docs/juju/manage-controllers                                                          |
| /docs/juju/set-constraints-for-a-controller                                         | /docs/juju/manage-controllers                                                          |
| /docs/juju/controller-backups                                                       | /docs/juju/manage-controllers                                                          |
| /docs/juju/high-availability-juju-controller                                        | /docs/juju/manage-controllers                                                          |
| /docs/juju/remove-a-controller                                                      | /docs/juju/manage-controllers                                                          |
| /docs/juju/applications                                                             | /docs/juju/application                                                                 |
| /docs/juju/add-a-model                                                              | /docs/juju/manage-models                                                               |
| /docs/juju/get-information-about-a-model                                            | /docs/juju/manage-models                                                               |
| /docs/juju/configure-a-model                                                        | /docs/juju/manage-models                                                               |
| /docs/juju/set-constraints-for-a-model                                              | /docs/juju/manage-models                                                               |
| /docs/juju/switch-to-a-different-model                                              | /docs/juju/manage-models                                                               |
| /docs/juju/migrate-a-model                                                          | /docs/juju/manage-models                                                               |
| /docs/juju/upgrade-models                                                           | /docs/juju/manage-models                                                               |
| /docs/juju/remove-a-model                                                           | /docs/juju/manage-models                                                               |
| /docs/juju/disabling-commands                                                       | /docs/juju/manage-models                                                               |
| /docs/juju/monitor-elasticsearch-with-elasticsearch-and-kibana                      | /docs/juju/how-to                                                                      |
| /docs/juju/additional-how-to-guides                                                 | /docs/juju/how-to                                                                      |
| /docs/juju/deploy-postgres-on-ubuntu-server                                         | /docs/juju/how-to                                                                      |
| /docs/juju/deploy-rabbitmq-cluster-on-ubuntu-server                                 | /docs/juju/how-to                                                                      |
| /docs/juju/get-started-charmed-kubernetes                                           | /docs/juju/how-to                                                                      |
| /docs/juju/using-gitlab-as-a-container-registry                                     | /docs/juju/how-to                                                                      |
| /docs/juju/streaming-hadoop-analysis                                                | /docs/juju/how-to                                                                      |
| /docs/juju/charmed-kubernetes-kata-containers                                       | /docs/juju/how-to                                                                      |
| /docs/juju/get-started-hadoop-spark                                                 | /docs/juju/how-to                                                                      |
| /docs/juju/kubeapps-on-canonical-kubernetes                                         | /docs/juju/how-to                                                                      |
| /docs/juju/deploying-storageos-on-kubernetes                                        | /docs/juju/how-to                                                                      |
| /docs/juju/charmed-osm-get-started                                                  | /docs/juju/how-to                                                                      |
| /docs/juju/lma-light                                                                | /docs/juju/how-to                                                                      |
| /docs/juju/deploy-a-charm-from-charmhub                                             | /docs/juju/manage-applications                                                         |
| /docs/juju/deploy-an-application-from-a-local-charm                                 | /docs/juju/manage-applications                                                         |
| /docs/juju/deploy-to-a-lxd-container                                                | /docs/juju/manage-applications                                                         |
| /docs/juju/deploy-an-application-with-a-specific-series                             | /docs/juju/manage-applications                                                         |
| /docs/juju/deploy-to-a-specific-machine                                             | /docs/juju/manage-applications                                                         |
| /docs/juju/deploy-to-a-specific-availability-zone                                   | /docs/juju/manage-applications                                                         |
| /docs/juju/deploy-to-a-network-space                                                | /docs/juju/manage-applications                                                         |
| /docs/juju/trust-an-application-with-a-credential                                   | /docs/juju/manage-applications                                                         |
| /docs/juju/expose-a-deployed-application                                            | /docs/juju/manage-applications                                                         |
| /docs/juju/configure-an-application                                                 | /docs/juju/manage-applications                                                         |
| /docs/juju/set-constraints-for-an-application                                       | /docs/juju/manage-applications                                                         |
| /docs/juju/scale-an-application                                                     | /docs/juju/manage-applications                                                         |
| /docs/juju/upgrade-applications                                                     | /docs/juju/manage-applications                                                         |
| /docs/juju/remove-an-application                                                    | /docs/juju/manage-applications                                                         |
| /docs/juju/debug-charm-hooks                                                        | [https://juju.is/docs/sdk/debug-a-charm](https://juju.is/docs/sdk/debug-a-charm)       |
| /docs/juju/test                                                                     | /docs/sdk/debug-a-charm                                                                |
| /docs/juju/juju-logs                                                                | /docs/juju/log                                                                         |
| /docs/juju/adding-clouds                                                            | /docs/juju/manage-clouds                                                               |
| /docs/juju/view-the-available-clouds                                                | /docs/juju/manage-clouds                                                               |
| /docs/juju/view-the-available-cloud-regions                                         | /docs/juju/manage-clouds                                                               |
| /docs/juju/change-the-default-region-for-a-cloud                                    | /docs/juju/manage-clouds                                                               |
| /docs/juju/view-detailed-information-about-a-cloud                                  | /docs/juju/manage-clouds                                                               |
| /docs/juju/update-the-definition-of-a-cloud                                         | /docs/juju/manage-clouds                                                               |
| /docs/juju/remove-a-cloud                                                           | /docs/juju/manage-clouds                                                               |
| /docs/juju/charmed-operators                                                        | /docs/juju/charmed-operator                                                            |
| /docs/juju/user-types-and-abilities                                                 | /docs/juju/user                                                                        |
| /docs/juju/add-credentials                                                          | /docs/juju/manage-credentials                                                          |
| /docs/juju/list-credentials                                                         | /docs/juju/manage-credentials                                                          |
| /docs/juju/set-the-default-credential-for-a-cloud                                   | /docs/juju/manage-credentials                                                          |
| /docs/juju/relate-a-credential-to-a-model                                           | /docs/juju/manage-credentials                                                          |
| /docs/juju/query-a-credential-related-to-a-model                                    | /docs/juju/manage-credentials                                                          |
| /docs/juju/update-a-credential                                                      | /docs/juju/manage-credentials                                                          |
| /docs/juju/remove-a-credential                                                      | /docs/juju/manage-credentials                                                          |
| /docs/juju/log-in-to-a-controller                                                   | /docs/juju/manage-users                                                                |
| /docs/juju/remove-a-user-from-a-controller                                          | /docs/juju/manage-users                                                                |
| /docs/juju/status-values                                                            | /docs/juju/status                                                                      |
| /docs/juju/deployment-of-juju-agents                                                | /docs/juju/deployment                                                                  |
| /docs/juju/agent-version                                                            | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/apt-mirror                                                               | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/automatically-retry-hooks                                                | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/cloudinit-userdata                                                       | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/container-inherit-properties                                             | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/disable-network-management                                               | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/enable-os-refresh-update                                                 | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/enable-os-upgrade                                                        | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/firewall-mode                                                            | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/image-stream                                                             | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/provisioner-harvest-mode                                                 | /docs/juju/list-of-model-configuration-keys                                            |
| /docs/juju/amazon-aws                                                               | /docs/juju/amazon-ec2                                                                  |
| /docs/juju/amazon-elastic-kubernetes-service-(amazon-eks)                           | /docs/juju/amazon-eks                                                                  |
| /docs/juju/google-kubernetes-engine-(gke)                                           | /docs/juju/google-gke                                                                  |
| /docs/juju/azure                                                                    | /docs/juju/microsoft-azure                                                             |
| /docs/juju/azure-kubernetes-service-(azure-aks)                                     | /docs/juju/microsoft-aks                                                               |
| /docs/juju/oracle                                                                   | /docs/juju/oracle-oci                                                                  |
| /docs/juju/manual-setup                                                             | /docs/juju/manual                                                                      |
| /docs/juju/agent-binary                                                             | /docs/juju/jujud-binary                                                                |
| /docs/juju/other-clusters                                                           | /docs/juju/tutorial                                                                    |
| /docs/aws-cloud                                                                     | /docs/juju/amazon-ec2                                                                  |
| /docs/juju/tutorials                                                                | /docs/juju/tutorial                                                                    |
| /docs/juju/get-started-with-juju                                                    | /docs/juju/tutorial                                                                    |
| /docs/juju/use-lxd-clustering                                                       | /docs/juju/lxd                                                                         |
| /docs/juju/manage-a-lxd-cloud                                                       | /docs/juju/lxd                                                                         |
| /docs/juju/use-lxd-profiles                                                         | [https://juju.is/docs/sdk/lxd-profile-yaml](https://juju.is/docs/sdk/lxd-profile-yaml) |
| /docs/juju/control-application-network-ingress                                      | /docs/juju/manage-applications                                                         |
| /docs/juju/manage-same-model-integrations                                           | /docs/juju/manage-integrations                                                         |
| /docs/juju/manage-cross-model-integrations                                          | /docs/juju/manage-offers                                                               |
| /docs/juju/controller-agent                                                         | /docs/juju/agent                                                                       |
| /docs/juju/cross-model-integration                                                  | /docs/juju/relation                                                                    |
| /docs/juju/integration                                                              | /docs/juju/relation                                                                    |
| /docs/juju/manage-integrations                                                      | /docs/juju/manage-relations                                                            |
| /docs/juju/cloud-image-metadata                                                     | /docs/juju/manage-metadata                                                             |
| /docs/juju/install-juju                                                             | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/use-juju                                                                 | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/back-up-juju                                                             | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/upgrade-juju                                                             | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/manage-juju                                                              | /docs/juju/install-and-manage-the-client                                               |
| /docs/juju/the-juju-client                                                          | /docs/juju/juju-client                                                                 |
| /docs/juju/terraform-cli-client                                                     | /docs/juju/terraform-juju-client                                                       |
| /docs/juju/manage-charm-bundles                                                     | /docs/juju/manage-charms                                                               |
| /docs/juju/manage-charms                                                            | /docs/juju/manage-charms-or-bundles                                                    |
| /docs/juju/upgrade-your-juju-deployment-from-2-9-to-3-x                             | /docs/juju/upgrade-your-juju-deployment                                                |
| /docs/juju/collecting-juju-metrics                                                  | /docs/juju/manage-controllers                                                          |
| /docs/juju/juju-security                                                            | /docs/juju/harden-your-deployment                                                      |
| /docs/juju/troubleshooting                                                          | /docs/juju/troubleshoot-your-deployment                                                |
| /docs/juju/troubleshoot-additions                                                   | /docs/juju/troubleshoot-your-deployment                                                |
| /docs/juju/troubleshoot-clouds                                                      | /docs/juju/troubleshoot-your-deployment                                                |
| /docs/juju/working-offline                                                          | /docs/juju/take-your-deployment-offline                                                |
| /docs/juju/use-the-localhost-cloud-offline                                          | /docs/juju/take-your-deployment-offline                                                |
| /docs/juju/configure-juju-for-offline-usage                                         | /docs/juju/take-your-deployment-offline                                                |
| /docs/juju/offline-mode-strategies                                                  | /docs/juju/take-your-deployment-offline                                                |
| /docs/juju/troubleshoot-model-upgrades                                              | /docs/juju/troubleshoot-your-deployment                                                |
| /docs/juju/troubleshoot-removals                                                    | /docs/juju/troubleshoot-your-deployment                                                |
| /docs/juju/juju-version-compatibility-matrix                                        | /docs/juju/cross-version-compatibility-in-juju                                         |
| /docs/juju/agent-introspection-juju-leases                                          | /docs/juju/agent-introspection                                                         |
| /docs/juju/agent-introspection-juju-revoke-lease                                    | /docs/juju/agent-introspection                                                         |

```