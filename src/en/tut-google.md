Title: Creating additional controllers
TODO:  Still WIP: needs refinement and further details
       Decide on a better example than Django
       Remove default model?
       Image for GCE Dashboard with resources
       Check whether 'juju gui --with-credentials' will be a thing

# Create a Google Compute Engine controller

Juju is unrivalled in its ability to model and deploy dependable cloud
distributed applications. To prove this, we're going to use Juju to deploy one
such application - Django - with Google Compute Engine (GCE) in less than 10
minutes.  But you could just as easily use Amazon AWS or Microsoft Azure, and
just as easily deploy Kubernetes, Cassandra or even OpenStack. It's the
magic of Juju that makes it happen.

!!! Note: If you already have a controller configured, such as the LXD controller created
in the '[Getting started with Juju][first]' page, this new controller will be
seamlessly added alongside. 

## Installation
First, install Juju 2, if you have not done so already. See 
[the first use page here][first]. 

## Pick a cloud
Type `juju list-clouds` and you'll see output very similar to the following:

```bash
Cloud        Regions  Default        Type        Description
aws               11  us-east-1      ec2         Amazon Web Services
aws-china          1  cn-north-1     ec2         Amazon China
aws-gov            1  us-gov-west-1  ec2         Amazon (USA Government)
azure             18  centralus      azure       Microsoft Azure
azure-china        2  chinaeast      azure       Microsoft Azure China
cloudsigma         5  hnl            cloudsigma  CloudSigma Cloud
google             4  us-east1       gce         Google Cloud Platform
joyent             6  eu-ams-1       joyent      Joyent Cloud
rackspace          6  dfw            rackspace   Rackspace Cloud
localhost          1  localhost      lxd         LXD Container Hypervisor
```
As mentioned, we're going with Google's Cloud Engine, which we'll
configure over the next couple of steps. But you could just as easily use
[Amazon AWS][helpaws] or [Microsoft Azure][helpazure], or any of the listed
clouds you have credentials for. 

## Download GCE credentials

All you need to get started with GCE and Juju is a JSON-formatted credentials
file for a new Compute Engine API-enabled project. Either sign up for a [free
60 day/$300 trial][gcetrial], or connect to your [GCE dashboard][gcedashboard].
If needed, see our GCE [Create a Project][gcenewproject] documentation for
further help. 

## Add credentials

Copy the credentials file somewhere sensible, such as
'~/.local/share/juju/gcejuju.json,' and initiate the import process by typing
`juju add-credential google`. You'll first be asked for an arbitrary name 
to identify the credentials with, followed by a prompt asking for 'Auth
Type'. Press return to select the default `jsonfile*` type and then enter the
absolute path to the credentials file:

```bash
Enter credential name: juju-demo
Auth Types
jsonfile*
oauth2

Select auth-type:
Enter file: /home/graham/.local/share/juju/gcejuju.json
Credentials added for cloud google.
```
You can now start using Juju with your GCE cloud.

## Bootstrap Juju

Pushing Juju onto your new cloud is as simple as typing:

```bash
juju bootstrap google mycloud
```
This should only take a few minutes. You could use this time to brush up on
some [Juju terminology][jujuterms]. 

When complete, Juju will have instantiated a new controller and created a
default model with output similar to the following: 

```bash
Creating Juju controller "mycloud" on google/us-east1
Looking for packaged Juju agent version 2.0-rc1 for amd64
Launching controller instance(s) on google/us-east1...
 - juju-a3d331-0
Fetching Juju GUI 2.1.10
Waiting for address
Attempting to connect to 104.196.179.170:22
Attempting to connect to 10.142.0.2:22
Logging to /var/log/cloud-init-output.log on the bootstrap machine
Running apt-get update
Running apt-get upgrade
Installing curl, cpu-checker, bridge-utils, cloud-utils, tmux
Fetching Juju agent version 2.0-rc1 for amd64
Installing Juju machine agent
Starting Juju machine agent (service jujud-machine-0)
Bootstrap agent now started
Contacting Juju controller at 10.142.0.2 to verify accessibility...
Bootstrap complete, "mycloud" controller now available.
Controller machines are in the "controller" model.
Initial model "default" added.
```
## Create a model

Before deploying an application, we're going to first create a new model.
Models are used by Juju to group applications, resources and their relationships
into environments that can be seamlessly managed, deployed and scaled. 

For example, different models can be deployed to different regions. You can see
which regions your cloud supports with the `juju show-cloud google` command,
and create a new model hosted on `europe-west1` with the following:

```bash
juju add-model gce-test europe-west1 
```

## Deploy an application

Applications themselves are deployed either as 'charms' or as 'bundles'. Charms
are singular applications, such as [Haproxy][charmhaproxy] or
[PostgreSQL][charmpsql], whereas bundles are a curated collection of charms and
their relationships. Bundles are ideal for deploying [OpenStack][bundleopenstack], for instance,
or [Kubernetes][bundlekubernetes]. 

It's also possible to [write your own charms][diycharm] and deploy locally, or
publish via the [Charm Store][charmstore].

Deploying a charm is as simple as searching for your required application on
the [Charm Store][charmstore], and using the 'juju' command to grab and deploy it
automatically:

```bash
juju deploy haproxy
```
You can check on the state of any deployment, model or controller with the
'juju status' command. If you query the status directly after deploying
'haproxy', for instance, you'll something similar to this:

```bash
Model     Controller  Cloud/Region         Version
gce-test  usertest    google/europe-west1  2.0-rc3

App      Version  Status   Scale  Charm    Store       Rev  OS      Notes
haproxy           waiting    0/1  haproxy  jujucharms   37  ubuntu

Unit       Workload  Agent       Machine  Public address  Ports  Message
haproxy/0  waiting   allocating  0                               waiting for machine

Machine  State    DNS  Inst id  Series  AZ
0        pending       pending  xenial

Relation  Provides  Consumes  Type
peer      haproxy   haproxy   peer
```

## Use Juju's GUI

Juju includes a beautiful web interface. This allows you to perform almost all
the same functions as the CLI, only without RSI. To launch the web interface in
your default browser, type the following:

```bash
juju gui --show-credentials
```
Then use the output username and password to connect to the GUI via your browser:

![Juju GUI login](media/tut-gce-gui_login.png)


After logging in, you'll see the Juju GUI overview for the current model. Not
only does the web interface show you the current state of your applications and
their relationships, it allows you to manage your models, resources and
machines, and deploy both charms and bundles. 

For example, you can use the GUI to switch between the two models currently
running on your controller - the default one we left empty and the new one we
created for Haproxy. Look for the drop-down menu to the right of the user
profile (which currently says 'admin@local'). In this drop-down list you should
find both 'default' and 'gce-test' models, and selecting one will switch the
current model.

![Juju GUI model switching menu](media/tut-gce-gui_model.png)

To create a new model from the GUI, click on 'Manage' from the drop-down model
list. This will open a more detailed list of the current models. A new model
can now be created by clicking on the 'New' button at the top of the list,
entering a name for the new model, and clicking submit. Click on 'Manage' for
this model to return to the main view.

For more details on how to use Juju's web interface, take a look at [our
overview][jujugui].

## Deploy Django from the GUI

With the blank canvas of a new model created, we're now in a position to deploy
Django.

From the GUI, this really is as simple as clicking on the link to the store and
searching for Django. It will appear as a bundle, which means it includes
Django alongside PostgreSQL and Gunicorn. Click on 'Add to canvas' to import
the bundle into your model, click on 'Commit changes' to review what's about to
happen and finally 'Deploy'.  

Monitor the GUI as the applications are deployed to GCE and when each
application's colour changes to green, you're all set.

Congratulations - you've just modelled and deployed your own scalable cloud
application.

![Juju GUI model of Django bundle](media/tut-gce-gui_django.png)

## Next Steps

Now you can see how Juju makes it easy to model workloads, you are sure
to want to share. Find out how easy it is to 
[add users to your Juju controllers and models][tutuser].

[first]: ./getting-started.html
[helpaws]: ./help-aws.html
[helpazure]: ./help-azure.html
[gcetrial]: https://console.cloud.google.com/freetrial
[gcedashboard]: https://console.cloud.google.com
[gcenewproject]: ./help-google.html#create-a-project 
[jujuterms]: ./glossary.html
[charmhaproxy]: https://jujucharms.com/haproxy/37
[charmpsql]: https://jujucharms.com/postgresql/105
[bundleopenstack]: https://jujucharms.com/openstack-base/
[bundlekubernetes]: https://jujucharms.com/canonical-kubernetes/
[charmstore]: https://jujucharms.com/store
[diycharm]: ./developer-getting-started.html
[jujugui]: ./controllers-gui.html
[tutuser]: ./tut-users.html
