Juju is an open source application modelling tool. With it, you can deploy, configure, scale, and operate your software on public and private clouds. In so doing, Juju creates machines in the cloud you've chosen to use. One such machine, the *controller*, acts as the central management node for that cloud.

This guide will introduce you to Juju through the use of *JAAS* (Juju as a Service). JAAS is a web application that is equipped with everything you need to start using Juju, including a controller.

The clouds that JAAS supports are: [Amazon AWS](https://aws.amazon.com), [Google GCE](https://cloud.google.com), and [Microsoft Azure](https://azure.microsoft.com). You will therefore need an account on one of these clouds in order to use JAAS. Note that Juju itself supports many more [clouds](/t/clouds/1100).

The use of JAAS does not preclude the use of the command line *client* for managing Juju. Anything you do in JAAS is transparent to the Juju client, and vice versa, providing the same controller is being used. We'll provide insight into this along with a crash course on client usage.

<h2 id="heading--log-in-to-jaas">Log in to JAAS</h2>

Ensure you have an [Ubuntu SSO account](https://login.ubuntu.com/) before contacting JAAS.

[Log in to JAAS](https://jujucharms.com/login) now!

<h2 id="heading--configure-a-model">Configure a model</h2>

Applications are contained within *models* and are installed via *charms*. Configure your model by pressing the "Start a new model" button.

Logged in to JAAS             |  New empty model
:-------------------------|:-------------------------
![ ][jaas-login-1-2-reduced] | ![ ][jaas-login-2-2-reduced]

[jaas-login-1-2-reduced]: /uploads/default/original/1X/243d6ba66f58b186e73e7686a3a91007e6568565.png "Logged in to JAAS"
[jaas-login-2-2-reduced]: /uploads/default/original/1X/a7fc410be70ded4bf618425460556259c41ef1ce.png "New empty model"

Press the green circle in the middle of the canvas to be transported to the [Charm Store](https://jujucharms.com/store) where you can use the search facility (top-right) to locate a charm or *bundle* (a collection of charms).

Notice how the Charm Store is integrated into the JAAS experience.

Here, we've decided to search for the '[kubernetes-core](https://jujucharms.com/kubernetes-core/)' bundle. This bundle is complex enough to be interesting but not overwhelming. It involves five applications and two machines.

If you're looking for the high-octane experience, choose the '[canonical-kubernetes](https://jujucharms.com/canonical-kubernetes/)' bundle.

A charm/bundle is added to your current JAAS model by pressing the "Add to model" button.

Search the Charm Store             |  Add to model
:-------------------------|:-------------------------
![ ][jaas-store-1-reduced] | ![ ][jaas-store-2-reduced]

[jaas-store-1-reduced]: /uploads/default/original/1X/143daa0f27a964a129e8303eb571ee6891176fc5.png "Search the Charm Store"
[jaas-store-2-reduced]: /uploads/default/original/1X/0ec041ef3c24c21dffd6dd1c7f636447c458e668.png "Add to model"

Once a charm/bundle has been added to your model a simulated construction will begin. At this time your chosen cloud has not yet been solicited. What we've done so far is "primed" our desired configuration. This is particular to how JAAS works; the Juju client operates in a more direct fashion.

Once you hit the "Deploy changes" button you will be able to name your model and select the cloud you want to use. Here we've called the model 'k8s-core'.

Add a bundle             |  Name model and select cloud
:-------------------------|:-------------------------
![ ][jaas-bundle-selected-reduced] | ![ ][jaas-select-cloud-reduced]

[jaas-bundle-selected-reduced]: /uploads/default/original/1X/e76873a6cde1148482f542ba2755208e0420819a.png "Add a bundle"
[jaas-select-cloud-reduced]: /uploads/default/original/1X/4b559ac62362d42a6ee4209c767e710566886c51.png "Name model and select cloud"

<h2 id="heading--credentials-and-ssh-keys">Credentials and SSH keys</h2>

After having selected a cloud, a form will appear for submitting your credentials to JAAS. The below resources are available if you need help with gathering credentials:

-   [Amazon AWS credentials](/t/using-amazon-aws-with-juju/1084#heading--gathering-credential-information)
-   [Microsoft Azure credentials](/t/using-microsoft-azure-with-juju/1086#heading--adding-credentials)
-   [Google GCE credentials](/t/using-google-gce-with-juju/1088#heading--gathering-credential-information)

[note type="positive" status="Pro tip"]
Generate a set of credentials dedicated to the use of JAAS.
[/note]

There is also the option of adding public SSH keys to the model. This results in every machine residing within it having those keys installed (in the 'ubuntu' user account). Once a key has been selected you must press the "Add keys" button.

<h2 id="heading--deploy">Deploy</h2>

Click on the big "Deploy" button to confirm your cloud information, create your model, and deploy the charm/bundle.

The complexity of the chosen charm/bundle determines the deployment time. During this time, cloud instances are being created, software is being installed, *relations* (the lines between the charms) are being set up, and default configuration is being applied.

Specify SSH keys            |  Deployment initiated
:-------------------------|:-------------------------
![ ][jaas-ssh-keys-reduced] | ![ ][jaas-deploy-1-2-reduced]

[jaas-ssh-keys-reduced]: /uploads/default/original/1X/a9da5da141ee54e9d3fc7ac180da40e112db9818.png "Specify SSH keys"
[jaas-deploy-1-2-reduced]: /uploads/default/original/1X/8f653d571129267f5770160233881d05d76fb063.png "Deployment initiated"

As the applications become operational, the colours on the canvas will reflect the state of the charms. Amber indicates "working" and grey indicates "idle". A successful deployment should show grey everywhere.

Bundle is still deploying            |  Bundle is deployed
:-------------------------|:-------------------------
![ ][jaas-deploy-2-2-reduced] | ![ ][jaas-deploy-3-reduced]

[jaas-deploy-2-2-reduced]: /uploads/default/original/1X/a1f30a7ad554389fd0d82ff1b47711dfdfc32585.png "Bundle is still deploying"
[jaas-deploy-3-reduced]: /uploads/default/original/1X/a9ec2445776596a3fab2347c5c444652813ac2d4.png "Bundle is deployed"

Congratulations! You just deployed a respectable workload in the cloud without hours of looking up configuration options or wrestling with install scripts!

<h2 id="heading--removing-charms-and-models">Removing charms and models</h2>

An individual charm can be removed by clicking on it and choosing the "Destroy" button. If there is no other charm being hosted by the underlying machine then the machine will also be destroyed.

A model can be removed by clicking on your username in the top-left area of the window and hitting its trash bin icon. If you change your mind just click on the model name to return to the canvas.

When a model is removed all machines and charms contained within it are also permanently removed.

[note type="positive" status="Pro tip"]
Model removal is often used as a way to quickly wipe out one's work. Try to therefore always organise your work on a per-model basis.
[/note]

You can either remove your work now, via the JAAS web UI, or do so later using the Juju client.

<h2 id="heading--using-the-command-line-client">Using the command line client</h2>

Experienced Juju administrator manage Juju from the command line client, and that includes the work done via JAAS. The client is obtained by installing Juju on your machine, where Windows, macOS, Ubuntu, and other Linux are supported. See the [install](/t/installing-juju/1164) page for guidance.

<h3 id="heading--log-in-to-jaas">Log in to JAAS</h3>

To manage JAAS with the client, log in to the JAAS controller:

``` text
juju login jaas
```

This should direct your web browser to the [Ubuntu SSO](https://login.ubuntu.com/) site that will authenticate your account. If this doesn't occur, just use the URL printed in the output.

Example output (once authentication has taken place):

``` text
Opening an authorization web page in your browser.
If it does not open, please open this URL:
https://api.jujucharms.com/identity/v1/login?waitid=3c45e5b19bbe2cfd14ad140d915b9b3c
Couldn't find a suitable web browser!
Set the BROWSER environment variable to your desired browser.
Welcome, javier-larin@external. You are now logged into "jaas".

current model set to "javier-larin@external/k8s-core".
```

To see a list of your controllers:

``` text
juju controllers --refresh
```

Output:

``` text
Controller  Model     User                   Access     Cloud/Region  Models  Machines  HA  Version
jaas*       k8s-core  javier-larin@external  (unknown)                     1         3   -  2.4.7
```

There's our JAAS controller. The asterisk denotes the currently active one (in a non-JAAS context there could be multiple controllers).

Now that we are connected to the JAAS controller our entire JAAS environment can be managed from the client. Already we see evidence of our 'k8s-core' model.

<h3 id="heading--basic-commands">Basic commands</h3>

Juju has a large number of [commands](./commands.md) at its disposal. Here, we will cover only the most rudimentary ones.

To list all models of the currently active controller:

``` text
juju models
```

To check the status of the currently active model:

``` text
juju status
```

To switch to a different model:

``` text
juju switch mymodel
```

To create a model in the currently active controller:

``` text
juju add-model mymodel-1
```

In a JAAS context you will need to add your current cloud name as an extra argument. For AWS:

``` text
juju add-model mymodel-1 aws
```

To deploy a charm or bundle (and thus installing a similarly-named application on one machine):

``` text
juju deploy some-charm-or-bundle
```

[note type="caution"]
Unless Juju is told to do otherwise, a new charm implies a new cloud instance.
[/note]

To scale out an application by creating two more instantiations (*units*) of it on new machines:

``` text
juju add-unit -n 2 some-application
```

To remove an application, including all units, along with associated machines (provided they are not hosting another application's units).

``` text
juju remove-application some-application
```

To destroy a model, along with any associated machines and applications (here our JAAS 'k8s-core' model) :

``` text
juju destroy-model k8s-core
```

To log out of the currently active controller:

``` text
juju logout
```

To unregister a controller from your local client (here the JAAS controller):

``` text
juju unregister jaas
```

This command is not destructive in nature. In a JAAS context in particular, it does not affect your JAAS environment, which can still be accessed either via the JAAS web UI or by logging in again at the command line.

<h2 id="heading--next-steps">Next steps</h2>

For a more in-depth look at client commands we recommend the [Basic client usage](/t/basic-client-usage-tutorial/1191) tutorial.

[note type="caution"]
Ensure you have removed any work done within JAAS. If you followed all the steps in this guide there were two instances created in your cloud.
[/note]

<!-- LINKS -->
