Title: Getting started with Juju as a Service

# Getting started with Juju as a Service

Juju as a Service (JAAS) is the fastest and easiest way to model and deploy
your cloud-based applications. You can deploy Kubernetes to GCE in 10 minutes
or get OpenStack running in Azure in 15 minutes, all from your web browser.

When you use JAAS, Canonical manages the Juju infrastructure. This frees you
to concentrate on your software and solutions. With JAAS you can deploy,
configure, and operate your applications on the largest public clouds:
[Amazon Web Services][aws], [Google Compute Engine][gce], and [Microsoft Azure][azure].

All you will need is access to your public cloud credentials and an Ubuntu
Single Sign On account.

## Log in to JAAS

Open the [JAAS login page][jaaslogin] to begin.

Log in to JAAS using your [Ubuntu Single Sign On][ubuntuSSO] account.

<style>
table th, table td {
    background: #f7f7f7;
    border: 0px solid;
    padding: 15px 10px;
}
</style>

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-empty.png" alt="description here" />
<br />
Press the green Start building button to get started...
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-start.png" alt="description here" />
<br />
... and reveal your (currently empty) canvas.
</td>

</tr>

</table>


## Create and deploy a model

Press the green + button on the page to start building your [model][models].

You will be shown a list of available charms and bundles with a description of
each. Select a [charm][charms] or [bundle][bundles] to learn more about it and decide whether
to use it.

Find a charm or bundle that you want to add to your model.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-select-bundle.png" alt="description here" />
<br />
Press the green Add to model button to add it to your model.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-changes.png" alt="description here" />
<br />
Press the blue Deploy changes button to deploy the changes.
</td>

</tr>

</table>

After you press `Deploy changes` you can adjust your model name and choose a
public cloud to deploy to. When you select a cloud, you will see where to enter
your cloud credentials.

![juju_jaas_choose_cloud](./media/juju_jaas_choose_cloud.png)

## Prepare your cloud credentials

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.

See [Cloud credentials][credentials] for more information, along with the
following links for your specific cloud.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<a href="./help-aws.html#credentials">
<img src="./media/logo-aws.png" alt="AWS" />
</a>
</td>

<td align="center" valign="center" border-width="0px" >
<a href="./help-azure.html#credentials">
<img src="./media/logo-azure.png" alt="Azure" />
</a>
</td>


<td align="center" valign="center" border-width="0px">
<a href="./help-google.html#download-credentials">
<img src="./media/logo-gcp.png" alt="GCP" />
</a>
</td>
</tr>

<!-- COMMENTED OUT AS PROBABLY NOT NEEDED

<tr>
<td align="center" valign="center" border-width="0px">
Amazon Web Services
</td>
<td align="center" valign="center" border-width="0px">
Microsoft Azure
</td>
<td align="center" valign="center" border-width="0px">
Google Cloud Platform
</td>
</tr>

-->

</table>

We briefly cover retrieving and entering your GCE credentials below.

### Google Cloud Platform credentials

To get the credentials for Google Cloud Platform, first sign in to your [GCE
dashboard][gcedashboard]. We recommend creating a new project for JAAS using
the pull-down menu in the dashboard's top bar, but you could also select and
use a pre-existing project from the same menu.

Navigate to the API manager's [credentials page][gcecredentials] using the menu
in the top left of the dashboard and use the `Create credentials` drop-down
menu to select `Service account key`. Change the service account to `Compute
Engine default service account` and the 'Key type' to `JSON`, then click
`Create`. This will generate and automatically download your credentials.

Back in JAAS, enter a name for this new project, we'd recommend using the same
name as the project in GCE, and simply import your credentials by clicking on
the large `Upload Google Compute Engine .json auth-file` button. Point the
file requester at the downloaded credentials file and click the green 
`Add cloud credential` to complete the process.

Click on `Deploy` to send your application model to the cloud.

!!! Note: An enabled Compute Engine API is needed by JAAS. The API is enabled
    automatically if your GCE account has a billing method set up. See our [GCE
    documentation][gce] for further details.

## Destroy a model

When you are done and want to destroy the model you created, click on your
username at the top left of the page to list all your models.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-model-list.png" alt="description here" />
<br />
Click the model name to select the model you want to manage from the list.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-destroy-model.png" alt="description here" />
<br />
From the options that are revealed, click Destroy model.
</td>

</tr>

</table>

Log in to your cloud provider's dashboard to confirm the machines created for
your model were terminated.

## Collaborate

To share your model with another JAAS user you can share the standard Juju way,
as described in [Users and models][users], or you can share directly from the
JAAS GUI, like this.

Click the share button.

![juju_jaas_top_panel](./media/juju_jaas_share_button.png)

Enter the username and set the permissions for the new user.

![juju_jaas_share_screen](./media/juju_jaas_share_screen.png)

## Next steps

Most users find the flexibility and power of using JAAS and Juju from the CLI
rewarding. See [Using JAAS from the command line][jaascli] for more information.

[azure]: ./help-azure.html "Using the Microsoft Azure public cloud"
[aws]: ./help-aws.html "Using the Amazon Web Service public cloud"
[bundles]: ./charms-bundles.html "Introduction to bundles"
[charms]: ./charms.html "Introduction to charms"
[credentials]: ./credentials.html
[gce]: ./help-google.html "Using the Google Compute Engine public cloud"
[jaascli]: ./jaas-cli.html "Using JAAS from the command line"
[jaaslogin]: https://jujucharms.com/login "JAAS login page"
[models]: ./models.html "Introduction to Juju models"
[ubuntuSSO]: https://login.ubuntu.com/ "Ubuntu single sign on"
[users]: ./users-models.html "Users and models"
[gcedashboard]: https://console.cloud.google.com
[gcecredentials]: https://console.developers.google.com/apis/credentials
