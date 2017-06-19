Title: Juju Release Notes

# Release Notes History

This section details all the available release notes for the 
2.x stable series of Juju 
(notes for [earlier releases are available here](./reference-release-notes-1.html) ).

The versions covered here are: 


^# Juju 2.2.0

  This release greatly enhances memory and CPU utilization at scale, improves
  the modelling of networks, and adds support for KVM containers on arm64.
  Additionally, there is now outline support for Oracle Compute, and vSphere
  clouds are now easier to deploy.
  
  conjure-up now supports Juju as a Service (JAAS), macOS clients, Oracle
  and vSphere clouds, and repeatable spell deployments.
  
  ## How can I get it?
  
  The best way to get your hands on this release of Juju and conjure-up is to
  install them via snap packages (see https://snapcraft.io/ for more info on snaps).
  
          snap install juju --classic 
          snap install conjure-up --classic 
  
  Other packages are available for a variety of platforms. Please see the
  online documentation at https://jujucharms.com/docs/stable/reference-install.
  Those subscribed to a snap channel should be automatically upgraded.
  If you’re using the ppa/homebrew, you should see an upgrade available.
  
  For highlights of this release, please see the documentation at
  [https://jujucharms.com/docs/2.2/whats-new](./whats-new).
  Further details are below.
  
  ## Upgrading
  
  Changes introduced in 2.2.0 mean that you should also upgrade any
  controllers and hosted models after installing the new client software.
  Please see the documentation at 
  [https://jujucharms.com/docs/2.2/models-upgrade](./models-upgrade#upgrading-the-model-software)
  for more information.
  

  ## New and Improved
  
  * Users can now deploy workloads to Centos7 machines on Azure.
  * vSphere Juju users with vCenter 5.5 and vCenter 6.0 can now bootstrap
  successfully and deploy workloads as well as have machines organised into
  folders. 
  * Juju now has initial support for Oracle Cloud, https://jujucharms.com/docs/2.2/help-oracle.
  * Users of Azure can now benefit from better credential management
  support, we’ve eliminated the need to manually discover subscription ID
  in order to add an Azure credential. All you need is to have Azure CLI
  installed and regular Juju credential management commands will “Just Work”. 
  * Juju login command now accepts the name or hostname of a public controller
  as a parameter. Passing a user to log in as has been moved to an option
  rather than a positional parameter.
  * Behavior for a Juju bootstrap argument ‘-metadata-source’ has changed.
  In addition to specifying a parent directory that contains “tools” and
  “images” subdirectories with metadata, this argument can now also point
  directly to one of these subdirectories if only one type of custom metadata
  is required. (lp:1696555)
  * Actions that require ‘sudo’ can now be used in conjure-up steps.
  * conjure-up now uses libjuju as its api client.
  * conjure-up can now deploy from release channels, e.g. 'beta'.
  * There's a new bootstrap configuration option, max-txn-log-size, that can
  be used to configure the size of the capped transaction log used internally
  by Juju. Larger deployments needed to be able to tune this setting; we
  don't recommend setting this option without careful consideration.
  * General Juju log pruning policy can now be configured to specify maximum
  log entry age and log collection size, https://jujucharms.com/docs/2.2/controllers-config.
  * Juju status history pruning policy can also be configured to specify
  maximum status entry age and status collection size,
  https://jujucharms.com/docs/2.2/models-config.
  * The  'status --format=yaml' and 'show-machine' commands now show more
  detailed information about individual machines' network configuration.
  * Added support for AWS ‘ap-northeast-2’ region, and GCE ‘us-west1’,
  ‘asia-northeast1’ regions.
  * Actions have received some polish and can now be canceled, and showing a
  previously run action will include the name of the action along with the
  results.
  * Rotated Juju log files are now also compressed.
  * Updates to MAAS spaces and subnets can be made available to a Juju model
  using the new ‘reload-spaces’ command.
  * ‘unit-get private-address’ now uses the default binding for an application.
  * Juju models have always been internally identified by their owner and
  their short name. These full names have not been exposed well to the user
  but are now part of juju models and show-model command output.
  
  ## Fixes
  
  * Juju more reliably determines whether to connect to the MAASv2 or MAASv1
  API based on MAAS endpoint URL as well as the response received from MAAS.
  * Juju is now built with Go version 1.8 to take advantage of performance
  improvements.
  * Juju users will no longer be missing their firewall rules when adding
  a new machine on Azure.
  * Juju models with storage can now be cleanly destroyed.
  * Juju is now resilient to a MITM attack as SSH Keys of the bootstrap host
  are now verified before bootstrap (lp:1579593).
  * Root escalation vulnerability in ‘juju-run’ has been fixed (lp:1682411). 
  * Juju’s agent presence data is now aggressively pruned, reducing
  controller disk space usage and avoiding associated performance issues.
  * MAAS 2.x block storage now works with physical disks, when MAAS reports
  the WWN unique identifier. (lp:1677001). 
  * Automatic bridge names are now properly limited to 15 characters in
  Juju (lp:1672327).
  * Juju subordinate units are now removed as expected when their principal
  is removed (lp:1686696 and lp:1655486)
  
  You can check the milestones for a detailed breakdown of the Juju and
  conjure-up bugs we have fixed:
  
  https://launchpad.net/juju/+milestone/2.2.0
  https://github.com/conjure-up/conjure-up/milestone/19?closed=1
  
  ## Known issues
  
  * Juju 2.1 agents can fail if configuration for the units is large enough
  to cause responses to be chunked. https://bugs.launchpad.net/juju/2.1/+bug/1697936
  * Restarting controller during an HA upgrade will cause it to not upgrade.
  https://bugs.launchpad.net/juju/+bug/1697956 
  
  ## Feedback Appreciated!
  
  We encourage everyone to let us know how you're using Juju.
  
  Join us at regular Juju shows - subscribe to our Youtube channel
  https://youtube.com/jujucharms
  
  Send us a message on Twitter using #jujucharms, join us at #juju on freenode,
  and subscribe to the mailing list at juju@lists.ubuntu.com.
  
  https://jujucharms.com/docs/stable/contact-us


^# Juju 2.1.3 
  
  This release fixes a privilege escalation vulnerability when executing 
  `juju-run` on the cloud instances, not to be confused with the 
  'juju run' CLI command.
  
  See the following for further details on the vulnerability:
  https://bugs.launchpad.net/juju/+bug/1682411
  CVE-2017-9232 http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9232
  
  This vulnerability affects all currently distributed versions of 
  Juju (1.25.x, 2.0.x and 2.1.x).
  
  ## How to know if you need to update
  
  We’ve put together a helpful Python script that will loop through your
  controllers and then output the version of each model on the controller.
  It requires Python 2.7 or higher.
  
        curl -L https://goo.gl/59gxnz | python
  
  ## How do I update? I’m on…

  
  ### JAAS
  JAAS has been updated to the new 2.1.3 release. Users with models in
  JAAS do not need to perform any upgrade steps to their models that
  are running in JAAS.
  
  ### Juju 2.2-betaX
  Users of the 2.2-beta releases need to temporarily update to using 
  the edge channel. Users will need to use this until Juju 2.2-rc1 
  is released in the coming days. You can easily switch your snap install
  client by using the following:
  
        snap refresh juju --edge --classic
  
  Once you’ve completed this step you’ll need to run through the normal upgrade 
  steps on your models, as explained 
  [in the documentation](./models-upgrade#the-upgrade-juju-command)
  
  Note for non-snap beta users: we suggest you do not run controllers with 
  the 2.2 beta releases. We suggest you move to the edge channel of the 
  snap releases or to wait and redeploy when 2.2 RC1 is released. 
  
  ### Juju 2.1.x

  You can follow the current upgrade documentation to upgrade. Make sure that
  you update your controller model as well as each model on that controller.
  
  https://jujucharms.com/docs/2.1/models-upgrade
  
  
  ## Questions/Concerns

  
  If you have any questions please don’t hesitate to reach out to the team via:
  
  the #juju Freenode IRC channel
  the juju mailing list https://lists.ubuntu.com/mailman/listinfo/juju
  
  We encourage everyone to let us know how you're using Juju.
  
  Join us at regular Juju shows -
  subscribe to our Youtube channel https://youtube.com/jujucharms

^# Juju 2.1.2

  ## What's new in 2.1.2

  - [conjure-up] headless installs now support cloud regions
  - [conjure-up] improved error handling
  - [juju] Handle 'Node with this Hostname already exists' errors when
    provisioning containers. LP:#1670873
  - [juju] Fix 'interface bindings cannot have empty names' LP:#1671489
  - [juju] Fix 'upgrade-charm broken after using default binding' 
    LP:#1671428


  ## Resolved Issues

  Check the milestones for a detailed breakdown of Juju and conjure-up
  bugs corrected.

    https://github.com/conjure-up/conjure-up/milestone/20?closed=1
    https://launchpad.net/juju/+milestone/2.1.2


  ## How do I get it?

  If you are running Ubuntu, you can get Juju from the juju stable ppa:

    sudo add-apt-repository ppa:juju/stable; sudo apt-get update
    sudo apt-get install juju

  Or install Juju from the snap store:

    snap install juju --classic

  Install conjure-up from the snap store:

    snap install conjure-up --classic

  If you are on Trusty, you'll need to run a few extra commands:

    sudo apt-get install snapd
    sudo groupadd lxd && sudo usermod -a -G lxd $USER
    sudo reboot

  Now you can install snaps, including conjure-up, as normal:

    snap install conjure-up --classic

  Windows, CentOS, and MacOS users can get a corresponding Juju
  installer at:

    https://launchpad.net/juju/+milestone/2.1.2


^# Juju 2.1.1

  ## What's new in 2.1.1

  - Networking improvements
  - [conjure-up] Spells support side-loading bundles. This helps spells
    authors who are writing spells for particular software but want to 
    offer variations. For example, there are OpenStack bundles that 
    support both KVM and LXD, or Telemetry additions. Side-loading will 
    help with spells that need to provide those various bundle 
    configurations.
  - [conjure-up] More LXD improvements in addition to support for the
     recently released LXD 2.10.


  ### Networking improvements

  - containers now respect static routes from MAAS. The static routes
    defined for the subnets that the containers are in should should be
    set for the containers as well.
  - 'lxdbr0' subnet selection has changed from a simple incremental search
    to randomized selection across 10.0.X. It also now properly handles
    when an active subnet spans more than just a /24.
  - better handling of http_proxy and no_proxy when interacting with LXD
  - errors while trying to set up networking for containers are properly
    reported as provisioning errors, instead of falling back to 'lxdbr0'.
    This mostly impacts MAAS deployments where they would end up with
    containers that were not addressable, and the actual failure was
    buried in log files.


  ## Resolved Issues

  Check the milestones for a detailed breakdown of Juju and conjure-up
  bugs corrected.

      https://github.com/conjure-up/conjure-up/milestone/18?closed=1
      https://launchpad.net/juju/+milestone/2.1.1


  ## How do I get it?

  If you are running Ubuntu, you can get Juju from the juju stable ppa:

     sudo add-apt-repository ppa:juju/stable; sudo apt-get update

     sudo apt-get install juju

  Or install Juju from the snap store:

     snap install juju --classic

  Install conjure-up from the snap store:

     snap install conjure-up --classic

  If you are on Trusty, you'll need to run a few extra commands:

     sudo apt-get install snapd
     sudo groupadd lxd && sudo usermod -a -G lxd $USER
     sudo reboot

  Now you can install snaps, including conjure-up, as normal:

     snap install conjure-up --classic

  Windows, CentOS, and MacOS users can get a corresponding Juju
  installer at:

     https://launchpad.net/juju/+milestone/2.1.1


^# Juju 2.1.0

  ## What's new in 2.1.0

  - Model migration
  - Interactive `add-cloud`
  - Networking changes
  - Conjure-up 
  - LXD credential changes
  - Changes to the GUI
  - Instrumentation of Juju via Prometheus endpoints
  - Improved OpenStack keystone v3 authentication
  - New cloud-regions supported
  - Additional improvements


  ### Model migration

  Model migration allows you to easily move a live model from one
  controller to another. The same configuration of machines, units and
  their relationships will be replicated on a secondary controller, while
  your applications continue uninterrupted.

  Migration is a useful alternative to upgrading a controller in place,
  and for moving models off a busy controller. When upgrading a
  controller, you can bootstrap a new controller running a newer version
  of Juju and then migrate each model across one at a time. This is safer
  than upgrading a controller while it is running many applications.

  Currently there are some restrictions:

    - The source and destination controllers need to be in the same cloud
      environment.
    - The destination controller needs to be running on the same cloud
      substrate as the source controller.
    - Destination controllers on different regions or VPCs need direct
      connectivity to the source controller.
    - The version of Juju running on the destination controller needs to
      be the same or newer than the version on the source controller. 
    - The controller model cannot be migrated.

  To migrate a model on the current controller to a model on another
  controller, you simply name the model as the first argument followed by
  the target controller (a model with the same name cannot already exist
  on the target controller):

      juju migrate <model-name> <target-controller-name>

  This will initiate the migration with output similar to the following:

      Migration started with ID "d1924666-1b00-4805-89b5-5ed5a6744426:0"

  You can monitor the migration progress from the output of the juju
  status command run against the source model. The juju show-model command
  also shows migration progress.

  If the migration fails at any point, the model will be reactivated on
  the original controller in the same state it was in before the migration
  process was started. The duration of a migration will depend on the
  complexity of the model, the resources it uses and the capabilities of
  the hosted environment. Most migrations will take minutes, and even
  large deployments are unlikely to take hours.

  When complete, the model will no longer exist on the source controller,
  and the model, all its applications, machines and units will be running
  from the target controller.

  Use `juju switch` to select the migrated model in the destination
  controller:

      juju switch <target controller>:<model>
      juju status

  There is more information on model migration in the Juju documentation
  online at 
  [https://jujucharms.com/docs/2.1/models-migrate](./models-migrate.html)


  ### Interactive `add-cloud`

  With previous versions of Juju, the `add-cloud` command would need to be
  fed a specifically formatted YAML file if your cloud of choice wasn't
  directly supported by Juju. You can still do this, but from version 2.1,
  you can also step through a simple interactive process that will create
  a working configuration for you.

  Typing `juju add-cloud` starts the process and produces the following
  output:

      Cloud Types
        maas
        manual
        openstack
        vsphere
      
      Select cloud type:

  Simply answer the three or four questions for your new cloud and Juju
  will do the rest. The next step is to add credentials for this new
  cloud, which can be done with the similarly interactive command:

      juju add-credentials

  Again, follow the prompts to add the requested information.

  A more detailed walkthrough of the process is published in the online
  Juju documentation here:
  [https://jujucharms.com/docs/2.1/clouds#specifying-additional-clouds](./clouds.html#specifying-additional-clouds)


  ### Networking changes

  A number of changes have been introduced to make the use of networks,
  particularly networking of containers, more efficient and consistent in
  Juju.

  Juju models networks using the primitive of "spaces". A space is made up
  of one or more routable subnets with common ingress and egress rules.
  The operator can model this topology in such a way that applications
  have the required network connectivity without generating network IP
  maps of overwhelming complexity that are not portable.

  The default behaviour in Juju 2.0 was that all machines might host
  containers and so all interfaces were bridged by default, even if a
  container was never placed on the machine. If a container was placed on
  the machine all of the network devices of that machine were made
  available to each container. This led to issues where the operator
  wanted a much cleaner model where the containers only had access to
  networks that the model required. Starting from Juju 2.1 this will no
  longer be true. Juju will only create the bridges which are necessary
  for a container to operate in the model.

  The changes in 2.1 require operators to be more specific about what
  network space a charm should operate in (this is particularly relevant
  to charms deployed to containers on Juju machines) when more than one
  space is available on the machine. Defining what spaces the container is
  required to operate in is is already supported by the '--bind' option of
  the deploy command, which can be used to specify that of the charm
  should operate within the same space, e.g.:

      juju deploy mysql --bind db-space

  ...or, you can specify which charm defined endpoints should end up in
  specific spaces:

      juju deploy mysql --bind "db:db-space db-admin:admin-space default-space"

  ...which also includes a default option for any other interfaces not
  specified.

  These changes potentially impact on currently published bundles. Bundles
  that might have assumed that a container has access to all of the same
  spaces as the host machine will no longer deploy cleanly. They need to
  be updated to be more specific about the bindings required. The above
  deploy commands can be mirrored in bundle format like so:

      mysql:
         charm: "cs:mysql"
         num_units: 1
         bindings:
           “”: default-space
           db: db-space
           db-admin: admin-space

  There is more information on binding to spaces in the online Juju
  documentation
  [https://jujucharms.com/docs/2.1/charms-deploying#deploying-with-binding](./charms-deploying.html#deploying-with-binding)

  Defining spaces within Juju is covered in the documentation here:
  [https://jujucharms.com/docs/2.1/network-spaces](./network-spaces.html)

  Information on adding bindings to charm bundles is also documented online:
  [https://jujucharms.com/docs/2.1/charms-bundles#binding-endpoints-of-applications-within-a-bundle](./charms-bundles.html#binding-endpoints-of-applications-within-a-bundle)

  These changes and the rationale behind them were originally posted to
  the juju-dev mailing list. If you require further background or have
  questions or concerns, please add to the discussion on the mailing list.
  The original post is here:
  <https://lists.ubuntu.com/archives/juju-dev/2017-February/006313.html>


  ### Conjure-up

  Conjure-up, the big-software deployment tool that leverages Juju, has
  seen some major improvements in-line with Juju development. A new
  `conjure-down` command can be used to easily teardown models, and
  there's support for Canonical Kubernetes 1.5.2 and Kubernetes 1.5.2,
  which can be deployed to the local LXD provider. Several ‘big-data’
  spells have been added - see them with ‘conjure-up bigdata’-  and
  there’s a new ‘Architect’ button which allows editing machine placement,
  including allocation to a MAAS machine.

  For more details, take a look at the updated Conjure-up user guide:
  <http://conjure-up.io/docs/en/users/>


  ### [juju] LXD credentials

  Juju now support credentials to access controllers on remote LXD hosts.
  If you are just bootstrapping and adding models on your laptop there is
  no change in workflow, but there is a change if you want to add models
  from another machine.

  Users are now expected to have a "certificate" credential for creating
  LXD models. If you are on the LXD host, bootstrap and add-model will
  both auto-generate a credential as needed, assuming you have access to
  the LXD Unix socket.

  When working with remote users on different machines, LXD-hosted
  controllers need to to manually import the certificate credential from
  the host machine.

  To do this, first run juju autoload-credentials on the LXD host. This
  will generate output similar to the following:

      Looking for cloud and credential information locally...

      1. LXD credential "localhost" (new)
      Select a credential to save by number, or type Q to quit:

  Select the LXD credential (1 in the above example) and you will be asked
  for the name of a cloud to link to this credential. Enter "localhost" to
  specify the local LXD deployment. When the prompt re-appears, type "q"
  to quit. The new certificate credential will have been created.

  To export this certificate credential to a file called
  localhost-credentials.yaml,
  type the following:

      juju credentials localhost --format=yaml > localhost-credentials.yaml

  The output file now needs to be moved to the machine and account that
  requires access to the local LXD deployment. With this file on the
  remote machine, the certificate credential can be imported with the
  following command:

      juju add-credential localhost -f localhost-credentials.yaml


  ### [juju] Instrumentation of Juju via Prometheus endpoints

  Starting with Juju 2.1 each Juju controller provides an HTTPS endpoint
  to expose Prometheus metrics. To feed these metrics into Prometheus, you
  must add a new scrape target to your already installed and running
  Prometheus instance. For this use case, the only constraint on where
  Prometheus is running is that Prometheus must be able to contact the
  Juju controller's API server address/port.

  A more detailed walkthrough of the process is published in the online
  Juju documentation here:
  [https://jujucharms.com/docs/2.1/howto-prometheus](./howto-prometheus.html)


  ### [juju] Changes to the GUI

  The `juju gui` command has changed to improve the user experience. By
  default this command now uses the old 'no-browser' behaviour (i.e. it
  doesn't automatically open the URL in your default web browser) and also
  displays the login credential. There is a new --hide-credential option
  not to show the credential.

  The --no-browser option is supported but deprecated (it is effectively a
  no-op). To bring up a browser, use the --browser option. For example, to
  output the URL and credential, run:

      juju gui

  To print the Juju GUI URL only:

      juju gui --hide-credential

  To open the Juju GUI in the default browser and show admin credential
  used to log into it:

      juju gui --browser

  Juju now supports the new model path based URLs; these replace the URLs
  containing the model UUID. So if you know the owner and name of a model,
  you can easily point a browser to the following location to access the
  GUI for that model:

      https://<controller-ip>:17070/gui/u/<owner>/<modelname>/

  There is more information on using the built-in GUI in the online
  documentation at:
  [https://jujucharms.com/docs/2.1/controllers-gui](./controllers-gui.html)


  ### [juju] Improved Openstack keystone v3 authentication

  Juju now supports authentication for project and domain scopes. The
  following environment variables or ~/.novarc attributes are supported:

  - OS_DOMAIN_NAME
    domain name of the requested domain level authorisation scope
  - OS_USER_DOMAIN_NAME
    domain name of the user
  - OS_PROJECT_DOMAIN_NAME
    domain name of the requested project level authorisation scope
  - OS_DEFAULT_DOMAIN_NAME
    common domain name of the user and project

  The Juju autoload-credentials command may be used to import credential
  attributes from either environment variables or ~/.novarc into the Juju
  credential store.

  See the online Openstack documentation here:
  <https://developer.openstack.org/api-ref/identity/v3/>


  ### [juju] New cloud-regions supported

  Juju supports two more Google region and six more Azure regions:
  - google/us-west1
  - google/asia-northeast1
  - azure/canadacentral
  - azure/canadaeast
  - azure/uksouth
  - azure/ukwest
  - azure/westcentralus
  - azure/westus2


  ### [juju] Additional improvements

  - Manual cloud provisioning now supports CentOS machines
  - Deployments to LXD containers on Xenial use the more performant
    directory backend https://bugs.launchpad.net/juju/+bug/1648513
  - Constraints placed on KVM containers in bundles are honoured
  - Juju SSH improvements for the Windows platform
  - Memory usage improvements
  - Openstack Provider has been updated to support Neutron networking apis
  - New APIs for querying instance types and characteristics available on
    clouds 
  - vSphere provider improvements
  - Model config now supports an "extra-info" field for holding additional
    metadata
  - Stricter rules for validating charm metadata field names to conform to
    data storage requirements. Charm metadata fields can not contain dots
  - Openstack Provider has been updated to support Neutron networking apis
  - New APIs for querying instance types and characteristics available on
    clouds 


  ## Resolved Issues

  - [Juju] KVM containers race with LXD containers and hooks Lp 1664437
  - [Juju] juju2 eating CPU, units in error Lp 1635311
  - [Juju] kill-controller removes machines from migrated model Lp 1648063
  - [Juju] Memory/goroutine leaks Lp 1516669
  - [Juju] memory leak when adding many applications Lp 1653558
  - [Juju] lxd client raw response 'sync' is too noisy Lp 1656243
  - [Conjure-up] headless conjure-up kubernetes-core fails, while GUI does
    work bug Gh 676
  - [Conjure-up] conjure-up isn't properly handling a failed bootstrap
    bug Gh 641
  - [Conjure-up] Conjure-up uses double the deployed hardware when
    deploying openstack-base and kubernetes-core bug maas 2.0
    test-track Gh 553

  Check the milestones for a detailed breakdown of Juju and conjure-up
  bugs corrected.

      https://github.com/conjure-up/conjure-up/milestone/14?closed=1
      https://launchpad.net/juju/+milestone/2.1-rc2 
      https://launchpad.net/juju/+milestone/2.1-rc1
      https://launchpad.net/juju/+milestone/2.1-beta5 
      https://launchpad.net/juju/+milestone/2.1-beta4
      https://launchpad.net/juju/+milestone/2.1-beta3 
      https://launchpad.net/juju/+milestone/2.1-beta2 
      https://launchpad.net/juju/+milestone/2.1-beta1


^# juju 2.0.3

  ## What's new?

  This releases addresses stability and performance issues.

  ## How do I get it?

  If you are running Ubuntu, you can get it from the juju stable ppa:

      sudo add-apt-repository ppa:juju/stable
      sudo apt-get update; sudo apt-get install juju

  Windows, Centos, and MacOS users can get a corresponding installer at:

      https://launchpad.net/juju/+milestone/2.0.3

  ## Resolved issues

    * Improvements to Juju's CPU and memory performance, and overall
  responsiveness.
      Lp 1645729, Lp 1635311, Lp 1651291, Lp 1660087, Lp 1632362, Lp 1639577,
      Lp 1645917

    * Required packages are upgraded with Juju agent upgrades.
      Lp 1637079

    * Better cleanup of resources in OpenStack and manual providers.
      Lp 1642295, Lp 1625624

    * Commands in interactive ssh from windows clients are properly passed.
      Lp 1468752

    See https://launchpad.net/juju/+milestone/2.0.3 for more details.


^# juju 2.0.2

  ## Notable changes

    * This releases addresses stability and performance issues.

  ## Resolved issues

    * Cinder fails with badrequest... "invalid input for field/attribute
      device" Lp 1636648
    * Juju 2.0.1 is not able to bootstrap with nova Lp 1638304
    * [1.9] multiple negative spaces constraints given and rejected by
      maas Lp 1636969
    * Maas machine selected with space in violation of constraint Lp 1636919
    * Openstack provider: if use-floating-ip=true, uses incorrect
      compute api endpoint to determine available floating ips Lp 1638704
    * Restore fails on some openstacks like prodstack Lp 1557726

  For the full list of bugs addressed, see: [https://launchpad.net/juju/+milestone/2.0.2](https://launchpad.net/juju/+milestone/2.0.2).


^# juju 2.0.1

  ## Notable changes

    * Support new AWS region us-east-2
    * Correct OSX Sierra support
    * Update list-models output to show cloud/region vs owner
    * Update model-migrations with support for endpoints, cloud credentials

  ## Resolved issues

    * Vsphere improvements Lp 1623136 and Lp 1629452
    * `use-floating-ip` is not honored from clouds.yaml config Lp 1614239 
    * `bootstrap-timeout` ignored in --config Lp 1619808 
    * `juju show-machines` should show all addresses a machine has Lp 1602840 
    * Juju 2.0 uses random IP for 'PUBLIC-ADDRESS' with MAAS 2.0 Lp 1616098 

  For the full list of bugs addressed, see: [https://launchpad.net/juju/+milestone/2.0.1](https://launchpad.net/juju/+milestone/2.0.1).


^# juju 2.0.0

  ## Notable Changes

  Juju 2.0 is a fundamental step forward from the previous 1.x series,
  introducing significant new features and capabilities, including:

    * Integrated GUI
    * Better cloud management
    * Multi-user support
    * Baked-in knowledge of public clouds
    * Uses LXD for fast and efficient local experience 
    * More efficient Controller/Model arrangement 
    * More intuitive CLI experience

  An overview of these features is discussed below - for full 
  documentation, please visit our docs online at:
  [https://jujucharms.com/docs](https://jujucharms.com/docs/) 

  ### Integrated GUI

  The GUI is now included with your Juju install. To open the GUI run:

        juju gui --show-credentials

  It will open the GUI in your browser and output your credentials to
  the console for logging in. When a new version of the GUI is released to upgrade:

        juju upgrade-gui

  ### Juju 2.0 is co-installable with Juju 1.25

  The directory where Juju stores its working data has changed to
  follow the XDG directory specification. By default, the Juju data
  directory is located at ~/.local/share/juju. You may override this
  by setting the JUJU_DATA environment variable.

  Juju 2.0's data is not compatible with Juju 1.x.
  **Do not** set `JUJU_DATA` to the old `JUJU_HOME` (~/.juju).

  ### New bootstrap and cloud management experience

  This release introduces a new way of bootstrapping and managing clouds
  and credentials that involves less editing of files and makes Juju work
  out of the box with major public clouds like AWS, Azure, Google,
  Rackspace, Joyent, and Cloudsigma.

  Clouds and credentials are managed separately making it easier to
  use different credentials for a single cloud.

  See: https://jujucharms.com/docs/2.0/controllers-creating

  #### LXD cloud support

  Using the LXD cloud is the fastest way to get started with Juju
  locally using secure local containers. Use our getting-started guide
  to setup LXD and start modeling your operations. 

  [https://jujucharms.com/docs/2.0/getting-started](./getting-started.html) 

  #### Public clouds

  To see what clouds are available, use:

        juju clouds

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


  ##### update-clouds command

  Canonical will publish new public cloud data to reflect new
  regions or changed endpoints in the list of public clouds supported
  by Juju. To update your Juju environment, use this:

        juju update-clouds

  The newly downloaded cloud information will be used next time a
  Juju controller is bootstrapped.

  See: [https://jujucharms.com/docs/2.0/clouds](./clouds.html) 


  #### Credential management

  To access your cloud, Juju must be able to authenticate to it.
  Credentials are defined per cloud. Juju can guide you through
  adding a new credential like so: 

        juju add-credential aws

  See: [https://jujucharms.com/docs/2.0/credentials](./credentials.html) 


  #### Manual, MAAS, and OpenStack clouds

  For manual, MAAS, and OpenStack clouds, it is necessary to create a YAML
  file and then run 'juju add-cloud' to add these to Juju.

  Assuming you have a file called "personal-clouds.yaml" detailing an
  OpenStack cloud called "homestack", use this to add the cloud
  to Juju:

        juju add-cloud homestack personal-clouds.yaml

  To bootstrap that OpenStack cloud:

        juju bootstrap homestack

  For more details see [https://jujucharms.com/docs/2.0/clouds](./clouds.html) 


  #### Bootstrap constraints and series

  While bootstrapping, you can now specify constraints for the bootstrap
  machine independently of the constraints used for deployed applications:

        juju bootstrap --constraints mem=2G --bootstrap-constraints "mem=32G cores=4" aws

  You may also specify the operating system series of the bootstrap machine:

        juju bootstrap --bootstrap-series trusty aws


  #### Model configuration at bootstrap

  When bootstrapping, it is sometimes necessary to pass in
  configuration values. You may specify config values as bootstrap
  arguments or via a file:

        juju bootstrap aws --config image-stream=daily

  Values as name pairs take precedence over the content of any file
  specified. Example:

        juju bootstrap aws --config image-stream=daily --config
            /path/to/file

  To specify a different name for the initial hosted model created during bootstrap:

        juju bootstrap aws --default-model mymodel

  ### Shared model config

  Configuration can now be shared between models. The three separate
  commands (get-model-config, set-model-config, and unset-model-config)
  have been collapsed into a single command. 

  New/changed commands relevant to this feature:
    - juju model-config
    - juju controller-config
    - juju show-model
    - juju model-defaults

  The management of hosted model configuration has been improved in several ways:
    - shared config can be defined which will be used for all new models
      unless overridden by the user, either at model creation time using
      --config arguments or using juju model-config later
    - output of juju model-config includes the origin of each attribute
      value ("default", "controller", "region", or "model")
    - output of juju model config only shows configuration relevant to
      controlling the behaviour of a model; 
    - other data, e.g. model name, UUID, cloud type etc are shown using 
      juju show-model
    - controller specific details like api port, certificates etc are now
      available using juju controller-config

  There are 4 sources of model attribute values:
    1. default - hard coded into Juju or the cloud provider
    2. controller - shared by all models created on controller
    3. region - shared by all models running in a given cloud region
    4. model - set by the user

  ##### Model config command examples
  
  When bootstrapping, it is sometimes necessary to pass in configuration
  values. You may specify config values as bootstrap arguments or via a file:

        juju bootstrap aws --config image-stream=daily

  Values as name pairs take precedence over the content of any file specified. Example:

        juju bootstrap aws --config image-stream=daily --config
            /path/to/file

  To specify a different name for the hosted model:

        juju bootstrap aws --default-model mymodel

  An example juju model-config output:

  Attribute                     From     Value
  agent-metadata-url            default  ""
  agent-stream                  model    devel
  agent-version                 model    2.0.0
  apt-ftp-proxy                 default  ""
  ...
      
  Points of note are that:
    - all model attributes are shown, enabling the user to see what values
      are available to be set
    - when a new model is created, the values are forked at that time so
      that any Juju upgrades which come with different hard coded defaults
      do not affect existing models.
    - the FROM value is calculated dynamically so that if a default value
      changes to match the model, the output is adjusted accordingly

  The behaviour of juju model-config --reset has changed. Previously,
  any reset attribute would revert to the empty value. Now, the
  value will revert to the closest inherited value.

  #### Model defaults

  Shared controller config attributes can be specified in the clouds.yaml file. For example:

      clouds:
      lxdtest:
        type: lxd
        config:
          bootstrap-timeout: 900
          set-numa-control-policy: true
          ftp-proxy: http://local

  After deployment the `model-defaults` command allows a user to:
    - set and unset shared controller attributes
    - display the values of shared attributes used when creating models, and
      where those attributes are defined (default, controller, or region)
    - allow shared attributes to be specified for each cloud region (where    
      they exist) instead of just the controller.

  ##### Model default command examples
  
  Retrieve the full set of configuration defaults (some content elided for brevity).
  
      juju model-defaults
  
      Attribute                   Default           Controller
      agent-metadata-url          ""                -
      agent-stream                released          -
      apt-ftp-proxy               ""                -
      ...
      logging-config              ""                <root>=TRACE
      no-proxy                    ""                https://local
      us-east-1                 foobar            -
      us-west-1                 https://foo-west  -
      provisioner-harvest-mode    destroyed         -
      proxy-ssh                   false             -
      resource-tags               ""                -
      ...
      
  Set the default configuration value for all models in the controller for key to value and key2 to value2.
  
      juju model-defaults key=value key2=value2
  
  Retrieve just the value for a single key:
  
      juju model-defaults key
  
      ATTRIBUTE    DEFAULT           CONTROLLER
      key          ""                shrubbery
      us-east-1  value             -
      us-west-1  foobaz            -
  
  Retrieve just the value for a single region:

      juju model-defaults us-east-1
 
      ATTRIBUTE    DEFAULT           CONTROLLER
      key          ""                shrubbery
      us-east-1  value             -
  
  Reset the value of key and key2 to the next closest default value:

      juju model-defaults --reset key,key2
  
  As with model-config values can be reset and set in one command.

      juju model-defaults --reset key key2=value2

  ### Juju controllers
  
  A Juju controller provides the HTTP API to Juju and handles 
  all of the state information for each model running.

  A controller is created by the “juju bootstrap” command. A single
  Juju controller can now manage many Juju models, meaning less
  resources are needed for Juju's management infrastructure than
  with Juju 1.x, and new models can be created instantly.

  Controllers have a name. By default, Juju will name the controller
  after the cloud and region on which it is running:

      juju bootstrap aws
      
      Creating Juju controller "aws-us-east-1" on aws/us-east-1
      …

  It is also possible to give the controller a name:

      juju bootstrap aws prod
   
      Creating Juju controller "prod" on aws/us-east-1
      …

  The relevant controller and model commands are:

        juju bootstrap
        juju controllers
        juju models
        juju switch
        juju add-model
        juju destroy-model
        juju destroy-controller

  To learn about managing controllers and models, see:

  [https://jujucharms.com/docs/2.0/controllers](./controllers.html) 
  [https://jujucharms.com/docs/2.0/models](./models.html) 


  #### Juju GUI in the controller

  The Juju GUI is now included in every Juju controller after
  bootstrapping, eliminating the need to deploy a Juju GUI charm. 

  See: [https://jujucharms.com/docs/controllers-gui](./controllers-gui.html) 


  #### Creating new models

  Controller admin users can create new models without needing to specify
  any additional configuration:

        juju add-model mynewmodel

  In such cases, the new model will inherit the credentials and SSH authorized
  keys of the controller.

  Other users are required to specify a named credential (so that resources
  created by the new model are allocated to the cloud account of the model
  creator):

        juju add-model mynewmodel --credential myAWScreds

  Additional configuration for the new model may also be specified:

        juju add-model --config image-stream=daily


  #### Sharing models

  It is now possible to give other people access to models. Users may be granted
  read, write, or admin access to a model.

  To grant access to a new user they need to be added first
  using the `add-user` command:

        juju add-user jo 

  Grant tracy access to production-cms.

        juju grant tracy write production-cms

  Grant jo admin admin access on staging-cms.

        juju grant jo admin staging-cms 

  Additional command support revoking permissions and disabling users. To learn more, see:
  [https://jujucharms.com/docs/2.0/users](./users.html) 


  ### Controller and model permissions

  A user can be given one of three permission levels on each model in a controller:
  
    * read: The user can log in to the model and obtain status and information about it.
    * write: The user can deploy/delete services and add relations in a model.
    * admin: The user has full control over the model except for controller level 
    actions such as deletion. Model owners can delete their own models.

  Three permission levels have also been added for users on controllers:

    * login: Allows the user to log in to the controller.
    * add-model: Allows the user to create new models.
    * superuser: Allows the user full control over the model 
    (this permission is granted automatically to the creator of a model).
    

  ### Improvements in charms and bundles

  #### Native support for charm bundles

  The Juju 'deploy' command is used to deploy a bundle. A bundle is a
  collection of charms, configuration, and other characteristics that can
  be deployed in a consistent manner. 

  See: [https://jujucharms.com/docs/2.0/charms-bundles](./charms-bundles.html) 


  #### Multi-series charms

  Charms may now declare that they support more than one operating
  system series. Previously a separate version of a charm was required
  for each series. To specify the series to use when deploying a charm,
  use the ‘--series’ flag:

        juju deploy mysql --series trusty

  If '--series' is not specified the default is used. The default series
  for a multi-series charm is the first one specified in the charm metadata.
  If the specified series is not supported by the charm the deploy will abort
  with an error, unless '--force' is used.


  #### Improved local charm deployment

  Local charms and bundles can be deployed directly from their source
  directory. This feature makes it convenient to hack on a charm and
  just deploy it. The feature is also necessary to develop local charms
  supporting multiple series. 

  For example, to deploy a development copy of magic-charm from a local
  repo, targeting the yakkety series:

        juju deploy ./dev/juju/magic-charm --series yakkety

  See: [https://jujucharms.com/docs/2.0/charms-deploying](./charms-deploying.html) 

  Any directory structure can be used, including simply pulling the
  charm source from a version control system, hacking on the code, and
  deploying directly from the local repo.


  #### Resources

  In charms, "resources" are binary blobs that the charm can utilize, and
  are declared in the metadata for the charm. All resources declared will
  have a version stored in the Charm Store, however updates to these can
  be uploaded from an admin's local machine to the controller.


  ##### Change to metadata

  A new clause has been added to metadata.yaml for resources. Resources
  can be declared as follows:

      resources:
        name:
          type: file                         # the only type initially
          filename: filename.tgz
          description: "One line that is useful when operators need to push it."

  ##### New commands related to resources

  To show the resources required by or in use by an
  existing application or unit in your model:


        juju resources

  To upload a file from your local disk to the Juju controller
  to be used as a resource for a application.

        juju push-resource <application> name=<filename>

  #### New charmer concepts

  #####  Charms can declare minimum Juju version

  There is a new (optional) top level field in the metadata.yaml
  file called min-juju-version. If supplied, this value specifies
  the minimum version of a Juju server with which the charm is compatible.

  Note that, at this time, Juju 1.25.x does *not* recognize this
  field, so charms using this field will not be accepted by 1.25
  environments.


  ##### Expansion of the upgrade-charm hook

  Whenever a charm or any of its required resources are updated,
  the 'upgrade-charm' hook will fire. A resource is updated whenever
  a new copy is uploaded to the charm store or controller.


  ##### resource-get

  Use 'resource-get' while a hook is running to get the local
  path to the file for the identified resource. This file is an
  fs-local copy, unique to the unit for which the hook is running.
  It is downloaded from the controller, if necessary.

  #### application-version-set

  Charm authors may trigger this command from any hook to output
  what version of the application is running. This could be a package
  version, for instance postgres version 9.5. It could also be a
  build number or version control revision identifier, for instance
  "git sha 6fb7ba68". The version details will then be displayed in juju status 
  output with the application details.

  Example (within a charm hook): 
    
        application-version-set 9.5.3

  Then application status will show:

      App         Version  Status  Scale  Charm       Store       Rev  OS      Notes
      postgresql  9.5.3    active      1  postgresql  jujucharms  105  ubuntu  

  #### Juju supports Charm Store channels

  Support for channels has been brought into Juju via command options on the
  relevant sub-commands:

        juju deploy
        juju upgrade-charm

  For more information on the new support for channels in the Charm Store
  and how they work, please see our 
  [documentation](./authors-charm-store.html#entities-explained)
  on the subject.

  #### extra-bindings Support for charms metadata

  Many charms use a simple model where a relationship with another charm
  also indicates there is a network connection between units of those
  applications. We have utilized this fact to add a network model that allows
  system operators to control where those TCP connections are made by
  binding the application relation endpoints onto a network space.

  However, some charms specifically use relation endpoints only as a way
  to pass configuration around, and the relations don't map directly to
  applications that are running in that charm and/or networking configuration.
  These charms want to be able to express that they have more networking
  configuration that an operator wants to control without having yet-
  another interface that will never be related to another application.

  Juju solves the aforementioned issues by introducing an optional new
  section in the charm metadata,yaml. The new section is called "extra-
  bindings". Similarly to the peers/provides/requires sections, extra-
  bindings contains a list of names, which can be used with 'juju deploy
  --bind' like relation names. Unlike relations, you don't have to define
  hooks or anything more complex to allow the users of the charm to bind
  those names to Juju spaces.

  #### New hook command: network-get

  When deploying an application with endpoint bindings specified, charm
  authors can use the new "network-get" hook command to determine which
  address to advertise for a given endpoint. This approach will eventually
  replace "unit-get private-address" as well as various other ways to get
  the address to use for a given unit.

  There is currently a mandatory '--primary-address' argument to 'network-
  get', which guarantees a single IP address to be returned.

  Example (within a charm hook): 

      relation-ids cluster
      url:2

      network-get url:2 --primary-address
      10.20.30.23

  (assuming the application was deployed with e.g. --bind url=internal, and
  (10.20.30.0/24 is one of the subnets in that "internal" space).


  ### New spaces support on MAAS 1.9, 2.0, 2.1

  Juju 2.0 now natively supports the spaces API in MAAS 1.9+. Spaces
  are automatically discovered from MAAS (1.9+) on bootstrap and available
  for use with application endpoint bindings or machine provisioning
  constraints (see below). Space discovery works for the controller model
  as well as any model created later using 'juju add-model'.


  #### Binding application endpoints to spaces

  Binding means the "bound" endpoints will have IP addresses from
  subnets that are part of the space the endpoint is bound to.

  Use the optional '--bind' argument when deploying an application to
  specify to which space individual charm endpoints should be bound. The
  syntax for the '--bind' argument is a whitespace-separated list of
  endpoint and space names, separated by "=".

  When `--bind` is not specified, all endpoints will use the same
  address, which is the host machine's preferred private address, as
  returned by "unit-get private-address".
  This is backwards-compatible behaviour.

  Additionally, an application-default space can be specified by omitting
  the `<endpoint>=` prefix before the space name. This space will
  be used for binding all endpoints that are not explicitly specified.

  Examples:

        juju deploy mysql --bind "db=database server=internal"

  Bind "db" endpoint to an address part of the "database" space (i.e. the
  address is coming from one of the "database" space's subnets in MAAS).

        juju deploy wordpress --bind internal-apps

  Bind *all* endpoints of wordpress to the "internal-apps" space.

        juju deploy haproxy --bind "url=public internal"

  Bind "url" to "public", and all other endpoints to "internal".


  ### Provider improvements

  #### LXC local provider no longer available

  With the introduction of the LXD provider (below), the LXC version of
  the local provider is no longer supported.


  #### LXD provider

  The new LXD provider is the best way to use Juju locally. 
  See: [https://jujucharms.com/docs/2.0/clouds-LXD](./clouds-LXD.html) 

  The controller is no longer your host machine; a LXD
  container is created instead. This keeps your host machine clean 
  and allows you to utilize your local controler more like a Juju 
  controller running in any other cloud. This also means you can test
  features like Juju’s  high-availability controllers without needing
  to use a cloud provider.


  ##### Setting up LXD on older series

  LXD has been made available in Trusty backports, but needs manual
  dependency resolution:
          
        sudo apt-get --target-release trusty-backports install lxd

  Before using a locally running LXD after installing it, either through
  Juju or the LXD CLI ("lxc"), you must either log out and back in or run
  this command:
          
        newgrp lxd
                
  See: [https://linuxcontainers.org/lxd/getting-started-cli/](https://linuxcontainers.org/lxd/getting-started-cli/) 


  #### LXD Container Support

  Juju now uses LXD to provide containers when deploying applications. So
  instead of doing:

        juju deploy mysql --to lxc:1

  the new syntax is:

        juju deploy mysql --to lxd:1


  #### Microsoft Azure Resource Manager provider

  Juju now supports Microsoft Azure's new Resource Manager API. The new
  provider supports everything the old provider did, but now also
  supports several additional features, including unit placement,
  which allows you to specify existing machines to which units are
  deployed. As before, units of an application will be allocated to machines
  in a application-specific Availability Set if no machine is specified.

  To add credentials for Azure, run the command `juju add-credential azure`.
  Select the default interactive mode and you will be prompted to enter your
  subscription ID. You can find your subscription ID in the Azure portal
  ([https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade) ).
  You will then be prompted to open a URL to authenticate with Azure,
  and authorise Juju to create credentials on your behalf.


  #### New support for the Rackspace Public Cloud

  A new provider has been added that supports hosting a Juju model in
  Rackspace Public Cloud. Add your credentials for Rackspace with:

        juju add-credential rackspace

  Then bootstrap:

        juju bootstrap rackspace


  #### OpenStack improvements

  ##### New OpenStack machines can be provisioned based on virtualization type (kvm, lxd)

  Openstack clouds with multi-hypervisor support have different images for
  LXD and KVM. Juju can now pick the right image for LXD or KVM instance
  based on the instance constraints:

        juju deploy mysql --constraints="virt-type=lxd,mem=8G,cpu=4"

  ##### Keystone 3 support in OpenStack

  Juju now supports Openstack with Keystone Identity provider V3. Keystone
  3 brings a new attribute to our credentials, "domain-name"
  (OS_DOMAIN_NAME) which is optional. If "domain-name" is present (and
  user/password too) juju will use V3 authentication by default. In other
  cases where only user and password is present, it will query OpenStack
  as to what identity providers are supported, and their endpoints. V3
  will be tried and, if it works, set as the identity provider otherwise it
  will use V2, the previous standard.

  #### Joyent provider no longer uses Manta storage

  The use of Joyent Manta Storage is no longer necessary and has been
  removed. The Manta credential attributes are not supported. `juju add-
  credential` will not prompt for them. Existing credential.yaml files used
  in previous betas will need to be edited to remove: manta-user, manta-
  key-id, manta-url


  ### Misc changes

  #### juju status improvements

  The default Juju status format is now tabular (not yaml). YAML can still
  be output by using the '--format yaml' arguments. The deprecated agent-
  state and associated yaml attributes are now deleted (these have been
  replaced since 1.24 by agent status and workload status attributes).

  The tabular status output now also includes relation information. This
  was previously only shown in the 'yaml' and 'json' output formats.


  ##### Machine provisioning status

  Juju status for machines has a new "machine-status" value in the yaml
  format. This reflects the state of the machine as it is being allocated
  within the cloud. For providers like MAAS, it is possible to see the
  state of the machine as it transitions from allocating to deploying to
  deployed. For containers it also provides extra information about the
  container being created.

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


  #### Juju client support for any Linux

  The Juju 2.0 client works on any Linux flavour. When bootstrapping
  with local tools, it is now possible to create a controller using
  any supported Linux series regardless of the Linux flavour the client
  is running on.


  #### Automatic retries of failed hooks

  Failing hooks are automatically retried with a backoff strategy.
  Backoff increases on each retry by a factor of 2 starting from 5
  seconds and is capped at 5 minutes. (5, 10, ..., 5\*60 seconds)

  A model configuration flag, `automatically-retry-hooks`, is now
  available that will toggle this behaviour. It affects all the units
  running in the same model. By default the flag is true and that
  is the recommended value for regular deployments. 

  #### SSH host key checking

  The SSH host keys of Juju managed machines are now tracked and
  are verified by the juju ssh, scp and debug-hooks commands. This
  ensures that SSH connections established by these commands are
  actually made to the intended hosts.

  Host key checking can be disabled using the new --no-host-key-checks
  option for Juju’s SSH related commands. Routine use of this option
  is strongly discouraged.

  #### Juju logging improvements

  Logs from machine and unit agents are now streamed to controllers
  via API instead of using rsyslogd. This is a requirement of
  multi-model support, which is now enabled by default. Additionally,
  centralised logs are now stored in Juju's database instead of the a
  file. This improves log query flexibility and performance as well as
  opening up the possibility of structured log output in future
  Juju releases.

  The `juju debug-log` command will continue to function as before and
  should be used as the default way of accessing Juju's logs.


  ##### Juju log forwarding

  When enabled, log messages for all hosted models in a controller
  are forwarded to a syslog server over a secure TLS connection.
  The easiest way to configure the feature is to provide a 
  config.yaml file at bootstrap:

        juju bootstrap <cloud>
            --config logforward-enabled=true --config logconfig.yaml

  The contents of the YAML file should currently be as follows:

        syslog-host: <host>:<port>
        syslog-ca-cert: |
        -----BEGIN CERTIFICATE-----
         <cert-contents>
        -----END CERTIFICATE-----
        syslog-client-cert: |
        -----BEGIN CERTIFICATE-----
         <cert-contents>
        -----END CERTIFICATE-----
        syslog-client-key: |
        -----BEGIN PRIVATE KEY-----
         <cert-contents>
        -----END PRIVATE KEY-----

  The feature can be toggled by setting the logforward-enabled
  attribute. When enabled, a maximum of 100 previous log lines
  will be forwarded.
  
  ##### Example syslog message

      <11>1 2016-02-28T09:57:10.804642398-05:00 172.12.3.1 juju - - [origin enterpriseId="28978" software="jujud" "2.0.0"] [model@28978 controller-uuid="deadbeef" model-uuid="deadbeef"] [log@28978 source-file="provider/ec2/storage.go" source-line="60"] Could not initialise machine block storage


  ### Audit logging

  In its initial implementation, audit logging is on by default.
  The audit log will be in /var/log/juju/audit.log for each controller
  machine. If running in an HA environment, the audit.log files on each
  controller machine must be collated to get a complete log. Future
  releases will provide a utility to merge the logs, akin to debug-log.

  Since users may interact with Juju from multiple sources (CLI, GUI,
  deployer, etc.), audit log entries record the API calls made, rather
  than only reporting CLI commands run. Only those API calls originating
  from authenticated users calling the external API are logged.


  #### Enhancements to `juju run`

  `juju run` now works by queueing actions using the name "juju-run".  
  The command line API has not changed.

  A few notes:
  
    * `juju run` is now supported on Windows. The commands are executed through PowerShell.
    * Any actions named `juju-run` defined in the charm will **not** work anymore. The charm build tool will forbid any actions starting with 'juju-' to be defined, similar to relations.
    * Because the commands are now actions, statistics related to queue times, execution times, etc. can be gathered.
    * The specified timeout is only taken into account when actually executing the action and does **not** account for delays that might come from the action waiting to be executed.
    * `show-action-status` also lists actions queued by `juju-run`.
    * To avoid flooding a new flag has been created for `show-action-status`.  You can now use `--name <action-name>` to only get the actions corresponding to a particular name.
    * `show-action-output` can be used to get more information on a
  particular command.


  #### API login with macaroons

  Juju 2.0 supports an alternate API login method based on macaroons. 

  #### Experimental address-allocation feature flag is no longer supported

  In earlier releases, it was possible to have Juju use static IP
  addresses for containers from the same subnet as their host machine,
  using the following development feature flag:

      JUJU_DEV_FEATURE_FLAGS=address-allocation juju bootstrap ...

  This flag is no longer supported and will log a warning message if used.


  #### Mongo 3.2 support

  Juju now uses mongo 3.2 for its database with the new Wired Tiger 
  storage engine enabled. This is initially only supported for 16.04 (Xenial).
  Trusty and Wily will be supported soon.


  ### Terminology

  "environments" are now be referred to as "models" and “services” are
  referred to as “applications”.  Commands which referenced "environments"
  or “services” now reference "models” or “applications” respectively.

  The "state-server" from Juju 1.x is now a "controller" in 2.0.


  ### Command name changes

  Juju commands have moved to a flat command structure instead of nested command structure:

  | 1.25 command                         | 2.0 command                   |
  |--------------------------------------|-------------------------------|
  | juju environment destroy             |juju destroy-model *            
  | juju environment get                 | juju model-config
  | juju environment get-constraints     | juju get-model-constraints 
  | juju environment retry-provisioning  | juju retry-provisioning
  | juju environment set                 | juju model-config 
  | juju environment set-constraints     | juju set-model-constraints
  | juju environment share               | juju grant 
  | juju environment unset               | juju model-config
  | juju environment unshare             | juju revoke
  | juju environment users               | juju users
  | juju user add                        | juju add-user
  | juju user change-password            | juju change-user-password
  | juju user disable                    | juju disable-user
  | juju user enable                     | juju enable-user
  | juju user info                       | juju show-user
  | juju user list                       | juju users
  | juju machine add                     | juju add-machine 
  | juju machine remove                  | juju remove-machine 
  | juju authorised-keys add             | juju add-ssh-key
  | juju authorised-keys list            | juju ssh-keys
  | juju authorised-keys delete          | juju remove-ssh-key
  | juju authorised-keys import          | juju import-ssh-key
  | juju get                             | juju config
  | juju set                             | juju config
  | juju get-constraints                 | juju get-model-constraints
  | juju set-constraints                 | juju set-model-constraints
  | juju get-constraints <application>   | juju get-constraints
  | juju set-constraints <application>   | juju set-constraints
  | juju backups create                  | juju create-backup 
  | juju backups restore                 | juju restore-backup 
  | juju action do                       | juju run-action 
  | juju action defined                  | juju actions 
  | juju action fetch                    | juju show-action-output 
  | juju action status                   | juju show-action-status 
  | juju storage list                    | juju storage 
  | juju storage show                    | juju show-storage 
  | juju storage add                     | juju add-storage 
  | juju space create                    | juju add-space 
  | juju space list                      | juju spaces 
  | juju subnet add                      | juju add-subnet 
  | juju ensure-availability             | juju enable-ha

  * the behaviour of destroy-environment/destroy-model has changed, see
        [https://jujucharms.com/docs/2.0/controllers](./controllers.html) 


  These extra commands were previously under the "jes" developer feature
  flag but are now available out of the box:
  
  | 1.25 command                   | 2.0 command                 |
  |--------------------------------|-----------------------------|
  | juju system create-environment | juju add-model              |
  | juju system destroy            | juju destroy-controller     |
  | juju system environments       | juju models            |
  | juju system kill               | juju kill-controller        |
  | juju system list               | juju controllers       |
  | juju system login              | juju login                  |
  | juju system remove-blocks      | juju enable-commands        |
  | juju system list-blocks        | juju disabled-commands |


  In general:
  
    * commands which list multiple things should start with `list-` and there
      will be an alias for the plural noun in the command, for 
      example ‘list-controllers’ is an alias for ‘controllers’.
    * commands which look at an individual thing will start with `show-`.
    * commands which start with 'remove-' are used for things that can be easily recreated.
    * commands which start with 'destroy-' are used only for controllers and models.

  ### Known issues

    * Juju 2.0 no longer supports KVM for the local provider
      Lp 1547665
    * Cannot deploy a dense openstack bundle with native deploy
      Lp 1555808
    * Credentials files containing Joyent credentials must be updated to
      work with beta3 and later (See "Joyent Provider No Longer Uses Manta   
      Storage")

