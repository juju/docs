Introduction
===

Allows the user to specify cloudinit keys to be copied from host machines to containers on the host from the vendor files.

Included in juju 2.4-beta1 as of early Feb.

Using:
--
Caveats related to series: If using a Trusty machine, only Trusty containers will use this feature.  OS type must be the same between machine and container.

Allowed keys are: ca-certs, apt-primary, apt-security, apt-sources.  In xenial and other series (not trusty):
* apt-primary finds:
    apt:
      primary:
        …
* apt-security finds:
    apt:
      security:
        …
* apt-sources finds:
    apt:
      sources:
        …

In trusty apt-security is ignored (unless someone can provide a map):

* apt-primary finds:
    apt_mirror: ...
    apt_mirror_search: ...
    apt_mirror_search_dns: ...
* apt-sources finds:
    apt_sources: ...


`juju model-config container-inherit-properties=”ca-certs, apt-primary”`
