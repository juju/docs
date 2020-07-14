[note type="caution"]
Multi-cloud functionality via `add-cloud` (not `add-k8s`) is available as "early access" and requires the use of a feature flag. Once the controller is created, you can enable it with: `juju controller-config features="[multi-cloud]"`
[/note]

In Juju `v.2.6.1`, clouds can now be added to an existing controller using the standard `add-cloud` command. This gives rise to the "multi-cloud controller". Tutorial [Multi-cloud controller with GKE and auto-configured storage](/t/tutorial-multi-cloud-controller-with-gke-and-auto-configured-storage/1465) gives the steps to follow.

A limiting factor is that both controller machine and workload machine must be able to initiate a TCP connection to one another. There are also latency issues that may make some scenarios unfeasible.

New cloud-based 'add-model' permissions can be set up via new commands `grant-cloud` and `revoke-cloud`.

When adding a model on a controller hosting more than one cloud, specifying the cloud name is mandatory.

For example, to manage a MAAS cloud with a LXD controller:

```text
juju bootstrap localhost lxd
juju add-cloud --local maas -f maas-cloud.yaml
juju add-credential maas -f maas-credentials.yaml
juju add-cloud --controller lxd maas
```

Exceptionally, credentials for the local cloud need to be set up before adding the cloud to the controller. (normally, credentials are only required when a model is created). Per usual, if there is no default credential set for the the local cloud and that cloud has multiple credentials, the `--credential` option must be used.

A commonly requested use case is the ability to continue with the above to do the following:

1. Juju deploy OpenStack onto the MAAS cloud
1. add the resulting OpenStack cloud to the controller
1. Juju deploy applications onto the OpenStack cloud

All this can be achieved with a single controller.
