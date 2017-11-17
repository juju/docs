Title: Juju and FAN networking

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
and a larger one (e.g. a /8 network) where **subnets** from the larger one (the
*underlay* network) are assigned to **addresses** on the smaller one (the
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

Juju manages FAN networking at the model level (see
[Configuring models][models-config]) and is enabled via the
`container-networking-method` configuration option. This option can take on the
following values:

 - provider : ?
 - local : ?
 - fan : FAN networking

Once FAN is enabled, by setting the above option to 'fan', all that is needed
is to map the underlay network to the overlay network. The `fan-config` model
option is used for this. Its value has the following syntax:

  `<underlay-network>=<overlay-network>`

To confirm that a model is properly configured for FAN networking use the
following command:

```bash
juju model-config | egrep 'fan-config|container-networking-method'
```

The output should be similar to this:

```no-highlight
container-networking-method   model    fan
fan-config                    model    10.0.0.0/16=252.0.0.0/8
```

In this example, the underlay network is 10.0.0.0/16 and the overlay network is
252.0.0.0/8.

## Cloud provider requirements

Juju autoconfigures FAN networking in both an AWS/VPC context and a GCE
context. All that is needed is a controller, which does not need any special
FAN options passed during its creation.

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
    original VPC may be deficient). See
    [Creating an AWS VPC for use with FAN networking][fan-example-aws-vpc].

#### Specifying a VPC

Whether you created a secondary VPC out of necessity or because you prefer to
use a Juju-dedicated VPC you will need to tell Juju to use it. This is done
by specifying the VPC ID during the controller-creation process. For example:

```bash
juju boootstrap --config vpc-id=vpc-6aae2f12 aws
```

The VPC ID is obtained from the AWS web interface.

#### Deploying

Here, FAN networking will be leveraged by deploying and relating applications
that are running in different LXD containers, where the containers are housed
on separate machines.

```bash
juju add-machine -n 2
juju deploy mysql --to lxd:0
juju deploy wordpress --to lxd:1
juju add-relation mysql wordpress
```


<!-- LINKS -->

[fan-ubuntu-wiki]: https://wiki.ubuntu.com/FanNetworking
[fan-ubuntu-insights]: https://insights.ubuntu.com/2015/06/22/container-to-container-networking-the-bits-have-hit-the-fan/
[fan-lxd-config-options]: https://github.com/lxc/lxd/blob/master/doc/networks.md
[fan-fanctl-man-page]: http://manpages.ubuntu.com/cgi-bin/search.py?q=fanctl
[fan-aws-vpc]: ./charms-fan-aws-vpc.html
[models-config]: ./models-config.html
