<!--
Todo:
- Add scenario #3: different cloud types
- Add commands to a scenario: grant|revoke, suspend|resume, remove-offer, consume|remove-saas
- 'Managing offers' section could use a rework
- (e.g. summarise management abilities first)
- (e.g. moving some detail to a new scenario)
-->

Cross Model Relations (CMR) allow applications in different models to be related. Recall that traditional relations must abide within the same model. This extends to models hosted on different controllers, and thus in different clouds.

CMR addresses the case where one may wish to centralize services within one model and share them with disparate models. One can imagine models dedicated to tasks such as service monitoring, block storage, and database backends. Another use case would be when you are simply using different cloud types.

The commands related specifically to this subject are:

[`consume`](/t/command-consume/1698)
:   Accepts an offer to a model but does not relate to it.

[`find-offers`](/t/command-find-offers/1722)
:   Finds URLs and endpoints of available offers.

[`list-firewall-rules`](/t/command-list-firewall-rules/1745)
:   Lists the firewall rules.

[`offer`](/t/command-offer/1772)
:   Creates an offer.

[`offers`](/t/command-offers/1773)
:   Lists connected (related to) offers.

[`remove-offer`](/t/command-remove-offer/1788)
:   Removes an offer.

[`remove-saas`](/t/command-remove-saas/1790)
:   Removes a SAAS object created with the `juju consume` command.

[`resume-relation`](/t/command-resume-relation/1799)
:   Resumes a suspended relation to an offer.

[`set-firewall-rule`](/t/command-set-firewall-rule/1811)
:   Sets a firewall rule.

[`show-offer`](/t/command-show-offer/1826)
:   Shows details for a connected (related to) offer.

[`suspend-relation`](/t/command-suspend-relation/1840)
:   Suspends a relation to an offer.

See [Models](/t/models/1155) and [Managing relations](/t/managing-relations/1073) for beginner information on those topics.

This page presents the **concepts** behind cross model relations as well as two example **scenarios** that aim to reinforce those concepts through practical usage.

[note]
The functionality of CMR is not exposed in the GUI at this time.
[/note]

<h2 id="heading--concepts">Concepts</h2>

In this section command syntax may be simplified to keep complexity to a minimum. See the above CLI help text for full syntax and more examples.

<h3 id="heading--terminology">Terminology</h3>

An *offer* is an application that an administrator makes available to applications residing in remote models. The model in which the offer resides is known as the *offering* model.

The application (and model) that utilizes the offer is called the *consuming* application (and consuming model).

Like traditional Juju applications,

- an offer has one or more *endpoints* that denote the features available for that offer.
- a fully-qualified offer endpoint includes the associated offer name:

    `<offer name>:<offer endpoint>`

- a reference to an offer endpoint will often omit the 'offer name' if the context presupposes it.
- an endpoint has an *interface* that satisfies a particular protocol.

<!--
There is therefore what is known as a *provides* endpoint (for the service end)
and a *requires* endpoint (for the client end). The latter can also be called a
*target* endpoint.
-->

<h3 id="heading--creating-offers">Creating offers</h3>

An offer stems from an application endpoint. This is how an offer is created:

`juju offer <application>:<application endpoint>`

Although an offer may have multiple (offer) endpoints it is always expressed as a single URL:

`[<controller>:]<user>/<model.offer_name>`

If the 'controller' portion is omitted the current controller is assumed.

<h3 id="heading--managing-offers">Managing offers</h3>

An offer can be removed providing a relation has not been made to it. To override this behaviour the `--force` option is required, in which case the relation is also removed. This is how an offer is removed:

`juju remove-offer [--force] <offer url>`

Note that if the offer resides in the current model then the shorter offer name can be used instead of the longer URL.

Similarly, if an application is being offered it cannot be deleted until all its offers are removed.

Managing ACL for offers is done with these three access levels:

-   read (a user can see the offer when searching)
-   consume (a user can relate an application to the offer)
-   admin (a user can manage the offer)

These are applied similarly to how standard model access is applied, via the `juju grant` and `juju revoke` commands:

`juju grant|revoke <user> <access level> <offer url>`

Revoking a user's consume access will result in all relations for that user to that offer to be suspended. If the consume access is granted anew, each relation will need to be individually resumed. Suspending and resuming relations are explained in more detail later.

<h3 id="heading--relating-to-offers">Relating to offers</h3>

If a user has consume access to an offer, they can deploy an application in their model and establish a relation to the offer by way of its URL. The controller part of the URL is optional if the other model resides in the same controller.

`juju add-relation <application>[:<application endpoint>] <offer url>[:<offer endpoint>]`

Specifying the endpoint for the application and the offer is analogous to normal relations. They can be added but are often unnecessary:

`juju add-relation <application> <offer url>`

When an offer is related to, a proxy application is made in the consuming model, named after the offer.

Note that the relations block in status shows any relevant status information about the relation to the offer in the Message field. This includes any error information due to rejected ingress, or if the relation is suspended etc.

An offer can be consumed without relating to it. This workflow sets up the proxy application in the consuming model and creates a user-defined alias for the offer. This latter is what's used to subsequently relate to. Having an offer alias can avoid a namespace conflict with a pre-existing application.

`juju consume <offer url> <offer alias>`
`juju add-relation <application> <offer alias>`

Offers which have been consumed show up in `juju status` in the SAAS section. Such an object can be removed in the consuming model with:

`juju remove-saas <offer alias>`

<h3 id="heading--relations-and-firewalls">Relations and firewalls</h3>

When the consuming model is behind a NAT firewall its traffic will typically exit (egress) that firewall with a modified address/network. In this case, the `--via` option can be used with the `juju relate` command to request the firewall on the offering side to allow this traffic. This option specifies the NATed address (or network) in CIDR notation:

`juju add-relation <application> <offer url> --via <cidr subnet>`

It's possible to set this up in advance at the model level in this way:

`juju model-config egress-subnets=<cidr subnet>`

To be clear, the above command is applied to the **consuming** model.

However, an administrator can control what incoming traffic is allowed to contact the offering model by whitelisting subnets:

`juju set-firewall-rule juju-application-offer --whitelist <cidr subnet>`

Where 'juju-application-offer' is a well-known string that denotes the firewall rule to apply to any offer in the current model.

The above command is applied to the **offering** model.

[note type="caution"]
The `juju set-firewall-rule` command only affects subsequently created relations, not existing ones.
[/note]

<!--
To see what ingress is currently in use by relations to an offer, use the
offers command (below).

To see what firewall rules have currently been defined, use the list
firewall-rules command.

```bash
juju firewall-rules
```

```no-highlight
Service                 Whitelist subnets
juju-application-offer  103.37.0.0/16
```

[note]
Beyond a certain number of firewall rules, which have been dynamically
created to allow access from individual relations, Juju will revert to using
the whitelist subnets as the access rules. The number of rules at which this
cutover applies is cloud specific.
[/note]
-->
<h3 id="heading--suspending-and-resuming-relations">Suspending and resuming relations</h3>

A relation to an offer may be temporarily suspended, causing the consuming application to no longer have access to the offer:

`juju suspend-relation <id1>`

A suspended relation is resumed by an admin on the offering side:

`juju resume-relation <id1>`

[note]
Command `juju offers` provides the relation ids.
[/note]

<h3 id="heading--removing-relations">Removing relations</h3>

To remove a relation entirely:

`juju remove-relation <id1>`

Removing a relation on the offering side will trigger a removal on the consuming side. A relation can also be removed from the consuming side, as well as the application proxy, resulting in all relations being removed.

<h2 id="heading--example-scenarios">Example scenarios</h2>

The following CMR scenarios will be examined:

-   [Scenario #1](/t/cmr-scenario-1/1148)
    A MediaWiki deployment, based within the **same** controller, used by the **admin** user, but consumed by **multiple** models.
-   [Scenario #2](/t/cmr-scenario-2/1149)
    A MediaWiki deployment, based within **multiple** controllers, used by a **non-admin** user, and consumed by a **single** model.

<!-- LINKS -->
