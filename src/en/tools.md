Title: Tools

# Tools

This page covers independent tools that can be used in conjunction with Juju.

## Charm Tools

The Charm Tools package is a collection of commands that assist with charm
management. In particular, it allows charm authors to create charms. See the
[Charm Tools][charm-tools] page.

## Amulet

Amulet is a Python library for deploying, manipulating, and testing Juju
workloads (collections of related applications).

With Amulet you can:

* Deploy, relate, configure, and scale applications imperatively
* Deploy a preconfigured workload using a bundle file
* Execute application actions and inspect the results
* Run arbitrary commands against deployed units and inspect the results.

For documentation, visit the upstream site at
[http://pythonhosted.org/amulet][upstream-amulet].

## Mojo

The Mojo package provides tools to install, configure, and verify Juju-based
deployments. It is being applied successfully for the purpose of continuous
integration (CI) at the enterprise level.

Mojo is an open source project available under the GPLv3 license and is hosted
on Launchpad. See the [Mojo project][lp-mojo].

For documentation, visit the upstream site at
[https://mojo.canonical.com][upstream-mojo].

## Charm Helpers

Charm Helpers is a Python library that simplifies charm development by
providing a rich collection of helpful utilities for:

* Interacting with the host machine and environment
* Responding to hook events
* Reading and writing charm configuration
* Installing dependencies
* Much, much more!

For documentation, visit the upstream site at
[https://charm-helpers.readthedocs.io][upstream-charm-helpers].

<!-- LINKS -->

[lp-mojo]: https://launchpad.net/mojo
[upstream-amulet]: http://pythonhosted.org/amulet
[upstream-charm-helpers]: https://charm-helpers.readthedocs.io
[upstream-mojo]: https://mojo.canonical.com
[charm-tools]: tools-charm-tools.md
