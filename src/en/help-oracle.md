Title: Using the Oracle cloud

# Using the Oracle public cloud

Juju has built-in support for [Oracle's Compute service][compute]. However, the
following few steps are required before Juju can bootstrap Oracle's Compute
cloud:

1. Associate Oracle's Ubuntu images with your Compute service. Juju uses these
   for deployment.

1. For trial accounts, add the Oracle cloud to Juju. Endpoint details may need 
   to be retrieved from the Oracle Compute *Dashboard*.
   Juju already knows about endpoints for paid accounts so this step is only
   necessary if using a trial account.

1. Add authentication credentials for the specific Compute service to Juju.

We'll step through each of these requirements below, before using Juju to
launch a test deployment on Oracle's Compute. 

!!! Note:
	Oracle support is currently in the latest [Juju 2.2 release
        candidate][jujubeta] and is experimental. Both the Juju and Oracle
        teams are working to improve the user experience.

## Images

Juju needs access to Ubuntu images that have been associated with your Oracle
Compute deployment. 

To do this, first sign in to your Oracle cloud domain. The URL for this will
depend on the cloud's geographical location. In EMEA, for example, the URL is
the following:

[https://myservices.emea.oraclecloud.com](https://myservices.emea.oraclecloud.com).

After signing in, you'll see the default top level of Oracle's domain
dashboard.

![Empty Oracle dashboard](./media/oracle_empty-dashboard.png)

Click on the large `Create Instance` tile and select `Compute` from the list of
services that appear. 

You are now looking at the first step in Oracle's Compute cloud deployment
process. We'll be using this step to associate images with this specific cloud
domain before cancelling the remainder of Oracle's cloud deployment. 

Ubuntu images can be found by clicking on 'Marketplace' from the menu on the
left and entering `Ubuntu` into the search field that appears. 

![Ubuntu image search](./media/oracle_create-instance-ubuntu.png) 

The search will return any official Ubuntu images, visible with the Ubuntu
logo, alongside other Ubuntu-associated images. 

It's currently possible to use any of the following images with Juju:

| Version          | Arch   | Series  |
|------------------| -------|---------|
| Ubuntu 12.04-LTS | amd64  | Precise |
| Ubuntu 14.04-LTS | amd64  | Trusty  |
| Ubuntu 16.04-LTS | amd64  | Xenial  |
| Ubuntu 17.04     | amd64  | Zesty   |

!!! Warning: 
	Currently, Oracle's Ubuntu 16.10 (Yakkety Yak) image shouldn't be
        associated with your Juju/Oracle Compute deployment.

To associate an image, click `Select` at the bottom of the image tile and
accept Oracle's terms and conditions for associating a Marketplace image with
your cloud (this needs to be done separately for each image).

We'd recommend adding at least the Xenial and Trusty images to your cloud, as
these are used by the majority of Juju deployments. The series you need to
associate will depend on the specific charms you use. While images are being
added, a small `Instance Creation` pane will appear which turns green when the
process is complete. This typically takes a few seconds.
 
When complete, associated images will be listed when you select 'Private
Images' from the menu on the left, as well as from the Compute console by
selecting the 'Images' tab: 

![Private image in Oracle Compute dashboard](./media/oracle_create-instance-private.png)

## Add cloud

When using a trial account, to add your Oracle cloud to Juju, type `juju add-cloud`. 

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
[compute]: https://cloud.oracle.com/en_US/compute
[jujubeta]: ./reference-install.html#getting-development-releases
[cloudoracle]: https://cloud.oracle.com/home
[getstarted]: ./getting-started-jaas.html
[spaces]: ./network-spaces.html
