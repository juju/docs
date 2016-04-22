# Juju 2.0-beta5

A new development release of Juju, juju 2.0-beta5, is now available.
This release replaces version 2.0-beta4.


## Getting Juju

Juju 2.0-beta5 is available for Xenial and backported to earlier
series in the following PPA:

    https://launchpad.net/~juju/+archive/devel

Windows, Centos, and OS X users will find installers at:

    https://launchpad.net/juju-core/+milestone/2.0-beta5

Upgrading environments to 2.0-beta5 is not supported.


## Getting started with Juju 2.0

Juju 2.0 allows you to get started creating models without modifying any
definition files.  Just provide your credentials and go!  (*Note: to
fully understand the new bootstrap experience please see the "New
Bootstrap and Cloud Management Experience" section below)

* LXD provider (requires lxd 2.0.0~rc9 or later):
  The LXD provider requires no credentials, so you can create a
  controller by just specifying its name:

    juju bootstrap <controller name> lxd

Note that the lxdbr0 bridge needs to be properly configured for the lxd
provider to work, for details see: 
http://insights.ubuntu.com/2016/04/07/lxd-networking-lxdbr0-explained/

* Public Clouds:
  Known public clouds can be listed with juju list-clouds:

        juju list-clouds

        CLOUD              TYPE        REGIONS
        aws                ec2         us-east-1, us-west-1, us-west-2, ...
        aws-china          ec2         cn-north-1
        aws-gov            ec2         us-gov-west-1
        azure              azure       japanwest, centralindia, eastus2, ...
        azure-china        azure       chinaeast, chinanorth
        cloudsigma         cloudsigma  mia, sjc, wdc, zrh, hnl
        google             gce         us-east1, us-central1, ...
        joyent             joyent      us-east-1, us-east-2, us-east-3, …
        lxd                lxd
        maas               maas
        manual             manual
        rackspace          rackspace   lon, syd, hkg, dfw, ord, iad

Add your credentials using either:

    juju add-credential <cloud>
or
    juju add-credential <cloud> -f creds.yaml
or
    juju autoload-credentials

When specifying just the cloud, juju add-credential will allow a new
credential to be added interactively. You will be prompted type the
required credential attributes. Example:

juju add-credential maas
  credential name: hmaas
  replace existing credential? [y/N]: y
  auth-type: oauth1
  maas-oauth: 
credentials added for cloud maas

The new credentials.yaml file at: ~/.local/share/juju/credentials.yaml

The autoload tool will search for existing credentials for AWS,
OpenStack/Rackspace, and Google clouds. You will then be prompted for
which ones you'd like to save.

If you have an existing credential.yaml file, you can also import a
named credential, eg for MAAS

    cat credentials.yaml

      credentials:
         maas:
           my-credentials:
             auth-type: oauth1
             maas-oauth: <mass-oauth-key>

or, for AWS

    cat credentials.yaml

      credentials:
        aws:
          default-credential: my-credentials
          my-credentials:
            auth-type: access-key
            access-key: <key>
            secret-key: <secret>

Bootstrap using your default credentials:

     juju bootstrap <controller name> <cloud>[/region]

Examples:

     juju bootstrap aws-controller aws

     juju bootstrap mass-controller maas/192.168.0.1

In the MAAS example above, you specify the host address of the MAAS
controller. So to use Juju on MAAS out of the box, you set up a
credentials file (either interactively, or based on the example above)
and then bootstrap. This avoids the need for any cloud configuration.
But it's also possible to set up a named MAAS cloud definition as
explained later.

More details on the new bootstrap experience, including defining private
clouds can be found in the New Bootstrap and Cloud Management Experience
section.


## What's New in Beta5

* Support for local charm repositories removed.
  * All local charms must now be deployed using the path to the charm
    instead of a local URL.
  * Bundles support specifying local charms using the path to the charm.

* Notable Bug Fixes:
  * GridFS namespace breaks charm and tools deduping across models
    Lp 1569054
  * Unable to download local: charm due to hash mismatch in
    multi-model deployment
    Lp 1541482
  * Destroyed models still show up in list-models
    Lp 1534627


## Notable Changes

* Terminology
* Command Name Changes
* New Juju Home Directory
* Multi-Model Support Active by Default
* New Bootstrap and Cloud Management Experience
* Native Support for Charm Bundles
* Multi Series Charms
* Improved Local Charm Deployment
* Mongo 3.2 Support
* LXC Local Provider No Longer Available
* LXD Provider
* LXD Containers
* Microsoft Azure Resource Manager Provider
* Bootstrap Constraints, Series
* Juju Logging Improvements
* Unit Agent Improvements
* API Login with Macaroons
* MAAS Spaces
* Resources
* Juju Status Improvements
* Relation Get and Set Compatibility
* Support for new AWS M4 Instance Types
* Support for win10 and win2016
* Juju Now Respects CharmStore Channels
* Known Issues


### Terminology

In Juju 2.0, environments will now be referred to as "models".  Commands
which referenced "environments" will now reference "models".  Example:

    juju destroy-environment

will become

    juju destroy-model


The "state-server" from Juju 1.x becomes a "controller" in 2.0.


### Command Name Changes

After a while experimenting with nested command structures, the decision
was made to go back to a flat command namespace as the nested commands
always felt clumsy and awkward when being used even though they seemed
like a good idea.

So, we have the following changes:

    1.25 command                          2.0-beta2 command

    juju environment destroy              juju destroy-model * ***
    juju environment get                  juju get-model-config ***
    juju environment get-constraints      juju get-model-constraints **
    juju environment retry-provisioning   juju retry-provisioning
    juju environment set                  juju set-model-config ***
    juju environment set-constraints      juju set-model-constraints **
    juju environment share                juju share-model ***
    juju environment unset                juju unset-model ** ***
    juju environment unshare              juju unshare-model ***
    juju environment users                juju list-shares
    juju user add                         juju add-user
    juju user change-password             juju change-user-password
    juju user credentials                 juju get-user-credentials
    juju user disable                     juju disable-user
    juju user enable                      juju enable-user
    juju user info                        juju show-user
    juju user list                        juju list-users
    juju machine add                      juju add-machine **
    juju machine remove                   juju remove-machine **
    <new in 2.0>                          juju list-machines
    <new in 2.0>                          juju show-machines
    juju authorised-keys add              juju add-ssh-key
    juju authorised-keys list             juju list-ssh-keys
    juju authorised-keys delete           juju remove-ssh-key
    juju authorised-keys import           juju import-ssh-key
    juju get                              juju get-config
    juju set                              juju set-config
    juju get-constraints                  juju get-model-constraints
    juju set-constraints                  juju set-model-constraints
    juju get-constraints <service>        juju get-constraints
    juju set-constraints <service>        juju set-constraints
    juju backups create                   juju create-backup ***
    juju backups restore                  juju restore-backup ***
    juju action do                        juju run-action ***
    juju action defined                   juju list-actions ***
    juju action fetch                     juju show-action-output ***
    juju action status                    juju show-action-status ***
    juju storage list                     juju list-storage ***
    juju storage show                     juju show-storage ***
    juju storage add                      juju add-storage ***
    juju space create                     juju add-space ***
    juju space list                       juju list-spaces ***
    juju subnet add                       juju add-subnet ***
    juju ensure-availability              juju enable-ha ***

    * the behaviour of destroy-environment/destroy-model has changed, see
      the section on controllers below
    ** these commands existed at the top level before but become the
       recommended approach again.
    *** alias, but primary name going forward.

And for the extra commands previously under the "jes" feature flag but
are now available out of the box:

    juju system create-environment         juju create-model
    juju system destroy                    juju destroy-controller
    juju system environments               juju list-models
    juju system kill                       juju kill-controller
    juju system list                       juju list-controllers
    juju system list-blocks                juju list-all-blocks
    juju system login                      juju login
    juju system remove-blocks              juju remove-all-blocks
    juju system use-environment            juju use-model

Fundamentally, listing things should start with 'list-', and looking at
an individual thing should start with 'show-'. 'remove' is generally
used for things that can be easily added back, whereas 'destroy' is used
when it is not so easy to add back.


### New Juju Home Directory

The directory where Juju stores its working data has changed. We now
follow the XDG directory specification. By default, the Juju data
(formerly home) directory is located at ~/.local/share/juju. This may be
overridden by setting the JUJU_DATA environment variable.

Juju 2.0's data is not compatible with Juju 1.x.
Do not set `JUJU_DATA` to the old `JUJU_HOME` (~/.juju).


### Multi-Model Support Active by Default

The multiple model support that was previously behind the "jes"
developer feature flag is now enabled by default. Along with the
enabling:

A new concept has been introduced, that of a "controller".

A Juju Controller, also sometimes called the "controller model",
describes the model that runs and manages the Juju API servers and the
underlying database.

The controller model is what is created when the bootstrap command is
used. This controller model is a normal Juju model that just happens to
have machines that manage Juju. A single Juju controller can manage many
Juju models, meaning less resources are needed for Juju's management
infrastructure and new models can be created almost instantly.

In order to keep a clean separation of concerns, it is now considered
best practice to create additional models for deploying workloads,
leaving the controller model for Juju's own infrastructure. Services can
still be deployed to the controller model, but it is generally expected
that these be only for management and monitoring purposes (e.g Landscape
and Nagios).

When creating a Juju controller that is going to be used by more than
one person, it is good practice to create users for each individual that
will be accessing the models.

The main new commands of note are:

    juju list-models
    juju create-model
    juju grant
    Juju revoke
    juju list-shares
    juju use-model 
    juju list-users
    juju switch-user

Also see:
    juju help controllers
    juju help users

Also, since controllers are now special in that they can host multiple
other models, destroying controllers now needs to be done with more
care.

    juju destroy-model

does not work on controllers, but now only on hosted models (those
models that the controller looks after).

    juju destroy-controller

is the way to do an orderly takedown.

    juju kill-controller

will attempt to do an orderly takedown, but if the API server is
unreachable it will force a takedown through the provider.  However,
forcibly taking down a controller could leave other models running with
no way to talk to an API server.


### New Bootstrap and Cloud Management Experience

This release introduces a new way of bootstrapping and managing clouds
and credentials that involves less editing of files and makes Juju work
out of the box with major public clouds like AWS, Azure, Joyent,
Rackspace, Google, Cloudsigma.

Firstly, there is no more environments.yaml file to edit. Clouds and
credentials are defined in separate files, and the only cloud
information that requires editing is for private MAAS and OpenStack
deployments.


#### Public Clouds

So, we've installed Juju, let's see what clouds are available:

    juju list-clouds

      CLOUD              TYPE        REGIONS
      aws                ec2         us-east-1, us-west-1, us-west-2, ...
      aws-china          ec2         cn-north-1
      aws-gov            ec2         us-gov-west-1
      azure              azure       japanwest, centralindia, eastus2, ...
      azure-china        azure       chinaeast, chinanorth
      cloudsigma         cloudsigma  mia, sjc, wdc, zrh, hnl
      google             gce         us-east1, us-central1, ...
      joyent             joyent      us-east-1, us-east-2, us-east-3, …
      lxd                lxd
      maas               maas
      manual             manual
      rackspace          rackspace   lon, syd, hkg, dfw, ord, iad

To see more detail on a particular cloud, use show-cloud:

    juju show-cloud azure

We want to bootstrap a controller on AWS. In this case, as is possible
with previous versions of Juju, our credentials are already set up as
environment variables so we can just get straight to it:

    juju bootstrap mycontroller aws

The default region is shown first in the list-clouds output so we'll get
a controller called "mycontroller" on us-east-1. But we can also specify
a different region.

    juju bootstrap mycontroller aws/us-west-2

You can set the default region for a cloud:

    juju set-default-region aws us-west-1


#### Update Clouds Command

Canonical will from time to time publish new public cloud data to
reflect new regions or changed endpoints in the list of public clouds
supported by Juju. To make use of this information, this command can be
run prior to bootstrap:

    juju update-clouds

If there is new cloud information available, this information may then
be used next time a Juju controller is bootstrapped.


#### Credential Management

Credentials are managed in a separate credentials.yaml file located in
~/.local/share/juju. Credentials are per cloud. This is where it's also
possible to define the default region to use for a cloud if none is
specified when bootstrapping.

If there's only one credential, that's what's used. Or you can define
the default credential for a cloud. Otherwise you can specify the
credential name when bootstrapping:

    juju bootstrap mycontroller aws --credential mysecrets

Juju has the ability to discover credentials that may be stored in
environment variables or other well known places for various public
clouds.

* AWS credentials are discovered as follows:
  * ~/.aws/credentials file (%USERPROFILE%/.aws/credentials on Windows)
  * environment variables ```AWS_ACCESS_KEY_ID```,
    ```AWS_SECRET_ACCESS_KEY``` (fallbacks ```AWS_ACCESS_KEY```,
    ```AWS_SECRET_KEY``` also supported)

* Google credentials are discovered as follows: json file whose path is
  * set by environment variable ```GOOGLE_APPLICATION_CREDENTIALS```
    json file
  * ~/.config/gcloud/application_default_credentials.json
     (%APPDATA%/gcloud/application_default_credentials.json on Windows)

* OpenStack or Rackspace credentials are discovered as follows:
  * ~/.novarc file
  * userpass environment variables
     (```OS_USERNAME```, ```OS_PASSWORD```, ```OS_AUTH_URL```,
     ```OS_REGION_NAME```, ```OS_TENANT_NAME```)
  * accesskey environment variables
     (```OS_ACCESS_KEY```, ```OS_SECRET_KEY```, ```OS_AUTH_URL```,
      ```OS_REGION_NAME```, ```OS_TENANT_NAME```)



Juju will search the above locations and use the first credential it
finds for each cloud.

To use this feature, simply run:

    juju autoload-credentials

Juju will print the credentials it finds and prompt for which ones to
import.

Looking for cloud and credential information locally...

    1. aws credential "fred" (existing, will overwrite)
    2. aws credential "default" (new)
    3. openstack region "home" project "fred_project" user "fred" 
       (existing, will overwrite)
    Save any? Type number, or Q to quit, then enter. 3

    Enter cloud to which the credential belongs, or Q to quit [home-openstack] 


    Saved openstack region "home" project "fred_project" user "fred" to
    cloud home-openstack

When prompting which cloud for which to save the credentials, Juju will
attempt to select a default cloud where you can just hit enter. If you
do type a cloud name, the type of cloud must match the credentials. eg
you can't save Google credentials to the "aws" cloud.

Once imported, credentials can be listed:
  
    juju list-credentials

      CLOUD           CREDENTIALS
      aws             default, user
      home-openstack  user

You can set the default credential for a cloud:

    juju set-default-credential aws user

To see the full credentials details including secrets:

    juju list-credentials --format yaml --show-secrets

      credentials:
        aws:
          default-region: us-east-1
          fred:
            auth-type: access-key
            access-key: AKIAIBVNWJYRCE4RMGBQ
            secret-key: mysecret
        local:homestack:
          default-region: home
          fred:
            auth-type: userpass
            password: mysecret
            tenant-name: fred_project
            username: fred

It's also possible to create a credentials.yaml file to add credentials
for other clouds like Azure, MAAS and Joyent. If you have a
credentials.yaml file from which you want to add credentials to Juju,
without editing Juju's credentials.yaml file, you can use the command:

    juju add-credential <cloud> -f <credentials.yaml>

The above command will add all credentials for the specified cloud to
Juju's available credentials. If any credentials for the cloud already
are known to Juju, the '--replace' option will be required.

To remove a credential, use the remove-credential command:

  Juju remove-credential aws myoldcredential

An example credentials.yaml file. Note the sections for Azure, MAAS and
Joyent which define what attributes must be specified. You can create a
version of this file by hand and use the add-credential command to
import into Juju.

    credentials:
      aws:
        default-credential: peter
        default-region: us-west-2
        peter:
          auth-type: access-key
          access-key: key
          secret-key: secret
        paul:
          auth-type: access-key
          access-key: key
          secret-key: secret
      homemaas:
        peter:
          auth-type: oauth1
          maas-oauth: mass-oauth-key
      homestack:
        default-region: region-a
        peter:
          auth-type: userpass
          password: secret
          tenant-name: tenant
          username: user
      google:
        peter:
          auth-type: jsonfile
          file: path-to-json-file
      azure:
        peter:
          auth-type: userpass
          application-id: blah
          subscription-id: blah
          application-password: blah
      joyent:
        peter:
          auth-type: userpass
          sdc-user: blah
          sdc-key-id: blah
          private-key: blah (or private-key-path)
          algorithm: blah


#### Managing Controllers and Models

We can see what controllers I can talk to:

    juju list-controllers

      CONTROLLER    MODEL         USER         SERVER
      mycontroller*  admin         admin@local  10.0.1.12:17070
      test           default       admin@local  10.0.3.13:17070

The current controller is indicated with an *.

Juju will create the controller model, called "admin", and an initial
hosted model, called "default", as part of bootstrap. You can then
create a new hosted model in which workloads are run, or use the
"default" model.

Note: locally bootstrapped controllers will be prefixed by the "local."
label in the next Juju beta. So "mycontroller" above becomes
"local.mycontroller".

It's possible to use juju switch to select the current controller and/or
model.

    juju switch mymodel        (switch to mymodel on current controller)
    juju switch mycontroller   (switch current controller to mycontroller)
    juju switch mycontroller:mymodel   (switch to mymodel on mycontroller)

To see the name of the current controller (and model), run switch with
no arguments:

    juju switch

To see the full details of the current controller, run show-controller
with no arguments:

    juju show-controller

When run on the machine used to bootstrap the controller, this command shows
key details about the controller, including the type of cloud, the region in
which the controller is running, and any additional user supplied bootstrap
configuration. Account passwords are included if --show-passwords is used.

    juju show-controller mycontroller

    mycontroller:
     details:
       servers: ['10.0.1.92:17070']
       uuid: 16db5c82-f7af-4b0a-8507-2023df01ce89
       api-endpoints: ['10.0.1.92:17070']
       ca-cert: |
         -----BEGIN CERTIFICATE-----
         MIICUzCCAbygAwIBAgIBADANBgkqhkiG9w0BAQsFADA9MQ0wCwYDVQQKEwRqdWp1
         be+b85buvy96izTUygz3LVZQT379pXw=
         -----END CERTIFICATE-----
     accounts:
       admin@local:
         user: admin@local
         models:
           admin:
             uuid: 16db5c82-f7af-4b0a-8507-2023df01ce89
           default:
             uuid: c86c7699-21f2-4eb2-8ee6-6ffc65895762
         current-model: default
     current-account: admin@local
     bootstrap-config:
       cloud: lxd
       cloud-type: lxd
       region: localhost

Note: The model commands used for multi-model support, as outlined in
the previous section, work across multiple controllers also.

    juju create-model mynewmodel -c mycontroller

The above command creates a new model on the nominated controller and
switches to that controller and model as the default for subsequent
commands.


#### LXD and Manual and MAAS Providers 

Bootstrapping models using the LXD, MAAS manual providers also Just Works.

    juju bootstrap mycontroller lxd

    juju bootstrap mycontroller manual/<hostname>

    juju bootstrap mycontroller maas/<hostname>

For now, LXD just supports localhost as the LXD host which is the
default.   The manual provider sees the hostname (or IP address)
specified as shown above rather than a config setting.

MAAS works out of the box by specifying the MAAS controller address, but
it's also possible to set up a named MAAS cloud definition using juju
add-cloud (see below).


#### Private Clouds

For MAAS and OpenStack clouds, it's necessary to edit a clouds.yaml
file. This can be done from anywhere and then the juju add-cloud command
is used to add these to Juju.

    clouds:
       homestack:
          type: openstack
          auth-types: [userpass, access-key]
          regions:
             london:
                endpoint: http://london/1.0
       homemaas:
          type: maas
          auth-types: [oauth1]
          endpoint: http://homemaas/MAAS

Assuming you save the above to personal-clouds.yaml, you can add the
OpenStack cloud to Juju:

   juju add-cloud homestack personal-clouds.yaml

Then when you juju list-clouds:

    CLOUD            TYPE        REGIONS
    aws              ec2         us-west-2, eu-west-1, ap-southeast-2 ...
    aws-china        ec2         cn-north-1
    aws-gov          ec2         us-gov-west-1
    azure            azure       eastus, southeastasia, centralindia ...
    azure-china      azure       chinaeast, chinanorth
    cloudsigma       cloudsigma  hnl, mia, sjc, wdc, zrh
    google           gce         us-east1, us-central1, europe-west1, ...
    joyent           joyent      eu-ams-1, us-sw-1, us-east-1, us-east-2 ... 
    rackspace        rackspace   ord, iad, lon, syd, hkg, dfw
    local:homestack  openstack   london

And now you can bootstrap that OpenStack cloud:

    juju bootstrap mycontroller homestack


#### Model Configuration at Bootstrap

When bootstrapping, it's sometimes also necessary to pass in
configuration values. These was previously done via the
environments.yaml file. For this release, you can specify config values
as bootstrap arguments or via a file:

    juju bootstrap

        mycontroller aws/us-west-2
        --config key1=value1 --config key2=value2 --config /path/to/file

Values as name pairs take precedence over the content of any file
specified. Example:

    juju bootstrap mycontroller aws --config image-stream=daily

A newly bootstrapped controller runs 2 models out of the box:
a controller model called "admin"
a hosted model called "default", which is set as the current model

To specify a different name for the hosted model:

  juju bootstrap mycontroller aws --default-model mymodel


#### Creating New Models

Controller admin users can create new models without needing to specify
any additional configuration:

  juju create-model mynewmodel

In such cases, the new model will inherit the credentials and authorized
ssh keys of the admin model.

Where a cloud requires credentials, non-admin users, and admin users if
they wish, are required to specify a named credential (so that resources
created by the new model are allocated to the cloud account of the model
creator), as well as authorized keys:

  juju create-model mynewmodel --credential mysecrets
    --config authorized-keys="ssh-rsa ...."

Additional model config just for the new model may also be specified:

  juju create-model --config image-stream=daily


#### Sharing Models

You can now easily give other people read-only or write access to your
models, even if that user did not previously have the ability to login
to the controller hosting the model.

    juju add-user bob --models mymodel --acl=write

      User "bob" added
      Model  "mymodel" is now shared
      Please send this command to bob:
         juju register MDoTA2JvYjAREw8xMC4wLjEuMTI6MTcwNzAEIMZ7bVxwiApr

Now all bob has to do is run register command and he is prompted to
enter a new password and name the controller and he will be logged into
the controller and access the shared model.

    juju register MDoTA2JvYjAREw8xMC4wLjEuMTI6MTcwNzAEIMZ7bVxwiApr
      Please set a name for this controller: controller
      Enter password:  
      Confirm password:  
      Welcome, bob. You are now logged into "controller".

The above process is cryptographically secure with end-end encryption
and message signing/authentication and is immune to man-in-the-middle
attacks.


### Joyent Provider No Longer Uses Manta Storage

The use of Joyent Manta Storage is no longer necessary and has been
removed. The Manta credential attributes is not supported. `juju add-
credential` will not prompt for them. Existing credential.yaml files used
in previous betas will need to be edited to remove: manta-user, manta-
key-id, manta-url


### Native Support for Charm Bundles

The Juju 'deploy' command can now deploy a bundle. The Juju Quickstart
or Deployer plugins are not needed to deploy a bundle of charms. You can
deploy the mediawiki-single bundle like so:

    juju deploy cs:bundle/mediawiki-single
 
Local bundles can be deployed by passing the path to the bundle. For
example:

    juju deploy ./openstack/bundle.yaml

Local bundles can also be deployed from a local repository. Bundles
reside in the "bundle" subdirectory. For example, your local juju
repository might look like this:

    juju-repo/
     |
     - trusty/
     - bundle/
       |
       - openstack/
         |
         - bundle.yaml 

and you can deploy the bundle like so:

    export JUJU_REPOSITORY="$HOME/juju-repo"
    juju deploy local:bundle/openstack

Bundles, when deployed from the command line like this, now support
storage constraints. To specify how to allocate storage for a service,
you can add a 'storage' key underneath a service, and under 'storage'
add a key for each store you want to allocate, along with the
constraints. e.g. say you're deploying ceph-osd, and you want each unit
to have a 50GiB disk:

    ceph-osd:
        ...
        storage:
            osd-devices: 50G

Because a bundle should work across cloud providers, the constraints in
the bundle should not specify a pool/storage provider, and just use the
default for the cloud. To customize how storage is allocated, you can use
the '--storage' option with a new bundle-specific format: --storage
service:store=constraints. e.g. say you you're deploying OpenStack, and
you want each unit of ceph-osd to have 3x50GiB disks:

    juju deploy ./openstack/bundle.yaml --storage ceph-osd:osd-devices=3,50G


### Multi Series Charms

Charms now have the capability to declare that they support more than
one  series. Previously a separate copy of the charm was required for
each  series. An important constraint here is that for a given charm,
all of the  listed series must be for the same distro/OS; it is not
allowed to offer a  single charm for Ubuntu and CentOS for example.
Supported series are added  to charm metadata as follows:

    name: mycharm
    summary: "Great software"
    description: It works
    maintainer: Some One <some.one@example.com>
    categories:
       - databases
    series:
       - precise
       - trusty
       - wily
    provides:
       db:
         interface: pgsql
    requires:
       syslog:
         interface: syslog

The default series is the first in the list:

    juju deploy mycharm

will deploy a mycharm service running on precise.

A different, non-default series may be specified:

    juju deploy mycharm --series trusty

It is possible to force the charm to deploy using an unsupported series
(so long as the underlying OS is compatible):

    juju deploy mycharm --series xenial --force

or

    juju add-machine --series xenial
    Machine 1 added.
    juju deploy mycharm --to 1 --force

'--force' is required in the above deploy command because the target
machine  is running xenial which is not supported by the charm.

The 'force' option may also be required when upgrading charms. Consider
the  case where a service is initially deployed with a charm supporting
precise  and trusty. A new version of the charm is published which only
supports  trusty and xenial. For services deployed on precise, upgrading
to the newer  charm revision is allowed, but only using force (note the
use of  '--force-series' since upgrade-charm also supports '--force-
units'):

    juju upgrade-charm mycharm --force-series


### Juju GUI in the Controller

Juju GUI is now automatically included in every Juju controller after
bootstrapping, thus eliminating the need to additionally deploy the Juju
GUI charm.

In order to  open the Juju GUI in the default browser the following
command should be used.

    juju gui

The GUI connects to the model that is currently active. You are greeted
with the login window, where you will have to provide the credentials to
access the model. If you want to output your credentials in the
terminal for easier copy/paste into login window, run the GUI with the
'--show-credentials' option.

    juju gui --show-credentials 


#### juju upgrade-gui 

The upgrade-gui command downloads the latest published GUI from the
streams and replaces the one on the controller. To verify which versions
of the GUI are available before the upgrade, try:

    juju upgrade-gui --list

If you want to upgrade (or downgrade) to a specific version of the GUI,
provide the revision as a parameter to the upgrade-gui command, where
the revision listed by the `juju upgrade-gui --list`. For example:

    juju upgrade-gui 2.1.1 

If you'd like to try a version of the GUI that has not been published in
the streams and is not listed yet, you are able to provide the blob
either from a charm or from the manually built GUI. Example:

    juju upgrade-gui /path/to/release.tar.bz2

In order to upgrade the GUI, you'll have to have proper access rights to
the controller. When an administrator upgrades the GUI, the users will
have to reload the open sessions in the browser.

If you don not want to install the GUI into the controller, bootstrap
your controller with the '--no-gui option.


### Improved Local Charm Deployment

Local charms can be deployed directly from their source directory
without  having to set up a pre-determined local repository file
structure. This  feature makes it more convenient to hack on a charm and
just deploy it, and  it also necessary to develop local charms
supporting multi series.

Assuming a local charm exists in directory /home/user/charms/mycharm:

    juju deploy ~/charms/mycharm

will deploy the charm using the default series.

    juju deploy ~/charms/mycharm --series trusty

will deploy the charm using trusty.

Note that it is no longer necessary to define a JUJU_REPOSITORY nor
locate  the charms in a directory named after a series. Any directory
structure can  be used, including simply pulling the charm source from a
VCS, hacking on  the code, and deploying directly from the local repo.

Bundles are also supported. You can now do something like this:

    series: xenial
    services:
        wordpress:
            charm: ./wordpress
            num_units: 1
            series: trusty
        mysql:
            charm: ./mysql
            num_units: 1
    relations:
        - ["wordpress:db", "mysql:server"]


Note the series attributes. These are required if the charm does not
yet define any default series in metadata or you want to use a series
different to the default. Either the bundle default series will be
used ("xenial" for the mysql service above) or the service specific
one will be ("trusty" for the wordpress service above).


### Mongo 3.2 Support

Juju will now use mongo 3.2 for its database, with the new Wired Tiger
storage engine enabled. This is initially only when bootstrapping on
Xenial. Trusty and Wily will be supported soon.

### LXC Local Provider No Longer Available

With the introduction of the LXD provider (below), the LXC version of
the Local Provider is no longer supported.


### LXD Provider

The new LXD provider is the best way to use Juju locally.

The controller is no longer your host machine; it is now a LXC
container. This keeps your host machine clean and allows you to utilize
your local model more like a traditional Juju model. Because
of this, you can test things like Juju high-availability without needing
to utilize a cloud provider.


#### Requirements

* In 2.0-beta3, users are required to have lxd 2.0.0~rc3-0ubuntu2 or
  later to use the LXD provider.

Logs are located at '/var/log/lxd/juju-{uuid}-machine-#/


#### Setting up LXD on older series

LXD has been made available in Trusty backports, but needs manual
dependency resolution:
        
    sudo apt-get --target-release trusty-backports install lxd
        
Before using a locally running LXD after installing it, either through
Juju or the LXD CLI ("lxc"), you must either log out and back in or run
this command:
        
    newgrp lxd
               
See: https://linuxcontainers.org/lxd/getting-started-cli/


### LXD Containers

Juju now uses LXD to provide containers when deploying services. So
instead of doing:

    juju deploy mysql --to lxc:1

the new syntax is:

    juju deploy mysql --to lxd:1

This also allows us to use LXD's implementation of resource constraints
to limit the total memory or number of CPUs that are available


### Microsoft Azure Resource Manager Provider

Juju now supports Microsoft Azure's new Resource Manager API. The Azure
provider has effectively been rewritten, but old models are still
supported. To use the new provider support, you must bootstrap a new
model with new configuration. There is no automated method for
migrating.

The new provider supports everything the old provider did, but now also
supports several additional features, as well as support for unit
placement (i.e. you can specify existing machines to which units are
deployed). As before, units of a service will be allocated to machines
in a service-specific Availability Set if no machine is specified.

In the initial release of this provider, each machine will be allocated
a public IP address. In a future release, we will only allocate public
IP addresses to machines that have exposed services, to enable
allocating more machines than there are public IP addresses.

Each model is represented as a "resource group" in Azure, with the VMs,
subnets, disks, etc. being contained within that resource group. This
enables guarantees about ensuring resources are not leaked when
destroying a model, which means we are now able to support persistent
volumes in the Azure storage provider.

Finally, as well as Ubuntu support, the new Azure provider supports
Microsoft Windows Server 2012 (series "win2012"), Windows Server 2012 R2
(series "win2012r2"), and CentOS 7 (series "centos7") natively.

To use the new Azure support, you need the following configuration in
environments.yaml:

    type:                 azure
    application-id:       <Azure-AD-application-ID>
    application-password: <Azure-AD-application-password>
    subscription-id:      <Azure-account-subscription-ID>
    tenant-id:            <Azure-AD-tenant-ID>
    location:             westus # or any other Azure location

To obtain these values, it is recommended that you use the Azure CLI:
https://azure.microsoft.com/en-us/documentation/articles/xplat-cli/.

You will need to create an "application" in Azure Active Directory for
Juju to use, per the following documentation:
https://azure.microsoft.com/en-us/documentation/articles/resource-group-authenticate-service-principal/#authenticate-service-principal-with-password---azure-cli
(NOTE: you should assign the role "Owner", not "Reader", to the
application.)

Take a note of the "Application Id" output when issuing "azure ad app
create". This is the value that you must use in the 'application-id'
configuration for Juju. The password you specify is the value to use in
'application-password'.

To obtain your subscription ID, you can use "azure account list" to list
your account subscriptions and their IDs. To obtain your tenant ID, you
should use "azure account show", passing in the ID of the account
subscription you will use.

You may need to register some resources using the azure CLI when
updating an  existing Azure account:

    azure provider register Microsoft.Compute
    azure provider register Microsoft.Network
    azure provider register Microsoft.Storage


### New Support for Rackspace

A new provider has been added that supports hosting a Juju model in
Rackspace  Public Cloud As Rackspace  Cloud is based on OpenStack,
Rackspace  provider internally uses OpenStack provider, and most of the
features and  configuration options for those two providers are
identical.

A note when entering credential attributes via juju add-credential:

'tenant-name' must contain the rackspace Account Number.
'region' must contain rackspace region (iad, dfw, ord, lon, hkg, syd). 


### Bootstrap Constraints, Series

While bootstrapping, you can now specify constraints for the bootstrap
machine independently of the service constraints:

    juju bootstrap --constraints <service-constraints> 
        --bootstrap-constraints <bootstrap-machine-constraints>

You can also specify the series of the bootstrap machine:

    juju bootstrap --bootstrap-series trusty


### Juju Logging Improvements

Logs from Juju's machine and unit agents are now streamed to the Juju
controllers over the Juju API in preference to using rsyslogd. This is
more robust and is a requirement now that multi-model support is enabled
by default. Additionally, the centralised logs are now stored in Juju's
database instead of the all-machines.log file. This improves log query
flexibility and performance as well as opening up the possibility of
structured log output in future Juju releases.

The 'juju debug-log' command will continue to function as before and
should be used as the default way of accessing Juju's logs.

This change does not affect the per machine (machine-N.log) and per unit
(unit-*-N.log) log files that exist on each Juju managed host. These
continue to function as they did before.

A new 'juju-dumplogs' tool is also now available. This can be run on
Juju controllers to extract the logs from Juju's database even when the
Juju server isn't available. It is intended to be used as a last resort
in emergency situations. 'juju-dumplogs' will be available on the system
$PATH and requires no command line options in typical usage.


### API Login with Macaroons

Juju 2.0 supports an alternate API long method based on macaroons. This
will support the new charm publishing workflow coming future releases


### Unit Agent Improvements

We've made improvements to worker lifecycle management in the unit agent
in this release. The resource dependencies (API connections, locks,
etc.) shared among concurrent workers that comprise the agent are now
well-defined, modeled and coordinated by an engine, in a design inspired
by Erlang supervisor trees.

This improves the long-term testability of the unit agent, and should
improve the agent's resilience to failure. This work also allows hook
contexts to execute concurrently, which supports features in development
targeting 2.0.


### Experimental address-allocation feature flag is no longer supported

In earlier releases, it was possible to get Juju to use static IP
addresses for containers from the same subnet as their host machine,
using the following development feature flag:

    JUJU_DEV_FEATURE_FLAGS=address-allocation juju bootstrap ...

This flag is no longer supported and will not be accepted.


### New Openstack machines can be provisioned based on virtualisation type (kvm, lxd)

Openstack clouds with multi-hypervisor support have different images for
LXD and KVM. Juju can now pick the right image for LXD or KVM instance
based on the instance constraints:

    juju deploy mysql --constraints="virt-type=lxd,mem=8G,cpu=4"


### Support for MAAS 1.9+ Spaces and Related APIs

Juju 2.0 now natively supports the new spaces API in MAAS 1.9+. Spaces
are automatically discovered from MAAS (1.9+) on bootstrap and available
for use with service endpoint bindings or machine provisioning
constraints (see below). Space discovery works for the controller model
as well as any model created later using 'juju create-model'.

Currently there is no command to update the spaces in Juju if their
corresponding MAAS spaces change. As a workaround, restarting the
controller machine agent (jujud) discovers any new spaces.


#### Binding Service Endpoints to Spaces

When deploying a service, you can use the optional '--bind' argument to
specify to which space individual charm endpoints should be bound. The
syntax for the '--bind' argument is a whitespace-separated list of
endpoint and space names, separated by "=".

Binding means the "bound" endpoints will have addresses from subnets
part of the space the endpoint is bound to. When '--bind' is not
specified, all endpoints will use the same address (backwards-compatible
behaviour) which is the host machine's preferred private address (as
returned by "unit-get private-address"). Additionally, a service-default
space can be specified by omitting the "<endpoint>=" prefix before the
space name. This space will be used for binding all endpoints that are
not explicitly specified.

Examples:

    juju deploy mysql --bind "db=database server=internal"

Bind "db" endpoint to an address part of the "database" space (i.e. the
address is coming from one of the "database" space's subnets in MAAS).

    juju deploy wordpress --bind internal-apps

Bind *all* endpoints of wordpress to the "internal-apps" space.

    juju deploy haproxy --bind "url=public internal"

Bind "url" to "public", and all other endpoints to "internal".


#### Binding Endpoints of Services Within a Bundle to Spaces

Bindings can be specified for services within a bundle the same way as
when deploying individual charms. The bundle YAML can include a section
called "bindings", defining the map of endpoint names to space names.

Example bundle.yaml excerpt:
    ...
    mysql:
        charm: cs:trusty/mysql-53
        num_units: 1
        constraints: mem=4G
        bindings:
            server: database
            cluster: internal
    ...

Deploying a bundle including a section like in the example above, is
equivalent to running:

    juju deploy mysql --bind "server=database cluster=internal"

There is currently no way to declare a service-default space for all
endpoints in a bundle's bindings section. A workaround is to list all
endpoints explicitly.


#### New Hook Command: network-get

When deploying a service with endpoint bindings specified, charm authors
can use the new "network-get" hook command to determine which address to
advertise for a given endpoint. This approach will eventually replace
"unit-get private-address" as well as various other ways to get the
address to use for a given unit.

There is currently a mandatory '--primary-address' argument to 'network-
get', which guarantees a single IP address to be returned.

Example (within a charm hook): 

    relation-ids cluster
    url:2

    network-get -r url:2 --primary-address
    10.20.30.23

(assuming the service was deployed with e.g. --bind url=internal, and
(10.20.30.0/24 is one of the subnets in that "internal" space).


#### Multiple Positive and Negative Spaces Supported in Constraints

Earlier releases which introduced spaces constraints ignored all but the
first positive space in the list. While the AWS provider still does
that, for MAAS deployments all spaces constraints are applied for
machine selection, positives and negatives.

Example:

    juju add-machine --constraints spaces=public,internal,^db,^admin

When used on a MAAS-based model, Juju will select a machine which has
access to both "public" and "internal" spaces, but neither the "db" or
"admin" spaces.


#### Mediawiki Demo Bundle Using Bindings

A customised version of the mediawiki bundle[1] that deploys haproxy,
mediawiki and mysql. Traffic between haproxy and mediawiki is on a space
called "internal" and traffic between mediawiki and mysql is in a space
called "db". The haproxy website endpoint is bound to the "public"
space.

[1] - http://juju-sapphire.github.io/MAAS%20Spaces%20Demo/


### Resources A new concept has been introduced into Charms called
"resources". Resources are binary blobs that the charm can utilize, and
are declared in the metadata for the Charm. All resources declared will
have a version stored in the Charm store, however updates to these can
be uploaded from an admin's local machine to the controller.


#### Change to Metadata

A new clause has been added to metadata.yaml for resources. Resources
can be declared as follows:

    resources:
      name:
        type: file                         # the only type initially
        filename: filename.tgz
        description: "One line that is useful when operators need to push it."


#### New User Commands

Three new commands have been introduced:

1.  juju list-resources

    usage: juju list-resources [options] service-or-unit
    purpose: show the resources for a service or unit
    
    options:
    --format  (= tabular)
        specify output format (json|tabular|yaml)
    -m, --model (= "")
        juju model to operate in
    -o, --output (= "")
        specify an output file
    
    This command shows the resources required by and those in use by an
    existing service or unit in your model.
    
    aliases: resources

2.  juju push-resource

    usage: juju push-resource [options] service name=file
    purpose: upload a file as a resource for a service
    
    options:
    -m, --model (= "")
        juju model to operate in
    
    This command uploads a file from your local disk to the juju
    controller to be used as a resource for a service.

3. juju charm list-resources

    usage: juju charm [options] <command> ...
    purpose: interact with charms

    options:
    --description  (= false)
    
    -h, --help  (= false)
        show help on a command or other topic

    "juju charm" is the the juju CLI equivalent of the "charm" command
    used by charm authors, though only applicable functionality is
    mirrored.

    commands:
        help           - show help on a command or other topic
        list-resources - display the resources for a charm in the charm store
        resources      - alias for 'list-resources'

In addition, resources may be uploaded when deploying or upgrading
charms by specifying the resource option to the deploy command. Following
the resource option should be name=filepath pair.  This option may be
repeated more than once to upload more than one resource.

    juju deploy foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml

or

    juju upgrade-charm foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml

Where bar and baz are resources named in the metadata for the foo charm.


#### New Charmer Concepts

##### Expansion of the upgrade-charm hook

Whenever a charm or any of its required resources are updated, the
'upgrade-charm' hook will fire. A resource is updated whenever a new
copy is uploaded to the charm store or controller


##### resource-get

There is a new hook tool 'resource-get' which is used while a hook is
running to get the local path to the file for the identified resource.
This file is an fs-local copy, unique to the unit for which the hook is
running. It is downloaded from the controller, if necessary.

If 'resource-get' for a resource has not been run before (for the unit)
then the resource is downloaded from the controller at the revision
associated with the unit's service. That file is stored in the unit's
local cache. If 'resource-get' **has** been run before then each
subsequent run syncs the resource with the controller. This ensures that
the revision of the unit-local copy of the resource matches the revision
of the resource associated with the unit's service.

Either way, the path provided by 'resource-get' references the up-to-
date file for the resource. Note that the resource may get updated on
the controller for the service at any time, meaning the cached copy
**may** be out of date at any time after you call 'resource-get'.
Consequently, the command should be run at every point where it is
critical that the resource be up to date.

The 'upgrade-charm' hook will be fired whenever a new resource has
become available. Thus, in the hook the charm may call 'resource-get',
forcing an update if the resource has changed.

Note that 'resource-get' only provides an FS path to the resource file.
It does not provide any information about the resource (e.g. revision).

##### Charms can declare minimum Juju version

There is a new (optional) top level field in the metadata.yaml file
called min-juju-version.  If supplied, this value specifies the minimum
version of a Juju server with which the charm is compatible.  When a
user attempts to deploy a charm (whether from the charmstore or from
local) that has min-juju-version specified, if the targeted model's Juju
version is lower than that specified, then the user will be shown an
error noting that the charm requires a newer version of Juju (and told
what version they need).  The format for min-juju-version is a string
that follows the same scheme as our release versions, so you can be as
specific as you like. For example, min-juju-version: "2.0.1-beta3" will
deploy on 2.0.1 (release), but will not deploy on 2.0.1-alpha1 (since
alpha1 is older than beta3).

Note that, at this time, Juju 1.25.x does *not* recognize this field, so
charms using this field will, unfortunately, not be accepted by 1.25
environments.


### Juju Status Improvements

The default Juju status format is now tabular (not yaml). Yaml can still
be output by using the '--format yaml' arguments. The deprecated agent-
state and associated yaml attributes are now deleted (these have been
replaced since 1.24 by agent status and workload status attributes).

The tabular status output now also includes relation information. This
was previously only shown in the yaml and json output formats.


#### Machine provisioning status

Juju status for machines has a new "machine-status" value. This reflects
the state of the machine as it is being allocated within the cloud. For
providers like MAAS, it is possible to see the state of the machine as
it transitions from allocating to deploying to deployed. For containers
it also provide extra information about the container being created.

    juju status --format yaml

        model: admin
        machines:
         "0":
           juju-status:
             current: allocating
             since: 24 Mar 2016 09:06:59+10:00
             version: 2.0-beta3.1
           dns-name: 10.0.1.92
           instance-id: juju-16db5c82-f7af-4b0a-8507-2023df01ce89-machine-0
           machine-status:
             current: allocating
             message: a2ef-dec1-8bfc-092e: deploying
             since: 24 Mar 2016 09:06:59+10:00
           series: trusty
           hardware: arch=amd64 cpu-cores=0 mem=0M


### Relation get-config and set-config compatibility

See https://bugs.launchpad.net/juju-core/+bug/1382274

If 'juju get-config' is used to save YAML output to a file, the same
file can now be used as input to 'juju set-config'. The functions are
now reciprocal such that the output of one can be used as the input of
the other with no changes required, so that:

1. complex configuration data containing multiple levels of quotes can
be modified via YAML without needing to be escaped on shell command
lines, and

2. large amounts of config data can be transported from one
juju model to another in a trivial fashion.


### Support for new EC2 M4 Instance Types

Juju now supports m4 instances on EC2.

    m4.large
    m4.xlarge
    m4.2xlarge
    m4.4xlarge
    m4.10xlarge


### Support for win10 and win2016

Juju now supports Windows 10 Enterprise and Windows Server 2016


### Juju Now Respects CharmStore Channels

For more information on the new support for channels in the Charm Store
and how they work, please see our
[documentation](https://jujucharms.com/docs/devel/authors-charm-store
#entities-explained) on the subject.

Support for channels has been brought into Juju via command options on the
relevant sub-commands:

    juju deploy
    Juju upgrade-charm


### Keystone 3 support in Openstack.

Juju now supports Openstack with Keystone Identity provider V3. Keystone
3 brings a new attribute to our credentials, "domain-name"
(OS_DOMAIN_NAME) which is optional. If "domain-name" is present (and
user/password too) juju will use V3 authentication by default. In other
cases where only user and password is present, it will query Openstack
as to what identity providers are supported, and their endpoints. V3
will be tried and, if it works, set as the identity provider or else it
will settle for V2, the previous standard.


### Accurate Address Selection Based on Network Spaces (in MAAS)

MAAS 1.9+ offers native support for Network Spaces, which Juju will
discover and import. This means Juju knows which space any machine
address comes from and can select addresses based on their space. An
example for this improved support is the used by the 'network-get' hook
tool. Earlier versions of Juju (and even this one on providers other
than MAAS) use a simpler address selection based on scope and
lexicographic order.


### network-get Hook Tool Arguments Changed

The new 'network-get' hook tool introduced in 2.0-alpha3 slightly
changed:

Before: network-get -r <relation-id> --primary-address
Now:    network-get <binding-name> --primary-address

Instead of taking an (implicit) -r argument with relation ID, the first
expected argument is now a binding name. This can be a name listed
inside the "extra-bindings" section of the charm metadata.yaml, or a
name of a relation (from the "provides", "requires", or "peers"
sections). The output is the same otherwise - a single address returned.


### extra-bindings Support for Charms Metadata

Many charms use a simple model where a relationship with another charm
also indicates there is a network connection between units of those
services. We have utilized this fact to add a network model that allows
system operators to control where those TCP connections are made by
binding the service relation endpoints onto a network space.

However, some charms specifically use relation endpoints as simply a way
to pass configuration around, and the relations don't map directly to
services that are running in that charm and/or networking configuration.
These charms want to be able to express that they have more networking
configuration that an operator wants to control without having yet-
another interface that will never be related to another service.

Juju solves the aforementioned issues by introducing an optional new
section in the charm metadata,yaml. The new section is called "extra-
bindings". Similarly to the peers/provides/requires sections, extra-
bindings contains a list of names, which can be used with 'juju deploy
--bind' like relation names. Unlike relations, you don't have to define
hooks or anything more complex to allow the users of the charm to bind
those names to Juju spaces.

Example: ceph charm's metadata.yaml would look like:

    name: ceph
    summary: Highly scalable distributed storage
    maintainer: OpenStack Charmers <openstack-charmers@lists.ubuntu.com>
    description: |
     Ceph is a distributed storage and network file system designed to provide
     excellent performance, reliability, and scalability.
    tags:
      - openstack
      - storage
      - file-servers
      - misc
    peers:
      mon:
        interface: ceph
    extra-bindings:
      cluster:
      public:
    provides:
      nrpe-external-master:
        interface: nrpe-external-master
        scope: container
    …
    storage:
      osd-devices:
        type: block
        multiple:
          range: 0-
      osd-journal:
        type: block
        multiple:
          range: 0-1


As a user then you can deploy this charm and tell Juju to provide
distinct addresses for it on one or more spaces:

    juju deploy ~/path/to/charm/ceph --bind 'cluster=admin-api public=public-api internal-api'

Units of the ceph service will be deployed on machines which have access
to the "admin-api", "public-api", and "internal-api" spaces in MAAS, a
different network interface and address for each binding.

Then, e.g. in a hook of the same charm, running 'network-get cluster
--primary-address' will only return the correct address - the one coming
from the "admin-api" space.


### Known issues

  * Juju 2.0 no longer supports KVM for local provider
    Lp 1547665
  * Cannot deploy a dense openstack bundle with native deploy
    Lp 1555808
  * Cannot add LXD containers in 2.0beta4 on trusty
    Lp 1568895
  * LXD containers /etc/network/interfaces as generated by Juju gets
    overwritten by LXD container start
    Lp 1566801
  * juju restore-backup does not complete properly
    Lp 1569467
  * panic when running juju register
    Lp 1572707
  * Credentials files containing Joyent credentials must be updated to
    work with beta3 (See "Joyent Provider No Longer Uses Manta Storage")


## Resolved issues

  * Newly created lxd container has zero network devices
    Lp 1564395

  * Cloud-init cannot always use private ip address to fetch tools
    (ec2 provider)
    Lp 1566431

  * Address allocation feature flag still enabled for maas provider in
    juju 2.0
    Lp 1568925

  * Gridfs namespace breaks charm and tools deduping across models
    Lp 1569054

  * Storage-get crashes on xenial (aws)
    Lp 1569490

  * Apiserver: digest sha header is incorrectly formed
    Lp 1503992

  * Destroyed models still show up in list-models
    Lp 1534627

  * Unable to download local: charm due to hash mismatch in multi-
    model deployment
    Lp 1541482

  * Help text for juju remove-relation needs improving
    Lp 1555694

  * Ensure availability uses wrong constraints
    Lp 1561315

  * 'juju help glossary' and 'juju help topics' are deprecated
    Lp 1564017

  * Disallow upgrading with --upload-tools for hosted models
    Lp 1567170

  * List resources will not work correctly
    Lp 1569386

  * Juju lxd bridge detection fallback is not reliable
    Lp 1570473

  * Manpage still refers to 1.x config for 2.0
    Lp 1570654

  * Can't deploy multiseries charms in bundles
    Lp 1571254

  * "juju register" stores password on disk
    Lp 1571476

  * Juju login should only ask for password once
    Lp 1571478

  * "juju change-user-password --generate" is unhelpful
    Lp 1571901

  * Help text for juju import-ssh-key needs improving
    Lp 1554700

  * Help text for juju list-ssh-keys needs improving
    Lp 1554705

  * Help text for juju add-ssh-key needs improving
    Lp 1557380

  * Help text for juju remove ssh key needs improving
    Lp 1558078

  * Help text for juju set-constraints needs improving
    Lp 1563932

  * Help text for juju get-constraints needs improving
    Lp 1563939

  * Help text for juju set-config needs improving
    Lp 1563942

  * Help text for juju debug-log needs improving
    Lp 1563950

  * Help text for juju scp needs improving
    Lp 1563956

  * Help text for juju get-config needs improving
    Lp 1564515

  * Help text for juju remove-credential needs improving
    Lp 1566332

  * Help text for juju add-credential needs improving
    Lp 1566362

  * Help text for juju upgrade-juju needs improving
    Lp 1566367

  * Help text for juju ssh needs improving
    Lp 1566369

  * Help text for juju list-shares needs improving
    Lp 1567719

  * Help text for juju set-default-credential needs improving
    Lp 1567721

  * Help text for juju list-credentials needs improving
    Lp 1567722

  * Help text for juju add-cloud needs improving
    Lp 1567724

  * Help text for juju disable-user needs improving
    Lp 1567726

  * Help text for juju enable-user needs improving
    Lp 1567728

  * Help text for juju unexpose needs improving
    Lp 1567730

  * Help text for juju expose needs improving
    Lp 1567732

  * Help text for juju set-default-region needs improving
    Lp 1567734

  * Help text for juju add-unit needs improving
    Lp 1567925

  * Help text for juju bootstrap needs improving
    Lp 1568848

  * Help text for juju needs improving
    Lp 1568862

  * Help text for juju grant needs improving
    Lp 1569652

  * Help text for juju revoke needs improving
    Lp 1569654

  * Help text for juju show-controller needs improving
    Lp 1569914

  * Help text for juju list-machines needs improving
    Lp 1569948

  * Unhelpful error message shown when metered deployment fails
    Lp 1571054
