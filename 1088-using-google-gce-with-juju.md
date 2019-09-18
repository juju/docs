Juju already has knowledge of the GCE cloud, which means adding your GCE account to Juju is quick and easy.

You can see more specific information on Juju's GCE support (e.g. the supported regions) by running:

``` text
juju show-cloud google
```

To ensure that Juju's information is up to date (e.g. new region support), you can update Juju's public cloud data by running:

``` text
juju update-public-clouds
```

<h2 id="heading--preparing-your-gce-account">Preparing your GCE account</h2>

Although Juju knows how GCE works, there are a few tasks you must perform in order to integrate your account with Juju. We give an overview of the steps here:

- Using the CLI tools
- Assigning user permissions
- Managing service accounts
- Gathering credential information
- Enabling the Compute Engine API

[note]
The Google [Cloud Platform Console](https://console.cloud.google.com/) (web UI) can also be used to complete the above steps.
[/note]

The instructions on this page make use of the Identity and Access Management (IAM) framework to control access to your GCP account. Read Google's [Cloud IAM](https://cloud.google.com/iam/docs/overview) page for an overview.

<h3 id="heading--using-the-cli-tools">Using the CLI tools</h3>

We show how to use the [Cloud SDK tools](https://cloud.google.com/sdk/docs/) from Google to manage your GCP (Google Cloud Platform) account. The tools installation instructions presented here are for Ubuntu/Debian. See the link above for how to install on other platforms.

Install the tools in this way:

``` text
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update && sudo apt install google-cloud-sdk
```

Now initialise the tool:

``` text
gcloud init
```

Among other things, you will be asked to enter a verification code in order to log in to GCP. This code is acquired by following a supplied hyperlink, which, in turn, will have you agree on the resulting page to allow Google Cloud SDK to access your Google account.

You will be given the choice of selecting an existing GCE project or of creating a new one. If creating, pick a unique name to prevent the command from exiting. If it does, re-invoke `gcloud init` and choose option [1] to re-initialise.

When you're done, try out the following commands (we created a project called 'juju-gce-1' during the init phase):

``` text
gcloud components list
gcloud services list
gcloud config list
gcloud projects list
gcloud projects describe juju-gce-1
```

See the [gcloud command reference](https://cloud.google.com/sdk/gcloud/reference/) for more help with this tool.

<h3 id="heading--assigning-user-permissions">Assigning user permissions</h3>

Using the IAM framework, we'll be associating credentials with our project at the *Compute Engine service account* level and not at the level of your Google user.

To download such credentials, however, your user (now known to the CLI tool) must have the authorisation to do so. This is done by assigning the role of 'Service Account Key Admin' to your user (insert your project ID and your user's email address):

``` text
gcloud projects add-iam-policy-binding juju-gce-1 \
    --member user:javierlarin72@gmail.com \
    --role roles/iam.serviceAccountKeyAdmin
```

<h3 id="heading--managing-service-accounts">Managing service accounts</h3>

A project's service accounts are listed in this way:

``` text
gcloud iam service-accounts list --project juju-gce-1
```

You can create a new service account if:

-   you are having trouble identifying an existing one to use
-   your project does not yet have any service accounts
-   you want one dedicated to Juju

Here, we will create a new one called 'juju-gce-1-sa':

``` text
gcloud iam service-accounts create juju-gce-1-sa \
    --display-name "Compute Engine Juju service account"
```

For our example project, the list of service accounts is now:

``` text
NAME                                    EMAIL
Compute Engine Juju service account     juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com
```

We must now give our chosen service account enough permissions so it can do what Juju asks of it. The roles of 'Compute Instance Admin (v1)' and 'Compute Security Admin' are sufficient:

``` text
gcloud projects add-iam-policy-binding juju-gce-1 \
    --member serviceAccount:juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com \
    --role roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding juju-gce-1 \
    --member serviceAccount:juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com \
    --role roles/compute.securityAdmin
```

Permissions can be configured in multiple ways due to the many IAM roles available. See upstream document [Compute Engine IAM Roles](https://cloud.google.com/compute/docs/access/iam) for details.

Verify the roles now assigned to both your user and your service account:

``` text
gcloud projects get-iam-policy juju-gce-1
```

<h3 id="heading--gathering-credential-information">Gathering credential information</h3>

You are now ready to download credentials for your chosen service account. Here we've called the download file `juju-gce-1-sa.json`:

``` text
gcloud iam service-accounts keys create juju-gce-1-sa.json \
    --iam-account=juju-gce-1-sa@juju-gce-1.iam.gserviceaccount.com
```

Store this file on the Juju client (e.g. `~/.local/share/juju/juju-gce-1-sa.json`).

The section [Using environment variables](#heading--using-environment-variables) below explains where this data can be stored if you wish to use the `autoload-credentials` command to add credentials to Juju.

<h3 id="heading--enabling-the-compute-engine-api">Enabling the Compute Engine API</h3>

The Compute Engine API needs to be enabled for your project but this requires your billing account to be first linked to your project.

Your billing (credit card) should have been set up when you registered with GCE. To see your billing account number:

``` text
gcloud alpha billing accounts list
```

Sample output:

``` text
ACCOUNT_ID            NAME                OPEN  MASTER_ACCOUNT_ID
01ACD0-B3D759-187641  My Billing Account  True
```

Use the account number/ID to link your project:

``` text
gcloud alpha billing projects link juju-gce-1 --billing-account 01ACD0-B3D759-187641
```

You can now enable the Compute Engine API for your project (this can take a few minutes to complete):

``` text
gcloud services enable compute.googleapis.com --project juju-gce-1
```

For some integrated Juju services (e.g. the [Charmed Distribution of Kubernetes](https://www.ubuntu.com/kubernetes)) it is useful to also enable the IAM management API:

``` text
gcloud services enable iam.googleapis.com --project juju-gce-1
```

Verify by listing all currently enabled services/APIs:

``` text
gcloud services list --project juju-gce-1
```

<h2 id="heading--adding-credentials">Adding credentials</h2>

The [Credentials](/t/credentials/1112) page offers a full treatment of credential management.

In order to access Google GCE, you will need to add credentials to Juju. This can be done in one of three ways (as shown below).

[note type="caution"]
The project that gets used by Juju is determined by the service account's credentials used to create a controller. It is therefore recommended that the user-defined credential name strongly reflects the project name. This is chiefly relevant in a multi-project (multi-credential) scenario.
[/note]

Alternately, you can use your credentials with [Juju as a Service](/t/getting-started-with-juju/1134), where charms can be deployed within a graphical environment that comes equipped with a ready-made controller.

<h3 id="heading--using-the-interactive-method">Using the interactive method</h3>

Armed with the gathered information, credentials can be added interactively:

``` text
juju add-credential google
```

The command will prompt you for information that the chosen cloud needs. An example session follows:

``` text
Enter credential name: juju-gce-1-sa

Auth Types
  jsonfile
  oauth2

Select auth type [jsonfile]: 

Enter file: ~/.local/share/juju/juju-gce-1-sa.json

Credential "juju-gce-1-sa" added locally for cloud "google".`
```

<h3 id="heading--using-a-file">Using a file</h3>

A YAML-formatted file, say `mycreds.yaml`, can be used to store credential information for any cloud. This information is then added to Juju by pointing the `add-credential` command to the file:

``` text
juju add-credential google -f mycreds.yaml
```

See section [Adding credentials from a file](/t/credentials/1112#heading--adding-credentials-from-a-file) for guidance on what such a file looks like.

<h3 id="heading--using-environment-variables">Using environment variables</h3>

With GCE you have the option of adding credentials using the following environment variable that may already be present (and set) on your client system:

`CLOUDSDK_COMPUTE_REGION`

In addition, a special variable may contain the path to a JSON-formatted file which, in turn, contains credential information:

`GOOGLE_APPLICATION_CREDENTIALS`

Finally, on Linux systems, the file `$HOME/.config/gcloud/application_default_credentials.json` may be used to contain credential data and is parsed by the above command as part of the scanning process. On Windows systems, the file is `%APPDATA%\gcloud\application_default_credentials.json`.

Add this credential information to Juju in this way:

``` text
juju autoload-credentials
```

For any found credentials you will be asked which ones to use and what name to store them under.

For background information on this method read section [Adding credentials from environment variables](/t/credentials/1112#heading--adding-credentials-from-environment-variables).

<h2 id="heading--creating-a-controller">Creating a controller</h2>

You are now ready to create a Juju controller for cloud 'google':

``` text
juju bootstrap google google-controller
```

Above, the name given to the new controller is 'google-controller'. GCE will provision an instance to run the controller on.

For a detailed explanation and examples of the `bootstrap` command see the [Creating a controller](/t/creating-a-controller/1108) page.

<h2 id="heading--next-steps">Next steps</h2>

A controller is created with two models - the 'controller' model, which should be reserved for Juju's internal operations, and a model named 'default', which can be used for deploying user workloads.

See these pages for ideas on what to do next:

- [Juju models](/t/models/1155)
- [Applications and charms](/t/applications-and-charms/1034)
