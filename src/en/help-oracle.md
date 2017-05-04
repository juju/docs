Title: Using the Oracle Compute Provider
TODO: Test Oracle
      Rewrite so its not so list heavy (especially Networks and spaces section)

# Using the Oracle Compute Provider

!!! Note:
	Oracle Compute support is currently in [Juju 2.2 beta3][jujubeta] and
        is experimental.

To start using Juju with the [Oracle Compute Cloud][compute], some initial set up steps
are required:

1. Associate Ubuntu or Windows images from the Marketplace with your Oracle
   account. This is an Oracle legal requirement.

1. If not using a paid account, use `juju add-cloud` to set up the region and
   endpoint details for Juju to use.  Set up credentials using `juju
   add-credentials`. 

1. Set up credentials using `juju add-credentials`.

These steps - outlined below - will be refined by both the Juju and Oracle
teams to improve the user experience.

The following can be used with either a free Oracle trial account, or a paid
account.

## Associate images

For each Ubuntu series used by Juju, the relevant image needs to be selected
from the Marketplace and associated with your account. You also need to agree
to Oracle’s Terms and Conditions.

The currently available Ubuntu images are:

| Series   | Version                          |
|----------|----------------------------------|
| precise  | Ubuntu.12.04-LTS.amd64.20170417  |
| trusty   | Ubuntu.14.04-LTS.amd64.20170405  |
| xenial   | Ubuntu.16.04-LTS.amd64.20170330  |
| zesty    | Ubuntu.17.04.amd64.20170412.1    |

Windows images are also available for Windows Server 2008 and 2012.

!!! Warning:
        Do not attempt to associate a `yakkety` image with your account. Only use
        one of the images listed above.

### Steps to associate images

Sign in to [https://cloud.oracle.com/home][cloudoracle] with your credentials.
You will need to know your Data Center and Identity Domain.

1. If you're not on the *Dashboard*, click the `Dashboard` button.
1. From the Dashboard, click on the green `Create Instance` button.
1. Select `Compute` from the pop-up window; you'll come to the Compute screen.
1. Select `Marketplace` from the list on the left of your screen.
1. Search for Ubuntu and click `Select` on an image matching one of those listed above.
1. Accept the terms of use in the 'Install Marketplace Image' pop-up and click `Install`.
1. Informational messages on install status will appear in the upper right corner.
1. You can cancel the rest of the image creation at this point.

To verify, go back to the Dashboard. Click on the `Compute` link (one
of the boxes on your Dashboard). From the 'Service Details: Oracle Compute Cloud
Service' window, click on `Open Service Console` and select the `Images` tab.
You'll see a drop down menu; change `Category: All` to `Category: Personal` and
you should see your image. 

## Set up the Oracle cloud

If using a paid Oracle account, there's one currently supported region,
`uscom-central-1`, which is supported out of the box.

Using a trial account requires adding the cloud information to Juju using the
`add-cloud` command:

```bash
juju add-cloud
```

From the list of clouds, enter `oracle-compute`:

```no-highlight
Cloud Types
  maas
  manual
  openstack
  oracle-compute
  vsphere

Select cloud type: oracle-compute
```
You will then be asked for a name and an endpoint before being informed that
the cloud has been successfully added:

```no-highlight
Enter a name for your oracle-compute cloud: myoracle
Enter the API endpoint url for the cloud: https://compute.uscom-central-1.oraclecloud.com/
Cloud "myoracle" successfully added
```
The endpoint can be found in the `REST Endpoint` field in the Dashboard's
`Compute` screen. The above steps also work for a paid account and are useful
if there's a need to define the default model configuration or other bespoke
bootstrap configuration.

## Set up credentials

To access the cloud, you first need to add credentials using the cloud name
configured previously: 

```bash
juju add-credential myoracle
```

You will be asked for your username, password and Identity Domain:

```no-highlight
Enter credential name: default
Using auth-type "userpass".
Enter username: user@somewhere.com
Enter password: 
Enter identity-domain: mydomain
Credentials added for cloud myoracle.
```

## Start using Juju

You can now start using Juju with your Oracle cloud:

```bash
juju bootstrap myoracle
juju deploy ...
```

## Storage

Juju includes optional support for Oracle block storage volumes. The storage
pool name to use is `oracle`:

```bash
juju deploy postgresql --storage data=oracle,10G
```

## Networks and spaces

For paid accounts, it's possible to associate networks with Juju and define
[spaces][spaces] using those networks:

1. Verify you’re in the paid account space (Site: `uscomm-central-1`).
1. If you're not on the Dashboard, click the `Dashboard` button.
1. Click on the `Compute` link (one of the boxes on your dashboard).
1. From the 'Service Details: Oracle Compute Cloud Service' window, click on
   `Open Service Console`.
1. Select the `Network` tab.
1. From the left menu, click on the arrow to display `IP Network` if not shown.
1. Select `IP Exchanges` from the choices on the left.
1. Click on the `Create IP Exchange` button on the right.
1. Add a name in the `Create IP Exchange` pop-up window and click `Create`.
1. The new IP Exchange will appear in the window.
1. Select `IP Networks` from the choices on the left.

IP Networks may be shown, but unless you created them you won't be able to see
them from Juju. To create one:

1. Click the `Create IP Network` button on the right.
1. Add `Name` and `IP Address Prefix` (CIDR) in the 'Create IP Exchange'
   pop-up window and then select the  IP Exchange you just created. 
1. Click on `Create` and the new IP Network should appear in the window.

This information will be viewable via the `juju subnets` and `juju spaces`
commands after Juju has been bootstrapped.

<!-- LINKS -->
[compute]: https://cloud.oracle.com/en_US/compute
[jujubeta]: ./reference-install.html
[cloudoracle]: https://cloud.oracle.com/home
[getstarted]: ./getting-started-jaas.html
[spaces]: ./network-spaces.html
