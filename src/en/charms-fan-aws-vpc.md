Title: Creating an AWS VPC

# Creating an AWS VPC

This is in connection with [Juju and Fan networking][charms-fan] where an AWS
user may wish to create an additional VPC (virtual private network).

Note that only older AWS accounts will actually require a new VPC in order for
Juju to autoconfigure the Fan. Recent AWS accounts are furnished with a VPC
which will work out-of-the-box.

The procedure covered here refers to the AWS web interface. Alternatively, the
[AWS API][amazon-api-vpc] can be used.

To add a VPC:

 1. Navigate to the VPC console:

    https://console.aws.amazon.com/vpc/home

 1. **Create a VPC** by selecting `Your VPCs` in the left menu and pressing the
    `Create VPC` button.

    In the resulting dialog box, enter a name for the VPC (e.g. 'vpc-juju') and
    a /16 address space (e.g. '192.168.0.0/16').

 1. **Create a subnet** for the VPC by selecting `Subnets` in the left menu and
    pressing the `Create Subnet` button.

    In the resulting dialog box, enter a name for the subnet (e.g.
    'vpc-juju-subnet'), select the VPC you created earlier, an Availability
    Zone (optional), and an IPv4 CIDR block that resides within the initial
    address space (e.g. '192.168.1.0/24').

    Select the subnet's checkbox and hit `Subnet Actions`. There, choose
    `Modify auto-assign IP settings` and then select `Enable auto-assign public
    IPv4 address`.

 1. **Create a gateway** for the VPC by selecting `Internet Gateways` in the
    left menu and pressing the `Create Internet Gateway` button.

    In the resulting dialog box, enter a name for the gateway (e.g.
    'vpc-juju-igw').

    Select the gateway's checkbox and hit `Attach to VPC`. There, select the
    VPC you created earlier.

 1. **Create a default route** for the VPC by selecting `Route Tables` in the
    left menu and selecting the route table for your VPC. The VPC name will
    appear in the VPC column (along with the VPC ID).

    Down below, enter the `Routes` tab, press the `Edit` button, then
    `Add another route`. Under `Destination` put '0.0.0.0/0' and under `Target`
    the gateway you created earlier will be pre-populated as an option, select
    it.  Save.
    
The VPC is now ready for use by Juju. If you now have multiple VPCs Juju will
need to refer to a VPC by its ID. Take note of it. It has the format
`vpc-HHHHHHHH` where each 'H' represents a hexadecimal number (e.g.
'vpc-2434a45c').

!!! Warning:
    While working with VPCs be careful to not delete the wrong one by mistake.
    Doing so will destroy all associated instances.


<!-- LINKS -->

[amazon-api-vpc]: http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpc.html
[charms-fan]: ./charms-fan.html
