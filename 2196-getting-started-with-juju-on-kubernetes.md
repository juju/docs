Juju is the simplest way to deploy and manage applications deployed to Kubernetes. It takes the pain away from managing YAML files.

In this guide, you’ll be deploying a simple web application to a Kubernetes cluster deployed to your local machine.

## Setting up

[details="Instructions for readers on MS Windows and macOS"]
### Install Multipass

If you're not running Ubuntu, visit [multipass.run](https://multipass.run/). Multipass is a tool for quickly running virtual machines from any host operating system. This will allow you to create a fully-isolated test environment that won't impact your host system.

> Multipass provides a command line interface to launch, manage and generally fiddle about with instances of Linux. The downloading of a minty-fresh image takes a matter of seconds, and within minutes a VM can be up and running.
>&mdash; [The Register](https://www.theregister.co.uk/2019/01/22/multipass/)

### Create virtual machine 

We want to be able to experiment with Juju and evaluate it without the testing impacting on the rest of our system. To enter a shell within a virtual machine `microcloud` that has 8 GB RAM allocated to it, execute this command:

```plaintext
$ multipass launch -n microcloud -m 8g -c 2 -d 20G 
Launched: microcloud
```

Once `multipass` has downloaded the latest Long Term Support version of the Ubuntu operating system, you will be able to enter a command-line shell:

```plain
$ multipass shell microcloud
[...]
multipass@microcloud:~$
```
[/details]


## Install microk8s

[microk8s](https://microk8s.io/) is "single node Kubernetes done right". From the website:

> The smallest, fastest, fully-conformant Kubernetes that tracks upstream releases and makes clustering trivial. MicroK8s is great for offline development, prototyping, and testing. Use it on a VM as a small, cheap, reliable k8s for CI/CD.



```plain
snap install microk8s
```


[details="Need to install snap?"]
Visit the [snapcraft homepage](https://snapcraft.io/docs/installing-snapd) for installation instructions. **Snap** makes software installation trivial and secure.
[/details]
