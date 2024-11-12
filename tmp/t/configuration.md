(configuration)=
# Configuration

In Juju, a **configuration** is a rule or a set of rules that define the behavior of your controller, model, or application.

**Contents:**

- [Controller configuration](#heading--controller-configuration)
- [Model configuration](#heading--model-configuration)
- [Application configuration](#heading--application-configuration)


 <a href="#heading--controller-configuration"><h2 id="heading--controller-configuration">Controller configuration</h2></a>

Controller configuration affects the operation of the controller as a whole.  

> See more:  {ref}`List of controller configuration keys <list-of-controller-configuration-keys>`, {ref}`How to configure a controller <6659md>`

 <a href="#heading--model-configuration"><h2 id="heading--model-configuration">Model configuration</h2></a>

Model configuration affects behavior of a model, including the `controller` model.
> See more: {ref}`List of model configuration keys <list-of-model-configuration-keys>`,  {ref}`How to configure a model <6659md>`

 <a href="#heading--application-configuration"><h2 id="heading--application-configuration">Application configuration</h2></a>

Application configuration affects the behavior of an application. 

Application configuration keys are generally application-specific. Depending on what the charm author has decided, they can be used to allow the charm user to make certain decisions about the application, for example, the server port on which the  application should be available, the resource profile, the DNS name, etc. 

> See examples: [Charmhub | `mysql` > Configurations](https://charmhub.io/mysql/configure#cluster-name), [Charmhub | `traefik-k8s` > Configurations](https://charmhub.io/traefik-k8s/configure), etc. 

> See more: {ref}`How to configure an application <6659md>`

However, there is also a generic key, `trust`, that can be changed via `juju trust`. 

> See more: {ref}`How to trust an application with a credential <6659md>`   


<!-- Heather and I decided to include `trust` under application configuration keys because, if you run, e.g., `$ juju config juju-qa-test`, you'll find something like:

```
$ juju config juju-qa-test
application: juju-qa-test
application-config:
  trust:
```

with `trust` being listed there (even if it's not in the config of the charm). 
-->