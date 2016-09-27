Title: Create a Google Compute Engine controller
TODO:  Still WIP: needs refinement and further details
       Decide on a better example than Django
       Remove default model?
       Create a new model from the GUI
       Image for Juju GUI with Haproxy
       Image for GCE Dashboard with resources
       Check whether 'juju gui --with-credentials' will be a thing

# Create a Google Compute Engine controller

Juju is unrivalled in its ability to model and deploy dependable cloud
distributed applications. To prove this, we're going to use Juju to deploy one
such application - Django - with Google Compute Engine (GCE) in less than 10
minutes.  But you could just as easily use Amazon AWS or Microsoft Azure, and
just as easily deploy Kubernetes, Cassandra or even OpenStack. It's the
magic of Juju that's making it happen.

## Step 1: Installation
First, install Juju 2. If you're running Ubuntu 16.04 LTS (Xenial), this is as
simple as entering `sudo apt install juju` into the terminal. 

## Step 2: Pick a cloud
Type `juju list-clouds` and you'll output very similar to the following:

```bash
CLOUD        TYPE        REGIONS
aws          ec2         us-east-1, us-west-1, us-west-2, eu-west-1,
eu-central-1, ap-southeast-1, ap-southeast-2 ...
aws-china    ec2         cn-north-1
aws-gov      ec2         us-gov-west-1
azure        azure       centralus, eastus, eastus2, northcentralus,
southcentralus, westus, northeurope ...
azure-china  azure       chinaeast, chinanorth
cloudsigma   cloudsigma  hnl, mia, sjc, wdc, zrh
google       gce         us-east1, us-central1, europe-west1, asia-east1
joyent       joyent      eu-ams-1, us-sw-1, us-east-1, us-east-2, us-east-3,
us-west-1
rackspace    rackspace   dfw, ord, iad, lon, syd, hkg
localhost    lxd         localhost
```
As mentioned, we're going with Google's Cloud Engine (gce), which we'll
configure over the next couple of steps. But you could just as easily use
[Amazon AWS][helpaws] or [Microsoft Azure][helpazure]. 

## Step 3: Download GCE credentials

All you need to get started with Juju is a JSON-formatted credentials file for
a new Compute Engine API-enabled project. Either sign up for a free 60 day/$300
trial [Google Compute Engine trial][gcetrial], or login to your [GCE
dashboard][gcedashboard] and see [Create a Project][gcenewproject] for further
help if needed. 

## Step 4: Add credentials

Copy the credentials file somewhere sensible, such as
'~/.local/share/juju/gcejuju.json,' and initiate the import process by typing
`juju add-credential google`. You'll first be asked for an arbitrary name for
you to identify the credentials with, followed by a prompt asking for 'Auth
Type'. Press return to select the default `jsonfile*` type and then enter the
absolute path to the credentials file.

Your 'add-credential' session should look like the following:

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

## Step 5: Bootstrap Juju

Pushing Juju onto your new cloud is as simple as typing:

```bash
juju bootstrap mycloud google
```
This should only take a few minutes. You could use this time to brush up on
some [Juju terminology][jujuterms]. 

When complete, Juju will have instantiated a new controller and created a
default model with output should be similar to the following: 

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
## Step 6: Create a model

Before deploying an application, we're first going to create a new model.
Models are used by Juju group applications, resources and their relationships
into environments that can be seamlessly managed, deployed and scaled. 

For example, different models can be deployed to different regions. You can see
which regions your cloud supports with the `juju show-cloud google` command.
This show output similar to the following:

```bash
defined: public
type: gce
auth-types: [jsonfile, oauth2]
regions:
  us-east1:
    endpoint: https://www.googleapis.com
  us-central1:
    endpoint: https://www.googleapis.com
  europe-west1:
    endpoint: https://www.googleapis.com
  asia-east1:
    endpoint: https://www.googleapis.com
```

You could create a new model hosted `europe-west1` with the following command:

```bash
juju add-model gce-test europe-west1 
```

## Step 7: Deploy an application

Applications themselves are deployed either as 'charms' or as 'bundles'. Charms
are singular applications, such as [Haproxy][charmhaproxy] or
[PostgreSQL][charmpsql], whereas 'bundles' are a curated collection of charms and
their relationships. Bundles are ideal for deploying [OpenStack][bundleopenstack], for instance,
or [Kubernetes][bundlekubernetes]. 

It's also possible to [write your own charms][diycharm] and deploy locally, or
publish via the [Charm Store][charmstore].

Deploying a 'charm' is as simple as searching for your required application on
the [Charm Store][charmstore], and using the 'juju' command to grab and deploy it
automatically:

```bash
juju deploy haproxy

```
You can check of on the state of any deployment, model or controller with the
'juju status' command. If query the status directly after deploying 'haproxy',
for instance, you'll see output similar to the following:

```bash
MODEL     CONTROLLER  CLOUD/REGION         VERSION
gce-test  mycloud     google/europe-west1  2.0-rc1

APP      VERSION  STATUS   SCALE  CHARM    STORE       REV  OS      NOTES
haproxy           waiting    0/1  haproxy  jujucharms   37  ubuntu

UNIT       WORKLOAD  AGENT       MACHINE  PUBLIC-ADDRESS  PORTS  MESSAGE
haproxy/0  waiting   allocating  0                               waiting for
machine

MACHINE  STATE    DNS  INS-ID   SERIES  AZ
0        pending       pending  xenial

RELATION  PROVIDES  CONSUMES  TYPE
peer      haproxy   haproxy   peer
```

## Step 8: Use Juju's GUI

Juju includes a beautiful web interface. This allows you to perform almost all
the same functions as the CLI, only without RSI. To launch the web interface in
your default browser, type the following and use the output username and
password to connect to the GUI via your browser:

```bash
juju gui --show-credentials
```
Not only does the web interface show you the current state of your applications
and their relationships, it allows you to manage your models, resources and
machines, and deploy both charms and bundles. 

For more details on how to use Juju's web interface, take a look at [our
overview][jujugui].

## Step 9: Deploy Django from the GUI

We're now in a position to deploy Django. From the GUI, this really is as simple as
clicking on the link to the store and searching for Django. It will appear as a
bundle, which means it includes Django alongside PostgreSQL and Gunicorn. Click
on 'Add to canvas' to import the bundle into your model, click on 'Commit
changes' to review what's about to happen and finally 'Deploy'.  

Monitor the GUI as the applications are deployed to GCE and when each
application's colour changes to green, you're all set.

Congratulations - you've just modelled deployed your own scaleable cloud
application.


[helpaws]: https://jujucharms.com/docs/stable/help-aws
[helpazure]: https://jujucharms.com/docs/stable/help-azure
[gcetrial]: https://console.cloud.google.com/freetrial
[gcedashboard]: https://console.cloud.google.com
[gcenewproject]: https://jujucharms.com/docs/stable/help-google#create-a-project 
[jujuterms]: https://jujucharms.com/docs/stable/glossary
[charmhaproxy]: https://jujucharms.com/haproxy/37
[charmpsql]:https://jujucharms.com/postgresql/105
[bundleopenstack]: https://jujucharms.com/openstack-base/
[bundlekubernetes]: https://jujucharms.com/canonical-kubernetes/
[charmstore]: https://jujucharms.com/store
[diycharm]: https://jujucharms.com/docs/2.0/developer-getting-started
[jujugui]: https://jujucharms.com/docs/stable/controllers-gui
