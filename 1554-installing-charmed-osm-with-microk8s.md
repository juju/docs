This guide will walk you through installing the Charmed Distribution of OSM.

## Requirements

We suggest the following minimum requirements:

- Ubuntu Bionic
- 4 CPU
- 8 GB RAM
- 50G free disk space

## Getting Started

Install the basic prerequisites.

```bash
sudo snap install juju --classic
sudo snap install osmclient --edge
```

## Alias

The osm command will be available via `osmclient.osm`. You can create an alias to `osm` with the following command:

```bash
$ sudo snap alias osmclient.osm osm
Added:
  - osmclient.osm as osm
```

## Connect Snap Interface

By default, snaps need to be given permissions to read hidden resources in your home directory. This will allow the `osmclient` snap to access your Juju configuration.

```bash
sudo snap connect osmclient:juju-client-observe
```

## Bootstrap Juju on LXD

> NOTE: It is not necessary to use  `sudo` with any `juju` command. Doing so may lead to permission denied errors.

Bootstrap the Juju controller, on LXD, that OSM will use to deploy proxy charms.

Before that, make sure LXD is [installed and configured correctly to work with Charmed OSM](https://discourse.jujucharms.com/t/configuring-lxd-for-charmed-osm/1920)

```bash
juju bootstrap localhost osm-lxd
```

## Install and configure MicroK8s

[MicroK8s](https://microk8s.io/) is a fast, lightweight, and certified distribution of Kubernetes that is made for developers. It's a great choice if you want Kubernetes within minutes. 

```bash
sudo snap install microk8s --channel 1.14/stable --classic
sudo usermod -a -G microk8s $USER
newgrp microk8s
microk8s.status --wait-ready
microk8s.enable storage dns

# For easier access, create an alias to microk8's kubectl command
sudo snap alias microk8s.kubectl kubectl

# Bootstrap the Kubernetes cloud
juju bootstrap microk8s osm-on-k8s

# Add a new model for OSM
juju add-model osm
```

## Install OSM

Generate a bundle overlay containing the credentials of our OSM Juju controller and deploy 

```bash
osmclient.overlay
```

### Deployment

Choose how you would like Charmed OSM to be deployed. 

### Standalone

The standalone version is perfect for evaluation and development purposes. Each component is installed with a single instance, ideal for running on a laptop or workstation, pairing well with microk8s.

```bash
juju deploy osm --overlay vca-overlay.yaml
```

#### High-Availability

For production use, we offer a high-availability version of Charmed OSM. Each component will be deployed in clusters of three units setup with failover, and requires significantly more resources to operate.

```bash
juju deploy osm-ha --overlay vca-overlay.yaml
```

## Status

It can take several minutes or longer to install, depending on your machine and bandwidth. To monitor the progress of the installation, you can watch the output of `juju status`:

```bash
$ watch -c juju status --color
Every 2.0s: juju status --color                                                                                                                                                                                                             micro-osm: Fri Aug 23 17:03:25 2019

Model  Controller  Cloud/Region        Version  SLA          Timestamp
osm    osm-on-k8s  microk8s/localhost  2.6.6    unsupported  17:03:27Z

App             Version  Status  Scale  Charm           Store       Rev  OS          Address         Notes 
grafana-k8s              active      1  grafana-k8s     jujucharms   15  kubernetes  10.152.183.122 
kafka-k8s                active      1  kafka-k8s       jujucharms    1  kubernetes  10.152.183.90     
lcm-k8s                  active      1  lcm-k8s         jujucharms   21  kubernetes  10.152.183.44 
mariadb-k8s              active      1  mariadb-k8s     jujucharms   16  kubernetes  10.152.183.75     
mon-k8s                  active      1  mon-k8s         jujucharms   14  kubernetes  10.152.183.231   
mongodb-k8s              active      1  mongodb-k8s     jujucharms   15  kubernetes  10.152.183.15     
nbi-k8s                  active      1  nbi-k8s         jujucharms   24  kubernetes  10.152.183.104 
pol-k8s                  active      1  pol-k8s         jujucharms   14  kubernetes  10.152.183.230 
prometheus-k8s           active      1  prometheus-k8s  jujucharms   14  kubernetes  10.152.183.13    
ro-k8s                   active      1  ro-k8s          jujucharms   20  kubernetes  10.152.183.56     
ui-k8s                   active      1  ui-k8s          jujucharms   28  kubernetes  10.152.183.7     
zookeeper-k8s            active      1  zookeeper-k8s   jujucharms   16  kubernetes  10.152.183.140     

Unit               Workload  Agent  Address    Ports                       Message   
grafana-k8s/0*     active    idle   10.1.1.39  3000/TCP                    configured   
kafka-k8s/0*       active    idle   10.1.1.32  9092/TCP                    configured   
lcm-k8s/0*         active    idle   10.1.1.36  80/TCP                      configured   
mariadb-k8s/0*     active    idle   10.1.1.24  3306/TCP                    ready   
mon-k8s/0*         active    idle   10.1.1.33  8000/TCP                    configured   
mongodb-k8s/0*     active    idle   10.1.1.26  27017/TCP                   configured   
nbi-k8s/0*         active    idle   10.1.1.35  9999/TCP                    configured   
pol-k8s/0*         active    idle   10.1.1.34  80/TCP                      configured   
prometheus-k8s/0*  active    idle   10.1.1.38  9090/TCP                    configured
ro-k8s/0*          active    idle   10.1.1.30  9090/TCP                    configured   
ui-k8s/0*          active    idle   10.1.1.37  80/TCP                      configured   
zookeeper-k8s/0*   active    idle   10.1.1.31  2181/TCP,2888/TCP,3888/TCP  configured   
```

When all Status and Workloads are shown in an `active` state, your installation of OSM is ready to use.

## Post-deployment

Once Charmed OSM has been successfully installed, set the OSM_HOSTNAME.

First, get the IP address of the `nbi-k8s` *application*.

```bash
$ juju status nbi-k8s
Model  Controller  Cloud/Region        Version  SLA          Timestamp
osm    osm-on-k8s  microk8s/localhost  2.6.6    unsupported  17:15:10Z

App      Version  Status  Scale  Charm    Store       Rev  OS          Address         Notes
nbi-k8s           active      1  nbi-k8s  jujucharms   24  kubernetes  10.152.183.104  

Unit        Workload  Agent  Address    Ports     Message
nbi-k8s/0*  active    idle   10.1.1.35  9999/TCP  configured
```

Next, export the `OSM_HOSTNAME` variable and confirm that the platform is operational:

```bash
$ export OSM_HOSTNAME=10.152.183.104
```
You may now interact with Charmed OSM via the `osm` command. To make this persistent across sessions, it's recommended to add this to your `~/.bashrc`.

```bash
$ osm vim-list
+----------+------+
| vim name | uuid |
+----------+------+
+----------+------+

$ osm user-list
+-------+--------------------------------------+
| name  | id                                   |
+-------+--------------------------------------+
| admin | 51b369ed-942e-4a61-a031-64eaa15e8cff |
+-------+--------------------------------------+

```
