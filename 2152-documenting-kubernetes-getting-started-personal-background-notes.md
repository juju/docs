[note]
This document is a bit of a personal brain dump. It won't become official documentation.
[/note]

### Thoughts

Need to sync/update the semantics to match add-credentials.

The `add-k8s` command introduces new flows for `add-cloud` and `add-credential`. This introduces cognitive load.

For documentation purposes, we now need to consider four starting points:

| Has a Kubernetes cluster? | Familiar with Juju?  | Live controller? | In Scope? | Representative User(s) | 
|------------------|---------------|-------|-------|-----|
| :ballot_box_with_check: |  :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: | Canonical IS staff. Heavily invested in Juju.
| :ballot_box_with_check: |  :ballot_box_with_check: | | :ballot_box_with_check: | Ex-Juju user.
| :ballot_box_with_check: | | | :ballot_box_with_check: :sparkle:  | Current k8s user. Exploring options for simplifying their deployment.
| | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: | Current Juju user. Someone currently on Discourse.
| | :ballot_box_with_check: | | :ballot_box_with_check: | Someone who used Juju in the past, but has moved to other tools. JAAS  users.
| |  |  | :negative_squared_cross_mark: | Brand new to Juju _and_ Kubernetes.

### Examples

```plain
juju add-k8s myk8scloud
```
<dl>

<dt>Behaviour</dt>
<dd>
Loads the definition of myk8scloud into the current controller.
</dd>

<dt>Assumptions</dt>
<dd>
 Assumes that a K8s cluster is available.

When the k8s cluster is a vanilla cluster on top of a cloud, assumes that an integrator charm has been deployed.
</dd>

<dt>Questions</dt>
<dd>
<ul>
  <li>Q: where does the definition for myk8scloud come from? ~/.kube/config? A: yes.
  <li>how does it behave when k8s isn't available? A: `ERROR failed to read Kubernetes config file: /home/tsm/.kube/config not found`
  <li>how does it behave when a controller isn't available?
</ul>
</dd>
</dl>

### Scenarios

<dt>No k8s, no controller</dt>
<dd>
<pre>
$ juju add-k8s nope
ERROR failed to read Kubernetes config file: /home/ubuntu/.kube/config not found
</pre>
</dd>

<dt>Kubernetes-core deployed</dt>
<dd>
Setup
<pre>
juju add-cloud devstack [openstack]
juju bootstrap devstack
juju add-model k8s-base
juju deploy kubernetes-core
juju wait [via juju-wait plugin]
juju scp kubernetes-master/0:config ~/.kube/config [only documented in charm readmes] 
</pre>
</dd>
<dd>
Running add-k8s
<pre>
$ juju add-k8s dev-k8s
.
ERROR 	Juju needs to query the k8s cluster to ensure that the recommended
	storage defaults are available and to detect the cluster's cloud/region.
	This was not possible in this case so run add-k8s again, using
	--storage=<name> to specify the storage class to use and
	--cloud=<cloud> --region=<cloud>/<someregion> to specify the cloud/region.
</pre>
<pre>
$ juju add-k8s dev-k8s --cloud=devstack
.
ERROR 	No recommended storage configuration is defined on this cluster.
	Run add-k8s again with --storage=<name> and Juju will use the
	specified storage class or create a storage-class using the recommended
	"Cinder Disk" provisioner.
</pre>
<pre>
juju deploy ~containers/openstack-integrator
juju trust openstac-integrator
juju wait
</pre>
</dd>
<dd>
<dl>
<dt>Questions:</dt>
<dd>
<li>Why is &lt;cloud&gt; required twice?
</dd>
</dl>
</dd>

<dt>Microk8s, no controller</dt>
<dd>
<pre>
$ juju add-k8s maybe
[todo]
</pre>
</dd>



----



    juju add-k8s myk8scloud --local
    juju add-k8s myk8scloud --controller mycontroller
    juju add-k8s --context-name mycontext myk8scloud
    juju add-k8s myk8scloud --region <cloudNameOrCloudType>/<someregion>
    juju add-k8s myk8scloud --cloud <cloudNameOrCloudType>
    juju add-k8s myk8scloud --cloud <cloudNameOrCloudType> --region=<someregion>

    KUBECONFIG=path-to-kubuconfig-file juju add-k8s myk8scloud --cluster-name=my_cluster_name
    kubectl config view --raw | juju add-k8s myk8scloud --cluster-name=my_cluster_name

    juju add-k8s --gke myk8scloud
    juju add-k8s --gke --project=myproject myk8scloud
    juju add-k8s --gke --credential=myaccount --project=myproject myk8scloud
    juju add-k8s --gke --credential=myaccount --project=myproject --region=someregion myk8scloud

    juju add-k8s --aks myk8scloud
    juju add-k8s --aks --cluster-name mycluster myk8scloud
    juju add-k8s --aks --cluster-name mycluster --resource-group myrg myk8scloud

See also:
    remove-k8s
