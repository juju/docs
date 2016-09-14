Title: Ensuring High Availability (HA) for deployed services  
TODO: Needs a rewrite

# Service High Availability (HA)


## Distribution groups

Juju works with your cloud to ensure that, in the event of an IaaS
outage, not all units of an application will go down at the same time,
maximising your application's availability. 

Each deployed application is considered a 'distribution group'. Every time a
unit is added to a distribution group, Juju will spread out units to best
ensure high availability. As long as the charm and the charm's application are
well written, you can rest assured that IaaS downtime will not affect your
application.

!!! Note: see [High Availability](./controllers-ha.html) for details on
enabling high availability for the controller.

Commands you already use for scaling now ensure your applications are always
available. e.g.

```bash
juju deploy -n 10 <application>
```
The way this works depends on whether Juju uses 'availability zones' or
'availability sets'. 

## Availability Zones

Availability zones allow for the automatic and uniform distribution of units
across a region. A new instance, for example, will be allocated the zone
with the fewest members of its distribution group.

Juju supports such zones on Google Compute Engine, VMware vSphere, Amazon's
EC2, OpenStack-based clouds (Havana or newer) and
[MAAS](http://maas.io/docs/installconfig-zones). See the
[Clouds](./clouds.html) section of the documentation for more details on these
and other cloud-specific settings.

If you do not specify a zone explicitly, Juju will automatically and uniformly
distribute units across the available zones within the region. This can be
overridden with a placement directive:

```bash
juju bootstrap --to zone=us-east-1b
juju add-machine zone=us-east-1c
```
## Azure Availability Sets

Juju supports availability sets on Microsoft's Azure.  As long as at least two
units are deployed, Azure guarantees 99.95% availability of the application
overall.  Exposed ports are automatically load-balanced across all units within
the application.  Using availability sets disables manual placement and the
"add-machine" command.

New Azure environments use availability sets by default. This behaviour can be
disabled only when bootstrapping the cloud by adding
'availability-sets-enabled=false' as a configuration option:

```yaml
juju bootstrap --config availability-sets-enabled=false mycloud azure
```
!!! Note: By disabling availability sets, you will lose Azure's SLA
guarantees. 

Once an environment has been bootstrapped, you cannot change whether it uses
availability sets. You would have to tear it down and create a new
environment.

Availability sets work differently from zones, but serve the same basic
purpose.  With zones, Juju directly ensures each unit of a distribution group
is placed into a different zone.  With sets, Juju places each unit of a
distribution group into the same set, and Azure will then try to ensure that
not all units in the set will become unavailable at the same time.
