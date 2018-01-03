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
command for a model called 'ceph':

<!-- JUJUVERSION: 2.3.1-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
```no-highlight
Model  Controller  Cloud/Region   Version  SLA
ceph   aws         aws/us-east-1  2.3.1    unsupported

App       Version  Status  Scale  Charm     Store       Rev  OS      Notes
ceph-mon  10.2.9   active      3  ceph-mon  jujucharms   18  ubuntu  
ceph-osd  10.2.9   active      3  ceph-osd  jujucharms  252  ubuntu  

Unit         Workload  Agent  Machine  Public address  Ports  Message
ceph-mon/0   active    idle   0        54.157.253.136         Unit is ready and clustered
ceph-mon/1*  active    idle   1        54.166.249.23          Unit is ready and clustered
ceph-mon/2   active    idle   2        54.221.92.67           Unit is ready and clustered
ceph-osd/0   active    idle   3        54.156.62.76           Unit is ready (2 OSD)
ceph-osd/1   active    idle   4        54.167.125.232         Unit is ready (2 OSD)
ceph-osd/2*  active    idle   5        54.159.206.197         Unit is ready (2 OSD)

Machine  State    DNS             Inst id              Series  AZ          Message
0        started  54.157.253.136  i-02969e42b6654c4cb  xenial  us-east-1c  running
1        started  54.166.249.23   i-09a55570b2c47159f  xenial  us-east-1a  running
2        started  54.221.92.67    i-04467e3dce94a0795  xenial  us-east-1d  running
3        started  54.156.62.76    i-0ee866a3b9a8f2b02  xenial  us-east-1a  running
4        started  54.167.125.232  i-0610ebe802907fc3e  xenial  us-east-1d  running
5        started  54.159.206.197  i-0b9fbb073810df44c  xenial  us-east-1c  running

Relation provider  Requirer      Interface  Type     Message
ceph-mon:mon       ceph-mon:mon  ceph       peer     
ceph-mon:osd       ceph-osd:mon  ceph-osd   regular
```

Now view the status of the cluster from Ceph itself by running the `ceph status`
command on one of the monitors:

```bash
juju ssh ceph-mon/0 sudo ceph status
```

Sample output:

```no-highlight
   cluster 316b16da-f02a-11e7-9315-22000b270782
     health HEALTH_OK
     monmap e2: 3 mons at {ip-10-111-155-227=10.111.155.227:6789/0,ip-10-153-224-190=10.153.224.190:6789/0,ip-10-232-134-102=10.232.134.102:6789/0}
            election epoch 12, quorum 0,1,2 ip-10-111-155-227,ip-10-153-224-190,ip-10-232-134-102
     osdmap e27: 6 osds: 6 up, 6 in
            flags sortbitwise,require_jewel_osds
      pgmap v62: 64 pgs, 1 pools, 0 bytes data, 0 objects
            202 MB used, 191 GB / 191 GB avail
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
ceph-osd/0  osd-devices/0   block  ebs   vol-078db09cf280baa61  32GiB   attached  
ceph-osd/0  osd-devices/1   block  ebs   vol-04ef7df7ae5ef688b  32GiB   attached  
ceph-osd/0  osd-journals/2  block  ebs   vol-056e0f1ae9ef3ee35  8.0GiB  attached  
ceph-osd/1  osd-devices/3   block  ebs   vol-06a0a30d8bb069be5  32GiB   attached  
ceph-osd/1  osd-devices/4   block  ebs   vol-021706e37f90eb5c1  32GiB   attached  
ceph-osd/1  osd-journals/5  block  ebs   vol-02bfd75cae548800c  8.0GiB  attached  
ceph-osd/2  osd-devices/6   block  ebs   vol-0321404bf7050c1b3  32GiB   attached  
ceph-osd/2  osd-devices/7   block  ebs   vol-0cfc7464af10aebd2  32GiB   attached  
ceph-osd/2  osd-journals/8  block  ebs   vol-0236aed9919b0ec8e  8.0GiB  attached
```

Here we see each Ceph OSD unit has two OSD volumes and one journal volume, for
a total of nine volumes.

This Ceph cluster is used as a basis for some examples provided in
[Using Juju Storage][charms-storage].


<!-- LINKS -->

[charms-storage]: ./charms-storage.html
[upstream-ceph-documentation]: http://docs.ceph.com/docs
