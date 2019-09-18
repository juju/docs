<!--
Todo:
- Update azure-cli to use a snap when stable (checked 8 May 2018)
- Possible to get a list of zones for each region? How can one specify a zone otherwise?
-->

Juju already has knowledge of the Azure cloud, which means adding your Azure account to Juju is quick and easy.

You can see more specific information on Juju's Azure support (e.g. the supported regions) by running:

```text
juju show-cloud azure
```

To ensure that Juju's information is up to date (e.g. new region support), you can update Juju's public cloud data by running:

```text
juju update-public-clouds
```

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Credentials](/t/credentials/1112) page offers a full treatment of credential management.

Several steps are required to add Azure credentials to Juju:

- Install the CLI tool
- Log in to Azure
- Import the credentials

[note type="caution"]
Azure account credentials have been reported to expire. If a previously working setup suddenly behaves as if incorrect credentials are being used then you may need to update the credentials on the controller. See [Updating remote credentials](/t/credentials/1112#heading--updating-remote-credentials) for guidance.
[/note]

Alternately, you can use your credentials with [Juju as a Service](/t/getting-started-with-juju/1134), where charms can be deployed within a graphical environment that comes equipped with a ready-made controller.

<h3 id="heading--install-the-cli-tool">Install the CLI tool</h3>

You will need to import your Azure credentials into Juju using the [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/overview) tool from Microsoft.

Ubuntu/Linux users can install Azure CLI 2.0 with the following command:

``` text
curl -L https://aka.ms/InstallAzureCli | bash
```

[note]
For instructions that cover installing Azure CLI on Microsoft Windows and Apple macOS, see Microsoft's [Install Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) documentation.
[/note]

If the installer encounters any difficulties it will let you know. Examples include the inability to find your system's Python interpreter or missing software dependencies. Run any commands that the installer suggests in order to rectify these deficiencies. You may need to prepend `sudo` to some commands (only do this if needed). After each command, rerun the above `curl` command. Accept the suggested default answers to any questions it may ask (by just pressing 'Enter').

[note]
The following commands were run (May 21, 2019) prior to the `curl` command on Ubuntu 18.04.2 LTS and the command completed without error:

`sudo ln -s /usr/bin/python3 /usr/bin/python`
`sudo apt install python3-distutils gcc python3-dev`
[/note]

At the end you will be asked to run `exec -l $SHELL` to restart your shell.

Verify that the tool is properly installed by running `az --version`.

<h3 id="heading--log-in-to-azure">Log in to Azure</h3>

Log in to your Azure account in order to display the credentials that you will, in turn, provide to Juju:

``` text
az login
```

This will output a URL and a code, for example:

``` text
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code D6FRLOY6U to authenticate.
```

After entering the code the web site should show 'Microsoft Azure Cross-platform Command Line Interface'. Press the 'Continue' button. The resulting page will ask you to "Pick an account". This is just the email address that you've associated with your Azure account. Click on it. You are now logged in to your Azure account.

<h3 id="heading--import-the-credentials">Import the credentials</h3>

Back on the command line, the output from `az login` should now display your Azure account information:

``` yaml
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

``` text
juju add-credential azure
```

You will first be asked for an arbitrary credential name (e.g. 'ubuntu'). Secondly, you will be asked to select an 'Auth Type' from among the following two methods:

- interactive
- service-principal-secret

The default choice is `interactive` and it is the recommended method. It is far quicker and easier than the manual `service-principal-secret` method. Here, we'll assume that 'interactive' has been chosen.

[note]
For guidance on the manual method, see [Manually adding Azure credentials](/t/using-microsoft-azure-with-juju-advanced/1085#heading--manually-adding-azure-credentials). Use this method if the interactive option fails, or if you want to automate the configuration process.
[/note]

You then will be asked for your subscription id. In the example above, it is 'f717c8c1-8e5e-4d38-be7f-ed1e1c879e18'. The recommended way is to simply press 'Enter' and let the tool automatically retrieve what's needed. If you do so, after a few seconds you will see the following (assuming 'ubuntu' is the credential name):

``` text
Credential "ubuntu" added locally for cloud "azure".
```

You can also verify that the credentials were successfully added by running `juju credentials`.

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'azure':

``` text
juju bootstrap azure azure-controller
```

Above, the name given to the new controller is 'azure-controller'. Azure will provision an instance to run the controller on.

This will result in the controller environment being visible in the [Azure portal](http://portal.azure.com).

![Juju environment in Azure portal](https://assets.ubuntu.com/v1/95d6cd3e-azure_portal-environment.png)

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--azure-specific-features">Azure specific features</h2>

Juju supports Azure availability sets. See the [Application high availability](/t/application-high-availability/1066#heading--azure-availability-sets) page for more details.

[note]
Azure accounts are initially limited to 10 cores (trial accounts can be even lower). You will need to file a support ticket with Azure to raise your quota limit.
[/note]

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
