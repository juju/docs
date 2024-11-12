(dynamic-storage)=
# Dynamic storage

><small> {ref}`Storage <storage>` > Dynamic storage </small>
>
> See also: {ref}`Storage provider <storage-provider>`


Most storage can be dynamically added to, and removed from, a unit. Some types of storage, however, cannot be dynamically managed. For instance, Juju cannot disassociate MAAS disks from their respective MAAS nodes. These types of static storage can only be requested at deployment time and will be removed when the machine is removed from the model.

Certain cloud providers may also impose restrictions when attaching storage. For example, attaching an EBS volume to an EC2 instance requires that they both reside within the same availability zone. If this is not the case, Juju will return an error.

When deploying an application or unit that requires storage, using machine placement (i.e. `--to`) requires that the assigned storage be dynamic. Juju will return an error if you try to deploy a unit to an existing machine, while also attempting to allocate static storage.