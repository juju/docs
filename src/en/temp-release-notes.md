# Juju 2.0-beta16

A new development release of Juju, juju 2.0-beta16, is now available.
This release replaces version 2.0-beta15.

## What's New in Beta16
* debug-log usability changes
 - only tails by default when running in a terminal
    --no-tail can be used to not tail from a terminal
    --tail can be used for force tailing when not on a terminal
  - time output now defaults to local time (--utc flag added to show times in utc)
  - filename and line number no longer shown by default (--location flag added to include location in the output)
 - dates no longer shown by default (--date flag added to include dates in output)
 --ms flag added to show timestamps to millisecond precision
 - severity levels and location now shown in color in the terminal
 --color option to force ansi color codes to pass to 'less -R'
* controllers models, and users commands now show current controller and model respectively using color as well as the asterix
* removal of smart formatter for CLI commands. Where 'smart' used to be the default, now it is 'yaml'.
* controllers, models, and users commands now print the access level users have against each model/controller
* juju whoami command prints the current controller/model/logged in user details
* fix for LXD image aliases so that the images auto update (when bootstrapping a new LXD cloud, images will be downloaded again the first time, even if existing ones exist)
* new controller and model permissions

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
* Automatic Retries of Failed Hooks
* Enhancements to juju run
* SSH Host Key Checking
* Config can be included in clouds.yaml
* Juju log forwarding
* Audit logging
* Controller and Model permissions
* New hook command: application-version-set
* Shared Model Config
* Known Issues


### Terminology

In Juju 2.0, "environments" will now be referred to as "models" and “services” will be referred to as “applications”.  Commands
which referenced "environments" or “services” will now reference "models” or “applications” respectively.

The "state-server" from Juju 1.x becomes a "controller" in 2.0.


### Command Name Changes

Juju commands have moved to a flat command structure instead of nested command structure:

| 1.25 command                          | 2.0-beta command |
| --- | --- |
| juju environment destroy              | juju destroy-model * *** |
| juju environment get                  | juju get-model-config *** |
| juju environment get-constraints      | juju get-model-constraints ** |
| juju environment retry-provisioning   | juju retry-provisioning |
| juju environment set                  | juju set-model-config *** |
| juju environment set-constraints      | juju set-model-constraints ** |
| juju environment share                | juju share-model *** |
| juju environment unset                | juju unset-model ** *** |
| juju environment unshare              | juju unshare-model *** |
| juju environment users                | juju list-shares |
| juju user add                         | juju add-user |
| juju user change-password             | juju change-user-password |
| juju user credentials                 | juju get-user-credentials |
| juju user disable                     | juju disable-user |
| juju user enable                      | juju enable-user |
| juju user info                        | juju show-user |
| juju user list                        | juju list-users |
| juju machine add                      | juju add-machine ** |
| juju machine remove                   | juju remove-machine ** |
| \<new in 2.0\>                        | juju list-machines |
| \<new in 2.0\>                        | juju show-machines |
| juju authorised-keys add              | juju add-ssh-key |
| juju authorised-keys list             | juju list-ssh-keys |
| juju authorised-keys delete           | juju remove-ssh-key |
| juju authorised-keys import           | juju import-ssh-key |
| juju get                              | juju get-config |
| juju set                              | juju set-config |
| juju get-constraints                  | juju get-model-constraints |
| juju set-constraints                  | juju set-model-constraints |
| juju get-constraints <application>    | juju get-constraints |
| juju set-constraints <application>    | juju set-constraints |
| juju backups create                   | juju create-backup *** |
| juju backups restore                  | juju restore-backup *** |
| juju action do                        | juju run-action *** |
| juju action defined                   | juju list-actions *** |
| juju action fetch                     | juju show-action-output *** |
| juju action status                    | juju show-action-status *** |
| juju storage list                     | juju list-storage *** |
| juju storage show                     | juju show-storage *** |
| juju storage add                      | juju add-storage *** |
| juju space create                     | juju add-space *** |
| juju space list                       | juju list-spaces *** |
| juju subnet add                       | juju add-subnet *** |
| juju ensure-availability              | juju enable-ha *** |

\* the behaviour of destroy-environment/destroy-model has changed, see
https://jujucharms.com/docs/devel/controllers
\*\* these commands existed but are now the recommended approach
\*\*\* this is an alias, but will be the primary command going forward

These extra commands were previously under the "jes" developer feature
flag but are now available out of the box:

| 1.25 command                         | 2.0-beta command |
| --- | --- |
| juju system create-environment       | juju add-model |
| juju system destroy                  | destroy-controller |
| juju system environments             | juju list-models |
| juju system kill                     | juju kill-controller |
| juju system list                     | juju list-controllers |
| juju system list-blocks              | juju list-all-blocks |
| juju system login                    | juju login |
| juju system remove-blocks            | juju remove-all-blocks |
| juju system use-environment          | juju use-model |

In general:
* listing things should start with 'list-'
* looking at an individual thing should start with 'show-'
* 'remove' is used for things that can be easily added back
* 'destroy' is used when it is not so easy to add back


### New Juju Data Directory

The directory where Juju stores its working data has changed to
follow the XDG directory specification. By default, the Juju data
directory is located at ~/.local/share/juju. You may
override this by setting the JUJU_DATA environment variable.

Juju 2.0's data is not compatible with Juju 1.x.
Do not set `JUJU_DATA` to the old `JUJU_HOME` (~/.juju).


### Multi-Model Support Active by Default

The multiple model support that was previously available using
the "jes" developer feature flag is now enabled by default.

A new concept has been introduced, that of a "controller".

A Juju controller, sometimes called the "controller model",
is the model that runs and manages the Juju API servers and the
underlying database.

The controller model is what is created when the bootstrap command is
used. This controller model is a normal Juju model that just happens to
manage Juju. A single Juju controller can manage many
Juju models, meaning less resources are needed for Juju's management
infrastructure and new models can be created almost instantly.

In order to keep a clean separation of concerns, it is now considered
best practice to create additional models for deploying workloads,
leaving the controller model responsible only for Juju's own
infrastructure. Applications can still be deployed to the controller model,
but it is generally expected that these be only for management and
monitoring purposes, such as Landscape or Nagios.

When creating a Juju controller that is going to be used by more than
one person, it is good practice to create users for each individual that
will be accessing the models. See the Sharing Models section for more info.

The main new commands of note are:

    juju list-models
    juju add-model
    juju grant
    Juju revoke
    juju list-shares
    juju use-model 
    juju list-users
    juju switch-user

See also:
    juju help controllers
    juju help users
    https://jujucharms.com/docs/devel/controllers


### New Bootstrap and Cloud Management Experience

This release introduces a new way of bootstrapping and managing clouds
and credentials that involves less editing of files and makes Juju work
out of the box with major public clouds like AWS, Azure, Joyent,
Rackspace, Google, Cloudsigma.

There is no environments.yaml file to edit. Instead, clouds and
credentials are defined in separate files, and the only cloud
information that requires editing is for private MAAS and OpenStack
deployments.

See: https://jujucharms.com/docs/devel/controllers-creating


#### Public Clouds

To see what clouds are available, use:

    juju list-clouds

      CLOUD              TYPE        REGIONS
      aws                ec2         us-east-1, us-west-1, us-west-2, ...
      aws-china          ec2         cn-north-1
      aws-gov            ec2         us-gov-west-1
      azure              azure       japanwest, centralindia, eastus2, ...
      azure-china        azure       chinaeast, chinanorth
      cloudsigma         cloudsigma  mia, sjc, wdc, zrh, hnl
      google             gce         us-east1, us-central1, ...
      joyent             joyent      us-east-1, us-east-2, us-east-3, ...
      rackspace          rackspace   lon, syd, hkg, dfw, ord, iad

See: https://jujucharms.com/docs/devel/clouds


#### Update Clouds Command

Canonical will from time to time publish new public cloud data to
reflect new regions or changed endpoints in the list of public clouds
supported by Juju. To use the updated information in your Juju
environment, use this:

    juju update-clouds

If there is new cloud information available, this information will then
be used next time a Juju controller is bootstrapped.

See: https://jujucharms.com/docs/devel/clouds


#### Credential Management

In order to access your cloud, Juju must be able to authenticate to it. Credentials are managed in a credentials.yaml file located in
~/.local/share/juju. Credentials are per cloud. This is where it is also
possible to define the default region to use for a cloud if none is
specified when bootstrapping.

See: https://jujucharms.com/docs/devel/credentials


#### Managing Controllers and Models

To learn about managing controllers and models, see:
https://jujucharms.com/docs/devel/controllers
https://jujucharms.com/docs/devel/models


#### LXD, Manual, and MAAS Providers 

To bootstrap models using the LXD, manual, and MAAS providers, see the special clouds section of: https://jujucharms.com/docs/devel/clouds


#### Private Clouds

For MAAS and OpenStack clouds, it is necessary to edit a clouds.yaml
file and then the juju add-cloud command to add these to Juju.

Assuming you a file called "personal-clouds.yaml" detailing an
OpenStack cloud called "homestack", use this to add the cloud
to Juju:

   juju add-cloud homestack personal-clouds.yaml

To bootstrap that OpenStack cloud:

    juju bootstrap mycontroller homestack


#### Model Configuration at Bootstrap

When bootstrapping, it is sometimes also necessary to pass in
configuration values. These was previously done via the
environments.yaml file. For this release, you can specify config
values as bootstrap arguments or via a file:

    juju bootstrap

        mycontroller aws/us-west-2
        --config key1=value1 --config key2=value2 --config /path/to/file

Values as name pairs take precedence over the content of any file
specified. Example:

    juju bootstrap mycontroller aws --config image-stream=daily

To specify a different name for the hosted model:

  juju bootstrap mycontroller aws --default-model mymodel


#### Creating New Models

Controller admin users can create new models without needing to specify
any additional configuration:

  juju add-model mynewmodel

In such cases, the new model will inherit the credentials and authorized
ssh keys of the admin model.

Where a cloud requires credentials, non-admin users, and admin users if
they wish, are required to specify a named credential (so that resources
created by the new model are allocated to the cloud account of the model
creator), as well as authorized keys:

  juju add-model mynewmodel --credential mysecrets
    --config authorized-keys="ssh-rsa ...."

Additional model config just for the new model may also be specified:

  juju add-model --config image-stream=daily


#### Sharing Models

It is now possible to give other people read-only or read and
write access to your models, even if that user did not previously
have the ability to login to the controller hosting the model. To learn more, see:
https://jujucharms.com/docs/devel/users
https://jujucharms.com/docs/devel/users-auth
https://jujucharms.com/docs/devel/users-creating
https://jujucharms.com/docs/devel/users-manage

### Joyent Provider No Longer Uses Manta Storage

The use of Joyent Manta Storage is no longer necessary and has been
removed. The Manta credential attributes are not supported. `juju add-
credential` will not prompt for them. Existing credential.yaml files used
in previous betas will need to be edited to remove: manta-user, manta-
key-id, manta-url


### Native Support for Charm Bundles

The Juju 'deploy' command can now deploy a bundle. A bundle is a
collection of charms that together create an entire system. The 
Juju Quickstart or Deployer plugins are no longer needed to deploy
a bundle of charms. See: https://jujucharms.com/docs/devel/charms-bundles


### Multi Series Charms

Charms now have the capability to declare that they support more than
one series. Previously a separate copy of the charm was required for
each series.


### Juju GUI in the Controller

Juju GUI is now automatically included in every Juju controller after
bootstrapping, thus eliminating the need to deploy a Juju
GUI charm. See: https://jujucharms.com/docs/devel/controllers-gui


### Improved Local Charm Deployment

Local charms and bundles can be deployed directly from their source
directory without having to set up a pre-determined local repository file
structure. This feature makes it more convenient to hack on a charm and
just deploy it. The feature is also necessary to develop local charms
supporting multiple series. See: https://jujucharms.com/docs/devel/charms-deploying

Note that it is no longer necessary to define a JUJU_REPOSITORY nor
locate the charms in a directory named after a series. Any directory
structure can  be used, including simply pulling the charm source from a
version control system, hacking on the code, and deploying directly from the local repo.


### Mongo 3.2 Support

Juju will now use mongo 3.2 for its database, with the new Wired Tiger
storage engine enabled. This is initially only when bootstrapping on
Xenial. Trusty and Wily will be supported soon.


### LXC Local Provider No Longer Available

With the introduction of the LXD provider (below), the LXC version of
the Local Provider is no longer supported.


### LXD Provider

The new LXD provider is the best way to use Juju locally. See: https://jujucharms.com/docs/devel/clouds-LXD

The controller is no longer your host machine; it is now a LXC
container. This keeps your host machine clean and allows you to utilize
your local model more like a traditional Juju model. Because
of this, you can test things like Juju high-availability without needing
to utilize a cloud provider.

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

Juju now uses LXD to provide containers when deploying applications. So
instead of doing:

    juju deploy mysql --to lxc:1

the new syntax is:

    juju deploy mysql --to lxd:1


### Microsoft Azure Resource Manager Provider

Juju now supports Microsoft Azure's new Resource Manager API. The Azure
provider has effectively been rewritten, but old models are still
supported. To use the new provider support, you must bootstrap a new
model with new configuration. There is no automated method for
migrating.

The new provider supports everything the old provider did, but now also
supports several additional features, including unit placement,
which allows you to specify existing machines to which units are
deployed. As before, units of an application will be allocated to machines
in a application-specific Availability Set if no machine is specified.

In the initial release of this provider, each machine will be allocated
a public IP address. In a future release, we will only allocate public
IP addresses to machines that have exposed applications, to enable
allocating more machines than there are public IP addresses.


### New Support for Rackspace

A new provider has been added that supports hosting a Juju model in
Rackspace Public Cloud. As Rackspace Cloud is based on OpenStack,
most of the features and configuration options for those two 
providers are identical.


### Bootstrap Constraints, Series

While bootstrapping, you can now specify constraints for the bootstrap
machine independently of the application constraints:

    juju bootstrap --constraints <application-constraints> 
        --bootstrap-constraints <bootstrap-machine-constraints>

You can also specify the series of the bootstrap machine:

    juju bootstrap --bootstrap-series trusty


### Juju Logging Improvements

Logs from Juju's machine and unit agents are now streamed to the Juju
controllers over the Juju API instead of using rsyslogd. This is
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

Worker lifecycle management in the unit agent has been improved.
The resource dependencies (API connections, locks, etc.) shared among
concurrent workers that comprise the agent are now well-defined, modeled
and coordinated by an engine, in a design inspired by Erlang supervisor
trees.

This improves the long-term testability of the unit agent, and should
improve the agent's resilience to failure. This work also allows hook
contexts to execute concurrently, which supports features in development
targeting 2.0.


### Experimental address-allocation feature flag is no longer supported

In earlier releases, it was possible to get Juju to use static IP
addresses for containers from the same subnet as their host machine,
using the following development feature flag:

    JUJU_DEV_FEATURE_FLAGS=address-allocation juju bootstrap ...

This flag is no longer supported and will log a warning message if used.


### New Openstack machines can be provisioned based on virtualisation type (kvm, lxd)

Openstack clouds with multi-hypervisor support have different images for
LXD and KVM. Juju can now pick the right image for LXD or KVM instance
based on the instance constraints:

    juju deploy mysql --constraints="virt-type=lxd,mem=8G,cpu=4"


### Support for MAAS 1.9+ Spaces and Related APIs

Juju 2.0 now natively supports the new spaces API in MAAS 1.9+. Spaces
are automatically discovered from MAAS (1.9+) on bootstrap and available
for use with application endpoint bindings or machine provisioning
constraints (see below). Space discovery works for the controller model
as well as any model created later using 'juju add-model'.

Currently there is no command to update the spaces in Juju if their
corresponding MAAS spaces change. As a workaround, restarting the
controller machine agent (jujud) discovers any new spaces.


#### Binding Application Endpoints to Spaces

Binding means the "bound" endpoints will have IP addresses from
subnets that are part of the space the endpoint is bound to.

Use the optional '--bind' argument when deploying an application to
specify to which space individual charm endpoints should be bound. The
syntax for the '--bind' argument is a whitespace-separated list of
endpoint and space names, separated by "=".

When '--bind' is not specified, all endpoints will use the same
address, which is the host machine's preferred private address, as
returned by "unit-get private-address". This is backwards-compatible behaviour.

Additionally, an application-default space can be specified by omitting
the "<endpoint>=" prefix before the space name. This space will
be used for binding all endpoints that are not explicitly specified.

Examples:

    juju deploy mysql --bind "db=database server=internal"

Bind "db" endpoint to an address part of the "database" space (i.e. the
address is coming from one of the "database" space's subnets in MAAS).

    juju deploy wordpress --bind internal-apps

Bind *all* endpoints of wordpress to the "internal-apps" space.

    juju deploy haproxy --bind "url=public internal"

Bind "url" to "public", and all other endpoints to "internal".


#### Binding Endpoints of Applications Within a Bundle to Spaces

Bindings can be specified for applications within a bundle the same way as
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

There is currently no way to declare an application-default space for all
endpoints in a bundle's bindings section. A workaround is to list all
endpoints explicitly.


#### New Hook Command: network-get

When deploying an application with endpoint bindings specified, charm authors can use the new "network-get" hook command to determine which address to advertise for a given endpoint. This approach will eventually replace "unit-get private-address" as well as various other ways to get the
address to use for a given unit.

There is currently a mandatory '--primary-address' argument to 'network-
get', which guarantees a single IP address to be returned.

Example (within a charm hook): 

    relation-ids cluster
    url:2

    network-get -r url:2 --primary-address
    10.20.30.23

(assuming the application was deployed with e.g. --bind url=internal, and
(10.20.30.0/24 is one of the subnets in that "internal" space).


#### Multiple Positive and Negative Spaces Supported in Constraints

Earlier releases which introduced spaces constraints ignored all but the
first positive space in the list. The AWS provider still does
this, but for MAAS deployments all spaces constraints are applied for
machine selection, positives and negatives.

Example:

    juju add-machine --constraints spaces=public,internal,^db,^admin

When used on a MAAS-based model, Juju will select a machine which has
access to both "public" and "internal" spaces, but neither the "db" or
"admin" spaces.


#### Mediawiki Demo Bundle Using Bindings

A customised version of the mediawiki bundle[1] that deploys haproxy,
mediawiki and mysql has been created. Traffic between haproxy and
mediawiki is on a space called "internal" and traffic between
mediawiki and mysql is in a space called "db". The haproxy website
endpoint is bound to the "public" space.

[1] - http://juju-sapphire.github.io/MAAS%20Spaces%20Demo/


### Resources

In Charms, "resources" are binary blobs that the charm can utilize, and
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

    usage: juju list-resources [options] application-or-unit
    
    This command shows the resources required by and those in use by an
    existing application or unit in your model.

2.  juju push-resource

    usage: juju push-resource [options] application name=file
    
    This command uploads a file from your local disk to the juju
    controller to be used as a resource for a application.

3. juju charm list-resources

    usage: juju charm [options] <command> ...

    "juju charm" is the the juju CLI equivalent of the "charm" command
    used by charm authors, though only applicable functionality is
    mirrored.


#### New Charmer Concepts

##### Expansion of the upgrade-charm hook

Whenever a charm or any of its required resources are updated, the
'upgrade-charm' hook will fire. A resource is updated whenever a new
copy is uploaded to the charm store or controller


##### resource-get

Use 'resource-get' while a hook is running to get the local path
to the file for the identified resource. This file is an fs-local
copy, unique to the unit for which the hook is running. It is
downloaded from the controller, if necessary.

##### Charms can declare minimum Juju version

There is a new (optional) top level field in the metadata.yaml file
called min-juju-version. If supplied, this value specifies the minimum
version of a Juju server with which the charm is compatible.

Note that, at this time, Juju 1.25.x does *not* recognize this field, so
charms using this field will not be accepted by 1.25 environments.


### Juju Status Improvements

The default Juju status format is now tabular (not yaml). Yaml can still
be output by using the '--format yaml' arguments. The deprecated agent-
state and associated yaml attributes are now deleted (these have been
replaced since 1.24 by agent status and workload status attributes).

The tabular status output now also includes relation information. This
was previously only shown in the yaml and json output formats.


#### Machine provisioning status

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


### Relation get-config and set-config compatibility

If 'juju get-config' is used to save YAML output to a file, the same
file can now be used as input to 'juju set-config'. The functions are
now reciprocal such that the output of one can be used as the input of
the other with no changes required, so that:

1. complex configuration data containing multiple levels of quotes can
be modified via YAML without needing to be escaped on shell command
lines, and

2. large amounts of config data can be transported from one
juju model to another in a trivial fashion.

See https://bugs.launchpad.net/juju-core/+bug/1382274


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

Support for channels has been brought into Juju via command options on the
relevant sub-commands:

    juju deploy
    Juju upgrade-charm

For more information on the new support for channels in the Charm Store
and how they work, please see our
[documentation](https://jujucharms.com/docs/devel/authors-charm-store#entities-explained)
on the subject.


### Keystone 3 support in Openstack.

Juju now supports Openstack with Keystone Identity provider V3. Keystone
3 brings a new attribute to our credentials, "domain-name"
(OS_DOMAIN_NAME) which is optional. If "domain-name" is present (and
user/password too) juju will use V3 authentication by default. In other
cases where only user and password is present, it will query Openstack
as to what identity providers are supported, and their endpoints. V3
will be tried and, if it works, set as the identity provider otherwise it
will use V2, the previous standard.


### Accurate Address Selection Based on Network Spaces (in MAAS)

MAAS 1.9+ offers native support for Network Spaces, which Juju will
discover and import. This means Juju knows which space any machine
address comes from and can select addresses based on their space. An
example for this improved support is the used by the 'network-get' hook
tool. Earlier versions of Juju (and even this one on providers other
than MAAS) use a simpler address selection based on scope and
lexicographic order.


### network-get Hook Tool Arguments Changed

The new 'network-get' hook tool introduced in 2.0-alpha3
changed slightly:

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


### Automatic Retries of Failed Hooks

Starting from 2.0 failing hooks are now being automatically retried by
juju. This currently happens with an exponential backoff with a factor of 2 starting from 5 seconds and capped off at 5 minutes. (5, 10, ..., 5\*60 seconds)

A model config flag `automatically-retry-hooks` is now available that
will toggle this behavior. It affects all the units running in the same model. By default the flag is true and that is the recommended value for regular deployments. It is toggleable mainly for debugging purposes.

### Enhancements to juju run

Starting from 2.0 juju run will work by queueing actions using the name
'Juju-run'.  The command line API has not changed.

A few things to note:
* Juju run is now supported on windows machines. The commands will be executed through powershell.
* Any actions named 'juju-run' defined in the charm will **not** work anymore. The charm build tool will forbid any actions starting with 'juju-' to be defined, similar to relations.
* Because the commands are now actions statistics related to queue times, execution times, etc. can be gathered.
* The specified timeout is only taken into account when actually executing the action and does **not** account for delays that might come from the action waiting to be executed.
* `show-action-status` will also list actions queued by `juju-run`
* To avoid flooding a new flag has been created for `show-action-status`.  You can now use `--name <action-name>` to only get the actions corresponding to a particular name.
* `show-action-output` can be used to get more information on a
particular command.

### SSH Host Key Checking
The SSH host keys of Juju managed machines are now tracked and are verified by the juju ssh, scp and debug-hooks commands. This ensures that SSH connections established by these commands are actually made to the intended hosts, removing the possibility of man-in-the-middle attacks.

The host key checks can be disabled using the new --no-host-key-checks option for Juju’s SSH related commands. Routine use of this option is strongly discouraged.

### Config can be included in clouds.yaml
The cloud definitions in the clouds.yaml file can contain a config section which contains configuration attributes which will be used for all models hosted by the controller.

clouds:
  home-maas:
    type: maas
    config:
      bootstrap-timeout: 900
      set-numa-control-policy: true

### Juju Log Forwarding

When enabled, log messages for all hosted models in a controller are forwarded to a syslog server over a secure TLS connection. The easiest way to configure the feature is to provide a config.yaml file at bootstrap. 

$ juju bootstrap <controllername> <cloud>
	--config logforward-enabled=true --config logconfig.yaml

The contents of the yaml file should currently be as follows:

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

The feature can be toggled on or off by setting the logforward-enabled attribute. When enabled, a maximum of 100 previous log lines will be forwarded 

#### Wire Format
Syslog messages will be sent using the RFC 5424 message format.  We make use of the structured data facility defined in the more recent RFC.

Log Messages:
The facility code will be 1 (user level message). Severity will be mapped as follows:
Juju ERROR = Error (3)
Juju WARNING = Warning (4)
Juju INFO = Informational (6)
Juju DEBUG = Debug (7)
Juju TRACE = Debug (7)

Messages will use structured data to record relevant environment and user action parameters. Key pair definitions will be:

SDID: origin
enterpriseId: 28978 (Canonical, Ltd.)
software: jujud
swVersion: <the Juju version of the running agent>

SDID: model@28978
controller-uuid: <the uuid of the controller from which the message originates>
model-uuid: <the uuid of the model from which the message originates>

SDID: log@28978
source: <the name of the source filename from which the message originates>:<the source line number>
module: <the name of the source “module”>
#### Example log (error) message

<11>1 2016-02-28T09:57:10.804642398-05:00 172.12.3.1 juju - - [origin enterpriseId="28978" software="jujud" "2.0.0"] [model@28978 controller-uuid="deadbeef" model-uuid="deadbeef"] [log@28978 source-file="provider/ec2/storage.go" source-line="60"] Could not initialise machine block storage

### Audit Logging

In its initial implementation, audit logging is on by default.  The audit log will be in /var/log/juju/audit.log for each controller machine.  If running in an HA environment, the audit.log files on each controller machine must be collated to get a complete log.  Future releases will provide a utility to merge the logs, akin to debug-log.

Since users may interact with Juju from multiple sources (CLI, GUI, deployer, etc.), audit log entries record the API calls made, rather than only reporting CLI commands run. Only those API calls originating from authenticated users calling the external API are logged.

### Controller and Model permissions

Three level of permissions are now available for users on models.
A user can be given one of three level of permissions on each one of the models in a controller.
The permissions for a model are:
  * Read: The user can login to the model and obtain status and information about it.
  * Write: The user can deploy/delete services and add relations into a model.
  * Admin: The user has full control over the model except for controller level actions such as deletion. Model owners can delete their own models.

Three different levels have also been added for users on controllers.

A user can be given one of the three following permissions in a controller, these permissions will affect aspects of the controller.
  * Login: Allows the user to login into the controller.
  * AddModel: Allows the user to create new models and the permissions of login.
  * SuperUser: Allows the user full control over the model, this is the permission the controller creator has.

### application-version-set

Charm authors may trigger this command from any hook to output what version of the application is running. This could be a package version, for instance postgres version 9.5. It could also be a build number or version control revision identifier, for instance git sha 6fb7ba68. The version details will then be displayed in "juju status" output with the application details.

Example (within a charm hook): 
   
    $ application-version-set 9.5.3

Then application status will show:

APP         VERSION  STATUS  EXPOSED  ORIGIN  CHARM       REV  OS
postgresql  9.5.3    active  false    local   postgresql  0    ubuntu

### Shared Model Config

New/changed commands relevant to this feature:
  - juju model-config
  - juju set-model-config
  - juju unset-model-config
  - juju get-controller-config
  - juju show-model

The management of hosted model configuration has been improved in several ways:
  - shared config can be defined which will be used for all new models
    unless overridden by the user, either at model creation time using
    --config arguments or using juju set-model-config later
  - output of juju model-config includes the origin of each attribute
    value ("default", "controller", "model")
  - output of juju model config only shows configuration relevant to
    controlling the behaviour of a model; other data like model name,
    UUID, cloud type etc is shown using juju show-model
  - controller specific details like api port, certificates etc are now
    available using juju get-controller-config

There are 3 sources of model attribute values:
  1. default - hard coded into Juju or the cloud provider
  2. controller - shared by all models created on controllers within an HA environment
  3. model - set by the user

An example juju model-config output:

    ATTRIBUTE                   FROM        VALUE
    agent-metadata-url          default      
    agent-stream                default     released
    agent-version               model       2.0-beta14.4
    apt-ftp-proxy               default      
    apt-http-proxy              default      
    apt-https-proxy             default      
    apt-mirror                  default      
    automatically-retry-hooks   default     True
    default-series              default     xenial
    development                 default     False
    disable-network-management  default     False
    enable-os-refresh-update    default     True
    enable-os-upgrade           default     True
    firewall-mode               default     instance
    ftp-proxy                   controller  http://local
    http-proxy                  default      
    https-proxy                 default      
    ignore-machine-addresses    default     False
    image-metadata-url          default      
    image-stream                default     released
    logforward-enabled          default     False
    logging-config              model       <root>=INFO;unit=DEBUG
    no-proxy                    model       http://local
    provisioner-harvest-mode    default     destroyed
    proxy-ssh                   default     False
    remote-url                  model       10.0.4.1
    resource-tags               model       {}
    ssl-hostname-verification   default     True
    test-mode                   default     False

Points of note are that:
  - all model attributes are shown, enabling the user to see what values
    are available to be set
  - when a new model is created, the values are forked at that time so
    that any Juju upgrades which come with different hard coded defaults
    do not affect existing models, nor will migrating a model to a
    controller running a different version of the Juju agent
  - the FROM value is calculated dynamically so that if a default value
    changes to match the model, the output is adjusted accordingly

The behaviour of juju unset-model-config has changed. Previously, any unset attribute would revert to the empty value. Now, the value will revert to the closest inherited value. In the case above:
  - ftp-proxy has inherited the controller value http://local
  - juju set-model-config ftp-proxy=http://another will set a new "model"
    value for this attribute
  - juju unset-model-config ftp-proxy will revert to the controller value
    http://local

For this release, shared controller config attributes are specified in the clouds.yaml file.

    clouds:
     lxdtest:
       type: lxd
       config:
         bootstrap-timeout: 900
         set-numa-control-policy: true
         ftp-proxy: http://local

These cannot be changed once set. The next Juju beta will include new functionality to:
  - set and unset shared controller attributes
  - display the values of shared attributes used when creating models, and
    where those attributes are defined (default or controller)
  - allow shared attributes to be specified for each cloud region instead
    of just the controller


### Known issues

  * Juju 2.0 no longer supports KVM for local provider
    Lp 1547665
  * Cannot deploy a dense openstack bundle with native deploy
    Lp 1555808
  * Cannot get status after restore is denied
    Lp 1595686
  * [aws] adding a machine post-bootstrap on the controller model closes of
    api port in controller security group
    Lp 1598164
  * Credentials files containing Joyent credentials must be updated to
    work with beta3 and later (See "Joyent Provider No Longer Uses Manta   
    Storage")
