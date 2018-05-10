Title: Using Microsoft Azure with Juju
TODO: Update azure-cli to use a snap when stable (checked 8 May 2018)
      Possible to get a list of zones for each region? How can one specify a zone otherwise?

# Using Microsoft Azure with Juju

Juju already has knowledge of the Azure cloud, which means adding your Azure
account to Juju is quick and easy.

You can see more specific information on Juju's Azure support (e.g. the
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

## Add credentials

Several steps are required to add Azure credentials to Juju:

 - Install the CLI tool
 - Log in to Azure
 - Import the credentials

### Install the CLI tool

You will need to import your Azure credentials into Juju using the
[Azure CLI 2.0][azurecli] tool from Microsoft.

Ubuntu/Linux users can install Azure CLI 2.0 with the following command:

```bash
curl -L https://aka.ms/InstallAzureCli | bash
```

!!! Note:
    For instructions that cover installing Azure CLI on Microsoft Windows and
    Apple macOS, see Microsoft's [Install Azure CLI 2.0][azuretwoinstall]
    documentation.

If the installer encounters any difficulties it will let you know. Examples
include the inability to find your system's Python interpreter or missing
software dependencies. Run any commands that the installer suggests in order to
rectify these deficiencies. You may need to prepend `sudo` to some commands
(only do this if needed). After each command, rerun the above `curl` command.
Accept the suggested default answers to any questions it may ask (by just
pressing 'Enter'). At the end you will be asked to run `exec -l $SHELL` to
restart your shell.

Verify that the tool is properly installed by running `az --version`.

### Log in to Azure

Log in to your Azure account in order to display the credentials that you will,
in turn, provide to Juju:

```bash
az login
```

This will output a URL and a code, for example:

```no-highlight
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code D6FRLOY6U to authenticate.
```

After entering the code the web site should show 'Microsoft Azure
Cross-platform Command Line Interface'. Press the 'Continue' button.

### Import the credentials

Back on the command line, the output from `az login` should now display your
Azure account information: 

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

Now initiate the process to import your Azure credentials into Juju:

```bash
juju add-credential azure
```

You will first be asked for an arbitrary credential name (e.g. 'ubuntu').
Secondly, you will be asked to select an 'Auth Type' from among the following
two methods:

- interactive
- service-principal-secret

The default choice is `interactive` and it is the recommended method. It is far
quicker and easier than the manual `service-principal-secret` method. Here,
we'll assume that 'interactive' has been chosen.

!!! Note:
    For guidance on the manul method, see
    [Manually adding Azure credentials][clouds-azure-advanced]. Use this method
    if the interactive option fails, or if you want to automate the
    configuration process.

You then will be optionally asked for your subscription id. In the example
above, it is 'f717c8c1-8e5e-4d38-be7f-ed1e1c879e18'. The recommended way is to
simply press 'Enter' and let the tool automatically retrieve what's needed. If
you do so, after a few seconds you will see the following (assuming 'ubuntu' is
the credential name):

```no-highlight
Credential "ubuntu" added locally for cloud "azure".
```

You can also verify that the credentials were successfully added by running
`juju credentials`.

## Dealing with expired Azure credentials

Credentials on the Azure cloud have been reported to expire. If a previously
working setup suddenly behaves as if incorrect credentials are being used then
you may need to update the credentials on the controller. See
[Updating remote credentials][updating-remote-credentials] for guidance.

## Create the Juju controller

```bash
juju bootstrap azure mycloud
```

A successful bootstrap will result in the controller environment being visible
in the [Azure portal][azureportal].

![Juju environment in Azure portal](media/azure_portal-environment.png)

!!! Note:
    Azure accounts are initially limited to 10 cores (trial accounts can be
    even lower). You will need to file a support ticket with Azure to raise
    your quota limit.

## Compatibility with older versions of Juju

Juju 2.x support for Azure is backwards compatible with older versions of Juju
but supports several additional features, in particular, support for unit
placement (i.e. units can be deployed to specific existing machines). In lieu
of this, the old default behaviour is used: units of an application will be
allocated to machines in an application-specific Availability Set. Read the
[Azure SLA][azure-sla] to learn how availability sets affect uptime guarantees.

## Next steps

You can now start deploying Juju charms and/or bundles to your MAAS cloud.
Continue with Juju by visiting the [Models][models] and
[Introduction to Juju Charms][charms] pages.


<!-- LINKS -->

[anchor__credentials]: ./help-azure.html#credentials
[updating-remote-credentials]: ./credentials.html#updating-remote-credentials
[subscriptionblade]: https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade
[azuredeviceauth]: https://login.windows.net/common/oauth2/deviceauth
[azureportal]: http://portal.azure.com
[jaas]: ./getting-started.html "Getting Started with Juju as a Service"
[azurecli]: https://docs.microsoft.com/en-us/cli/azure/overview 
[snapcraft]: https://snapcraft.io/
[npminfo]: https://docs.npmjs.com/getting-started/what-is-npm
[azuretwo]: https://github.com/Azure/azure-cli
[azuretwoinstall]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
[#manually-adding-credentials]: #manually-adding-credentials
[azure-sla]: https://azure.microsoft.com/en-gb/support/legal/sla/
[clouds-azure-advanced]: ./help-azure-advanced.html
