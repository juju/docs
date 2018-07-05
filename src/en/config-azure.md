Title: Configuring for Microsoft Azure


# Configuring for Microsoft Azure 

!!! Warning: Azure has two concurrent UI versions: the older "classic" console
(https://manage.windowsazure.com) and the "new" console
(https://portal.azure.com). The features necessary in this document are only
available in the classic portal.


## Prerequisites

 - An Azure account is required. See http://azure.microsoft.com.

 - An SSL/TLS certificate, either an existing one or a new one, will be needed to
   communicate with Azure.

 - Juju 1.25 (or greater) is needed for [storage support](./storage.html).

 - The Juju client (the host running the below commands) will need the ability
   to contact the Azure infrastructure on TCP ports 22 and 17070.

### SSL/TLS certificate

The certificate will be uploaded to Azure to enable the Juju client to
authenticate (and communicate securely) using the associated private key.

Certificate creation is dependant on platform. Below, the *openssl* command
on Ubuntu is used to create a
[self-signed certificate](https://en.wikipedia.org/wiki/Self-signed_certificate).

During the creation process, you will be prompted for some information
(country, state, location, organisation, and common name). 'country' must be a
valid 2-character value but the others are arbitrary.

!!! Note: We recommend a meaningful name for 'common name' such as 'juju-azure'
as this will become the "name" of the certificate.

Create the key and certificate now:

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
	-keyout juju-azure.pem -out juju-azure.pem
openssl x509 -inform pem -in juju-azure.pem -outform der -out juju-azure.cer
chmod 600 juju-azure.pem
```

The certificate is in file `juju-azure.cer` and the private key is in
`juju-azure.pem`.

!!! Note: The PEM file (`juju-azure.pem`) actually contains both the private key
and the certificate.

Copy the PEM file to where Juju can find it:

```bash
cp juju-azure.pem /home/ubuntu/.juju
```

#### Upload certificate to Azure

Log in to the classic console at https://manage.windowsazure.com and in the
left pane, scroll down and select 'Settings'. Select the 'Management
Certificates' tab in the right pane. 

![azure_settings_and_certificates](media/config-azure-stable_settings_and_certificates.png)

At the bottom there is an 'Upload' icon.  Use it to upload the certificate
(`juju-azure.cer`).


## Configure and bootstrap

If this is a new Juju install then you do not yet have a
`~/.juju/environments.yaml` file. Create one with

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

 - management-subscription-id
 - storage-account-name
 - location
 - management-certificate-path

Access the Classic Azure console (https://manage.windowsazure.com) again to
gather the first three values.

### `management-subscription-id`

Enter 'Settings' again, find the appropriate subscription in the right pane, and
take note of its `subscription ID`. This is the value to be used for
`management-subscription-id`.

![azure_settings_page](media/config-azure-stable_settings-page.png)

### `storage-account-name`

First create a *storage account*. In the left pane, scroll down to 'Storage'
and press the **+ NEW** icon (bottom-left). An overlay page will appear. Click
'Quick Create' and fill in the 'URL' field (e.g. `jujuazure`). This is the
value to be used for `storage-account-name`.

![azure_storage account_creation](media/config-azure-stable_storage.png)

### `location`

In the same dialog, select a 'Location/Affinity Group'.

If you intend to use [storage support](./storage.html) then this value and the
value you provide the `location` paramter must be the same. Failure to do so
will result in storage being used local to the Juju machine where the charm is
being run. Note that there is a limited set of regions available in the Azure
UI. Choose one that is closest to you:

![azure_storage_region_dropdown](media/config-azure-stable_storage_locations_dropdown.png)

For insight into the 'Replication' field see
[Azure storage redundancy documentation](https://azure.microsoft.com/documentation/articles/storage-redundancy)
.

!!! Note: Once you bootstrap Juju, an Azure affinity group (e.g.
`juju-azure-ag`) will appear in this list if you ever come back to it. See
[stackoverflow.com: "Azure Availability Set vs Affinity
Group"](http://stackoverflow.com/questions/25472549/azure-availability-set-vs-affinity-group)
for context.

### `management-certificate-path`

The value of this parameter is the file path of the private key (and
certificate) stored in the PEM file created earlier:
`/home/ubuntu/.juju/juju-azure.pem`.


## Confirm configuration and bootstrap

According to all the above, the Azure section of file `environments.yaml` for
this example would look like this (comments removed for simplicity):

```yaml
    azure:
        type: azure
        location: Central US
        storage-account-name: jujuazure
        management-subscription-id: f717c8c1-8e5e-4d38-be7f-ed1e1c879e18
        management-certificate-path: /home/ubuntu/.juju/juju-azure.pem
```

Finally, switch to the Azure provider and bootstrap:

```bash
juju switch azure
juju bootstrap --debug
```

A successful bootstrap will result in the controller being visible in the Classic console
under 'Virtual Machines' in the left pane:

![bootstrap machine 0 in Azure portal](media/config-azure-stable_machine_0.png)

!!! Note: By default new Azure accounts are limited to 10 cores. You may
 +need to file a support ticket with Azure to raise this limit for your 
 +account if you are deploying many or large applications.
 
## Additional notes

The default behaviour is for units of a service to be allocated to
machines in a service-specific Availability Set. Read the
[Azure SLA](https://azure.microsoft.com/en-gb/support/legal/sla/) to learn how
availability sets affect uptime guarantees.

See [General configuration options][config]
for additional and advanced customization of your environment.

[config]: ./config-general
