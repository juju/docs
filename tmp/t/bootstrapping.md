(bootstrapping)=
# Bootstrapping

In Juju, **bootstrapping** refers to the process whereby a Juju {ref}`client <juju-juju-client>` creates a {ref}`controller <controller>` on a specific {ref}`cloud <cloud-substrate>`. 

A controller is needed to perform any further Juju operations, such as deploying an application.

## Bootstrapping on a Kubernetes cloud

![JujuOnKubernetesBootstrapProcess|690x600](upload://qDmewbwPsyW7NZ6EKPdaVNJZiwG.png)
<br> *Bootstrapping a controller on a Kubernetes cloud: The process.*<br>


![JujuOnKubernetesBoostrapResult|690x680](upload://dEGK7HisD0VlcG7dJwG5l7HtfkS.jpeg)


<br> *Bootstrapping a controller on a Kubernetes cloud: The result.*<br>


## Bootstrapping on a machine cloud

![JujuOnMachinesBootstrapProcess|690x662](upload://ujh5UkY4e7EDPZtQfwLK8l5Mzat.png)
<br> *Bootstrapping a controller on a machine cloud: The process.*<br>

> See more: [Source code](https://github.com/juju/juju/blob/3.4/cmd/jujud/agent/bootstrap.go), {ref}`How to create a controller <6209md>`

![JujuOnMachinesBootstrapResult|690x977](upload://aOuaqnjl1hhEjrhzo5UyFkvl93x.jpeg)

<br> *Bootstrapping a controller on a machine cloud: The result. (Note: The machine, model, unit, and controller agent are actually all part of the same {ref}``jujud` <binary-jujud>` process and refer in fact to trees of workers with machine, model, unit and, respectively, controller responsibility.)*<br>



<br>

> <small>**Contributors:** @hmlanigan, @simonrichardson, @tmihoc </small>