Title: Getting started with Juju as a Service

# Getting started with Juju as a Service

Juju as a Service (JAAS) is the fastest and easiest way to quickly get started
modeling and deploying your cloud-based applications. When you use JAAS,
Canonical manages the Juju infrastructure. This frees you to concentrate on
your software and solutions. With JAAS you can deploy, configure, and operate
your applications on AWS, GCE, and Azure.

## Create an Ubuntu single sign on account

JAAS uses [Ubuntu single sign on][ubuntuSSO] (SSO) for identity management. If you don’t
already have an Ubuntu SSO account, create one. You will provide a username
when registering which is the username that will be used by JAAS.

## Obtain cloud credentials

In order for JAAS to deploy your workload on the cloud of your choice, you must
enter credentials for each cloud you would like to use.

We recommend that you use each public cloud's identity and access management
(IAM) tool to generate a new set of credentials exclusively for use with JAAS.
See [Cloud credentials][credentials] for more information. 

## Use JAAS from the web GUI

It is easiest to do the initial steps using the web. Open the [JAAS login page][jaaslogin]
to begin.

Log in to JAAS using your Ubuntu SSO account. This will open a second tab in
your web browser to log you in. If the tab does not open, check and disable any
pop-up blockers that may be running and try again.

Press the green + button on the page to design and deploy your model. Press
Deploy Changes when you are ready.

![juju_jaas_main](./media/juju_jaas_main.png)

The last step in the deployment requires and will request your credentials for
the public cloud you want to use, so prepare these beforehand and have them
ready.

## Use JAAS from the CLI

To use JAAS from the CLI requires a few additional steps.

### Install Juju

Follow [these instructions][installjuju] to install Juju on your local machine.

### Register or login to JAAS from Juju

If you are using Juju 2.1, add the JAAS controller with:

```bash
juju register jimm.jujucharms.com
```

If you are using Juju 2.2, use:
	
```bash
juju login JAAS
```

### View your models

If you added a model using the GUI, you can see it in the CLI, like this:

```bash
juju models
```

### Create a new model

If you have not yet entered credentials for the public cloud of your choice
into JAAS, enter one now with the `add-credential` command, which will walk
you through entering the pertinent credential data for the cloud you specify,
as in this example which uses the GCE cloud.

```bash
juju add-credential google
```

See [Cloud credentials][credentials] for more information.

To add a new model from the CLI, use:

```bash
juju add-model mygce google
```

To deploy kubernetes-core, use:

```bash
juju deploy kubernetes-core
```

View the new model in the JAAS web UI by logging in to [https://jujucharms.com][https://jujucharms.com].

## Collaborate

To share your model with another JAAS user you have two options. Share via the
web GUI or via the CLI.

### Share via the web GUI

Click the share button.

![juju_jaas_top_panel](./media/juju_jaas_share_button.png)

Enter the username and set the permissions for the new user.

![juju_jaas_share_screen](./media/juju_jaas_share_button.png)

### Share via the CLI

Change the username and cloud as appropriate and enter:

```bash
juju grant uros@external read testmodel
```

[ubuntuSSO]: https://login.ubuntu.com/ "Ubuntu single sign on"
[credentials]: ./credentials.html
[jaaslogin]: https://jujucharms.com/login "JAAS login page"
[installjuju]: ./getting-started-general.html
