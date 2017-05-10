Title: Help with Azure clouds

# Using the Microsoft Azure public cloud

Juju already has knowledge of the Azure cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. Azure
will appear in the list of known clouds when you issue the command:
  
```bash
juju clouds
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

Using Juju's interactive authentication, importing Azure credentials into Juju
is a simple process. The only information you'll need is your Azure subscription
id, which can be found by signing in to Azure and going to the
'[SubscriptionBlade][subscriptionblade]'
page.

![Azure SubscriptionBlade page showing subscription id](./media/getting_started-azure_subsid.png)

Credentials can now be added by running the command:

```bash
juju add-credential azure
```
The first question will ask for an arbitrary credential name, which you choose
for yourself.  This will be how you remember and refer to this Azure credential
in Juju. The second question will ask you to select an 'Auth Type' from the
following two options:

```bash
interactive*
service-principal-secret
```

The `*` after 'interactive' indicates this is the default option, and you can
either type 'interactive' manually, or simply press 'Enter' to continue. 

!!! Note: The 'interactive' option is far quicker and easier than manually
adding credentials via the 'service-principal-secret' option, but instructions
for this are covered in the [Manually adding
credentials](#manually-adding-credentials) section.

You will then be asked for your Azure subscription id.  After entering this, you'll
be notified that Juju is initiating its interactive authentication followed by
a request to use a web browser to follow [link][azuredeviceauth] and enter an
authentication code:

```bash
To sign in, use a web browser to open the page
https://login.windows.net/common/oauth2/deviceauth. Enter the code
D5RM8DE4J to authenticate.
```

Following the link will open a page that displays 'Device Login' and an empty
text entry field for Juju's authentication code. After entering the code,
you'll see Juju CLI identified as the application publisher and you should
click continue.

You'll next be asked to accept the following permissions needed
by the Juju CLI:

- Sign you in and read your profile
- Read and write directory data
- Access your organization's directory
- Access Azure Service Management as you (preview)

After accepting these permissions, you can close the browser and your Juju
session will automatically complete with output similar to the following:

```bash
Authenticated as "Graham a5a231c2-defd-4e87-a48d-efba12225b75".
Creating/updating service principal.
Assigning Owner role to service principal.
Credentials added for cloud azure.
```

You can now start using Juju with your Azure cloud.

## Create controller


```bash
juju bootstrap azure mycloud
```

A successful bootstrap will result in the controller environment being visible
in the [Azure portal][azureportal].

![Juju environment in Azure portal](media/azure_portal-environment.png)

!!! Note: By default new Azure accounts are limited to 10 cores. You may
need to file a support ticket with Azure to raise this limit for your 
account if you are deploying many or large applications.

## Manually adding credentials

Selecting the `service-principal-secret` authentication option when running
`juju add-credential azure` will require you to configure and retrieve specific
details from your Azure cloud: 

 - application-id
 - subscription-id
 - application-password

In the sections below, we will assign each of these a variable name.  When you
enter them into the command, replace the variable name we give with the actual
ID that corresponds to the variable.

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


### `subscription-id`

List your account. Note the subscription ID, the **SUB_ID**.

```bash
azure account list
```

**SUB_ID** will appear on a line like this:

```no-highlight
info:    Executing command account list
data:    Name        Id                                    Current  State
data:    ----------  ------------------------------------  -------  -------
data:    Free Trial  f717c8c1-8e5e-4d38-be7f-ed1e1c879e18  true     Enabled
info:    account list command OK
```

In the output of this command, the **SUB_ID** is not labeled as such. In our
sample it was next to last line, so:

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

You can now run the interactive `juju add-credential azure` command. Select
`service-principal-secret` as the Auth Type, and supply the following details,
discovered above, when asked:

```bash
APP_ID
SUB_ID
APP_PASSWORD
```

You can now [create the controller](#create-controller).

Alternately, you can also use this credential with [Juju as a Service][jaas] and
create and deploy your model using its GUI.

!!! Note: If you add more than one credential, you will also need to set the
default one to use with `juju set-default-credential`

## Compatibility with older versions of Juju

Juju 2.x support for Azure is backwards compatible with older versions of Juju
but supports several additional features, in particular, support for unit 
placement (i.e. units can be deployed to specific existing machines). In lieu
of this, the old default behaviour is used: units of an application will be 
allocated to machines in an application-specific Availability Set. Read the
[Azure SLA](https://azure.microsoft.com/en-gb/support/legal/sla/) to learn how
availability sets affect uptime guarantees.

[subscriptionblade]: https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade
[azuredeviceauth]: https://login.windows.net/common/oauth2/deviceauth
[azureportal]: http://portal.azure.com
[jaas]: ./getting-started.html "Getting Started with Juju as a Service"
