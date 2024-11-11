(the-juju-execution-flow-for-a-charm)=
# The Juju execution flow for a charm

This document describes the Juju execution flow for a Kubernetes / machine [charm](https://juju.is/docs/sdk/charmed-operators).

The Juju [controller](https://juju.is/docs/olm/controller) sends an [event](https://juju.is/docs/sdk/event) to a unit [agent](https://juju.is/docs/olm/agent) that is in the charm container / VM. The unit agent executes the charm according to certain environment variables. When this happens, the environment variables are translated by the operator framework [Ops](https://juju.is/docs/sdk/ops) into the events in the charm code, and the charm then responds with the event handlers in the charm code. All of this is represented schematically in the diagram below, where the top depicts the situation for a Kubernetes charm and the bottom -- for a machine charm.

![image|690x660](upload://5OdbdBmJR6RDKSHp8pcdwfQ1Ay6.png) 


> See more: https://juju.is/docs/sdk/talking-to-a-workload-control-flow-from-a-to-z