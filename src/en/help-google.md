Title: Using Google GCE with Juju
TODO:  credentials page scheduled to cover the special env variables. Link when done

# Using Google GCE with Juju

Juju already has knowledge of the GCE cloud, so unlike previous versions there
is no need to provide a specific configuration for it, it 'just works'. GCE
will appear in the list of known clouds when you issue the command:
  
```bash
juju clouds
```

And you can see more specific information (e.g. the supported regions) by 
running:
  
```bash
juju show-cloud google
```

If at any point you believe Juju's information is out of date (e.g. Google just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Preparing your GCE cloud for use by Juju

Although Juju knows how GCE works, there are some tasks you must perform 
manually in the GCE dashboard to prepare your account to work with Juju. We
give an overview of the steps here. For greater detail, see the GCE site and
the official [GCE documentation][gce-docs].

### Creating a project

Firstly, you should create a new project for Juju. If you have already used GCE 
your existing projects will be listed in the pull-down menu with one being
selected as your currently active project (here 'My First Project'). The dialog is
found near the top-right corner:

![create_gce_project_dropdown](./media/config-gce-new_project_dropdown.png)

Enter a project name (here 'My Juju-GCE Project'):

![create_gce_project_details](./media/config-gce-first_project_create.png)

The *project id* (used later) will be generated automatically. Click 'Edit'
to change it.

### Enabling the GCE API

The Google Compute Engine API needs to be enabled for your new project in order
for Juju to communicate with it. This is done automatically if a "billing
method" has been set up. By following the below steps you will discover whether
you need to set up billing or not.

At the top-left of the web UI there is an icon representing 'Products &
services'. It is denoted by this icon, next to the 'Google Cloud Platform'
title:

![Product & services icon](./media/config-gce-product_services_icon.png)

Click through and select 'API Manager'. By default you will be on the 'Overview'
screen, it will show this across the top:

![API Manager screen](./media/config-gce-api_manager.png)

Click '+Enable API' and then from the list of available APIs you are shown,
select 'Compute Engine API':

![Compute Engine API](./media/config-gce-api_manager_compute_enabled.png)

On the top of the page that opens, click 'Enable'. If the API is already
enabled, this will display 'Disable'. Clicking it may prompt you to set up a
billing method (if not already done).

## Gathering credential information

Juju will need credential information to authenticate itself to the GCE cloud. 
This is provided in the form of a file which can be  generated and downloaded 
from GCE.

In the GCE web interface, navigate back to the 'API Manager' screen you used 
above, and choose the 'Credentials' screen. By default you
will be within the 'Credentials' tab. Click the 'Create credentials' button and
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

For the current example, say the file is called `My-Juju-GCE-Project-f33a6cdbd8e3.json`
(based on our project name of 'My Juju-GCE Project'), on Ubuntu we would store
it here:

`~/.local/share/juju/Juju-GCE-f33a6cdbd8e3.json`

The section [Using environment variables][#using-environment-variables] below
explains where this data can be stored if you wish to use the
`autoload-credentials` command to add credentials to Juju.

## Adding credentials

In order to access Google GCE, you will need to add credentials to Juju. This
can be done in one of three ways.

### Using the interactive method

Armed with the gathered information, you can add credentials with the command:

```bash
juju add-credential google
```

The command will interactively prompt you for the information needed for the
chosen cloud. For the authentication type, choose 'json' and then give the full
path to the downloaded file.

Alternately, you can use these credentials with [Juju as a Service][jaas] where
you can deploy charms using a web GUI.

### Using a file

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential
information for any cloud. This information is then added to Juju by pointing
the `add-credential` command to the file:

```bash
juju add-credential myopenstack -f mycreds.yaml
```

See section [Adding credentials from a file][credentials-adding-from-file] for
guidance on what such a file looks like.

### Using environment variables

With GCE you have the option of adding credentials using the following
environment variable that may already be present (and set) on your client
system:

`CLOUDSDK_COMPUTE_REGION`

In addition, a special variable may contain the path to a JSON-formatted file
which, in turn, contains credential information:

`GOOGLE_APPLICATION_CREDENTIALS`  

Add this credential information to Juju in this way:
  
```bash
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to
store them under.

On Linux systems, the file
`$HOME/.config/gcloud/application_default_credentials.json` may be used to
contain credential data and is parsed by the above command as part of the
scanning process. On Windows systems, the file is
`%APPDATA%\gcloud\application_default_credentials.json`.

For background information on this method read section
[Adding credentials from environment variables][credentials-adding-from-variables].

## Creating a controller

You are now ready to create a Juju controller for cloud 'google':

```bash
juju bootstrap google google-controller
```

Above, the name given to the new controller is 'google-controller'. GCE will
provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the
[Creating a controller][controllers-creating] page.

## Next steps

A controller is created with two models - the 'controller' model, which
should be reserved for Juju's internal operations, and a model named
'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

 - [Juju models][models]
 - [Introduction to Juju Charms][charms]


<!-- LINKS -->

[gce-docs]: https://console.cloud.google.com/start
[jaas]: ./getting-started.md
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
[credentials-adding-from-variables]: ./credentials.md#adding-credentials-from-environment-variables
