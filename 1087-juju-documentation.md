Juju allows you to retain a high-level understanding of all the parts of your system without being bogged down needing to know every hostname, every machine, every subnet and every specification of every storage volume.

Focus on your applications and their relations. Create a development environment on your laptop,  then recreate that environment on the public cloud, onto bare metal servers or into a Kubernetes cluster. 

Maximise your productivity by encapsulating specialist knowledge into Juju charms. They create repeatable, systematic and secure devops practices for all stages of your product's lifecycle. Juju simplifies deployment, maintenance, scaling up and winding down. 

## Getting started

<!--
TODO

[Getting started with JAAS](/t/getting-started-with-jaas/1134)
-->

* [Getting started locally](/t/getting-started-with-juju/1970)
* [Install Juju](/t/installing-juju/1164)
* Learn the [concepts behind Juju](/t/concepts-and-terms/1144)

## Finding help and seeking support

- Ask a question on our [forum](https://discourse.jujucharms.com/)
- Chat to us on [IRC](http://webchat.freenode.net/?channels=%23juju)

## Contribute

- [Help improve Juju](https://github.com/juju/juju)
- [Help improve the documentation](/t/documentation-guidelines/1245)

## Community Links

- [Join a charm sub-community](https://jaas.ai/community)
- Engage a Juju expert to deliver a [managed solution](/docs/managed-solutions/1132)
- Read our [blog posts](https://ubuntu.com/blog/tag/juju)

## Navigation

### Introduction

<!--
- [Home](index.md)
-->

- [Getting started](/t/getting-started-with-juju/1970)
- [Install Juju](/t/installing-juju/1164)
- [Tutorials](/t/tutorials/1197)

### Using Juju
- Bootstrap
  - [Add a cloud](/t/clouds/1100)
  - [Add credentials](/t/credentials/1112)
  - [Create a controller](/t/creating-a-controller/1108)
- Constructing the model
  - [Add constraints](/t/using-constraints/1060)
  - [Deploy applications](/t/deploying-applications/1062)
  - [Increase scale and tailor deployment](/t/deploying-applications-advanced/1061)
  - [Relate applications](/t/managing-relations/1073)
  - [Remove things](/t/removing-things/1063)
- Interacting with the model
  - [Access individual machines](/t/machine-authentication/1146)
  - [Run actions](/t/working-with-actions/1033)
  - [Collect metrics](/t/collecting-juju-metrics/1138)
  - [Accessing Juju's web interface](/t/juju-gui/1109)
- Networking
  - [Fan container networking](/t/fan-container-networking/1065)
  - [Network spaces](/t/network-spaces/1157)
- Storage
  - [Define and use persistent storage](/t/using-juju-storage/1079)
- Troubleshooting
  - [Advanced status output](/t/troubleshooting/1187)
  - [Finding Juju logs](/t/juju-logs/1184)

### Juju Concepts

- Concepts I
  - [Application](/t/applications-and-charms/1034)
  - [Model](/t/models/1155)
  - [Relation](/t/managing-relations/1073)
- Concepts II
  - [Clouds](/t/clouds/1100)
  - [Credentials](/t/credentials/1112)
  - [Controllers](/t/controllers/1111)
  - [Constraints](/t/using-constraints/1060)
  - [High availability](/t/application-high-availability/1066)
  - [More terms](/t/concepts-and-terms/1144)


### Administering Juju

- [Upgrading to a new release](/t/upgrading/1199)
- [Backing up the controller](/t/controller-backups/1106)
- [Running a high-availability controller](/t/controller-high-availability/1110)
- [Working with multiple users](/t/working-with-multiple-users/1156)
- [Working offline](/t/working-offline/1072)
- [Migrating models](/t/migrating-models/1152)
- [Generate your own cloud image metadata](/t/cloud-image-metadata/1137)


### Writing Charms

- [Charm bundles](/t/charm-bundles/1058)
- [Working with resources](/t/juju-resources/1074)
- [Charm writing guide](/t/charm-writing-guide/1260)
- [Software tools for charm writers](/t/tools/1181)


### Reference

- [Glossary](/t/glossary/1949)
- For operators
  -   [Status values and their meanings](/t/charm-unit-status-and-their-meanings/1168)
  -   [Juju constraints](/t/juju-constraints/1160)
  -   [Juju commands](t/commands/1667)
  -   [Environment variables](t/juju-environment-variables/1162) 
- For charm writers and developers
  -   [Juju hook tools](/t/hook-tools/1163)
  -   [metadata.yaml specification](/t/charm-metadata/1043)
  -   [bundle.yaml specification](/t/bundle-reference/1158)
  -   [Internal API docs](http://godoc.org/github.com/juju/juju/api)

### Seeking help

- [Ask on our forum](https://discourse.jujucharms.com/)
- [File a bug](https://bugs.launchpad.net/juju/+filebug)
- [Report a docs issue](https://github.com/juju/docs/issues/new)
- [Further contact details](/t/contact-us/1103)

## URLs

<!--
There is no purpose in putting Release Notes in the mapping table because they point
directly back to Discourse. I'm keeping them here for now.
| https://discourse.jujucharms.com/t/2-4-0-release-notes/1169 | /docs/2-4-0-release-notes |
| https://discourse.jujucharms.com/t/2-4-1-release-notes/1170 | /docs/2-4-1-release-notes |
| https://discourse.jujucharms.com/t/2-4-2-release-notes/1171 | /docs/2-4-2-release-notes |
| https://discourse.jujucharms.com/t/2-4-3-release-notes/1172 | /docs/2-4-3-release-notes |
| https://discourse.jujucharms.com/t/2-4-4-release-notes/1173 | /docs/2-4-4-release-notes |
| https://discourse.jujucharms.com/t/2-4-5-release-notes/1174 | /docs/2-4-5-release-notes |
| https://discourse.jujucharms.com/t/2-4-6-release-notes/1175 | /docs/2-4-6-release-notes |
| https://discourse.jujucharms.com/t/2-4-7-release-notes/1176 | /docs/2-4-7-release-notes |
| https://discourse.jujucharms.com/t/2-5-0-release-notes/1177 | /docs/2-5-0-release-notes |
| https://discourse.jujucharms.com/t/2-5-1-release-notes/1178 | /docs/2-5-1-release-notes |
| https://discourse.jujucharms.com/t/2-5-2-release-notes/1270 | /docs/2-5-2-release-notes |
| https://discourse.jujucharms.com/t/juju-2-5-3-release-notes/1307 | /docs/2-5-3-release-notes |
| https://discourse.jujucharms.com/t/juju-2-5-4-release-notes/1326 | /docs/2-5-4-release-notes |
| https://discourse.jujucharms.com/t/juju-2-5-7-release-notes/1432 | /docs/2-5-7-release-notes |
| https://discourse.jujucharms.com/t/juju-2-6-1-release-notes/1473 | /docs/2-6-1-release-notes |
| https://discourse.jujucharms.com/t/juju-2-6-2-release-notes/1474 | /docs/2-6-2-release-notes |

/t/glossary/1949
-->

[details=Mapping table]
| Topic | Path |
| -- | -- |
| https://discourse.jujucharms.com/t/getting-started-with-juju-on-your-laptop/1970 | /docs/wip-getting-started |
| https://discourse.jujucharms.com/t/glossary/1949 | /docs/glossary |
| https://discourse.jujucharms.com/t/a-multi-user-cloud/1190 | /docs/multi-user-cloud |
| https://discourse.jujucharms.com/t/actions-for-the-charm-author/1113 | /docs/charm-writing/actions |
| https://discourse.jujucharms.com/t/adding-a-model/1147 | /docs/adding-a-model |
| https://discourse.jujucharms.com/t/additional-lxd-resources/1092 | /docs/lxd-resources |
| https://discourse.jujucharms.com/t/appendix-installing-a-gke-cluster/1448 | /docs/appendix-gke |
| https://discourse.jujucharms.com/t/application-configuration/1052 | /docs/charm-writing/application-config |
| https://discourse.jujucharms.com/t/application-groups/1076 | /docs/application-groups |
| https://discourse.jujucharms.com/t/application-high-availability/1066 | /docs/ha-applications |
| https://discourse.jujucharms.com/t/application-metrics/1067 | /docs/metrics-applications |
| https://discourse.jujucharms.com/t/applications-and-charms/1034 | /docs/applications-and-charms |
| https://discourse.jujucharms.com/t/basic-client-usage-tutorial/1191 | /docs/client-usage-tutorial |
| https://discourse.jujucharms.com/t/benchmarking-juju-applications/1036 | /docs/charm-writing/benchmarks |
| https://discourse.jujucharms.com/t/best-practice-for-charm-authors/1037 | /docs/charm-writing/best-practice |
| https://discourse.jujucharms.com/t/bundle-reference/1158 | /docs/bundle-reference |
| https://discourse.jujucharms.com/t/charm-bundles/1058 | /docs/charm-bundles |
| https://discourse.jujucharms.com/t/charm-hooks/1040 | /docs/charm-hooks |
| https://discourse.jujucharms.com/t/charm-layer-yaml-reference/1165 | /docs/charm-layer-yaml-reference |
| https://discourse.jujucharms.com/t/charm-metadata/1043 | /docs/charm-metadata |
| https://discourse.jujucharms.com/t/charm-network-primitives/1126 | /docs/charm-network-primitives |
| https://discourse.jujucharms.com/t/charm-promulgation/1054 | /docs/charm-writing/promulgation |
| https://discourse.jujucharms.com/t/charm-review-process/1055 | /docs/charm-review-process |
| https://discourse.jujucharms.com/t/charm-store-policy/1044 | /docs/charm-store-policy |
| https://discourse.jujucharms.com/t/charm-tools/1180 | /docs/charm-tools |
| https://discourse.jujucharms.com/t/charm-unit-status-and-their-meanings/1168 | /docs/charm-unit-status-and-their-meanings |
| https://discourse.jujucharms.com/t/charm-writing/1260 | /docs/charm-writing |
| https://discourse.jujucharms.com/t/charms-and-mysql-interfaces/1139 | /docs/charms-and-mysql-interfaces |
| https://discourse.jujucharms.com/t/client/1083 | /docs/client |
| https://discourse.jujucharms.com/t/cloud-image-metadata/1137 | /docs/cloud-image-metadata |
| https://discourse.jujucharms.com/t/clouds/1100 | /docs/clouds |
| https://discourse.jujucharms.com/t/cmr-scenario-1/1148 | /docs/cmr-scenario-1 |
| https://discourse.jujucharms.com/t/cmr-scenario-2/1149 | /docs/cmr-scenario-2 |
| https://discourse.jujucharms.com/t/collecting-juju-metrics/1138 | /docs/collecting-juju-metrics |
| https://discourse.jujucharms.com/t/command-changes-from-1-25-to-2-0/1101 | /docs/command-changes-from-1-25-to-2-0 |
| https://discourse.jujucharms.com/t/components-of-a-charm/1038 | /docs/components-of-a-charm |
| https://discourse.jujucharms.com/t/concepts-and-terms/1144 | /docs/concepts-and-terms |
| https://discourse.jujucharms.com/t/configuring-applications/1059 | /docs/configuring-applications |
| https://discourse.jujucharms.com/t/configuring-controllers/1107 | /docs/configuring-controllers |
| https://discourse.jujucharms.com/t/configuring-juju-for-offline-usage/1068 | /docs/configuring-offline-usage |
| https://discourse.jujucharms.com/t/configuring-models/1151 | /docs/configuring-models |
| https://discourse.jujucharms.com/t/contact-us/1103 | /docs/contact-us |
| https://discourse.jujucharms.com/t/controller-backups/1106 | /docs/controller-backups |
| https://discourse.jujucharms.com/t/controller-high-availability/1110 | /docs/controller-high-availability |
| https://discourse.jujucharms.com/t/controller-logins/1389 | /docs/controller-logins |
| https://discourse.jujucharms.com/t/controllers/1111 | /docs/controllers |
| https://discourse.jujucharms.com/t/create-a-google-compute-engine-controller/1189 | /docs/create-a-google-compute-engine-controller |
| https://discourse.jujucharms.com/t/creating-a-controller/1108 | /docs/creating-a-controller |
| https://discourse.jujucharms.com/t/appendix-creating-an-aws-vpc/1064 | /docs/appendix-creating-an-aws-vpc |
| https://discourse.jujucharms.com/t/creating-config-yaml-and-configuring-charms/1039 | /docs/creating-config-yaml-and-configuring-charms |
| https://discourse.jujucharms.com/t/creating-icons-for-charms/1041 | /docs/creating-icons-for-charms |
| https://discourse.jujucharms.com/t/creating-ssh-keypairs-on-windows/1133 | /docs/creating-ssh-keypairs-on-windows |
| https://discourse.jujucharms.com/t/credentials/1112 | /docs/credentials |
| https://discourse.jujucharms.com/t/cross-model-relations/1150 | /docs/cross-model-relations |
| https://discourse.jujucharms.com/t/dealing-with-errors-encountered-by-charm-hooks/1048 | /docs/charm-writing/hook-errors |
| https://discourse.jujucharms.com/t/debugging-building-layers/1115 | /docs/debugging-building-layers |
| https://discourse.jujucharms.com/t/debugging-charm-hooks/1116 | /docs/charm-writing/hook-debug |
| https://discourse.jujucharms.com/t/deploying-applications-advanced/1061 | /docs/deploying-advanced-applications |
| https://discourse.jujucharms.com/t/deploying-applications/1062 | /docs/deploying-applications |
| https://discourse.jujucharms.com/t/deploying-charms-offline/1069 | /docs/deploying-charms-offline |
| https://discourse.jujucharms.com/t/dhx-a-customized-hook-debugging-environment-plugin/1114 | /docs/charm-writing/hook-debug-dhx |
| https://discourse.jujucharms.com/t/disabling-commands/1141 | /docs/disabling-commands |
| https://discourse.jujucharms.com/t/event-cycle/1117 | /docs/event-cycle |
| https://discourse.jujucharms.com/t/fan-container-networking/1065 | /docs/fan-container-networking |
| https://discourse.jujucharms.com/t/getting-started-with-charm-development/1118 | /docs/getting-started-with-charm-development |
| https://discourse.jujucharms.com/t/getting-started-with-juju-on-jaas/1134 | /docs/getting-started-with-juju-on-jaas |
| https://discourse.jujucharms.com/t/getting-started-with-juju/1970 | /docs/getting-started-with-juju |
| https://discourse.jujucharms.com/t/hook-tools/1163 | /docs/charm-writing/hook-tools |
| https://discourse.jujucharms.com/t/how-to-become-a-juju-charm-author/1049 | /docs/charm-writing/howto-author |
| https://discourse.jujucharms.com/t/implementing-leadership/1124 | /docs/implementing-leadership |
| https://discourse.jujucharms.com/t/implementing-relations/1051 | /docs/charm-writing/relations |
| https://discourse.jujucharms.com/t/appendix-installing-ceph/1077 | /docs/appendix-installing-ceph |
| https://discourse.jujucharms.com/t/installing-juju/1164 | /docs/installing |
| https://discourse.jujucharms.com/t/installing-snaps-offline/1179 | /docs/installing-snaps-offline |
| https://discourse.jujucharms.com/t/instance-naming-and-tagging-in-clouds/1102 | /docs/instance-naming-and-tagging-in-clouds |
| https://discourse.jujucharms.com/t/interface-layers/1121 | /docs/interface-layers |
| https://discourse.jujucharms.com/t/introducing-juju-2-0/1140 | /docs/introducing-juju-2-0 |
| https://discourse.jujucharms.com/t/introduction-to-juju-charms/1188 | /docs/introduction-to-juju-charms |
| https://discourse.jujucharms.com/t/juju-constraints/1160 | /docs/constraints-reference |
| https://discourse.jujucharms.com/t/juju-environment-variables/1162 | /docs/juju-environment-variables |
| https://discourse.jujucharms.com/t/juju-gui/1109 | /docs/gui |
| https://discourse.jujucharms.com/t/juju-logs/1184 | /docs/logs |
| https://discourse.jujucharms.com/t/juju-plugins/1145 | /docs/juju-plugins |
| https://discourse.jujucharms.com/t/juju-resources/1074 | /docs/juju-resources |
| https://discourse.jujucharms.com/t/juju-support-for-centos7/1142 | /docs/centos |
| https://discourse.jujucharms.com/t/language-details-contributing-to-juju-docs/1104 | /docs/language-details-contributing-to-juju-docs |
| https://discourse.jujucharms.com/t/layers-for-charm-authoring/1122 | /docs/layers-for-charm-authoring |
| https://discourse.jujucharms.com/t/leadership-howtos/1123 | /docs/leadership-howtos |
| https://discourse.jujucharms.com/t/machine-authentication/1146 | /docs/machine-auth |
| https://discourse.jujucharms.com/t/managed-solutions/1132 | /docs/managed-solutions |
| https://discourse.jujucharms.com/t/managing-relations/1073 | /docs/relations |
| https://discourse.jujucharms.com/t/metric-collecting-charms/1125 | /docs/metric-collecting-charms |
| https://discourse.jujucharms.com/t/migrating-models/1152 | /docs/migrating-models |
| https://discourse.jujucharms.com/t/models/1155 | /docs/models |
| https://discourse.jujucharms.com/t/multi-user-basic-setup-tutorial/1195 | /docs/multi-user-basic-tutorial |
| https://discourse.jujucharms.com/t/multi-user-external-setup-tutorial/1196 | /docs/multi-user-external-tutorial |
| https://discourse.jujucharms.com/t/network-spaces/1157 | /docs/spaces |
| https://discourse.jujucharms.com/t/notes-on-upgrading-juju-software/1153 | /docs/notes-on-upgrading-juju-software |
| https://discourse.jujucharms.com/t/offline-mode-strategies/1071 | /docs/offline-mode-strategies |
| https://discourse.jujucharms.com/t/persistent-storage-and-kubernetes/1078 | /docs/persistent-storage-and-kubernetes |
| https://discourse.jujucharms.com/t/reference-documents/1161 | /docs/reference |
| https://discourse.jujucharms.com/t/release-notes/1166 | /docs/release-notes |
| https://discourse.jujucharms.com/t/removing-things/1063 | /docs/removing-things |
| https://discourse.jujucharms.com/t/running-multiple-versions-of-juju/1143 | /docs/running-multiple-versions-of-juju |
| https://discourse.jujucharms.com/t/sample-command-usage-and-output-interpretation/1200 | /docs/sample-command-usage-and-output-interpretation |
| https://discourse.jujucharms.com/t/scaling-applications/1075 | /docs/scaling-applications |
| https://discourse.jujucharms.com/t/setting-up-static-kubernetes-storage-tutorial/1193 | /docs/k8s-static-pv-tutorial |
| https://discourse.jujucharms.com/t/subordinate-applications/1053 | /docs/charm-writing/subordinates |
| https://discourse.jujucharms.com/t/the-hook-environment-hook-tools-and-how-hooks-are-run/1047 | /docs/charm-writing/hook-env |
| https://discourse.jujucharms.com/t/the-juju-charm-store/1045 | /docs/charm-writing/store |
| https://discourse.jujucharms.com/t/the-lifecycle-of-charm-relations/1050 | /docs/charm-writing/relations-lifecycle |
| https://discourse.jujucharms.com/t/tools/1181 | /docs/tools |
| https://discourse.jujucharms.com/t/troubleshooting-additions/1182 | /docs/help-additions |
| https://discourse.jujucharms.com/t/troubleshooting-clouds/1183 | /docs/help-clouds |
| https://discourse.jujucharms.com/t/troubleshooting-model-upgrades/1186 | /docs/help-model-upgrades |
| https://discourse.jujucharms.com/t/troubleshooting-removals/1185 | /docs/help-removals |
| https://discourse.jujucharms.com/t/troubleshooting/1187 | /docs/help |
| https://discourse.jujucharms.com/t/tutorial-installing-kubernetes-with-cdk-and-using-auto-configured-storage/1469 | /docs/k8s-cdk-autostorage-tutorial |
| https://discourse.jujucharms.com/t/tutorial-multi-cloud-controller-with-gke-and-auto-configured-storage/1465 | /docs/k8s-multicloud-gke-autostorage-tutorial |
| https://discourse.jujucharms.com/t/tutorials/1197 | /docs/tutorials |
| https://discourse.jujucharms.com/t/understanding-kubernetes-charms-tutorial/1263 | /docs/k8s-charms-tutorial |
| https://discourse.jujucharms.com/t/unmaintained-charms/1056 | /docs/unmaintained-charms |
| https://discourse.jujucharms.com/t/upgrading-a-charm/1131 | /docs/charm-writing/upgrading |
| https://discourse.jujucharms.com/t/upgrading-a-machine-series/1198 | /docs/upgrading-series |
| https://discourse.jujucharms.com/t/upgrading-applications/1080 | /docs/upgrading-applications |
| https://discourse.jujucharms.com/t/upgrading-models/1154 | /docs/upgrading-models |
| https://discourse.jujucharms.com/t/upgrading/1199 | /docs/upgrading |
| https://discourse.jujucharms.com/t/user-types-and-abilities/1201 | /docs/user-types-and-abilities |
| https://discourse.jujucharms.com/t/using-amazon-aws-with-juju/1084 | /docs/aws-cloud |
| https://discourse.jujucharms.com/t/using-bundles-with-the-gui/1057 | /docs/using-bundles-with-the-gui |
| https://discourse.jujucharms.com/t/using-constraints/1060 | /docs/constraints |
| https://discourse.jujucharms.com/t/using-docker-in-charms/1135 | /docs/using-docker-in-charms |
| https://discourse.jujucharms.com/t/using-google-gce-with-juju/1088 | /docs/gce-cloud |
| https://discourse.jujucharms.com/t/using-joyent-with-juju/1089 | /docs/joyent-cloud |
| https://discourse.jujucharms.com/t/using-juju-storage/1079 | /docs/storage |
| https://discourse.jujucharms.com/t/using-juju-with-microk8s-tutorial/1194 | /docs/microk8s-cloud |
| https://discourse.jujucharms.com/t/using-kubernetes-with-juju/1090 | /docs/k8s-cloud |
| https://discourse.jujucharms.com/t/using-lxd-with-juju-advanced/1091 | /docs/lxd-cloud-advanced |
| https://discourse.jujucharms.com/t/using-lxd-with-juju/1093 | /docs/lxd-cloud |
| https://discourse.jujucharms.com/t/using-maas-with-juju/1094 | /docs/maas-cloud |
| https://discourse.jujucharms.com/t/using-microsoft-azure-with-juju-advanced/1085 | /docs/advanced-azure-cloud |
| https://discourse.jujucharms.com/t/using-microsoft-azure-with-juju/1086 | /docs/azure-cloud |
| https://discourse.jujucharms.com/t/using-openstack-with-juju/1097 | /docs/openstack-cloud |
| https://discourse.jujucharms.com/t/using-oracle-oci-with-juju/1096 | /docs/oci-cloud |
| https://discourse.jujucharms.com/t/using-rackspace-with-juju/1098 | /docs/rackspace-cloud |
| https://discourse.jujucharms.com/t/using-resources-developer-guide/1127 | /docs/using-resources-developer-guide |
| https://discourse.jujucharms.com/t/using-the-aws-integrator-charm-tutorial/1192 | /docs/k8s-aws-integrator-tutorial |
| https://discourse.jujucharms.com/t/using-the-localhost-cloud-offline/1070 | /docs/using-the-localhost-cloud-offline |
| https://discourse.jujucharms.com/t/using-the-manual-cloud-with-juju/1095 | /docs/manual-cloud |
| https://discourse.jujucharms.com/t/using-vmware-vsphere-with-juju/1099 | /docs/vsphere-cloud |
| https://discourse.jujucharms.com/t/what-is-juju/1032 | /docs/what-is-juju |
| https://discourse.jujucharms.com/t/whats-new-in-2-6/1202 | /docs/whats-new-2-6 |
| https://discourse.jujucharms.com/t/working-offline/1072 | /docs/working-offline |
| https://discourse.jujucharms.com/t/working-with-actions/1033 | /docs/working-with-actions |
| https://discourse.jujucharms.com/t/working-with-multiple-users/1156 | /docs/working-with-multiple-users |
| https://discourse.jujucharms.com/t/writing-a-layer-by-example/1120 | /docs/writing-a-layer-by-example |
| https://discourse.jujucharms.com/t/writing-charm-tests/1130 | /docs/writing-charm-tests |
| https://discourse.jujucharms.com/t/writing-charms-that-use-storage/1128 | /docs/writing-charms-that-use-storage |
| https://discourse.jujucharms.com/t/writing-charms-that-use-terms/1129 | /docs/writing-charms-that-use-terms |
| https://discourse.jujucharms.com/t/writing-your-first-juju-charm/1046 | /docs/writing-your-first-juju-charm |
[/details]

## Redirects

[details=Mapping table]
| Path | Location |
| -- | -- |
| /getting-started | /docs/getting-started-with-juju |
| /docs/getting-started | /docs/getting-started-with-juju |
| /docs/getting-started-with-jaas | /docs/getting-started-with-juju-on-jaas |
| /docs/clouds-lxd-resources | /docs/lxd-resources |
| /docs/applications/groups | /docs/application-groups |
| /docs/applications/ha | /docs/ha-applications |
| /docs/applications/metrics | /docs/application-metrics |
| /docs/tutorials/client-basic | /docs/client-usage-tutorial |
| /docs/applications/configuring | /docs/configuring-applications |
| /docs/applications/deploying-advanced | /docs/deploying-advanced-applications |
| /docs/applications/deploying | /docs/deploying-applications |
| /docs/reference/constraints | /docs/constraints-reference |
| /docs/tutorials/multi-user-basic | /docs/multi-user-basic-tutorial |
| /docs/tutorials/multi-user-external | /docs/multi-user-external-tutorial |
| /docs/applications/scaling | /docs/scaling-applications |
| /docs/tutorials/k8s-static-pv | /docs/k8s-static-pv-tutorial |
| /docs/tutorials/k8s-charms | /docs/k8s-charms-tutorial |
| /docs/applications/upgrading | /docs/upgrading-applications |
| /docs/aws | /docs/aws-cloud |
| /docs/gce | /docs/gce-cloud |
| /docs/gcp | /docs/gce-cloud |
| /docs/azure | /docs/azure-cloud |
| /docs/microk8s | /docs/microk8s-cloud |
| /docs/oracle | /docs/oracle-cloud |
| /docs/openstack | /docs/openstack-cloud |
| /docs/rackspace | /docs/rackspace-cloud |
| /docs/clouds-aws | /docs/aws-cloud |
| /docs/clouds-gce | /docs/gce-cloud |
| /docs/clouds-joyent | /docs/joyent-cloud |
| /docs/tutorials/k8s-microk8s | /docs/microk8s-cloud |
| /docs/clouds-k8s | /docs/k8s-cloud |
| /docs/clouds-lxd-advanced | /docs/lxd-cloud-advanced |
| /docs/clouds-lxd | /docs/lxd-cloud |
| /docs/clouds-maas | /docs/maas-cloud |
| /docs/clouds-azure-advanced | /docs/advanced-azure-cloud |
| /docs/clouds-azure | /docs/azure-cloud |
| /docs/clouds-openstack | /docs/openstack-cloud |
| /docs/clouds-oci | /docs/oci-cloud |
| /docs/clouds-rackspace | /docs/rackspace-cloud |
| /docs/tutorials/k8s-aws-integrator | /docs/k8s-aws-integrator-tutorial |
| /docs/clouds-manual | /docs/manual-cloud |
| /docs/clouds-vsphere | /docs/vsphere-cloud |
| /docs/tutorials/k8s-cdk-autostorage | /docs/k8s-cdk-autostorage-tutorial |
| /docs/tutorials/k8s-multicloud-gke-autostorage | /docs/k8s-multicloud-gke-autostorage-tutorial |
|  /docs/charm-building | /docs/charm-writing |  
|  /docs/authors-charm-building | /docs/charm-writing  |
| /docs/install | /docs/installing |
| /docs/install-juju | /docs/installing |
| /docs/installing-juju | /docs/installing |
[/details]
