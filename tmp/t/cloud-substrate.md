(cloud-substrate)=
# Cloud (substrate)

> See also: {ref}`How to manage a cloud <how-to-manage-clouds>`

<!-- > -  {ref}`Amazon AWS <the-amazon-ec2-cloud-and-juju>`,  {ref}`Amazon EKS <the-amazon-eks-cloud-and-juju>`,  {ref}`Equinix Metal <the-equinix-metal-cloud-and-juju>`,{ref}`Google GCE <the-google-gce-cloud-and-juju>`, {ref}`Google GKE <the-google-gke-cloud-and-juju>`, {ref}`LXD <the-lxd-cloud-and-juju>`, {ref}`MAAS <the-maas-cloud-and-juju>`,  {ref}`Manual cloud <the-manual-cloud-and-juju>`, {ref}`MicroK8s <the-microk8s-cloud-and-juju>`, {ref}`Microsoft Azure <the-microsoft-azure-cloud-and-juju>`, {ref}`Microsoft AKS <the-microsoft-aks-cloud-and-juju>`, {ref}`OpenStack <openstack-and-juju>`, {ref}`Oracle <the-oracle-oci-cloud-and-juju>`, {ref}`VMware vSphere <vmware-vsphere-and-juju>` -->

To Juju, a **cloud** (or backing cloud) is any entity that has an API that can provide compute, networking, and optionally storage resources in order for application units to be deployed on them. This includes public clouds such as Amazon Web Services, Google Compute Engine, Microsoft Azure and Kubernetes as well as private OpenStack-based clouds. Juju can also make use of environments which are not clouds per se, but which Juju can nonetheless treat as a cloud. MAAS and LXD fit into this last category. Because of this, in Juju a cloud is sometimes also called, more generally, a **substrate**. 

**Contents:**

- [Supported clouds](#heading--supported-clouds)
- [Cloud differences](#heading--cloud-differences)
- [Cloud definition](#heading--cloud-definition)	

<a href="#heading--supported-clouds"><h2 id="heading--supported-clouds">Supported clouds</h2></a>

> See: {ref}`List of supported clouds <list-of-supported-clouds>`

<a href="#heading--cloud-differences"><h2 id="heading--cloud-differences">Cloud differences</h2></a>

While Juju aims to make all clouds feel the same, some differences still persist depending on whether the cloud is a machine cloud or a Kubernetes cloud or a specific cloud as opposed to another. 

<!--

----
```{dropdown} Expand to view an example featuring the Amazon EC2 cloud


The Amazon EC2 cloud is a machine cloud, so you connect it to Juju via `add-cloud` + `add-credential`. However, it's a public cloud, so Juju can get its definition for you, so you can skip `add-cloud` -- Juju already knows this cloud as `aws`. Still, when you do `add-credential`, you have to use the cloud-specific authentication type, which in this case requires you to provide your access key and secret key. Because it's a machine cloud, that means you can make your controller high-availability; also, you can clone your controller's configuration into a new controller via `juju create-backup` and the stand-alone tool `juju-restore`; however, you can only deploy machine charms; and, to scale an application, you can't do `scale-application` -- you must do `add-unit`. However, because it's AWS EC2 you can use instance roles. Etc.

```
----
-->

- [Machine clouds vs. Kubernetes clouds](#heading--machine-clouds-vs--kubernetes-clouds)
- [Cloud foo vs. cloud bar](#heading--cloud-foo-vs--cloud-bar)	

<a href="#heading--machine-clouds-vs--kubernetes-clouds"><h3 id="heading--machine-clouds-vs--kubernetes-clouds">Machine clouds vs. Kubernetes clouds</h3></a>

Juju makes a fundamental distinction between **'machine' clouds** -- that is, clouds based on bare metal machines (BMs; e.g., MAAS), virtual machines (VMs; e.g., AWS EC2), or system containers (e.g., LXD) -- and **'Kubernetes' clouds** -- that is, based on containers (e.g., AWS EKS). 

> See more: {ref}`Machine <machine>`

While the user experience is still mostly the same -- bootstrap a Juju controller into the cloud, add a model, deploy charms, scale, upgrade, etc. -- this difference affects:
 - the required system requirements (e.g., for a Juju controller, 4GB vs. 6GB memory)
- the way you connect the cloud to Juju (`add-cloud` + `add-credentials` vs. `add-k8s`)
- what charms you can deploy ('machine' charms vs. 'Kubernetes' charms)

and, occasionally

- what operations you may perform, e.g.,
    - `enable-ha` is currently supported just for machine controllers
    - scaling an application is done via `add-unit` on machines and via `scale-application` on K8s). 

> See more:  {ref}`Tutorial <get-started-with-juju>`, {ref}`Juju How-to guides <juju-how-to-guides>`

Juju's vision is to eventually make this distinction irrelevant.


<!--REMOVE THIS BECAUSE Attempts to classify into public/private, remote/local are confusing. E.g., by public people usually mean Amazon, Google, or Azure, but that's just branded or commercial public -- any other cloud can be public if you just provide it with a static IP and share it. And the remote/local distinction is entangled with it as well -- a personal 'public' cloud is local to you though remote to whoever you're sharing it with. Juju fundamentally just cares about machine vs. K8s. For 'public' it cares only in the sense that you can skip add-cloud for Amazon EC2, Equinix Metal, Google GCE, Microsoft Azure, and ; even there, for aws-gov you do actually have to do add-cloud, and for the rest it doesn't harm to do add-cloud -- it's just not necessary. Also in the sense that we have an update-public-clouds command, but it's not even clear if that does anything for public clouds other than aws, google, and azure, so we might be better off minimizing it, e.g., by turning that command into a flag or something. The only distinction we should introduce prominently is machine vs. K8s, and we should introduce it via our tutorial and HTGs. The smaller differences are inevitable accidents of the fact that cloud foo is not cloud bar, and they will always affect the information you need to supply in the cloud registration step and also the availability of certain constraints, configs, etc.

<a href="#heading--public-clouds-vs--private-local---remote-clouds"><h3 id="heading--public-clouds-vs--private-local---remote-clouds">Public clouds vs. private local / remote clouds</h3></a>

Juju differentiates slightly between **public** and **private** **local** / **remote** clouds in the sense that it will try to anticipate and help you skip steps wherever possible.

From the point of view of a user, this mostly just affects whether you can skip certain steps in the setup phase. For example, if your cloud is a public machine cloud / a local private machine or Kubernetes cloud, and you are a Juju controller `superuser` (the typical case), Juju knows where to retrieve the definition for your cloud / your cloud credentials, so you don't have to provide them to Juju manually.

> See more:  {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`

-->

<a href="#heading--cloud-foo-vs--cloud-bar"><h3 id="heading--cloud-foo-vs--cloud-bar">Cloud foo vs. cloud bar</h3></a>

As a Juju user you will sometimes also notice small differences tied to a cloud's specific identity, beyond the machine-Kubernetes divide. 

This usually affects the setup phase (the information you have to supply to Juju to connect Juju to your cloud, and whether Juju can retrieve any of that automatically for you) and, later on, the customisations you can make to your deployment (e.g., small differences in configurations, constraints, placement directives, subnets, spaces, storage, etc., depending on the features available / supported for a given cloud).

> See more: {ref}`List of supported clouds > `<cloud name>` <list-of-supported-clouds>`

However, note that all Kubernetes clouds are fundamentally the same.

> See more: {ref}`Kubernetes clouds and Juju <kubernetes-clouds-and-juju>`

<a href="#heading--cloud-definition"><h2 id="heading--cloud-definition">Cloud definition</h2></a>

In Juju, cloud definitions can be provided either interactively or via a YAML file or (depending on the cloud) environment variables. 

Regardless of the method, they are saved in a file called `public-clouds.yaml` (for public clouds; on Linux, typically: `~/.local/share/juju/public-clouds.yaml`) or `clouds.yaml` (for user-defined clouds, including Kubernetes; on Linux, the default location is: `~/.local/share/juju/clouds.yaml`).

These files both follow the same basic schema. 


<!--
The `clouds.yaml` file is the file in your Juju installation where Juju stores your cloud definitions. This includes definitions that Juju has already (e.g., for public clouds) as well as any definitions you have provided yourself, either interactively (by typing `juju add-cloud` and then following the interactive prompts) or manually (either via a YAML file or via environment variables).

-->

---
```{dropdown} Expand to view an example 'clouds.yaml' file with a definition for LXD and Amazon EKS

```text
clouds:
  lxd:
    type: lxd
    auth-types:
      - certificate
    endpoint: <endpoint>
    regions:
      default:
        endpoint: <endpoint>
    config:
      apt-http-proxy: <endpoint>
  eks:
    type: kubernetes
    host-cloud-region: ec2/eu-north-1
    auth-types:
      - userpass
      - oauth2
      - clientcertificate
    endpoint: <endpoint>
    regions:
      eu-north-1:
        endpoint: <endpoint>
    config:
      operator-storage: gp2
      workload-storage: gp2
    ca-certificates: <certificates>

```

```
----

<!--
```{important}

This schema is the same across all clouds, 

(1) `auth-types` -- the specific list may vary from cloud to cloud.

(2) `config` -- while the generic model configuration keys are the same across clouds, the cloud-specific keys will naturally vary.

> See more: {ref}`List of supported clouds > `<cloud name>` <list-of-supported-clouds>` 

```
-->

 The rest of this section gives details about this schema.

> [Source](https://github.com/juju/juju/blob/ecd609d9e8700e87f630b6fb8c8b6690f211092d/cloud/clouds.go)

```{note}

The most important keys are `clouds`, `.<cloud name>`, `..type`, `..auth-types`, and `..endpoint`.

```

- [`clouds`](#heading--clouds)
- [`clouds.<cloud>`](#heading--clouds-cloud)
- [`clouds.<cloud>.auth-types`](#heading--clouds-cloud-auth-types)
- [`clouds.<cloud>.ca-certificates`](#heading--clouds-cloud-ca-certificates)
- [`clouds.<cloud>.config`](#heading--clouds-cloud-config)
- [`clouds.<cloud>.description`](#heading--clouds-cloud-description)
- [`clouds.<cloud>.endpoint`](#heading--clouds-cloud-endpoint)
- [`clouds.<cloud>.host-cloud-region`](#heading--clouds-cloud-host-cloud-region)
- [`clouds.<cloud>.identity-endpoint`](#heading--clouds-cloud-identity-endpoint)
- [`clouds.<cloud>.region-config`](#heading--clouds-cloud-region-config)
- [`clouds.<cloud>.regions`](#heading--clouds-cloud-regions)
- [`clouds.<cloud>.regions.<region>`](#heading--clouds-cloud-regions-region)
- [`clouds.<cloud>.regions.<region>.endpoint`](#heading--clouds-cloud-regions-region-endpoint)
- [`clouds.<cloud>.regions.<region>.identity-endpoint`](#heading--clouds-cloud-regions-region-identity-endpoint)
- [`clouds.<cloud>.regions.<region>.storage-endpoint`](#heading--clouds-cloud-regions-region-storage-endpoint)
- [`clouds.<cloud>.storage-endpoint`](#heading--clouds-cloud-storage-endpoint)
- [`clouds.<cloud>.type`](#heading--clouds-cloud-type)

<a href="#heading--clouds"><h3 id="heading--clouds">`clouds`</h3></a>

**Status:** Required.

**Purpose:** To define different clouds.

**Value:** Mapping. Keys are cloud names.

<a href="#heading--clouds-cloud"><h3 id="heading--clouds-cloud">`clouds.<cloud>`</h3></a>

**Status:** Required. 

**Purpose:** To define a cloud.

**Name:** String = the name of the cloud. For built-in clouds and for public clouds, set by Juju; see {ref}`List of supported clouds > `<cloud name>` <list-of-supported-clouds>`. For user-defined clouds, set by the user. 

**Value:** Mapping. Keys are strings = cloud properties.

<a href="#heading--clouds-cloud-auth-types"><h3 id="heading--clouds-cloud-auth-types">`clouds.<cloud>.auth-types`</h3></a>

**Status:** Required.

**Purpose:** To define the authentication types supported by the clouds.

**Value:** Sequence. Items are strings = authentication types supported by the cloud given its cloud type. See more: {ref}`List of supported clouds > `<cloud name>` > Cloud definition <list-of-supported-clouds>`. 

<a href="#heading--clouds-cloud-ca-certificates"><h3 id="heading--clouds-cloud-ca-certificates">`clouds.<cloud>.ca-certificates`</h3></a>

**Status:** Optional.

**Purpose:** To define the Certificate Authority certificates to be used to validate certificates of cloud infrastructure components. 

**Value:** Sequence. Items are strings = base64-encoded x.509 certs.


<a href="#heading--clouds-cloud-config"><h3 id="heading--clouds-cloud-config">`clouds.<cloud>.config`</h3></a>

**Status:** Optional.

**Purpose:** To define a model configuration to use when bootstrapping Juju in the cloud. The configuration will be combined with Juju-generated, and user-supplied values; user-supplied values take precedence.

**Value:** Mapping. Keys are model configuration keys (either generic or cloud-specific).  See more: {ref}`List of model configuration keys <list-of-model-configuration-keys>` and/or {ref}`List of supported clouds > `<cloud>` <list-of-supported-clouds>`.

<a href="#heading--clouds-cloud-description"><h3 id="heading--clouds-cloud-description">`clouds.<cloud>.description`</h3></a>

**Status:** Optional.

**Purpose:** To describe the cloud.

**Value:** String = the cloud description.
 
<a href="#heading--clouds-cloud-endpoint"><h3 id="heading--clouds-cloud-endpoint">`clouds.<cloud>.endpoint`</h3></a>

**Status:** {ref}`TO BE ADDED]

**Purpose:** To define the default endpoint for the cloud regions. Note: It may be overridden by a region.

**Value:** String = the endpoint URL or, for manual clouds, the SSH URI (e.g., `ubuntu@1.2.3.4`).

<a href="#heading--clouds-cloud-host-cloud-region"><h3 id="heading--clouds-cloud-host-cloud-region">`clouds.<cloud>.host-cloud-region`</h3></a>

**Status:** [TO BE ADDED]

**Purpose:** To define the Kubernetes host cloud region. 

**Value:** String = the Kubernetes host cloud region, in the following format: `<cloudType>/<region>`.

<a href="#heading--clouds-cloud-identity-endpoint"><h3 id="heading--clouds-cloud-identity-endpoint">`clouds.<cloud>.identity-endpoint`</h3></a>

**Status:** [TO BE ADDED]

**Purpose:** To define the default identity endpoint for the cloud regions. Note: It may be overridden by a region.

**Value:** String = the default identity endpoint for the cloud regions.

<a href="#heading--clouds-cloud-region-config"><h3 id="heading--clouds-cloud-region-config">`clouds.<cloud>.region-config`</h3></a>

**Status:** Optional.

**Purpose:**  To define a cloud-specific configuration to use when bootstrapping Juju in a specific cloud region. The configuration will be combined with Juju-generated and user supplied values;  user supplied values take precedence.

**Value:** [TO BE ADDED]

<a href="#heading--clouds-cloud-regions"><h3 id="heading--clouds-cloud-regions">`clouds.<cloud>.regions`</h3></a>

**Status:** Optional.

**Purpose:** To define the regions available in the cloud.

**Value:** Mapping. Keys are strings = region names. Cloud-specific.  See more: [List of supported clouds > `<cloud>` <list-of-supported-clouds>`.

<!--
*Type:* Ordered list of regions. The first region will be used as the default region for the cloud. **Value:** Cloud-specific.  See more: {ref}`List of supported clouds > `<cloud>` <list-of-supported-clouds>`.
-->


<a href="#heading--clouds-cloud-regions-region"><h3 id="heading--clouds-cloud-regions-region">`clouds.<cloud>.regions.<region>`</h3></a>

**Value:** String = the name of the region.

<a href="#heading--clouds-cloud-regions-region-endpoint"><h3 id="heading--clouds-cloud-regions-region-endpoint">`clouds.<cloud>.regions.<region>.endpoint`</h3></a>

**Value:** String = the region's primary endpoint URL.

<a href="#heading--clouds-cloud-regions-region-identity-endpoint"><h3 id="heading--clouds-cloud-regions-region-identity-endpoint">`clouds.<cloud>.regions.<region>.identity-endpoint`</h3></a>

The region's identity endpoint URL.  If the cloud/region does not have an identity-specific endpoint URL, this will be empty.

<a href="#heading--clouds-cloud-regions-region-storage-endpoint"><h3 id="heading--clouds-cloud-regions-region-storage-endpoint">`clouds.<cloud>.regions.<region>.storage-endpoint`</h3></a>

The region's storage endpoint URL.  If the cloud/region does not have an storage-specific endpoint URL, this will be empty.

<a href="#heading--clouds-cloud-storage-endpoint"><h3 id="heading--clouds-cloud-storage-endpoint">`clouds.<cloud>.storage-endpoint`</h3></a>

**Status:** Optional.

**Purpose:** To define the default storage endpoint for the cloud regions. Note: It may be overridden by a region.

**Value:** String = the storage endpoint.
 
<a href="#heading--clouds-cloud-type"><h3 id="heading--clouds-cloud-type">`clouds.<cloud>.type`</h3></a>

**Status:** Required.

**Purpose:** To define the type of cloud in Juju.

**Value:** String = the cloud type. See more: {ref}`List of supported clouds > `<cloud>` <list-of-supported-clouds>`.