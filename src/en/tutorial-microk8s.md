Title: Using Juju with microk8s

# Using Juju with microk8s

*This is in connection with the [Using Kubernetes with Juju][clouds-k8s] page.
See that resource for background information.*

This tutorial has the following pre-requisites:

 1. Juju is installed (see ????)
 1. 
udo apt update && sudo apt -y full-upgrade && sudo snap install lxd && sudo apt purge -y liblxc1 lxcfs lxd lxd-client && sudo snap install --edge --classic juju && sudo reboot
sudo snap install --edge --classic microk8s
juju bootstrap --config charmstore-url=https://api.staging.jujucharms.com/charmstore localhost lxd-microk8s
microk8s.enable dns storage
microk8s.config | juju add-k8s lxd-microk8s-cloud
juju add-model lxd-microk8s-model lxd-microk8s-cloud
juju create-storage-pool operator-storage kubernetes storage-class=microk8s-hostpath
juju create-storage-pool mariadb-pv kubernetes storage-class=microk8s-hostpath
juju deploy cs:~wallyworld/mariadb-k8s --storage database=mariadb-pv,10M

<!-- LINKS -->

[clouds-k8s]: ./clouds-k8s.md
