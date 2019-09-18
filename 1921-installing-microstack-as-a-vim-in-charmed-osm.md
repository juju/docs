This guide will walk you through installing the Microstack and using it as a VIM in Charmed OSM.
<!--
## Requirements

You must have completed the [Charmed OSM installation](https://discourse.jujucharms.com/t/installing-charmed-osm/1554) on [MicroK8s](https://discourse.jujucharms.com/t/install-microk8s/1897)
-->
## Install microstack
Before installing Microstack, please review our [Performance Tunning](https://discourse.jujucharms.com/t/advanced-performance-tuning/1885) for system requirements.

```bash
sudo snap install microstack --classic --channel=edge/rocky
sudo microstack.init --auto
```

## Basic Configuration
#### Add security rules
The following commands will allow OSM to ssh the VNFs when it will be needed.
```bash
SECGROUP_ID=$(microstack.openstack security group list --project admin -f value -c ID)
microstack.openstack security group rule create $SECGROUP_ID \
                     --proto tcp \
                     --remote-ip 0.0.0.0/0 \
                     --dst-port 22
microstack.openstack security group rule create $SECGROUP_ID \
                     --proto icmp \
                     --remote-ip 0.0.0.0/0
```
#### Enable DHCP
To get external IPs assigned we will enable DHCP.
```bash
SUBNET_ID=$(microstack.openstack subnet list | grep external-subnet | awk '{ print $2 }')
microstack.openstack subnet set --dhcp $SUBNET_ID
```
#### Add Ubuntu image
```bash
wget https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img
microstack.openstack image create \
                     --public \
                     --disk-format qcow2 \
                     --container-format bare \
                     --file ubuntu-16.04-server-cloudimg-amd64-disk1.img \
                     ubuntu1604
```

## Configuring OSM
#### Generate keypair
For us to be able to ssh into our VMs we will create a keypair just used for microstack.
```bash
ssh-keygen -t rsa -N "" -f ~/.ssh/microstack
microstack.openstack keypair create --public-key ~/.ssh/microstack.pub microstack
```
#### Add microstack as a VIM
At this point, it is assumed you have previously exported the environment variable `OSM_HOSTNAME` to configure the osmclient. Now we will proceed adding the microstack in OSM as a VIM using the `vim-create` command.

```bash
osmclient.osm vim-create --name microstack-site \
    --user admin \
    --password keystone \
    --auth_url http://10.20.20.1:5000/v3 \
    --tenant admin \
    --account_type openstack \
    --config='{security_groups: default,
               keypair: microstack,
               project_name: admin,
               user_domain_name: default,
               region_name: microstack,
               insecure: True,
               availability_zone: nova,
               version: 3}'
```

#### Download simple VNF and NS
In order to exercise OSM, you will need to download or create your own VNF and NS descriptors. As the main purpose of this page is to use microstack as a VIM in OSM,  we will download a basic VNF and NS from OSM's public FTP.

```bash
wget http://osm-download.etsi.org/ftp/osm-5.0-five/6th-hackfest/packages/hackfest_basic_vnf.tar.gz
wget http://osm-download.etsi.org/ftp/osm-5.0-five/6th-hackfest/packages/hackfest_basic_ns.tar.gz
```

#### Upload descriptors
The osm client provides commands to upload descriptors.

```bash
osmclient.osm upload-package hackfest_basic_vnf.tar.gz
osmclient.osm upload-package hackfest_basic_ns.tar.gz
```

#### Create a basic Network Service
Finally, with the following command we can have our first basic network descriptor created.

```bash
osmclient.osm ns-create --ns_name hackfest_basic_ns \
                        --nsd_name hackfest_basic-ns \
                        --vim_account microstack-site
```

## Checking the status of a Network Service
The command `osmclient.osm ns-list` will show you the status of the Network Services.
```bash
$ osmclient.osm ns-list
+-------------------+--------------------------------------+--------------------+---------------+-----------------+
| ns instance name  | id                                   | operational status | config status | detailed status |
+-------------------+--------------------------------------+--------------------+---------------+-----------------+
| hackfest_basic_ns | 0133e3fe-e648-4b3d-8cf6-d55fed8b458d | running            | configured    | done            |
+-------------------+--------------------------------------+--------------------+---------------+-----------------+

```

You can also check that the VNFs are successfully created using `microstack.openstack server list` command.
```bash
microstack.openstack server list
+--------------------------------------+-----------------------------------------+--------+---------------------------------+------------+-----------------------+
| ID                                   | Name                                    | Status | Networks                        | Image      | Flavor                |
+--------------------------------------+-----------------------------------------+--------+---------------------------------+------------+-----------------------+
| 13707a28-9644-4148-aadd-46707fbf40a5 | hackfest_basic_ns-1-hackfest_basic-VM-1 | ACTIVE | mgmtnet=192.168.1.12            | ubuntu1604 | hackfest_basic-VM-flv |
+--------------------------------------+-----------------------------------------+--------+---------------------------------+------------+-----------------------+
```
