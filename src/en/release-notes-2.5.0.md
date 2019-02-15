Title: 2.5.0 Release Notes 

# 2.5.0 Release Notes

This is a big release that includes support for Kubernetes workloads, LXD
remote clustering, managed OS series upgrades, support for charms with LXD
profiles, Oracle OCI cloud support, and bundle enhancements.

For highlights of this release, please see the
[What's new in 2.5](https://docs.jujucharms.com/2.5/en/whats-new) page in the
documentation. Further details are below.

## New and improved

**Kubernetes workloads support**  
Juju has been able to install a Kubernetes cluster for a while now. However,
only until `v.2.5` is Juju able to take a pre-existing cluster and add it to
its list of backing clouds. This renders the cluster available for charm
deployment. Kubernetes-specific charms are naturally required.

Documentation: [https://docs.jujucharms.com/2.5/clouds-k8s](https://docs.jujucharms.com/2.5/en/clouds-k8s)

**LXD clustering support**  
Juju now supports managing models on a remote LXD cluster. Leveraging the
density of a LXD cluster of remote machines means you can test full HA
scenarios in complex workloads easily. With three bare metal machines you can
create a HA Juju control plane along with deploying HA enabled workloads.
This is a great setup for development, testing, and validating failover
scenarios or just providing a great dense "micro cloud" for a team to work
against. 

- Documentation: [https://docs.jujucharms.com/2.5/clouds-lxd-advanced](https://docs.jujucharms.com/2.5/en/clouds-lxd-advanced#lxd-clustering)
- Tips on setting up the LXD cluster networking:
  [https://discourse.jujucharms.com/t/manual-network-setup-for-lxd-clustering/261](https://discourse.jujucharms.com/t/manual-network-setup-for-lxd-clustering/261)

**Upgrading of underlying OS support**  
Juju supports a new `upgrade-series` command that allows you to upgrade a
machine running Ubuntu Trusty to Xenial or Xenial to Bionic. Charms now have
the ability to provide new hooks that can script the work required for
applications to handle the big OS upgrade scenario. With this you can now
migrate your infrastructure without redeploying and keep up with the latest
LTS releases available. 

Documentation: [https://docs.jujucharms.com/2.5/upgrade-series](https://docs.jujucharms.com/2.5/en/upgrade-series)

The OpenStack charms are updated to support this in their latest release. You
can see a charm that uses this feature
[here](https://docs.openstack.org/project-deploy-guide/charm-deployment-guide/latest/app-series-upgrade.html).

**Bundle export feature**  
This feature provides a CLI command which exports the configuration of the
current model in bundle format which can then be used for subsequent
(re-)deployment.

The command added to support this functionality is `export-bundle`:

    juju export-bundle --filename <outputfile>
    juju export-bundle

If `--filename` option is not specified the output is printed to STDOUT.

**Bundle diff feature**  
This feature provides a command to compare a bundle with a model and report
any differences. This is really useful when you're trying to see what changes
might have been made in production over time that are different than the
original bundle you started out with. You might also use this to snapshot
updates to the bundle over time. 

The bundle to compare can be a local bundle file or the name of a bundle in
the Charm Store. The bundle can also be combined with overlays (in the same
way as the deploy command) before comparing with the model.

The map-machines option works similarly as for the deploy command, but
existing is always assumed, so it doesn't need to be specified.

Here are some examples to demonstrate the flexibility available:

    juju diff-bundle localbundle.yaml
    juju diff-bundle canonical-kubernetes
    juju diff-bundle -m othermodel hadoop-spark
    juju diff-bundle mongodb-cluster --channel beta
    juju diff-bundle canonical-kubernetes --overlay local-config.yaml --overlay extra.yaml
    juju diff-bundle localbundle.yaml --map-machines 3=4

Documentation: [https://docs.jujucharms.com/2.5/charms-bundles](https://docs.jujucharms.com/2.5/en/charms-bundles#comparing-a-bundle-to-a-model)

**Support for charms with LXD profiles**  
Sometimes an application needs to have a LXD profile with some tweaks in
order to work properly in a LXD container. Some examples of this include
things like allowing nested containers, so that workload creating Docker
containers is able to create  those containers, or perhaps an application
needs a kernel module added into the LXD container it runs in. In Juju 2.5
charms can now provide a `lxd-profile.yaml` file that helps tell Juju what it
needs. Juju will then make sure that the LXD containers the application runs
it is provided the tweaks it needs. 

Documentation:
[https://docs.jujucharms.com/2.5/clouds-lxd-advanced](https://docs.jujucharms.com/2.5/en/clouds-lxd-advanced#charms-and-lxd-profiles)

A charm in development that uses this feature can be seen
[here](https://jujucharms.com/u/openstack-charmers-next/neutron-openvswitch/)
(see the `lxd-profile.yaml` in the file listing).

**Oracle Cloud Infrastructure support**  
The Oracle cloud has been updated and now supports
[Oracle Cloud Infrastructure](https://cloud.oracle.com/cloud-infrastructure)
(OCI) as a cloud.

If you wish to use the older legacy cloud you can find it listed as "OCI
Classic".

Documentation: [https://docs.jujucharms.com/2.5/clouds-oci](https://docs.jujucharms.com/2.5/en/clouds-oci)

**Credential Management and Validation**  
Juju uses a cloud credential to bootstrap a controller or to add a model.
This credential is then used in cloud communications on the model's behalf.
The credentials however can expire, be revoked and deleted or simply need to
be changed during the life of the model. From 2.5, Juju gains the ability to
react to these changes.  

Whenever the underlying cloud rejects Juju's call because of an invalid
credential, all communications between this model and the cloud are stopped
until the credential is either updated or changed. If more than one model
uses the same credential, these models will react the same way. This ability
has been rolled out to most supported cloud providers.

In order to re-enable cloud communications on the models that have invalid
credentials, users can use the existing `update-credential` command. If the
model requires a completely different credential, a new command can be used
to upload a new credential and use it on the model, see `set-credential`.

Juju users can examine what credential models have via `show-model` or
`show-credential` commands.

**OpenStack cloud config supports CA_CERT**  
Juju now supports OpenStack clouds requiring CA Certificates. Simply run
`juju add-cloud` with your novarc file sourced, Juju will pick up the value
of OS_CACERT, or provide the location of the certificate and Juju will take
it from there.

Documentation: [https://docs.jujucharms.com/2.5/help-openstack](https://docs.jujucharms.com/2.5/en/help-openstack#adding-an-openstack-cloud)

**Adding zones as a valid constraint**  
You can now select one or more zones to be a constraint on the deployment. If
you wish to use a subset of the available zones you can list them at deploy
time and all units will respect that selection over time. 

Documentation: [https://docs.jujucharms.com/2.5/charms-constraints](https://docs.jujucharms.com/2.5/en/charms-constraints)

**New config-changed hook behaviour**  
The  config-changed hook is now only run when needed. This solves a problem
on deployments with a large number of units whereby the system thrashed after
any upgrade (or other agent restart) due to each and every unit agent running
config-changed for all charms. Instead of speculatively running the hook
whenever the agent restarts, or when an update is made that doesn't really
change anything, we now track the hash of 3 artefacts - config settings,
machine/container addresses, trust config. If any of these change, the hook
is run. The agent still checks on start up but will no longer run the hook if
nothing has changed since the last invocation. *Note that the first agent
restart after upgrade to Juju 2.5 will run the hook as there are no hashes
recorded yet.*

## Fixes

Some important fixes include:

[LP #1791715](https://bugs.launchpad.net/juju/+bug/1791715) - juju does not support --to <zone> placement directive in bundles  
[LP #1806442](https://bugs.launchpad.net/juju/+bug/1806442) - primary charm with a customized lxd profile fails  
[LP #1804669](https://bugs.launchpad.net/juju/+bug/1804669) - Charm channel isn't used on upgrade-charm  
[LP #1787986](https://bugs.launchpad.net/juju/+bug/1787986) - Run action on leader   
[LP #1799365](https://bugs.launchpad.net/juju/+bug/1799365) - Juju HA controllers need to distribute client connections  
[LP #1796378](https://bugs.launchpad.net/juju/+bug/1796378) - Subordinate charm deployment ignores global series settings  
[LP #1776995](https://bugs.launchpad.net/juju/+bug/1776995) - subordinate can't relate to applications with different series  
[LP #1804701](https://bugs.launchpad.net/juju/+bug/1804701) - (2.5-beta1) juju upgrade-series from Trusty to Xenial hangs up  
[LP #1787753](https://bugs.launchpad.net/juju/+bug/1787753) - Add europe-north1 region to google clouds  
[LP #1778033](https://bugs.launchpad.net/juju/+bug/1778033) - juju stuck attaching storage to OSD  
[LP #1751858](https://bugs.launchpad.net/juju/+bug/1751858) - support vsphere disk.enableUUID model config

For a detailed breakdown of fixed bugs:

[https://launchpad.net/juju/+milestone/2.5-rc2](https://launchpad.net/juju/+milestone/2.5-rc2)
[https://launchpad.net/juju/+milestone/2.5-rc1](https://launchpad.net/juju/+milestone/2.5-rc1)  
[https://launchpad.net/juju/+milestone/2.5-beta3](https://launchpad.net/juju/+milestone/2.5-beta3)  
[https://launchpad.net/juju/+milestone/2.5-beta1](https://launchpad.net/juju/+milestone/2.5-beta1)

Known issues:

[LP #1808515](https://bugs.launchpad.net/juju/+bug/1808515) - updating a charm with a LXD profile, directly after deploying a charm can prevent any new upgrades of the same charm  
[LP #1808551](https://bugs.launchpad.net/juju/+bug/1808551) - model migration fails when using a previous client and breaks current client

If you were affected by any of the bugs fixed in this release, your feedback
is appreciated. Please contact the Juju team using the communication channels
specified in the feedback section.

## Get Juju

The recommended install method is by snaps:

    sudo snap install juju --classic

Those already using the 'stable' snap channel (the default as per the above
command) should be upgraded automatically. Other packages are available for a
variety of platforms (see the [install documentation][reference-install]).

## Feedback appreciated

Let us know how you're using Juju or of any questions you may have. You can
join us on [Discourse][juju-discourse-forum], send us a message on Twitter
(hashtag `#jujucharms`), or talk to us in the `#juju` IRC channel on
freenode.

## More information

To learn more about Juju visit our home page at
[https://jujucharms.com][upstream-juju].


<!-- LINKS -->

[reference-install]: ./reference-install.md
[juju-discourse-forum]: https://discourse.jujucharms.com/
[upstream-juju]: https://jujucharms.com
