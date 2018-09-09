Title: Using Google GCE with Juju

# Using Google GCE with Juju

Juju already has knowledge of the GCE cloud, which means adding your GCE
account to Juju is quick and easy.

You can see more specific information on Juju's GCE support (e.g. the
supported regions) by running:

```bash
juju show-cloud google
```

If at any point you believe Juju's information is out of date (e.g. Google just 
announced support for a new region), you can update Juju's public cloud data by
running:
  
```bash
juju update-clouds
```

## Preparing your GCE account

Although Juju knows how GCE works, there are a few tasks you must perform in
order to integrate your account with Juju. We give an overview of the steps
here:

 - Using the CLI tools
 - Assigning user permissions
 - Managing service accounts
 - Gathering credential information
 - Enabling the Compute Engine API

!!! Note:
    The Google [Cloud Platform Console][google-cpc] (web UI) can also be used
    to complete the above steps.

The instructions on this page make use of the Identity and Access Management
(IAM) framework to control access to your GCP account. Read Google's
[Cloud IAM][gce-iam] page for an overview.

### Using the CLI tools

We show how to use the [Cloud SDK tools][google-cloud-sdk-docs] from Google to
manage your GCP (Google Cloud Platform) account. The tools installation
instructions presented here are for Ubuntu/Debian. See the link above for how
to install on other platforms.

Install the tools in this way:

```bash
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
	| sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update && sudo apt install google-cloud-sdk
```

Now initialise the tool:

```bash
gcloud init
```

Among other things, you will be asked to enter a verification code in order to
log in to GCP. This code is acquired by following a supplied hyperlink, which,
in turn, will have you agree on the resulting page to allow Google Cloud SDK to
access your Google account.

You will be given the choice of selecting an existing GCE project or of
creating a new one. If creating, pick a unique name to prevent the command from
exiting. If it does, re-invoke `gcloud init` and choose option [1] to
re-initialise.

When you're done, try out the following commands (we created a project called
'juju-gce-1' during the init phase):

```bash
gcloud components list
gcloud config list
gcloud projects list
gcloud projects describe juju-gce-1
```

See the [gcloud command reference][gcloud-commands] for more help with this
tool.

### Assigning user permissions

Using the IAM framework, we'll be associating credentials with our project at
the *Compute Engine service account* level and not at the level of your
Google user.

To download such credentials, however, your user (now known to the CLI tool)
must have the authorisation to do so. This is done by assigning the role of
'Service Account Key Admin' to your user (insert your project ID and your
user's email address):

```bash
gcloud projects add-iam-policy-binding juju-gce-1 \
	--member user:javierlarin72@gmail.com \
	--role roles/iam.serviceAccountKeyAdmin
```

### Managing service accounts

A project's service accounts are listed in this way:

```bash
gcloud iam service-accounts list --project juju-gce-1
```

You can create a new service account if:

 - you are having trouble identifying an existing one to use
 - your project does not yet have any service accounts
 - you want one dedicated to Juju
 
Here, we will create a new one called 'juju-gce-1-sa':

```bash
gcloud iam service-accounts create juju-gce-1-sa \
	--display-name "Compute Engine Juju service account"
```

For our example project, the list of service accounts is now:

```no-highlight
NAME                                    EMAIL
Compute Engine Juju service account     juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com
```

We must now give our chosen service account enough permissions so it can do
what Juju asks of it. The roles of 'Compute Instance Admin (v1)' and 'Compute
Security Admin' are sufficient:

```bash
gcloud projects add-iam-policy-binding juju-gce-1 \
	--member serviceAccount:juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com \
	--role roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding juju-gce-1 \
	--member serviceAccount:juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com \
	--role roles/compute.securityAdmin
```

Permissions can be configured in multiple ways due to the many IAM roles
available. See upstream document [Compute Engine IAM Roles][gce-iam-roles] for
details.

Verify the roles now assigned to both your user and your service account:

```bash
gcloud projects get-iam-policy juju-gce-1
```

### Gathering credential information

You are now ready to download credentials for your chosen service account.
Here we've called the download file `juju-gce-1-sa.json`:

```bash
gcloud iam service-accounts keys create juju-gce-1-sa.json \
	--iam-account=juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com
```

Store this file on the Juju client (e.g. `~/.local/share/juju/juju-gce-1-sa.json`).

The section [Using environment variables][#using-environment-variables] below
explains where this data can be stored if you wish to use the
`autoload-credentials` command to add credentials to Juju.

### Enabling the Compute Engine API

The Compute Engine API needs to be enabled for your project but this requires 
your billing account to be first linked to your project.

Your billing (credit card) should have been set up when you registered with
GCE. To see your billing account number:

```bash
gcloud alpha billing accounts list
```

Sample output:

```no-highlight
ACCOUNT_ID            NAME                OPEN  MASTER_ACCOUNT_ID
01ACD0-B3D759-187641  My Billing Account  True
```

Use the account number/ID to link your project:

```bash
gcloud alpha billing projects link juju-gce-1 --billing-account 01ACD0-B3D759-187641
```

You can now enable the Compute Engine API for your project (this can take a few
minutes to complete):

```bash
gcloud services enable compute.googleapis.com --project juju-gce-1
```

Verify by listing all currently enabled services/APIs:

```bash
gcloud services list --project juju-gce-1
```

## Adding credentials

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

In order to access Google GCE, you will need to add credentials to Juju. This
can be done in one of three ways (as shown below).

!!! Important:
    The project that gets used by Juju is determined by the service account's
    credentials used to create a controller. It is therefore recommended that
    the user-defined credential name strongly reflects the project name. This
    is chiefly relevant in a multi-project (multi-credential) scenario.

Alternately, you can use your credentials with [Juju as a Service][jaas], where
charms can be deployed using a web GUI.

### Using the interactive method

Armed with the gathered information, credentials can be added interactively:

```bash
juju add-credential google
```

The command will prompt you for information that the chosen cloud needs. An
example session follows:

```no-highlight
Enter credential name: juju-gce-1-sa

Auth Types
  jsonfile
  oauth2

Select auth type [jsonfile]: 

Enter file: ~/.local/share/juju/juju-gce-1-sa.json

Credential "juju-gce-1-sa" added locally for cloud "google".`
```

### Using a file

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential
information for any cloud. This information is then added to Juju by pointing
the `add-credential` command to the file:

```bash
juju add-credential google -f mycreds.yaml
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

Finally, on Linux systems, the file
`$HOME/.config/gcloud/application_default_credentials.json` may be used to
contain credential data and is parsed by the above command as part of the
scanning process. On Windows systems, the file is
`%APPDATA%\gcloud\application_default_credentials.json`.

Add this credential information to Juju in this way:
  
```bash
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to
store them under.

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

[jaas]: ./getting-started.md
[controllers-creating]: ./controllers-creating.md
[models]: ./models.md
[charms]: ./charms.md
[credentials]: ./credentials.md
[credentials-adding-from-file]: ./credentials.md#adding-credentials-from-a-file
[credentials-adding-from-variables]: ./credentials.md#adding-credentials-from-environment-variables
[#using-environment-variables]: #using-environment-variables
[google-cloud-sdk-docs]: https://cloud.google.com/sdk/docs/
[gcloud-commands]: https://cloud.google.com/sdk/gcloud/reference/
[gce-iam]: https://cloud.google.com/iam/docs/overview
[gce-iam-roles]: https://cloud.google.com/compute/docs/access/iam
[google-cpc]: https://console.cloud.google.com/
