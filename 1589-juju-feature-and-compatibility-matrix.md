[note type=important status=Draft]
This document is not authoritative. If you encounter a mistake, please either make corrections directly, or add a comment below if you would prefer.
[/note]

Juju is an evolving system and supports a wide array of underlying infrastructure. Not all things are possible on all combinations of infrastructure and so this is a general guideline of support for functionality. 



| Provider | Instance Creation | Spaces Management | Storage Management | Firewall Management  |  LXD containers | KVM containers | Container Networking
|---|---|---|---|---|---|---|--|
| MAAS | Y | Y | Y | - | Y | Y | Y
|LXD Localhost| Y | - | Y | - | Y | Y | -
|LXD Cluster| Y | - | Y | Y | Y | Y | - |
|OpenStack|Y | Y | Y | Y | Y | Y | Y
|AWS|Y|Y|Y | - |Y| Y| Y | -
|Google |Y | - | Y | - | Y | Y | - |
|Azure |Y | - | Y | - | Y | Y | - |
|Oracle|Y | - | Y | - | Y | Y | - |
|Manual|-|-|-|-| Y | Y  | - |

# Feature Definitions

## Instance Creation

#### Description

Juju can automatically create machine instances on behalf of an administrator. By default, the `juju deploy` command will use this functionality to automatically provision new capacity.

Providers without this capability require administrators to manually execute `juju add-machine ssh:<user>@<host>` or `juju add-machine winrm:<user>@<host>` to register machines with Juju. 

#### Acceptance Criteria

- `juju add-machine` provisions a new machine when no arguments are supplied
- `juju deploy` provisions a new machine when default arguments are supplied 

## Spaces

#### Description

Networks are modelled by Juju as “spaces”. They enable administrators to prevent specific applications from being directly accessed by the Internet.

#### Acceptance Criteria

The provider supports the following commands:

- `juju add-space` 
- `juju add-subnet`
- `juju bind`
- `juju reload-spaces` 
- `juju subnets` 
- `juju deploy` respects the `spaces` constraint 
- `juju add-machine` respects the `spaces` constraint

#### Further Documentation

https://discourse.jujucharms.com/t/network-spaces/1157

https://discourse.jujucharms.com/t/deploying-applications-advanced/1061

https://discourse.jujucharms.com/t/using-constraints/1060

Storage
===

#### Description

Juju interacts with cloud providers' API to provide persistent storage volumes. 

#### Acceptance Criteria

The provider supports:

- `juju add-storage`
- `juju add-storage-pool`
- `juju import-filesystem`
- `juju remove-storage`
- `juju remove-storage-pool`
- `juju storage`
- `juju storage-pools`
- `juju show-storage` 
- `juju deploy` respects `--attach-storage`
- `juju deploy` respects `--storage`

#### Further Documentation

https://discourse.jujucharms.com/t/using-juju-storage/1079


### Firewalls

#### Description

Juju will manage firewalls and security groups on providers where there is an API to manage. Administrators interact with firewall APIs via the `juju expose` command.

#### Acceptance Criteria

The provider supports:

- `juju expose` interacts with a provider's API to open network access to unit(s)
- `juju unexpose` interacts with a provider's API to restrict network access to unit(s)



## LXD containers

Juju directly supports provisioning LXD containers as machines. This can greatly increase application density.

#### Acceptance criteria 

Provider supports the following commands:

- `juju add-machine lxd`
- `juju deploy --to lxd` 


## KVM containers

Juju directly supports provisioning KVM containers as machines. This can greatly increase application density.

#### Acceptance criteria 

Provider supports the following commands:

- `juju add-machine kvm`
- `juju deploy --to kvm` 


## Container networking

The provider supports container addresses on the same network as their host.

MAAS and OpenStack allow containers request addresses that are on the same network as the host machines. In this way, a workload placed in a LXD container can be reached by any other service on the same network, containerized or not.

<!-- 
TODO: clarify

To provide similar functionality in other clouds, an administrator may deploy a proxy. This set ups the network such that the containers are able to route through to the host machine's networks and as such a proxy service might be brought into play that helps provide routing down into a containerized workload. 
-->


[doc-guidelines]: /t/documentation-guidelines
[discourse-docs-discuss]: /c/docs/docs-discuss
[github-juju-docs-issues]: https://github.com/juju/docs/issues


<!---
TODO

# Operating System Support

| OS | Client |  Controller (`juju bootstrap` works) | Units (`juju add-unit` works) |
|--|--|--|--|
| Ubuntu | Y | Y | Y | 
| CentOS |  |  |  | 
| OpenSUSE |  |  |  | 
| RHEL |  |  |  | 
| Enterprise SUSE |  |  |  | 
| Windows |  |  |  | 
| macOS |  |  |  |

-->
