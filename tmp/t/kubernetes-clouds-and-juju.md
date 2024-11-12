(kubernetes-clouds-and-juju)=
# Kubernetes clouds and Juju

In Juju, all Kubernetes clouds behave fundamentally the same.

## Notes on `juju add-k8s`

On Kubernetes clouds, both the cloud definition and the cloud credentials are added through `juju add-k8s`, which reads from your kubeconfig file.

### Authentication types


#### certificate
Attributes:
- ClientCertificateData: the kubernetes certificate data (required)
- Token: the kubernetes service account bearer token (required)
- rbac-id: the unique ID key name of the rbac resources (optional)


#### clientcertificate
Attributes:
- ClientCertificateData: the kubernetes certificate data (required)
- ClientKeyData: the kubernetes certificate key (required)
- rbac-id: the unique ID key name of the rbac resources (optional)

#### oauth2
Attributes:
- Token: the kubernetes token (required)
- rbac-id: the unique ID key name of the rbac resources (optional)

#### oauth2withcert
Attributes:
- ClientCertificateData: the kubernetes certificate data (required)
- ClientKeyData: the kubernetes private key data (required)
- Token: the kubernetes token (required)


#### userpass
Attributes:
- username: The username to authenticate with. (required)
- password: The password for the specified username. (required)



## Cloud-specific model configuration keys

### operator-storage
The storage class used to provision operator storage.

| | |
|-|-|
| type | string |
| default value | "" |
| immutable | true |
| mandatory | false |

### workload-storage
The preferred storage class used to provision workload storage.

| | |
|-|-|
| type | string |
| default value | "" |
| immutable | false |
| mandatory | false |

## Supported constraints

> See first: {ref}`Constraint <constraint>`

|||
|-|-|
|conflicting:|`{ref}`instance-type]` vs. `[cores, cpu-power, mem]`|
|supported?||
|- [`allocate-public-ip` <15621md>`|&#10060;|
|- {ref}``arch` <15621md>`|&#10060;|
|- {ref}``container` <15621md>`|&#10060;|
|- {ref}``cores` <15621md>`|&#10060;|
|- {ref}``cpu-power` <15621md>`|:white_check_mark:|
|- {ref}``image-id` <15621md>`|&#10060;|
|- {ref}``instance-role` <15621md>`|&#10060;|
|- {ref}``instance-type` <15621md>`|&#10060;|
|- {ref}``mem` <15621md>`|:white_check_mark:|
|- {ref}``root-disk` <15621md>`|&#10060;|
|- {ref}``root-disk-source` <15621md>`|&#10060;|
|- {ref}``spaces` <15621md>`|&#10060;|
|- {ref}``tags` <15621md>`|:white_check_mark: <br> Used for affinity.|
|- {ref}``virt-type` <15621md>`|&#10060;|
|- {ref}``zones` <15621md>`|&#10060;|


<!--
Sadly, the mem and cpu-power constraints do not properly do what's needed for requests and limits; what we have is very simplistic.
-->

## Placement directives

Placement directives aren't supported on Kubernetes clouds.