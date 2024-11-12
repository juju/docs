(deploying)=
# Deploying

In Juju, **deploying** refers to the process where Juju uses a {ref}`charm <charm>` (from Charmhub or a local path) to install an {ref}`application <application>` on a resource from a {ref}`cloud <cloud-substrate>`.


## Deploying on a Kubernetes cloud

### The process

![JujuOnKubernetesDeployProcess|690x311](upload://4MzLfQku8H9gB3GTlGww4Jqud3d.png)

### The result

Note: This diagram assumes a typical scenario with a single workload container (depending on the charm, there may be more and there may be none).

![JujuOnKubernetesDeployResult|690x704](upload://6oWYcP95EAD5gW99GhN96cVXapH.jpeg)


## Deploying on a machine cloud

### The process

![JujuOnMachinesDeployProcess|689x700](upload://bgOc4jpj7YoQ6Wfp4zfaQM8QELk.png)

### The result

![JujuOnMachinesDeployResult|622x1000](upload://qPaCb6Xlu0zZoGvlaXukncOVd92.jpeg)

<br> *Deploying an application on a machine cloud: The result. This diagram assumes a typical scenario where the unit is deployed on a new machine of its own. (Note: The machine, model, unit, and controller agent are actually all part of the same {ref}``jujud` <binary-jujud>` process and refer in fact to trees of workers with machine, model, unit and, respectively, controller responsibility.)*

```{important}

**If you're curious about deployments to a *system container* on a VM:** 

On most machine clouds, Juju makes it possible to deploy to a system container *inside* the machine rather to the machine directly. The result doesn't change much: In terms of the diagram above, the only difference would be another box in between the "Regular Model Machine" and its contents and another machine agent for this box, as Juju treats system containers as regular machines. 

> See more: {ref}`Machine > Machines and system (LXD) containers <11285md>`

```