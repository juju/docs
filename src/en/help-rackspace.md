Title: Help with Rackspace clouds

# Using the Rackspace public cloud

Juju already has knowledge of the Rackspace cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. Rackspace
will appear in the list of known clouds when you issue the command:
  
```bash
juju list-clouds
```
And you can see more specific information (e.g. the supported regions and
authentication types) by running:
  
```bash
juju show-cloud rackspace
```
If at any point you believe Juju's information is out of date (e.g. Rackspace just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Credentials

Using Juju's interactive authentication, importing Rackspace credentials into
Juju is a simple process. The only information you'll need is your Rackspace
username, password and tenant name (which is actually a number):

 - **`username`** The name used to login to the 
    [Rackspace cloud control panel](rscontrolpanel).

 - **`password`** The password used to login to the Rackspace cloud
   control panel. 

 - **`tenant-name`** The Rackspace account number. You can view this in 
    the cloud control panel in the top-right corner (under your username), as
    shown in the following image:

![Rackspace control panel showing tenant id](./media/config-rackspace_tenant_id.png)


Credentials can now be added by running the following command:

```bash
juju add-credential rackspace
```

The first question will ask for an arbitrary credential name, which you choose
for yourself. This will be how you remember and refer to this Rackspace
credential in Juju. The second question will ask you to select an 'Auth Type',
with the options being either `access-key` or `userpass`. 

Enter `userpass` as the authentication type and then enter your username,
password and tenant-name, as described above.

You can now start using Juju with your Rackspace cloud.

## Create controller

To create the controller, run the following command:

```bash
juju bootstrap rackspace mycloud
```

This will create a new controller called 'mycloud' with the configuration 
values we entered earlier.

This controller will now be visible in the
[Rackspace cloud control panel](rscontrolpanel):

![bootstrap machine 0 in Rackspace portal](./media/config-rackspace_portal-machine_0.png)

[rscontrolpanel]: https://mycloud.rackspace.com
