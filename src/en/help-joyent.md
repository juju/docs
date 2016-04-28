Title: Help with Joyent clouds

# Using the Joyent public cloud

Juju already has knowledge of the Joyent cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. Joyent
will appear in the list of known clouds when you issue the command:
  
```bash
juju list-clouds
```
And you can see more specific information (e.g. the supported regions) by 
running:
  
```bash
juju show-cloud joyent
```

If at any point you believe Juju's information is out of date (e.g. Joyent just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Credentials

In order to authenticate itself to the Joyent cloud, Juju will need the 
following information:

  - **sdc-user** - obtained from the Joyent Dashboard
  - **sdc-key-id** - The fingerprint of an SSH key uploaded to Joyent (obtained 
    from the Joyent Dashboard)
  - **private-key-path** - full local path to the actual private key (e.g. 
    '/home/ubuntu/.ssh/id_rsa'). See note below.

The first two values are easily obtained from the 'Account' section via the 
Joyent Dashboard

![Joyent Account](./media/getting_started-joyent-account-dropdown.png)

!!! Note: The private key is currently uploaded to the cloud in order to
remotely sign requests to the Joyent API. It is highly recommended that the
private key used in this way _should not_ be a common SSH key you use for other
purposes, but a specific one used for the Joyent cloud.

With the above information, you can now run the command:

```bash
juju add-credential joyent
```
...and supply relevant answers to the questions. Note that the path to the SSH
key must be the full system path, not using any bash shortcuts such as '~'.


!!! Note: During initial setup if you are having issues deploying charms contact
Joyent support at [https://help.joyent.com/home](https://help.joyent.com/home) 
to verify your account is capable of provisioning virtual machines.