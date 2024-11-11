(how-to-manage-secrets)=
# How to manage secrets

> See also: {ref}`Secret <secret>`

Charms can use relations to share secrets, such as API keys, a database’s address, credentials and so on. This document demonstrates how to interact with them as a Juju user. 

```{caution}

The write operations are only available (a) starting with Juju 3.3 and (b) to model admin users looking to manage user-owned secrets. See more: {ref}`Secret <secret>`.

```

**Contents:**

- [Add a secret](#heading--add-a-secret)
- [View all the available secrets](#heading--view-all-the-available-secrets)
- [View details about a secret](#heading--view-details-about-a-secret)
- [Grant access to a secret](#heading--grant-access-to-a-secret)
- [Update a secret](#heading--update-a-secret)
- [Remove a secret](#heading--remove-a-secret)

<a href="#heading--add-a-secret"><h2 id="heading--add-a-secret">Add a secret</h2></a>


{ref}`tabs]
[tab version="juju"]

To add a (user) secret, run the `add-secret` command followed by a secret name and a (space-separated list of) key-value pair(s). This will return a secret ID. For example:

```text
$ juju add-secret dbpassword foo=bar
secret:copp9vfmp25c77di8nm0
```

The command also allows you to specify the type of key, whether you want to supply its value from a file, whether you want to give it a label, etc.

> See more: [`juju add-secret` <command-juju-add-secret>`

[/tab]

[tab version="terraform juju"]
To add a (user) secret on the controller specified in the juju provider definition, in your Terraform plan create a resource of the `juju_secret` type, specifying, at the very least, a model, the name of the secret, a values map and, optionally, an info field. For example:

```terraform
resource "juju_secret" "my-secret" {
  model = juju_model.development.name
  name  = "my_secret_name"
  value = {
    key1 = "value1"
    key2 = "value2"
  }
  info = "<description of the secret>"
}
```

> See more: [`juju_secret` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/secret)

[/tab]

[tab version="python libjuju"]
To add a (user) secret, on a connected Model, use the `add_secret()` method, passing the name of the secret and the data as arguments. For example:

```python
await model.add_secret(name='my-apitoken', data_args=['token=34ae35facd4'])
```

> See more: [`add_secret()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.add_secret), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
{ref}`/tab]
[/tabs]

<a href="#heading--view-all-the-available-secrets"><h2 id="heading--view-all-the-available-secrets">View all the available secrets</h2></a>


[tabs]
[tab version="juju"]

To view all the (user and charm) secrets available in a model, run:

```text
juju secrets
```

You can also add options to specify an output format, a model other than the current model, an owner, etc.

> See more: [`juju secrets` <command-juju-secrets>`
[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
To view all the (user and charm) secrets available in a model, on a connected Model, use the `list_secrets()` method.

```python
await model.list_secrets()
```

> See more: [`list_secrets()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.list_secrets), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
{ref}`/tab]
[/tabs]


<a href="#heading--view-details-about-a-secret"><h2 id="heading--view-details-about-a-secret">View details about a secret</h2></a>


[tabs]
[tab version="juju"]

To drill down into a (user or charm) secret, run the `show-secret` command followed by the secret name or ID. For example:

```text
juju show-secret 9m4e2mr0ui3e8a215n4g
```

You can also add options to specify the format, the revision, whether to reveal the value of a secret, etc.

> See more: [`juju show-secret` <command-juju-show-secret>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--grant-access-to-a-secret"><h2 id="heading--grant-access-to-a-secret">Grant access to a secret</h2></a>


[tabs]
[tab version="juju"]

Given a charm that has a configuration option that allows it to be configured with a user secret, to grant the application deployed from it access to the secret, run the `grant-secret` command followed by the secret name or ID and by the name of the application. For example:

```text
juju grant-secret dbpassword mysql
```

Note that this only gives the application *permission* to use the secret, so you must follow up by giving the application the secret itself, by setting its relevant secret-relation configuration  option to the secret URI:

```text
juju config <application> <option>=<secret URI>
```

> See more: [`juju grant-secret` <command-juju-grant-secret>`


[/tab]

[tab version="terraform juju"]
Given a model that contains both your (user) secret and the application(s) that you want to grant access to, to grant the application(s) access to the secret, in your Terraform plan create a resource of the `juju_access_secret` type, specifying the model, the secret ID, and the application(s) that you wish to grant access to. For example:

```
resource "juju_access_secret" "my-secret-access" {
  model = juju_model.development.name

  # Use the secret_id from your secret resource or data source.
  secret_id = juju_secret.my-secret.secret_id

  applications = [
    juju_application.app.name, juju_application.app2.name
  ]
}

```

> See more: [`juju_access_secret` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/access_secret)

[/tab]

[tab version="python libjuju"]
Given a model that contains both your (user) secret and the application(s) that you want to grant access to, to grant the application(s) access to the secret, on a connected Model, use the `grant_secret()` method, passing the name of the secret and the application name as arguments. For example:

```python
await model.grant_secret('my-apitoken', 'ubuntu')
```

Similarly, you can use the `revoke_secret()` method to revoke access to a secret for an application.

```python
await model.revoke_secret('my-apitoken', 'ubuntu')
```

> See more: [`grant_secret()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.grant_secret), [`revoke_secret()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.revoke_secret), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
{ref}`/tab]
[/tabs]

<a href="#heading--update-a-secret"><h2 id="heading--update-a-secret">Update a secret</h2></a>
> *This feature is opt-in because Juju automatically removing secret content might result in data loss.*


[tabs]
[tab version="juju"]

To update a (user) secret, run the `update-secret` command followed by the secret ID and the updated (space-separated list of) key-value pair(s). For example:

```text
juju update-secret secret:9m4e2mr0ui3e8a215n4g token=34ae35facd4
```

> See more: [`juju update-secret` <command-juju-update-secret>`

[/tab]

[tab version="terraform juju"]
To update a (user) secret, update its resource definition from your Terraform plan.

[/tab]

[tab version="python libjuju"]
To update a (user) secret, on a connected Model, use the `update_secret()` method, passing the name of the secret and the updated info arguments. You may pass in `data_args`, `new_name`, `file` and `info` to update the secret (check out the documentation for details). For example:

```python
await model.update_secret(name='my-apitoken', new_name='new-token')
```

> See more: [`update_secret()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.update_secret), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
{ref}`/tab]
[/tabs]

<a href="#heading--remove-a-secret"><h2 id="heading--remove-a-secret">Remove a secret</h2></a>


[tabs]
[tab version="juju"]

To remove all the revisions of a (user) secret, run the `remove-secret` command followed by the secret ID. For example:

```text
juju remove-secret  secret:9m4e2mr0ui3e8a215n4g
```
The command also allows you to specify a model or to provide a specific revision to remove instead of the default all.

> See more: [`juju remove-secret` <command-juju-remove-secret>`

[/tab]

[tab version="terraform juju"]
To remove a secret, remove its resource definition from your Terraform plan.

[/tab]

[tab version="python libjuju"]
To remove a secret from a model, on a connected Model, use the `remove_secret()` method, passing the name of the secret as an argument. For example:

```python
# Remove all the revisions of a secret 
await model.remove_secret('my-apitoken')

# Remove the revision 2 of a secret 
await model.remove_secret('my-apitoken', revision=2)
```

> See more: [`remove_secret()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.remove_secret), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
[/tab]
[/tabs]

<br>

> <small>Contributors: @anvial, @cderici, @kelvin.liu , @tmihoc, @tony-meyer , @wallyworld </small>