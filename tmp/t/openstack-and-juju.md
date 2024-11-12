(openstack-and-juju)=
# OpenStack and Juju

<!--To see the older HTG-style doc, see version 46. Note that it may be out-of-date. -->

> <small > {ref}`List of supported clouds <list-of-supported-clouds>` > OpenStack </small>

This document describes details specific to using your existing OpenStack cloud with Juju. 

> See more: [OpenStack](https://www.openstack.org/) 

When using the OpenStack cloud with Juju, it is important to keep in mind that it is a (1) {ref}`machine cloud <1097md>` and (2) {ref}`not some other cloud <1097md>`. 

> See more: {ref}`Cloud differences in Juju <1097md>`

As the differences related to (1) are already documented generically in our {ref}`Tutorial <get-started-with-juju>`, {ref}`How-to guides <juju-how-to-guides>`, and {ref}`Reference <juju-reference>` docs, here we record just those that follow from (2).

## Supported cloud versions

Any version that supports: <br> - compute v2 (Nova) <br> - network v2 (Neutron) (optional) <br> - volume2 (Cinder) (optional) <br> - identity v2 or v3 (Keystone)

## Notes on `juju add-cloud`

Type in Juju: `openstack`.

Name in Juju: User-defined.

**If you want to use the novarc file (recommended):** <br> Source the OpenStack RC file (`source <path to file>`). This will allow Juju to detect values from preset OpenStack environment variables. Run `add-cloud` in interactive mode and accept the suggested defaults.

## Notes on `juju add-credential`

```{important}

**If you want to use environment variables (recommended):** <br> Source the OpenStack RC file (see above). Run `add-credential` and accept the suggested defaults.

```

### Authentication types

#### `userpass`

Attributes:

- username: The username to authenticate with. (required)
- password: The password for the specified username. (required)
- tenant-name: The OpenStack tenant name. (optional)
- tenant-id: The Openstack tenant ID (optional)
- version: The Openstack identity version (optional)
- domain-name: The OpenStack domain name. (optional)
- project-domain-name: The OpenStack project domain name. (optional)
- user-domain-name: The OpenStack user domain name. (optional)


## Notes on `juju bootstrap`

You will need to create an OpenStack machine metadata. If the metadata is available locally, you can pass it to Juju via `juju bootstrap ... --metadata-source <path to metadata simplestreams`. <br> > See more: {ref}`How to manage metadata <how-to-manage-metadata>` <p> **If your cloud has multiple private networks:** You will need to specify the one that you want the instances to boot from via `juju bootstrap ... --model-default network=<network uuid or name>`. <p> **If your cloud's topology requires that its instances are accessed via floating IP addresses:** Pass the `allocate-public-ip=true` (see constraints below) as a bootstrap constraint.


## Cloud-specific model configuration keys

### external-network
The network label or UUID to create floating IP addresses on when multiple external networks exist.

| | |
|-|-|
| type | string |
| default value | "" |
| immutable | false |
| mandatory | false |

### use-openstack-gbp
Whether to use Neutrons Group-Based Policy

| | |
|-|-|
| type | bool |
| default value | false |
| immutable | false |
| mandatory | false |

### policy-target-group
The UUID of Policy Target Group to use for Policy Targets created.

| | |
|-|-|
| type | string |
| default value | "" |
| immutable | false |
| mandatory | false |

### use-default-secgroup
Whether new machine instances should have the "default" Openstack security group assigned in addition to juju defined security groups.

| | |
|-|-|
| type | bool |
| default value | false |
| immutable | false |
| mandatory | false |

### network
The network label or UUID to bring machines up on when multiple networks exist.

| | |
|-|-|
| type | string |
| default value | "" |
| immutable | false |
| mandatory | false |

## Supported constraints

|Juju points of variation|Notes for the OpenStack cloud|
| --- | --- |
|{ref}`CONSTRAINT <constraint>`||
|conflicting:|`{ref}`instance-type]` vs. `[mem, root-disk, cores]`|
|supported?||
|- [`allocate-public-ip` <1097md>`|:white_check_mark:|
|- {ref}``arch` <1097md>`|:white_check_mark:|
|- {ref}``container` <1097md>`|:white_check_mark:|
|- {ref}``cores` <1097md>`|:white_check_mark:|
|- {ref}``cpu-power` <1097md>`|&#10060;|
|- {ref}``image-id` <1097md>`|:white_check_mark: (Starting with Juju 3.3) <br> Type: String. <br> Valid values: An OpenStack image ID.|
|- {ref}``instance-role` <1097md>`|&#10060;|
|- {ref}``instance-type` <1097md>`|:white_check_mark: <br> Valid values: Any (cloud admin) user defined OpenStack flavor.|
|- {ref}``mem` <1097md>`|:white_check_mark:|
|- {ref}``root-disk` <1097md>`|:white_check_mark:|
|- {ref}``root-disk-source` <1097md>`|:white_check_mark: <br> `root-disk-source` is either `local` or `volume`.|
|- {ref}``spaces` <1097md>`|&#10060;|
|- {ref}``tags` <1097md>`|&#10060;|
|- {ref}``virt-type` <1097md>`|:white_check_mark: <br> Valid values: `{ref}`kvm, lxd]`.|
|- [`zones` <1097md>`|:white_check_mark:|
|{ref}`PLACEMENT DIRECTIVE <placement-directive>`||
|{ref}``<machine>` <1097md>`|TBA|
|{ref}``subnet=...` <1097md>`|&#10060;|
|{ref}``system-id=...` <1097md>`|&#10060;|
|{ref}``zone=...` <1097md>`|:white_check_mark:|
|{ref}`MACHINE <machine>`|--|
|{ref}`RESOURCE (cloud) <how-to-define-cloud-resource-tags-in-a-cloud>` <p> Consistent naming, tagging, and the ability to add user-controlled tags to created instances.|:white_check_mark:|


> <small>Contributors: @acsgn, @gerdner, @hallback, @tmihoc, @wallyworld  </small>