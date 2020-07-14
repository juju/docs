

[note status=Provisional]
This page is mostly for my (@timclicks) own interest at this stage. 
[/note]

Juju introduces several networking abstractions. Three important terms to learn if you want to understand more about how Juju interacts with cloud providers are **spaces**, **application endpoints**  and **endpoint bindings** (usually shortened to **endpoints** and **bindings** respectively.)

A **space** is a collection of [subnets](https://en.wikipedia.org/wiki/Subnet) that allow network connectivity between IP addresses within the space.

Spaces are designated with a name. 

**Endpoints** facilitate an application's _binding_ to a space. Applications bound to a space have an IP address within that space for every unit.

All relation names can be used as application endpoints. While useful, this feature can cause confusion. Application endpoints are not relation endpoints.

 also given string names defined by the charm author, rather than a CIDR block. For example, the `keystone` charm defines `public`, `admin` and `internal` bindings. All applications also


Further reading:

- "[Advanced Networking: Deploying OpenStack on MAAS 1.9+ with Juju](http://blog.naydenov.net/2016/06/advanced-networking-deploying-openstack-on-maas-1-9-with-juju/)" (discusses transition to Juju 2.0)
