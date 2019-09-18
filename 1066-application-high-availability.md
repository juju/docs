<!--
Todo:
- Critical: review required
-->

In the event of an outage affecting one's backing cloud, application high availability strives to ensure that not all units of an application will become unresponsive at the same time. This default behaviour in Juju thus maximises your application's availability.

<h2 id="heading--distribution-groups">Distribution groups</h2>

Each deployed application is considered a *distribution group*. Every time a unit is added to a distribution group, Juju will spread out units to best ensure high availability. As long as the charm and the charm's application are well written, you can rest assured that IaaS downtime will not affect your application.

[note]
See [Controller high availability](/t/controller-high-availability/1110) for details on enabling high availability for the controller.
[/note]

Commands you already use for scaling now ensure your applications are always available. e.g.

``` text
juju deploy -n 10 <application>
```

The way this works depends on whether Juju uses availability zones or availability sets.

<h2 id="heading--availability-zones">Availability zones</h2>

Availability zones allow for the automatic and uniform distribution of units across a region. A new instance, for example, will be allocated the zone with the fewest members of its distribution group.

Juju supports such zones on Google Compute Engine, VMware vSphere, Amazon's EC2, OpenStack-based clouds, and [MAAS](https://docs.ubuntu.com/maas/en/manage-zones). See the [Clouds](/t/clouds/1100) page for more details on these and other cloud-specific settings.

If you do not specify a zone explicitly, Juju will automatically and uniformly distribute units across the available zones within the region. This can be overridden with a placement directive:

``` text
juju bootstrap --to zone=us-east-1b
juju add-machine zone=us-east-1c
```

<h2 id="heading--azure-availability-sets">Azure availability sets</h2>

Juju supports availability sets on Microsoft's Azure (see [Using Microsoft Azure with Juju](/t/using-microsoft-azure-with-juju/1086). As long as at least two units are deployed, Azure guarantees 99.95% availability of the application overall. Exposed ports are automatically load-balanced across all units within the application. Using availability sets disables manual placement and the `add-machine` command.

New Azure environments use availability sets by default. This behaviour can be disabled only when bootstrapping the cloud by adding `availability-sets-enabled=false` as a configuration option:

``` text
juju bootstrap --config availability-sets-enabled=false azure mycloud
```

[note]
By disabling availability sets, you will lose Azure's SLA guarantees. See [Azure SLA](https://azure.microsoft.com/en-gb/support/legal/sla/) to learn how availability sets affect uptime guarantees.
[/note]

Once an environment has been bootstrapped, you cannot change whether it uses availability sets. You would have to tear it down and create a new environment.

Availability sets work differently from zones, but serve the same basic purpose. With zones, Juju directly ensures each unit of a distribution group is placed into a different zone. With sets, Juju places each unit of a distribution group into the same set, and Azure will then try to ensure that not all units in the set will become unavailable at the same time.

[note]
Availability sets are not enforced when unit placement (i.e. the `--to` option for the `deploy` or `add-unit` commands) is used.
[/note]

<!-- LINKS -->
