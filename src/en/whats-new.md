Title: What's new in 2.5

# What's new in 2.5

???????

For full details on this release, see the [2.5 release notes][release-notes].

If you are new to Juju, you will probably want to read the
[Getting started][getting-started] guide first.

## Kubernetes support

See [][].

## Remote LXD support

A remote LXD cloud is now possible. Like other custom clouds, it is added via
the enhanced `add-cloud` command. The Juju client can then request a controller
be created on the remote LXD host. This naturally augments the already
supported LXD clustering feature; both features are expected to be used in
tandem.

See [][].

## Oracle Cloud Infrastructure (OCI) support
 
OCI is the new cloud framework from Oracle.

See [][].

## Rework of machine series upgrades

Juju workload machines can now have their series updated natively. In previous
versions the recommended approach was to add a new unit and remove the old one.
With `v.2.5` a new command makes its appearance: `upgrade-series`. By design,
the bulk of the underlying operating system is upgraded manually by the user by
way of standard tooling (e.g. `do-release-upgrade`). Note that the upgrade of
machines hosting controllers is not supported and the documented method of
creating a new controller and migrating models is still the recommended
procedure.

See [][].

## CLI bundle export support

A model's configuration can now be saved as a bundle at the command line using
the new `export-bundle` command. Previously, the Juju GUI was needed to do
this.

See [][].

## New tool for comparing a bundle and model 

<!-- check use cases -->
A model and a bundle can now be compared using the new `diff-bundle` command.
This will help in complex enterprise setups where changes have been made to a
model yet a new bundle deployment of the initial model is desired.

See [][].

## Enhancements for adding OpenStack clouds

The adding of an OpenStack cloud, via `add-cloud`, now supports the inclusion
of a CA certificate in cases where it is necessary. This command also now
recognises certain environment variables used by OpenStack - typically via its
`novarc` file. The corresponding values will be used as default values when
`add-cloud` is used in interactive mode.

See [][].

## LXD availability zones

See [][].

## Charm Store controller configuration key added

See [][].


<!-- LINKS -->

[getting-started]: ./getting-started.md
[release-notes]: ./reference-release-notes.md#juju_2.5.0
