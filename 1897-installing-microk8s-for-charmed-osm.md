[MicroK8s](https://microk8s.io/) is a fast, lightweight, and certified distribution of Kubernetes that is made for developers. It's a great choice if you want Kubernetes within minutes. 

```bash
sudo snap install microk8s --channel 1.14/stable --classic
microk8s.status --wait-ready
microk8s.enable dashboard storage dns

# For easier access, create an alias to microk8's kubectl command
sudo snap alias microk8s.kubectl kubectl

# Bootstrap the Kubernetes cloud
juju bootstrap microk8s osm-on-k8s

# Add a new model for OSM
juju add-model osm
```
