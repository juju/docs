## Installation

### ERROR cannot deploy bundle

> ERROR cannot deploy bundle: cannot add charm "cs:~charmed-osm/grafana-k8s-15": cannot retrieve charm "cs:~charmed-osm/grafana-k8s-15": cannot get archive: Get https://api.jujucharms.com/charmstore/v5/~charmed-osm/grafana-k8s-15/archive?channel=stable: dial tcp: lookup api.jujucharms.com on 10.152.183.10:53: read udp 10.1.1.11:36266->10.152.183.10:53: i/o timeout

This can happen if you deploy MicroK8s in an environment with strict network access.

In order to solve this, we need to edit the `kube-dns` configuration to point to your DNS servers. Edit the configuration and both sets of DNS addresses accordingly:

```
microk8s.kubectl -n kube-system edit configmap/kube-dns
```

`kube-dns` will automatically reload the configuration, so re-run `juju deploy` command and verify that the error is resolved.

Get the name of the kube-dns pod:

```
$ kubectl -n kube-system get pods
NAME                                              READY   STATUS    RESTARTS   AGE
heapster-v1.5.2-6b5d7b57f9-c9vln                  4/4     Running   0          67m
hostpath-provisioner-6d744c4f7c-cr9br             1/1     Running   0          71m
kube-dns-6bfbdd666c-xrnnb                         3/3     Running   3          71m
kubernetes-dashboard-6fd7f9c494-zx6s9             1/1     Running   0          71m
monitoring-influxdb-grafana-v4-78777c64c8-lsh8l   2/2     Running   2          71m
```

Check the logs for dnsmasq container in the pod:

```
$ kubectl -n kube-system logs kube-dns-6bfbdd666c-xrnnb dnsmasq
```

Once `dnsmasq` is able to resolve hostnames, you can continue with the installation.

### ERROR Permission denied, are you in the lxd group?

If you receive this error while running `juju bootstrap localhost osm-lxd`, it means that your current user is not in the `lxd` group.

```
sudo add-user $USER lxd
newgrp lxd
```

### ERROR failed to bootstrap model

This seems to happen if trying to bootstrap before microk8s is ready (like after enabling plugins)

```bash
$ juju bootstrap microk8s osm-on-k8s
Creating Juju controller "osm-on-k8s" on microk8s/localhost
Creating k8s resources for controller "controller-osm-on-k8s"
ERROR failed to bootstrap model: creating controller stack for controller: creating statefulset for controller: fetching pods' status for controller: Get https://10.48.130.54:16443/api/v1/namespaces/controller-osm-on-k8s/pods/controller-0?includeUninitialized=true: dial t
cp 10.48.130.54:16443: connect: connection refused
WARNING k8s cluster is not accessible: Get https://10.48.130.54:16443/api/v1/namespaces?fieldSelector=metadata.name%3Dcontroller-osm-on-k8s&includeUninitialized=true&watch=true: dial tcp 10.48.130.54:16443: connect: connection refused
```

Attempting to bootstrap again will lead to:

```
$ juju bootstrap microk8s osm-on-k8s
ERROR a controller called "osm-on-k8s" already exists on this k8s cluster.
Please bootstrap again and choose a different controller name.
```

To recover, the controller namespace needs to be deleted from Kubernetes

```bash
microk8s.kubectl delete namespace controller-osm-on-k8s
```

When that is finished, re-run the bootstrap command.
