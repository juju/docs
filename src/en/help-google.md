Title: Help with Google Compute Engine clouds

# Using the Google Compute Engine public cloud

Juju already has knowledge of the GCE cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. GCE
will appear in the list of known clouds when you issue the command:
  
```bash
juju list-clouds
```
And you can see more specific information (e.g. the supported regions) by 
running:
  
```bash
juju show-cloud google
```

If at any point you believe Juju's information is out of date (e.g. Amazon just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Preparing your GCE cloud for use by Juju

Although Juju knows how GCE works, there are some tasks you must perform 
manually in the GCE dashboard to prepare your account to work with Juju.

### Create a project

Firstly, you should create a new project for Juju. If you have already used GCE 
your existing projects will be listed in the pull-down menu with one being
selected as your currently active project (here 'Juju-GCE'). The dialog is
found at the top-right corner:

![create_gce_project_dropdown](./media/config-gce-new_project_dropdown.png)

Enter some details. If you have already created a project in the past you
may not see the extra two questions shown below:

![create_gce_project_details](./media/config-gce-first_project_create.png)

The *project id* (used later) will be generated automatically. Use the 'Edit'
button to change it.

### Enable the GCE API

The Google Compute Engine API needs to be enabled for your new project in order
for Juju to communicate with it. This is done automatically if a "billing
method" has been set up. By following the below steps you will discover whether
you need to set up billing or not.

At the top-left of the web UI there is an icon representing 'Product &
services'. It is denoted by this icon:

![Product & services icon](./media/config-gce-product_services_icon.png)

Click through and select 'API Manager'. By default you will be on the 'Overview'
screen, it will show:

![API Manager screen](./media/config-gce-api_manager.png)

Select 'Compute Engine API' to get:

![Compute Engine API](./media/config-gce-api_manager_compute_enabled.png)

The API is already enabled if the button displays 'Disable API'. If the button
shows 'Enable API', clicking it may prompt you to set up a billing method (if
not already done).

### Download credentials

Juju will need credential information to authenticate itself to the GCE cloud. 
This is provided in the form of a file which can be  generated and downloaded 
from GCE.

In the GCE web interface, navigate back to the 'API Manager' screen you used 
above, and choose the 'Credentials' screen. By default you
will be within the 'Credentials' tab. Click the 'New credentials' button and
choose 'Service account key' from the 3 options available:

![Create credentials dialog #1](./media/config-gce-api_manager_create_credentials-1.png)

In the ensuing dialog, select 'Compute Engine default service account' and 'JSON'
key type:

![Create credentials dialog #2](./media/config-gce-api_manager_create_credentials-2.png)

Once the 'Create' button is pressed you will be prompted to download a file.
This is the file we're after. Store it safely as this file cannot be
regenerated (although a new one can easily be created).

Place this file where the Juju client can find it. This may or may not be on
the computer you downloaded the file to. We recommend storing this file in the 
default Juju directory, to ensure that it is with your other Juju files in 
whatever system backups you perform. 
For the current example, the file is called `Juju-GCE-f33a6cdbd8e3.json` (based
on our project name of 'Juju-GCE'). So for Ubuntu we would store it here:

`~/.local/share/juju/Juju-GCE-f33a6cdbd8e3.json`

## Credentials

Armed with the file downloaded above, you can add the credential with the
command:

```bash
juju add-crdential google
```
For the authentication type, choose 'json' and give the full path to the file
downloaded.
