Title: Juju and FAN networking
TODO:  bug tracking: https://bugs.launchpad.net/juju/+bug/1733354 (remove constraints Note if no longer required)
       hardcoded: default AWS instance type of 'm3.medium'
       consider a third example: manually configure the FAN with Azure

# Juju and FAN networking

FAN networking addresses a need raised by the proliferation of container usage
in an IPv4 context: the ability to manage the address space such that network
connectivity among containers running on separate hosts is achieved.

Juju integrates with the FAN to provide network connectivity between containers
that was hitherto not possible. The typical use case is the seamless
interaction between deployed applications running within LXD containers on
separate Juju machines.

## FAN overview

The FAN is a mapping between a smaller IPv4 address space (e.g. a /16 network)
and a larger one (e.g. a /8 network) where **subnets** from the smaller one (the
*underlay* network) are assigned to **addresses** on the larger one (the
*overlay* network). Connectivity between containers on the larger network is
enabled in a simple and efficient manner.

In the case of the above networks (/16 underlay and /8 overlay), each host
address on the underlay "provides" 253 addresses on the overlay. FAN networking
can thus be considered a form of "address expansion".

Further reading on generic (non-Juju) FAN networking:

 - [FAN networking][fan-ubuntu-wiki] : general user documentation
 - [Container-to-Container Networking][fan-ubuntu-insights] : a less technical
   overview
 - [LXD network configuration][fan-lxd-config-options] : FAN configuration
   options at the LXD level
 - [`fanctl` man page][fan-fanctl-man-page] : configuration information at the
   operating system level

## Juju model FAN configuration

Juju manages FAN networking at the model level, with the relevant configuration
options being `fan-config` and `container-networking-method`.

First, configure the FAN via `fan-config`. This option can assume a
space-separated list of `<underlay-network>=<overlay-network>`. This option
maps the underlay network to the overlay network.

```bash
juju model-config fan-config=10.0.0.0/16=252.0.0.0/8
```

Then, enable the FAN with the `container-networking-method` option. It can take
on the following values:

 - local : standard LXD; addressing based on the LXD bridge (e.g. lxdbr0)
 - provider : addressing based on host bridge; works only with providers with
   built-in container addressing support (e.g. MAAS with LXD)
 - fan : FAN networking; works with any provider, in principle

```bash
juju model-config container-networking-method=fan
```

To confirm that a model is properly configured use the following command:

```bash
juju model-config | egrep 'fan-config|container-networking-method'
```

This example will produce the following output:

```no-highlight
container-networking-method   model    fan
fan-config                    model    10.0.0.0/16=252.0.0.0/8
```

See [Configuring models][models-config] for more details on setting model
options.

## Cloud provider requirements

Juju autoconfigures FAN networking for both the AWS and GCE clouds. All that
is needed is a controller, which does not need any special FAN options passed
during its creation.

In principle, all public cloud types can utilize the FAN. Yet due to the myriad
ways a cloud may configure their subnets your mileage may vary. At the very
least, if you are using a cloud other than AWS or GCE, manual configuration at
the Juju level will be needed (the above model options). Adjustments at the
cloud level can also be expected. For guidance, the auto-configured clouds both
start with a /16 address space. Juju then maps it onto an /8.

Note that [MAAS][maas-upstream] has LXD addressing built-in so there is no
point in applying the FAN in such a context.

## Examples

Two examples are provided. Each will use a different cloud:

 - Rudimentary confirmation of the FAN using a GCE cloud
 - Deploying applications with the FAN using an AWS cloud

### Rudimentary confirmation of the FAN using a GCE cloud

FAN networking works out-of-the-box with GCE. We'll use a GCE cloud to perform
a rudimentary confirmation that the FAN is in working order by creating two
machines with a LXD container on each. A network test will then be performed
between the two containers to confirm connectivity.

Here we go:

```bash
juju add-machine -n 2
juju deploy ubuntu --to lxd:0
juju add-unit ubuntu --to lxd:1
```

After a while, we see the following output to command
`juju machines -m default | grep lxd`:

```no-highlight
0/lxd/0  started  252.0.63.146    juju-477cfe-0-lxd-0  xenial  us-east1-b Container started
1/lxd/0  started  252.0.78.212    juju-477cfe-1-lxd-0  xenial  us-east1-c Container started
```

So these two containers should be able to contact one another if the FAN is up:

```bash
juju ssh -m default 0 sudo lxc exec juju-477cfe-0-lxd-0 '/usr/bin/tracepath 252.0.78.212'
```

Output:

```no-highlight
1?: [LOCALHOST]                                         pmtu 1410
 1:  252.0.78.212                                          1.027ms reached
 1:  252.0.78.212                                          0.610ms reached
     Resume: pmtu 1410 hops 1 back 1 
Connection to 35.196.138.253 closed.
```

Good work.

### Deploying applications with the FAN using an AWS cloud

To use FAN networking with AWS a *virtual private cloud* (VPC) is required.
Fortunately, a working VPC is provided with every AWS account and is used, by
default, when creating regular EC2 instances.  

!!! Note:
    You may need to create a new VPC if you are using an old AWS account (the
    original VPC may be deficient). Some may simply prefer to have a
    Juju-dedicated VPC. See [Creating an AWS VPC][fan-aws-vpc] for
    instructions.

Whether you created a secondary VPC out of necessity or preference you will
need to inform Juju about it. See
[AWS specific features][anchor__aws-specific-features] for how to do this.

Here, FAN networking will be leveraged by deploying and relating applications
that are running in different LXD containers, where the containers are housed
on separate machines.

```bash
juju add-machine -n 2
juju deploy mysql --to lxd:0
juju deploy wordpress --to lxd:1
juju add-relation mysql wordpress
```

!!! Note:
    A VPC may fail to provide the default AWS instance type of 'm3.medium'. See
    [AWS specific features][anchor__aws-specific-features] for how to request
    an alternative.

A partial output to `juju status` is:

```no-highlight
Unit          Workload  Agent      Machine  Public address  Ports     Message
mysql/0*      active    idle       0/lxd/0  252.0.82.239    3306/tcp  Ready
wordpress/0*  active    executing  1/lxd/0  252.0.169.174   80/tcp
```

We can confirm that the MySQL container can contact the WordPress container
with:

```bash
juju ssh mysql/0 exec nc -vz 252.0.169.174 80
```

This example test was successful by yielding the following output:

```no-highlight
Connection to 252.0.169.174 80 port [tcp/http] succeeded!
```


<!-- LINKS -->

[maas-upstream]: https://maas.io/
[fan-ubuntu-wiki]: https://wiki.ubuntu.com/FanNetworking
[fan-ubuntu-insights]: https://insights.ubuntu.com/2015/06/22/container-to-container-networking-the-bits-have-hit-the-fan/
[fan-lxd-config-options]: https://github.com/lxc/lxd/blob/master/doc/networks.md
[fan-fanctl-man-page]: http://manpages.ubuntu.com/cgi-bin/search.py?q=fanctl
[fan-aws-vpc]: ./charms-fan-aws-vpc.html
[models-config]: ./models-config.html
[anchor__aws-specific-features]: ./help-aws.html#aws-specific-features
