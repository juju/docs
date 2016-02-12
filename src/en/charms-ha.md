Title: Ensuring High Availability (HA) for deployed services  


# Service High Availability (HA)


## Distribution groups
Juju works with OpenStack, Amazon EC2 and Azure providers to ensure that in
the event of an IaaS outage, not all units of a service will go down at the
same time.

Each deployed service is considered a "distribution group", and so are state
servers.  Every time a unit is added to a distribution group, Juju will work to
ensure that the its members are spread out to ensure high availability.  As
long as the charm and the charm's service are well written, you can rest
assured that IaaS downtime will not affect your application.

Commands you already use for scaling now ensure your services are always
available. e.g.

```bash
juju deploy -n 10 <service>
```

The way this works depends on whether Juju uses Availability Zones or
Availability Sets for that provider.


## Availability Zones

Juju supports Availability Zones on Amazon's EC2 and OpenStack-based clouds.
Openstack Havana and newer is supported, which includes HP Cloud. Older
versions of OpenStack are not supported. See the per-provider [Install &
Configure](./getting-started.html) section for more on these and any other
provider-specific settings.

If you do not specify a zone explicitly, Juju will automatically and uniformly
distribute units across the available zones within the region. The spread is
based on density of instance "distribution groups". This can be overridden
with a placement directive:

```bash
juju bootstrap --to zone=us-east-1b
juju add-machine zone=us-east-1c
```


## Azure Availability Sets

Juju supports Availability Sets on Microsoft's Azure.  As long as at least two
units are deployed, Azure guarantees 99.95% availability of the service
overall.  Exposed ports are automatically load-balanced across all units within
the service.  Using availability sets disables manual placement and the
"add-machine" command.

In Juju 1.20 and later, new Azure environments use availability sets by
default. To disable availability sets, the 'availability-sets-enabled' option
must be set in environments.yaml like so:

```yaml
  availability-sets-enabled: false
```

Once an environment has been bootstrapped, you cannot change whether it uses
availability sets.  You would have to tear it down and create a new
environment.

Availability Sets work differently from zones, but serve the same basic
purpose.  With zones, Juju directly ensures each unit of a distribution group
is placed into a different zone.  With sets, Juju places each unit of a
distribution group into the same set, and Azure will then try to ensure that
not all units in the set will become unavailable at the same time.
