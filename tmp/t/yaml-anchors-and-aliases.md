(yaml-anchors-and-aliases)=
# YAML anchors and aliases

YAML *anchors* and *aliases* can be used to stipulate values for certain kinds of objects (usually charm options)  in a central place in a bundle file where they can then be referred to elsewhere in the file.

An anchor is a string prefixed with an ampersand (&) and an alias is the same string but prefixed with an asterisk (*). The object's value is set with the anchor and that value is manifested with the alias. For this to work, anchors must be set before the alias is parsed. For simplicity, just put all the anchors at the very top of the file under an element called `variables`. Here is an example:

```yaml
variables:
  openstack-origin:    &openstack-origin     cloud:bionic-stein
  osd-devices:         &osd-devices          /dev/sdb /dev/vdb
.
.
.
applications:
  ceph-osd:
    charm: ceph-osd
    num_units: 3
    options:
      osd-devices: *osd-devices
      source: *openstack-origin
    to:
    - '1'
    - '2'
    - '3'
.
.
.
```

So in the above excerpt, the `options` section would effectively be treated as:

```yaml
    options:
      osd-devices: /dev/sdb /dev/vdb
      source: cloud:bionic-stein
```