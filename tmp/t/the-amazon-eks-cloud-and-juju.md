(the-amazon-eks-cloud-and-juju)=
# The Amazon EKS cloud and Juju

<!--To see the older HTG-style doc, see version 24. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > Amazon EKS </small>

This document describes details specific to using your existing Amazon EKS cloud with Juju. 

> See more: [Amazon EKS](https://docs.aws.amazon.com/eks/index.html) 

When using the Amazon EKS cloud with Juju, it is important to keep in mind that it is a (1) {ref}`Kubernetes cloud <3352md>` and (2) {ref}`not some other cloud <3352md>`. 

> See more: {ref}`Cloud differences in Juju <3352md>`, {ref}`Kubernetes clouds and Juju <kubernetes-clouds-and-juju>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

## Notes on `add-k8s`

Starting with Juju 3.0, because of the  fact that the `juju` client snap is strictly confined but the EKS cloud CLI snap is not, you must run the `add-k8s` command with the 'raw' client. See note in {ref}`How to add a Kubernetes cloud <3352md>`.

-------------------------

pedroleaoc | 2021-06-08 18:06:32 UTC | #5



-------------------------

pedroleaoc | 2022-10-14 11:31:57 UTC | #6