(machine)=
# Machine

> See also: {ref}`How to manage machines <how-to-manage-machines>`

In Juju, a **machine** is any instance requested explicitly (via {ref}``juju add-machine` <5459md>`) or implicitly (e.g., {ref}``juju bootstrap` <5459md>`, {ref}``juju deploy` <5459md>`, {ref}``juju add-unit` <5459md>`)  from a  {ref}`'machine' cloud <cloud-substrate>`. 

```{important}

This definition suggests that, regardless of whether the cloud is bare metal cloud, a virtual machine cloud, or a LXD container- or VM-based cloud, and regardless of whether the command targets a regular instance or rather a LXD container on a regular instance (all the commands above can apply to both), what's being provisioned is always, from the point of view of Juju, a 'machine'. 

From the point of view of an end user, this is absolutely true, with one small caveat -- even though listed in `juju` outputs under 'Machines', and in general handled via the same CLI commands as a machine, a LXD container provisioned on top of a regular cloud instance will be named after its host machine; e.g., `0/lxd/5` = LXD container `5` on machine `0`.

```

**Contents:**

- [Machines and units](#heading--machines-and-units)
- [Machines and system (LXD) containers](#heading--machines-and-system-lxd-containers)
- [Machine designations](#heading--machine-designations)
- [Machine customisation](#heading--machine-customisation)	

<a href="#heading--machines-and-units"><h2 id="heading--machines-and-units">Machines and units</h2></a>

When you deploy an {ref}`application <application>` on a machine, there is usually one {ref}`unit <unit>` per machine. However, it is usually possible to optimise resources by deploying multiple units of the same or of different applications to the same machine. 


<a href="#heading--machines-and-system-lxd-containers"><h2 id="heading--machines-and-system-lxd-containers">Machines and system (LXD) containers</h2></a>

In Juju, they are both essentially the same -- 'machines'.  For example, most Juju CLI commands that target machines can actually target system containers in the exact same way.  

----
```{dropdown} Expand to view an example

E.g., `juju add-machine lxd` starts a LXD container on a new machine and adds *both* as 'machines' -- the only difference being that the container 'machine' is prefixed with the ID of its host machine and the annotation `lxd`:

```text
$ juju add-machine lxd
created container 1/lxd/0

$ juju machines
Machine  State    Address         Inst id        Base          AZ  Message
0        started  10.154.118.110  juju-dadfb7-0  ubuntu@22.04      Running
1        pending                  pending        ubuntu@22.04      Creating container
1/lxd/0  pending                  pending        ubuntu@22.04      
```

And if you then deploy an application to a LXD container (without specifying any particular container), that will again provision two machines:

```text
$ juju deploy postgresql --to lxd
Located charm "postgresql" in charm-hub, revision 288
Deploying "postgresql" from charm-hub charm "postgresql", revision 288 in channel 14/stable on ubuntu@22.04/stable
ubuntu@charm-dev:~/.local/share/juju$ juju machines
Machine  State    Address         Inst id              Base          AZ  Message
0        started  10.154.118.110  juju-dadfb7-0        ubuntu@22.04      Running
1        started  10.154.118.72   juju-dadfb7-1        ubuntu@22.04      Running
1/lxd/0  pending                  juju-dadfb7-1-lxd-0  ubuntu@22.04      Container started
2        started  10.154.118.209  juju-dadfb7-2        ubuntu@22.04      Running
2/lxd/0  pending                  pending              ubuntu@22.04      acquiring LXD image
```


```

----

<a href="#heading--machine-designations"><h2 id="heading--machine-designations">Machine designations</h2></a>

In Juju, many different commands have a machine argument. The shape of this argument depends on whether the machine is existing vs. new and a regular cloud instance vs. a LXD container on top of a regular cloud instance. The argument can also contain combinations, in comma-separated format. The examples below illustrate all the various cases:

<!--
- When the machine is a regular cloud instance, the ID is numeric, e.g., `1`. 
- When the machine is a LXD container provisioned on top of a regular cloud instance, the ID will take the form `<host instance ID>/lxd/<container ID>`, e.g., `0/lxd/4`. 
- When the target machine does not yet exist, and thus does not yet have an ID, it is omitted. 
- When the target container 'machine' does not yet exist but the target host instance does, so its ID is known, the ID will take the form `lxd:<host instance ID>`, e.g., `lxd:4`. When the target is more than one machine, the IDs can be specified at the same time, in comma-separated format. For more concreteness, some examples along with their gloss:
-->

| shape of the machine argument | meaning|
|-|-|
|  | a new machine | 
|`0`| machine 0 |
|`0,4`| machines 0 and 4|
| `lxd` | a new LXD container  on a new machine |
| `lxd:25`| a new LXD container on machine 25|
| `0/lxd/4`| LXD container `4` on machine `0`|
|`3,0/lxd/2,lxd:5`| machine 3, LXD container 2 on machine 0, and a new LXD container on machine 5|

<a href="#heading--machine-customisation"><h2 id="heading--machine-customisation">Machine customisation</h2></a>
A machine's specific hardware can be customised via {ref}`constraints <constraint>`.







<!--
**Contents:**
- [Ways to refer to a machine](#heading--ways-to-refer-to-a-machine)

<a href="#heading--ways-to-refer-to-a-machine"><h2 id="heading--ways-to-refer-to-a-machine">Ways to refer to a machine</h2></a>
-->