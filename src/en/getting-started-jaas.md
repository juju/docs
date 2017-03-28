Title: Getting started with Juju as a Service

# Getting started with Juju as a Service

Juju as a Service (JAAS) is the fastest and easiest way to model and deploy
your cloud-based applications. When you use JAAS, Canonical manages the Juju
infrastructure. This frees you to concentrate on your software and solutions.
With JAAS you can deploy, configure, and operate your applications on the
largest public clouds: [Amazon Web Services][aws], [Google Compute Engine][gce],
and [Microsoft Azure][azure].


## Preparing your cloud credentials

We recommend that you use best practices and leverage each public cloud's
identity and access management (IAM) tool to generate a new set of credentials
exclusively for use with JAAS.  See [Cloud credentials][credentials] for more
details, along with the following links for your specific cloud.

 * [AWS][awscreds]
 * [GCE][gcecreds]
 * [Azure][azurecreds]

## Log in to JAAS

Open the [JAAS login page][jaaslogin] to begin.

Log in to JAAS using your [Ubuntu SSO account][ubuntuSSO]. This will open a
second tab in your web browser to log you in. If the tab does not open, check
and disable any pop-up blockers that may be running and try again.

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
Press the green button to get started...
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-start.png" alt="description here" />
<br />
... and reveal your (currently empty) canvas.
</td>

</tr>

</table>


## Create and deploy a model

Press the green + button on the page to start building your model.

Browse the store for the applications you need in your model. Once added to
your model you can configure, scale, and relate it to connected applications.


![juju_jaas_charms_bundles](./media/jaas-search.png)

Find a charm or bundle that you want to add to your model.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-select-bundle.png" alt="description here" />
<br />
Press the green button to add it to your model.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-changes.png" alt="description here" />
<br />
Press the blue button to deploy the changes.
</td>

</tr>

</table>

Adjust your model name and choose a public cloud to deploy to.
Enter your cloud credentials. Scroll down and click Deploy.

![juju_jaas_choose_cloud](./media/juju_jaas_choose_cloud.png)


Your model is now being deployed for you. Now you can fire up the command line
to see this model and operate against it.


## Accessing JAAS from the command line

To use JAAS from the CLI requires that you install Juju and connect to your
JAAS account.

## Install Juju

Follow [these instructions][installjuju] to install Juju on your local machine.

## Register or login to JAAS from Juju

If you are using Juju 2.1, use:

```bash
juju register jimm.jujucharms.com
```

If you are using Juju 2.2, use:

```bash
juju login jaas
```

Use `juju --version` to double check your version of Juju.


## View your models

Now that you're signed in to JAAS you can list your models running in any of the
supported clouds with:

```bash
juju models
```

To learn more about model related tasks, see [Models][models].


## Next steps

Now that you have a Juju powered model, it is time to explore the other
amazing things you can do!

We suggest you continue your journey by discovering
[how to add controllers for additional clouds][tut-cloud].



[azure]: ./help-azure.html "Using the Microsoft Azure public cloud"
[azurecreds]: ./help-azure#credentials "Help with Azure credentials"
[aws]: ./help-aws.html "Using the Amazon Web Service public cloud"
[awscreds]: ./help-aws#credentials "Help with AWS credentials"
[credentials]: ./credentials.html
[gce]: ./help-google.html "Using the Google Compute Engine public cloud"
[gcecreds]: ./help-google#download-credentials "Help with GCE credentials"
[installjuju]: ./getting-started-general.html
[jaascli]: ./jaas-cli.html "Using JAAS from the command line"
[jaaslogin]: https://jujucharms.com/login "JAAS login page"
[models]: ./models.html
[ubuntuSSO]: https://login.ubuntu.com/ "Ubuntu single sign on"
[tut-cloud]: ./tut-google.html
[users]: ./users-models.html "Users and models"


