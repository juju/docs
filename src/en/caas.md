Title: CAAS
TODO:  Once 2.4 is officially released remove support Note and update status output

# CAAS

CAAS is *Containers As A Service*.

Kubernetes (often abbreviated as "k8s") provides a flexible architecture for
managing containerised applications at scale (see the
[Kubernetes documentation][upstream-kubernetes-docs] for more information).

!!! Important:
    Juju provides base Kubernetes support starting with version 2.4-beta1.

## Using Kubernetes with Juju

First off, a Kubernetes cluster will be required. Essentially, you will use it
as you would any other cloud that Juju interacts with: the cluster becomes the
backing cloud. In this document, we deploy the cluster using Juju itself.

To deploy a minimal two-machine Kubernetes cluster we'll use the
[kubernetes-core][kubernetes-core-charm] bundle available in the Charm Store:

```bash
juju deploy kubernetes-core
```

!!! Note:
    An alternative to using the bundle is to use the `conjure-up` installer.
    See Ubuntu tutorial
    [Install Kubernetes with conjure-up][ubuntu-tutorial_install-kubernetes-with-conjure-up].
    Although it specifically mentions the
    [Canonical Distribution of Kubernetes][cdk-charm] you can choose the
    identical minimal install deployed above from the tool's interface.

Sample output (here on the localhost cloud) looks like this:

```no-highlight
Model    Controller  Cloud/Region         Version    SLA
default  lxd-caas    localhost/localhost  2.4-beta1  unsupported

App                Version  Status   Scale  Charm              Store       Rev  OS      Notes
easyrsa            3.0.1    active       1  easyrsa            jujucharms   39  ubuntu  
etcd               2.3.8    active       1  etcd               jujucharms   77  ubuntu  
flannel            0.9.1    active       2  flannel            jujucharms   52  ubuntu  
kubernetes-master  1.10.0   waiting      1  kubernetes-master  jujucharms  102  ubuntu  exposed
kubernetes-worker  1.10.0   active       1  kubernetes-worker  jujucharms  114  ubuntu  exposed

Unit                  Workload  Agent  Machine  Public address  Ports           Message
easyrsa/0*            active    idle   0/lxd/0  10.0.45.195                     Certificate Authority connected.
etcd/0*               active    idle   0        10.40.174.204   2379/tcp        Healthy with 1 known peer
kubernetes-master/0*  waiting   idle   0        10.40.174.204   6443/tcp        Waiting for kube-system pods to start
  flannel/0*          active    idle            10.40.174.204                   Flannel subnet 10.1.53.1/24
kubernetes-worker/0*  active    idle   1        10.40.174.193   80/tcp,443/tcp  Kubernetes worker running.
  flannel/1           active    idle            10.40.174.193                   Flannel subnet 10.1.25.1/24

Machine  State    DNS            Inst id              Series  AZ  Message
0        started  10.40.174.204  juju-562a96-0        xenial      Running
0/lxd/0  started  10.0.45.195    juju-562a96-0-lxd-0  xenial      Container started
1        started  10.40.174.193  juju-562a96-1        xenial      Running

Relation provider                    Requirer                             Interface         Type         Message
easyrsa:client                       etcd:certificates                    tls-certificates  regular      
easyrsa:client                       kubernetes-master:certificates       tls-certificates  regular      
easyrsa:client                       kubernetes-worker:certificates       tls-certificates  regular      
etcd:cluster                         etcd:cluster                         etcd              peer         
etcd:db                              flannel:etcd                         etcd              regular      
etcd:db                              kubernetes-master:etcd               etcd              regular      
kubernetes-master:cni                flannel:cni                          kubernetes-cni    subordinate  
kubernetes-master:kube-api-endpoint  kubernetes-worker:kube-api-endpoint  http              regular      
kubernetes-master:kube-control       kubernetes-worker:kube-control       kube-control      regular      
kubernetes-worker:cni                flannel:cni 			  kubernetes-cni    subordinate
```

Copy the main configuration file from the Kubernetes master node:

```bash
mkdir ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
```
 
The contents of this file will be used in a subsequent command.

## Architecture


## Charms


## Configuration


## Commands


## Credentials


## Storage


<!-- LINKS -->

[kubernetes-core-charm]: https://jujucharms.com/kubernetes-core/
[ubuntu-tutorial_install-kubernetes-with-conjure-up]: https://tutorials.ubuntu.com/tutorial/install-kubernetes-with-conjure-up#0
[cdk-charm]: https://jujucharms.com/u/containers/canonical-kubernetes/
[upstream-kubernetes-docs]: https://kubernetes.io/docs
