(how-to-manage-secret-backends)=
# How to manage secret backends

> See also: {ref}`Secret backend <secret-backend>`

<!--NOT STRICTLY NECESSARY. THEY'RE RELATED BUT HERE IT'S FINE TO FOCUS JUST ON THE BACKEND. PEOPLE CAN GET TO SECRETS BY NAVIGATION TO SECRET BACKEND AND CLICKING ON THE "SECRET" PAGE LINKED IN THE DEFINING STATEMENT.
, {ref}`How to manage secrets <how-to-manage-secrets>`
-->

Starting with Juju `3.1.0`, you can also manage secret backends in a number of ways.

**Contents:**

- [Configure a secret backend](#heading--configure-a-secret-backend)
- [Add a secret backend to a model](#heading--add-a-secret-backend-to-a-model) 
- [View all the secret backends available on a controller](#heading--view-all-the-secret-backends-available-on-a-controller) 
- [View all the secret backends active in a model](#heading--view-all-the-secret-backends-active-in-a-model) 
- [Change the secret backend to be used by a model](#heading--change-the-secret-backend-to-be-used-by-a-model) 
- [View details about a secret backend](#heading--view-details-about-a-secret-backend)
- [Update a secret backend](#heading--update-a-secret-backend)
- [Remove a secret backend](#heading--remove-a-secret-backend)

 <a href="#heading--configure-a-secret-backend"><h2 id="heading--configure-a-secret-backend">Configure a secret backend</h2></a>

To configure a secret backend, create a configuration YAML file with configurations supported by your chosen backend type. Below we create a minimal configuration file  for a backend type `vault`, so we name the file `vault_config.yaml` and specify the API `endpoint` and the access `token`.

```{important}

Currently this is possible only for `vault`. 

```

```{caution}

A minimal `vault` backend configuration as below is not secure. For production you should configure your `vault` backend securely by specifying further configuration keys, following {ref}`the list of supported keys <8701md>` and recommendations from the upstream Vault documentation.

```


```
cat > vault_config.yaml <<EOF
endpoint: http://10.0.0.1:8200
token: s.eujhj
EOF

```

That's it. You can now start using this backend by adding it to a model.

> See more: {ref}`Secret backend > Configuration options <8701md>`

<!--
```
juju add-secret-backend mysecrets vault \
--config=/path/to/vault_config.yaml \
token-rotate=7d
```
-->

<a href="#heading--add-a-secret-backend-to-a-model"><h2 id="heading--add-a-secret-backend-to-a-model">Add a secret backend to a model</h2></a>

{ref}`tabs]
[tab version="juju"]

To add a secret backend to a model, run the `add-secret-backend` command followed by your desired name and type for the backend, type as well as any relevant options:

```text
juju add-secret-backend myvault vault token-rotate=10m --config /path/to/cfg.yaml
```

> See more: [`juju add-secret-backend` <command-juju-add-secret-backend>`, {ref}`Secret backend > Name <8701md>`, {ref}`Secret backend > Type <8701md>`, {ref}`Secret backend > Configuration options <8701md>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
To add a secret backend to a controller, on a connected Controller, use the `add_secret_backends()` method, passing the `id`, `name`, `backend_type`, and `config` as arguments. For example:

```python
await my_controller.add_secret_backends("1001", "myvault", "vault", {"endpoint": vault_url, "token": keys["root_token"]})
```

> See more: [`add_secret_backend()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.add_secret_backends), [Controller (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/controller.html)
{ref}`/tab]
[/tabs]

<a href="#heading--view-all-the-secret-backends-available-on-a-controller"><h2 id="heading--view-all-the-secret-backends-available-on-a-controller">View all the secret backends available on a controller</h2></a>


[tabs]
[tab version="juju"]

To view all the backends available in the controller, run the `secret-backends` command:

```text
juju secret-backends
```

```{dropdown} Expand to see a sample output

```text
Backend           Type        Secrets  Message
internal          controller      134  
foo-local         kubernetes       30
bar-local         kubernetes       30
myvault           vault            20  sealed
```

```

The command also has options that allow you to filter by a specific controller or set an output format or an output file or reveal sensitive backend config content.

> See more: [`juju secret-backends` <command-juju-secret-backends>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
To view all the backends available in the controller, on a connected Controller, use the `list_secret_backends()` method.

```python
list = await my_controller.list_secret_backends()
```

> See more: [`list_secret_backends()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.list_secret_backends), [Controller (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/controller.html)
{ref}`/tab]
[/tabs]

<a href="#heading--view-all-the-secret-backends-active-in-a-model"><h2 id="heading--view-all-the-secret-backends-active-in-a-model">View all the secret backends active in a model</h2></a>

[tabs]
[tab version="juju"]

To see all the secret backends in use on a model, use the `show-model` command. Beginning with Juju `3.1`, this command also shows the secret backends (though you might have to scroll down to the end).

```text
juju show-model
```

```{dropdown} Expand to see a sample output


```text
mymodel:
  name: admin/mymodel
  short-name: mymodel
  model-uuid: deadbeef-0bad-400d-8000-4b1d0d06f00d
  model-type: iaas
  controller-uuid: deadbeef-1bad-500d-9000-4b1d0d06f00d
  controller-name: kontroll
  owner: admin
  cloud: aws
  region: us-east-1
  type: ec2
  life: alive
  status:
	current: available
  users:
	admin:
  	display-name: admin
  	access: admin
  	last-connection: just now
  machines:
	"0":
  	  cores: 0
	"1":
  	  cores: 2
  secret-backends:
	myothersecrets:
  	  status: active
	  secrets: 6
	mysecrets:
  	  status:draining
	  secrets: 5
```

```

> See more: [`juju show-model`**strong text** <command-juju-show-model>`

{ref}`/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--change-the-secret-backend-to-be-used-by-a-model"><h2 id="heading--change-the-secret-backend-to-be-used-by-a-model">Change the secret backend to be used by a model</h2></a>


[tabs]
[tab version="juju"]

To change the secret backend to be used by a model, use the `model-config` command with the `secret-backend` key configured to the name of the secret backend that you want to use, for example, `myothersecrets`:

```text
juju model-config secret-backend=myothersecrets
```

After the switch, any new secret revisions are stored in the new backend. Existing revisions continue to be read from the old backend.

> See more: [How to configure a model <8701md>`, {ref}`List of model configuration keys > `secret-backend` <list-of-model-configuration-keys>`

{ref}`/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--view-details-about-a-secret-backend"><h2 id="heading--view-details-about-a-secret-backend">View details about a secret backend</h2></a>

[tabs]
[tab version="juju"]

To view details about a particular secret, use the `show-secret-backend` command followed by the name of the secret backend. For example, for a secret called `myvault`, do:

```text
juju show-secret-backend myvault
```

By passing various options you can also specify a controller, an output format, an output file, or whether to reveal sensitive information. 

> See more: [`juju show-secret-backend` <command-juju-show-secret-backend>`

{ref}`/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--update-a-secret-backend"><h2 id="heading--update-a-secret-backend">Update a secret backend</h2></a>

[tabs]
[tab version="juju"]


To update a secret backend on the controller, run the `update-secret-backend` command followed by the name of the secret backend. Below we update the backend by supplying a configuration from a file:

```text
juju update-secret-backend myvault --config /path/to/cfg.yaml
```

> See more: [`juju update-secret-backend` <command-juju-update-secret-backend>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
To update a secret backend on the controller, on a connected Controller, use the `update_secret_backends()` method, passing the backend name as argument, along with the updated information, such as `name_change` for a new name. For example:

```python
await my_controller.update_secret_backends(
            "myvault",
            name_change="changed_name")
```

Check out the documentation for the full list of arguments.

> See more: [`update_secret_backend()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.update_secret_backends), [Controller (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/controller.html)
{ref}`/tab]
[/tabs]

<a href="#heading--remove-a-secret-backend"><h2 id="heading--remove-a-secret-backend">Remove a secret backend</h2></a>

[tabs]
[tab version="juju"]

To remove a secret backend, use the `remove-secret-backend` command followed by the backend name:

```text
juju remove-secret-backend myvault
```

> See more: [`juju update-secret-backend` <command-juju-update-secret-backend>`

[/tab]

[tab version="terraform juju"]

[/tab]

[tab version="python libjuju"]
To remove a secret backend on the controller, on a connected Controller, use the `remove_secret_backends()` method, passing the backend name as argument. For example:

```python
await my_controller.remove_secret_backends("myvault")
```

Check out the documentation for the full list of arguments.

> See more: [`remove_secret_backend()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.remove_secret_backends), [Controller (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/controller.html)
[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @tmihoc, @wallyworld </small>