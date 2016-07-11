Title: Help with Azure clouds

# Using the Microsoft Azure public cloud

Juju already has knowledge of the Azure cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. Azure
will appear in the list of known clouds when you issue the command:
  
```bash
juju list-clouds
```
And you can see more specific information (e.g. the supported regions) by 
running:
  
```bash
juju show-cloud azure
```

If at any point you believe Juju's information is out of date (e.g. Azure just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Credentials

In order to access Azure, you will need to add some credentials for Juju to use.
The Azure command line interface (CLI) tool is used to both gather information
and to perform necessary actions.

```bash
sudo apt-get install -y nodejs-legacy npm
sudo npm install -g azure-cli
```

The Azure CLI tool gets installed here:

```bash
ls -lh /usr/local/bin/azure
lrwxrwxrwx 1 root root 39 Jan 18 22:58 /usr/local/bin/azure -> ../lib/node_modules/azure-cli/bin/azure
```

Confirm the tool is installed correctly by viewing its online help.

```bash
azure help
```

Put Azure in *Azure Resource Manager* mode and log in:
```bash
azure config mode arm
azure login
```

You will be prompted to visit a website to enter the provided code. It will
therefore be easier to perform this on a graphical desktop.

### Registering azure services

Juju requires certain services to be active for your account. Use these 
to register using the Azure CLI tool:

```
azure provider register Microsoft.Compute
azure provider register Microsoft.Network
azure provider register Microsoft.Storage
```

To enter credentials, values will need to be found for the following parameters:

 - subscription-id
 - application-password
 - application-id
 - tenant-id

!!! Note: In the sections below, we will assign each of these a variable name.
When you enter them into the command, replace the variable name we give with
the actual ID that corresponds to the variable.

### `subscription-id`

List your account and get the subscription ID, the **SUB_ID**:

```bash
azure account list
```

Sample output:

```no-highlight
info:    Executing command account list
data:    Name        Id                                    Current  State
data:    ----------  ------------------------------------  -------  -------
data:    Free Trial  f717c8c1-8e5e-4d38-be7f-ed1e1c879e18  true     Enabled
info:    account list command OK
```

In this sample,

```bash
SUB_ID=f717c8c1-8e5e-4d38-be7f-ed1e1c879e18
```

### `application-password` and  `application-id`

Create a password for the application to use, the **APP_PASSWORD**. In our
sample,

```bash
APP_PASSWORD=some_password
```

Create an Azure Active Directory (AAD) application:

```bash
azure ad app create \
        --name "ubuntu.example.com" \
        --home-page "http://ubuntu.example.com" \
        --identifier-uris "http://ubuntu.example.com" \
        --password $APP_PASSWORD
```

The options `--name`, `--home-page`, and `--identifier-uris` are arbitrary but
you should use values that make sense for your environment.

In the output of this command, note the application ID, the **APP_ID**.
In our sample it was on a line like this:

```bash
data:    AppId:    f6ab7cbd-5029-43ef-85e3-5c4442a00ba8
```

Use the APP_ID to create an Active Directory (Kerberos) server principal:

!!! Note: Replace our variable here with the actual value you learned above.
Do this throughout the rest of this page when you see variables listed.

```bash
azure ad sp create -a $APP_ID
```

Note its object ID, the **OBJ_ID**. In our sample it was on a line like this:

```bash
data:    ObjectId:    aab17f6f-6b9a-43ae-8d6d-2ff889aa8941
```

Now grant permissions to the principal (OBJ_ID) associated with your
subscription (SUB_ID):

```bash
azure role assignment create \
        --objectId $OBJ_ID \
        -o Owner \
        -c /subscriptions/$SUB_ID/
```

### `tenant-id`

Get the tenant id, the **TENANT_ID**:

```bash
azure account show
```

In our sample it was on a line like this:

```bash
data:    Tenant ID:    daff614b-725e-4b9a-bc57-7763017c1cfb
```

You can test by logging in using the application principal as your identity:

```bash
azure login \
        -u "$APP_ID" \
        -p "$APP_PASSWORD" \
        --service-principal \
        --tenant "$TENANT_ID"
```

You can now run the interactive command:
  
```bash
juju add-credential azure
```

Which will ask for a credential name, which you determine for yourself, and
then the values discovered above.

!!! Note: If you add more than one credential, you will also need to set the
default one to use with `juju set-default-credential`

## Create controller


```bash
juju bootstrap mycloud azure
```

A successful bootstrap will result in the controller being visible in the
[Azure portal](http://portal.azure.com):

![bootstrap machine 0 in Azure portal](media/azure_portal-machine_0.png)


## Compatibility with older versions of Juju

Juju 2.x support for Azure is backwards compatible with older versions of Juju
but supports several additional features, in particular, support for unit 
placement (i.e. units can be deployed to specific existing machines). In lieu
of this, the old default behaviour is used: units of an application will be 
allocated to machines in an application-specific Availability Set. Read the
[Azure SLA](https://azure.microsoft.com/en-gb/support/legal/sla/) to learn how
availability sets affect uptime guarantees.


