Title: Using the Oracle cloud

# Using the Oracle public cloud

Juju has built-in support for [Oracle Compute][oracle-compute], Oracle's public
cloud. This means that there is no need to *add* the Oracle cloud to Juju. An
exception to this are Oracle Compute *trial* accounts. Both types of accounts,
paid and trial, are covered here.

!!! Warning:
    Support for Oracle Compute is only available via the [juju 2.2 dev
    release][jujubeta] and is therefore not yet recommended for production use.

The email you received upon signing up for Oracle Compute contains vital
information you will need:

- 'My Services URL'
- 'Identity domain'
- 'My Account URL' (for trial accounts)
- 'Username' (your email address)
- 'Password' (temporary)

On first login you will be prompted to change the temporary password to arrive
at your final password.

## Ubuntu images

You will need to make Ubuntu images available in your Oracle Compute account in
order for Juju to be able to create Ubuntu-based machines. This is a
requirement.

Proceed as follows:

1. Navigate to 'My Services URL' and log in.
1. Select your 'Identity Domain' in the top-right corner.
1. Click on the 'Create instance' box and then 'Create' a Compute service.

![Create Compute service](./media/oracle_empty-dashboard-2.png)

!!! Recall:
    We are doing this to associate images with your 'identity domain'. We will
    not be creating an instance here.

Click on 'Marketplace' on the resulting page (left menu), enter 'ubuntu' into
the search field, and hit Enter:

![Search Ubuntu images](./media/oracle_create-instance-ubuntu-2.png) 

Juju works best with specific Ubuntu images however. These Juju-compatible
images are listed here:

| Version          | Arch   | Series  |
|------------------| -------|---------|
| Ubuntu 12.04 LTS | amd64  | Precise |
| Ubuntu 14.04 LTS | amd64  | Trusty  |
| Ubuntu 16.04 LTS | amd64  | Xenial  |
| Ubuntu 17.04     | amd64  | Zesty   |

Since Juju uses charms to install applications, the Ubuntu series you need are
those that the charms were written for. If unsure, it is recommended to add the
two most recent LTS releases.

!!! Note:
    At time of writing, Trusty and Xenial are the two most recent Ubuntu
    LTS releases.

Go ahead and select a compatible image from among the official Ubuntu images
(orange Ubuntu logo), accept Oracle's terms and conditions, and click
'Install'. Repeat the process for each desired image. These installed images
will end up under 'Private Images' in the menu on the left:

![List private images](./media/oracle_create-instance-private-2.png)

## Add cloud (trial accounts)

As mentioned, you will need to add your Oracle cloud to Juju if you're using a
trial account. This requires a 'REST Endpoint'. To get this, navigate to 'My
Account URL', scroll down to 'Oracle Compute Cloud Service', and click on it.
The resulting page will look similar to this:

![REST endpoint](./media/oracle_myservices-endpoint-2.png)

There may be multiple endpoints. Choose the one beginning with `compute.`.

You are now ready to use the interactive `add-cloud` command:

```bash
juju add-cloud
```

Example user session:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  oracle
  vsphere

Select cloud type: oracle

Enter a name for your oracle cloud: oracle-cloud

Enter the API endpoint url for the cloud:
https://compute.uscom-central-1.oraclecloud.com/

Cloud "oracle-cloud" successfully added
You may bootstrap with 'juju bootstrap oracle-cloud'
```

We've called the new cloud 'oracle-cloud' and used an endpoint of
'https://compute.uscom-central-1.oraclecloud.com/'.

Now confirm the successful addition of the cloud:

```bash
juju clouds
```

Here is a partial output:

```no-highlight
Cloud            Regions  Default          Type        Description
.
.
.
oracle                 5  uscom-central-1  oracle      Oracle Compute Cloud Service
oracle-cloud           0                   oracle      Oracle Compute Cloud Service
```

Cloud 'oracle' is for the built-in (for pay) service and cloud 'oracle-cloud'
is tied to your trial account.

## Add credentials

Use the interactive `add-credential` command to add your credentials to the new
cloud:

```bash
juju add-credential oracle-cloud
```

Example user session:

```no-highlight
Enter credential name: oracle-cloud-creds

Using auth-type "userpass".

Enter username: peter.gargamel@example.com

Enter password:

Enter identity-domain: a498151

Credentials added for cloud oracle-cloud.
```

We've called the new credential 'maas-cloud-creds' and entered values for
'Username', 'Password', and 'Identity domain'.

!!! Note:
    The password will not be echoed back to the screen.


## Networks and spaces

An optional step allows you to easily associate Oracle Compute IP networks and
exchanges with Juju's networks and spaces.

To do this, sign in to your Oracle cloud domain, select the Compute service
you're using for Juju, and open its service console. 

From the Compute dashboard that appears, switch to the `Network` tab and select
`IP Exchanges` from the menu on the left.

Click on the `Create IP Exchange` button. In the pane that appears, enter a
name for the exchange, and optionally, a description and one or more tags.

The new exchange will now be listed. 

We now need to add a new network to use this exchange. Select the `IP Networks`
page from the menu on the left and click on `Create IP Network` to open the new
network details panel. 

![Add an IP Network](./media/oracle_create-ip-network.png)

Enter a name, a CIDR formatted address for the `IP Address Prefix`, and an
optional description with one or more tags. Use the `IP Exchange` drop-down
menu to select the exchange created previously and click on `Create`. 

A few moments later, the new network will be listed.

When you next bootstrap Juju with Oracle Compute, you'll be able to use these
new subnets and spaces. For example, typing `juju subnets` will show output
similar to the following:

```no-highlight
subnets:
  10.0.123.0/24:
    type: ipv4
    provider-id: /Compute-a476989/juju-network
    status: in-use
    space: juju-exchange
    zones:
    - default
```

Typing `juju spaces` will list the Oracle IP exchange:

```no-highlight
Space          Subnets
juju-exchange  10.0.123.0/24
```

See [How to configure more complex networks using spaces][spaces] for further
details on networks and spaces. 

## Create the Juju controller

You are now ready to create a Juju controller (this will create an instance in
your Oracle Compute account):

```bash
juju bootstrap oracle-cloud oracle-cloud-controller
```

Above, the name given to the new controller was 'oracle-cloud-controller'.

Once created, you can view the controller as an Oracle Compute instance by
navigating to 'My Services URL', opening the left menu (top-left icon), and
selecting 'Compute'. The controller should be visible under the 'Instances'
tab:

![List controller instance](./media/oracle_bootstrap-instances-2.png)

## Next steps

You can now start deploying Juju charms and/or bundles to your Oracle cloud.
Continue with Juju by visiting the [Models][models] and
[Introduction to Juju Charms][charms] pages.


<!-- LINKS -->

[oracle-compute]: https://cloud.oracle.com/en_US/compute
[jujubeta]: ./reference-install.html#getting-development-releases
[cloudoracle]: https://cloud.oracle.com/home
[getstarted]: ./getting-started-jaas.html
[spaces]: ./network-spaces.html
[models]: ./models.html
[charms]: ./charms.html
