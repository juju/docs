(agent-introspection-juju_start_unit)=
# Agent introspection: juju_start_unit

> See also: {ref}`Agent introspection <agent-introspection>`

The `juju_start_unit` introspection function was introduced in 2.9.

In 2.9 the machine and unit agents were combined into a single process running on juju deployed machines. This tools allows you to see the start a stopped unit agent running inside of that single process.  It takes a unit name as input. Example output:

```
$ juju_start_unit neutron-openvswitch/0
neutron-openvswitch/0: started
```