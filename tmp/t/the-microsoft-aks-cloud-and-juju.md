(the-microsoft-aks-cloud-and-juju)=
# The Microsoft AKS cloud and Juju

<!--To see the older HTG-style doc, see version 43. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Microsoft AKS </small>

This document describes details specific to using your existing Microsoft AKS cloud with Juju. 

> See more: [Microsoft AKS](https://azure.microsoft.com/en-us/products/kubernetes-service) 

When using the Microsoft AKS cloud with Juju, it is important to keep in mind that it is a (1) {ref}`Kubernetes cloud <3301md>` and (2) {ref}`not some other cloud <3301md>`. 

> See more: {ref}`Cloud differences in Juju <3301md>`, {ref}`Kubernetes clouds and Juju <kubernetes-clouds-and-juju>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

## Notes on `add-k8s`

Starting with Juju 3.0, because of  the  fact that the `juju` client snap is strictly confined but the AKS cloud CLI snap is not, you must run the `add-k8s` command with the 'raw' client. See note in {ref}`How to add a Kubernetes cloud <3301md>`.