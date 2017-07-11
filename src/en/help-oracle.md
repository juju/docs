Title: Using the Oracle cloud

# Using the Oracle public cloud

Juju has built-in support for [Oracle Compute][oracle-compute], Oracle's public
cloud. This means that there is no need to *add* the Oracle cloud to Juju. An
exception to this are Oracle Compute *trial* accounts. Both types of accounts,
paid and trial, are covered here.

!!! Warning:
    Support for Oracle Compute is only available via the [juju 2.2 dev
    release][jujubeta] and is therefore not yet recommended for production use.

The email you received upon signing up for Oracle Compute contains information
you will need to get going. Look for:

- 'My Services URL'
- 'Identity domain'

## Ubuntu images

You will need to make Ubuntu images available in your Oracle Compute account in
order for Juju to be able to create Ubuntu-based machines. This is a
requirement.

Navigate to 'My Services URL' and log in. Click on the 'Create instance' box
and then 'Create' a Compute service:

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

## Add cloud

**If using a trial account**, you will need to add your Oracle cloud to Juju
with the interactive `juju add-cloud` command. 

The interactive `add-cloud` process will start by first asking for the cloud
type. Enter `oracle`:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  oracle
  vsphere

Select cloud type: oracle
```
You will then be asked to name your cloud, followed by an endpoint:

```no-highlight
Enter a name for your oracle cloud: myoracle
Enter the API endpoint url for the cloud: https://compute.uscom-central-1.oraclecloud.com/
Cloud "myoracle" successfully added
```

If you're using a paid Oracle account, `uscom-central-1` is currently the only
supported region that works with Juju out of the box. 

For trial accounts and other regions, the endpoint needs to be retrieved from
Oracle's Compute dashboard. 

To retrieve the endpoint, sign in to your Oracle cloud domain and click on the
Compute tile for your domain. 

Alternatively, if the Compute domain tile isn't visible, use the drop-down menu
in the top left of the dashboard to select `Cloud Account`, select the
`Subscriptions` tab and from the 'Subscriptions Type' drop-down menu, select
IaaS. From the list of  subscriptions that appear (Storage, Compute, Ravello
and Container), click on the menu icon to the right of Compute and select 
`View Details`.

In the `Additional Information` view that appears, the REST endpoint field is
the value Juju needs for the endpoint URL:

![Endpoint URL](./media/oracle_myservices-endpoint.png)

## Credentials

Using Juju's interactive authentication, importing Oracle credentials into Juju
is a simple process. You will just need the following information:

- **Username**: usually the email address for your Oracle account.
- **Password**: the password for this specific Compute domain.
- **Identity domain**: the ID for the domain, e.g. `a476989`.

To add these details, type `juju add-credential <credential-name>
<cloud-name>`: 

```bash
juju add-credential myoracle
```

You will be asked for each detail in turn.

```no-highlight
Enter credential name: mynewcredential
Using auth-type "userpass".
Enter username: javier
Enter password: ********
Enter identity-domain: a476989
Credentials added for cloud myoracle.
```

You have now added everything needed to bootstrap your new Oracle Compute cloud
with Juju.

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

## Create controller

To bootstrap your Oracle Compute cloud, use the `juju bootstrap` command with
your cloud name:

```bash
juju boostrap myoracle
```

You can now start deploying Juju charms and bundles to your Oracle cloud.

A successful bootstrap and deployment will result in the controller environment
being visible in the `Instances` page of the Oracle Compute dashboard:

![Oracle dashboard showing Juju](./media/oracle_bootstrap-instances.png)


<!-- LINKS -->

[oracle-compute]: https://cloud.oracle.com/en_US/compute
[jujubeta]: ./reference-install.html#getting-development-releases
[cloudoracle]: https://cloud.oracle.com/home
[getstarted]: ./getting-started-jaas.html
[spaces]: ./network-spaces.html
