Title: Help with Azure clouds
TODO: Update azure-cli to use snap when stable (checked 10 Aug 2017)

# Using the Microsoft Azure public cloud

Juju already has knowledge of the Azure cloud, which means adding your Azure
account to Juju is quick and easy.

You can see more specific information on Juju's Azure support (e.g.  the
supported regions) by running:

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

Before you can use Azure with Juju, you will need to import your Azure
account credentials into Juju. Retrieving those credentials is easy, thanks to
Microsoft's new [Azure CLI][azurecli].

Azure CLI can be installed using *[npm][npminfo]*. Enter the following
command to install npm if it isn't already on your system:

```bash
sudo apt install -y nodejs-legacy npm
```

The following command will install Azure CLI with *npm*:

```bash
sudo npm install -g azure-cli
```

With 'azure-cli' installed, you can login to your Azure account with the
following command:

```bash
azure login
```
The above command will prompt you to open a browser with a specific URL and
enter a provided authentication code.

After entering the code and pressing continue, you will be asked to select the
Microsoft account you'd like associated with the Azure CLI. 

!!! Note:
    For further details on the Azure CLI, see [Microsoft's
    documentation][azurecommands].

Back on the command line, the output from `azure login` will have concluded by
displaying `info:    login command OK`. Typing `azure account show` will now
output the credentials for your account, and you will need to make a note of
the *ID* value:

```yaml
info:    Executing command account show
data:    Name                        : Pay-As-You-Go
data:    ID                          : 43456246-e693-4236-2636-224624659486
data:    State                       : Enabled
data:    Tenant ID                   : 0f242469-f23f-4c78-2365-2362362653af
data:    Is Default                  : true
data:    Environment                 : AzureCloud
data:    Has Certificate             : No
data:    Has Access Token            : Yes
data:    User name                   : javierlarin72@gmail.com
data:
info:    account show command OK
```

Credentials can now be added by running the command:

```bash
juju add-credential azure
```
The first question will ask for an arbitrary credential name, which you choose
for yourself.  This will be how you remember and refer to this Azure credential
in Juju. The second question will ask you to select an 'Auth Type' from the
following two options:

```no-highlight
interactive
service-principal-secret
```

The default option is `interactive` and you can either type 'interactive' or
press 'Enter' to continue. 

!!! Note: 
    The 'interactive' option is far quicker and easier than manually adding
    credentials via the 'service-principal-secret' option, but instructions for
    this are covered in the [Manually adding credentials](#manually-adding-credentials)
    section.

Finally, you will be asked for your Azure subscription id. Enter the value
alongside *ID* in the output from `azure account show` command, as shown above. You
will then be asked to step through the browser authentication process again to
validate **Juju CLI** against your Azure cloud. 

Once the authentication is successful, you will see output similar to the
following:

```bash
Authenticated as "Javier fdgsfdrgdf-fexd-4e87-a48d-ef3534699215b76".
Credentials added for cloud azure.
```

If you want to check that the credentials were successfully added, use the
`juju credentials` command. You will see your Azure credentials listed.

You can now start using Juju with your Azure cloud.

## Create controller

```bash
juju bootstrap azure mycloud
```

A successful bootstrap will result in the controller environment being visible
in the [Azure portal][azureportal].

![Juju environment in Azure portal](media/azure_portal-environment.png)

!!! Note:
    By default new Azure accounts are limited to 10 cores. You may
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

!!! Note:
    Make sure you have the Azure CLI installed and that you've used `azure login`
    to authorize the session. See **[Credentials][credentials]** above for more
    details.

### `subscription-id`

List your account. Note the subscription ID, the **SUB_ID**.

```bash
azure account list
```

**SUB_ID** will appear on a line like this:

```no-highlight
info:    Executing command account list
data:    Name           Id                                    Current  State
data:    -------------  ------------------------------------  -------  -------
data:    Pay-As-You-Go  f717c8c1-8e5e-4d38-be7f-ed1e1c879e18  true     Enabled
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

Now create an Active Directory (Kerberos) server principal:

```bash
azure ad sp create --name "ubuntu.example.com" --password $APP_PASSWORD
```

The `--name` option is arbitrary but you should use a value that make sense for
your environment. The command output will be similar to the following:

```no-highlight
info:    Executing command ad sp create
+ Creating application ubuntu.example.com
+ Creating service principal for application  e03f5baa-b63c-4a75-a52e-5ed55d9343ef
data:    Object Id:               8ff5e077-c5c2-40ec-abd8-ba9d4c288c17
data:    Display Name:            ubuntu.example.com
data:    Service Principal Names:
data:                             e03f5baa-b63c-4a75-a52e-5ed55d9343ef
data:                             http://ubuntu.example.com
info:    ad sp create command OK
```

Make a note of the value that follows *Creating service principal for
application*, as this is the **APP_ID**. Also make a note of `Object ID`, which
we'll refer to as **OBJ_ID**

Now grant permissions to the principal with the following command:

```bash
azure role assignment create --objectId $OBJ_ID -o Owner
```

The above command will successfully conclude with 'role assignment create
command OK'.

### `tenant-id`

Get the tenant id, the **TENANT_ID**:

```bash
azure account show
```
In our sample it was on a line like this:

```bash
data:    Tenant ID                   : 0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af
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

!!! Note:
    If you add more than one credential, you will also need to set the
    default one to use with `juju set-default-credential`

## Compatibility with older versions of Juju

Juju 2.x support for Azure is backwards compatible with older versions of Juju
but supports several additional features, in particular, support for unit 
placement (i.e. units can be deployed to specific existing machines). In lieu
of this, the old default behaviour is used: units of an application will be 
allocated to machines in an application-specific Availability Set. Read the
[Azure SLA](https://azure.microsoft.com/en-gb/support/legal/sla/) to learn how
availability sets affect uptime guarantees.

<!-- LINKS -->
[credentials]: ./help-azure.html#credentials
[subscriptionblade]: https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade
[azuredeviceauth]: https://login.windows.net/common/oauth2/deviceauth
[azureportal]: http://portal.azure.com
[jaas]: ./getting-started.html "Getting Started with Juju as a Service"
[azurecli]: https://azure.microsoft.com/en-us/features/cloud-shell/
[snapcraft]: https://snapcraft.io/
[npminfo]: https://docs.npmjs.com/getting-started/what-is-npm
[azurecommands]: https://docs.microsoft.com/en-us/azure/virtual-machines/azure-cli-arm-commands
