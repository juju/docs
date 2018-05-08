Title: 

# Using Microsoft Azure with Juju - advanced

This page is dedicated to more advanced topics related to using Microsoft Azure
with Juju. The main page is [here][clouds-azure].

## Manually adding Azure credentials

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
    to authorize the session. See **[Credentials][anchor__credentials]** above for more
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


<!-- LINKS -->

[clouds-azure]: ./help-azure.html
