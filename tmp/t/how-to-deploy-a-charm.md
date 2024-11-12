(how-to-deploy-a-charm)=
# How to deploy a charm

This document shows how to deploy a charm. In the context of charm development, this always follows the procedure for a local charm, but the specifics vary depending on whether it's the first time you're deploying or if you're rather updating your deployment by updating the charm. 

- [Deploy a local charm for the first time](#heading--deploy-a-local-charm-for-the-first-time)
- [Update the deployment of a local charm by refreshing the charm](#heading--update-the-deployment-of-a-local-charm-by-refreshing-the-charm)

```{tip}

**To catch any issues that may arise during deployment:** Before you deploy: 

```text
# Set your logging verbosity level to `DEBUG`:
$ juju model-config logging-config="<root>=WARNING;unit=DEBUG"

# Start a live debug session:
$ juju debug-log
```

> See more: [Juju | Model configuration keys > `logging-config`](https://juju.is/docs/juju/list-of-model-configuration-keys#heading--logging-config), [Juju | `debug-log`](https://juju.is/docs/juju/juju-debug-log)

```

<a href="#heading--deploy-a-local-charm-for-the-first-time"><h2 id="heading--deploy-a-local-charm-for-the-first-time">Deploy a local charm for the first time</h2></a>

Then, to deploy a local charm for the first time, after packing the charm, run the `juju deploy` command followed by the path to the `.charm` file and, if applicable, the `--resource` flag for any resource specified in the `charmcraft.yaml` of the charm. If all goes well, `juju status` should show the application status as `active` and the unit status as `active` (workload status) and `idle` (agent status), respectively. Sample session:

```text
# Pack the charm:
~/example-k8s$ charmcraft pack
Created 'example-k8s_ubuntu-22.04-amd64.charm'.                                                                                                                                              
Charms packed:                                                                                                                                                                               
    example-k8s_ubuntu-22.04-amd64.charm 

# Deploy the charm from its local path:
~/example-k8s$ juju deploy ./example-k8s_ubuntu-22.04-amd64.charm --resource httpbin-image=kennethreitz/httpbin
Located local charm "example-k8s", revision 0
Deploying "example-k8s" from local charm "example-k8s", revision 0 on ubuntu@22.04/stable

# Check the charm's deployment status:
~/example-k8s$ juju status
Model        Controller  Cloud/Region        Version  SLA          Timestamp
welcome-k8s  microk8s    microk8s/localhost  3.1.6    unsupported  14:11:43+01:00

App          Version  Status  Scale  Charm        Channel  Rev  Address        Exposed  Message
example-k8s           active      1  example-k8s             0  10.152.183.43  no       

Unit            Workload  Agent  Address      Ports  Message
example-k8s/0*  active    idle   10.1.64.139         
```

> See more: {ref}``charmcraft pack` <command-charmcraft-pack>`,  [Juju | `juju deploy`](https://juju.is/docs/juju/juju-deploy), [Juju | `juju status`](https://juju.is/docs/juju/juju-status)

<a href="#heading--update-the-deployment-of-a-local-charm-by-refreshing-the-charm"><h2 id="heading--update-the-deployment-of-a-local-charm-by-refreshing-the-charm">Update the deployment of a local charm by refreshing the charm</h2></a>

To update and redeploy the local charm: After repacking the charm, run `juju refresh` followed by the name of the deployed application (see `juju status`); the `--path` flag followed by the "-enclosed path to the charm; if applicable, the resource; and the `-force-units` flag, which will refresh all units immediately, even if in error. If all goes well, `juju status` should show all `active` and `idle` -- but the charm's revision number should increase by 1. Sample session:

```text
# Repack the charm:
~/example-k8s$ charmcraft pack
Created 'example-k8s_ubuntu-22.04-amd64.charm'.                                              
Charms packed:                                                                               
    example-k8s_ubuntu-22.04-amd64.charm   

# Update the charm in Juju:
~/example-k8s$ juju refresh example-k8s --path="./example-k8s_ubuntu-22.04-amd64.charm" --resource httpbin-image=kennethreitz/httpbin --force-units
Added local charm "example-k8s", revision 1, to the model

# Check the charm's deployment status:
$ juju status
Model        Controller  Cloud/Region        Version  SLA          Timestamp
welcome-k8s  microk8s    microk8s/localhost  3.1.6    unsupported  14:16:37+01:00

App          Version  Status   Scale  Charm        Channel  Rev  Address        Exposed  Message
example-k8s           waiting      1  example-k8s             1  10.152.183.43  no       waiting for container

Unit            Workload  Agent  Address      Ports  Message
example-k8s/0*  active    idle   10.1.64.140         

```


> See more: {ref}``charmcraft pack` <command-charmcraft-pack>`, [Juju | `juju refresh`](https://juju.is/docs/juju/juju-refresh), [Juju | `juju status`](https://juju.is/docs/juju/juju-status)