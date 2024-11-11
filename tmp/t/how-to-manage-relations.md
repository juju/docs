(how-to-manage-relations)=
# How to manage relations

> See also: {ref}`Relation (integration) <relation-integration>`

## Add a relation

<!--TODO: Streamline story, e.g.: Suppose you have two applications, `mysql` and `wordpress`. These applications can only be related in one way-->

The procedure differs slightly depending on whether the applications that you want to integrate are on the same model or rather on different models.

### Add a same-model relation

[tabs]

[tab version="juju"]

To set up a relation between two applications on the same model, run the `integrate` command followed by the names of the applications. For example:

``` text
juju integrate mysql wordpress
```

This will satisfy WordPress's database requirement where MySQL provides the appropriate schema and access credentials required for WordPress to run properly.

The code above however works only if there is no ambiguity in what relation the charm _requires_ and what the related charm _provides_. 

If the charms in question are able to establish multiple relation types, Juju may need to be supplied with more information as to how the charms should be joined. For example, if we try instead to relate the 'mysql' charm to the 'mediawiki' charm:

```text
juju integrate mysql mediawiki 
```

the result is an error:

``` text
error: ambiguous relation: "mediawiki mysql" could refer to
  "mediawiki:db mysql:db"; "mediawiki:slave mysql:db"
```

The solution is to be explicit when referring to an *endpoint*, where the latter has a format of `<application>:<application endpoint>`. In this case, it is 'db' for both applications. However, it is not necessary to specify the MySQL endpoint because only the MediaWiki endpoint is ambiguous (according to the error message). Therefore, the command becomes:

```text
juju integrate mysql mediawiki:db
```
```{note}

The integration endpoints provided or required by a charm are listed in the result of the `juju info` command. They are also listed on the page for the charmed operator at [Charmhub](https://charmhub.io).

```

> See more: {ref}``juju integrate` <command-juju-integrate>`

[/tab]

[tab version="terraform juju"]

To add a same-model relation, create a resource of the `juju_integration` type, give it a label (below, `this`), and in its body add: 
- a `model` attribute specifying the name of the model where you want to create the relation; 
- two `application` blocks, specifying the names of the applications that you want to integrate (and, if necessary, their endpoints_;
- a `lifecycle` block with the `replace_triggered_by` argument specifying the list of application attributes (always the name, model, constraints, placement, and charm name) for which, if they are changed = destroyed and recreated, the relation must be recreated as well.

```{caution}

**To avoid complications (e.g., race conditions) related to how Terraform works:** 

Make sure to always specify resources and data sources by reference rather than directly by name. 

For example, for a resource / data source of type `juju_model` with label `development` and name `mymodel`, do not specify it as `mymodel` but rather as `juju_model.development.name` / `data.juju_model.development.name`.


```


```terraform
resource "juju_integration" "this" {
  model = juju_model.development.name
  via   = "10.0.0.0/24,10.0.1.0/24"

  application {
    name     = juju_application.wordpress.name
    endpoint = "db"
  }

  application {
    name     = juju_application.percona-cluster.name
    endpoint = "server"
  }

  # Add any RequiresReplace schema attributes of
  # an application in this integration to ensure
  # it is recreated if one of the applications
  # is Destroyed and Recreated by terraform. E.G.:
  lifecycle {
    replace_triggered_by = [
      juju_application.wordpress.name,
      juju_application.wordpress.model,
      juju_application.wordpress.constraints,
      juju_application.wordpress.placement,
      juju_application.wordpress.charm.name,
      juju_application.percona-cluster.name,
      juju_application.percona-cluster.model,
      juju_application.percona-cluster.constraints,
      juju_application.percona-cluster.placement,
      juju_application.percona-cluster.charm.name,
    ]
  }
}
```

> See more: [`juju_integration` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration), [Terraform | `lifecycle` > `replace_triggered_by`](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#replace_triggered_by)

[/tab]

[tab version="python libjuju"]
To integrate two applications, on a connected Model, use the `integrate()` method.

```python
await my_model.integrate('mysql', 'mediawiki')

# Integrate with particular endpoints
await my_model.integrate('mysql', 'mediawiki:db')
```

> See more: [`integrate()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.integrate)
{ref}`/tab]
[/tabs]


### Add a cross-model relation
> See also: [Cross-model relation <1073md>`


In a cross-model relation there is also an 'offering' model and a 'consuming' model. The admin of the 'offering' model 'offers' an application for consumption outside of the model and grants an external user access to it. The user on the 'consuming' model can then find an offer to use, consume the offer, and integrate an application on their model with the 'offer' via the same `integrate` command as in the same-model case (just that the offer must be specified in terms of its offer URL or its consume alias). This creates a local proxy for the offer in the consuming model, and the application is subsequently treated as any other application in the model.

> See more: {ref}`How to manage offers > Integrate with an offer <1073md>`

## View all the current relations

{ref}`tabs]
[tab version="juju"]

To view the current relations in the model, run `juju status --relations`. The example below shows a peer relation and a regular relation:

```text
[...]
Relation provider  Requirer       Interface  Type     Message
mysql:cluster      mysql:cluster  mysql-ha   peer     
mysql:db           mediawiki:db   mysql      regular
```

To view just a specific relation and the applications it integrates,  run `juju status --relations` followed by the provider and the requirer application (and endpoint). For example, based on the output above, `juju status --relations mysql mediawiki` would output: 

```text
[...]
Relation provider  Requirer       Interface  Type     Message  
mysql:db           mediawiki:db   mysql      regular
```

> See more: [`juju status --relations` <command-juju-status>`

[/tab]

[tab version="terraform juju"]

The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
To view the current relations in a model, directly access the Model's `relations` property.

```python
my_model.relations
```

> See more: [`Model.relations (property)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.relations)
{ref}`/tab]
[/tabs]

## Get the relation ID

[tabs]
[tab version="juju"]
To get the ID of a relation, for any unit participating in the relation, run the `show-unit` command -- the output will also include the relation ID. For example:

```text
$ juju show-unit synapse/0
  
...
  - relation-id: 7
    endpoint: synapse-peers
    related-endpoint: synapse-peers
   application-data:
      secret-id: secret://1234
    local-unit:
      in-scope: true
```


[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]


## Remove a relation

[tabs]
[tab version="juju"]

Regardless of whether the relation is same-model or cross-model, to remove an relation, run the `remove-relation` command followed by  the names of the two applications involved in the integration:

`juju remove-relation <application-name> <application-name>`

For example:

```text
juju remove-relation mediawiki mysql
```

In cases where there is more than one relation between the two applications, specify the interface at least for one of the applications:

```text
juju remove-relation mediawiki mysql:db
```

> See more: [`juju remove-relation` <command-juju-remove-relation>`

[/tab]

[tab version="terraform juju"]
To remove a relation, in your Terraform plan, remove its resource definition.

> See more: [`juju_integration` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration)

[/tab]

[tab version="python libjuju"]
To remove a relation, use the `remove_relation()` method on an Application object.

```python
await my_app.remove_relation('mediawiki', 'mysql:db')
```

> See more: [`remove_relation()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.remove_relation)
[/tab]
[/tabs]



<br>

> <small>**Contributors:** @amandahla, @aurelien-lourot , @cderici, @danieleprocida, @evilnick , @hmlanigan, @nottrobin , @pedroleaoc, @pmatulis, @tmihoc </small>