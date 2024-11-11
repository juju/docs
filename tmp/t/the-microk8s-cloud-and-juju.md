(the-microk8s-cloud-and-juju)=
# The MicroK8s cloud and Juju

<!--To see the older HTG-style doc, see version 49. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > MicroK8s </small>

This document describes details specific to using your a MicroK8s cloud with Juju. 

> See more: [Getting started on Microk8s](https://microk8s.io/docs/getting-started)

When using the MicroK8s cloud with Juju, it is important to keep in mind that it is a (1) {ref}`Kubernetes cloud <1194md>` and (2) {ref}`not some other cloud <1194md>`. 

> See more: {ref}`Cloud differences in Juju <1194md>`, {ref}`Kubernetes clouds and Juju <kubernetes-clouds-and-juju>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

## Requirements

### MicroK8s snap

Juju 3.x requires MicroK8s to operate in strict mode.
> See more: [MicroK8s | Strict MicroK8s](https://microk8s.io/docs/install-strict)

### Services that must enabled

- `dns`
- `hostpath-storage`

<br>

> **Contributors:** @tmihoc, @wideawakening