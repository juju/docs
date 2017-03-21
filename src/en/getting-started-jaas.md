Title: Getting started with Juju as a Service

# Getting started with Juju as a Service

Juju as a Service (JAAS) is the fastest and easiest way to model and deploy
your cloud-based applications. When you use JAAS, Canonical manages the Juju
infrastructure. This frees you to concentrate on your software and solutions.
With JAAS you can deploy, configure, and operate your applications on public
clouds like [Amazon Web Services][aws], [Google Compute Engine][gce], and
[Microsoft Azure][azure].

## Create an Ubuntu single sign on account

JAAS uses [Ubuntu single sign on][ubuntuSSO] (SSO) for identity management. If you don’t
already have an Ubuntu SSO account, create one. You will provide a username
when registering which is the username that will be used by JAAS.

## Obtain cloud credentials

JAAS supports the following public clouds:
* [Amazon Web Services (AWS)][aws]
* [Google Compute Engine (GCE)][gce]
* [Microsoft Azure][azure]

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.
See [Cloud credentials][credentials] for more information. 

## Log in to JAAS

Open the [JAAS login page][jaaslogin] to begin.

Log in to JAAS using your Ubuntu SSO account. This will open a second tab in
your web browser to log you in. If the tab does not open, check and disable any
pop-up blockers that may be running and try again.

## Create and deploy a model

Press the green + button on the page to start building your model.

![juju_jaas_main](./media/juju_jaas_main.png)

You will be shown a list of available charms and bundles with a description of
each. Select a charm or bundle to learn more about it and decide whether to
use it.

![juju_jaas_charms_bundles](./media/juju_jaas_charms_bundles.png)

When you have found a charm or bundle that you want to add to your model, press
Add to model.

![juju_jaas_add_charm](./media/juju_jaas_add_charm.png)

Once all charms and bundles that you want to use are added, press Deploy Changes.

![juju_jaas_deploy](./media/juju_jaas_deploy.png)

Adjust your model name, if you desire, then choose a public cloud to deploy to.
Enter your cloud credentials. Scroll down and click Deploy.

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
[aws]: ./help-aws.html "Using the Amazon Web Service public cloud"
[gce]: ./help-google.html "Using the Google Compute Engine public cloud"
[jaascli]: ./jaas-cli.html "Using JAAS from the command line"
[jaaslogin]: https://jujucharms.com/login "JAAS login page"
[ubuntuSSO]: https://login.ubuntu.com/ "Ubuntu single sign on"
[users]: ./users-models.html "Users and models"
