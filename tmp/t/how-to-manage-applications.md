(how-to-manage-applications)=
# How to manage applications

> See also: {ref}`Application <application>`

This document shows how to manage applications with Juju.

## Deploy an application

To deploy an application, find and deploy a charm / bundle that delivers it.

> See more: {ref}`How to deploy a charm / charm bundle <5476md>`

```{note}


- **Machines:**

Deploy on machines consists of the following steps: Provision resources/a machine M from the relevant cloud, via cloud-init maybe network config, download the `jujud` binaries from the controller, start `jujud`.

For failure at any point, retry the `deploy` command with the `--debug` and `--verbose` flags:

```text
juju deploy <charm> --debug --verbose
```

If it still fails,  connect to the machine and examine the logs.

> See more: {ref}`How to manage logs > View the log files <5476md>`, {ref}`How to troubleshoot your deployment <how-to-troubleshoot-your-deployment>`

- **Kubernetes:**

Deploy on Kubernetes includes creating a Kubernetes pod and in it charm and workload containers. To troubleshoot, inspect these containers with `kubectl`:

```text

kubectl exec <pod> -itc <container> -n <namespace> -- bash
```


```



## View details about an application

{ref}`tabs]
[tab version="juju"]

To view more information about a deployed application, run the `show-application` command followed by the application name or alias:

```text
juju show-application <application name or alias >

```

By specifying various flags you can also specify a model, or an output format or file.

> See more: [`juju show-application` <command-juju-deploy>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To view details about an application on python-libjuju, you may use various `get_*` methods that are defined for applications. 

For example, to get the config for an application, call `get_config()` method on an `Application` object:

```python
config = await my_app.get_config()
```

> See more: [`Application` (module) <5476md>`, [`Application.get_config (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_config), [`Application (methods)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application)
{ref}`/tab]
[/tabs]


## Set the machine base for an application
> Only for machine clouds.

[tabs]
[tab version="juju"]

You can set the base for the machines provisioned by Juju for your application's units either during deployment or after. 

**Set the machine base during deployment.** To set the machine base during deployment, run the `deploy` command with the `--base` flag followed by the desired compatible base. For example:


```text
juju deploy ubuntu --base ubuntu@20.04
```

**Set the machine base after deployment.** (*starting with Juju 4.0, this is no longer possible*) To set the machine base after deployment, run the `set-application-base` command followed by the name of the application and the desired compatible base. (This will affect any future units added to the application.) For example:

```text
juju set-application-base ubuntu ubuntu@20.04
```

> See more: [`juju set-application-base` <command-juju-set-application-base>`

{ref}`/tab]

[tab version="terraform juju"]

[TBA]

[/tab]

[tab version="python libjuju"]

[TBA]

[/tab]
[/tabs]




## Trust an application with a credential


Some applications may require access to the backing cloud in order to fulfil their purpose (e.g., storage-related tasks). In such cases, the remote credential associated with the current model would need to be shared with the application. When the Juju administrator allows this to occur the application is said to be *trusted*. 

[tabs]
[tab version="juju"]

An application can be trusted during deployment or after deployment.

**Trust an application during deployment.** To trust an application during deployment, run the `deploy` command with the `--trust` flag. E.g., below we trust

```text
juju deploy --trust ...
```

> See more: [`juju deploy --trust` <command-juju-deploy>`

**Trust an application after deployment.** To trust an application after deployment, use the `trust` command:

```text
juju trust <application>
```

By specifying various flags, you can also use this command to remove trust from an application, or to give an application deployed on a Kubernetes model access to the full Kubernetes cluster, etc.

> See more: {ref}``juju trust` <command-juju-trust>`
	
[/tab]

[tab version="terraform juju"]

To trust an application with a credential, in the `juju_application` resource definition, add a `trust` attribute and set it to `true`:

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name     = "hello-kubecon"
  }

    trust = true
}
```

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)


{ref}`/tab]

[tab version="python libjuju"]

To trust an application during deployment in python-libjuju, you may call the `Model.deploy()` with the `trust` parameter:

```python
await my_model.deploy(..., trust=True, ...)
```

To trust an application after deployment, you may use the `Application.set_trusted()` method:

```python
await my_app.set_trusted(True)
```

> See more: [`Model.deploy()` (method) <5476md>`, [`Application.set_trusted (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.set_trusted)

> See also: [`Application.get_trusted (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_trusted)

{ref}`/tab]
[/tabs]


## Run an application action

> See also: [Action <action>`

> See more: {ref}`How to manage actions <how-to-manage-actions>`

## Configure an application
> See also: {ref}`Application configuration <5476md>`

{ref}`tabs]
[tab version="juju"]

<!-- Application configuration here = configuration of the application, which comes from the charm. Not to be confused with application configuration = something like trust (juju deploy --trust, juju trust) and a couple of things for podspec charms (not important since podspec charms are functionally deprecated).-->

<!--When deploying an application, the charm you use will often support or even require specific configuration options to be set.-->

Most charms ship with a sensible default configuration out of the box. However, for some use cases, it may be desirable or necessary to override the default application configuration options.

**Get values.** The way to view the existing configuration for an application depends on whether the application has been deployed or not.

- To view the configuration options of an application that you have not yet deployed, 
    - if its charm is on Charmhub, inspect its Configurations page; for example: https://charmhub.io/mediawiki/configure.
    - if its charm is local on your machine, inspect its `config.yaml` file.

- To view the configuration values for a deployed application, run the `config` command followed by the name of the application. For example:

``` text
juju config mediawiki
```
---------------
```{dropdown} Expand to view a sample output

``` text
application: mediawiki
charm: mediawiki
settings:
  admins:
    description: Admin users to create, user:pass
    is_default: true
    type: string
    value: ""
  debug:
    description: turn on debugging features of mediawiki
    is_default: true
    type: boolean
    value: false
  logo:
    description: URL to fetch logo from
    is_default: true
    type: string
    value: ""
  name:
    description: The name, or Title of the Wiki
    is_default: true
    type: string
    value: Please set name of wiki
  server_address:
    description: The server url to set "$wgServer". Useful for reverse proxies
    is_default: true
    type: string
    value: ""
  skin:
    description: skin for the Wiki
    is_default: true
    type: string
    value: vector
  use_suffix:
    description: If we should put '/mediawiki' suffix on the url
    is_default: true
    type: boolean
    value: true
```

```

----

> See more: [`juju config` <command-juju-config>`

**Set values.** You can set configuration values for an application during deployment or later. 

- To set configuration values for an application during deployment, run the `deploy` command with the `--config` flag followed by the relevant key=value pair. For example, [the `mediawiki` charm allows users to configure the `name` of the deployed application](https://charmhub.io/mediawiki/configure); below, we set it to `my media wiki`:

```text
juju deploy mediawiki --config name='my media wiki'
```

To pass multiple values, you can repeat the flag or store the values into a config file and pass that as an argument.

> See more: {ref}``juju deploy --config` <command-juju-deploy>`


- To set configuration values for an application post deployment, run the `config` command followed by the name of the application and the relevant (list of space-separated) key=value pair(s). For example, [the `mediawiki` charm provides a `name` and a `skin` configuration key](https://charmhub.io/mediawiki/configure); below we set both:

``` text
juju config mediawiki name='Juju Wiki'  skin=monoblock
```

By exploring various options you can also use this command to pass the pairs from a YAML file or to reset the keys to their default values.

> See more: {ref}``juju config` <command-juju-config>`

[/tab]

[tab version="terraform juju"]

To configure an application, in its resource definition add a config map with the key=value pairs you want (from the list of configs available for the charm). 

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  config = {
    redirect-map = "https://demo"      
   }    
}
```
> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)



{ref}`/tab]

[tab version="python libjuju"]


Get values. To view the existing configuration for an application on python-libjuju, you may use the `Application.get_config()` method:

```python
config = await my_app.get_config()
```

Set values. To set configuration values for an application on python-libjuju:

* To configure an application at deployment, simply provide a `config` map during the `Model.deploy()` call:

```python
await my_model.deploy(..., config={'redirect-map':'https://demo'}, ...)
```

* To configure an application post deployment, you may use the `Application.set_config()` method, similar to passing config in the deploy call above:

```python
await my_app.set_config(config={'redirect-map':'https://demo'})
```

> See more: [`Model.deploy()` (method) <5476md>`, [`Application.set_config (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.set_config),  [`Application.get_config (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_config)


{ref}`/tab]
[/tabs]



## Scale an application

> See also: [Scaling <scaling>`

### Scale an application vertically

To scale an application vertically, set constraints for the resources that the application's units will be deployed on.
 
> See more: {ref}`How to manage constraints for an application <5476md>`

### Scale an application horizontally

To scale an application horizontally, control the number of units.

> See more: {ref}`How to control the number of units <5476md>`


## Make an application highly available
> See also: {ref}`High availability <high-availability-ha>`

1. Find out if the charm delivering the application supports high availability natively or not. If the latter, find out what you need to do. This could mean integrating with a load balancing reverse proxy, configuring storage etc. 

> See more: [Charmhub > `<your charm of interest>`](https://charmhub.io/)

2. Scale up horizontally as usual.

> See more: {ref}`How to scale an application horizontally <5476md>`

-----------------
```{dropdown} Expand to view an example featuring the machine charm for Wordpress

The `wordpress` charm supports high availability natively, so we can proceed to scale up horizontally:

```text
juju add-unit wordpress
```


```
-----------------
```{dropdown} Expand to view an example featuring the machine charm for Mediawiki

The `mediawiki` charm needs to be placed behind a load balancing reverse proxy. We can do that by deploying the `haproxy` charm, integrating the `haproxy` application with `wordpress`, and then scaling the `wordpress` application up horizontally:

``` text
# Suppose you have a deployment with mediawiki and mysql and you want to scale mediawiki.
juju deploy mediawiki
juju deploy mysql

# Deploy haproxy and integrate it with your existing deployment, then expose haproxy:
juju deploy haproxy
juju integrate mediawiki:db mysql
juju integrate mediawiki haproxy
juju expose haproxy

# Get the proxy's IP address:
juju status haproxy

# Finally, scale mediawiki up horizontally 
# (since it's a machine charm, use 'add-unit') 
# by adding a few more units:
juju add-unit -n 5 mediawiki

```


```

-----------------

Every time a unit is added to an application, Juju will spread out that application's units, distributing them evenly as supported by the provider (e.g., across multiple availability zones) to best ensure high availability. So long as a cloud's availability zones don't all fail at once, and the charm and the charm's application are well written (changing leaders, coordinating across units, etc.), you can rest assured that cloud downtime will not affect your application. 

> See more: [Charmhub | `wordpress`](https://charmhub.io/wordpress), [Charmhub | `mediawiki`](https://charmhub.io/mediawiki), [Charmhub | `haproxy`](https://charmhub.io/haproxy)

## Integrate an application with another application

> See more: {ref}`How to manage relations <how-to-manage-relations>`


## Manage an application’s public availability over the network
<!--Source: https://discourse.charmhub.io/t/how-to-control-application-network-ingress/3692 -->

{ref}`tabs]
[tab version="juju"]

**Expose an application.** By default, once an application is deployed, it is _only_ reachable by other applications in the _same_ Juju model. However, if the particular deployment use case requires for the application to be reachable by Internet traffic (e.g. a web server, Wordpress installation etc.), Juju needs to tweak the backing cloud's firewall rules to allow Internet traffic to reach the application. This is done with the `juju expose` command.

```{note}

After running a `juju expose` command, any ports opened by the application's charmed operator  will become accessible by **any** public or private IP address.

```

Assuming the `wordpress` application has been deployed (and a relation has been made to the deployed database `mariadb`), the following command can be used to expose the application outside the Juju model:

``` bash
juju expose wordpress
```

When running `juju status`, its output will not only indicate whether an application is exposed or not, but also the public address that can be used to access each exposed application:

``` bash
App        Version  Status  Scale  Charm      Rev  Exposed  Message
mariadb    10.1.36  active      1  mariadb      7  no       
wordpress           active      1  wordpress    5  yes      exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mariadb/0*    active    idle   1        54.147.127.19           ready
wordpress/0*  active    idle   0        54.224.246.234  80/tcp
```

The command also has flags that allow you to expose just specific endpoints of the application, or to make the application available to only specific CIDRs or spaces. For example:

```text
juju expose percona-cluster --endpoints db-admin --to-cidrs 10.0.0.0/24

```{important}

To override an initial `expose` command, run the command again with the new desired specifications.

```
```


> See more: [`juju expose` <command-juju-expose>`

**Inspect exposure.**

To view details of how the application has been exposed, run the `show-application` command. Sample session:

```text
$ juju show-application percona-cluster
percona-cluster:
  ...
  exposed: true
  exposed-endpoints:
    "":
      expose-to-cidrs:
      - 0.0.0.0/0
      - ::/0
    db-admin:
      expose-to-cidrs:
      - 192.168.0.0/24
      - 192.168.1.0/24
  ...
```

> See more: {ref}``juju show-application` <command-juju-show-application>`


**Unexpose an application.** The `juju unexpose` command can be used to undo the firewall changes and once again only allow the application to be accessed by applications in the same Juju model:

``` text
juju unexpose wordpress
```

You can again choose to unexpose just certain endpoints of the application. For example, running `juju unexpose percona-cluster --endpoints db-admin` will block access to any port ranges opened for the `db-admin` endpoint but still allow access to ports opened for all other endpoints:

```text
juju unexpose percona-cluster --endpoints db-admin
```

> See more: {ref}``juju unexpose` <command-juju-unexpose>`

[/tab]

[tab version="terraform juju"]

**Expose.** To expose an application over a network, in its resource definition use an expose attribute:

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  expose = {}
}
```

This will expose all of the application's endpoints. To restrict exposure to just specific endpoints, spaces, or CIDRs, specify nested attributes.

<!--
```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  expose = {
    endpoints = "..., ..."
    spaces = 
    cidrs = 
  }
}
```
-->


> See more: [`juju_application` > `expose` > nested schema](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#nested-schema-for-expose)



**Unexpose.** To unexpose an application, remove the `expose` attribute from its resource definition.



[/tab]

[tab version="python libjuju"]

To expose some or all endpoints of an application over a network, you may use the `Application.expose()` method, as follows:

```python
await my_app.expose(exposed_endpoints=None) # everything's reachable from 0.0.0.0/0.
```

To expose to specific CIDRs or spaces, you may use an `ExposedEndpoint` object to describe that, as follows:

```python
# For spaces
await my_app.expose(exposed_endpoints={"": ExposedEndpoint(to_spaces=["alpha"]) })

# For cidrs
await my_app.expose(exposed_endpoints={"": ExposedEndpoint(to_cidrs=["10.0.0.0/24"])})

# You may use both at the same time too
await my_app.expose(exposed_endpoints={
            "ubuntu": ExposedEndpoint(to_spaces=["alpha"], to_cidrs=["10.0.0.0/24"])
        })
```


To unexpose an application, use the `Application.unexpose()` method:

```python
await my_app.unexpose() # unexposes the entire application

await my_app.unexpose(exposed_endpoints=["ubuntu"]) # unexposes the endpoint named "ubuntu"
```

> See more: [Exposed Endpoint (methods)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.ExposedEndpoint), [`Application.expose()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.expose),  [`Application.unexpose()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.unexpose)

{ref}`/tab]
[/tabs]

## Manage constraints for an application

> See also: [Constraint <constraint>`

{ref}`tabs]
[tab version="juju"]

**Set values.** You can set constraints for an application during deployment or later.

- To set constraints for an application during deployment, run the `deploy` command with the `--constraints` flag followed by the relevant key-value pair or a quotes-enclosed list of key-value pairs. For example, to deploy MySQL on a resource that has at least 6 GiB of memory and 2 CPUs:

``` text
juju deploy mysql --constraints "mem=6G cores=2"
```
---
```{dropdown} Expand to see more examples


Assuming a LXD cloud, to deploy PostgreSQL with a specific amount of CPUs and memory, you can use a combination of the `instance-type` and `mem` constraints, as below -- `instance-type=c5.large` maps to 2 CPUs and 4 GiB, but `mem` overrides the latter, such that the result is a machine with 2 CPUs and *3.5* GiB of memory.

``` text
juju deploy postgresql --constraints "instance-type=c5.large mem=3.5G"
```

To deploy Zookeeper to a new LXD container (on a new machine) limited to 5 GiB of memory and 2 CPUs, execute:

``` text
juju deploy zookeeper --constraints "mem=5G cores=2" --to lxd
```

To deploy two units of Redis across two AWS availability zones, run:

``` text
juju deploy redis -n 2 --constraints zones=us-east-1a,us-east-1d
```

```

---

> See more: [`juju deploy --constraints` <command-juju-deploy>`

```{caution}

**If you want to use the `image-id` constraint with `juju deploy`:** <br>
You must also use the `--base` flag of the command. The base specified via `--base` will be used to determine the charm revision deployed on the resource created with the `image-id` constraint.

```

> See more: {ref}``juju deploy --base` <command-juju-deploy>`


<!--CLARIFY:
--base on its own does two things: (1) it determines the OS to be used on the provisioned machines; (2) it determines the charm revision to be deployed on the provisioned machines. In conjunction with `image-id`, though, it only does (2) -- part (1) is overridden by the (unknown) OS specified in the image chosen via `image-id`.
-->

- To set constraints for an application after deployment, run the `set-constraints` command followed by the desired ("-enclosed list of) key-value pair(s), as below. This will affect any future units you may add to the application.

``` text
juju set-constraints mariadb cores=2
```

```{tip}

**Pro tip:** To reset a constraint key to its default value, run the command with the value part empty (e.g., `juju deploy apache2 --constraints mem= `).

```

> See more: {ref}``juju set-constraints` <command-juju-set-constraints>`

**Get values.** To view an application's current constraints, use the `constraints` command:

``` text
juju constraints mariadb
```

> See more: {ref}``juju constraints` <command-juju-constraints>`

[/tab]

[tab version="terraform juju"]

To set constraints for an application, in its resource definition specify a `constraints` attribute followed by a quotes-enclosed, space-separated list of key=value pairs. For example:

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  constraints = "mem=6G cores=2"

}
```

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)



{ref}`/tab]

[tab version="python libjuju"]

Set values. To set constraints for application in python-libjuju:

* To set at deployment, simply provide a `constraints` map during the `Model.deploy()` call:

```python
await my_model.deploy(..., constraints={, 'arch': 'amd64', 'mem': 256}, ...)
```

* To set constraints post deployment, you may use the `Application.set_contraints()` method, similar to passing constraints in the deploy call above:

```python
await my_app.set_constraints(constraints={, 'arch': 'amd64', 'mem': 256})
```

Get values. To see what constraints are set on an application, use the `Application.get_constraints()` method:

```python
await my_app.get_constraints()
```

> See more: [`Model.deploy()` (method) <5476md>`, [`Application.set_contraints()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.set_constraints), [`Application.get_constraints (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_constraints)

{ref}`/tab]
[/tabs]

## Change space bindings for an application

> See also: [Binding <binding>`

{ref}`tabs]
[tab version="juju"]

You can set space bindings for an application during deployment or post-deployment. In both cases you can set either a default space for the entire application or a specific space for one or more individual application endpoints or both.

- To change space bindings for an application during deployment, use the `deploy` command with the `bind` flag followed by the name of the application and the name of the default space and/or key-value pairs consisting of specific application endpoints and the name of the space that you want to bind them to. For example (where `public` is the name of the space that will be used as a default):

```
juju deploy <application> --bind "public db=db db-client=db admin-api=public"
```

> See more: [`juju deploy --bind` <command-juju-deploy>`

- To change space bindings for an application after deployment, use the `bind` command followed by the name of the application and the name of the default space and/or key-value pairs consisting of specific application endpoints and the name of the space that you want to bind them to. For example:

```text
juju bind <application> new-default endpoint-1=space-1
```

> See more: {ref}``juju bind` <command-juju-bind>`

[/tab]

[tab version="terraform juju"]

To set space bindings for an application, in its resource definition specify an `endpoint_bindings` with a `space` key, to set a default for the entire application, and/or a `space` and an `endpoint` key, to set the space binding for a particular application endpoint. For example, below all the application's endpoints are bound to the `public` space except for the `juju-info` endpoint, which will be bound to the `private` space:

```text
resource "juju_application" "application_three" {
  model = resource.juju_model.testmodel.name
  charm {
    name = "juju-qa-test"
  }
  units = 0
  endpoint_bindings = [
    {
      "space" = "public"
    }
    {
      "space" = "private"
      "endpoint" = "juju-info"
    }
  ]
}
```

> See more: [`juju_application` > `endpoint_bindings`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#endpoint_bindings)


{ref}`/tab]

[tab version="python libjuju"]
To set bindings for an application on python-libjuju, simply pass the `bind` parameter at the `Model.deploy()` call:

```python
await my_model.deploy(..., bind="db=db db-client=db public admin-api=public", ...)
```

Python-libjuju currently doesn't support resetting space bindings post deployment, please use the `juju-cli` for that.

> See more: [`Model.deploy()` (method) <5476md>`

{ref}`/tab]
[/tabs]

## Upgrade an application

To upgrade an application, update its charm. 

> See more: [How to update a charm <5476md>`


## Remove an application
> See also: {ref}`Removing things <removing-things>`

{ref}`tabs]
[tab version="juju"]

To remove an application, run the `remove-application` command followed by the name of the application. For example:

```text
juju remove-application apache2
```

It can take a while for the application to be completely removed but if juju status reveals that the application is listed as ‘dying’, but also reports an error state, then the removed application will not go away. See the section below for how to manage applications stuck in a dying state.

This will remove all of the application's units. All associated resources will also be removed providing they are not hosting containers or another application's units.

If persistent [storage <5476md>` is in use by the application it will be detached and left in the model. However, the `--destroy-storage` option can be used to instruct Juju to destroy the storage once detached.

Removing an application which has relations with another application will terminate that relation. This may adversely affect the other application. 

As a last resort, use the `--force` option (in `v.2.6.1`).

> See more: {ref}``juju remove-application` <command-juju-remove-application>`


```{note}


```{dropdown} One or more units are stuck in error state


If the status of one or more of the units being removed is error, Juju will not proceed until the error has been resolved or the remove applications command has been run again with the force flag.

 > See more: {ref}`How to mark unit errors as resolved <5476md>`


```


```


[/tab]

[tab version="terraform juju"]

To remove an application, remove its resource definition from your Terraform plan.

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)


[/tab]

[tab version="python libjuju"]

To remove an application from a model in python-libjuju, you have two choices:

1) If you have a reference to a connected model object (connected to the model you're working on), then you may use the `Model.remove_application()` method:

```python
await my_model.remove_application(my_app.name)
```

2) If you have a reference to the application you want to remove, then you may use the `Application.destroy()` directly on the application object you want to remove:

```python
await my_app.destroy()
```
> See more: [`Model.remove_application (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.remove_application), [`Application.destroy (method)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.destroy)

[/tab]
[/tabs]

Behind the scenes, the application removal consists of multiple different stages. If something goes wrong, it can be useful to determine in which step it happened. The steps are the following:
- The client tells the controller to remove the application.
- The controller signals to the application (charm) that it is going to be
  destroyed.
- The charm breaks any relations to its application by calling
  relationship-broken and relationship-departed.
- The charm calls its ‘stop hook’ which should:
  - Stop the application
  - Remove any files/configuration created during the application lifecycle
  - Prepare any backup(s) of the application that are required for restore
    purposes.
- The application and all its units are then removed.
- In the case that this leaves machines with no running applications, the machines are also removed. 

> <small>Contributors: @achilleasa , @cderici, @james-garner, @hmlanigan , @nvinuesa , @pedroleaoc , @pmatulis , @stephanpampel , @timClicks , @tmihoc </small>