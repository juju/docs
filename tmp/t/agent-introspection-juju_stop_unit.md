(agent-introspection-juju_stop_unit)=
# Agent introspection: juju_stop_unit

> See also: {ref}`Agent introspection <agent-introspection>`

```{caution}

**For Kubernetes charms:** <br> This is not currently supported. (In the future it may be supported through Pebble.) 

```

The `juju_stop_unit` introspection function was introduced in 2.9.

In 2.9 the machine and unit agents were combined into a single process running on juju deployed machines. This tools allows you to stop a unit agent running inside of that single process.  It takes a unit name as input. Example output:

```
$ juju_stop_unit neutron-openvswitch/0
neutron-openvswitch/0: stopped
```