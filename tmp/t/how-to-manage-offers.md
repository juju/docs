(how-to-manage-offers)=
# How to manage offers

> See also: {ref}`Offer <offer>`

This document shows how to manage offers.

<!--
This document demonstrates the various steps involved in managing a cross-model integration. The step of adding the integration is the same as for a regular, same-model integration. However, as a cross-model integration may in principle cross controller, cloud, and administrative boundaries, there are additional steps before and after, for making an application accessible from another model, or *offering* it, and for relating to it from the other model, or *consuming* it.

### Central monitoring of model workloads
Assume that we have a number of models for which we want to collect performance metrics using a common prometheus deployment.

We'll deploy prometheus to one model and offer it.
```plain
juju switch bigbrother:voyeur
juju deploy prometheus2
juju expose prometheus2
juju offer prometheus2:target offerprom
```
In a different model, we'll deploy a workload.
```plain
juju switch monitorme
juju deploy ubuntu
juju deploy telegraf
juju integrate ubuntu:juju-info telegraf
```
Now we'll consume the prometheus offer and integrate our workload with it.
```plain
juju consume bigbrother:admin/voyeur.offerprom promed
juju integrate telegraf:prometheus2-client promed:target
```

-->


## Create an offer
> Who: User with {ref}`offer `admin` <1150md>` access.

{ref}`tabs]
[tab version="juju"]

An offer stems from an application endpoint. This is how an offer is created:

`juju offer <application>:<application endpoint>`

By default, an offer is named after its underlying application but you may also choose to give it a different name:

`juju offer <application>:<application endpoint> <offer name>`

Example:
```plain
juju deploy mysql
juju offer mysql:database hosted-mysql
```

To view the available application endpoints use `juju show-application` and  check the list below `endpoint-bindings`. Example:
```plain
juju show-application mysql 
mysql:
  charm: mysql
  ...
  endpoint-bindings:
    "": alpha
    certificates: alpha
    cos-agent: alpha
    database: alpha
    ...
```

To offer both the `certificates` and `database`  endpoints:
```plain
juju deploy mysql
juju offer mysql:database,certificates hosted-mysql
```

Although an offer may have multiple (offer) endpoints it is always expressed as a single URL:

`<user>/<model>.<offer_name>`

If the above mysql offer were made in the `default` model by user `admin`, the URL would be:

`admin/default.hosted-mysql`

> See more: [`juju offer` <command-juju-offer>`

[/tab]
[tab version="terraform juju"]

To create an offer, in your Terraform plan, create a resource of the `juju_offer` type, specifying the offering model and the name of the application and application endpoint from which the offer is created:

```terraform

resource "juju_offer" "percona-cluster" {
  model            = juju_model.development.name
  application_name = juju_application.percona-cluster.name
  endpoint         = server
}

```
> See more: [`juju_offer` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer)

[/tab]
[tab version="python libjuju"]

To create an offer, use the `create_offer()` method on a connected Model object.

```python
# Assume a deployed mysql application
await my_model.deploy('mysql')
# Expose the database endpoint of the mysql application
await my_model.create_offer('mysql:database', offer_name='hosted-mysql')
```

> See more: [`create_offer()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.create_offer)
{ref}`/tab]
[/tabs]

## View an offer’s details
> Who: User with [offer `read`+ <1150md>` access.

{ref}`tabs]
[tab version="juju"]

The `show-offer` command gives details about a given offer.

```plain
juju show-offer <offer name>
```

Example:
```plain
juju show-offer hosted-mysql
Store        URL                         Access  Description                                    Endpoint      Interface         Role
foo          admin/default.hosted-mysql  admin   MySQL is a widely used, open-source            certificates  tls-certificates  requirer
                                                 relational database management system          database      mysql_client      provider
                                                 (RDBMS). MySQL InnoDB cluster provides a                                       
                                                 complete high availability solution for MySQL                                  
                                                 via Group Replic...  
```

For more details, including which users can access the offer, use the `yaml` format.

Example:
```plain
juju show-offer hosted-mysql --format yaml
serverstack:admin/default.hosted-mysql:
  description: |
    MySQL is a widely used, open-source relational database management system
    (RDBMS). MySQL InnoDB cluster provides a complete high availability solution
    for MySQL via Group Replication.

    This charm supports MySQL 8.0 in bare-metal/virtual-machines.
  access: admin
  endpoints:
    certificates:
      interface: tls-certificates
      role: requirer
    database:
      interface: mysql_client
      role: provider
  users:
    admin:
      display-name: admin
      access: admin
    everyone@external:
      access: read
```

A non-admin user with read/consume access can also view an offer's details, but they won't see the information for users with access.

> See more: [`juju show-offer` <command-juju-show-offer>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]

[/tabs]


## Control access to an offer
> Who: User with [offer `admin` <1150md>` access.

{ref}`tabs]

[tab version="juju"]

Offers can have one of three access levels:

-   read (a user can see the offer when searching)
-   consume (a user can relate an application to the offer)
-   admin (a user can manage the offer)

These are applied similarly to how standard model access is applied, via the `juju grant` and `juju revoke` commands:

```plain
juju grant <user> <access-level> <offer-url>
```

```plain
juju revoke <user> <access-level> <offer-url>
```

Revoking a user's consume access will result in all relations for that user to that offer to be suspended. If the consume access is granted anew, each relation will need to be individually resumed. Suspending and resuming relations are explained in more detail later.

To grant bob consume access to an offer:

`juju grant bob consume admin/default.hosted-mysql`

To revoke bob's consume access (he will be left with read access):

`juju revoke bob consume admin/default.hosted-mysql`

To revoke all of bob's access:

`juju revoke bob read admin/default.hosted-mysql`

> See more: [`juju grant` <command-juju-grant>`, {ref}``juju revoke` <command-juju-revoke>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The access levels for offers can be applied in the same way the model or controller access for a given user. Use the `grant()` and `revoke()` methods on a User object to grant or revoke access to an offer.

```python
# Grant Bob consume access to an offer
await user_bob.grant('consume', offer_name='admin/default.hosted-mysql')

# Revoke Bob's consume access (he will be left with read access)
await user_bob.revoke('consume', offer_name='admin/default.hosted-mysql')
```

<!-- TODO (cderici): links for these methods will be added when pylibjuju docs are generated. -->
> See more: [`User (object)` <1150md>`, {ref}``grant()` <1150md>`, {ref}``revoke()` <1150md>`
{ref}`/tab]

[/tabs]

## Find an offer to use
> Who: User with [offer `read`+ <1150md>` access

{ref}`tabs]

[tab version="juju"]

Offers can be searched based on various criteria:

* URL (or part thereof)
* offer name
* model name
* interface

The results will show information about the offer, including the level of access the user making the query has on each offer.

To find all offers on a specified controller:
```plain
$ juju find-offers foo:
Store  URL                         Access  Interfaces
foo    admin/default.hosted-mysql  admin   mysql:database
foo    admin/default.postgresql    admin   pgsql:db
```
As with the `show-offer` command, the `yaml` output will show extra information, including users who can access the offer (if an admin makes the query).
```plain
juju find-offers --offer hosted-mysql --format yaml
foo:admin/default.hosted-mysql:
  access: admin
  endpoints:
    certificates:
      interface: tls-certificates
      role: requirer
    database:
      interface: mysql_client
      role: provider
  users:
    admin:
      display-name: admin
      access: admin
    bob:
      access: read
    everyone@external:
      access: read
```

To find offers in a specified model:
```plain
juju find-offers admin/another-model
juju find-offers foo:admin/another-model
```

To find offers with a specified interface on the current controller:
```plain
juju find-offers --interface mysql_client
juju find-offers --interface tls-certificates
```

To find offers with a specified interface on a specific controller:
```plain
juju find-offers --interface mysql_client foo:
```

To find offers with "sql" in the name:
```plain
$ juju find-offers --offer sql foo:
```

> See more: [`juju find-offers` <command-juju-find-offers>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]

[/tabs]

## Integrate with an offer
> Who: User with [offer `consume`+ <1150md>` access.

{ref}`tabs]

[tab version="juju"]

```{important}


Before Juju `3.0`, `juju integrate` was `juju relate`.


```

If a user has consume access to an offer, they can deploy an application in their model and establish an integration with the offer by way of its URL. 

```plain
juju integrate <application>[:<application endpoint>] <offer-url>[:<offer endpoint>]
```

Specifying the endpoint for the application and the offer is analogous to normal integrations. They can be added but are often unnecessary:

```plain
juju integrate <application> <offer-url>
```

When you integrate with an offer, a proxy application is made in the consuming model, named after the offer.

An offer can be consumed without integration. This workflow sets up the proxy application in the consuming model and creates a user-defined alias for the offer. This latter is what's used to subsequently relate to. Having an offer alias can avoid a namespace conflict with a pre-existing application.

```plain
juju consume <offer-url> <offer-alias>
juju integrate <application> <offer alias>
```

Offers which have been consumed show up in `juju status` in the SAAS section. The integrations (relations) block in status shows any relevant status information about the integrations to the offer in the Message field. This includes any error information due to rejected ingress, or if the relation is suspended etc.

To remove a consumed offer:

```plain
juju remove-saas <offer alias>
```
> See more: [`juju integrate` <command-juju-integrate>`, {ref}``juju consume` <command-juju-consume>`, {ref}``juju remove-saas` <command-juju-remove-saas>`

[/tab]

[tab version="terraform juju"]
To integrate with an offer, in your Terraform plan create a `juju_integration` resource as usual by specifying two application blocks and a `lifecycle > replace_triggered_by` block, but for the application representing the offer specify the `offer_url`, and in the `lifecycle` block list triggers only for the regular application (not the offer). For example:

```terraform
resource "juju_integration" "wordpress-db" {
  model = juju_model.development-destination.name

  application {
    name     = juju_application.wordpress.name
    endpoint = "db"
  }

  application {
    offer_url = juju_offer.this.url
  }

lifecycle {
    replace_triggered_by = [
      juju_application.wordpress.name,
      juju_application.wordpress.model,
      juju_application.wordpress.constraints,
      juju_application.wordpress.placement,
      juju_application.wordpress.charm.name,
    ]
  }

}

```

> See more: [`juju_integration` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration)

[/tab]

[tab version="python libjuju"]
To integrate with an offer, use the `Model.integrate()` method on a connected model, with a consumed offer url.

```python
# Integrate via offer url
await my_model.integrate('mediawiki:db', 'admin/default.hosted-mysql')

# Integrate via an offer alias created when consumed
await my_model.consume('admin/prod.hosted_mysql', application_alias="mysql-alias")
await my_model.integrate('mediawiki:db', 'mysql-alias')

# Remove a consumed offer:
await my_model.remove_saas('mysql-alias')
```
> See more: [`Model.integrate()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.integrate), [`Model.consume()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.consume), [`Model.remove_saas()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.remove_saas)
{ref}`/tab]

[/tabs]

## Allow traffic from an integrated offer
> Who: User with [offer `admin` <1150md>` access.

{ref}`tabs]

[tab version="juju"]

When the consuming model is behind a NAT firewall its traffic will typically exit (egress) that firewall with a modified address/network. In this case, the `--via` option can be used with the `juju integrate` command to request the firewall on the offering side to allow this traffic. This option specifies the NATed address (or network) in CIDR notation:

```plain
juju integrate <application> <offer url> --via <cidr subnet(s)>
```

Example:
`juju integrate mediawiki:db ian:admin/default.mysql --via 69.32.56.0/8`

The `--via` value is a comma separated list of subnets in CIDR notation. This includes the /32 case where a single NATed IP address is used for egress.

It's also possible to set up egress subnets as a model config value so that all cross model integrations use those subnets without needing to use the `--via` option.

```plain
juju model-config egress-subnets=<cidr subnet>
```

Example:
`juju model-config egress-subnets=69.32.56.0/8`

To be clear, the above command is applied to the **consuming** model.

To allow control over what ingress can be applied to the offering model, an administrator can set up allowed ingress subnets by creating a firewall rule.

```plain
juju set-firewall-rule juju-application-offer --whitelist <cidr subnet>
```

Where 'juju-application-offer' is a well-known string that denotes the firewall rule to apply to any offer in the current model. If a consumer attempts to create a relation with requested ingress outside the bounds of the whitelist subnets, the relation will fail and be marked as in error.

The above command is applied to the **offering** model.

Example:
`juju set-firewall-rule juju-application-offer --whitelist 103.37.0.0/16`

```{note}

The `juju set-firewall-rule` command only affects subsequently created relations, not existing ones. Only new relations will be rejected if the changed firewall rules preclude the requested ingress.

```

To see what firewall rules have currently been defined, use the list firewall-rules command.

Example:
```plain
juju firewall-rules
Service                 Whitelist subnets
juju-application-offer  103.37.0.0/16
```

```{note}

Beyond a certain number of firewall rules, which have been dynamically created to allow access from individual integrations, Juju will revert to using the whitelist subnets as the access rules. The number of rules at which this cutover applies is cloud specific.

```


> See more: [`juju set-firewall-rule` <command-juju-set-firewall-rule>`, {ref}``juju firewall-rules` <command-juju-firewall-rules>`

[/tab]

[tab version="terraform juju"]
To allow traffic from an integrated offer, in your Terraform plan, in the resource definition where you define the integration with an offer, use the `via` attribute to specify the list of CIDRs for outbound traffic. For example:



```terraform
resource "juju_integration" "this" {
...
  via   = "10.0.0.0/24,10.0.1.0/24"

# the rest of your integration definition

}

```

> See more: [`juju_integration` > `via`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration#via)

{ref}`/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]

[/tabs]

## Inspect integrations with an offer
> Who: User with [offer `admin` <1150md>` access.

> See also: {ref}``offers` <1150md>`

{ref}`tabs]

[tab version="juju"]

The `offers` command is used to see all connections to one more offers.

```plain
juju offers [--format (tabular|summary|yaml|json)] [<offer name>]
```

If `offer name` is not provided, all offers are included in the result.

The default `tabular` output shows each user connected (relating to) the offer, the 
relation id of the relation, and ingress subnets in use with that connection. The `summary` output shows one row per offer, with a count of active/total relations. Use the `yaml` output to see extra detail such as the UUID of the consuming model.

The output can be filtered by:
 - interface: the interface name of the endpoint
 - application: the name of the offered application
 - connected user: the name of a user who has an integration to the offer
 - allowed consumer: the name of a user allowed to consume the offer
 - active only: only show offers which are in use (are related to)

See `juju help offers` for more detail.

Example:
```plain
juju offers mysql
Offer  User   Relation id  Status  Endpoint  Interface  Role      Ingress subnets
mysql  admin  2            joined  db        mysql      provider  69.193.151.51/32

juju offers --format summary
Offer         Application  Charm        Connected  Store   URL                      Endpoint  Interface  Role
hosted_mysql  mysql        ch:mysql-57  1/1        myctrl  admin/prod.hosted_mysql  db        mysql      provider

```

All offers for a given application:
`juju offers --application mysql`

All offers for a given interface:
`juju offers --interface mysql`

All offers for a given user who has related to the offer:
`juju offers --connected-user fred`

All offers for a given user who can consume the offer:
`juju offers --format summary --allowed-consumer mary`

The above command is best run with `--format` summary as the intent is to see, for a given user, what offers they might relate to, regardless of whether there are existing integrations (which is what the tabular view shows).

> See more: [`juju offers` <command-juju-offers>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To see all connections to one or more offers, use the `list_offers()` method on a connected Model object.

```python
await my_model.list_offers()
```

> See more: [`list_offers()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.list_offers)
{ref}`/tab]

[/tabs]

## Suspend, resume, or remove an integration with an offer
> Who: User with [offer `admin` <1150md>` access.

{ref}`tabs]

[tab version=juju]

Before you can suspend, resume, or remove an integration (relation), you need to know the integration (relation) ID. (That is because, once you've made an offer, there could potentially be many instances of the same application integrating with that offer, so the only way to identify uniquely is via the relation ID.)

Given two related apps (app1: endpoint, app2), the integration (relation) ID can be found as follows:

<!--COMMENT: DOESN'T WORK FOR EVERYTHING
```{note}

Command `juju offers` provides the relation ids. Active relations have a status "joined".

```
-->


```plain
juju exec --unit $UNIT_FOR_APP1 -- relation-ids endpoint
```

The output, `<ENDPOINT>:<REL_ID>`, gives you the relation id.

Once you have the integration (relation) id:

To suspend an integration (relation), do:


```plain
juju suspend-relation <id1>
```

```{note}


Suspended integrations (relations) will run the relation departed / broken hooks on either end, and any firewall ingress will be closed.


```


And, to resume an integration (relation), do:

```plain
juju resume-relation <id1>
```

Finally, to remove an integration (relation) entirely:

```plain
juju remove-relation <id1>
```

```{note}

Removing an integration on the offering side will trigger a removal on the consuming side. An integration can also be removed from the consuming side, as well as the application proxy, resulting in all integrations being removed.

```

```{note}

In all cases, more than one integration id can be specified, separated by spaces.

```

Examples:
```plain
juju suspend-relation 2 --message "reason for suspension"
juju suspend-relation 3 4 5 --message "reason for suspension"
juju resume-relation 2
```

> See more: [`juju suspend-relation` <command-juju-suspend-relation>`, {ref}``juju resume-relation` <command-juju-resume-relation>`, {ref}``juju remove-relation` <command-juju-remove-relation>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support suspending, and resuming integrations. However, to remove an integration, you can use the `remove_relation()` method on an Application object. 

```python
await my_controller.remove_integration('mediawiki', 'mysql:db')
```

> See more: [`remove_relation()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.remove_relation)
{ref}`/tab]

[/tabs]

## Remove an offer
> Who: User with [offer `admin` <1150md>` access.

{ref}`tabs]

[tab version="juju"]


An offer can be removed providing it hasn't been used in any integration. To override this behaviour the `--force` option is required, in which case the  integration is also removed. This is how an offer is removed:

`juju remove-offer [--force] <offer-url>`

Note that, if the offer resides in the current model, then the shorter offer name can be used instead of the longer URL.

Similarly, if an application is being offered, it cannot be deleted until all its offers are removed.


> See more: [`juju remove-offer` <command-juju-remove-offer>`

[/tab]

[tab version="terraform juju"]

To remove an offer, in your Terraform plan, remove its resource definition.

> See more: [`juju_offer`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer)

[/tab]

[tab version="python libjuju"]
To remove an offer, use the `remove_offer()` method on a connected Model. If the offer is used in an integration, then the `force=True` parameter is required to remove the offer, in which case the integration is also removed.

```python
await my_model.remove_offer('admin/mymodel.ubuntu', force=True)
```

> See more: [`remove_offer()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.remove_offer)

{ref}`/tab]

[/tabs]



---------------
**Further reading**

For more on cross-model relations, see the following scenarios:

-   [Scenario #1 <1150md>`
    A MediaWiki deployment, based within the **same** controller, used by the **admin** user, but consumed by **multiple** models.
-   {ref}`Scenario #2 <1150md>`
    A MediaWiki deployment, based within **multiple** controllers, used by a **non-admin** user, and consumed by a **single** model.

-------

<br>

> <small>**Contributors:** @anvial, @cderici, @hmlanigan, @manadart, @simonrichardson, @tmihoc </small>