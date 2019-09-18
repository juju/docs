This page is dedicated to more advanced topics related to using Microsoft Azure with Juju. The main page is [here](/t/using-microsoft-azure-with-juju/1086).

<h2 id="heading--manually-adding-azure-credentials">Manually adding Azure credentials</h2>

The manual option is useful if Juju fails to automatically gather your credentials, or if you want to automate the process.

<h3 id="heading--gathering-values">Gathering values</h3>

We will need values for the following bits of information:

- subscription id
- application name
- application id
- tenant id
- application password

In the sections below, we will assign each of these a variable name. When you enter them into the command, replace the variable name we give with the actual ID that corresponds to the variable.

[note type="caution"]
This process requires the Azure CLI tool to be installed and used to successfully log in to Azure prior to Juju configuration. See [Install the CLI tool](/t/using-microsoft-azure-with-juju/1086#heading--install-the-cli-tool) and [Log in to Azure](/t/using-microsoft-azure-with-juju/1086#heading--log-in-to-azure) respectively.
[/note]

<h4 id="heading--subscription-id">subscription id</h4>

List your account and take note of the subscription ID, the **SUB_ID**.

```text
az account list
```

It will appear on the line labelled **id**:

```yaml
  {
    "cloudName": "AzureCloud",
    "id": "27dcbd27-c935-43f4-a1b5-123456722c00",
    "isDefault": false,
    "name": "Microsoft Azure Enterprise",
    "state": "Enabled",
    "tenantId": "558ac724-0c20-4c6b-ab00-12345679b6f0",
    "user": {
      "name": "javierlarin72@gmail.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "id": "bef58c0a-6fca-489d-8297-12345677f276",
    "isDefault": true,
    "name": "Pay-As-You-Go(Converted to EA)",
    "state": "Enabled",
    "tenantId": "558ac724-0c20-4c6b-ab00-12345679b6f0",
    "user": {
      "name": "javierlarin72@gmail.com",
      "type": "user"
    }
  }
]
```

In this example, there is a Pay-As-You-Go (PAYG) subscription that has been converted to an Enterprise Agreement (EA), which refers to the other stanza (Microsoft Azure Enterprise). It seems we should always choose the PAYG subscription id, so:

```text
SUB_ID=bef58c0a-6fca-489d-8297-12345677f276
```

<h4 id="heading--application-name">application name</h4>

You will need to come up with an arbitrary application name (typically an internet URL). In our example:

```text
APP_NAME=http://ubuntu.example.com
```

Now create an Active Directory (Kerberos) service principal and assign it a role of **Owner**:

```text
az ad sp create-for-rbac --name "$APP_NAME" --role Owner
```

The command output will be similar to the following:

```yaml
{
  "appId": "c07fd75f-dc07-47a1-87ed-123456731897",
  "displayName": "azure-cli-2019-05-22-02-01-44",
  "name": "http://ubuntu.example.com",
  "password": "76ab0f15-4d2e-4dd8-abca-1234567325d5",
  "tenant": "558ac724-0c20-4c6b-ab00-12345679b6f0"
}
```

For more in-depth information, see Microsoft's Azure CLI documentation on [Role-Based Access Control (RBAC)](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-cli) and the [above commmand's syntax](https://docs.microsoft.com/en-us/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac).

<h4 id="heading--application-id-tenant-id-and-application-password">application id, tenant id, and application password</h4>

From the previous output we obtain the following values for `application-id`, `tenant-id`, and `application-password`:

```text
APP_ID=c07fd75f-dc07-47a1-87ed-123456731897
TENANT_ID=558ac724-0c20-4c6b-ab00-12345679b6f0
APP_PASSWORD=76ab0f15-4d2e-4dd8-abca-1234567325d5
```

<h3 id="heading--verification-of-values">Verification of values</h3>

You can verify the values we've collected by logging in using the application principal as your identity:

```text
az login --service-principal -u "$APP_NAME" -p "$APP_PASSWORD" --tenant "$TENANT_ID"
```

Command output will look similar to the following:

```yaml
  {
    "cloudName": "AzureCloud",
    "id": "bef58c0a-6fca-489d-8297-12345677f276",
    "isDefault": true,
    "name": "Pay-As-You-Go(Converted to EA)",
    "state": "Enabled",
    "tenantId": "558ac724-0c20-4c6b-ab00-12345679b6f0",
    "user": {
      "name": "http://ubuntu.example.com",
      "type": "servicePrincipal"
    }
  }
]
```

<h2 id="heading--add-credentials">Add credentials</h2>

Credential information can now be placed into a YAML file and used with a client. Here, we've assigned a credential name of 'jlaurin':

```text
credentials:
  azure:
    jlaurin:
      auth-type: service-principal-secret
      application-id: c07fd75f-dc07-47a1-87ed-123456731897
      subscription-id: bef58c0a-6fca-489d-8297-12345677f276
      application-password: 76ab0f15-4d2e-4dd8-abca-1234567325d5
```

To add credential ‘jlaurin’, assuming the configuration file is `creds.yaml` in the current directory, we would run:

```text
juju add-credential azure -f creds.yaml
```

<h2 id="heading--next-steps">Next steps</h2>

You should now continue reading the main [Using Microsoft Azure with Juju](/t/using-microsoft-azure-with-juju/1086#heading--creating-a-controller) page at the controller-creation step.

[note]
If you add more than one credential you will need to either specify one while creating the controller (`juju bootstrap --credential`) or set a default (`juju set-default-credential`) before doing so.
[/note]
