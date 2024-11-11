(how-to-manage-credentials)=
# How to manage credentials

> See also: {ref}`Credential <credential>`

This document shows how to manage credentials in Juju.


## Add a credential

> See also: {ref}`Credential definition <1112md>`, {ref}`List of supported clouds > \<cloud name\> > CREDENTIAL <list-of-supported-clouds>`

{ref}`tabs]
[tab version="juju"]

The procedure for how to add a cloud credential to Juju depends on whether the cloud is a machine (traditional, non-Kubernetes) cloud or rather a Kubernetes cloud.

### Add a credential for a machine cloud

```{tip}

 **If your cloud is a local LXD cloud and if you are a Juju admin user:**
Your cloud credential is set up and retrieved automatically for you, so you can skip this step. Run `juju credentials` to confirm. (If you are not a Juju admin user, run `autoload-credentials`.)

```

**1.** Choose a cloud authentication type and collect the information required for that type from your cloud account.

```{caution}

The authentication types and the information needed for each type depend on your chosen cloud. Run `juju show-cloud` or consult the cloud Reference doc to find out.

> See more: [List of supported clouds <list-of-supported-clouds>`

```

**2.** Provide this information to Juju. You may do so in three ways -- interactively, by specifying a YAML file, or automatically, by having Juju check your local YAML files or environment variables. 

```{caution}

In general, we recommend the interactive method -- the latter two are both error-prone, and the last one is not available for all clouds.

```


**2a.** To add a credential interactively, run the `add-credential` command followed by the name of your machine cloud. For example:

```text
juju add-credential aws
```

This will start an interactive session where you’ll be asked to choose a cloud region (if applicable), specify a credential name (you can pick any name you want), and then provide the credential information (e.g., access key, etc.)

The command also  offers various flags that you can use  to provide all this information in one go (e.g., the path to a YAML file containing the credential definition) as an alternative to the interactive session.

> See more: {ref}``juju add-credential` <command-juju-add-credential>`


**2b.** To add a credential by specifying a YAML file, use your credential information to prepare a `credentials.yaml` file, then run the `add-credential` command with the `-f` flag followed by the path to this file. 

> See more: {ref}``juju add-credential -f` <command-juju-add-credential>`


**2c.** To add a credential automatically, use your credential information to prepare a `credentials.yaml` file / environment variables, then run the `autoload-credentials` command:

```text
juju autoload-credentials
```

Juju will scan your local credentials files / environment variables / rc files and, if it detects something suitable for the present cloud, it will display a prompt asking you to confirm the addition of the credential and to specify a name for it.

The command also allows you to restrict the search to a specific cloud, a specific controller, etc.

> See more: {ref}``juju autoload-credentials` <command-juju-autoload-credentials>`

### Add a credential for a Kubernetes cloud

For a Kubernetes cloud, credential definitions are added automatically when you add the cloud definition to Juju. Run `juju credentials` to verify.

> See more: {ref}`How to add a Kubernetes cloud <1112md>`

[/tab]

[tab version="terraform juju"]

To add a credential, in your Terraform plan create a resource of the `juju_credential` type, specifying the credential's name, cloud, authentication type, and the attributes associated with the authentication type.


```text
resource "juju_credential" "this" {
  name = "creddev"

  cloud {
    name = "localhost"
  }

  auth_type = "certificate"

  attributes = {
    client-cert    = "/srv/cert.crt"
    client-key     = "/srv/cert.key"
    trust-password = "S0m3P@$$w0rd"
  }
}
```

> See more: [`juju_credential` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/credential)
[/tab]

[tab version="python libjuju"]
To add a credential, you may use the `Controller.add_credential()` method on a connected `Controller` object. `add_credential` is an upsert method (where it inserts if the given credential is new, and updates if the given credential name already exists).

```python
from juju.client import client as jujuclient

my_controller.add_credential("my-credential", 
    jujuclient.CloudCredential(auth_type="jsonfile", attrs={'file':'path_to_cred_file'})

```

> See more: [`add_credential` (method)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.add_credential)

{ref}`/tab]
[/tabs]

## View all the known credentials

[tabs]
[tab version="juju"]

To see a list of all the known credentials, run the `credentials` command:

```text
juju credentials
```

This should output something similar to this:

```text
Controller Credentials:
Cloud           Credentials
lxd             localhost*

Client Credentials:
Cloud   Credentials
aws     bob*, carol
google  wayne
```

where the asterisk denotes the default credential for a given cloud.

By passing various flags, you can also choose to view just the credentials known to the client, or just those for a particular controller; you can select a different output format or an output file (and also choose to include secrets); etc.

> See more: [`juju credentials` <command-juju-credentials>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

## View details about a credential

[tabs]
[tab version="juju"]

You can view details about all your credentials at once or just about a specific credential.

**All credentials.** To view details about all your credentials at once, run the `show-credential` command with no argument:

```text
juju show-credential
```

By passing various flags you can filter by controller, select an output format or an output file, etc.

> See more: [`juju show-credential` <1112md>`


**A specific credential.** To view details about just one specific credential, run the `show-credential` command followed by the name of the cloud and the name of the credential. For example:

```text
juju show-credential mycloud mycredential
```

By passing various flags you can specify an output format or an output file, display secret attributes, etc.

> See more: {ref}``juju show-credential` <command-juju-show-credential>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

## Set the default credential

[tabs]
[tab version="juju"]

**Set.** To set the default credential for a cloud on the current client, run the `default-credential` command followed by the name of the cloud and the name of the credential. For example: 

```text
juju default-credential aws carol
```

> See more: [`juju default-credential` <1112md>`

**Get.** To view the currrently set default credential for a cloud, run the `default-credential` command followed by the name of the cloud. For example:

```text 
juju default-credential aws
```
This should display the default credential.

<!--
By running the same with the `--reset` flag  you can reset the default.
-->

> See more: {ref}``juju default-credential` <command-juju-default-credential>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

## Add a credential to a model

```{caution}

You can only do this if you are a controller admin or a model owner.

```

[tabs]
[tab version="juju"]

To add a controller credential to a model, run the `set-credential` command followed by a flag for the intended model, the host cloud, and the name of the credential. For example:

```text
juju set-credential -m trinity aws bob
```

```{important}

If the credential is only known to the client, this will first upload it to the controller and then relate it to the model. 

```

```{tip}

This command does not affect any existing relations between the credential and other models. If the credential is already related to a single model, this operation will just cause the credential to be related to two models.

```

> See more: [`juju set-credential` <command-juju-set-credential>`

{ref}`/tab]

[tab version="terraform juju"]
To add a controller credential to a model, in your Terraform plan, specify it as an attribute to the model definition. For example:

```text
resource "juju_model" "this" {
  name = "development"

  cloud {
    name   = "aws"
    region = "eu-west-1"
  }

  credential = juju_credential.<credential label>.name
}
```



[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]

## Update a credential

[tabs]
[tab version="juju"]

To update a credential, run the `update-credential` command followed by the name of the cloud and the name of the credential. For example:

```text
juju update-credential mycloud mycredential
```

This will start an interactive session where you will be asked to specify various parameters for the update. 

By passing various flags, you can also perform this operation in-line. And by dropping the credential (and the cloud) argument and passing a flag with a credential YAMl file, you can also update all your credentials at once.

> See more: [`juju update-credential` <command-juju-update-credential>`

[/tab]

[tab version="terraform juju"]
To update a credential, in your Terraform plan, update its resource definition.

> See more: [Resource `juju_credential`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/credential)
[/tab]

[tab version="python libjuju"]
To update a credential, you may use the `Controller.add_credential()` method on a connected `Controller` object. `add_credential` is an upsert method (where it inserts if the given credential is new, and updates if the given credential name already exists).

```python
from juju.client import client as jujuclient

my_controller.add_credential("my-credential", 
    jujuclient.CloudCredential(auth_type="jsonfile", attrs={'file':'path_to_cred_file'})

```

> See more: [`add_credential` (method)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.add_credential)
{ref}`/tab]
[/tabs]

## Remove a credential

[tabs]
[tab version="juju"]

To remove a credential, run the `remove-credential` command followed by the name of the cloud and the name of the credential. For example:

``` text
juju remove-credential mycloud mycredential
```

This will start an interactive session where you will be asked to choose whether to apply this operation for the client or a specific controller or both. You can bypass this by using the client and controller flags in-line.

> See more: [`juju remove-credential` <command-juju-remove-credential>`

[/tab]

[tab version="terraform juju"]

To remove a credential, remove its resource definition from your Terraform plan.

> See more: [Resource `juju_credential`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/credential)
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not support this. Please use the `juju` client.
[/tab]
[/tabs]


<br>

> <small>**Contributors:** @cderici, @erik-lonroth , @pedroleaoc, @pmatulis, @timclicks, @tmihoc, @wallyworld </small>