Title:Juju commands and usage

# Juju Command reference

You can get a list of the currently used commands by entering
```juju help commands``` from the commandline. The currently understood commands
are listed here, with usage and examples.

Click on the expander to see details for each command. 

^# actions

   **Usage:** ` juju actions [options] <application name>`

   **Summary:**

   List actions defined for a service.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--schema  (= false)_

   Display the full action schema

   
   **Details:**


   List the actions available to run on the target application, with a short
   description.  To show the full schema for the actions, use --schema.

   For more information, see also the 'run-action' command, which executes actions.

   **Aliases:**

   _list-actions_


 

^# add-cloud

   **Usage:** ` juju add-cloud [options] <cloud name> <cloud definition file>`

   **Summary:**

   Adds a user-defined cloud to Juju from among known cloud types.

   **Options:**

   _--replace  (= false)_

   Overwrite any existing cloud information

   
   **Details:**


   A cloud definition file has the following YAML format:

   clouds:

           mycloud:

             type: openstack
             auth-types: [ userpass ]
             regions:

               london:

                 endpoint: https://london.mycloud.com:35574/v3.0/
   
   If the named cloud already exists, the `--replace` option is required to 
   overwrite its configuration.

   Known cloud types: azure, cloudsigma, ec2, gce, joyent, lxd, maas, manual,
   openstack, rackspace

   **Examples:**


          juju add-cloud mycloud ~/mycloud.yaml


   **See also:**

   [clouds](#clouds)


 

^# add-credential

   **Usage:** ` juju add-credential [options] <cloud name>`

   **Summary:**

   Adds or replaces credentials for a cloud.

   **Options:**

   _-f (= "")_

   The YAML file containing credentials to add

   _--replace  (= false)_

   Overwrite existing credential information

   
   **Details:**


   The user is prompted to add credentials interactively if a YAML-formatted
   credentials file is not specified. Here is a sample credentials file:

   credentials:

           aws:

             <credential name>:

               auth-type: access-key
               access-key: <key>
               secret-key: <key>
           azure:

             <credential name>:

               auth-type: userpass
               application-id: <uuid1>
               application-password: <password>
               subscription-id: <uuid2>
               tenant-id: <uuid3>
   
   A "credential name" is arbitrary and is used solely to represent a set of
   credentials, of which there may be multiple per cloud.

   The `--replace` option is required if credential information for the named
   cloud already exists. All such information will be overwritten.

   This command does not set default regions nor default credentials. Note
   that if only one credential name exists, it will become the effective
   default credential.

   For credentials which are already in use by tools other than Juju, `juju 
   autoload-credentials` may be used.

   When Juju needs credentials for a cloud, i) if there are multiple
   available; ii) there's no set default; iii) and one is not specified ('--
   credential'), an error will be emitted.


   **Examples:**


          juju add-credential google
          juju add-credential aws -f ~/credentials.yaml


   **See also:**

   [credentials](#credentials)

   [remove-credential](#remove-credential)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)


 

^# add-machine

   **Usage:** ` juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | placement]`

   **Summary:**

   Start a new, empty machine and optionally a container, or add a container to a machine.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--constraints (= "")_

   Additional machine constraints

   _--disks  (= )_

   Constraints for disks to attach to the machine

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-n  (= 1)_

   The number of machines to add

   _--series (= "")_

   The charm series

   
   **Details:**


   Juju supports adding machines using provider-specific machine instances
   (EC2 instances, OpenStack servers, MAAS nodes, etc.); existing machines
   running a supported operating system (see "manual provisioning" below),
   and containers on machines. Machines are created in a clean state and
   ready to have units deployed.

   Without any parameters, add machine will allocate a new provider-specific
   machine (multiple, if "-n" is provided). When adding a new machine, you
   may specify constraints for the machine to be provisioned; the provider
   will interpret these constraints in order to decide what kind of machine
   to allocate.

   If a container type is specified (e.g. "lxd"), then add machine will
   allocate a container of that type on a new provider-specific machine. It is
   also possible to add containers to existing machines using the format
   <container type>:<machine number>. Constraints cannot be combined with
   deploying a container to an existing machine. The currently supported
   container types are: lxd, kvm.

   Manual provisioning is the process of installing Juju on an existing machine
   and bringing it under Juju's management; currently this requires that the
   machine be running Ubuntu, that it be accessible via SSH, and be running on
   the same network as the API server.

   It is possible to override or augment constraints by passing provider-specific
   "placement directives" as an argument; these give the provider additional
   information about how to allocate the machine. For example, one can direct the
   MAAS provider to acquire a particular node by specifying its hostname.
   For more information on placement directives, see "juju help placement".

   **Examples:**


         juju add-machine                      (starts a new machine)
         juju add-machine -n 2                 (starts 2 new machines)
         juju add-machine lxd                  (starts a new machine with an lxd container)
         juju add-machine lxd -n 2             (starts 2 new machines with an lxd container)
         juju add-machine lxd:4                (starts a new lxd container on machine 4)
         juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
         juju add-machine ssh:user@10.10.0.3   (manually provisions a machine with ssh)
         juju add-machine zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
         juju add-machine maas2.name           (acquire machine maas2.name on MAAS)


   **See also:**

   [remove-machine](#remove-machine)


 

^# add-model

   **Usage:** ` juju add-model [options] <model name> [cloud|region|(cloud/region)]`

   **Summary:**

   Adds a hosted model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--config  (= )_

   Path to YAML model configuration file or individual options (--config config.yaml [--config key=value ...])

   _--credential (= "")_

   Credential used to add the model

   _--owner (= "")_

   The owner of the new model if not the current user

   
   **Details:**


   Adding a model is typically done in order to run a specific workload.

   To add a model, you must at a minimum specify a model name. You may
   also supply model-specific configuration, a credential, and which
   cloud/region to deploy the model to. The cloud/region and credentials
   are the ones used to create any future resources within the model.

   Model names can be duplicated across controllers but must be unique for
   any given controller. Model names may only contain lowercase letters,
   digits and hyphens, and may not start with a hyphen.

   Credential names are specified either in the form "credential-name", or
   "credential-owner/credential-name". There is currently no way to acquire
   access to another user's credentials, so the only valid value for
   credential-owner is your own user name. This may change in a future
   release.

   If no cloud/region is specified, then the model will be deployed to
   the same cloud/region as the controller model. If a region is specified
   without a cloud qualifier, then it is assumed to be in the same cloud
   as the controller model. It is not currently possible for a controller
   to manage multiple clouds, so the only valid cloud is the same cloud
   as the controller model is deployed to. This may change in a future
   release.


   **Examples:**


          juju add-model mymodel
          juju add-model mymodel us-east-1
          juju add-model mymodel aws/us-east-1
          juju add-model mymodel --config my-config.yaml --config image-stream=daily
          juju add-model mymodel --credential credential_name --config authorized-keys="ssh-rsa ..."



 

^# add-relation

   **Usage:** ` juju add-relation [options] <application1>[:<relation name1>] <application2>[:<relation name2>]`

   **Summary:**

   Add a relation between two applications.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   **Aliases:**

   _relate_


 

^# add-space

   **Usage:** ` juju add-space [options] <name> [<CIDR1> <CIDR2> ...]`

   **Summary:**

   Add a new network space

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Adds a new space with the given name and associates the given
   (optional) list of existing subnet CIDRs with it.



 

^# add-ssh-key

   **Usage:** ` juju add-ssh-key [options] <ssh key> ...`

   **Summary:**

   Adds a public SSH key to a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju maintains a per-model cache of public SSH keys which it copies to
   each unit (including units already deployed). By default this includes the
   key of the user who created the model (assuming it is stored in the
   default location ~/.ssh/). Additional keys may be added with this command,
   quoting the entire public key as an argument.


   **Examples:**


          juju add-ssh-key "ssh-rsa qYfS5LieM79HIOr535ret6xy
          AAAAB3NzaC1yc2EAAAADAQA6fgBAAABAQCygc6Rc9XgHdhQqTJ
          Wsoj+I3xGrOtk21xYtKijnhkGqItAHmrE5+VH6PY1rVIUXhpTg
          pSkJsHLmhE29OhIpt6yr8vQSOChqYfS5LieM79HIOJEgJEzIqC
          52rCYXLvr/BVkd6yr4IoM1vpb/n6u9o8v1a0VUGfc/J6tQAcPR
          ExzjZUVsfjj8HdLtcFq4JLYC41miiJtHw4b3qYu7qm3vh4eCiK
          1LqLncXnBCJfjj0pADXaL5OQ9dmD3aCbi8KFyOEs3UumPosgmh
          VCAfjjHObWHwNQ/ZU2KrX1/lv/+lBChx2tJliqQpyYMiA3nrtS
          jfqQgZfjVF5vz8LESQbGc6+vLcXZ9KQpuYDt joe@ubuntu"

   For ease of use it is possible to use shell substitution to pass the key 
   to the command:
   juju add-ssh-key "$(cat ~/mykey.pub)"


   **See also:**

   [ssh-keys](#ssh-keys)

   [remove-ssh-key](#remove-ssh-key)

   [import-ssh-key](#import-ssh-key)


 

^# add-storage

   **Usage:** ` juju add-storage [options] <unit name> <storage directive>`

   **Summary:**

   Adds unit storage dynamically.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Add storage instances to a unit dynamically using provided storage directives.
   Specify a unit and a storage specification in the same format 
   as passed to juju deploy --storage=”...”.

   A storage directive consists of a storage name as per charm specification
   and storage constraints, e.g. pool, count, size.

   The acceptable format for storage constraints is a comma separated
   sequence of: POOL, COUNT, and SIZE, where
             POOL identifies the storage pool. POOL can be a string
             starting with a letter, followed by zero or more digits
             or letters optionally separated by hyphens.

             COUNT is a positive integer indicating how many instances
             of the storage to create. If unspecified, and SIZE is
             specified, COUNT defaults to 1.

             SIZE describes the minimum size of the storage instances to
             create. SIZE is a floating point number and multiplier from
             the set (M, G, T, P, E, Z, Y), which are all treated as
             powers of 1024.

   
   Storage constraints can be optionally ommitted.

   Model default values will be used for all ommitted constraint values.

   There is no need to comma-separate ommitted constraints. 

   **Examples:**


          # Add 3 ebs storage instances for "data" storage to unit u/0:
            juju add-storage u/0 data=ebs,1024,3 
          or
            juju add-storage u/0 data=ebs,3
          or
            juju add-storage u/0 data=ebs,,3 
          
          
          # Add 1 storage instances for "data" storage to unit u/0
          # using default model provider pool:
            juju add-storage u/0 data=1 
          or
            juju add-storage u/0 data



 

^# add-subnet

   **Usage:** ` juju add-subnet [options] <CIDR>|<provider-id> <space> [<zone1> <zone2> ...]`

   **Summary:**

   Add an existing subnet to Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Adds an existing subnet to Juju, making it available for use. Unlike
   "juju create-subnet", this command does not create a new subnet, so it
   is supported on a wider variety of clouds (where SDN features are not
   available, e.g. MAAS). The subnet will be associated with the given
   existing Juju network space.

   Subnets can be referenced by either their CIDR or ProviderId (if the
   provider supports it). If CIDR is used an multiple subnets have the
   same CIDR, an error will be returned, including the list of possible
   provider IDs uniquely identifying each subnet.

   Any availablility zones associated with the added subnet are automatically
   discovered using the cloud API (if supported). If this is not possible,
   since any subnet needs to be part of at least one zone, specifying
   zone(s) is required.



 

^# add-unit

   **Usage:** ` juju add-unit [options] <application name>`

   **Summary:**

   Adds one or more units to a deployed application.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-n, --num-units  (= 1)_

   Number of units to add

   _--to (= "")_

   The machine and/or container to deploy the unit in (bypasses constraints)

   
   **Details:**


   Adding units to an existing application is a way to scale out that application. 
   Many charms will seamlessly support horizontal scaling, others may need an
   additional application to facilitate load-balancing (check the individual 
   charm documentation).

   This command is applied to applications that have already been deployed.
   By default, applications are deployed to newly provisioned machines in
   accordance with any application or model constraints. Alternatively, this 
   command also supports the placement directive ("--to") for targeting
   specific machines or containers, which will bypass any existing
   constraints.


   **Examples:**

   Add five units of wordpress on five new machines:

          juju add-unit wordpress -n 5

   Add one unit of mysql to the existing machine 23:

          juju add-unit mysql --to 23

   Create a new LXD container on machine 7 and add one unit of mysql:

          juju add-unit mysql --to lxd:7

   Add a unit of mariadb to LXD container number 3 on machine 24:

          juju add-unit mariadb --to 24/lxd/3


   **See also:**

   [remove-unit](#remove-unit)


 

^# add-user

   **Usage:** ` juju add-user [options] <user name> [<display name>]`

   **Summary:**

   Adds a Juju user to a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   A `juju register` command will be printed, which must be executed by the
   user to complete the registration process. The user's details are stored
   within the shared model, and will be removed when the model is destroyed.
   Some machine providers will require the user to be in possession of certain
   credentials in order to create a model.


   **Examples:**


          juju add-user bob
          juju add-user --controller mycontroller bob


   **See also:**

   [register](#register)

   [grant](#grant)

   [users](#users)

   [show-user](#show-user)

   [disable-user](#disable-user)

   [enable-user](#enable-user)

   [change-user-password](#change-user-password)

   [remove-user](#remove-user)


 

^# agree

   **Usage:** ` juju agree [options] <term>`

   **Summary:**

   Agree to terms.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= json)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--yes  (= false)_

   Agree to terms non interactively

   
   **Details:**


   Agree to the terms required by a charm.

   When deploying a charm that requires agreement to terms, use 'juju agree' to
   view the terms and agree to them. Then the charm may be deployed.

   Once you have agreed to terms, you will not be prompted to view them again.

   **Examples:**


          # Displays terms for somePlan revision 1 and prompts for agreement.
          juju agree somePlan/1
          # Displays the terms for revision 1 of somePlan, revision 2 of otherPlan,
          # and prompts for agreement.
          juju agree somePlan/1 otherPlan/2
          # Agrees to the terms without prompting.
          juju agree somePlan/1 otherPlan/2 --yes



^# agreements

   **Usage:** ` juju agreements [options]`

   **Summary:**

   List user's agreements.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= json)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   
  **Details:**


   List terms the user has agreed to.


   **Aliases:**

   _list-agreements_


 

^# allocate

   **Usage:** ` juju allocate [options] <budget>:<value> <application> [<application2> ...]`

   **Summary:**

   Allocate budget to applications.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--model-uuid (= "")_

   Model UUID of allocation

   
   **Details:**


   Allocate budget for the specified applications, replacing any prior allocations
   made for the specified applications.


   **Examples:**


          # Assigns application "db" to an allocation on budget "somebudget" with
          # the limit "42".
          juju allocate somebudget:42 db
          # Application names assume the current selected model, unless otherwise
          # specified with:
          juju allocate -m [<controller name:]<model name> ...
          # Models may also be referenced by UUID when necessary:
           juju allocate --model-uuid <uuid> ...



^# attach

   **Usage:** ` juju attach [options] application name=file`

   **Summary:**

   upload a file as a resource for an application

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   This command uploads a file from your local disk to the juju controller to be
   used as a resource for an application.
   

^# autoload-credentials

   **Usage:** `juju autoload-credentials`

   **Summary:**

   Attempts to automatically add or replace credentials for a cloud.


   
   **Details:**


   Well known locations for specific clouds are searched and any found
   information is presented interactively to the user.

   An alternative to this command is `juju add-credential`
   Below are the cloud types for which credentials may be autoloaded,
   including the locations searched.

   EC2
   Credentials and regions:
 
   1. On Linux, &#36;HOME/.aws/credentials and &#36;HOME/.aws/config
   2. Environment variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
   
   GCE
   Credentials:

   1. A JSON file whose path is specified by the
   GOOGLE_APPLICATION_CREDENTIALS environment variable

   2. On Linux, &#36;HOME/.config/gcloud/application_default_credentials.json
   Default region is specified by the CLOUDSDK_COMPUTE_REGION environment
   variable.

   3. On Windows, &#37;APPDATA&#37;&#92;gcloud&#92;application_default_credentials.json
   
   OpenStack
   Credentials:

   1. On Linux, &#36;HOME/.novarc
   2. Environment variables OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME,
   OS_DOMAIN_NAME
   
   Example:

             juju autoload-credentials
            

   **See also:**

   [list-credentials](#list-credentials)

   [remove-credential](#remove-credential)

   [set-default-credential](#set-default-credential)

   [add-credential](#add-credential)




^# backups

   **Usage:** ` juju backups [options]`

   **Summary:**

   Displays information about all backups.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   backups provides the metadata associated with all backups.


   **Aliases:**

   _list-backups_


 

^# bootstrap

   **Usage:** ` juju bootstrap [options] [<cloud name>[/region] [<controller name>]]`

   **Summary:**

   Initializes a cloud environment.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--agent-version (= "")_

   Version of tools to use for Juju agents

   _--auto-upgrade  (= false)_

   Upgrade to the latest patch release tools on first bootstrap

   _--bootstrap-constraints (= "")_

   Specify bootstrap machine constraints

   _--bootstrap-series (= "")_

   Specify the series of the bootstrap machine

   _--build-agent  (= false)_

   Build local version of agent binary before bootstrapping

   _--clouds  (= false)_

   Print the available clouds which can be used to bootstrap a Juju environment

   _--config  (= )_

   Specify a controller configuration file, or one or more configuration

   options

   (--config config.yaml [--config key=value ...])

   _--constraints (= "")_

   Set model constraints

   _--credential (= "")_

   Credentials to use when bootstrapping

   _-d, --default-model (= "default")_

   Name of the default hosted model for the controller

   _--keep-broken  (= false)_

   Do not destroy the model if bootstrap fails

   _--metadata-source (= "")_

   Local path to use as tools and/or metadata source

   _--model-default  (= )_

   Specify a configuration file, or one or more configuration

   options to be set for all models, unless otherwise specified

   (--config config.yaml [--config key=value ...])

   _--no-gui  (= false)_

   Do not install the Juju GUI in the controller when bootstrapping

   _--regions (= "")_

   Print the available regions for the specified cloud

   _--to (= "")_

   Placement directive indicating an instance to bootstrap

   
   **Details:**


   Used without arguments, bootstrap will step you through the process of
   initializing a Juju cloud environment. Initialization consists of creating
   a 'controller' model and provisioning a machine to act as controller.

   We recommend you call your controller ‘username-region’ e.g. ‘fred-us-east-1’
   See --clouds for a list of clouds and credentials.

   See --regions <cloud> for a list of available regions for a given cloud.
   Credentials are set beforehand and are distinct from any other
   configuration (see `juju add-credential`).

   The 'controller' model typically does not run workloads. It should remain
   pristine to run and manage Juju's own infrastructure for the corresponding
   cloud. Additional (hosted) models should be created with `juju create-
   model` for workload purposes.

   Note that a 'default' model is also created and becomes the current model
   of the environment once the command completes. It can be discarded if
   other models are created.

   If '--bootstrap-constraints' is used, its values will also apply to any
   future controllers provisioned for high availability (HA).

   If '--constraints' is used, its values will be set as the default
   constraints for all future workload machines in the model, exactly as if
   the constraints were set with `juju set-model-constraints`.

   It is possible to override constraints and the automatic machine selection
   algorithm by assigning a "placement directive" via the '--to' option. This
   dictates what machine to use for the controller. This would typically be
   used with the MAAS provider ('--to <host>.maas').

   You can change the default timeout and retry delays used during the
   bootstrap by changing the following settings in your configuration
   (all values represent number of seconds):

             # How long to wait for a connection to the controller
             bootstrap-timeout: 600 # default: 10 minutes
             # How long to wait between connection attempts to a controller
   
   address.

             bootstrap-retry-delay: 5 # default: 5 seconds
             # How often to refresh controller addresses from the API server.
             bootstrap-addresses-delay: 10 # default: 10 seconds
   
   Private clouds may need to specify their own custom image metadata and
   tools/agent. Use '--metadata-source' whose value is a local directory.
   The value of '--agent-version' will become the default tools version to
   use in all models for this controller. The full binary version is accepted
   (e.g.: 2.0.1-xenial-amd64) but only the numeric version (e.g.: 2.0.1) is
   used. Otherwise, by default, the version used is that of the client.


   **Examples:**


          juju bootstrap
          juju bootstrap --clouds
          juju bootstrap --regions aws
          juju bootstrap aws
          juju bootstrap aws/us-east-1
          juju bootstrap google joe-us-east1
          juju bootstrap --config=~/config-rs.yaml rackspace joe-syd
          juju bootstrap --config agent-version=1.25.3 aws joe-us-east-1
          juju bootstrap --config bootstrap-timeout=1200 azure joe-eastus


   **See also:**

   [add-credentials](#add-credentials)

   [add-model](#add-model)

   [set-constraints](#set-constraints)


 

^# budgets

   **Usage:** ` juju budgets [options]`

   **Summary:**

   List budgets.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List the available budgets.


   **Examples:**


          juju budgets


   **Aliases:**

   _list-budgets_


 

^# cached-images

   **Usage:** ` juju cached-images [options]`

   **Summary:**

   Shows cached os images.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--arch (= "")_

   The architecture of the image to list eg amd64

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _--kind (= "")_

   The image kind to list eg lxd

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--series (= "")_

   The series of the image to list eg xenial

   
   **Details:**


   List cached os images in the Juju model.

   Images can be filtered on:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"
   
   The filter attributes are optional.


   **Examples:**


        # List all cached images.
        juju cached-images
        # List cached images for xenial.
        juju cached-images --series xenial
        # List all cached lxd images for xenial amd64.
        juju cached-images --kind lxd --series xenial --arch amd64


   **Aliases:**

   _list-cached-images_


 

^# change-user-password

   **Usage:** ` juju change-user-password [options] [username]`

   **Summary:**

   Changes the password for the current or specified Juju user

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   The user is, by default, the current user. The latter can be confirmed with
   the `juju show-user` command.

   A controller administrator can change the password for another user (on
   that controller).


   **Examples:**


          juju change-user-password
          juju change-user-password bob


   **See also:**

   [add-user](#add-user)


 

^# charm

   **Usage:** ` juju charm [options] <command> ...`

   **Summary:**

   Interact with charms.

   **Options:**

   _--description  (= false)_

   

   _-h, --help  (= false)_

   show help on a command or other topic

   
   **Details:**


   "juju charm" is the the juju CLI equivalent of the "charm" command used
   by charm authors, though only applicable functionality is mirrored.

   commands:

             help           - show help on a command or other topic
             list-resources - Alias for 'resources'.

             resources      - display the resources for a charm in the charm store


 

^# clouds

   **Usage:** ` juju clouds [options]`

   **Summary:**

   Lists all clouds available to Juju.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Provided information includes 'cloud' (as understood by Juju), cloud
   'type', and cloud 'regions'.

   The listing will consist of public clouds and any custom clouds made
   available through the `juju add-cloud` command. The former can be updated
   via the `juju update-cloud` command.

   By default, the tabular format is used.


   **Examples:**


          juju clouds


   **See also:**

   [add-cloud](#add-cloud)

   [regions](#regions)

   [show-cloud](#show-cloud)

   [update-clouds](#update-clouds)

   **Aliases:**

   _list-clouds_


 

^# collect-metrics

   **Usage:** ` juju collect-metrics [options] [application or unit]`

   **Summary:**

   Collect metrics on the given unit/application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Trigger metrics collection
   This command waits for the metric collection to finish before returning.
   You may abort this command and it will continue to run asynchronously.
   Results may be checked by 'juju action status'.



 

^# config

   **Usage:** ` juju config [options] <application name> [--reset <key[,key]>] [<attribute-key>][=<value>] ...]`

   **Summary:**

   Gets, sets, or resets configuration for a deployed application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--file  (= )_

   path to yaml-formatted application config

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--reset  (= )_

   Reset the provided comma delimited keys

   
   **Details:**


   By default, all configuration (keys, values, metadata) for the application are
   displayed if a key is not specified.

   Output includes the name of the charm used to deploy the application and a
   listing of the application-specific configuration settings.

   See `juju status` for application names.


   **Examples:**


          juju config apache2
          juju config --format=json apache2
          juju config mysql dataset-size
          juju config mysql --reset dataset-size,backup_dir
          juju config apache2 --file path/to/config.yaml
          juju config apache2 --model mymodel --file /home/ubuntu/mysql.yaml


   **See also:**

   [deploy](#deploy)

   [status](#status)


 

^# controller-config

   **Usage:** ` juju controller-config [options] [<attribute key>]`

   **Summary:**

   Displays configuration settings for a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   By default, all configuration (keys and values) for the controller are
   displayed if a key is not specified.


   **Examples:**


          juju controller-config
          juju controller-config api-port
          juju controller-config -c mycontroller


   **See also:**

   [controllers](#controllers)


 

^# controllers

   **Usage:** ` juju controllers [options]`

   **Summary:**

   Lists all controllers.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--refresh  (= false)_

   Connect to each controller to download the latest details

   
   **Details:**


   The output format may be selected with the '--format' option. In the
   default tabular output, the current controller is marked with an asterisk.

   **Examples:**


          juju controllers
          juju controllers --format json --output ~/tmp/controllers.json


   **See also:**

   [models](#models)

   [show-controller](#show-controller)

   **Aliases:**

   _list-controllers_


 

^# create-backup

   **Usage:** ` juju create-backup [options] [<notes>]`

   **Summary:**

   Create a backup.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--filename (= "juju-backup-<date>-<time>.tar.gz")_

   Download to this file

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--no-download  (= false)_

   Do not download the archive

   
   **Details:**


   create-backup requests that juju create a backup of its state and print the
   backup's unique ID.  You may provide a note to associate with the backup.
   The backup archive and associated metadata are stored remotely by juju.
   The --download option may be used without the --filename option.  In
   that case, the backup archive will be stored in the current working
   directory with a name matching juju-backup-<date>-<time>.tar.gz.

   WARNING: Remotely stored backups will be lost when the model is
   destroyed.  Furthermore, the remotely backup is not guaranteed to be
   available.

   Therefore, you should use the --download or --filename options, or use:
             juju download-backups
   
   to get a local copy of the backup archive.

   This local copy can then be used to restore an model even if that
   model was already destroyed or is otherwise unavailable.



 

^# create-budget

   **Usage:** ` juju create-budget [options]`

   **Summary:**

   Create a new budget.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   
   **Details:**


   Create a new budget with monthly limit.


   **Examples:**


          # Creates a budget named 'qa' with a limit of 42.
          juju create-budget qa 42



 

^# create-storage-pool

   **Usage:** ` juju create-storage-pool [options] <name> <provider> [<key>=<value> [<key>=<value>...]]`

   **Summary:**

   Create or define a storage pool.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Pools are a mechanism for administrators to define sources of storage that
   they will use to satisfy application storage requirements.

   A single pool might be used for storage from units of many different applications -
   it is a resource from which different stores may be drawn.

   A pool describes provider-specific parameters for creating storage,
   such as performance (e.g. IOPS), media type (e.g. magnetic vs. SSD),
   or durability.

   For many providers, there will be a shared resource
   where storage can be requested (e.g. EBS in amazon).

   Creating pools there maps provider specific settings
   into named resources that can be used during deployment.

   Pools defined at the model level are easily reused across applications.
   Pool creation requires a pool name, the provider type and attributes for
   configuration as space-separated pairs, e.g. tags, size, path, etc.



 

^# credentials

   **Usage:** ` juju credentials [options] [<cloud name>]`

   **Summary:**

   Lists credentials for a cloud.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-secrets  (= false)_

   Show secrets

   
   **Details:**


   Credentials are used with `juju bootstrap`  and `juju add-model`.

   An arbitrary "credential name" is used to represent credentials, which are 
   added either via `juju add-credential` or `juju autoload-credentials`.
   Note that there can be multiple sets of credentials and thus multiple 
   names.

   Actual authentication material is exposed with the '--show-secrets' 
   option.

   A controller and subsequently created models can be created with a 
   different set of credentials but any action taken within the model (e.g.:
   `juju deploy`; `juju add-unit`) applies the set used to create the model. 
   Recall that when a controller is created a 'default' model is also 
   created.

   Credentials denoted with an asterisk '*' are currently set as the default
   for the given cloud.


   **Examples:**


          juju credentials
          juju credentials aws
          juju credentials --format yaml --show-secrets


   **See also:**

   [add-credential](#add-credential)

   [remove-credential](#remove-credential)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)

   **Aliases:**

   _list-credentials_


 

^# debug-hooks

   **Usage:** ` juju debug-hooks [options] <unit name> [hook names]`

   **Summary:**

   Launch a tmux session to debug a hook.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--no-host-key-checks  (= false)_

   Skip host key checking (INSECURE)

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= true)_

   Enable pseudo-tty allocation

   
   **Details:**


   Interactively debug a hook remotely on an application unit.

   See the "juju help ssh" for information about SSH related options
   accepted by the debug-hooks command.



 

^# debug-log

   **Usage:** ` juju debug-log [options]`

   **Summary:**

   Displays log messages for a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--color  (= false)_

   Force use of ANSI color codes

   _--date  (= false)_

   Show dates as well as times

   _--exclude-module  (= )_

   Do not show log messages for these logging modules

   _-i, --include  (= )_

   Only show log messages for these entities

   _--include-module  (= )_

   Only show log messages for these logging modules

   _-l, --level (= "")_

   Log level to show, one of [TRACE, DEBUG, INFO, WARNING, ERROR]

   _--limit  (= 0)_

   Exit once this many of the most recent (possibly filtered) lines are shown

   _--location  (= false)_

   Show filename and line numbers

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--ms  (= false)_

   Show times to millisecond precision

   _-n, --lines  (= 10)_

   Show this many of the most recent (possibly filtered) lines, and continue to append

   _--no-tail  (= false)_

   Stop after returning existing log messages

   _--replay  (= false)_

   Show the entire (possibly filtered) log and continue to append

   _--tail  (= false)_

   Wait for new logs

   _--utc  (= false)_

   Show times in UTC

   _-x, --exclude  (= )_

   Do not show log messages for these entities

   
   **Details:**


   This command provides access to all logged Juju activity on a per-model
   basis. By default, the logs for the currently select model are shown.

   Each log line is emitted in this format:

           <entity> <timestamp> <log-level> <module>:<line-no> <message>
   
   The "entity" is the source of the message: a machine or unit. The names for
   machines and units can be seen in the output of `juju status`.

   The '--include' and '--exclude' options filter by entity. A unit entity is
   identified by prefixing 'unit-' to its corresponding unit name and replacing
   the slash with a dash. A machine entity is identified by prefixing 'machine-'
   to its corresponding machine id.

   The '--include-module' and '--exclude-module' options filter by (dotted)
   logging module name. The module name can be truncated such that all loggers
   with the prefix will match.

   The filtering options combine as follows:

   * All --include options are logically ORed together.

   * All --exclude options are logically ORed together.

   * All --include-module options are logically ORed together.

   * All --exclude-module options are logically ORed together.

   * The combined --include, --exclude, --include-module and --exclude-module
           selections are logically ANDed to form the complete filter.


   **Examples:**

   Exclude all machine 0 messages; show a maximum of 100 lines; and continue to
   append filtered messages:

          juju debug-log --exclude machine-0 --lines 100

   Include only unit mysql/0 messages; show a maximum of 50 lines; and then
   exit:

          juju debug-log -T --include unit-mysql-0 --lines 50

   Show all messages from unit apache2/3 or machine 1 and then exit:

          juju debug-log -T --replay --include unit-apache2-3 --include machine-1

   Show all juju.worker.uniter logging module messages that are also unit
   wordpress/0 messages, and then show any new log messages which match the
   filter:

          juju debug-log --replay 
              --include-module juju.worker.uniter \
              --include unit-wordpress-0

   Show all messages from the juju.worker.uniter module, except those sent from
   machine-3 or machine-4, and then stop:

          juju debug-log --replay --no-tail
              --include-module juju.worker.uniter \
              --exclude machine-3 \
              --exclude machine-4 

   To see all WARNING and ERROR messages and then continue showing any
   new WARNING and ERROR messages as they are logged:

          juju debug-log --replay --level WARNING


   **See also:**

   [status](#status)

   [ssh](#ssh)


 

^# deploy

   **Usage:** ` juju deploy [options] <charm or bundle> [<application name>]`

   **Summary:**

   Deploy a new application or bundle.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--bind (= "")_

   Configure application endpoint bindings to spaces

   _--budget (= "personal:0")_

   budget and allocation limit

   _--channel (= "")_

   Channel to use when getting the charm or bundle from the charm store

   _--config  (= )_

   Path to yaml-formatted application config

   _--constraints (= "")_

   Set application constraints

   _--force  (= false)_

   Allow a charm to be deployed to a machine running an unsupported series

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-n, --num-units  (= 1)_

   Number of application units to deploy for principal charms

   _--plan (= "")_

   plan to deploy charm under

   _--resource  (= )_

   Resource to be uploaded to the controller

   _--series (= "")_

   The series on which to deploy

   _--storage  (= )_

   Charm storage constraints

   _--to (= "")_

   The machine and/or container to deploy the unit in (bypasses constraints)

   
   **Details:**


   <charm or bundle> can be a charm/bundle URL, or an unambiguously condensed
   form of it; assuming a current series of "trusty", the following forms will be
   accepted:

   For cs:trusty/mysql
           mysql
           trusty/mysql
   
   For cs:~user/trusty/mysql
           ~user/mysql
   
   For cs:bundle/mediawiki-single
           mediawiki-single
           bundle/mediawiki-single
   
   The current series for charms is determined first by the 'default-series' model
   setting, followed by the preferred series for the charm in the charm store.
   In these cases, a versioned charm URL will be expanded as expected (for
   example, mysql-33 becomes cs:precise/mysql-33).

   Charms may also be deployed from a user specified path. In this case, the path
   to the charm is specified along with an optional series.

           juju deploy /path/to/charm --series trusty
   
   If '--series' is not specified, the charm's default series is used. The default
   series for a charm is the first one specified in the charm metadata. If the
   specified series is not supported by the charm, this results in an error,
   unless '--force' is used.

           juju deploy /path/to/charm --series wily --force
   
   Local bundles are specified with a direct path to a bundle.yaml file.
   For example:

           juju deploy /path/to/bundle/openstack/bundle.yaml
   
   If an 'application name' is not provided, the application name used is the
   'charm or bundle' name.

   Constraints can be specified by specifying the '--constraints' option. If the
   application is later scaled out with `juju add-unit`, provisioned machines
   will use the same constraints (unless changed by `juju set-constraints`).
   Resources may be uploaded by specifying the '--resource' option followed by a
   name=filepath pair. This option may be repeated more than once to upload more
   than one resource.

           juju deploy foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml
   
   Where 'bar' and 'baz' are resources named in the metadata for the 'foo' charm.
   When using a placement directive to deploy to an existing machine or container
   ('--to' option), the `juju status` command should be used for guidance. A few
   placement directives are provider-dependent (e.g.: 'zone').

   In more complex scenarios, Juju's network spaces are used to partition the
   cloud networking layer into sets of subnets. Instances hosting units inside the
   same space can communicate with each other without any firewalls. Traffic
   crossing space boundaries could be subject to firewall and access restrictions.
   Using spaces as deployment targets, rather than their individual subnets,
   allows Juju to perform automatic distribution of units across availability zones
   to support high availability for applications. Spaces help isolate applications
   and their units, both for security purposes and to manage both traffic
   segregation and congestion.

   When deploying an application or adding machines, the 'spaces' constraint can
   be used to define a comma-delimited list of required and forbidden spaces (the
   latter prefixed with "^", similar to the 'tags' constraint).


   **Examples:**


          juju deploy mysql --to 23       (deploy to machine 23)
          juju deploy mysql --to 24/lxd/3 (deploy to lxd container 3 on machine 24)
          juju deploy mysql --to lxd:25   (deploy to a new lxd container on machine 25)
          juju deploy mysql --to lxd      (deploy to a new lxd container on a new machine)
          juju deploy mysql --to zone=us-east-1a
          (provider-dependent; deploy to a specific AZ)
          juju deploy mysql --to host.maas
          (deploy to a specific MAAS node)
          juju deploy mysql -n 5 --constraints mem=8G
          (deploy 5 units to machines with at least 8 GB of memory)
          juju deploy haproxy -n 2 --constraints spaces=dmz,^cms,^database
          (deploy 2 units to machines that are part of the 'dmz' space but not of the
          'cmd' or the 'database' spaces)


   **See also:**

   [spaces](#spaces)

   [constraints](#constraints)

   [add-unit](#add-unit)

   [set-config](#set-config)

   [get-config](#get-config)

   [set-constraints](#set-constraints)

   [get-constraints](#get-constraints)


 

^# destroy-controller

   **Usage:** ` juju destroy-controller [options] <controller name>`

   **Summary:**

   Destroys a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--destroy-all-models  (= false)_

   Destroy all hosted models in the controller

   _-y, --yes  (= false)_

   Do not ask for confirmation

   
   **Details:**


   All models (initial model plus all workload/hosted) associated with the
   controller will first need to be destroyed, either in advance, or by
   specifying `--destroy-all-models`.


   **Examples:**


          juju destroy-controller --destroy-all-models mycontroller


   **See also:**

   [kill-controller](#kill-controller)

   [unregister](#unregister)


 

^# destroy-model

   **Usage:** ` juju destroy-model [options] [<controller name>:]<model name>`

   **Summary:**

   Terminate all machines and resources for a non-controller model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-y, --yes  (= false)_

   Do not prompt for confirmation

   
   **Details:**


   Destroys the specified model. This will result in the non-recoverable
   removal of all the units operating in the model and any resources stored
   there. Due to the irreversible nature of the command, it will prompt for
   confirmation (unless overridden with the '-y' option) before taking any
   action.


   **Examples:**


          juju destroy-model test
          juju destroy-model -y mymodel


   **See also:**

   [destroy-controller](#destroy-controller)


 

^# disable-command

   **Usage:** ` juju disable-command [options] <command set> [message...]`

   **Summary:**

   Disable commands for the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju allows to safeguard deployed models from unintentional damage by preventing
   execution of operations that could alter model.

   This is done by disabling certain sets of commands from successful execution.
   Disabled commands must be manually enabled to proceed.

   Some commands offer a --force option that can be used to bypass the disabling.
   Commands that can be disabled are grouped based on logical operations as follows:
   "destroy-model" prevents:

             destroy-controller
             destroy-model
   
   "remove-object" prevents:

             destroy-controller
             destroy-model
             remove-machine
             remove-relation
             remove-application
             remove-unit
   
   "all" prevents:

             add-machine
             add-relation
             add-unit
             add-ssh-key
             add-user
             change-user-password
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-config
             set-constraints
             set-model-config
             sync-tools
             unexpose
             unset-config
             unset-model-config
             upgrade-charm
             upgrade-juju
   
   	

   **Examples:**


          # To prevent the model from being destroyed:
          juju disable-command destroy-model "Check with SA before destruction."
          # To prevent the machines, applications, units and relations from being removed:
          juju disable-command remove-object
          # To prevent changes to the model:
          juju disable-command all "Model locked down"


   **See also:**

   [disabled-commands](#disabled-commands)

   [enable-command](#enable-command)


 

^# disable-user

   **Usage:** ` juju disable-user [options] <user name>`

   **Summary:**

   Disables a Juju user.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   A disabled Juju user is one that cannot log in to any controller.

   This command has no affect on models that the disabled user may have
   created and/or shared nor any applications associated with that user.


   **Examples:**


          juju disable-user bob


   **See also:**

   [users](#users)

   [enable-user](#enable-user)

   [login](#login)


 

^# disabled-commands

   **Usage:** ` juju disabled-commands [options]`

   **Summary:**

   List disabled commands.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Lists for all models (administrative users only)

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List disabled commands for the model.

   Commands that can be disabled are grouped based on logical operations as follows:
   "destroy-model" prevents:

             destroy-controller
             destroy-model
   
   "remove-object" prevents:

             destroy-controller
             destroy-model
             remove-machine
             remove-relation
             remove-application
             remove-unit
   
   "all" prevents:

             add-machine
             add-relation
             add-unit
             add-ssh-key
             add-user
             change-user-password
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-config
             set-constraints
             set-model-config
             sync-tools
             unexpose
             unset-config
             unset-model-config
             upgrade-charm
             upgrade-juju
   
   	

   **See also:**

   [disable-command](#disable-command)

   [enable-command](#enable-command)

   **Aliases:**

   _list-disabled-commands_


 

^# download-backup

   **Usage:** ` juju download-backup [options] <ID>`

   **Summary:**

   Get an archive file.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--filename (= "")_

   Download target

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   download-backup retrieves a backup archive file.

   If --filename is not used, the archive is downloaded to a temporary
   location and the filename is printed to stdout.



 

^# enable-command

   **Usage:** ` juju enable-command [options] <command set>`

   **Summary:**

   Enable commands that had been previously disabled.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju allows to safeguard deployed models from unintentional damage by preventing
   execution of operations that could alter model.

   This is done by disabling certain sets of commands from successful execution.
   Disabled commands must be manually enabled to proceed.

   Some commands offer a --force option that can be used to bypass a block.
   Commands that can be disabled are grouped based on logical operations as follows:
   "destroy-model" prevents:

             destroy-controller
             destroy-model
   
   "remove-object" prevents:

             destroy-controller
             destroy-model
             remove-machine
             remove-relation
             remove-application
             remove-unit
   
   "all" prevents:

             add-machine
             add-relation
             add-unit
             add-ssh-key
             add-user
             change-user-password
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-config
             set-constraints
             set-model-config
             sync-tools
             unexpose
             unset-config
             unset-model-config
             upgrade-charm
             upgrade-juju
   
   	

   **Examples:**


          # To allow the model to be destroyed:
          juju enable-command destroy-model
          # To allow the machines, applications, units and relations to be removed:
          juju enable-command remove-object
          # To allow changes to the model:
          juju enable-command all


   **See also:**

   [disable-command](#disable-command)

   [disabled-commands](#disabled-commands)


 

^# enable-destroy-controller

   **Usage:** ` juju enable-destroy-controller [options]`

   **Summary:**

   Enable destroy-controller by removing disabled commands in the controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Any model in the controller that has disabled commands will block a controller
   from being destroyed.

   A controller administrator is able to enable all the commands across all the models
   in a Juju controller so that the controller can be destoyed if desired.

   **See also:**

   [disable-command](#disable-command)

   [disabled-commands](#disabled-commands)

   [enable-command](#enable-command)


 

^# enable-ha

   **Usage:** ` juju enable-ha [options]`

   **Summary:**

   Ensure that sufficient controllers exist to provide redundancy.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--constraints (= "")_

   Additional machine constraints

   _--format  (= simple)_

   Specify output format (json|simple|yaml)

   _-n  (= 0)_

   Number of controllers to make available

   _-o, --output (= "")_

   Specify an output file

   _--to (= "")_

   The machine(s) to become controllers, bypasses constraints

   
   **Details:**


   To ensure availability of deployed applications, the Juju infrastructure
   must itself be highly available. The enable-ha command will ensure
   that the specified number of controller machines are used to make up the
   controller.

   An odd number of controllers is required.


   **Examples:**


          # Ensure that the controller is still in highly available mode. If
          # there is only 1 controller running, this will ensure there
          # are 3 running. If you have previously requested more than 3,
          # then that number will be ensured.
          juju enable-ha
          # Ensure that 5 controllers are available.
          juju enable-ha -n 5 
          # Ensure that 7 controllers are available, with newly created
          # controller machines having at least 8GB RAM.
          juju enable-ha -n 7 --constraints mem=8G
          # Ensure that 7 controllers are available, with machines server1 and
          # server2 used first, and if necessary, newly created controller
          # machines having at least 8GB RAM.
          juju enable-ha -n 7 --to server1,server2 --constraints mem=8G



 

^# enable-user

   **Usage:** ` juju enable-user [options] <user name>`

   **Summary:**

   Re-enables a previously disabled Juju user.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   An enabled Juju user is one that can log in to a controller.


   **Examples:**


          juju enable-user bob


   **See also:**

   [users](#users)

   [disable-user](#disable-user)

   [login](#login)


 

^# expose

   **Usage:** ` juju expose [options] <application name>`

   **Summary:**

   Makes an application publicly available over the network.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Adjusts the firewall rules and any relevant security mechanisms of the
   cloud to allow public access to the application.


   **Examples:**


          juju expose wordpress


   **See also:**

   [unexpose](#unexpose)


 

^# get-constraints

   **Usage:** ` juju get-constraints [options] <application>`

   **Summary:**

   Displays machine constraints for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= constraints)_

   Specify output format (constraints|json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Shows machine constraints that have been set for an application with `juju set-
   constraints`.

   By default, the model is the current model.

   Application constraints are combined with model constraints, set with `juju 
   set-model-constraints`, for commands (such as 'deploy') that provision
   machines for applications. Where model and application constraints overlap, the
   application constraints take precedence.

   Constraints for a specific model can be viewed with `juju get-model-
   constraints`.


   **Examples:**


          juju get-constraints mysql
          juju get-constraints -m mymodel apache2


   **See also:**

   [set-constraints](#set-constraints)

   [get-model-constraints](#get-model-constraints)

   [set-model-constraints](#set-model-constraints)


 

^# get-model-constraints

   **Usage:** ` juju get-model-constraints [options]`

   **Summary:**

   Displays machine constraints for a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= constraints)_

   Specify output format (constraints|json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Shows machine constraints that have been set on the model with
   `juju set-model-constraints.`
   By default, the model is the current model.

   Model constraints are combined with constraints set on an application
   with `juju set-constraints` for commands (such as 'deploy') that provision
   machines for applications. Where model and application constraints overlap, the
   application constraints take precedence.

   Constraints for a specific application can be viewed with `juju get-constraints`.

   **Examples:**


          juju get-model-constraints
          juju get-model-constraints -m mymodel


   **See also:**

   [models](#models)

   [get-constraints](#get-constraints)

   [set-constraints](#set-constraints)

   [set-model-constraints](#set-model-constraints)


 

^# grant

   **Usage:** ` juju grant [options] <user name> <permission> [<model name> ...]`

   **Summary:**

   Grants access level to a Juju user for a model or controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   By default, the controller is the current controller.

   Users with read access are limited in what they can do with models:

   `juju models`, `juju machines`, and `juju status`.


   **Examples:**

   Grant user 'joe' 'read' access to model 'mymodel':

          juju grant joe read mymodel

   Grant user 'jim' 'write' access to model 'mymodel':

          juju grant jim write mymodel

   Grant user 'sam' 'read' access to models 'model1' and 'model2':

          juju grant sam read model1 model2

   Grant user 'maria' 'add-model' access to the controller:

          juju grant maria add-model

   Valid access levels for models are:

          read
          write
          admin

   Valid access levels for controllers are:

          login
          add-model
          superuser


   **See also:**

   [revoke](#revoke)

   [add-user](#add-user)


 

^# gui

   **Usage:** ` juju gui [options]`

   **Summary:**

   Open the Juju GUI in the default browser.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--no-browser  (= false)_

   Do not try to open the web browser, just print the Juju GUI URL

   _--show-credentials  (= false)_

   Show admin credentials to use for logging into the Juju GUI

   
   **Details:**


   Open the Juju GUI in the default browser:

   	juju gui
   Open the GUI and show admin credentials to use to log into it:

   	juju gui --show-credentials
   Do not open the browser, just output the GUI URL:

   	juju gui --no-browser
   An error is returned if the Juju GUI is not available in the controller.


 

^# help

   **Usage:** ` juju help [topic]`

   **Summary:**

   show help on a command or other topic

  

   **See also:**

   [opics](#opics)


 

^# help-tool

   **Usage:** ` juju help-tool [tool]`

   **Summary:**

   Show help on a Juju charm tool.


 

^# import-ssh-key

   **Usage:** ` juju import-ssh-key [options] <lp|gh>:<user identity> ...`

   **Summary:**

   Adds a public SSH key from a trusted identity source to a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju can add SSH keys to its cache from reliable public sources (currently
   Launchpad and GitHub), allowing those users SSH access to Juju machines.
   The user identity supplied is the username on the respective service given by
   'lp:' or 'gh:'.

   If the user has multiple keys on the service, all the keys will be added.
   Once the keys are imported, they can be viewed with the `juju ssh-keys`
   command, where comments will indicate which ones were imported in
   this way.

   An alternative to this command is the more manual `juju add-ssh-key`.


   **Examples:**

   Import all public keys associated with user account 'phamilton' on the
   GitHub service:

          juju import-ssh-key gh:phamilton

   Multiple identities may be specified in a space delimited list:
   juju import-ssh-key gh:rheinlein lp:iasmiov gh:hharrison


   **See also:**

   [add-ssh-key](#add-ssh-key)

   [ssh-keys](#ssh-keys)



^# kill-controller

   **Usage:** ` juju kill-controller [options] <controller name>`

   **Summary:**

   Forcibly terminate all machines and other associated resources for a Juju controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-t, --timeout  (= 5m0s)_

   Timeout before direct destruction

   _-y, --yes  (= false)_

   Do not ask for confirmation

   
   **Details:**


   Forcibly destroy the specified controller.  If the API server is accessible,
   this command will attempt to destroy the controller model and all hosted models
   and their resources.

   If the API server is unreachable, the machines of the controller model will be
   destroyed through the cloud provisioner.  If there are additional machines,
   including machines within hosted models, these machines will not be destroyed
   and will never be reconnected to the Juju controller being destroyed.

   The normal process of killing the controller will involve watching the hosted
   models as they are brought down in a controlled manner. If for some reason the
   models do not stop cleanly, there is a default five minute timeout. If no change
   in the model state occurs for the duration of this timeout, the command will
   stop watching and destroy the models directly through the cloud provider.

   **See also:**

   [destroy-controller](#destroy-controller)

   [unregister](#unregister)


 

^# list-actions

   **Usage:** ` juju actions [options] <application name>`

   **Summary:**

   List actions defined for a service.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--schema  (= false)_

   Display the full action schema

   
   **Details:**


   List the actions available to run on the target application, with a short
   description.  To show the full schema for the actions, use --schema.

   For more information, see also the 'run-action' command, which executes actions.

   **Aliases:**

   _list-actions_


 

^# list-agreements

   **Usage:** ` juju agreements [options]`

   **Summary:**

   List user's agreements.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= json)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List terms the user has agreed to.


   **Aliases:**

   _list-agreements_


 

^# list-backups

   **Usage:** ` juju backups [options]`

   **Summary:**

   Displays information about all backups.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   backups provides the metadata associated with all backups.


   **Aliases:**

   _list-backups_


 

^# list-budgets

   **Usage:** ` juju budgets [options]`

   **Summary:**

   List budgets.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List the available budgets.


   **Examples:**


          juju budgets


   **Aliases:**

   _list-budgets_


 

^# list-cached-images

   **Usage:** ` juju cached-images [options]`

   **Summary:**

   Shows cached os images.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--arch (= "")_

   The architecture of the image to list eg amd64

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _--kind (= "")_

   The image kind to list eg lxd

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--series (= "")_

   The series of the image to list eg xenial

   
   **Details:**


   List cached os images in the Juju model.

   Images can be filtered on:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"
   
   The filter attributes are optional.


   **Examples:**


        # List all cached images.
        juju cached-images
        # List cached images for xenial.
        juju cached-images --series xenial
        # List all cached lxd images for xenial amd64.
        juju cached-images --kind lxd --series xenial --arch amd64


   **Aliases:**

   _list-cached-images_


 

^# list-clouds

   **Usage:** ` juju clouds [options]`

   **Summary:**

   Lists all clouds available to Juju.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Provided information includes 'cloud' (as understood by Juju), cloud
   'type', and cloud 'regions'.

   The listing will consist of public clouds and any custom clouds made
   available through the `juju add-cloud` command. The former can be updated
   via the `juju update-cloud` command.

   By default, the tabular format is used.


   **Examples:**


          juju clouds


   **See also:**

   [add-cloud](#add-cloud)

   [regions](#regions)

   [show-cloud](#show-cloud)

   [update-clouds](#update-clouds)

   **Aliases:**

   _list-clouds_


 

^# list-controllers

   **Usage:** ` juju controllers [options]`

   **Summary:**

   Lists all controllers.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--refresh  (= false)_

   Connect to each controller to download the latest details

   
   **Details:**


   The output format may be selected with the '--format' option. In the
   default tabular output, the current controller is marked with an asterisk.

   **Examples:**


          juju controllers
          juju controllers --format json --output ~/tmp/controllers.json


   **See also:**

   [models](#models)

   [show-controller](#show-controller)

   **Aliases:**

   _list-controllers_


 

^# list-credentials

   **Usage:** ` juju credentials [options] [<cloud name>]`

   **Summary:**

   Lists credentials for a cloud.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-secrets  (= false)_

   Show secrets

   
   **Details:**


   Credentials are used with `juju bootstrap`  and `juju add-model`.

   An arbitrary "credential name" is used to represent credentials, which are 
   added either via `juju add-credential` or `juju autoload-credentials`.
   Note that there can be multiple sets of credentials and thus multiple 
   names.

   Actual authentication material is exposed with the '--show-secrets' 
   option.

   A controller and subsequently created models can be created with a 
   different set of credentials but any action taken within the model (e.g.:
   `juju deploy`; `juju add-unit`) applies the set used to create the model. 
   Recall that when a controller is created a 'default' model is also 
   created.

   Credentials denoted with an asterisk '*' are currently set as the default
   for the given cloud.


   **Examples:**


          juju credentials
          juju credentials aws
          juju credentials --format yaml --show-secrets


   **See also:**

   [add-credential](#add-credential)

   [remove-credential](#remove-credential)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)

   **Aliases:**

   _list-credentials_


 

^# list-disabled-commands

   **Usage:** ` juju disabled-commands [options]`

   **Summary:**

   List disabled commands.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Lists for all models (administrative users only)

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List disabled commands for the model.

   Commands that can be disabled are grouped based on logical operations as follows:
   "destroy-model" prevents:

             destroy-controller
             destroy-model
   
   "remove-object" prevents:

             destroy-controller
             destroy-model
             remove-machine
             remove-relation
             remove-application
             remove-unit
   
   "all" prevents:

             add-machine
             add-relation
             add-unit
             add-ssh-key
             add-user
             change-user-password
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-config
             set-constraints
             set-model-config
             sync-tools
             unexpose
             unset-config
             unset-model-config
             upgrade-charm
             upgrade-juju
   
   	

   **See also:**

   [disable-command](#disable-command)

   [enable-command](#enable-command)

   **Aliases:**

   _list-disabled-commands_


 

^# list-machines

   **Usage:** ` juju machines [options]`

   **Summary:**

   Lists machines in a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--color  (= false)_

   Force use of ANSI color codes

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default, the tabular format is used.

   The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


           juju machines


   **See also:**

   [status](#status)

   **Aliases:**

   _list-machines_


 

^# list-models

   **Usage:** ` juju models [options]`

   **Summary:**

   Lists models a user can access on a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Lists all models, regardless of user accessibility (administrative users only)

   _-c, --controller (= "")_

   Controller to operate in

   _--exact-time  (= false)_

   Use full timestamps

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--user (= "")_

   The user to list models for (administrative users only)

   _--uuid  (= false)_

   Display UUID for models

   
   **Details:**


   The models listed here are either models you have created yourself, or
   models which have been shared with you. Default values for user and
   controller are, respectively, the current user and the current controller.
   The active model is denoted by an asterisk.


   **Examples:**


          juju models
          juju models --user bob


   **See also:**

   [add-model](#add-model)

   [share-model](#share-model)

   [unshare-model](#unshare-model)

   **Aliases:**

   _list-models_


 

^# list-payloads

   **Usage:** ` juju payloads [options] [pattern ...]`

   **Summary:**

   display status information about known payloads

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command will report on the runtime state of defined payloads.

   When one or more pattern is given, Juju will limit the results to only
   those payloads which match *any* of the provided patterns. Each pattern
   will be checked against the following info in Juju:

   - unit name
   - machine id
   - payload type
   - payload class
   - payload id
   - payload tag
   - payload status

   **Aliases:**

   _list-payloads_


 

^# list-plans

   **Usage:** ` juju plans [options]`

   **Summary:**

   List plans.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|smart|summary|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List plans available for the specified charm.


   **Examples:**


          juju plans cs:webapp


   **Aliases:**

   _list-plans_


 

^# list-regions

   **Usage:** ` juju regions [options] <cloud>`

   **Summary:**

   Lists regions for a given cloud.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   Details:

   **Examples:**


          juju regions aws


   **See also:**

   [add-cloud](#add-cloud)

   [clouds](#clouds)

   [show-cloud](#show-cloud)

   [update-clouds](#update-clouds)

   **Aliases:**

   _list-regions_


 

^# list-resources

   **Usage:** ` juju resources [options] application-or-unit`

   **Summary:**

   show the resources for a service or unit

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--details  (= false)_

   show detailed information about resources used by each unit.

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command shows the resources required by and those in use by an existing
   application or unit in your model.  When run for an application, it will also show any
   updates available for resources from the charmstore.


   **Aliases:**

   _list-resources_


 

^# list-spaces

   **Usage:** ` juju spaces [options] [--short] [--format yaml|json] [--output <path>]`

   **Summary:**

   List known spaces, including associated subnets

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--short  (= false)_

   only display spaces.

   
   **Details:**


   Displays all defined spaces. If --short is not given both spaces and
   their subnets are displayed, otherwise just a list of spaces. The
   --format argument has the same semantics as in other CLI commands -
   "yaml" is the default. The --output argument allows the command
   output to be redirected to a file.


   **Aliases:**

   _list-spaces_


 

^# list-ssh-keys

   **Usage:** ` juju ssh-keys [options]`

   **Summary:**

   Lists the currently known SSH keys for the current (or specified) model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--full  (= false)_

   Show full key instead of just the fingerprint

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju maintains a per-model cache of SSH keys which it copies to each newly
   created unit.

   This command will display a list of all the keys currently used by Juju in
   the current model (or the model specified, if the '-m' option is used).
   By default a minimal list is returned, showing only the fingerprint of
   each key and its text identifier. By using the '--full' option, the entire
   key may be displayed.


   **Examples:**


          juju ssh-keys

   To examine the full key, use the '--full' option:

          juju ssh-keys -m jujutest --full


   **Aliases:**

   _list-ssh-keys_


 

^# list-storage

   **Usage:** ` juju storage [options] <machineID> ...`

   **Summary:**

   Lists storage details.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--filesystem  (= false)_

   List filesystem storage

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--volume  (= false)_

   List volume storage

   
   **Details:**


   List information about storage instances.


   **Aliases:**

   _list-storage_


 

^# list-storage-pools

   **Usage:** ` juju storage-pools [options]`

   **Summary:**

   List storage pools.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--name  (= )_

   Only show pools with these names

   _-o, --output (= "")_

   Specify an output file

   _--provider  (= )_

   Only show pools of these provider types

   
   **Details:**


   The user can filter on pool type, name.

   If no filter is specified, all current pools are listed.

   If at least 1 name and type is specified, only pools that match both a name
   AND a type from criteria are listed.

   If only names are specified, only mentioned pools will be listed.

   If only types are specified, all pools of the specified types will be listed.
   Both pool types and names must be valid.

   Valid pool types are pool types that are registered for Juju model.


   **Aliases:**

   _list-storage-pools_


 

^# list-subnets

   **Usage:** ` juju subnets [options] [--space <name>] [--zone <name>] [--format yaml|json] [--output <path>]`

   **Summary:**

   List subnets known to Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--space (= "")_

   Filter results by space name

   _--zone (= "")_

   Filter results by zone name

   
   **Details:**


   Displays a list of all subnets known to Juju. Results can be filtered
   using the optional --space and/or --zone arguments to only display
   subnets associated with a given network space and/or availability zone.
   Like with other Juju commands, the output and its format can be changed
   using the --format and --output (or -o) optional arguments. Supported
   output formats include "yaml" (default) and "json". To redirect the
   output to a file, use --output.


   **Aliases:**

   _list-subnets_


 

^# list-users

   **Usage:** ` juju users [options]`

   **Summary:**

   Lists Juju users allowed to connect to a controller or model.

   **Options:**

   _--all  (= false)_

   Include disabled users

   _-c, --controller (= "")_

   Controller to operate in

   _--exact-time  (= false)_

   Use full timestamp for connection times

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   When used without a model name argument, users relevant to a controller are printed.
   When used with a model name, users relevant to the specified model are printed.

   **Examples:**


          Print the users relevant to the current controller: 
          juju users
          
          Print the users relevant to the controller "another":
          juju users -c another
          Print the users relevant to the model "mymodel":
          juju users mymodel


   **See also:**

   [add-user](#add-user)

   [register](#register)

   [show-user](#show-user)

   [disable-user](#disable-user)

   [enable-user](#enable-user)

   **Aliases:**

   _list-users_


 

^# login

   **Usage:** ` juju login [options] [username]`

   **Summary:**

   Logs a user in to a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   After login, a token ("macaroon") will become active. It has an expiration
   time of 24 hours. Upon expiration, no further Juju commands can be issued
   and the user will be prompted to log in again.


   **Examples:**


          juju login bob


   **See also:**

   [disable-user](#disable-user)

   [enable-user](#enable-user)

   [logout](#logout)


 

^# logout

   **Usage:** ` juju logout [options]`

   **Summary:**

   Logs a Juju user out of a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--force  (= false)_

   Force logout when a locally recorded password is detected

   
   **Details:**


   If another client has logged in as the same user, they will remain logged
   in. This command only affects the local client.

   The command will fail if the user has not yet set a password
   (`juju change-user-password`). This scenario is only possible after 
   `juju bootstrap`since `juju register` sets a password. The
   failing behaviour can be overridden with the '--force' option.

   If the same user is logged in with another client system, that user session
   will not be affected by this command; it only affects the local client.
   By default, the controller is the current controller.


   **Examples:**


          juju logout


   **See also:**

   [change-user-password](#change-user-password)

   [login](#login)


 

^# machines

   **Usage:** ` juju machines [options]`

   **Summary:**

   Lists machines in a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--color  (= false)_

   Force use of ANSI color codes

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default, the tabular format is used.

   The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


           juju machines


   **See also:**

   [status](#status)

   **Aliases:**

   _list-machines_


 

^# metrics

   **Usage:** ` juju metrics [options] [tag1[...tagN]]`

   **Summary:**

   Retrieve metrics collected by specified entities.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   retrieve metrics collected by all units in the model

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Display recently collected metrics.



 

^# model-config

   **Usage:** ` juju model-config [options] [<model-key>[<=value>] ...]`

   **Summary:**

   Displays or sets configuration values on a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--reset  (= )_

   Reset the provided comma delimited keys

   
   **Details:**


   By default, all configuration (keys, source, and values) for the current model
   are displayed.

   Supplying one key name returns only the value for the key. Supplying key=value
   will set the supplied key to the supplied value, this can be repeated for
   multiple keys.

   Examples
             juju model-config default-series
             juju model-config -m mycontroller:mymodel
             juju model-config ftp-proxy=10.0.0.1:8000
             juju model-config -m othercontroller:mymodel default-series=yakkety test-mode=false
             juju model-config --reset default-series test-mode

   **See also:**

   [models](#models)

   [model-defaults](#model-defaults)


 

^# model-defaults

   **Usage:** ` juju model-defaults [options] [[<cloud/>]<region> ]<model-key>[<=value>] ...]`

   **Summary:**

   Displays or sets default configuration settings for a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--reset  (= )_

   Reset the provided comma delimited keys

   
   **Details:**


   By default, all default configuration (keys and values) are
   displayed if a key is not specified. Supplying key=value will set the
   supplied key to the supplied value. This can be repeated for multiple keys.
   By default, the model is the current model.


   **Examples:**


          juju model-defaults
          juju model-defaults http-proxy
          juju model-defaults aws/us-east-1 http-proxy
          juju model-defaults us-east-1 http-proxy
          juju model-defaults -m mymodel type
          juju model-defaults ftp-proxy=10.0.0.1:8000
          juju model-defaults aws/us-east-1 ftp-proxy=10.0.0.1:8000
          juju model-defaults us-east-1 ftp-proxy=10.0.0.1:8000
          juju model-defaults -m othercontroller:mymodel default-series=yakkety test-mode=false
          juju model-defaults --reset default-series test-mode
          juju model-defaults aws/us-east-1 --reset http-proxy
          juju model-defaults us-east-1 --reset http-proxy


   **See also:**

   [models](#models)

   [model-config](#model-config)


 

^# models

   **Usage:** ` juju models [options]`

   **Summary:**

   Lists models a user can access on a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Lists all models, regardless of user accessibility (administrative users only)

   _-c, --controller (= "")_

   Controller to operate in

   _--exact-time  (= false)_

   Use full timestamps

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--user (= "")_

   The user to list models for (administrative users only)

   _--uuid  (= false)_

   Display UUID for models

   
   **Details:**


   The models listed here are either models you have created yourself, or
   models which have been shared with you. Default values for user and
   controller are, respectively, the current user and the current controller.
   The active model is denoted by an asterisk.


   **Examples:**


          juju models
          juju models --user bob


   **See also:**

   [add-model](#add-model)

   [share-model](#share-model)

   [unshare-model](#unshare-model)

   **Aliases:**

   _list-models_


 

^# payloads

   **Usage:** ` juju payloads [options] [pattern ...]`

   **Summary:**

   display status information about known payloads

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command will report on the runtime state of defined payloads.

   When one or more pattern is given, Juju will limit the results to only
   those payloads which match *any* of the provided patterns. Each pattern
   will be checked against the following info in Juju:

   - unit name
   - machine id
   - payload type
   - payload class
   - payload id
   - payload tag
   - payload status

   **Aliases:**

   _list-payloads_


 

^# plans

   **Usage:** ` juju plans [options]`

   **Summary:**

   List plans.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|smart|summary|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List plans available for the specified charm.


   **Examples:**


          juju plans cs:webapp


   **Aliases:**

   _list-plans_


 

^# regions

   **Usage:** ` juju regions [options] <cloud>`

   **Summary:**

   Lists regions for a given cloud.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   Details:

   **Examples:**


          juju regions aws


   **See also:**

   [add-cloud](#add-cloud)

   [clouds](#clouds)

   [show-cloud](#show-cloud)

   [update-clouds](#update-clouds)

   **Aliases:**

   _list-regions_


 

^# register

   **Usage:** ` juju register [options] <registration string>|<controller host name>`

   **Summary:**

   Registers a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   
   **Details:**


   The register command adds details of a controller to the local system.
   This is done either by completing the user registration process that
   began with the 'juju add-user' command, or by providing the DNS host
   name of a public controller.

   To complete the user registration process, you should have been provided
   with a base64-encoded blob of data (the output of 'juju add-user')
   which can be copied and pasted as the <string> argument to 'register'.
   You will be prompted for a password, which, once set, causes the
   registration string to be voided. In order to start using Juju the user
   can now either add a model or wait for a model to be shared with them.
   Some machine providers will require the user to be in possession of
   certain credentials in order to add a model.

   When adding a controller at a public address, authentication via some
   external third party (for example Ubuntu SSO) will be required, usually
   by using a web browser.


   **Examples:**


          juju register MFATA3JvZDAnExMxMDQuMTU0LjQyLjQ0OjE3MDcwExAxMC4xMjguMC4yOjE3MDcwBCBEFCaXerhNImkKKabuX5ULWf2Bp4AzPNJEbXVWgraLrAA=
          juju register public-controller.example.com


   **See also:**

   [add-user](#add-user)

   [change-user-password](#change-user-password)

   [unregister](#unregister)


 

^# relate

   **Usage:** ` juju add-relation [options] <application1>[:<relation name1>] <application2>[:<relation name2>]`

   **Summary:**

   Add a relation between two applications.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   **Aliases:**

   _relate_


 

^# remove-application

   **Usage:** ` juju remove-application [options] <application>`

   **Summary:**

   Remove an application from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Removing an application will terminate any relations that application has, remove
   all units of the application, and in the case that this leaves machines with
   no running applications, Juju will also remove the machine. For this reason,
   you should retrieve any logs or data required from applications and units 
   before removing them. Removing units which are co-located with units of
   other charms or a Juju controller will not result in the removal of the
   machine.


   **Examples:**


          juju remove-application hadoop
          juju remove-application -m test-model mariadb



 

^# remove-backup

   **Usage:** ` juju remove-backup [options] <ID>`

   **Summary:**

   Remove the spcified backup from remote storage.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   remove-backup removes a backup from remote storage.



 

^# remove-cached-images

   **Usage:** ` juju remove-cached-images [options]`

   **Summary:**

   Remove cached OS images.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--arch (= "")_

   The architecture of the image to remove eg amd64

   _--kind (= "")_

   The image kind to remove eg lxd

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--series (= "")_

   The series of the image to remove eg xenial

   
   **Details:**


   Remove cached os images in the Juju model.

   Images are identified by:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"

   **Examples:**


        # Remove cached lxd image for xenial amd64.
        juju remove-cached-images --kind lxd --series xenial --arch amd64



 

^# remove-cloud

   **Usage:** ` juju remove-cloud <cloud name>`

   **Summary:**

   Removes a user-defined cloud from Juju.


   
   **Details:**


   Remove a named, user-defined cloud from Juju.


   **Examples:**


          juju remove-cloud mycloud


   **See also:**

   [add-cloud](#add-cloud)

   [list-clouds](#list-clouds)


 

^# remove-credential

   **Usage:** ` juju remove-credential <cloud name> <credential name>`

   **Summary:**

   Removes credentials for a cloud.


   
   **Details:**


   The credentials to be removed are specified by a "credential name".

   Credential names, and optionally the corresponding authentication
   material, can be listed with `juju credentials`.


   **Examples:**


          juju remove-credential rackspace credential_name


   **See also:**

   [credentials](#credentials)

   [add-credential](#add-credential)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)


 

^# remove-machine

   **Usage:** ` juju remove-machine [options] <machine number> ...`

   **Summary:**

   Removes one or more machines from a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--force  (= false)_

   Completely remove a machine and all its dependencies

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Machines are specified by their numbers, which may be retrieved from the
   output of `juju status`.

   Machines responsible for the model cannot be removed.

   Machines running units or containers can be removed using the '--force'
   option; this will also remove those units and containers without giving
   them an opportunity to shut down cleanly.


   **Examples:**

   Remove machine number 5 which has no running units or containers:

          juju remove-machine 5

   Remove machine 6 and any running units or containers:

          juju remove-machine 6 --force


   **See also:**

   [add-machine](#add-machine)


 

^# remove-relation

   **Usage:** ` juju remove-relation [options] <application1>[:<relation name1>] <application2>[:<relation name2>]`

   **Summary:**

   Removes an existing relation between two applications.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   An existing relation between the two specified applications will be removed. 
   This should not result in either of the applications entering an error state,
   but may result in either or both of the applications being unable to continue
   normal operation. In the case that there is more than one relation between
   two applications it is necessary to specify which is to be removed (see
   examples). Relations will automatically be removed when using the`juju
   remove-application` command.


   **Examples:**


          juju remove-relation mysql wordpress

   In the case of multiple relations, the relation name should be specified
   at least once - the following examples will all have the same effect:

          juju remove-relation mediawiki:db mariadb:db
          juju remove-relation mediawiki mariadb:db
          juju remove-relation mediawiki:db mariadb
       


   **See also:**

   [add-relation](#add-relation)

   [remove-application](#remove-application)


 

^# remove-ssh-key

   **Usage:** ` juju remove-ssh-key [options] <ssh key id> ...`

   **Summary:**

   Removes a public SSH key (or keys) from a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju maintains a per-model cache of public SSH keys which it copies to
   each unit. This command will remove a specified key (or space separated
   list of keys) from the model cache and all current units deployed in that
   model. The keys to be removed may be specified by the key's fingerprint,
   or by the text label associated with them.


   **Examples:**


          juju remove-ssh-key ubuntu@ubuntu
          juju remove-ssh-key 45:7f:33:2c:10:4e:6c:14:e3:a1:a4:c8:b2:e1:34:b4
          juju remove-ssh-key bob@ubuntu carol@ubuntu


   **See also:**

   [ssh-keys](#ssh-keys)

   [add-ssh-key](#add-ssh-key)

   [import-ssh-key](#import-ssh-key)


 

^# remove-unit

   **Usage:** ` juju remove-unit [options] <unit> [...]`

   **Summary:**

   Remove application units from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Remove application units from the model.

   Units of a service are numbered in sequence upon creation. For example, the
   fourth unit of wordpress will be designated "wordpress/3". These identifiers
   can be supplied in a space delimited list to remove unwanted units from the
   model.

   Juju will also remove the machine if the removed unit was the only unit left
   on that machine (including units in containers).

   Removing all units of a service is not equivalent to removing the service
   itself; for that, the `juju remove-service` command is used.


   **Examples:**


          juju remove-unit wordpress/2 wordpress/3 wordpress/4


   **See also:**

   [remove-service](#remove-service)


 

^# remove-user

   **Usage:** ` juju remove-user [options] <user name>`

   **Summary:**

   Deletes a Juju user from a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _-y, --yes  (= false)_

   Confirm deletion of the user

   
   **Details:**


   This removes a user permanently.

   By default, the controller is the current controller.


   **Examples:**


          juju remove-user bob
          juju remove-user bob --yes


   **See also:**

   [unregister](#unregister)

   [revoke](#revoke)

   [show-user](#show-user)

   [list-users](#list-users)

   [switch-user](#switch-user)

   [disable-user](#disable-user)

   [enable-user](#enable-user)

   [change-user-password](#change-user-password)


 

^# resolved

   **Usage:** ` juju resolved [options] <unit>`

   **Summary:**

   Marks unit errors resolved and re-executes failed hooks

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--no-retry  (= false)_

   Do not re-execute failed hooks on the unit


 

^# resources

   **Usage:** ` juju resources [options] application-or-unit`

   **Summary:**

   show the resources for a service or unit

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--details  (= false)_

   show detailed information about resources used by each unit.

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command shows the resources required by and those in use by an existing
   application or unit in your model.  When run for an application, it will also show any
   updates available for resources from the charmstore.


   **Aliases:**

   _list-resources_


 

^# restore-backup

   **Usage:** ` juju restore-backup [options]`

   **Summary:**

   Restore from a backup archive to a new controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-b  (= false)_

   Bootstrap a new state machine

   _--build-agent  (= false)_

   Build binary agent if bootstraping a new machine

   _--constraints (= "")_

   set model constraints

   _--file (= "")_

   Provide a file to be used as the backup.

   _--id (= "")_

   Provide the name of the backup to be restored

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Restores a backup that was previously created with "juju create-backup".
   This command creates a new controller and arranges for it to replace
   the previous controller for a model.  It does *not* restore
   an existing server to a previous state, but instead creates a new server
   with equivalent state.  As part of restore, all known instances are
   configured to treat the new controller as their master.

   The given constraints will be used to choose the new instance.

   If the provided state cannot be restored, this command will fail with
   an appropriate message.  For instance, if the existing bootstrap
   instance is already running then the command will fail with a message
   to that effect.



 

^# retry-provisioning

   **Usage:** ` juju retry-provisioning [options] <machine> [...]`

   **Summary:**

   Retries provisioning for failed machines.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`


 

^# revoke

   **Usage:** ` juju revoke [options] <user> <permission> [<model name> ...]`

   **Summary:**

   Revokes access from a Juju user for a model or controller

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   By default, the controller is the current controller.

   Revoking write access, from a user who has that permission, will leave
   that user with read access. Revoking read access, however, also revokes
   write access.


   **Examples:**

   Revoke 'read' (and 'write') access from user 'joe' for model 'mymodel':

          juju revoke joe read mymodel

   Revoke 'write' access from user 'sam' for models 'model1' and 'model2':

          juju revoke sam write model1 model2

   Revoke 'add-model' access from user 'maria' to the controller:

          juju revoke maria add-model


   **See also:**

   [grant](#grant)


 

^# run

   **Usage:** ` juju run [options] <commands>`

   **Summary:**

   Run the commands on the remote targets specified.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Run the commands on all the machines

   _--application  (= )_

   One or more application names

   _--format  (= default)_

   Specify output format (default|json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--machine  (= )_

   One or more machine ids

   _-o, --output (= "")_

   Specify an output file

   _--timeout  (= 5m0s)_

   How long to wait before the remote command is considered to have failed

   _--unit  (= )_

   One or more unit ids

   
   **Details:**


   Run the commands on the specified targets. Only admin users of a model
   are able to use this command.

   Targets are specified using either machine ids, application names or unit
   names.  At least one target specifier is needed.

   Multiple values can be set for --machine, --application, and --unit by using
   comma separated values.

   If the target is a machine, the command is run as the "ubuntu" user on
   the remote machine.

   If the target is an application, the command is run on all units for that
   application. For example, if there was an application "mysql" and that application
   had two units, "mysql/0" and "mysql/1", then
           --application mysql
   
   is equivalent to
           --unit mysql/0,mysql/1
   
   Commands run for applications or units are executed in a 'hook context' for
   the unit.

   --all is provided as a simple way to run the command on all the machines
   in the model.  If you specify --all you cannot provide additional
   targets.

   Since juju run creates actions, you can query for the status of commands
   started with juju run by calling "juju show-action-status --name juju-run".


 

^# run-action

   **Usage:** ` juju run-action [options] <unit> <action name> [key.key.key...=value]`

   **Summary:**

   Queue an action for execution.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--params  (= )_

   Path to yaml-formatted params file

   _--string-args  (= false)_

   Use raw string values of CLI args

   
   **Details:**


   Queue an Action for execution on a given unit, with a given set of params.
   The Action ID is returned for use with 'juju show-action-output <ID>' or
   'juju show-action-status <ID>'.

          
   
   Params are validated according to the charm for the unit's application.  The 
   valid params can be seen using "juju actions <application> --schema".

   Params may be in a yaml file which is passed with the --params flag, or they
   may be specified by a key.key.key...=value format (see examples below.)
   Params given in the CLI invocation will be parsed as YAML unless the
   --string-args flag is set.  This can be helpful for values such as 'y', which
   is a boolean true in YAML.

   If --params is passed, along with key.key...=value explicit arguments, the
   explicit arguments will override the parameter file.


   **Examples:**

   $ juju run-action mysql/3 backup 
   action: <ID>
   $ juju show-action-output <ID>
   result:

        status: success
        file:
          size: 873.2
          units: GB
          name: foo.sql

   $ juju run-action mysql/3 backup --params parameters.yml
   ...
   Params sent will be the contents of parameters.yml.
   ...
   $ juju run-action mysql/3 backup out=out.tar.bz2 file.kind=xz file.quality=high
   ...
   Params sent will be:
   out: out.tar.bz2
   file:

        kind: xz
        quality: high

   ...
   $ juju run-action mysql/3 backup --params p.yml file.kind=xz file.quality=high
   ...
   If p.yml contains:
   file:

        location: /var/backups/mysql/
        kind: gzip

   then the merged args passed will be:
   file:

        location: /var/backups/mysql/
        kind: xz
        quality: high

   ...
   $ juju run-action sleeper/0 pause time=1000
   ...
   $ juju run-action sleeper/0 pause --string-args time=1000
   ...
   The value for the "time" param will be the string literal "1000".



 

^# scp

   **Usage:** ` juju scp [options] <source> <destination>`

   **Summary:**

   Transfers files to/from a Juju machine.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--no-host-key-checks  (= false)_

   Skip host key checking (INSECURE)

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= true)_

   Enable pseudo-tty allocation

   
   **Details:**


   The source or destination arguments may either be a local path or a remote
   location. The syntax for a remote location is:

             [<user>@]<target>:[<path>]
   
   If the user is not specified, "ubuntu" is used. If <path> is not specified, it
   defaults to the home directory of the remote user account.

   The <target> may be either a 'unit name' or a 'machine id'. These can be
   obtained from the output of "juju status".

   Options specific to scp can be provided after a "--". Refer to the scp(1) man
   page for an explanation of those options. The "-r" option to recursively copy a
   directory is particularly useful.

   The SSH host keys of the target are verified. The --no-host-key-checks option
   can be used to disable these checks. Use of this option is not recommended as
   it opens up the possibility of a man-in-the-middle attack.


   **Examples:**

   Copy file /var/log/syslog from machine 2 to the client's current working
   directory:

          juju scp 2:/var/log/syslog .

   Recursively copy the /var/log/mongodb directory from a mongodb unit to the
   client's local remote-logs directory:

          juju scp -- -r mongodb/0:/var/log/mongodb/ remote-logs

   Copy foo.txt from the client's current working directory to an apache2 unit of
   model "prod". Proxy the SSH connection through the controller and turn on scp
   compression:

          juju scp -m prod --proxy -- -C foo.txt apache2/1:

   Copy multiple files from the client's current working directory to machine 2:

          juju scp file1 file2 2:

   Copy multiple files from the bob user account on machine 3 to the client's
   current working directory:

          juju scp bob@3:'file1 file2' .

   Copy file.dat from machine 0 to the machine hosting unit foo/0 (-3
   causes the transfer to be made via the client):

          juju scp -- -3 0:file.dat foo/0:


   **See also:**

   [ssh](#ssh)


 

^# set-budget

   **Usage:** ` juju set-budget [options] <budget name> <value>`

   **Summary:**

   Set the budget limit.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   
   **Details:**


   Set the monthly budget limit.


   **Examples:**


          # Sets the monthly limit for budget named 'personal' to 96.
          juju set-budget personal 96



 

^# set-constraints

   **Usage:** ` juju set-constraints [options] <application> <constraint>=<value> ...`

   **Summary:**

   Sets machine constraints for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Sets constraints for an application, which are used for all new machines 
   provisioned for that application. They can be viewed with `juju get-
   constraints`.

   By default, the model is the current model.

   Application constraints are combined with model constraints, set with `juju 
   set-model-constraints`, for commands (such as 'juju deploy') that 
   provision machines for applications. Where model and application constraints
   overlap, the application constraints take precedence.

   Constraints for a specific model can be viewed with `juju get-model-
   constraints`.

   This command requires that the application to have at least one unit. To apply 
   constraints to
   the first unit set them at the model level or pass them as an argument
   when deploying.


   **Examples:**


          juju set-constraints mysql mem=8G cores=4
          juju set-constraints -m mymodel apache2 mem=8G arch=amd64


   **See also:**

   [get-constraints](#get-constraints)

   [get-model-constraints](#get-model-constraints)

   [set-model-constraints](#set-model-constraints)


 

^# set-default-credential

   **Usage:** ` juju set-default-credential <cloud name> <credential name>`

   **Summary:**

   Sets the default credentials for a cloud.


   
   **Details:**


   The default credentials are specified with a "credential name". A 
   credential name is created during the process of adding credentials either 
   via `juju add-credential` or `juju autoload-credentials`. Credential names 
   can be listed with `juju credentials`.

   Default credentials avoid the need to specify a particular set of 
   credentials when more than one are available for a given cloud.


   **Examples:**


          juju set-default-credential google credential_name


   **See also:**

   [credentials](#credentials)

   [add-credential](#add-credential)

   [remove-credential](#remove-credential)

   [autoload-credentials](#autoload-credentials)


 

^# set-default-region

   **Usage:** ` juju set-default-region <cloud name> <region>`

   **Summary:**

   Sets the default region for a cloud.


   
   **Details:**


   The default region is specified directly as an argument.


   **Examples:**


          juju set-default-region azure-china chinaeast


   **See also:**

   [add-credential](#add-credential)


 

^# set-meter-status

   **Usage:** ` juju set-meter-status [options] [application or unit] status`

   **Summary:**

   Sets the meter status on an application or unit.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--info (= "")_

   Set the meter status info to this string

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Set meter status on the given application or unit. This command is used
   to test the meter-status-changed hook for charms in development.


   **Examples:**


          # Set Red meter status on all units of myapp
          juju set-meter-status myapp RED
          # Set AMBER meter status with "my message" as info on unit myapp/0
          juju set-meter-status myapp/0 AMBER --info "my message"



 

^# set-model-constraints

   **Usage:** ` juju set-model-constraints [options] <constraint>=<value> ...`

   **Summary:**

   Sets machine constraints on a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Sets machine constraints on the model that can be viewed with
   `juju get-model-constraints`.  By default, the model is the current model.
   Model constraints are combined with constraints set for an application with
   `juju set-constraints` for commands (such as 'deploy') that provision
   machines for applications. Where model and application constraints overlap, the
   application constraints take precedence.

   Constraints for a specific application can be viewed with `juju get-constraints`.

   **Examples:**


          juju set-model-constraints cores=8 mem=16G
          juju set-model-constraints -m mymodel root-disk=64G


   **See also:**

   [models](#models)

   [get-model-constraints](#get-model-constraints)

   [get-constraints](#get-constraints)

   [set-constraints](#set-constraints)


 

^# set-plan

   **Usage:** ` juju set-plan [options] <application name> <plan>`

   **Summary:**

   Set the plan for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Set the plan for the deployed application, effective immediately.

   The specified plan name must be a valid plan that is offered for this
   particular charm. Use "juju list-plans <charm>" for more information.


   **Examples:**


          juju set-plan myapp example/uptime



 

^# show-action-output

   **Usage:** ` juju show-action-output [options] <action ID>`

   **Summary:**

   Show results of an action by ID.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--wait (= "-1s")_

   Wait for results

   
   **Details:**


   Show the results returned by an action with the given ID.  A partial ID may
   also be used.  To block until the result is known completed or failed, use
   the --wait flag with a duration, as in --wait 5s or --wait 1h.  Use --wait 0
   to wait indefinitely.  If units are left off, seconds are assumed.

   The default behavior without --wait is to immediately check and return; if
   the results are "pending" then only the available information will be
   displayed.  This is also the behavior when any negative time is given.


 

^# show-action-status

   **Usage:** ` juju show-action-status [options] [<action ID>|<action ID prefix>]`

   **Summary:**

   Show results of all actions filtered by optional ID prefix.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--name (= "")_

   Action name

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show the status of Actions matching given ID, partial ID prefix, or all Actions if no ID is supplied.
   If --name <name> is provided the search will be done by name rather than by ID.


 

^# show-backup

   **Usage:** ` juju show-backup [options] <ID>`

   **Summary:**

   Show metadata for the specified backup.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   show-backup provides the metadata associated with a backup.



 

^# show-budget

   **Usage:** ` juju show-budget [options] <budget>`

   **Summary:**

   Show details about a budget.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Display budget usage information.


   **Examples:**


          juju show-budget personal



 

^# show-cloud

   **Usage:** ` juju show-cloud [options] <cloud name>`

   **Summary:**

   Shows detailed information on a cloud.

   **Options:**

   _--format  (= yaml)_

   Specify output format (yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Provided information includes 'defined' (public, built-in), 'type',
   'auth-type', 'regions', and 'endpoints'.


   **Examples:**


          juju show-cloud google
          juju show-cloud azure-china --output ~/azure_cloud_details.txt


   **See also:**

   [clouds](#clouds)

   [update-clouds](#update-clouds)


 

^# show-controller

   **Usage:** ` juju show-controller [options] [<controller name> ...]`

   **Summary:**

   Shows detailed information of a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-password  (= false)_

   Show password for logged in user

   
   **Details:**


   Shows extended information about a controller(s) as well as related models
   and user login details.


   **Examples:**


          juju show-controller
          juju show-controller aws google
          


   **See also:**

   [controllers](#controllers)


 

^# show-machine

   **Usage:** ` juju show-machine [options] <machineID> ...`

   **Summary:**

   Show a machine's status.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--color  (= false)_

   Force use of ANSI color codes

   _--format  (= yaml)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   Show a specified machine on a model.  Default format is in yaml,
   other formats can be specified with the "--format" option.

   Available formats are yaml, tabular, and json

   **Examples:**


          # Display status for machine 0
          juju show-machine 0
          # Display status for machines 1, 2 & 3
          juju show-machine 1 2 3



 

^# show-model

   **Usage:** ` juju show-model [options] <model name>`

   **Summary:**

   Shows information about the current or specified model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show information about the current or specified model


 

^# show-status

   **Usage:** ` juju show-status [options] [filter pattern ...]`

   **Summary:**

   Reports the current status of the model, machines, applications and units.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--color  (= false)_

   Force use of ANSI color codes

   _--format  (= tabular)_

   Specify output format (json|line|oneline|short|summary|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default (without argument), the status of the model, including all
   applications and units will be output.

   Application or unit names may be used as output filters (the '*' can be used as
   a wildcard character). In addition to matched applications and units, related
   machines, applications, and units will also be displayed. If a subordinate unit
   is matched, then its principal unit will be displayed. If a principal unit is
   matched, then all of its subordinates will be displayed.

   The available output formats are:

   - tabular (default): Displays status in a tabular format with a separate table
               for the model, machines, applications, relations (if any) and units.
               Note: in this format, the AZ column refers to the cloud region's
               availability zone.

   
   - {short|line|oneline}: List units and their subordinates. For each unit, the IP
               address and agent status are listed.

   
   - summary: Displays the subnet(s) and port(s) the model utilises. Also displays
               aggregate information about:

               - Machines: total #, and # in each state.

               - Units: total #, and # in each state.

               - Applications: total #, and # exposed of each application.
   
   - yaml: Displays information about the model, machines, applications, and units
               in structured YAML format.

   
   - json: Displays information about the model, machines, applications, and units
               in structured JSON format.


   **Examples:**


          juju show-status
          juju show-status mysql
          juju show-status nova-*


   **See also:**

   [machines](#machines)

   [show-model](#show-model)

   [show-status-log](#show-status-log)

   [storage](#storage)

   **Aliases:**

   _status_


 

^# show-status-log

   **Usage:** ` juju show-status-log [options] <entity name>`

   **Summary:**

   Output past statuses for the specified entity.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--date (= "")_

   Returns logs for any date after the passed one, the expected date format is YYYY-MM-DD (cannot be combined with -n or --days)

   _--days  (= 0)_

   Returns the logs for the past <days> days (cannot be combined with -n or --date)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-n  (= 0)_

   Returns the last N logs (cannot be combined with --days or --date)

   _--type (= "unit")_

   Type of statuses to be displayed [agent|workload|combined|machine|machineInstance|container|containerinstance]

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   This command will report the history of status changes for
   a given entity.

   The statuses are available for the following types.

   -type supports:

             juju-unit: will show statuses for the unit's juju agent.

             workload: will show statuses for the unit's workload.

             unit: will show workload and juju agent combined for the specified unit.
             juju-machine: will show statuses for machine's juju agent.

             machine: will show statuses for machines.

             juju-container: will show statuses for the container's juju agent.
             container: will show statuses for containers.

          and sorted by time of occurrence.

          The default is unit.



 

^# show-storage

   **Usage:** ` juju show-storage [options] <storage ID> [...]`

   **Summary:**

   Shows storage instance information.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show extended information about storage instances.

   Storage instances to display are specified by storage ids.

   * note use of positional arguments


 

^# show-user

   **Usage:** ` juju show-user [options] [<user name>]`

   **Summary:**

   Show information about a user.

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   _--exact-time  (= false)_

   Use full timestamp for connection times

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   By default, the YAML format is used and the user name is the current
   user.


   **Examples:**


          juju show-user
          juju show-user jsmith
          juju show-user --format json
          juju show-user --format yaml
          


   **See also:**

   [add-user](#add-user)

   [register](#register)

   [users](#users)


 

^# spaces

   **Usage:** ` juju spaces [options] [--short] [--format yaml|json] [--output <path>]`

   **Summary:**

   List known spaces, including associated subnets

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--short  (= false)_

   only display spaces.

   
   **Details:**


   Displays all defined spaces. If --short is not given both spaces and
   their subnets are displayed, otherwise just a list of spaces. The
   --format argument has the same semantics as in other CLI commands -
   "yaml" is the default. The --output argument allows the command
   output to be redirected to a file.


   **Aliases:**

   _list-spaces_


 

^# ssh

   **Usage:** ` juju ssh [options] <[user@]target> [command]`

   **Summary:**

   Initiates an SSH session or executes a command on a Juju machine.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--no-host-key-checks  (= false)_

   Skip host key checking (INSECURE)

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= true)_

   Enable pseudo-tty allocation

   
   **Details:**


   The machine is identified by the <target> argument which is either a 'unit
   name' or a 'machine id'. Both are obtained in the output to "juju status". If
   'user' is specified then the connection is made to that user account;
   otherwise, the default 'ubuntu' account, created by Juju, is used.

   The optional command is executed on the remote machine. Any output is sent back
   to the user. Screen-based programs require the default of '--pty=true'.
   The SSH host keys of the target are verified. The --no-host-key-checks option
   can be used to disable these checks. Use of this option is not recommended as
   it opens up the possibility of a man-in-the-middle attack.


   **Examples:**

   Connect to machine 0:

          juju ssh 0

   Connect to machine 1 and run command 'uname -a':

          juju ssh 1 uname -a

   Connect to a mysql unit:

          juju ssh mysql/0

   Connect to a jenkins unit as user jenkins:

          juju ssh jenkins@jenkins/0


   **See also:**

   [scp](#scp)


 

^# ssh-keys

   **Usage:** ` juju ssh-keys [options]`

   **Summary:**

   Lists the currently known SSH keys for the current (or specified) model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--full  (= false)_

   Show full key instead of just the fingerprint

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Juju maintains a per-model cache of SSH keys which it copies to each newly
   created unit.

   This command will display a list of all the keys currently used by Juju in
   the current model (or the model specified, if the '-m' option is used).
   By default a minimal list is returned, showing only the fingerprint of
   each key and its text identifier. By using the '--full' option, the entire
   key may be displayed.


   **Examples:**


          juju ssh-keys

   To examine the full key, use the '--full' option:

          juju ssh-keys -m jujutest --full


   **Aliases:**

   _list-ssh-keys_


 

^# status

   **Usage:** ` juju show-status [options] [filter pattern ...]`

   **Summary:**

   Reports the current status of the model, machines, applications and units.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--color  (= false)_

   Force use of ANSI color codes

   _--format  (= tabular)_

   Specify output format (json|line|oneline|short|summary|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default (without argument), the status of the model, including all
   applications and units will be output.

   Application or unit names may be used as output filters (the '*' can be used as
   a wildcard character). In addition to matched applications and units, related
   machines, applications, and units will also be displayed. If a subordinate unit
   is matched, then its principal unit will be displayed. If a principal unit is
   matched, then all of its subordinates will be displayed.

   The available output formats are:

   - tabular (default): Displays status in a tabular format with a separate table
               for the model, machines, applications, relations (if any) and units.
               Note: in this format, the AZ column refers to the cloud region's
               availability zone.

   
   - {short|line|oneline}: List units and their subordinates. For each unit, the IP
               address and agent status are listed.

   
   - summary: Displays the subnet(s) and port(s) the model utilises. Also displays
               aggregate information about:

               - Machines: total #, and # in each state.

               - Units: total #, and # in each state.

               - Applications: total #, and # exposed of each application.
   
   - yaml: Displays information about the model, machines, applications, and units
               in structured YAML format.

   
   - json: Displays information about the model, machines, applications, and units
               in structured JSON format.


   **Examples:**


          juju show-status
          juju show-status mysql
          juju show-status nova-*


   **See also:**

   [machines](#machines)

   [show-model](#show-model)

   [show-status-log](#show-status-log)

   [storage](#storage)

   **Aliases:**

   _status_


 

^# storage

   **Usage:** ` juju storage [options] <machineID> ...`

   **Summary:**

   Lists storage details.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--filesystem  (= false)_

   List filesystem storage

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--volume  (= false)_

   List volume storage

   
   **Details:**


   List information about storage instances.


   **Aliases:**

   _list-storage_


 

^# storage-pools

   **Usage:** ` juju storage-pools [options]`

   **Summary:**

   List storage pools.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--name  (= )_

   Only show pools with these names

   _-o, --output (= "")_

   Specify an output file

   _--provider  (= )_

   Only show pools of these provider types

   
   **Details:**


   The user can filter on pool type, name.

   If no filter is specified, all current pools are listed.

   If at least 1 name and type is specified, only pools that match both a name
   AND a type from criteria are listed.

   If only names are specified, only mentioned pools will be listed.

   If only types are specified, all pools of the specified types will be listed.
   Both pool types and names must be valid.

   Valid pool types are pool types that are registered for Juju model.


   **Aliases:**

   _list-storage-pools_


 

^# subnets

   **Usage:** ` juju subnets [options] [--space <name>] [--zone <name>] [--format yaml|json] [--output <path>]`

   **Summary:**

   List subnets known to Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _-o, --output (= "")_

   Specify an output file

   _--space (= "")_

   Filter results by space name

   _--zone (= "")_

   Filter results by zone name

   
   **Details:**


   Displays a list of all subnets known to Juju. Results can be filtered
   using the optional --space and/or --zone arguments to only display
   subnets associated with a given network space and/or availability zone.
   Like with other Juju commands, the output and its format can be changed
   using the --format and --output (or -o) optional arguments. Supported
   output formats include "yaml" (default) and "json". To redirect the
   output to a file, use --output.


   **Aliases:**

   _list-subnets_


 

^# switch

   **Usage:** ` juju switch [options] [<controller>|<model>|<controller>:<model>]`

   **Summary:**

   Selects or identifies the current controller and model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   
   **Details:**


   When used without an argument, the command shows the current controller 
   and its active model. 
   When switching by controller name alone, the model
   you get is the active model for that controller. If you want a different
   model then you must switch using controller:model notation or switch to 
   the controller and then to the model. 
   The `juju models` command can be used to determine the active model
   (of any controller). An asterisk denotes it.


   **Examples:**


          juju switch
          juju switch mymodel
          juju switch mycontroller
          juju switch mycontroller:mymodel


   **See also:**

   [controllers](#controllers)

   [models](#models)

   [show-controller](#show-controller)


 

^# sync-tools

   **Usage:** ` juju sync-tools [options]`

   **Summary:**

   Copy tools from the official tool store into a local model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Copy all versions, not just the latest

   _--destination (= "")_

   Local destination directory

   DEPRECATED: use --local-dir instead

   _--dev  (= false)_

   Consider development versions as well as released ones

   DEPRECATED: use --stream instead

   _--dry-run  (= false)_

   Don't copy, just print what would be copied

   _--local-dir (= "")_

   Local destination directory

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--public  (= false)_

   Tools are for a public cloud, so generate mirrors information

   _--source (= "")_

   Local source directory

   _--stream (= "")_

   Simplestreams stream for which to sync metadata

   _--version (= "")_

   Copy a specific major[.minor] version

   
   **Details:**


   This copies the Juju agent software from the official tools store (located
   at https://streams.canonical.com/juju) into a model. It is generally done
   when the model is without Internet access.

   Instead of the above site, a local directory can be specified as source.
   The online store will, of course, need to be contacted at some point to get
   the software.


   **Examples:**


          # Download the software (version auto-selected) to the model:
          juju sync-tools --debug
          # Download a specific version of the software locally:
          juju sync-tools --debug --version 2.0 --local-dir=/home/ubuntu/sync-tools
          # Get locally available software to the model:
          juju sync-tools --debug --source=/home/ubuntu/sync-tools


   **See also:**

   [upgrade-juju](#upgrade-juju)


 

^# unexpose

   **Usage:** ` juju unexpose [options] <application name>`

   **Summary:**

   Removes public availability over the network for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Adjusts the firewall rules and any relevant security mechanisms of the
   cloud to deny public access to the application.

   An application is unexposed by default when it gets created.


   **Examples:**


          juju unexpose wordpress


   **See also:**

   [expose](#expose)


 

^# unregister

   **Usage:** ` juju unregister [options] <controller name>`

   **Summary:**

   Unregisters a Juju controller

   **Options:**

   _-y, --yes  (= false)_

   Do not prompt for confirmation

   
   **Details:**


   Removes local connection information for the specified controller.  This
   command does not destroy the controller.  In order to regain access to an
   unregistered controller, it will need to be added again using the juju register
   command.


   **Examples:**


          juju unregister my-controller


   **See also:**

   [destroy-controller](#destroy-controller)

   [kill-controller](#kill-controller)

   [register](#register)


 

^# update-allocation

   **Usage:** ` juju update-allocation [options] <application> <value>`

   **Summary:**

   Update an allocation.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   Updates an existing allocation on an application.


   **Examples:**


          # Sets the allocation for the wordpress application to 10.
          juju update-allocation wordpress 10



 

^# update-clouds

   **Usage:** ` juju update-clouds`

   **Summary:**

   Updates public cloud information available to Juju.


   
   **Details:**


   If any new information for public clouds (such as regions and connection
   endpoints) are available this command will update Juju accordingly. It is
   suggested to run this command periodically.


   **Examples:**


          juju update-clouds


   **See also:**

   [clouds](#clouds)


 

^# update-credential

   **Usage:** ` juju update-credential [options] <cloud-name> <credential-name>`

   **Summary:**

   Updates a credential for a cloud.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--cloud (= "")_

   Cloud for which to update the credential

   _--credential (= "")_

   Name of credential to update

   
   **Details:**


   Updates a named credential for a cloud.


   **Examples:**


          juju update-credential aws mysecrets


   **See also:**

   [add-credential](#add-credential)

   [credentials](#credentials)


 

^# upgrade-charm

   **Usage:** ` juju upgrade-charm [options] <application>`

   **Summary:**

   Upgrade an application's charm.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--channel (= "")_

   Channel to use when getting the charm or bundle from the charm store

   _--config  (= )_

   Path to yaml-formatted application config

   _--force-series  (= false)_

   Upgrade even if series of deployed applications are not supported by the new charm

   _--force-units  (= false)_

   Upgrade all units immediately, even if in error state

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--path (= "")_

   Upgrade to a charm located at path

   _--resource  (= )_

   Resource to be uploaded to the controller

   _--revision  (= -1)_

   Explicit revision of current charm

   _--storage  (= )_

   Charm storage constraints

   _--switch (= "")_

   Crossgrade to a different charm

   
   **Details:**


   When no flags are set, the application's charm will be upgraded to the latest
   revision available in the repository from which it was originally deployed. An
   explicit revision can be chosen with the --revision flag.

   A path will need to be supplied to allow an updated copy of the charm
   to be located.

   Deploying from a path is intended to suit the workflow of a charm author working
   on a single client machine; use of this deployment method from multiple clients
   is not supported and may lead to confusing behaviour. Each local charm gets
   uploaded with the revision specified in the charm, if possible, otherwise it
   gets a unique revision (highest in state + 1).

   When deploying from a path, the --path flag is used to specify the location from
   which to load the updated charm. Note that the directory containing the charm must
   match what was originally used to deploy the charm as a superficial check that the
   updated charm is compatible.

   Resources may be uploaded at upgrade time by specifying the --resource flag.
   Following the resource flag should be name=filepath pair.  This flag may be
   repeated more than once to upload more than one resource.

           juju upgrade-charm foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml
   
   Where bar and baz are resources named in the metadata for the foo charm.
   Storage constraints may be added or updated at upgrade time by specifying
   the --storage flag, with the same format as specified in "juju deploy".
   If new required storage is added by the new charm revision, then you must
   specify constraints or the defaults will be applied.

           juju upgrade-charm foo --storage cache=ssd,10G
   
   Charm settings may be added or updated at upgrade time by specifying the
   --config flag, pointing to a YAML-encoded application config file.

           juju upgrade-charm foo --config config.yaml
   
   If the new version of a charm does not explicitly support the application's series, the
   upgrade is disallowed unless the --force-series flag is used. This option should be
   used with caution since using a charm on a machine running an unsupported series may
   cause unexpected behavior.

   The --switch flag allows you to replace the charm with an entirely different one.
   The new charm's URL and revision are inferred as they would be when running a
   deploy command.

   Please note that --switch is dangerous, because juju only has limited
   information with which to determine compatibility; the operation will succeed,
   regardless of potential havoc, so long as the following conditions hold:
   - The new charm must declare all relations that the application is currently
   participating in.

   - All config settings shared by the old and new charms must
   have the same types.

   The new charm may add new relations and configuration settings.

   --switch and --path are mutually exclusive.

   --path and --revision are mutually exclusive. The revision of the updated charm
   is determined by the contents of the charm at the specified path.

   --switch and --revision are mutually exclusive. To specify a given revision
   number with --switch, give it in the charm URL, for instance "cs:wordpress-5"
   would specify revision number 5 of the wordpress charm.

   Use of the --force-units flag is not generally recommended; units upgraded while in an
   error state will not have upgrade-charm hooks executed, and may cause unexpected
   behavior.



 

^# upgrade-gui

   **Usage:** ` juju upgrade-gui [options]`

   **Summary:**

   Upgrade to a new Juju GUI version.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--list  (= false)_

   List available Juju GUI release versions without upgrading

   
   **Details:**


   Upgrade to the latest Juju GUI released version:

   	juju upgrade-gui
   Upgrade to a specific Juju GUI released version:

   	juju upgrade-gui 2.2.0
   Upgrade to a Juju GUI version present in a local tar.bz2 GUI release file:
   	juju upgrade-gui /path/to/jujugui-2.2.0.tar.bz2
   List available Juju GUI releases without upgrading:

   	juju upgrade-gui --list


 

^# upgrade-juju

   **Usage:** ` juju upgrade-juju [options]`

   **Summary:**

   Upgrades Juju on all machines in a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--agent-version (= "")_

   Upgrade to specific version

   _--build-agent  (= false)_

   Build a local version of the agent binary; for development use only

   _--dry-run  (= false)_

   Don't change anything, just report what would be changed

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   _--reset-previous-upgrade  (= false)_

   Clear the previous (incomplete) upgrade status (use with care)

   _-y, --yes  (= false)_

   Answer 'yes' to confirmation prompts

   
   **Details:**


   Juju provides agent software to every machine it creates. This command
   upgrades that software across an entire model, which is, by default, the
   current model.

   A model's agent version can be shown with `juju model-config agent-
   version`.

   A version is denoted by: major.minor.patch
   The upgrade candidate will be auto-selected if '--agent-version' is not
   specified:

          - If the server major version matches the client major version, the
          version selected is minor+1. If such a minor version is not available then
          the next patch version is chosen.

          - If the server major version does not match the client major version,
          the version selected is that of the client version.

   
   If the controller is without internet access, the client must first supply
   the software to the controller's cache via the `juju sync-tools` command.
   The command will abort if an upgrade is in progress. It will also abort if
   a previous upgrade was not fully completed (e.g.: if one of the
   controllers in a high availability model failed to upgrade).

   If a failed upgrade has been resolved, '--reset-previous-upgrade' can be
   used to allow the upgrade to proceed.

   Backups are recommended prior to upgrading.


   **Examples:**


          juju upgrade-juju --dry-run
          juju upgrade-juju --agent-version 2.0.1
          


   **See also:**

   [sync-tools](#sync-tools)


 

^# upload-backup

   **Usage:** ` juju upload-backup [options] <filename>`

   **Summary:**

   Store a backup archive file remotely in Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts `[<controller name>:]<model name>`

   
   **Details:**


   upload-backup sends a backup archive file to remote storage.



 

^# users

   **Usage:** ` juju users [options]`

   **Summary:**

   Lists Juju users allowed to connect to a controller or model.

   **Options:**

   _--all  (= false)_

   Include disabled users

   _-c, --controller (= "")_

   Controller to operate in

   _--exact-time  (= false)_

   Use full timestamp for connection times

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   When used without a model name argument, users relevant to a controller are printed.
   When used with a model name, users relevant to the specified model are printed.

   **Examples:**


          Print the users relevant to the current controller: 
          juju users
          
          Print the users relevant to the controller "another":
          juju users -c another
          Print the users relevant to the model "mymodel":
          juju users mymodel


   **See also:**

   [add-user](#add-user)

   [register](#register)

   [show-user](#show-user)

   [disable-user](#disable-user)

   [enable-user](#enable-user)

   **Aliases:**

   _list-users_


 

^# version

   **Usage:** ` juju version [options]`

   **Summary:**

   print the current version

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-o, --output (= "")_

   Specify an output file


 

^# whoami

   **Usage:** ` juju whoami [options]`

   **Summary:**

   Print current login details

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Display the current controller, model and logged in user name. 

   **Examples:**


          juju whoami


   **See also:**

   [controllers](#controllers)

   [login](#login)

   [logout](#logout)

   [models](#models)

   [users](#users)
