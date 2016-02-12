Title: Configuring for Microsoft Azure
TODO: Decide on what to do with provider-specific features (e.g. placement).  


# Configuring for Microsoft Azure 

The new Azure provider is backwards compatible with the previous provider but
supports several additional features, in particular, support for unit placement
(i.e. units can be deployed to specific existing machines). In lieu of this,
the old default behaviour is used: units of a service will be allocated to
machines in a service-specific Availability Set. Read the
[Azure SLA](https://azure.microsoft.com/en-gb/support/legal/sla/) to learn how
availability sets affect uptime guarantees.

!!! Note: Juju now supports Microsoft Azure's Resource Manager API. The Azure
provider has effectively been rewritten, but old models are still supported. To
use the new provider support, you must bootstrap a new model with new
configuration. There is no automated migration method.


## Prerequisites and the Azure CLI tool

 - An Azure account is required. See http://azure.microsoft.com.

 - Juju 2.0 (or greater) is needed.

 - The Azure CLI tool is used to both gather information and to perform
   necessary actions.

 - The Juju client (the host running the below commands) will need the ability
   to contact the Azure infrastructure on TCP ports 22 and 17070.


## Azure CLI tool installation

Proceed to install the software:

```bash
sudo apt-get install -y nodejs-legacy npm
sudo npm install -g azure-cli
```

The Azure CLI tool gets installed here:

```bash
ls -lh /usr/bin/azure
lrwxrwxrwx 1 root root 39 Jan 18 22:58 /usr/bin/azure -> ../lib/node_modules/azure-cli/bin/azure
```

Confirm it's installed correctly by viewing its online help. Then put it in
*Azure Resource Manager* mode and log in:

```bash
azure help
azure config mode arm
azure login
```

You will be prompted to visit a website to enter the provided code. It will
therefore be easier to perform this on a graphical desktop.


## Configure and bootstrap

If this is a new Juju install then you do not yet have a
`~/.local/share/juju/environments.yaml` file. Create one with

```bash
juju generate-config
```

If it does exist first move it out of the way (back it up) and *then* generate
a new one. Alternatively, you can output a generic file to screen (STDOUT) and
paste the Azure parts into your existing file:

```bash
juju generate-config --show
```

The file will contain a section for the Azure provider.

Values will need to be found for the following parameters:

 - storage-account-type
 - location
 - subscription-id
 - application-password
 - application-id
 - tenant-id

#### `storage-account-type`

Use the generic value of 'Standard_LRS' for this.

### `location`

Choose an [Azure region](https://azure.microsoft.com/en-us/regions/). Here we will use
'East US'.

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

The subscription ID can now be stored in a local environment variable, by
entering:

```bash
SUB_ID=f717c8c1-8e5e-4d38-be7f-ed1e1c879e18
```

### `application-password`

You will create an application in the next step. For now, create a password for
it, the **APP_PASSWORD**.

```bash
APP_PASSWORD=some_password
```

### `application-id`

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

Note the application ID, the **APP_ID**. It will look similar to:

```bash
APP_ID=f6ab7cbd-5029-43ef-85e3-5c4442a00ba8
```

Use the APP_ID to create an Active Directory (Kerberos) server principal:

```bash
azure ad sp create $APP_ID
```

Note its object ID, the **OBJ_ID**:

```bash
OBJ_ID=aab17f6f-6b9a-43ae-8d6d-2ff889aa8941
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

It will look like:

```bash
TENANT_ID=daff614b-725e-4b9a-bc57-7763017c1cfb
```

You can test by logging in using the application principal as your identity:

```bash
azure login \
	-u "$APP_ID" \
	-p "$APP_PASSWORD" \
	--service-principal \
	--tenant "$TENANT_ID"
```


## Confirm configuration and bootstrap

According to all the above, the Azure section of file `environments.yaml` for
this example would look like this (comments removed for simplicity):

```yaml
    azure:
        type: azure
        storage-account-type: Standard_LRS
        location: East US
        subscription-id: f717c8c1-8e5e-4d38-be7f-ed1e1c879e1a
        application-password: some_password
        application-id: f6ab7cbd-5029-43ef-85e3-5c4442a00ba8
        tenant-id: daff614b-725e-4b9a-bc57-7763017c1cfb
```

Finally, switch to the Azure provider and bootstrap:

```bash
juju switch azure
juju bootstrap --debug
```

A successful bootstrap will result in the controller being visible in the
[Azure portal](http://portal.azure.com):

![bootstrap machine 0 in Azure portal](media/azure_portal-machine_0.png)


## Additional notes

See [General configuration options](https://jujucharms.com/docs/stable/config-general)
for additional and advanced customization of your environment.
