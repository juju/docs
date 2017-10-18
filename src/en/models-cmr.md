Title: Cross Model Relations

<!--

Introduced terms "shared model" and "consumer model".

Need to add links from other pages.

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

This page presents the **concepts** behind cross model relations as well as
two example **scenarios** that aim to reinforce those concepts through
practical usage.

## Concepts

In this section command syntax may be simplified to keep complexity to a
minimum. See the above CLI help text for full syntax and more examples.

### Offers and endpoints

The idea of an *offer* is key to understanding CMR. Nevertheless, it is quite
easy to grasp. An offer is simply an application that is making itself
available to a consumer application.

An *endpoint* is at either end of the server/client connection and is tacked
on to qualify the offer:

`offer_name:endpoint`

An offer endpoint can be thought of as being analogous to an application
endpoint. An offer also stems from an application endpoint. Here is how an
offer is created:

`juju offer <application>:<application endpoint>`

<!--

There is therefore what is known as a *provides* endpoint (for the service end)
and a *requires* endpoint (for the client end). The latter can also be called a
*target* endpoint.

-->

Although an offer may have multiple endpoints it is always expressed as a
single URL:

`[<controller>:]<user>/<model.offer_name>`

If the 'controller' portion is omitted the current controller is assumed.

### Managing offers

An offer can be removed providing a relation has not been made to it.
Similarly, if an application is being offered it cannot be deleted until all
its offers are removed.

Managing ACL for offers is done with these three access levels:

- read (a user can see the offer when searching)
- consume (a user can relate an application to the offer)
- admin (a user can manage the offer)

These are applied similarly to how standard model access is applied, via the
`juju grant` and `juju revoke` commands:

`juju grant|revoke <user> <access level> <offer url>`

Revoking a user's consume access will result in all relations for that user to
that offer to be suspended. If the consume access is granted anew, each relation
will need to be individually resumed. Suspending and resuming relations are
explained in more detail later.

### Relating to offers

If a user has consume access to an offer, they can deploy an application in
their model and establish a relation to the offer by way of its URL.
The controller part of the URL is optional if the other model resides in
the same controller.

`juju relate <application> <offer url>`

Specifying endpoints for the application and the offer is analogous to normal
relations. They can be added but are often unnecessary.

When an offer is related to, a proxy application is made in the consuming
model, named after the offer.

Note that the relations block in status shows any relevant status information
about the relation to the offer in the Message field. This includes any error
information due to rejected ingress, or if the relation is suspended etc.

<!--

It's possible to consume an offer without relating to it. This creates the
proxy application in the consuming model, which can then be related to
afterwards. Doing it this way enables an alias to be used for the offer, if
there's a need to avoid conflicts with an existing application already deployed
to the consuming model.

juju consume admin/default.mysql mysql-alias
juju relate mediawiki:db mysql-alias

Offers which have been consumed show up in status under the SAAS block.

-->

### Relations and firewalls

The (intended) consumer application may be deployed behind a NAT firewall, such
that traffic egresses through a different address/network to that on which the
consuming application is hosted.

In this case, the relate `--via` option is used to inform the offering side so
that the correct firewall rules can be set up.

`juju relate <application> <offer url> --via <cidr subnet>`

The `--via` value is a comma separated list of subnets in CIDR notation. This
includes the /32 case where a single NATed IP address is used for egress.

It's possible to set up egress subnets as a model config value so that all
cross model relations use those subnets without the need of the `--via` option.

`juju model-config egress-subnets=<cidr subnet>`

### Restricting ingress to the offering model

As we have seen, it's possible for a consuming application to ask for ingress
via an arbitrary subnet. To allow control over what ingress can be applied to
the offering model, an administrator can set up allowed ingress subnets by
creating a firewall rule.

`juju set-firewall-rule juju-application-offer --whitelist <cidr subnet>`

Where 'juju-application-offer' denotes the firewall rule to apply to any offer
in the current model. If a consumer attempts to create a relation with
requested ingress outside the bounds of the whitelist subnet, the relation will
fail.

If the firewall rule is changed, it does not (currently) affect existing
relations. Only new relations will be rejected if the changed firewall rules
preclude the requested ingress.

<!--
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
-->

### Suspending and resuming relations

A relation to an offer may be temporarily suspended, causing the consuming
application to no longer have access to the offer:

`juju suspend-relation <id1>`

A suspended relation is resumed by an admin on the offering side:

`juju resume-relation <id1>`

!!! Note:
    Command `juju list-offers` lists the relation ids.

### Removing relations

To remove a relation entirely:

`juju remove-relation <id1>`

Removing a relation on the offering side will trigger a removal on the
consuming side. A relation can also be removed from the consuming side, as well
as the application proxy, resulting in all relations being removed.

## Example scenarios

The following CMR scenarios will be examined:

- [Scenario #1][scenario-1]
  A MediaWiki deployment, based within the **same** controller, used by the
  **admin** user, but consumed by **multiple** models.
- [Scenario #2][scenario-2]
  A MediaWiki deployment, based within **multiple** controllers, used by a
  **non-admin** user, and consumed by a **single** model.


<!-- LINKS -->

[models]: ./models.html
[charms-relations]: ./charms-relations.html
[scenario-1]: ./models-cmr-scene-1.html
[scenario-2]: ./models-cmr-scene-2.html

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
