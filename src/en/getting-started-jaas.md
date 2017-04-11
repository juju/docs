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

This empty canvas is where you can define your [model][models], by adding and
 relating applications from the Charm Store. Press the '+' symbol in the
  middle of the canvas to start.

You will see a list of available charms and bundles with a description of
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
public cloud to deploy to. When you select a cloud, you will be guided through
 the process of entering credentials for it.

![jaas-choose-cloud](./media/jaas-choose-cloud.png)

## Prepare your cloud credentials

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.

See [Cloud credentials][credentials] for more information, along with the
following links for your specific cloud.

[Amazon Web Services](./help-aws.html#credentials)

[Microsoft Azure](./help-azure.html#credentials)

[Google Compute Engine](./help-google.html#download-credentials)

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
