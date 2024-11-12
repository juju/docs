(base)=
# Base

> Starting with Juju 3.1, a 'base' replaces the older notion of 'series'.

In Juju, a **base** is  a way to identify a particular operating system (OS) image for a Juju {ref}`machine <machine>`. 

This can be done via the name of the OS followed by the `@` symbol and the channel of the OS that you want to target, specified in terms of `<track>` or, optionally, `<track>/<risk>`. For example, `ubuntu@22.04` or `ubuntu@22.04/stable`.

<!--If we link to the doc on Channel https://juju.is/docs/sdk/channel , we need to specify that the notion of `branch` is not relevant here. -->