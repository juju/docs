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

## Prepare your cloud credentials

JAAS supports the following public clouds:

 * [Amazon Web Services (AWS)][aws]
 * [Google Compute Engine (GCE)][gce]
 * [Microsoft Azure][azure]

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.
See [Cloud credentials][credentials] for more information, along with the
following links for your specific cloud.

 * [AWS][awscreds]
 * [GCE][gcecreds]
 * [Azure][azurecreds]

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
Press the green "Start building" button to get started...
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


![juju_jaas_charms_bundles](./media/jaas-search.png)

Find a charm or bundle that you want to add to your model.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-select-bundle.png" alt="description here" />
<br />
Press the green "Add to model" button to add it to your model.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-changes.png" alt="description here" />
<br />
Press the blue "Deploy changes" button to deploy the changes.
</td>

</tr>

</table>

After you press "Deploy changes" you can adjust your model name and choose a
public cloud to deploy to. When you select a cloud, you will see where to enter
your cloud credentials. Enter them then scroll down and click Deploy.

![juju_jaas_choose_cloud](./media/juju_jaas_choose_cloud.png)

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
[azurecreds]: ./help-azure#credentials "Help with Azure credentials"
[aws]: ./help-aws.html "Using the Amazon Web Service public cloud"
[awscreds]: ./help-aws#credentials "Help with AWS credentials"
[bundles]: ./charms-bundles.html "Introduction to bundles"
[charms]: ./charms.html "Introduction to charms"
[credentials]: ./credentials.html
[gce]: ./help-google.html "Using the Google Compute Engine public cloud"
[gcecreds]: ./help-google#download-credentials "Help with GCE credentials"
[jaascli]: ./jaas-cli.html "Using JAAS from the command line"
[jaaslogin]: https://jujucharms.com/login "JAAS login page"
[models]: ./models.html "Introduction to Juju models"
[ubuntuSSO]: https://login.ubuntu.com/ "Ubuntu single sign on"
[users]: ./users-models.html "Users and models"


