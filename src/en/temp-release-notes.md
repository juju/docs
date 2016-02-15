# juju-core 2.0-alpha2

A new development release of Juju, juju-core 2.0-alpha2, is now available.
This release replaces version 2.0-alpha1.


## Getting Juju

juju-core 2.0-alpha2 is available for Xenial and backported to earlier
series in the following PPA:

    https://launchpad.net/~juju/+archive/devel

Windows, Centos, and OS X users will find installers at:

    https://launchpad.net/juju-core/+milestone/2.0-alpha2

Development releases use the "devel" simple-streams. You must configure
the 'agent-stream' option in your environments.yaml to use the matching
juju agents.

Users of AWS, Azure, and Joyent need to set the 'agent-metadata-url'
in environments.yaml to
    agent-metadata-url: https://streams.canonical.com/juju/tools

Upgrading from older releases to this development release is not
supported.


## Notable Changes

* Terminology
* Command Name Changes
* New Juju home directory
* Multi-Model Support Active by Default
* Native Support for Charm Bundles
* Multi Series Charms
* Improved Local Charm Deployment
* LXC Local Provider No Longer Available
* LXD Provider
* Microsoft Azure Resource Manager Provider
* Bootstrap Constraints, Series
* MAAS Spaces
* Juju Logging Improvements
* Unit Agent Improvements
* API Login with Macaroons
* Juju Status Improvements
* Relation get And set Compatibility
* Known Issues


### Terminology

In Juju 2.0, environments will now be referred to as "models".  Commands
which referenced "environments" will now reference "models".  Example:

    juju get-environment

will become

    juju get-model


The "state-server" from Juju 1.x becomes a "controller" in 2.0.


### Command Name Changes

After a while experimenting with nested command structures, the decision
was made to go back to a flat command namespace as the nested commands
always felt clumsy and awkward when being used even though they seemed
like a good idea.

So, we have the following changes:
```
1.25 command                           2.0-alpha1 command

juju environment destroy              juju destroy-model * ***
juju environment get                  juju get-model ** ***
juju environment get-constraints      juju get-model-constraints **
juju environment retry-provisioning   juju retry-provisioning
juju environment set                  juju set-model ** ***
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
```
* the behaviour of destroy-environment/destroy-model has changed,
see the section on controllers below
** these commands existed at the top level before but become the
recommended approach again.
*** alias, but primary name going forward.

And for the extra commands previously under the "jes" feature flag but
now available out of the box:
```
juju system create-environment         juju create-model
juju system destroy                    juju destroy-controller
juju system environments               juju list-models
juju system kill                       juju kill-controller
juju system list                       juju list-controllers
juju system list-blocks                juju list-all-blocks
juju system login                      juju login
juju system remove-blocks              juju remove-all-blocks
juju system use-environment            juju use-model
```
Fundamentally, listing things should start with 'list-', and looking at
an individual thing should start with 'show-'. 'remove' is generally
used for things that can be easily added back, whereas 'destroy' is used
when it is not so easy to add back.


### New Juju Home Directory

The directory where Juju stores its working data has changed. We now
follow the XDG directory specification. By default, the Juju data
(formerly home) directory is located at ~/.local/share/juju. This may be
overridden by setting the JUJU_DATA environment variable.

Juju 2.0's data is not compatible with Juju 1.x. Do not set JUJU_DATA to
the and old JUJU_HOME (~/.juju).


### Multi-Model Support Active by Default

The multiple model support that was previously behind the "jes"
developer feature flag is now enabled by default. Along with the
enabling there

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
    juju share-model
    juju list-shares
    juju use-model

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
forcibly taking down a controller could leave other models running
with no way to talk to an API server.


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


### LXC Local Provider No Longer Available

With the introduction of the LXD provider (below), the LXC version of
the Local Provider is no longer supported.


### LXD Provider

The new LXD provider is the best way to use Juju locally.

The controller is no longer your host machine; it is now a LXC
container. This keeps your host machine clean and allows you to utilize
your local model more like a traditional Juju model. Because of this,
you can test things like Juju high-availability without needing to
utilize a cloud provider.

The previous local provider remains functional for backwards
compatibility.


#### Requirements

- Running Wily (LXD is installed by default)

- Import the LXD cloud-images that you intend to deploy and register
  an alias:

      lxd-images import ubuntu trusty --alias ubuntu-trusty
      lxd-images import ubuntu wily --alias ubuntu-wily
      lxd-images import ubuntu xenial --alias ubuntu-xenial

  or register an alias for your existing cloud-images

      lxc image alias create ubuntu-trusty <fingerprint>
      lxc image alias create ubuntu-wily <fingerprint>
      lxc image alias create ubuntu-xenial <fingerprint>

- For 2.0-alpha1, you must specify the "--upload-tools" flag when
  bootstrapping the controller that will use trusty cloud-images.
  This is because most of Juju's charms are for Trusty, and the
  agent-tools for Trusty don't yet have LXD support compiled in.

    juju bootstrap --upload-tools

"--upload-tools" is not required for deploying a wily or xenial
controller and services.

Logs are located at '/var/log/lxd/juju-{uuid}-machine-#/ ?


#### Specifying a LXD Controller

In your ~/.local/share/juju/environments.yaml, you'll now find a block
for LXD providers:

    lxd:
        type: lxd
        # namespace identifies the namespace to associate with containers
        # created by the provider.  It is prepended to the container names.
        # By default the controller's name is used as the namespace.
        #
        # namespace: lxd
        # remote-url is the URL to the LXD API server to use for managing
        # containers, if any. If not specified then the locally running LXD
        # server is used.
        #
        # Note: Juju does not set up remotes for you. Run the following
        # commands on an LXD remote's host to install LXD:
        #
        #   add-apt-repository ppa:ubuntu-lxc/lxd-stable
        #   apt-get update
        #   apt-get install lxd
        #
        # Before using a locally running LXD (the default for this provider)
        # after installing it, either through Juju or the LXD CLI ("lxc"),
        # you must either log out and back in or run this command:
        #
        #   newgrp lxd
        #
        # You will also need to prepare the cloud images that Juju uses:
        #
        #   lxc remote add images images.linuxcontainers.org
        #   lxd-images import ubuntu trusty --alias ubuntu-trusty
        #   lxd-images import ubuntu wily --alias ubuntu-wily
        #   lxd-images import ubuntu xenial --alias ubuntu-xenial
        #
        # See: https://linuxcontainers.org/lxd/getting-started-cli/
        #
        # remote-url:
        # The cert and key the client should use to connect to the remote
        # may also be provided. If not then they are auto-generated.
        #
        # client-cert:
        # client-key:


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

The basic config options in your environments.yaml will look like this:

    rackspace:
        type: rackspace
        tenant-name: "<your tenant name>"
        region: <IAD, DFW, ORD, LON, HKG, or SYD>
        auth-url: https://identity.api.rackspacecloud.com/v2.0
        auth-mode: <userpass or keypair>
        username: <your username>
        password: <secret>
        # access-key: <secret>
        # secret-key: <secret>

The values in angle brackets need to be replaced with your rackspace
information.

'tenant-name' must contain the rackspace Account Number. 'region' must
contain rackspace region (IAD, DFW, ORD, LON, HKG, SYD). 'auth-mode'
parameter can contain either 'userpass' or 'keypair'. This parameter
distinguish the authentication mode that provider will use. If you use
'userpass' mode you must also provide 'username' and 'password'
parameters.  If you use 'keypair' mode 'access-key' and 'secret-key'
parameters must be  provided.


### Bootstrap Constraints, Series

While bootstrapping, you can now specify constraints for the bootstrap
machine independently of the service constraints:

    juju bootstrap --constraints <service-constraints>
        --bootstrap-constraints <bootstrap-machine-constraints>

You can also specify the series of the bootstrap machine:

    juju bootstrap --bootstrap-series trusty


### MAAS Spaces

Spaces are automatically discovered from MAAS (1.9+) on bootstrap and
available for binding or deployment.

Currently there is no command to update the spaces in Juju if the MAAS
spaces change. This command will be added shortly. Juju automatically
updates its definitions when the controller starts, so forcing a restart
of the controller is a workaround.


### Juju Logging Improvements

Logs from Juju's machine and unit agents are now streamed to the Juju
controllers over the Juju API in preference to using rsyslogd. This is
more robust and is a requirement now that multi-model support is enabled
by default. Additionally, the centralised logs are now stored in Juju's
database instead of the all-machines.log file. This improves log query
flexibility and performance as well as opening up the possibility of
structured log output in future Juju releases.

Logging to rsyslogd is currently still in place with logs being sent
both to rsyslogd and Juju's DB. Logging to rsyslogd will be removed
before the final Juju 2.0 release.

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


### Juju Status Improvements

The default Juju status format is now tabular (not yaml). Yaml can still
be output by using the '--format yaml' arguments. The deprecated agent-
state and associated yaml attributes are now deleted (these have been
replaced since 1.24 by agent status and workload status attributes).

The tabular status output now also includes relation information. This
was previously only shown in the yaml and json output formats.


### Relation get-config And set-config Compatibility

See https://bugs.launchpad.net/juju-core/+bug/1382274

If 'juju get-config' is used to save YAML output to a file, the same
file can now be used as input to 'juju set-config'. The functions are
now reciprocal such that the output of one can be used as the input of
the other with no changes required, so that:
1. complex configuration data containing multiple levels of quotes can
be modified via YAML without needing to be escaped on shell command
lines, and
2. large amounts of config data can be transported from one juju model
to another in a trivial fashion.


### Known issues
  * GUI and Landscape don’t work with this alpha 2 release
    As we transition to using the new "controller" and "model" related
    terminology, and remove deprecated APIs, for this release only
    downstream products like the GUI, Landscape (and anything else using
    the Python Juju Client) will not work. Please continue to use the
    alpha 1 release found in ppa:juju/experimental.

  * Some providers release wrong resources when destroying hosted models
    Lp 1536792

  * Destroying a hosted model in the local provider leaves the
    controller unusable
    Lp 1534636

  * Unable to create hosted environments with MAAS provider
    Lp 1535165


## Resolved issues

  * Agent install dies randomly on azure
    Lp 1533275

  * Unable to create hosted models with maas provider
    Lp 1535165

  * Jujud offers poodle vulnerable sslv3 on 17070
    Lp 1536269

  * Fslock staleness checks are broken
    Lp 1536378

  * Get and set are not reciprocal
    Lp 1382274

  * Provider/maas: data races
    Lp 1497802

  * Destroyed leader, new leader not elected.
    Lp 1511659

  * Bootstrap node does not use the proxy to fetch tools from
    streams.c.c
    Lp 1515289

  * Metadata worker repeatedly errors on new azure
    Lp 1533896

  * Status format should default to tabular in 2.0
    Lp 1537717

  * Juju deploy <bundle> silently ignores most cli flags
    Lp 1540701

  * Provider/maas: race in launchpad.net/gomaasapi
    Lp 1468972


Finally

We encourage everyone to subscribe the mailing list at
juju-dev@lists.canonical.com, or join us on #juju-dev on freenode.
