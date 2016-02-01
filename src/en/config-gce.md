Title: Juju GCE provider


# Overview

Google Compute Engine (GCE) is the Infrastructure as a Service (IaaS) component
of Google Cloud Platform which is built on the global infrastructure that runs
Google’s search engine, Gmail, YouTube, and other services. GCE enables users to
launch virtual machines on demand. Juju can use GCE by communicating with it
via API calls.


# Prerequisites and installation

 - A Google account is required. See http://google.com .

 - A GCE account is required. See https://cloud.google.com/compute/ .

 - The Juju devel PPA (may change) is needed.

 - The Juju client (the host running the below commands) will need the ability
   to contact the GCE infrastructure on TCP ports 22 and 17070.

Proceed to install the software.

```bash
sudo apt-add-repository -y ppa:juju/devel
sudo apt-get update
sudo apt-get install -y juju-core
```


# Create a GCE project

A separate GCE *project* is needed.

According to Google: "A project is a container for all GCE resources. Each
project is a compartmentalized world. They do not share resources, can have
different owners/users, and are billed separately.".

Create a project now. If you have already used GCE your existing projects will
be listed in the pull-down menu with one being selected as your currently
active project (here 'Juju-GCE'). The dialog is found at the top-right corner:

![create_gce_project_dropdown](./media/config-gce-new_project_dropdown.png)

Enter some details. If you have already created a project in the past you
will not see the extra two questions shown below:

![create_gce_project_details](./media/config-gce-first_project_create.png)

The *project id* (used later) will be generated automatically. Use the 'Edit'
button to change it.


## Google Compute Engine API

The Google Compute Engine API needs to be enabled for your new project in order
for Juju to communicate with it. This is done automatically if a "billing
method" has been set up. By following the below steps you will discover whether
you need to set up billing or not. Check to see if a trial account is available.

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


## GCE project credentials file

A collection of credentials-related material will be required. This is obtained
by downloading a file from the UI.

Return to the 'API Manager' and choose the 'Credentials' screen. By default you
will be within the 'Credentials' tab. Click the 'New credentials' button and
choose 'Service account key' among the 3 options available:

![Create credentials dialog #1](./media/config-gce-api_manager_create_credentials-1.png)

In the ensuing dialog, select 'Compute Engine default service account' and 'JSON'
key type:

![Create credentials dialog #2](./media/config-gce-api_manager_create_credentials-2.png)

Once the 'Create' button is pressed you will be prompted to download a file.
This is the file we're after. Store it safely as this file cannot be
regenerated (although a new one can easily be created).

Place this file where the Juju client can find it. This may or may not be on
the computer you downloaded the file to. We recommend the `~/.juju` directory.
For the current example, the file is called `Juju-GCE-f33a6cdbd8e3.json` (based
on our project name of 'Juju-GCE'. Let it be put here:

`/home/ubuntu/.juju/Juju-GCE-f33a6cdbd8e3.json`

!!! Warning: Due to
[LP #1533790](https://bugs.launchpad.net/juju-core/+bug/1533790) make a copy of
the original file and put it in another location. Edit the original file by
removing the lines containing these keywords: 'project-id', 'auth-uri',
'token_uri', 'auth_provider_x509_cert_url', and 'client-x509-cert-url'.


# Configuring for GCE

If this is a new Juju install then you do not yet have a
`~/.juju/environments.yaml` file. Create one with

```bash
juju generate-config
```

If it does exist (but it was created with an older version of Juju), first move
it out of the way (back it up) and *then* generate a new one. Alternatively,
you can output a generic file to screen (STDOUT) and paste the Azure parts into
your existing file:

```bash
juju generate-config --show
```

The file will contain a section for the Azure provider.


## Configure and bootstrap

Values will need to be found for the following parameters:

 - auth-file
 - project-id

### `auth-file`

The value of `auth-file` is the path to the credentials file downloaded
previously.

### `project-id`

The value of `project-id` is based on the name of the project you created earlier.
Take it from the downloaded file.

According to all the above, the GCE section of file `environments.yaml` for
this example would look like this (comments removed for simplicity):

```yaml
    gce:
      type: gce
      auth-file: /home/ubuntu/.juju/Juju-GCE-f33a6cdbd8e3.json
      project-id: juju-gce-1202
```

Finally, switch to the GCE provider and bootstrap:

```bash
juju switch gce
juju bootstrap --debug
```

A successful bootstrap will result in the controller being visible in the
[GCE console](https://console.cloud.google.com/compute):

![bootstrap machine 0 in GCE portal](./media/config-gce-gce_portal-machine_0.png)


# Additional notes

See [General configuration options](https://jujucharms.com/docs/stable/config-general)
for additional and advanced customization of your environment.


## gcloud compute CLI tool

The *gcloud compute* tool is a CLI utility for querying and configuring a CGE
account/project. It is not required nor sufficient for setting up Juju for GCE.
It does, however, have many uses. In particular, it can be used to change
defaults such as compute *zone* and *region*. The Google Cloud SDK gets installed
along with the tool.

Installation:

```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

For further information on the gcloud tool:

https://cloud.google.com/sdk/gcloud/
