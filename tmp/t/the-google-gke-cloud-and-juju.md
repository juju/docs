(the-google-gke-cloud-and-juju)=
# The Google GKE cloud and Juju

<!--To see the older HTG-style doc, see version 21. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Google GKE </small>

This document describes details specific to using your existing Google GKE cloud with Juju. 

> See more: [Google GKE](https://cloud.google.com/kubernetes-engine/docs) 

When using the Google GKE cloud with Juju, it is important to keep in mind that it is a (1) {ref}`Kubernetes cloud <3341md>` and (2) {ref}`not some other cloud <3341md>`. 

> See more: {ref}`Cloud differences in Juju <3341md>`, {ref}`Kubernetes clouds and Juju <kubernetes-clouds-and-juju>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

## Notes on `add-k8s`

Starting with Juju 3.0, because of the  fact that the `juju` client snap is strictly confined but the GKE cloud CLI snap is not, you must run the `add-k8s` command with the 'raw' client. See note in {ref}`How to add a Kubernetes cloud <3341md>`.