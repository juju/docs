Title: Using AWS with FAN networking

# Using AWS with FAN networking

*This is an example of how Juju can be used with FAN networking. See
[Juju and FAN networking][charms-fan] for background information.*

To use FAN networking with AWS a *virtual private cloud* (VPC) is required.
Fortunately, a working VPC is provided with every AWS account and is used, by
default, when creating regular EC2 instances. To make things even easier, Juju
autoconfigures FAN networking in an AWS/VPC context. All that is needed is an
AWS-based controller, which is created in the usual manner (e.g.
`juju bootstrap aws`) 

!!! Note:
    You may need to create a new VPC if you are using an old AWS account (the
    original VPC may be deficient). See
    [Creating an AWS VPC for use with FAN networking][fan-example-aws-vpc].

## Specifying a VPC

Whether you created a secondary VPC out of necessity or because you prefer to
use a Juju-dedicated VPC you will need to tell Juju to use it. This is done
by specifying the VPC ID during the controller-creation process. For example:

```bash
juju boootstrap --config vpc-id=vpc-6aae2f12 aws
```

The VPC ID is obtained from the AWS web interface.

## Confirming FAN networking

Here, FAN networking will be leveraged, and confirmed, by deploying and
relating applications that are running in different LXD containers, where the
containers are housed on separate machines.

```bash
juju add-machine -n 2
juju deploy mysql --to lxd:0
juju deploy wordpress --to lxd:1
juju add-relation mysql wordpress
```


<!-- LINKS -->

[charms-fan]: ./charms-fan.html
[fan-example-aws-vpc]: ./charms-fan-aws-vpc.html
