(zone)=
# Zone

A(n availability) **`zone`** is a  {ref}`constraint <constraint>` or a {ref}`placement directive <placement-directive>` that can be used to customise where the hardware spawned by Juju is provisioned in order to prevent better redundancy in case of an outage. 

The value of the key consists of the zone(s) available for a given cloud. 

When passed as a constraint you may specify a range of zones (via the {ref}``zones` <6695md>` key) whereas when passed as a placement directive you may only specify one zone (via the {ref}``zone` <6695md>` key). If you do both -- that is, there is overlap -- the placement directive takes precedence.

> See more: {ref}`List of supported clouds > `<cloud name>` <list-of-supported-clouds>`

<!--MOVING THIS CONTENT TO THE CLOUD SPECIFIC DOCS
Juju supports such zones on Google Compute Engine, VMware vSphere, Amazon’s EC2, OpenStack-based clouds, and [MAAS ](https://docs.ubuntu.com/maas/en/manage-zones). 

To evenly distribute an application's units across all available zones in a cloud region, Juju  allocates a new unit to the zone that has the fewest number of units of that application already deployed. 

See the {ref}`Supported clouds <list-of-supported-clouds>` page for more details on cloud regions and zones, and other cloud-specific settings.
-->


<!--
One way to select specific availability zones is via a {ref}`constraint <constraint>`. This can be done by running `juju bootstrap`, `juju deploy`, or `juju add-machine` with the `--constraints` option with the `zones` key. Another way is via a {ref}`placement directive <placement-directive>`, by using `juju bootstrap`, `juju deploy`, `juju add-machine` , `juju add-unit` , or  `juju enable-ha` with the `--to` option and the `zone` key. In the case of conflicts, the latter takes precedence.
-->