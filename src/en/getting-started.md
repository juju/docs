Title: Getting started with Juju

# Getting started with Juju

Juju works across public clouds, private clouds, and locally with LXD based
deployment and operating of applications. Juju works through a controller that
will process all of the events that occur. These instructions will walk you
through using the hosted Juju as a Service (JAAS) controller and requires you
to have public cloud credentials ready. If you'd prefer to test it out
locally, see our [Getting started with Juju and LXD][tut-lxd].


JAAS supports deploying, configuring, and operating your applications on the
largest public clouds: [Amazon Web Services][aws], [Google Compute
Engine][gce], and [Microsoft Azure][azure].

All you will need is access to your public cloud credentials and an Ubuntu
Single Sign On (SSO) account.

## Log in to JAAS

Open the [JAAS login page][jaaslogin] to begin.

JAAS uses your [Ubuntu SSO][ubuntuSSO] account for authentication - if you
don't yet have an SSO account you can sign up for one [here][ubuntuSSO] (it's
easy and free).

## Create a Model

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
... and reveal your (currently empty) model.
</td>

</tr>

</table>


You build your [model][models] by adding and relating applications from the
Charm Store. Press the green '+' symbol in the middle of the UI to start
finding applications in the Charm Store.

You will see a list of available charms and bundles with a description of
each. Select a [charm][charms] or [bundle][bundles] to learn more about it.

When you have selected a charm or bundle it can be added to your model by
pressing the 'Add to model' button...

Hint: see how easy JAAS makes complex deployments, try the [Canonical
Kubernetes bundle][k8]

<table width="500" border-width="0px" cellpadding="5">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-kubernetes.png" alt="Canonical kubernetes bundle" />
<br />
Press the green Add to model button to select the solution.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-changes.png" alt="deploying changes in JAAS" />
<br />
Press the blue Deploy changes button to proceed with the changes you've made
with your model.
</td>

</tr>

</table>

After you press `Deploy changes` you can adjust your model name and choose a
cloud. When you select a cloud, you will be guided through
the process of entering credentials for it.

## Prepare your cloud credentials

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.

See [Cloud credentials][credentials] for more information, along with the
following links for your specific cloud.

[Amazon Web Services][aws-creds] [Microsoft Azure][azure-creds] [Google Compute Engine][gce-creds]

## Deploy

Click on `Deploy` to confirm your cloud information and build your model.

Deploying takes a few minutes - in this period, instances are being
created in the cloud, software is being installed, applications are being
related to each other and configuration is being applied.

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
change to grey to indicate an idle state and the pending notices in the
inspector on the left will disappear, to show that everything is working as
expected.

!!! Tip: You can check and manage existing models through the JAAS GUI by
clicking on your username

## Use the command line

Juju can also be used from the command line. Models you've created with the
JAAS website can also able to be operated via the normal Juju command line. In
order to use the command line, you will first need to install the Juju client
software on your machine.

Juju is available for various types of Linux, macOS, and Windows.
Click on the sections below for the relevant instructions or visit the
[install instructions][install] for a thorough run down of your options.

Get started quickly by picking your OS from below:

<style>
details  {
    padding-bottom: 6px;
}
</style>

^# On an OS which supports snap packages

   For Ubuntu 16.04 LTS (Xenial) and other OSes which have snaps enabled
   ([see the snapcraft.io site][snapcraft]) you can install the latest
   stable release of Juju with the command:

         sudo snap install juju --classic

   You can check which version of Juju you have installed with:

         sudo snap list juju

   And update it if necessary with:

         sudo snap refresh juju

   It is possible to install other versions, including beta releases of
   Juju via a snap package. See the [install][install] for more information.


^# From the Ubuntu PPA

   A PPA resource is available containing the latest stable version of
   Juju. To install:

       sudo add-apt-repository ppa:juju/stable
       sudo apt update
       sudo apt install juju

^# For Windows

   A Windows installer is available for Juju.

   [juju-setup-2.1.2.exe](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe)([md5](https://launchpad.net/juju/2.1/2.1.2/+download/juju-setup-2.1.2.exe/+md5))

   Please see the [install docs][install] for other
   versions.

^# For macOS

   The easiest way to install Juju on macOS is with the brew package
   manager. With brew installed, simply enter the following into a
   terminal:

       brew install juju

   If you previously installed Juju with brew, the package can be
   updated with the following:

       brew upgrade juju

   For alternative installation methods, see the [install docs][install].

^# For CentOS

   A pre-compiled binary is available for CentOS.

   Please see the [install docs][install] for a link to the latest
   version.


## Register or login to JAAS

To connect to JAAS from the command line you'll need to login to the JAAS
controller. Enter the following command:

```bash
juju register jimm.jujucharms.com
```

This command will open a new window in your default web browser and use
[Ubuntu SSO][ubuntusso] to authorise your account. If the browser doesn't open,
you can manually copy and paste the unique authorisation URL from the command
output.

After successful authentication, you will be asked to enter a descriptive name
for the JAAS controller (we suggest JAAS). Now you can operate your models or
applications in JAAS from the command line. You can see a list of all of your
controllers using the command line command:


```bash
juju controllers
```


## View your models

You view the list of your models on the controller with the command:

```bash
juju models
```

You can switch focus between your models at any time.

```bash
juju switch mymodel
```

## Remove models

The model you created earlier is running in your selected cloud. If you want
to permanently remove it, you can use the JAAS GUI, or run the command:

```bash
juju destroy-model mymodel
```

This process may take a few minutes to complete, as Juju releases
the running resources back to the cloud.

## Next steps

Congratulations! You have now deployed a complex workload in the cloud without
hours of looking up config options or wrestling with install scripts!

To discover more about what Juju can do for you, we suggest some of the
following pages of documentation:

 - [Creating your own cloud controller][tut-google]
 - [Creating models locally with LXD][tut-lxd]
 - [Share your model with other users][share]
 - [Learn more about charms and bundles][learn]
 - [Find out how to customise and manage models][customise]

[azure]: ./help-azure.html "Using the Microsoft Azure public cloud"
[aws]: ./help-aws.html "Using the Amazon Web Service public cloud"
[bundles]: ./charms-bundles.html "Introduction to bundles"
[k8]: https://jujucharms.com/canonical-kubernetes/
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
[install]: ./reference-install.html
[tut-lxd]: ./tut-lxd.html
[tut-google]: ./tut-google.html
[share]: ./tut-users.html
[learn]: ./charms.html
[customise]: ./models.html
[snapcraft]: https://snapcraft.io
[aws-creds]: ./help-aws.html#credentials
[azure-creds]: ./help-azure.html#credentials
[gce-creds]: ./help-google.html#download-credentials
