(leader)=
# Leader

> See also:
> - {ref}`Implementing leadership <5461md>`

In Juju, a **leader** (or {ref}`application <application>` leader) is the application {ref}`unit <unit>` that is the authoritative source for an application's status and configuration. Every application is guaranteed to have at most one leader at any given time. Unit {ref}`agents <agent>` will each seek to acquire leadership, and maintain it while they have it or wait for the current leader to drop out. The leader is denoted by an asterisk in the output to `juju status`.