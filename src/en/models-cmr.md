Title: Cross Model Relations

<!--

Commands 'find-endpoints' and 'offer' are not yet available in commands.md.

Introduced terms "shared model" and "consumer model".

How to determine a unit's interface (e.g. mysql:db)?

Need to add links from other pages.

Also 'show-endpoints' and 'offers' (admin sees more).

Multi CMR controllers are now allowed it seems.

See wallyworld

-->

# Cross Model Relations

Cross Model Relations (CMR) allow applications in different models to be
related. Recall that traditional relations must abide within the same model.
This extends to models hosted on different controllers, and thus in different
clouds.

CMR addresses the case where one may wish to centralize services within one
model and share them with disparate models. One can imagine models dedicated to
tasks such as service monitoring, block storage, and database backends.

The commands related specifically to this subject are:

[`consume`][commands-consume]
: Adds a remote offer to a model.

[`find-offers`][commands-find-offers]
: Finds offered application endpoints.

[`list-firewall-rules`][commands-list-firewall-rules]
: Prints the firewall rules.

[`list-offers`][commands-list-offers]
: Lists shared endpoints.

[`offer`][commands-offer]
: Offers application endpoints for use in other models.

[`remove-offer`][commands-remove-offer]
: Removes one or more offers.

[`resume-relation`][commands-resume-relation]
: Resumes a suspended relation to an application offer.

[`set-firewall-rule`][commands-set-firewall-rule]
: Sets a firewall rule.

[`show-offer`][commands-show-offer]
: Shows offered applications' endpoints details.

[`suspend-relation`][commands-suspend-relation]
: Suspends a relation to an application offer.

See [Models][models] and [Managing relations][charms-relations] for beginner
information on those topics.

## Example scenarios

The following CMR scenarios will be examined:

- [Scenario #1](./models-cmr-scene-1.html)  
  A MediaWiki deployment, based within the **same** controller, used by the
  **admin** user, but consumed by **multiple** models.
- [Scenario #2](./models-cmr-scene-2.html)  
  A MediaWiki deployment, based within **multiple** controllers, used by a
  **non-admin** user, and consumed by a **single** model.

## Concepts

Here we'll explain the main concepts of Cross model relations.

### Offers and endpoints

The idea of an *offer* is key to understanding CMR. Nevertheless, it is quite
easy to grasp. An offer is simply a service that is making itself available to
some kind of client (or consumer).

An *endpoint* is at either end of the server:client connection. There is
therefore what is known as a *provides* endpoint (for the service end) and a
*requires* endpoint (for the client end). The latter can also be called a
*target* endpoint.

An offer consists of one or more endpoints for a given application and
is expressed as a URL. It is of the form:

`controller:user/model.offername`

### Managing offers

An offer can be removed providing a relation has not been made to it.
Similarly, if an application is being offered it cannot be deleted until the
offer is removed.

Managing who can partake in an offer is dictated by three access levels:

- read (a user can see the offer when searching)
- consume (a user can relate an application to the offer)
- admin (a user can manage the offer)

Grant/resume works the same way as for models.

To grant bob consume access to an offer:

```bash
juju grant bob consume admin/default.mysql
```

To revoke bob's consume access (he will be left with read access):

```bash
juju revoke bob consume admin/default.mysql
```

To revoke all of bob's access:

```bash
juju revoke bob read admin/default.mysql
```

Note: revoking a user's consume access will result in all relations for that
user to the offer to be suspended (see suspending relations). If the consume
access to the offer is granted again, each relation will need to be
individually resumed by an admin.

## Relating to (consuming) offers

If a user has consume access to an offer, they can deploy an application in
their model and establish a relation to the offer. The offer is referenced
using its URL. The controller part of the URL is optional if the other model is
in the same controller. Assuming a "mysql" offer has been made in other model
called "admin/default":

```bash
juju deploy mediawiki
juju relate mediawiki:db admin/default.mysql
```

The user part of the offer's model path is optional if the same user who made
the offer is now also consuming it.

When an offer is related to in this way, a proxy application is made in the
consuming model, named after the offer, in this case "mysql". 

It's possible to consume an offer without relating to it. This creates the
proxy application in the consuming model, which can then be related to
afterwards. Doing it this way enables an alias to be used for the offer, if
there's a need to avoid conflicts with an existing application already deployed
to the consuming model.

```bash
juju consume admin/default.mysql mysql-alias
juju relate mediawiki:db mysql-alias
```

Offers which have been consumed show up in status under the SAAS block.

```bash
juju status
```

```no-highlight
Model    Controller  Cloud/Region  Version       SLA
default  foo         lxdq          2.3-alpha1.1  unsupported

SAAS   Status   Store   URL
mysql  unknown  ianaws  admin/default.mysql

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports   Message
mediawiki/0*  active    idle   0        10.200.103.121  80/tcp  Ready

Machine  State    DNS             Inst id        Series  AZ  Message
0        started  10.200.103.121  juju-16fc34-0  trusty      Running

Relation provider  Requirer      Interface  Type     Message
mysql:db           mediawiki:db  mysql      regular 
```

Note that the relations block in status shows any relevant status information
about the relation to the offer in the Message field. This includes any error
information due to rejected ingress, or if the relation is suspended etc.

### Relating to offers from behind a firewall

Sometimes, the consuming application is deployed behind a firewall where NAT is
used, such that traffic egresses via a different address/network to that on
which the consuming application is hosted.

In this case, the relate --via option is used to inform the offering side so
that the correct firewall rules can be set up.

```bash
juju relate mediawiki:db ian:admin/default.mysql --via 69.32.56.0/8
```

The --via value is a comma separated list of subnets in CIDR notation. This
includes the /32 case where a single NATed IP address is used for egress.

It's also possible to set up egress subnets as a model config value so that all
cross model relations use those subnets without needing to use the --via
option.

```bash
juju model-config egress-subnets=69.32.56.0/8
```

### Restricting Ingress

As we have seen, it's possible for a consuming application to ask for ingress
via an arbitrary subnet. To allow control over what ingress can be applied to
the offering model, an administrator can set up allowed ingress subnets by
creating a firewall rule.

```bash
juju set-firewall-rule juju-application-offer --whitelist 103.37.0.0/16
```

"juju-application-offer" is the well known service name that specifies the
firewall rule applies to any offer in the current model. If a consumer attempts
to create a relation with requested ingress outside the bounds of the whitelist
subnets, the relation will fail and be marked as in error.

If the firewall rule is changed, it does not (currently) affect existing
relations. Only new relations will be rejected if the changed firewall rules
preclude the requested ingress.

To see what ingress is currently in use by relations to an offer, use the
list-offers command (below).

To see what firewall rules have currently been defined, use the list
firewall-rules command.

```bash
juju firewall-rules
```

```no-highlight
Service                 Whitelist subnets
juju-application-offer  103.37.0.0/16
```

!!! Note:
    Beyond a certain number of firewall rules, which have been dynamically
    created to allow access from individual relations, Juju will revert to using
    the whitelist subnets as the access rules. The number of rules at which this
    cutover applies is cloud specific.

### Suspending relations

Individual relations (connections) to an offer may be temporarily suspended.
Suspended relations will run the relation departed / broken hooks on either
end, and any firewall ingress will be closed.

Relations are suspended by specifying the relation id(s). More than one
relation id can be specified, separated by spaces. Use juju offers to see the
relation ids; active relations have a status "joined". 

```bash
juju suspend-relation 2 --message "reason for suspension"
```

or

```bash
juju suspend-relation 2 3 4 --message "reason for suspension"
```

```bash
juju offers mysql
```

```no-highlight
Offer  User   Relation id  Status     Endpoint  Interface  Role      Ingress subnets
mysql  admin  2            suspended  db        mysql      provider  69.193.151.51/32
```

The message is optional. If specified, it will be reflected in the relation
status in the consuming model.

```bash
juju status -m foo
```

```no-highlight
Model    Controller  Cloud/Region  Version       SLA
default  foo         lxdq          2.3-alpha1.1  unsupported

SAAS   Status   Store   URL
mysql  unknown  ianaws  admin/default.mysql

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  blocked      1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports  Message
mediawiki/0*  blocked   idle   0        10.200.103.121         Database required

Machine  State    DNS             Inst id        Series  AZ  Message
0        started  10.200.103.121  juju-16fc34-0  trusty      Running

Relation provider  Requirer      Interface  Type     Message
mysql:db           mediawiki:db  mysql      regular  suspended   - reason for suspension 
```

### Resuming relations

Suspended relations can then be resumed by an admin on the offering side.

```bash
juju resume-relation 2
```

or

```bash
juju resume-relation 2 3 4
```

### Removing relations to an offer

If a relation needs to be removed entirely, instead of just being suspended:

```bash
juju remove-relation 2
```

Removing a relation on the offering side will propagate the deletion to the
consuming side. The relation can also be removed from the consuming side. Also
on the consuming side, the application proxy can be removed, resulting in all
relations also being removed.


<!-- LINKS -->

[models]: ./models.html
[charms-relations]: ./charms-relations.html

[commands-consume]: ./commands.html#consume
[commands-find-offers]: ./commands.html#find-offers
[commands-list-firewall-rules]: ./commands.html#list-firewall-rules
[commands-list-offers]: ./commands.html#list-offers
[commands-offer]: ./commands.html#offer
[commands-remove-offer]: ./commands.html#remove-offer
[commands-resume-relation]: ./commands.html#resume-relation
[commands-set-firewall-rule]: ./commands.html#set-firewall-rule
[commands-show-offer]: ./commands.html#show-offer
[commands-suspend-relation]: ./commands.html#suspend-relation
