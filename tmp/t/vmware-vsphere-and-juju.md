(vmware-vsphere-and-juju)=
# VMware vSphere and Juju

<!--To see the older HTG-style doc, see version 45. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > VMware vSphere </small>

This document describes details specific to using your existing VMware vSphere cloud with Juju. 

> See more: [VMware vSphere](https://docs.vmware.com/) 

When using the VMware vSphere cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1099md>` and (2) {ref}`not some other cloud <1099md>`. 

> See more: {ref}`Cloud differences in Juju <1099md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

|Juju points of variation|Notes for the VMware vSphere cloud|
|---|---|
|**setup (chronological order):**||
|{ref}`CLOUD <cloud-substrate>`||
|supported versions:||
|requirements:|In order to add a vSphere cloud you will need to have an existing vSphere installation which supports, or has access to, the following: <p> - VMware Hardware Version 8 (or greater) <p> - ESXi 5.0 (or greater) <p> - Internet access <p> - DNS and DHCP <p> Juju supports both high-availability vSAN deployments as well and standard deployments. |
|{ref}`definition: <1099md>`||
|- cloud name: | user-defined|
|- type:|`vsphere`|
|- endpoint | vSphere endpoint |
|- region | Datacenter|
|- authentication types:|`{ref}`userpass]`|
|- cloud-specific model configuration keys:|**`datastore`** <br> The datastore in which to create VMs. If this is not specified, the process will abort unless there is only one datastore available. <p> **`disk-provisioning-type`** <br> This dictates how template VM disks should be cloned when creating a new machine. <br> Valid values: <p> - *thin* - Sparse provisioning, only written blocks will take up disk space on the datastore <p> - *thick* - The entire size of the virtual disk will be deducted from the datastore, but unwritten blocks will not be zeroed out. This adds 2 potential pitfalls. See comments in provider/vsphere/internal/vsphereclient/client.go regarding DiskProvisioningType. <p> - *thickEagerZero (default)* - The entire size of the virtual disk is deducted from the datastore, and unwritten blocks are zeroed out. Improves latency when committing to disk, as no extra step needs to be taken before writing data. <p> **`external-network`** <br> An external network that VMs will be connected to. The resulting IP address for a VM will be used as its public address. An external network provides the interface to the internet for virtual machines connected to external organization vDC networks. <p> **`force-vm-hardware-version`** (integer) <br> Adds a new model level flag that allows operators to set a newer compatibility version for the instances that get spawned by juju. E.g., `juju bootstrap vsphere --config force-vm-hardware-version=17` <p> **`primary-network`** <br> The primary network that VMs will be connected to. If this is not specified, Juju will look for a network named `VM Network`.|
|[CREDENTIAL <credential>`||
|definition:|`auth-type:` userpass. You will have to provide your username, password and, optionally, the vmfolder. <p> :warning: **If your credential stops working:** Credentials for the vSphere cloud have been reported to occasionally stop working over time. If this happens, try `juju update-credential` (passing as an argument the same credential) or `juju add-credential` (passing as an argument a new credential) + `juju default-credential`. |
|{ref}`CONTROLLER <controller>`||
|notes on bootstrap:|Recommended: Bootstrap with the following cloud-specific model-configuration keys: `datastore` and `primary-network`. See more below. <p> **Pro tip:** When creating a controller with vSphere, a cloud image is downloaded to the client and then uploaded to the ESX host. This depends on your network connection and can take a while.  Using [templates](#heading--using-templates) can speed up bootstrap and machine deployment.|
|||
|||
|**other (alphabetical order:)**||
| {ref}`CONSTRAINT <constraint>`||
|conflicting:||
|supported?||
|- {ref}``allocate-public-ip` <1099md>` |&#10060;|
|- {ref}``arch` <1099md>`|:white_check_mark: <br> Valid values: `{ref}`amd64]`.|
|- [`container` <1099md>`|:white_check_mark:|
|- {ref}``cores` <1099md>`|:white_check_mark:|
|- {ref}``cpu-power` <1099md>`|:white_check_mark:|
|- {ref}``image-id` <1099md>`|&#10060;  |
|- {ref}``instance-role` <1099md>`|&#10060;|
|- {ref}``instance-type` <1099md>`|:white_check_mark:|
|- {ref}``mem` <1099md>`|:white_check_mark:|
|- {ref}``root-disk` <1099md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1099md>`|:white_check_mark: <br> `root-disk-source` is the datastore for the root disk|
|- {ref}``spaces` <1099md>`|&#10060;|
|- {ref}``tags` <1099md>`|&#10060;|
|- {ref}``virt-type` <1099md>`|&#10060;|
|- {ref}``zones` <1099md>`|:white_check_mark: <p> Use to specify  resurce pools within a host or cluster, e.g. <p> `juju deploy myapp --constraints zones=myhost` <p> `juju deploy myapp --constraints zones=myfolder/myhost`<p> `juju deploy myapp --constraints zones=mycluster/mypool` <p> `juju deploy myapp --constraints zones=mycluster/myparent/mypool`|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1099md>`| :white_check_mark: |
|{ref}``subnet=...` <1099md>`|&#10060;  |
|{ref}``system-id=...` <1099md>`|&#10060;|
|{ref}``zone=...` <1099md>`|:white_check_mark: <br> Valid values: `<cluster\|host>`. <p> :warning:  If your topology has a cluster without a host, Juju will see this as an availability zone and may fail silently. To solve this, either make sure the host is within the cluster, or use a placement directive: `juju bootstrap vsphere/<datacenter> <controllername> --to zone=<cluster\|host>`.|
|{ref}`MACHINE <machine>`||
|{ref}`RESOURCE  (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|&#10060;  |


## Other notes

<a href="#heading--using-templates"><h3 id="heading--using-templates">Using templates</h3></a>

To speed up bootstrap and deploy, you can use VM templates, already created in your vSphere.  Templates can be created by hand on your vSphere, or created from an existing VM.  

Examples assume that the templates are in directory $DATA_STORE/templates.

Via simplestreams:
```text
mkdir -p $HOME/simplestreams
juju-metadata generate-image -d $HOME/simplestreams/ -i "templates/juju-focal-template" --base ubuntu@22.04 -r $DATA_STORE -u $CLOUD_ENDPOINT
juju-metadata generate-image -d $HOME/simplestreams/ -i "templates/juju-noble-template" --base ubuntu@24.04 -r $DATA_STORE -u $CLOUD_ENDPOINT
juju bootstrap --metadata-source $HOME/image-streams vsphere
```

Bootstrap juju with the controller on a VM running focal:
```text
juju bootstrap vsphere --bootstrap-image="templates/focal-test-template"  --bootstrap-base ubuntu@22.04 --bootstrap-constraints "arch=amd64"
```

Using [add-image](https://discourse.charmhub.io/t/new-feature-in-juju-2-8-add-custom-machine-images-with-the-juju-metadata-command/3171):
```text
juju metadata add-image templates/bionic-test-template --base ubuntu@22.04
```