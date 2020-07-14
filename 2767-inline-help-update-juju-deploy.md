How does this read?

```plain
Use this command to deploy a charm or bundle into your model. You can deploy
charms and bundles from your local file system, or remote charms hosted on
the public charm store.

To deploy a charm, provide the public charm's identifier or the path to the 
charm's source code:

	juju deploy postgresql

	juju deploy /path/to/local/charm

To deploy a bundle, specify its public identifier or the location of a bundle 
definition file. To overwrite any o

	juju deploy charmed-kubernetes

	juju deploy /path/to/bundle.yaml

The deployment process is highly configurable. The most important options 
are hardware constraints (--constraints), placement directives (--to),  and 
application configuration (--config).


Minimum Hardware Requirements 

To specify minimum hardware requirements, use the '--constraints' option.
The --constraints option accepts s a space-delimited list of key=value pairs. 
Juju uses this information to select an instance type to provision. The 
key=value syntax follows the following rule:

	<constraint>=<value>[ <constraint-key>=<value>[...]]

To ensure that Juju provisions an instance with at least 8GB RAM,
4 CPU cores and a root disk size of 40GB, use three constraints within
double quotes:

	juju deploy <charm> --constraints "mem=8G cores=4 root-disk=40G"

Several constraints are supported, but the exact options available are cloud-
dependent. See the "Further Information" section below for a link to the 
reference material.


Deploy to a Machine Already in the Model 

To deploy to a pre-existing machine, use the '--to' option with the 
machine identifier:

	juju deploy <charm> --to [0-9]+

Within a k8s cloud, use labels to deploy pods to specific nodes. For example:

	juju deploy <charm> --to kubernetes.io/hostname=<hostname>


Application Configuration

Use the '--config' option to specify application configuration values. This
option accepts either a path to a YAML-formatted file or a key=value pair.

Key=value pairs can also be passed directly in the command. For example, to
declare the 'name' key:

  juju deploy <charm> --config <param>=<value> [--config <param2>=<value2> [...]]



Container Support

Within a k8s cloud, all charms and their workloads are deployed into 
containers. Outside of Kubernetes, Juju is able to provision containers itself
based on KVM or LXD. 

To deploy to a container that should be provisioned within a pre-existing 
machine, specify the container type:

	juju deploy <charm> --to (lxd|kvm)

You may request that Juju adds the container to a specific machine:

    juju deploy <charm> --to (lxd|kvm):[0-9]+


Further reading:

    https://jaas.ai/docs/deploying-applications
    https://jaas.ai/docs/using-constraints
    https://jaas.ai/docs/constraints-reference

```
