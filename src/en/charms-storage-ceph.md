Title: Installing Ceph

# Installing Ceph

Here we present one way to install a rudimentary Ceph cluster with Juju backed
by an AWS cloud. See [Ceph documentation][upstream-ceph-documentation] to find
out more about Ceph.

Below, we install three Ceph monitors and three OSD systems. Each OSD system
has two 32 GiB OSDs and one 8 GiB volume dedicated to the OSD journal. All
volumes are EBS-based and magnetic (i.e. not SSD).

```bash
juju deploy -n 3 ceph-mon
juju deploy -n 3 ceph-osd --storage osd-devices=ebs,32G,2 --storage osd-journals=ebs,8G,1
juju add-relation ceph-mon ceph-osd
```

This will take a while. Presented below is the final output to the `juju status`
command:

```no-highlight
Model  Controller      Cloud/Region   Version       SLA
ceph   aws-controller  aws/us-east-1  2.3-alpha1.1  unsupported

App       Version  Status  Scale  Charm     Store       Rev  OS      Notes
ceph-mon  10.2.7   active      3  ceph-mon  jujucharms   11  ubuntu
ceph-osd  10.2.7   active      3  ceph-osd  jujucharms  245  ubuntu

Unit         Workload  Agent  Machine  Public address  Ports  Message
ceph-mon/0   active    idle   0        54.156.43.106          Unit is ready and clustered
ceph-mon/1*  active    idle   1        54.159.159.5           Unit is ready and clustered
ceph-mon/2   active    idle   2        54.144.102.36          Unit is ready and clustered
ceph-osd/0   active    idle   3        54.197.85.213          Unit is ready (2 OSD)
ceph-osd/1*  active    idle   4        54.146.68.53           Unit is ready (2 OSD)
ceph-osd/2   active    idle   5        54.224.59.60           Unit is ready (2 OSD)

Machine  State    DNS            Inst id              Series  AZ 	  Message
0        started  54.156.43.106  i-0f7fc6fd575287f7b  xenial  us-east-1a  running
1        started  54.159.159.5   i-08015f0c2c6ad45bb  xenial  us-east-1c  running
2        started  54.144.102.36  i-021d6f15b98ca13d7  xenial  us-east-1d  running
3        started  54.197.85.213  i-0a421dca4221bcf60  xenial  us-east-1c  running
4        started  54.146.68.53   i-016d906c158e2e2c0  xenial  us-east-1e  running
5        started  54.224.59.60   i-0d4b087f32320a560  xenial  us-east-1a  running

Relation  Provides  Consumes  Type
mon       ceph-mon  ceph-mon  peer
mon       ceph-mon  ceph-osd  regular
```

Now view the status of the cluster from Ceph itself by running the `ceph status`
command on one of the monitors:

```bash
juju ssh ceph-mon/0 sudo ceph status
```

Sample output:

```no-highlight
    cluster 48ef698c-7721-11e7-9f49-22000bdaa6e6
     health HEALTH_OK
     monmap e1: 3 mons at {ip-10-143-5-236=10.143.5.236:6789/0,ip-10-186-192-139=10.186.192.139:6789/0,ip-10-234-82-159=10.234.82.159:6789/0}
            election epoch 6, quorum 0,1,2 ip-10-143-5-236,ip-10-186-192-139,ip-10-234-82-159
     osdmap e22: 6 osds: 6 up, 6 in
            flags sortbitwise,require_jewel_osds
      pgmap v50: 64 pgs, 1 pools, 0 bytes data, 0 objects
            201 MB used, 191 GB / 191 GB avail
                  64 active+clean
```

This tells us that there are six OSDs, 191 GiB of available space, and all
Placement Groups are 'active+clean'.

Now list the storage from Juju:

```bash
juju list-storage
```

Output:

```no-highlight
[Storage]
Unit        Id              Type   Pool  Provider id            Size    Status    Message
ceph-osd/0  osd-devices/0   block  ebs   vol-0501570112618debf  32GiB   attached  
ceph-osd/0  osd-devices/1   block  ebs   vol-04345b11abe6bd5e8  32GiB   attached  
ceph-osd/0  osd-journals/2  block  ebs   vol-0a328ced71048ce0b  8.0GiB  attached  
ceph-osd/1  osd-devices/3   block  ebs   vol-0eaada2acc2dc851b  32GiB   attached  
ceph-osd/1  osd-devices/4   block  ebs   vol-08d7fefb838d72217  32GiB   attached  
ceph-osd/1  osd-journals/5  block  ebs   vol-0ca0e2ec9fb200e8a  8.0GiB  attached  
ceph-osd/2  osd-devices/6   block  ebs   vol-0d0a9a3a8cb4c4464  32GiB   attached  
ceph-osd/2  osd-devices/7   block  ebs   vol-0e0b54e0b70bb8ebd  32GiB   attached  
ceph-osd/2  osd-journals/8  block  ebs   vol-07de85abbdd395e1b  8.0GiB  attached 
```

Here we see the two OSDs and one journal per OSD system, for a total of nine
volumes.

This Ceph cluster is used as a basis for some examples provided in
[Using Juju Storage][charms-storage].

## Ceph Object Gateway

To allow clouds such as OpenStack and Amazon to access the Ceph cluster learn
about the [Ceph Object Gateway][upstream-ceph-object-gateway] (RADOS gateway).
To add a Ceph Object Gateway, formerly known as a 'RADOS gateway':

```bash
juju deploy ceph-radosgw
juju add-relation ceph-radosgw ceph-mon
```

Some manual configuration is necessary to complete the gateway install - see
[Configuring Ceph Object Gateway][upstream-ceph-object-gateway-configuring]. 


<!-- LINKS -->

[charms-storage]: ./charms-storage.html
[upstream-ceph-documentation]: http://docs.ceph.com/docs
[upstream-ceph-object-gateway]: http://docs.ceph.com/docs/master/radosgw/
[upstream-ceph-object-gateway-configuring]: http://docs.ceph.com/docs/jewel/radosgw/config/
