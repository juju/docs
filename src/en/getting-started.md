Title: Getting started with Juju

# Getting started with Juju

Juju is an open source application modelling tool. With it, you can deploy,
configure, scale, and operate your software on public and private clouds. In so
doing, Juju creates machines in the cloud you've chosen to use. One such
machine, the *controller*, acts as the central management node for that cloud.

This guide will introduce you to Juju through the use of *JAAS* (Juju as a
Service). JAAS is a web application that is equipped with everything you need
to start using Juju, including a controller.

The clouds that JAAS supports are: [Amazon AWS][upstream-aws],
[Google GCE][upstream-gce], and [Microsoft Azure][upstream-azure]. You will
therefore need an account on one of these clouds in order to use JAAS. Note
that Juju itself supports many more [clouds][clouds].

The use of JAAS does not preclude the use of the command line *client* for
managing Juju. Anything you do in JAAS is transparent to the Juju client, and
vice versa, providing the same controller is being used. We'll provide insight
into this along with a crash course on client usage.

## Log in to JAAS

Ensure you have an [Ubuntu SSO account][ubuntu-sso] before contacting JAAS.

[Log in to JAAS][jaas-login] now!

## Configure a model

Applications are contained within *models* and are installed via *charms*.
Configure your model by pressing the "Start a new model" button.

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

<table width="500" border-width="0px" cellpadding="0px">
<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-login-1-2.png" alt="Logged in to JAAS" />
Press the "Start a new model" button.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-login-2-2.png" alt="New empty model" />
This new model is currently empty.
</td>

</tr>
</table>

Press the green circle in the middle of the canvas to be transported to the
[Charm Store][charm-store] where you can use the search facility (top-right) to
locate a charm or *bundle* (a collection of charms).

Notice how the Charm Store is integrated into the JAAS experience.

Here, we've decided to search for the '[kubernetes-core][charm-kc]' bundle.
This bundle is complex enough to be interesting but not overwhelming. It
involves five applications and two machines.

If you're looking for the high-octane experience, choose the
'[canonical-kubernetes][charm-cdk]' bundle.

A charm/bundle is added to your current JAAS model by pressing the "Add to
model" button.

<table width="500" border-width="0px" cellpadding="0px">
<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-store-1.png" alt="Search the Charm Store" />
Search the Charm Store.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-store-2.png" alt="Add to model" />
Add a charm/bundle by pressing "Add to model".
</td>

<table width="500" border-width="0px" cellpadding="5">

<tr>
</table>

Once a charm/bundle has been added to your model a simulated construction will
begin. At this time your chosen cloud has not yet been solicited. What we've
done so far is "primed" our desired configuration. This is particular to how
JAAS works; the Juju client operates in a more direct fashion.

Once you hit the "Deploy changes" button you will be able to name your model
and select the cloud you want to use. Here we've called the model 'k8s-core'.

<table width="500" border-width="0px" cellpadding="0px">
<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-bundle-selected.png" alt="Add a bundle" />
This bundle has been added to the model.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-select-cloud.png" alt="Name model and select cloud" />
This model has been named. A cloud is not yet selected.
</td>

</tr>
</table>

## Credentials and SSH keys

After having selected a cloud, a form will appear for submitting your
credentials to JAAS. The below resources are available if you need help with
gathering credentials:

 - [Amazon AWS credentials][clouds-aws-creds]
 - [Microsoft Azure credentials][clouds-azure-creds]
 - [Google GCE credentials][clouds-gce-creds]

!!! Positive "Pro tip":
    Generate a set of credentials dedicated to the use of JAAS.

There is also the option of adding public SSH keys to the model. This results
in every machine residing within it having those keys installed (in the
'ubuntu' user account). Once a key has been selected you must press the "Add
keys" button.

## Deploy

Click on the big "Deploy" button to confirm your cloud information, create your
model, and deploy the charm/bundle.

The complexity of the chosen charm/bundle determines the deployment time.
During this time, cloud instances are being created, software is being
installed, *relations* (the lines between the charms) are being set up, and
default configuration is being applied.

<table width="500" border-width="0px" cellpadding="0px">
<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-ssh-keys.png" alt="Specify SSH keys" />
SSH keys have been added and the model is ready to deploy.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-1-2.png" alt="Deployment initiated" />
This bundle's deployment has just been initiated.
</td>

</tr>
</table>

As the applications become operational, the colours on the canvas will reflect
the state of the charms. Amber indicates "working" and grey indicates "idle". A
successful deployment should show grey everywhere.

<table width="500" border-width="0px" cellpadding="0px">

<tr>

<td align="center" valign="center" border-width="0px" >
<img src="./media/jaas-deploy-2-2.png" alt="Bundle is still deploying" />
This bundles is still deploying.
</td>

<td align="center" valign="center" border-width="0px">
<img src="./media/jaas-deploy-3.png" alt="Bundle is deployed" />
This bundle is now deployed.
</td>

</tr>

</table>

Congratulations! You just deployed a respectable workload in the cloud without
hours of looking up configuration options or wrestling with install scripts!

## Removing charms and models

An individual charm can be removed by clicking on it and choosing the "Destroy"
button. If there is no other charm being hosted by the underlying machine then
the machine will also be destroyed.

A model can be removed by clicking on your username in the top-left area of the
window and hitting its trash bin icon. If you change your mind just click on
the model name to return to the canvas.

When a model is removed all machines and charms contained within it are also
permanently removed.

!!! Positive "Pro tip":
    Model removal is often used as a way to quickly wipe out one's work. Try to
    therefore always organise your work on a per-model basis.

You can either remove your work now, via the JAAS web UI, or do so later using
the Juju client.

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
in the output.

Example output (once authentication has taken place):

```no-highlight
Opening an authorization web page in your browser.
If it does not open, please open this URL:
https://api.jujucharms.com/identity/v1/login?waitid=3c45e5b19bbe2cfd14ad140d915b9b3c
Couldn't find a suitable web browser!
Set the BROWSER environment variable to your desired browser.
Welcome, javier-larin@external. You are now logged into "jaas".

current model set to "javier-larin@external/k8s-core".
```

To see a list of your controllers:

```bash
juju controllers --refresh
```

Output:

```no-highlight
Controller  Model     User                   Access     Cloud/Region  Models  Machines  HA  Version
jaas*       k8s-core  javier-larin@external  (unknown)                     1         3   -  2.4.7
```

There's our JAAS controller. The asterisk denotes the currently active one (in
a non-JAAS context there could be multiple controllers).

Now that we are connected to the JAAS controller our entire JAAS environment
can be managed from the client. Already we see evidence of our 'k8s-core'
model.

### Basic commands

Juju has a large number of [commands][commands] at its disposal. Here, we will
cover only the most rudimentary ones.

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

In a JAAS context you will need to add your current cloud name as an extra
argument. For AWS:

```bash
juju add-model mymodel-1 aws
```

To deploy a charm or bundle (and thus installing a similarly-named application
on one machine):

```bash
juju deploy some-charm-or-bundle
```

!!! Important:
    Unless Juju is told to do otherwise, a new charm implies a new cloud
    instance.

To scale out an application by creating two more instantiations (*units*) of
it on new machines:

```bash
juju add-unit -n 2 some-application
```

To remove an application, including all instantiations, along with its
associated machines (provided they are not hosting another application's
units):

```bash
juju remove-application some-application
```

To destroy a model, along with any associated machines and applications (here
our JAAS 'k8s-core' model) :

```bash
juju destroy-model k8s-core
```

To log out of the currently active controller:

```bash
juju logout
```

To unregister a controller from your local client (here the JAAS controller):

```bash
juju unregister jaas
```

This command is not destructive in nature. In a JAAS context in particular, it
does not affect your JAAS environment, which can still be accessed either via
the JAAS web UI or by logging in again at the command line.

## Next steps

To delve into the conceptual world of Juju we suggest visiting the following
attractions:

 - [Controllers][controllers]
 - [Models][models]
 - [Client][client]
 - [Charms][charms]
 - [Concepts and terms][concepts]

For a more practical approach we recommend the
[Using Juju locally (LXD)][tutorial-lxd] tutorial.

!!! Important:
    Ensure you have removed any work done within JAAS. If you followed all the
    steps in this guide there were two instances created in your cloud.


<!-- LINKS -->

[jaas-login]: https://jujucharms.com/login
[ubuntu-sso]: https://login.ubuntu.com/
[install]: ./reference-install.md
[charms-bundles]: ./charms-bundles.md
[charm-store]: https://jujucharms.com/store
[charm-cdk]: https://jujucharms.com/canonical-kubernetes/
[charm-kc]: https://jujucharms.com/kubernetes-core/
[tutorial-lxd]: ./tut-lxd.md
[upstream-aws]: https://aws.amazon.com
[upstream-azure]: https://azure.microsoft.com
[upstream-gce]: https://cloud.google.com
[clouds-aws-creds]: ./clouds-aws.md#gathering-credential-information
[clouds-azure-creds]: ./clouds-azure.md#adding-credentials
[clouds-gce-creds]: ./clouds-gce.md#gathering-credential-information
[controllers]: ./controllers.md
[clouds]: ./clouds.md
[models]: ./models.md
[client]: ./client.md
[charms]: ./charms.md
[concepts]: ./juju-concepts.md
[commands]: ./commands.md
