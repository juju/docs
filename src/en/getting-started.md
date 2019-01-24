Title: Getting started with Juju

# Getting started with Juju

Juju works with public clouds, private clouds, MAAS, and LXD. A central Juju
machine, the controller, processes all of the events that occur between the
Juju client and the workload machines.

The instructions on this page will show you how to get started with Juju by
using the online-hosted JAAS (Juju as a Service) controller.

A good alternative method for learning about Juju is to use it with local LXD
containers. See tutorial [Using Juju locally (LXD)][tutorial-lxd].

## JAAS

JAAS supports the following public clouds: [Amazon AWS][clouds-aws],
[Google GCE][clouds-gce], and [Microsoft Azure][clouds-azure]. An account with
one of these clouds will therefore be needed (we'll later upload the account's
credentials to JAAS).

!!! Note:
    You may want to create a separate set of cloud credentials for use with
    JAAS.

You will also need an [Ubuntu SSO account][ubuntu-sso] to authenticate with
JAAS.

### Log in to JAAS

[Log in to JAAS][jaas-login] now.

### Create a model

Applications are contained within *models* and are installed via *charms*. 

Create your first model by pressing the "Start building" button.

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
Press the green "Start building" button to get started...
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-login-2.png" alt="Login to JAAS" />
<br />
... and reveal your (currently empty) model.
</td>

</tr>

</table>

Press the green "+" symbol in the middle of the canvas to search for
applications in the [Charm Store][charm-store] to deploy.

????????

When you have selected a charm or bundle (a collection of charms) it can be
added to your model by pressing the "Add to model" button.

!!! Positive "Pro tip":
    To get a better sense of the power of Juju, and the ability of JAAS to
    reveal it, consider the [CDK][charm-cdk] Kubernetes bundle.

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-kubernetes.png" alt="Canonical kubernetes bundle" />
<br />
Press the green "Add to model" button to select the solution.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-changes.png" alt="deploying changes in JAAS" />
<br />
Press the blue "Deploy changes" button to proceed.
</td>

</tr>

</table>

After you press "Deploy changes" you can adjust your model name. You will then
need to decide which cloud you want to use.

## Adding credentials

After selecting a cloud, a form will appear for submitting your credentials to
JAAS. Choose from among the below resources if you need help in gathering
credentials for your cloud:

 - [Amazon AWS][clouds-aws-creds]
 - [Microsoft Azure][clouds-azure-creds]
 - [Google GCE][clouds-gce-creds]

## Deploy

Click on "Deploy" to confirm your cloud information and build your model (and
its applications).

Deploying takes a few minutes. During this time, cloud instances are being
created, software is being installed, *relations* are being set up between
applications, and default configuration is being applied.

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

As the applications become operational, the colours in the model view will
change to grey to indicate an idle state, and the pending notices (amber
circles) on the left will disappear to show that everything is working as
expected.

!!! Note:
    You can manage existing models through the JAAS web UI by clicking on your
    username in the top-left of the window.

## Using the command line client

Experienced Juju operators manage Juju from the command line client, and that
includes the work done via JAAS. The client is obtained by installing Juju on
your machine, where Windows, macOS, Ubuntu, and other Linux are supported. See
the [install][install] page for guidance.

### Log in to JAAS

To manage JAAS with the client, log in to the JAAS controller:

```bash
juju login jaas
```

This should direct your web browser to the [Ubuntu SSO][ubuntu-sso] site that
will authenticate your account. If this doesn't occur, just use the URL printed
in the output. Upon login, you will be asked to enter a name for the JAAS
controller (e.g. "jaas").

To see a list of all of your controllers:

```bash
juju controllers
```

With your JAAS controller being the active one ????????, you can manage JAAS,
including your possibly existing models and applications, from the command
line.

### Basic commands

?????? (links)

To list all models of the currently active controller:

```bash
juju models
```

To check the status of the currently active model:

```bash
juju status
```

To switch to a different model:

```bash
juju switch mymodel
```

To create a model in the currently active controller:

```bash
juju add-model mymodel-1
```

To deploy a charm or bundle:

```bash
juju deploy some-charm-or-bundle
```

!!! Important:
    Unless Juju is told to do otherwise, a new charm implies a new cloud
    instance.

To destroy a model, along with any associated machines and applications:

```bash
juju destroy-model mymodel-1
```

!!! Positive "Pro tip":
    Destroying a model is often used to quickly wipe out one's work. Try to
    therefore organise your work on a per-model basis.

## Log out of JAAS

To remove the local authorization that links your Ubuntu SSO account with JAAS,
use the `unregister` command with the controller name as an argument:

```bash
juju unregister myjaas
```

This command does not remove models or applications, all of which can still
be accessed either via the JAAS web UI or by registering your account again
on the command line.

## Next steps

Congratulations! You just deployed a workload in the cloud without hours of
looking up configuration options or wrestling with install scripts!

To discover more about what Juju can do for you, we suggest taking a look at
some of the following resources:

 - [Charms][charms]
 - [Models][models]
 - [Using Juju locally (LXD)][tutorial-lxd]
 - [Multi-user cloud][tutorial-users]


<!-- LINKS -->

[jaas-login]: https://jujucharms.com/login
[ubuntu-sso]: https://login.ubuntu.com/
[install]: ./reference-install.md
[models]: ./models.md
[charms]: ./charms.md
[charms-bundles]: ./charms-bundles.md
[charm-store]: https://jujucharms.com/store
[charm-cdk]: https://jujucharms.com/canonical-kubernetes/
[tutorial-lxd]: ./tut-lxd.md
[tutorial-users]: ./tut-users.md
[clouds-azure]: ./help-azure.md
[clouds-aws]: ./clouds-aws.md
[clouds-gce]: ./help-google.md
[clouds-aws-creds]: ./clouds-aws.md#credentials
[clouds-azure-creds]: ./help-azure.md#credentials
[clouds-gce-creds]: ./help-google.md#download-credentials
