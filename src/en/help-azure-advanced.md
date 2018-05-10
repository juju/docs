Title: Using Microsoft Azure with Juju - advanced

# Using Microsoft Azure with Juju - advanced

This page is dedicated to more advanced topics related to using Microsoft Azure
with Juju. The main page is [here][clouds-azure].

## Manually adding Azure credentials

The manual option is useful if Juju fails to automatically gather your
credentials, or if you want to automate the process.

### Gathering values

We will need values for the following bits of information:

 - application-id
 - subscription-id
 - application-password
 - application-name
 - tenant-id

In the sections below, we will assign each of these a variable name.  When you
enter them into the command, replace the variable name we give with the actual
ID that corresponds to the variable.

!!! Important:
    This process requires the Azure CLI tool to be installed and a successful
    login with it. See [Install the CLI tool][clouds-azure-cli-install] and
    [Log in to Azure][clouds-azure-cli-login] respectively.

#### `subscription-id`

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

#### `application-password` and `application name`

Create a password for the application to use. You will also need to come up
with an arbitrary application name (typically an internet domain). In our
example:

```bash
APP_PASSWORD=some_password
APP_NAME=ubuntu.example.com
```

Now create an Active Directory (Kerberos) server principal and grant the
required resource permissions by assigning a role of ***Owner***:

```bash
az ad sp create-for-rbac --name "$APP_NAME" --password $APP_PASSWORD --role Owner
```

The command output will be similar to the following:

```yaml
{
  "appId": "01dfe0e9-f088-4d00-9fcf-2129de64d5d3",
  "displayName": "ubuntu.example.com",
  "name": "http://ubuntu.example.com",
  "password": "some_password",
  "tenant": "0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af"
}
```

#### `application-id` and `tenant-id`

In the previous output we'll be using the value that follows **appId** as
**APP_ID** and **tenant** as **TENANT_ID**. Hence:

```bash
APP_ID=01dfe0e9-f088-4d00-9fcf-2129de64d5d3
TENANT_ID=0fb95fd9-f42f-4c78-94c9-e3d01c2bc5af
```

### Verification of values

You can now verify the values we've collected by logging in using the
application principal as your identity:

```bash
az login --service-principal -u http://"$APP_NAME" -p "$APP_PASSWORD" --tenant "$TENANT_ID"
```

Command output will look similar to the following:

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
      "name": "http://ubuntu.example.com",
      "type": "servicePrincipal"
    }
  }
]
```

## Add credentials

One benefit of adding credentials manually is the ability to automate the
process. We will therefore use a file (here called `creds.yaml`) to store our
information:

```no-highlight
credentials:
  azure:
    az-manual4:
      auth-type: service-principal-secret
      application-id: 01dfe0e9-f088-4d00-9fcf-2129de64d5d3
      subscription-id: f717c8c1-8e5e-4d38-be7f-ed1e1c879e18
      application-password: some_password
```

Now run the following command to add your Azure credentials to Juju:

```bash
juju add-credential -f creds.yaml azure
```

## Next steps

You should now continue reading the main
[Using Microsoft Azure with Juju][clouds-azure-controller] page at the
controller-creation step.

!!! Note:
    If you add more than one credential you will need to either specify one
    while creating the controller (`juju bootstrap --credential`) or set a
    default (`juju set-default-credential`) before doing so.


<!-- LINKS -->

[clouds-azure]: ./help-azure.html
[clouds-azure-controller]: ./help-azure.html#create-the-juju-controller
[clouds-azure-cli-install]: ./help-azure.html#install-the-cli-tool
[clouds-azure-cli-login]: ./help-azure.html#log-in-to-azure
