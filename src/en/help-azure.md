Title: Help with Azure clouds
TODO: Update azure-cli to use snap when stable (checked 10 Aug 2017)

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

Before you can use Azure with Juju, you will need to import your Azure
account credentials into Juju and retrieving those credentials is easy, thanks
to Microsoft's [Azure CLI 2.0][azurecli].

Ubuntu/Linux users can install Azure CLI 2.x with the following command:

```bash
curl -L https://aka.ms/InstallAzureCli | bash
```

Accept the default options when asked for install locations and allow the
installer to update your $PATH. Finally, run `exec -l $SHELL` to restart your
shell. Typing `az --version` will show you now have Azure CLI 2.x installed.

For instructions that cover installing Azure CLI on Microsoft Windows and Apple
macOS, see Microsoft's [Install Azure CLI 2.0][azuretwoinstall] documentation.

With Azure CLI installed, you can login to your Azure account by entering the
following command:

```bash
az login
```
The above command will prompt you to open a browser with a specific URL and
enter a provided authentication code.

After entering the code and pressing continue, you will be asked to select the
Microsoft account you'd like associated with the Azure CLI. 

Back on the command line, the output from `az login` will have concluded by
displaying the credentials for your account: 

```yaml
[
  {
    "cloudName": "AzureCloud",
    "id": "f717c8c1-8e5e-4d38-be7f-ed1e1c879e18",
    "isDefault": true,
    "name": "Pay-As-You-Go",
    "state": "Enabled",
    "tenantId": "0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af",
    "user": {
      "name": "javierlarin72@gmail.com",
      "type": "user"
    }
  }
]
```

Your Azure credentials can now be added to Juju by running the command:

```bash
juju add-credential azure
```

You will first be asked for an arbitrary credential name, which you choose
for yourself.  This will be how you remember and refer to this Azure credential
in Juju. The second question will ask you to select an 'Auth Type' from the
following two options:

- interactive
- service-principal-secret

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

The 'interactive' option is far quicker and easier than manually adding
credentials via the 'service-principal-secret' option, but instructions for
this are covered in the [Manually adding
credentials](#manually-adding-credentials) section below. Follow this manual
process if the 'interactive' option fails, or you want to configure automated
testing in a new environment.

You then will be asked for your Azure subscription id (***id*** from the
`az login` credentials output, as shown above). Entering this is optional, as your Azure
credentials will be automatically retrieved by Juju by pressing enter. 

Once the authentication is successful, you will see the following:

```no-highlight
Credentials added for cloud azure.
```

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

!!! Note:
    By default new Azure accounts are limited to 10 cores. You may
    need to file a support ticket with Azure to raise this limit for your 
    account if you are deploying many or large applications.

## Manually adding credentials

The manual option is useful if Juju fails to automatically gather your
credentials, or if you want to automate the process within a testing
environment.

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
    Make sure you have the Azure CLI installed and that you've used `az login`
    to authorize the session. See **[Credentials][credentials]** above for more
    details.

### `subscription-id`

List your account. Note the subscription ID, the **SUB_ID**.

```bash
az account list
```

**SUB_ID** will appear on the line labelled **id**:

```yaml
[
  {
    "cloudName": "AzureCloud",
    "id": "f717c8c1-8e5e-4d38-be7f-ed1e1c879e18",
    "isDefault": true,
    "name": "Pay-As-You-Go",
    "state": "Enabled",
    "tenantId": "0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af",
    "user": {
      "name": "javierlarin72@gmail.com",
      "type": "user"
    }
  }
]
```

In our sample, **SUB_ID** is the second line line, so:

```bash
SUB_ID=f717c8c1-8e5e-4d38-be7f-ed1e1c879e18
```

### `application-password` and  `application-id`

Create a password for the application to use. In our sample:

```bash
APP_PASSWORD=some_password
```

Now create an Active Directory (Kerberos) server principal and grant the
required resource permissions by assigning a role of ***Owner***:

```bash
az ad sp create-for-rbac --name "ubuntu.example.com" --password $APP_PASSWORD --role Owner
```

The `--name` option is arbitrary but you should use a unique value that makes
sense for your environment. The command output will be similar to the
following:

```yaml
{
  "appId": "01dfe0e9-f088-4d00-9fcf-2129de64d5d3",
  "displayName": "ubuntu.example.com",
  "name": "http://ubuntu.example.com",
  "password": "$APP_PASSWORD",
  "tenant": "0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af"
}
```

We'll be using the value that follows **appId** as **APP_ID** and **tenant** as
**TENANT_ID**. 

You can now test these values by logging in using the application principal as
your identity:

```bash
az login --service-principal \
        -u "$APP_NAME" \
        -p "$APP_PASSWORD" \
        --tenant "$TENANT_ID"
```

Command output will look similar to the following:

```yaml
[
  {
    "cloudName": "AzureCloud",
    "id": "49d8c50b-e693-4be8-b906-c7a859149486",
    "isDefault": true,
    "name": "Pay-As-You-Go",
    "state": "Enabled",
    "tenantId": "0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af",
    "user": {
      "name": "http://ubuntu2.example.com",
      "type": "servicePrincipal"
    }
  }
]
```

You can now run the interactive `juju add-credential azure` command. Select
`service-principal-secret` as the Auth Type, and supply the following details,
discovered above, when asked:

- **APP_ID**
- **SUB_ID**
- **APP_PASSWORD**

A typical `add-credential` step-through will look similar to the following:

```no-highlight
Enter credential name: az-manual

Auth Types
  interactive
  service-principal-secret

Select auth type [interactive]: service-principal-secret

Enter application-id: http://ubuntu.example.com
Enter subscription-id: 49d8c50b-e693-4be8-b906-c7a859149486
Enter application-password: $APP_PASSWORD

Credentials added for cloud azure.
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
[azurecli]: https://docs.microsoft.com/en-us/cli/azure/overview 
[snapcraft]: https://snapcraft.io/
[npminfo]: https://docs.npmjs.com/getting-started/what-is-npm
[azuretwo]: https://github.com/Azure/azure-cli
[azuretwoinstall]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
