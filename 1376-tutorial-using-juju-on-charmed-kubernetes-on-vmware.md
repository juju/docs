*This is in connection to the topic of [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090). See that page for background information.*

This tutorial explains how to deploy a Kubernetes cluster on VMWare vSphere and configure Juju so that it can deploy k8s charms on that cluster.

If you have any comments or suggestions, let me know! 

# Requirements

You need a working Juju controller connected to a working VMWare vsphere cluster, and have switched to the model you want to deploy the Kubernetes cluster to.

More information on [setting up a Juju controller on VMWare vsphere](https://discourse.jujucharms.com/t/using-vmware-vsphere-with-juju/1099).  *If you can't get Juju to work on VMWare vsphere, let me know and I'll add the bootstrap instructions we use.*

# 1. Deploy Kubernetes on VMWare

I'm using the [Kubernetes Core](https://jujucharms.com/kubernetes-core/bundle/609) bundle, but this should also work with the [Charmed Distribution of Kubernetes](https://jujucharms.com/canonical-kubernetes/bundle/471).

The defaults of these bundles are good, so you can just deploy them.

```bash
juju deploy cs:bundle/kubernetes-core
```

# 2. Deploy Ceph

We'll be using Ceph for persistent storage. Persistent storage is required for running Juju on Kubernetes.

In this example we'll be installing Ceph on VMWare too. This setup isn't optimal however, because this creates an additional layer of indirection in storage. It's better to use an existing Ceph cluster deployed on bare metal.

```bash
# Deploy the ceph cluster
juju deploy -n 3 ceph-mon --constraints "mem=1G"
juju deploy -n 3 ceph-osd --storage osd-devices=200G,2 --storage osd-journals=8G,1 --constraints "root-disk=500G mem=1G"
juju add-relation ceph-osd ceph-mon

# Connect the Ceph cluster to Kubernetes, this will add the Ceph cluster as "Storage Classes" to k8s
juju add-relation ceph-mon:admin kubernetes-master
juju add-relation ceph-mon:client kubernetes-master
```

These commands add ceph as the default storage class to k8s. Juju will use the default storage class in k8s if no other storage pool is configured.

More info: [attaching Ceph storage to Charmed Kubernetes](https://www.ubuntu.com/kubernetes/docs/storage)
The constraints are derived from the [hardware recommendations for Ceph clusters](http://docs.ceph.com/docs/jewel/start/hardware-recommendations/).

# 3. Wait

Wait until the entire deployment is complete before proceeding to the next step. The following command shows you the status and updates every 2 seconds.

```bash
watch -c juju status --color
```

# 4. Download the Kubernetes `kubectl` config

You need the right info to connect Juju to the k8s cluster.

```bash
juju scp kubernetes-master/0:config ~/.kube/config
```

You can find more info on getting started with `kubectl` and the Charmed Kubernetes bundles in the READMEs of those bundles.

# 5. Add the K8s cluster to the existing Juju controller

Now you can add the k8s cluster as a "cloud" to the controller. This will allow you to create models juju models on that cluster.

```bash
juju add-k8s k8s-test-cloud
```

This command uses config you just downloaded to `~/.kube/config`.

# 6. Create a k8s model on the Juju controller

You can create a k8s model on the controller by specifying the k8s cloud you just added.

```bash
juju add-model k8s-test k8s-test-cloud
```
# 7. Deploy an k8s charm in the Juju model

At this point you should have a working model, ready to deploy charms. Test it out by deploying MariaDB.

```bash
juju deploy cs:~juju/mariadb-k8s mdb3
```

*Note that we don't specify which storage the database should use. This will cause Juju to use the default k8s storage.*
