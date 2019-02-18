Title: What's new in 2.5

# What's new in 2.5

The major new features in this release are summarised below. See the
[Release Notes][release-notes-2] for full details.

## Kubernetes workloads support

Juju has been able to install a Kubernetes cluster for a while now. However,
only until 2.5 is Juju able to take a pre-existing cluster and add it to its
list of backing clouds. This renders the cluster available for charm
deployment. Kubernetes-specific charms are naturally required.

See [Using Kubernetes with Juju][clouds-k8s].

## Remote LXD support and LXD clustering

A remote LXD cloud is now possible. Like other custom clouds, it is added via
the `add-cloud` command. The Juju client can then request a controller be
created on the remote LXD host. This naturally bolsters the already supported
LXD clustering feature; both features are expected to be used in tandem.

Placement directives are supported for LXD clustering. You can specify upon
which LXD host (cluster node) a Juju machine will be created. These nodes
effectively become availability zones for a LXD clustered cloud.

See [Adding a remote LXD cloud][clouds-lxd-advanced-remote] and
[LXD clustering][clouds-lxd-advanced-clustering].

## Oracle Cloud Infrastructure (OCI) support
 
OCI is the new cloud framework from Oracle and Juju now supports it out of the
box. Juju's cloud name for this cloud is 'oci'. The legacy Oracle cloud of
'oracle' has been renamed 'oracle-classic' and should be considered deprecated.

See [Using Oracle OCI with Juju][clouds-oci].

## Rework of machine series upgrades

Juju workload machines can now have their series updated natively. In previous
versions the recommended approach was to add a new unit and remove the old one.
With `v.2.5` a new command makes its appearance: `upgrade-series`. By design,
the bulk of the underlying operating system is upgraded manually by the user by
way of standard tooling (e.g. `do-release-upgrade`). Note that the upgrade of
machines hosting controllers is not supported and the documented method of
creating a new controller and migrating models is still the recommended
procedure.

See [Upgrading a machine series][upgrade-series].

## Support for charms with LXD profiles

Juju now supports charms that include a LXD profile. A profile is applied to a
LXD container that the charm is deployed into. Some hardcoded security checks
are applied automatically when such a charm is deployed and profile information
is exposed at the machine level with the `status` and `show-machine` commands.

See [Charms and LXD profiles][clouds-lxd-advanced-profiles].

## New command for saving a bundle

A model's configuration can now be saved as a bundle at the command line using
the new `export-bundle` command. Previously, the Juju GUI was needed for this.

See [Saving a bundle][charms-bundles-export].

## New command for comparing a bundle and model 

A model and a bundle can now be compared using the new `diff-bundle` command.
This will help in complex enterprise setups where changes have been made to a
model yet a new bundle deployment of the initial model is desired.

See [Comparing a bundle to a model][charms-bundles-diff].

## Enhancements for adding OpenStack clouds

The adding of an OpenStack cloud, via `add-cloud`, now supports the inclusion
of a CA certificate in cases where it is necessary. This command also now
recognises certain environment variables used by OpenStack - typically via its
`novarc` file. The corresponding values will be used as default values when
`add-cloud` is used in interactive mode.

See [Adding an OpenStack Cloud][clouds-openstack-adding].

## New command for assigning a remote credential to a model 

Occasionally there is the need to change (or set) what remote credential is
assigned to a model. This is now possible via the new `set-credential` command.

See [Changing a remote credential for a model][credentials-set-credential].

## Charm Store controller configuration key added

A custom Charm Store can be configured by specifying a URL during the creation
of a controller (`bootstrap`).

See [Use a custom charm store][controllers-creating-charmstore-url].


<!-- LINKS -->

[release-notes-2]: ./reference-release-notes.md
[clouds-k8s]: ./clouds-k8s.md
[clouds-lxd-advanced-remote]: ./clouds-lxd-advanced.md#adding-a-remote-lxd-cloud
[clouds-lxd-advanced-clustering]: ./clouds-lxd-advanced.md#lxd-clustering
[clouds-oci]: ./clouds-oci.md
[upgrade-series]: ./upgrade-series.md
[clouds-lxd-advanced-profiles]: ./clouds-lxd-advanced.md#charms-and-lxd-profiles
[charms-bundles-export]: ./charms-bundles.md#saving-a-bundle
[charms-bundles-diff]: ./charms-bundles.md#comparing-a-bundle-to-a-model
[clouds-openstack-adding]: ./clouds-openstack.md#adding-an-openstack-cloud
[credentials-set-credential]: ./credentials.md#changing-a-remote-credential-for-a-model
[controllers-creating-charmstore-url]: ./controllers-creating.md#use-a-custom-charm-store
