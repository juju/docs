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

JAAS uses your [Ubuntu Single Sign On][ubuntuSSO] account for authentication - if you 
don't yet have an SSO account you can sign up for one here (it's easy and free). 

<style>
table th, table td {
    background: #f7f7f7;
    border: 0px solid;
    padding: 15px 10px;
}

table.logos {
    background: #f7f7f7;
    border: 0px solid;
    padding: 4px 4px;
}

table.logos th, table.logos td{
    align="center";
    valign="center";
    border: 8px;
    border-style: solid;
    border-color: #ffffff;
  }
</style>

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-login-1.png" alt="Login to JAAS" />
<br />
Press the green Start building button to get started...
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-login-2.png" alt="Login to JAAS" />
<br />
... and reveal your (currently empty) canvas.
</td>

</tr>

</table>


## Create a model

Press the green + button on the page to start building your [model][models].

You will be shown a list of available charms and bundles with a description of
each. Select a [charm][charms] or [bundle][bundles] to learn more about it.

When you have selected a charm or bundle (hint: to see how easy JAAS makes
complex deployments, try the Canonical Kubernetes bundle!) it can be added
to your model by pressing the 'Add' button...

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-kubernetes.png" alt="Canonical kubernetes bundle" />
<br />
Press the green Add to model button to add it to your model.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-changes.png" alt="deploying changes in JAAS" />
<br />
Press the blue Deploy changes button to deploy the changes.
</td>

</tr>

</table>

After you press `Deploy changes` you can adjust your model name and choose a
public cloud to deploy to. When you select a cloud, you will see where to enter
your cloud credentials.

![jaas-choose-cloud](./media/jaas-choose-cloud.png)

## Prepare your cloud credentials

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.

See [Cloud credentials][credentials] for more information, along with the
following links for your specific cloud.

<table class="logos">

<tr>

<td>
<a href="./help-aws.html#credentials">
<img src="./media/logo-aws.png" alt="AWS" />
</a>
</td>

<td>
<a href="./help-azure.html#credentials">
<img src="./media/logo-azure.png" alt="Azure" />
</a>
</td>


<td>
<a href="./help-google.html#download-credentials">
<img src="./media/logo-gcp.png" alt="GCP" />
</a>
</td>
</tr>

</table>

We briefly cover retrieving and entering your GCE credentials below.

### Google Cloud Platform credentials

To get the credentials for Google Cloud Platform, first sign in to your [GCE
dashboard][gcedashboard]. We recommend creating a new project for JAAS using
the pull-down menu in the dashboard's top bar, but you could also select and
use a pre-existing project from the same menu.

Navigate to the API manager's [credentials page][gcecredentials] using the menu
in the top left of the dashboard and use the `Create credentials` drop-down
menu to select `Service account key`. Change the service account to 
`Compute Engine default service account` and the 'Key type' to `JSON`, then click
`Create`. This will generate and automatically download your credentials.

Back in JAAS, enter a name for this new project, we'd recommend using the same
name as the project in GCE, and simply import your credentials by clicking on
the large `Upload Google Compute Engine .json auth-file` button. Point the
file requester at the downloaded credentials file and click the green 
`Add cloud credential` to complete the process.


!!! Note: An enabled Compute Engine API is needed by JAAS. The API is enabled
    automatically if your GCE account has a billing method set up. See our [GCE
    documentation][gce] for further details.


## Deploy

Click on `Deploy` to send your application model to the cloud.

Deploying may actually take a few minutes - in this period, instances are being 
created in the cloud, software is being installed, applications are being 
related to each other and configurations are being applied.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-deploy-1.png" alt="description here" />
<br />
Deploying a bundle can take a few minutes...
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-2.png" alt="description here" />
<br />
When complete, the application icons will turn grey.
</td>

</tr>

</table>



As the applications change from pending to operational, the colours in the 
model view will change to grey and the pending notices in the inspector on the 
left will disappear, to show that everything is working as expected.


    

## Collaborate

To share your model with another JAAS user you can share the standard Juju way,
as described in [Users and models][users], or you can share directly from the
JAAS GUI, like this:


<table width="500" border-width="0px" cellpadding="5">

<tr>

<td>
<img src="./media/jaas-share-1.png" alt="description here" />
<br />
Click the share button...
</td>

<td>
<img src="./media/jaas-share-2.png" alt="description here" />
<br />
Enter the username and permissions for the new user.
</td>

</tr>

</table>


    
## Destroy a model

When you are done and want to destroy the model you created, click on your
username at the top left of the page to list all your models.

Click on a model name to select a particular model for more details.

<table>
  <tr>
    <td>
      <img src="./media/jaas-destroy-1.png" alt="description here" />
      <br />
      Click on the "Destroy model" button...
    </td>
    <td>
      <img src="./media/jaas-destroy-2.png" alt="description here" />
      <br />
      You will be asked to confirm this step.
    </td>
  </tr>
</table>

Destroying a model is not instantaneous - the images are shut down and released
in a controlled way - but it shouldn't take more than a minute or two.

Log in to your cloud provider's dashboard to confirm the machines created for
your model were terminated.


## Next steps

Congratulations! you have now deployed a complex workload in the cloud without 
ever leaving your browser!

There are many ways to use JAAS solely from the web interface, but many users
are more comfortable with the command line. You should check out how to 
[install the Juju client software and use JAAS from the command line][jaascli].

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
