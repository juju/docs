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

The instructions on this page make use of the Identity and Access Management
(IAM) framework to control access to your GCP account. Read Google's
[Cloud IAM][gce-iam] page for an overview.

## Preparing your GCE account

Although Juju knows how GCE works, there are a few tasks you must perform in
order to integrate your account with Juju. We give an overview of the steps
here:

 - Using the CLI tool
 - Assigning permissions
 - Gathering credential information

!!! Note:
    The Google Cloud Platform Console (web UI) can also be used to complete the
    above steps.

### Using the CLI tool

We show how to use the [Cloud SDK tools][gcloud-docs] from Google to manage
your GCP (Google Cloud Platform) account. In particular, they will allow you to
collect your GCE credentials, which can then be added to Juju.

Begin by installing the tool in this way:

```bash
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
	| sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update && sudo apt install google-cloud-sdk
```

Now initialise your GCE account:

```bash
gcloud init
```

Among other things, you will be asked to enter a verification code in order to
log in to GCP. This code is gained by following a supplied hyperlink.

You will also be given the choice of selecting an existing GCE project or of
creating a new one.

At the completion of this command a default value for your user, project,
region, and zone will be set. The following command shows the result:

```bash
gcloud config list
```

Sample output:

```no-highlight
[compute]
region = us-east1
zone = us-east1-d
[core]
account = javierlarin72@gmail.com
disable_usage_reporting = True
project = juju-gce-1225
```

Projects can be listed like this:

```bash
gcloud projects list
```

Output:

```no-highlight
PROJECT_ID     NAME      PROJECT_NUMBER
juju-gce-1225  Juju-GCE  525743174537
```

Information on a particular project can be shown in this way:

```bash
gcloud projects describe juju-gce-1225
```

Output:

```no-highlight
createTime: '2016-02-18T01:00:10.043Z'
lifecycleState: ACTIVE
name: Juju-GCE
projectId: juju-gce-1225
projectNumber: '525743174537'
```

The above outputs are what will be used in the remainder of this guide.

See these Google documents for further help:

 - [Google Cloud SDK Documentation][google-cloud-sdk-docs]
 - [gcloud command reference][gcloud-commands]

### Assigning permissions

The credentials you are looking for are not actually associated with your
user. They are instead linked to a *Compute Engine service account*.

To download such credentials the user, as known to *gcloud*, must have the
authorisation to do so. This is done by assigning the *role* of 'Service
Account Key Admin'.

To do this we need to include the project name and the user's email address:

```bash
gcloud projects add-iam-policy-binding juju-gce-1225 \
	--member user:javierlarin72@gmail.com \
	--role roles/iam.serviceAccountKeyAdmin
```

On a per-project basis, you can list IAM members (user accounts and service
accounts) and their roles with:

```bash
gcloud projects get-iam-policy juju-gce-1225
```

### Managing service accounts

Current service accounts are listed in this way:

```bash
gcloud iam service-accounts list
```

You can create a new service account if you are having trouble identifying an
existing one or if you want one dedicated to Juju. Here, we will create a new
one:

```bash
gcloud iam service-accounts create juju-gce \
	--display-name "Compute Engine Juju service account"
```

For our current example, the list of service accounts is now:

```no-highlight
NAME                                    EMAIL
App Engine default service account      blah-gce-1225@appspot.gserviceaccount.com
Compute Engine default service account  525743174537-compute@developer.gserviceaccount.com
Compute Engine Juju service account     juju-gce@juju-gce-1225.iam.gserviceaccount.com
```

We must now give our chosen GCE service account enough permissions to do what
Juju asks of it. The roles of 'Compute Instance Admin (v1)' and 
'Compute Security Admin' are sufficient. Proceed in this way:

```bash
gcloud projects add-iam-policy-binding juju-gce-1225 \
	--member serviceAccount:juju-gce@juju-gce-1225.iam.gserviceaccount.com \
	--role roles/compute.instanceAdmin.v1 \
	--role roles/compute.securityAdmin
```

IAM roles can be configured in multiple ways. See upstream document
[Compute Engine IAM Roles][gce-iam-roles] for full information.

### Gathering credential information

You are now ready to download credentials for your chosen GCE service account.
Here we've called the download file `juju-gce.json`:

```bash
gcloud iam service-accounts keys create juju-gce.json \
	--iam-account=juju-gce@juju-gce-1225.iam.gserviceaccount.com
```

Store this file in the Juju client directory (e.g.
`~/.local/share/juju/juju-gce.json`).

The section [Using environment variables][#using-environment-variables] below
explains where this data can be stored if you wish to use the
`autoload-credentials` command to add credentials to Juju.

## Adding credentials

The [Cloud credentials][credentials] page offers a full treatment of credential
management.

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
