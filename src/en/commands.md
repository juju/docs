Title:Juju commands and usage

# Juju Command reference

You can get a list of the currently used commands by entering
```juju help commands``` from the commandline. The currently understood commands
are listed here, with usage and examples.

Click on the expander to see details for each command. 

^# actions

   **Usage:** ` juju list-actions [options] <service name>`

   **Summary:**

   list actions defined for a service

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--schema  (= false)_

   display the full action schema

   
   **Details:**


   List the actions available to run on the target service, with a short
   description.  To show the full schema for the actions, use --schema.

   For more information, see also the 'run-ation' command, which executes actions.

   **Aliases:**

   _actions_


 

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

   [list-clouds](#list-clouds)


 

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

   [list-credentials](#list-credentials)

   [remove-credential](#remove-credential)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)


 

^# add-machine

   **Usage:** ` juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | placement]`

   **Summary:**

   start a new, empty machine and optionally a container, or add a container to a machine

   **Options:**

   _--constraints  (= )_

   additional machine constraints

   _--disks  (= )_

   constraints for disks to attach to the machine

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n  (= 1)_

   The number of machines to add

   _--series (= "")_

   the charm series

   
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

   If a container type is specified (e.g. "lxc"), then add machine will
   allocate a container of that type on a new provider-specific machine. It is
   also possible to add containers to existing machines using the format
   <container type>:<machine number>. Constraints cannot be combined with
   deploying a container to an existing machine. The currently supported
   container types are: lxc, lxd, kvm.

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
         juju add-machine lxc                  (starts a new machine with an lxc container)
         juju add-machine lxc -n 2             (starts 2 new machines with an lxc container)
         juju add-machine lxc:4                (starts a new lxc container on machine 4)
         juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
         juju add-machine ssh:user@10.10.0.3   (manually provisions a machine with ssh)
         juju add-machine zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
         juju add-machine maas2.name           (acquire machine maas2.name on MAAS)


   **See also:**

   [juju help constraints](#juju help constraints)

   [juju help placement](#juju help placement)

   [juju help remove-machine](#juju help remove-machine)

   **Aliases:**

   _add-machines_


 

^# add-machines

   **Usage:** ` juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | placement]`

   **Summary:**

   start a new, empty machine and optionally a container, or add a container to a machine

   **Options:**

   _--constraints  (= )_

   additional machine constraints

   _--disks  (= )_

   constraints for disks to attach to the machine

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n  (= 1)_

   The number of machines to add

   _--series (= "")_

   the charm series

   
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

   If a container type is specified (e.g. "lxc"), then add machine will
   allocate a container of that type on a new provider-specific machine. It is
   also possible to add containers to existing machines using the format
   <container type>:<machine number>. Constraints cannot be combined with
   deploying a container to an existing machine. The currently supported
   container types are: lxc, lxd, kvm.

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
         juju add-machine lxc                  (starts a new machine with an lxc container)
         juju add-machine lxc -n 2             (starts 2 new machines with an lxc container)
         juju add-machine lxc:4                (starts a new lxc container on machine 4)
         juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
         juju add-machine ssh:user@10.10.0.3   (manually provisions a machine with ssh)
         juju add-machine zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
         juju add-machine maas2.name           (acquire machine maas2.name on MAAS)


   **See also:**

   [juju help constraints](#juju help constraints)

   [juju help placement](#juju help placement)

   [juju help remove-machine](#juju help remove-machine)

   **Aliases:**

   _add-machines_


 

^# add-model

   **Usage:** ` juju add-model [options] <name> [--config key=[value] ...] [--credential <cloud>:<credential>]`

   **Summary:**

   Add a model within the Juju Model Server

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   _--config  (= )_

   Specify a controller config file, or one or more controller configuration options (--config config.yaml [--config k=v ...])

   _--credential (= "")_

   The name of the cloud and credentials the new model uses to create cloud resources

   _--owner (= "")_

   The owner of the new model if not the current user

   
   **Details:**


   This command will add another model within the current Juju
   Controller. The provider has to match, and the model config must
   specify all the required configuration values for the provider.

   If configuration values are passed by both extra command line
   arguments and the --config option, the command line args take
   priority.

   If adding a model in a controller for which you are not the
   administrator, the cloud credentials and authorized ssh keys must
   be specified. The credentials are specified using the argument
   --credential <cloud>:<credential>. The authorized ssh keys are
   specified using a --config argument, either authorized=keys=value
   or via a config yaml file.

          
   
   Any credentials used must be for a cloud with the same provider
   type as the controller. Controller administrators do not have to
   specify credentials or ssh keys; by default, the credentials and
   keys used to bootstrap the controller are used if no others are
   specified.


   **Examples:**


          juju add-model new-model
          juju add-model new-model --config aws-creds.yaml --config image-stream=daily
          
          juju add-model new-model --credential aws:mysekrets --config authorized-keys="ssh-rsa ..."


   **See also:**

   [juju help grant](#juju help grant)


 

^# add-relation

   **Usage:** ` juju add-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]`

   **Summary:**

   add a relation between two services

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>


 

^# add-space

   **Usage:** ` juju add-space [options] <name> [<CIDR1> <CIDR2> ...]`

   **Summary:**

   Add a new network space

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Adds a new space with the given name and associates the given
   (optional) list of existing subnet CIDRs with it.



 

^# add-ssh-key

   **Usage:** ` juju add-ssh-key [options] <ssh key> ...`

   **Summary:**

   Adds a public SSH key to a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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

   [list-ssh-key](#list-ssh-key)

   [remove-ssh-key](#remove-ssh-key)

   [import-ssh-key](#import-ssh-key)

   **Aliases:**

   _add-ssh-keys_


 

^# add-ssh-keys

   **Usage:** ` juju add-ssh-key [options] <ssh key> ...`

   **Summary:**

   Adds a public SSH key to a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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

   [list-ssh-key](#list-ssh-key)

   [remove-ssh-key](#remove-ssh-key)

   [import-ssh-key](#import-ssh-key)

   **Aliases:**

   _add-ssh-keys_


 

^# add-storage

   **Usage:** ` juju add-storage [options] <unit name> <storage directive> ...

   **Summary:**

   adds unit storage dynamically

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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
   Example:

             Add 3 ebs storage instances for "data" storage to unit u/0:

               juju add-storage u/0 data=ebs,1024,3 
             or
               juju add-storage u/0 data=ebs,3
             or
               juju add-storage u/0 data=ebs,,3 
             
             
             Add 1 storage instances for "data" storage to unit u/0 
             using default model provider pool:

               juju add-storage u/0 data=1 
             or
               juju add-storage u/0 data


 

^# add-subnet

   **Usage:** ` juju add-subnet [options] <CIDR>|<provider-id> <space> [<zone1> <zone2> ...]`

   **Summary:**

   add an existing subnet to Juju

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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

   **Usage:** ` juju add-unit [options] <service name>`

   **Summary:**

   Adds one or more units to a deployed service.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n, --num-units  (= 1)_

   Number of units to add

   _--to (= "")_

   The machine and/or container to deploy the unit in (bypasses constraints)

   
   **Details:**


   Adding units to an existing service is a way to scale out that service. 
   Many charms will seamlessly support horizontal scaling, others may need an
   additional service to facilitate load-balancing (check the individual 
   charm documentation).

   This command is applied to services that have already been deployed.

   By default, services are deployed to newly provisioned machines in
   accordance with any service or model constraints. Alternatively, this 
   command also supports the placement directive ("--to") for targeting
   specific machines or containers, which will bypass any existing
   constraints.


   **Examples:**

   Add five units of wordpress on five new machines:

          juju add-unit wordpress -n 5

   Add one unit of mysql to the existing machine 23:

          juju add-unit mysql --to 23

   Create a new LXC container on machine 7 and add one unit of mysql:

          juju add-unit mysql --to lxc:7

   Add a unit of mariadb to LXC container number 3 on machine 24:

          juju add-unit mariadb --to 24/lxc/3


   **See also:**

   [remove-unit](#remove-unit)

   **Aliases:**

   _add-units_


 

^# add-units

   **Usage:** ` juju add-unit [options] <service name>`

   **Summary:**

   Adds one or more units to a deployed service.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n, --num-units  (= 1)_

   Number of units to add

   _--to (= "")_

   The machine and/or container to deploy the unit in (bypasses constraints)

   
   **Details:**


   Adding units to an existing service is a way to scale out that service. 
   Many charms will seamlessly support horizontal scaling, others may need an
   additional service to facilitate load-balancing (check the individual 
   charm documentation).

   This command is applied to services that have already been deployed.

   By default, services are deployed to newly provisioned machines in
   accordance with any service or model constraints. Alternatively, this 
   command also supports the placement directive ("--to") for targeting
   specific machines or containers, which will bypass any existing
   constraints.


   **Examples:**

   Add five units of wordpress on five new machines:

          juju add-unit wordpress -n 5

   Add one unit of mysql to the existing machine 23:

          juju add-unit mysql --to 23

   Create a new LXC container on machine 7 and add one unit of mysql:

          juju add-unit mysql --to lxc:7

   Add a unit of mariadb to LXC container number 3 on machine 24:

          juju add-unit mariadb --to 24/lxc/3


   **See also:**

   [remove-unit](#remove-unit)

   **Aliases:**

   _add-units_


 

^# add-user

   **Usage:** ` juju add-user [options] <user name> [<display name>]`

   **Summary:**

   Adds a Juju user to a controller.

   **Options:**

   _--acl (= "read")_

   Access controls

   _-c, --controller (= "")_

   Controller to operate in

   _--models (= "")_

   Models the new user is granted access to

   
   **Details:**


   This allows the user to register with the controller and use the 
   optionally shared model.

   A `juju register`command will be printed, which
   must be executed by the user to complete the registration process.  The
   user's details are stored within the shared model, and will be removed
   when the model is destroyed.

   Some machine providers will require the user 
   to be in possession of certain credentials in order to create a model.

   **Examples:**


          juju add-user bob
          juju add-user --share mymodel bob
          juju add-user --controller mycontroller bob


   **See also:**

   [register](#register)

   [grant](#grant)

   [show-user](#show-user)

   [list-users](#list-users)

   [switch-user](#switch-user)

   [disable-user](#disable-user)

   [enable-user](#enable-user)

   [change-user-password](#change-user-password)


 

^# agree

   **Usage:** ` juju agree [options] <term>`

   **Summary:**

   agree to terms

   **Options:**

   _--format  (= json)_

   Specify output format (json|smart|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--yes  (= false)_

   agree to terms non interactively

   
   **Details:**


   Agree to the terms required by a charm.

   When deploying a charm that requires agreement to terms, use 'juju agree' to
   view the terms and agree to them. Then the charm may be deployed.

   Once you have agreed to terms, you will not be prompted to view them again.

   **Examples:**


       juju agree somePlan/1
           Displays terms for somePlan revision 1 and prompts for agreement.
       juju agree somePlan/1 otherPlan/2
           Displays the terms for revision 1 of somePlan, revision 2 of otherPlan,
           and prompts for agreement.
       juju agree somePlan/1 otherPlan/2 --yes
           Agrees to the terms without prompting.



 

^# allocate

   **Usage:** ` juju allocate [options]`

   **Summary:**

   allocate budget to services

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Allocate budget for the specified services, replacing any prior allocations
   made for the specified services.

   Usage:

          juju allocate <budget>:<value> <service> [<service2> ...]
   
   Example:

          juju allocate somebudget:42 db
              Assigns service "db" to an allocation on budget "somebudget" with the limit "42".


 

^# attach

   **Usage:** ` juju attach [options] service name=file`

   **Summary:**

   upload a file as a resource for a service

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   This command uploads a file from your local disk to the juju controller to be
   used as a resource for a service.



 

^# autoload-credentials

   **Usage:** ` juju autoload-credentials`

   **Summary:**

   looks for cloud credentials and caches those for use by Juju when bootstrapping


   
   **Details:**


   The autoload-credentials command looks for well known locations for supported clouds and
   allows the user to interactively save these into the Juju credentials store to make these
   available when bootstrapping new controllers and creating new models.

   The resulting credentials may be viewed with juju list-credentials.

   The clouds for which credentials may be autoloaded are:

   AWS
           Credentials and regions are located in:

             1. On Linux, $HOME/.aws/credentials and $HOME/.aws/config 
             2. Environment variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
             
   
   GCE
           Credentials are located in:

             1. A JSON file whose path is specified by the GOOGLE_APPLICATION_CREDENTIALS environment variable
             2. A JSON file in a knowm location eg on Linux $HOME/.config/gcloud/application_default_credentials.json
           Default region is specified by the CLOUDSDK_COMPUTE_REGION environment variable.  
             
   
   OpenStack
           Credentials are located in:

             1. On Linux, $HOME/.novarc
             2. Environment variables OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME 
             
   
   Example:

            juju autoload-credentials
            

   **See also:**

   [juju list-credentials](#juju list-credentials)

   [juju add-credential](#juju add-credential)


 

^# backups

   **Usage:** ` juju list-backups [options]`

   **Summary:**

   get all metadata

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   list-backups provides the metadata associated with all backups.


   **Aliases:**

   _backups_


 

^# block

   **Usage:** ` juju block [options] <command> ...`

   **Summary:**

   list and enable model blocks

   **Options:**

   _--description  (= false)_

   

   _-h, --help  (= false)_

   show help on a command or other topic

   
   **Details:**


   Juju allows to safeguard deployed models from unintentional damage by preventing
   execution of operations that could alter model.

   This is done by blocking certain commands from successful execution. Blocked commands
   must be manually unblocked to proceed.

   "juju block" is used to list or to enable model blocks in
          the Juju model.

   
   commands:

             all-changes   - block operations that could change Juju model
             destroy-model - block an operation that would destroy Juju model
             help          - show help on a command or other topic
             list          - list juju blocks
             remove-object - block an operation that would remove an object


 

^# bootstrap

   **Usage:** ` juju bootstrap [options] <controller name> <cloud name>[/region]`

   **Summary:**

   Initializes a cloud environment.

   **Options:**

   _--agent-version (= "")_

   Version of tools to use for Juju agents

   _--auto-upgrade  (= false)_

   Upgrade to the latest patch release tools on first bootstrap

   _--bootstrap-constraints  (= )_

   Specify bootstrap machine constraints

   _--bootstrap-series (= "")_

   Specify the series of the bootstrap machine

   _--config  (= )_

   Specify a controller configuration file, or one or more configuration

   options

   (--config config.yaml [--config key=value ...])

   _--constraints  (= )_

   Set model constraints

   _--credential (= "")_

   Credentials to use when bootstrapping

   _-d, --default-model (= "default")_

   Name of the default hosted model for the controller

   _--keep-broken  (= false)_

   Do not destroy the model if bootstrap fails

   _--metadata-source (= "")_

   Local path to use as tools and/or metadata source

   _--no-gui  (= false)_

   Do not install the Juju GUI in the controller when bootstrapping

   _--to (= "")_

   Placement directive indicating an instance to bootstrap

   _--upload-tools  (= false)_

   Upload local version of tools before bootstrapping

   
   **Details:**


   Initialization consists of creating an 'admin' model and provisioning a 
   machine to act as controller.

   Credentials are set beforehand and are distinct from any other 
   configuration (see `juju add-credential`).

   The 'admin' model typically does not run workloads. It should remain
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
   bootstrap by changing the following settings in your configuration file
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


          juju bootstrap mycontroller google
          juju bootstrap --config=~/config-rs.yaml mycontroller rackspace
          juju bootstrap --config agent-version=1.25.3 mycontroller aws
          juju bootstrap --config bootstrap-timeout=1200 mycontroller azure


   **See also:**

   [add-credentials](#add-credentials)

   [add-model](#add-model)

   [set-constraints](#set-constraints)


 

^# cached-images

   **Usage:** ` juju list-cached-images [options]`

   **Summary:**

   shows cached os images

   **Options:**

   _--arch (= "")_

   the architecture of the image to list eg amd64

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _--kind (= "")_

   the image kind to list eg lxd

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--series (= "")_

   the series of the image to list eg xenial

   
   **Details:**


   List cached os images in the Juju model.

   Images can be filtered on:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"
   
   The filter attributes are optional.


   **Examples:**


        # List all cached images.
        juju list-cache-images
        # List cached images for xenial.
        juju list-cache-images --series xenial 
        # List all cached lxd images for xenial amd64.
        juju list-cache-images --kind lxd --series xenial --arch amd64


   **Aliases:**

   _cached-images_


 

^# change-user-password

   **Usage:** ` juju change-user-password [options] [username]`

   **Summary:**

   changes the password for a user

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Change the password for the user you are currently logged in as;
   or as an admin, change the password for another user.


   **Examples:**


        # Change the password for the user you are logged in as.
        juju change-user-password
        # Change the password for bob.
        juju change-user-password bob



 

^# charm

   **Usage:** ` juju charm [options] <command> ...`

   **Summary:**

   interact with charms

   **Options:**

   _--description  (= false)_

   

   _-h, --help  (= false)_

   show help on a command or other topic

   
   **Details:**


   "juju charm" is the the juju CLI equivalent of the "charm" command used
   by charm authors, though only applicable functionality is mirrored.

   commands:

             help           - show help on a command or other topic
             list-resources - display the resources for a charm in the charm store
             resources      - alias for 'list-resources'


 

^# collect-metrics

   **Usage:** ` juju collect-metrics [options] [service or unit]`

   **Summary:**

   collect metrics on the given unit/service

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   collect-metrics
   trigger metrics collection
   Collect metrics infinitely waits for the command to finish.

   However if you cancel the command while waiting, you can still
   look for the results under 'juju action status'.



 

^# create-backup

   **Usage:** ` juju create-backup [options] [<notes>]`

   **Summary:**

   create a backup

   **Options:**

   _--filename (= "juju-backup-<date>-<time>.tar.gz")_

   download to this file

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--no-download  (= false)_

   do not download the archive

   
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

   **Usage:** ` juju create-budget`

   **Summary:**

   create a new budget


   
   **Details:**


   Create a new budget with monthly limit.

   Example:

          juju create-budget qa 42
              Creates a budget named 'qa' with a limit of 42.



 

^# create-storage-pool

   **Usage:** ` juju create-storage-pool [options] <name> <provider> [<key>=<value> [<key>=<value>...]]`

   **Summary:**

   create storage pool

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Create or define a storage pool.

   Pools are a mechanism for administrators to define sources of storage that
   they will use to satisfy service storage requirements.

   A single pool might be used for storage from units of many different services -
   it is a resource from which different stores may be drawn.

   A pool describes provider-specific parameters for creating storage,
   such as performance (e.g. IOPS), media type (e.g. magnetic vs. SSD),
   or durability.

   For many providers, there will be a shared resource
   where storage can be requested (e.g. EBS in amazon).

   Creating pools there maps provider specific settings
   into named resources that can be used during deployment.

   Pools defined at the model level are easily reused across services.

   options:

             -m, --model (= "")
                 juju model to operate in
             -o, --output (= "")
                 specify an output file
             <name>
                 pool name
             <provider type>
                 pool provider type
             <key>=<value> (<key>=<value> ...)
                 pool configuration attributes as space-separated pairs, 
                 for e.g. tags, size, path, etc...



 

^# debug-hooks

   **Usage:** ` juju debug-hooks [options] <unit name> [hook names]`

   **Summary:**

   launch a tmux session to debug a hook

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= true)_

   Enable pseudo-tty allocation

   
   **Details:**


   Interactively debug a hook remotely on a service unit.



 

^# debug-log

   **Usage:** ` juju debug-log [options]`

   **Summary:**

   Displays log messages for a model.

   **Options:**

   _-T, --no-tail  (= false)_

   Stop after returning existing log messages

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

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n, --lines  (= 10)_

   Show this many of the most recent (possibly filtered) lines, and continue to append

   _--replay  (= false)_

   Show the entire (possibly filtered) log and continue to append

   _-x, --exclude  (= )_

   Do not show log messages for these entities

   
   **Details:**


   This command accesses all logged Juju activity on a per-model basis. By
   default, the model is the current model.

   A log line is written in this format:

   <entity> <timestamp> <log-level> <module>:<line-no> <message>
   The "entity" is the source of the message: a machine or unit. Both are
   obtained in the output to `juju status`.

   The '--include' and '--exclude' options filter by entity. A unit entity is
   identified by prefixing 'unit-' to its corresponding unit name and
   replacing the slash with a dash. A machine entity is identified by
   prefixing 'machine-' to its corresponding machine id.

   The '--include-module' and '--exclude-module' options filter by (dotted)
   logging module name, which can be truncated.

   A combination of machine and unit filtering uses a logical OR whereas a
   combination of module and machine/unit filtering uses a logical AND.

   Log levels are cumulative; each lower level (more verbose) contains the
   preceding higher level (less verbose).


   **Examples:**

   Exclude all machine 0 messages; show a maximum of 100 lines; and continue
   to append filtered messages:

          juju debug-log --exclude machine-0 --lines 100

   Include only unit mysql/0 messages; show a maximum of 50 lines; and then
   exit:

          juju debug-log -T --include unit-mysql-0 --lines 50

   Show all messages from unit apache2/3 or machine 1 and then exit:

          juju debug-log -T --replay --include unit-apache2-3 --include machine-1

   Include all juju.worker.uniter logging module messages that are also unit
   wordpress/0 messages and continue to append filtered messages:

          juju debug-log --replay --include-module juju.worker.uniter --include \
              unit-wordpress-0

   To see all WARNING and ERROR messages:

          juju debug-log --replay --level WARNING


   **See also:**

   [status](#status)


 

^# debug-metrics

   **Usage:** ` juju debug-metrics [options] [service or unit]`

   **Summary:**

   retrieve metrics collected by the given unit/service

   **Options:**

   _--json  (= false)_

   output metrics as json

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n  (= 0)_

   number of metrics to retrieve

   
   **Details:**


   debug-metrics
   display recently collected metrics and exit


 

^# deploy

   **Usage:** ` juju deploy [options] <charm or bundle> [<service name>]`

   **Summary:**

   deploy a new service or bundle

   **Options:**

   _--bind (= "")_

   Configure service endpoint bindings to spaces

   _--budget (= "personal:0")_

   budget and allocation limit

   _--channel (= "")_

   channel to use when getting the charm or bundle from the charm store

   _--config  (= )_

   path to yaml-formatted service config

   _--constraints  (= )_

   set service constraints

   _--force  (= false)_

   allow a charm to be deployed to a machine running an unsupported series

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n, --num-units  (= 1)_

   number of service units to deploy for principal charms

   _--plan (= "")_

   plan to deploy charm under

   _--resource  (= )_

   resource to be uploaded to the controller

   _--series (= "")_

   the series on which to deploy

   _--storage  (= )_

   charm storage constraints

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
           cs:~user/mysql
   
   For cs:bundle/mediawiki-single
           mediawiki-single
           bundle/mediawiki-single
   
   The current series for charms is determined first by the default-series model
   setting, followed by the preferred series for the charm in the charm store.
   In these cases, a versioned charm URL will be expanded as expected (for example,
   mysql-33 becomes cs:precise/mysql-33).

   Charms may also be deployed from a user specified path. In this case, the
   path to the charm is specified along with an optional series.

            juju deploy /path/to/charm --series trusty
   
   If series is not specified, the charm's default series is used. The default series
   for a charm is the first one specified in the charm metadata. If the specified series
   is not supported by the charm, this results in an error, unless --force is used.
            juju deploy /path/to/charm --series wily --force
   
   Local bundles are specified with a direct path to a bundle.yaml file.
   For example:

           juju deploy /path/to/bundle/openstack/bundle.yaml
   
   <service name>, if omitted, will be derived from <charm name>.

   Constraints can be specified when using deploy by specifying the --constraints
   flag.  When used with deploy, service-specific constraints are set so that later
   machines provisioned with add-unit will use the same constraints (unless changed
   by set-constraints).

   Resources may be uploaded at deploy time by specifying the --resource flag.
   Following the resource flag should be name=filepath pair.  This flag may be
   repeated more than once to upload more than one resource.

           juju deploy foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml
   
   Where bar and baz are resources named in the metadata for the foo charm.
   Charms can be deployed to a specific machine using the --to argument.

   If the destination is an LXC container the default is to use lxc-clone
   to create the container where possible. For Ubuntu deployments, lxc-clone
   is supported for the trusty OS series and later. A 'template' container is
   created with the name
           juju-<series>-template
   
   where <series> is the OS series, for example 'juju-trusty-template'.
   You can override the use of clone by changing the provider configuration:
           lxc-clone: false
   
   In more complex scenarios, Juju's network spaces are used to partition the cloud
   networking layer into sets of subnets. Instances hosting units inside the
   same space can communicate with each other without any firewalls. Traffic
   crossing space boundaries could be subject to firewall and access restrictions.
   Using spaces as deployment targets, rather than their individual subnets allows
   Juju to perform automatic distribution of units across availability zones to
   support high availability for services. Spaces help isolate services and their
   units, both for security purposes and to manage both traffic segregation and
   congestion.

   When deploying a service or adding machines, the "spaces" constraint can be
   used to define a comma-delimited list of required and forbidden spaces
   (the latter prefixed with "^", similar to the "tags" constraint).

   If you have the main container directory mounted on a btrfs partition,
   then the clone will be using btrfs snapshots to create the containers.
   This means that clones use up much less disk space.  If you do not have btrfs,
   lxc will attempt to use aufs (an overlay type filesystem). You can
   explicitly ask Juju to create full containers and not overlays by specifying
   the following in the provider configuration:

           lxc-clone-aufs: false

   **Examples:**


         juju deploy mysql --to 23       (deploy to machine 23)
         juju deploy mysql --to 24/lxc/3 (deploy to lxc container 3 on host machine 24)
         juju deploy mysql --to lxc:25   (deploy to a new lxc container on host machine 25)
         juju deploy mysql -n 5 --constraints mem=8G
         (deploy 5 instances of mysql with at least 8 GB of RAM each)
         juju deploy haproxy -n 2 --constraints spaces=dmz,^cms,^database
         (deploy 2 instances of haproxy on cloud instances being part of the dmz
          space but not of the cmd and the database space)


   **See also:**

   [juju help spaces](#juju help spaces)

   [juju help constraints](#juju help constraints)

   [juju help set-constraints](#juju help set-constraints)

   [juju help get-constraints](#juju help get-constraints)


 

^# destroy-controller

   **Usage:** ` juju destroy-controller [options] <controller name>`

   **Summary:**

   Destroys a controller.

   **Options:**

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


 

^# destroy-model

   **Usage:** ` juju destroy-model [options] [<controller name>:]<model name>`

   **Summary:**

   Terminate all machines and resources for a non-controller model.

   **Options:**

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

   [estroy-controller](#estroy-controller)


 

^# destroy-relation

   **Usage:** ` juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]`

   **Summary:**

   Removes an existing relation between two services.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   An existing relation between the two specified services will be removed. 
   This should not result in either of the services entering an error state,
   but may result in either or both of the services being unable to continue
   normal operation. In the case that there is more than one relation between
   two services it is necessary to specify which is to be removed (see
   examples). Relations will automatically be removed when using the`juju
   remove-service` command.


   **Examples:**


          juju remove-relation mysql wordpress

   In the case of multiple relations, the relation name should be specified
   at least once - the following examples will all have the same effect:

          juju remove-relation mediawiki:db mariadb:db
          juju remove-relation mediawiki mariadb:db
          juju remove-relation mediawiki:db mariadb
       


   **See also:**

   [add-relation](#add-relation)

   [remove-service](#remove-service)

   **Aliases:**

   _destroy-relation_


 

^# destroy-service

   **Usage:** ` juju remove-service [options] <service>`

   **Summary:**

   Remove a service from the model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Removing a service will terminate any relations that service has, remove
   all units of the service, and in the case that this leaves machines with
   no running services, Juju will also remove the machine. For this reason,
   you should retrieve any logs or data required from services and units 
   before removing them. Removing units which are co-located with units of
   other charms or a Juju controller will not result in the removal of the
   machine.


   **Examples:**


          juju remove-service hadoop
          juju remove-service -m test-model mariadb


   **Aliases:**

   _destroy-service_


 

^# destroy-unit

   **Usage:** ` juju remove-unit [options] <unit> [...]`

   **Summary:**

   remove service units from the model

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Remove service units from the model.

   If this is the only unit running, the machine on which
   the unit is hosted will also be destroyed, if possible.

   The machine will be destroyed if:

   - it is not a controller
   - it is not hosting any Juju managed containers

   **Aliases:**

   _destroy-unit_


 

^# disable-user

   **Usage:** ` juju disable-user [options] <user name>`

   **Summary:**

   Disables a Juju user.

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   A disabled Juju user is one that cannot log in to any controller.

   This command has no affect on models that the disabled user may have
   created and/or shared nor any services associated with that user.


   **Examples:**


          juju disable-user bob


   **See also:**

   [enable-user](#enable-user)

   [list-users](#list-users)

   [login](#login)


 

^# download-backup

   **Usage:** ` juju download-backup [options] <ID>`

   **Summary:**

   get an archive file

   **Options:**

   _--filename (= "")_

   download target

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   download-backup retrieves a backup archive file.

   If --filename is not used, the archive is downloaded to a temporary
   location and the filename is printed to stdout.



 

^# enable-ha

   **Usage:** ` juju enable-ha [options]`

   **Summary:**

   ensure that sufficient controllers exist to provide redundancy

   **Options:**

   _--constraints  (= )_

   additional machine constraints

   _--format  (= simple)_

   Specify output format (json|simple|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n  (= 0)_

   number of controllers to make available

   _-o, --output (= "")_

   Specify an output file

   _--series (= "")_

   the charm series

   _--to (= "")_

   the machine(s) to become controllers, bypasses constraints

   
   **Details:**


   To ensure availability of deployed services, the Juju infrastructure
   must itself be highly available.  enable-ha must be called
   to ensure that the specified number of controllers are made available.
   An odd number of controllers is required.


   **Examples:**


       juju enable-ha
           Ensure that the controller is still in highly available mode. If
           there is only 1 controller running, this will ensure there
           are 3 running. If you have previously requested more than 3,
           then that number will be ensured.
       juju enable-ha -n 5 --series=trusty
           Ensure that 5 controllers are available, with newly created
           controller machines having the "trusty" series.
       juju enable-ha -n 7 --constraints mem=8G
           Ensure that 7 controllers are available, with newly created
           controller machines having the default series, and at least
           8GB RAM.
       juju enable-ha -n 7 --to server1,server2 --constraints mem=8G
           Ensure that 7 controllers are available, with machines server1 and
           server2 used first, and if necessary, newly created controller
           machines having the default series, and at least 8GB RAM.



 

^# enable-user

   **Usage:** ` juju enable-user [options] <user name>`

   **Summary:**

   Re-enables a previously disabled Juju user.

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   An enabled Juju user is one that can log in to a controller.


   **Examples:**


          juju enable-user bob


   **See also:**

   [disable-user](#disable-user)

   [list-users](#list-users)

   [login](#login)


 

^# expose

   **Usage:** ` juju expose [options] <service name>`

   **Summary:**

   Makes a service publicly available over the network.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Adjusts the firewall rules and any relevant security mechanisms of the
   cloud to allow public access to the service.


   **Examples:**


          juju expose wordpress


   **See also:**

   [unexpose](#unexpose)


 

^# get-config

   **Usage:** ` juju get-config [options] <service name>`

   **Summary:**

   Displays configuration settings for a deployed service.

   **Options:**

   _--format  (= yaml)_

   Specify output format (yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Output includes the name of the charm used to deploy the service and a
   listing of the service-specific configuration settings.

   See `juju status` for service names.


   **Examples:**


          juju get-config mysql
          juju get-config mysql-testing


   **See also:**

   [set-config](#set-config)

   [deploy](#deploy)

   [status](#status)

   **Aliases:**

   _get-configs_


 

^# get-configs

   **Usage:** ` juju get-config [options] <service name>`

   **Summary:**

   Displays configuration settings for a deployed service.

   **Options:**

   _--format  (= yaml)_

   Specify output format (yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Output includes the name of the charm used to deploy the service and a
   listing of the service-specific configuration settings.

   See `juju status` for service names.


   **Examples:**


          juju get-config mysql
          juju get-config mysql-testing


   **See also:**

   [set-config](#set-config)

   [deploy](#deploy)

   [status](#status)

   **Aliases:**

   _get-configs_


 

^# get-constraints

   **Usage:** ` juju get-constraints [options] <service>`

   **Summary:**

   Displays machine constraints for a service.

   **Options:**

   _--format  (= constraints)_

   Specify output format (constraints|json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Shows machine constraints that have been set for a service with `juju set-
   constraints`.

   By default, the model is the current model.

   Service constraints are combined with model constraints, set with `juju 
   set-model-constraints`, for commands (such as 'deploy') that provision
   machines for services. Where model and service constraints overlap, the
   service constraints take precedence.

   Constraints for a specific model can be viewed with `juju get-model-
   constraints`.


   **Examples:**


          juju get-constraints mysql
          juju get-constraints -m mymodel apache2


   **See also:**

   [set-constraints](#set-constraints)

   [get-model-constraints](#get-model-constraints)

   [set-model-constraints](#set-model-constraints)


 

^# get-model-config

   **Usage:** ` juju get-model-config [options] [<model key>]`

   **Summary:**

   Displays configuration settings for a model.

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   By default, all configuration (keys and values) for the model are
   displayed if a key is not specified.

   By default, the model is the current model.


   **Examples:**


          juju get-model-config default-series
          juju get-model-config -m mymodel type


   **See also:**

   [ist-models](#ist-models)

   [set-model-config](#set-model-config)

   [unset-model-config](#unset-model-config)


 

^# get-model-constraints

   **Usage:** ` juju get-model-constraints [options]`

   **Summary:**

   Displays machine constraints for a model.

   **Options:**

   _--format  (= constraints)_

   Specify output format (constraints|json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Shows machine constraints that have been set on the model with
   `juju set-model-constraints.`
   By default, the model is the current model.

   Model constraints are combined with constraints set on a service
   with `juju set-constraints` for commands (such as 'deploy') that provision
   machines for services. Where model and service constraints overlap, the
   service constraints take precedence.

   Constraints for a specific service can be viewed with `juju get-constraints`.

   **Examples:**


          juju get-model-constraints
          juju get-model-constraints -m mymodel


   **See also:**

   [ist-models](#ist-models)

   [set-model-constraints](#set-model-constraints)

   [set-constraints](#set-constraints)

   [get-constraints](#get-constraints)


 

^# grant

   **Usage:** ` juju grant [options] <user name> <model name> ...`

   **Summary:**

   Grants access to a Juju user for a model.

   **Options:**

   _--acl (= "read")_

   Access control ('read' or 'write')

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   By default, the controller is the current controller.

   Model access can also be granted at user-addition time with the `juju add-
   user` command.

   Users with read access are limited in what they can do with models: `juju 
   list-models`, `juju list-machines`, and `juju status`.


   **Examples:**

   Grant user 'joe' default (read) access to model 'mymodel':

          juju grant joe mymodel

   Grant user 'jim' write access to model 'mymodel':

          juju grant --acl=write jim mymodel

   Grant user 'sam' default (read) access to models 'model1' and 'model2':

          juju grant sam model1 model2


   **See also:**

   [revoke](#revoke)

   [add-user](#add-user)


 

^# gui

   **Usage:** ` juju gui [options]`

   **Summary:**

   open the Juju GUI in the default browser

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--no-browser  (= false)_

   do not try to open the web browser, just print the Juju GUI URL

   _--show-credentials  (= false)_

   show admin credentials to use for logging into the Juju GUI

   
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

Details:

   **See also:**

   [opics](#opics)


 

^# help-tool

   **Usage:** ` juju help-tool [tool]`

   **Summary:**

   show help on a juju charm tool


 

^# import-ssh-key

   **Usage:** ` juju import-ssh-key [options] <lp|gh>:<user identity> ...`

   **Summary:**

   Adds a public SSH key from a trusted identity source to a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju can add SSH keys to its cache from reliable public sources (currently
   Launchpad and GitHub), allowing those users SSH access to Juju machines.
   The user identity supplied is the username on the respective service given
   by 'lp:' or 'gh:'.

   If the user has multiple keys on the service, all the keys will be added.
   Once the keys are imported, they can be viewed with the `juju list-ssh-
   keys` command, where comments will indicate which ones were imported in
   this way.

   An alternative to this command is the more manual `juju add-ssh-key`.


   **Examples:**

   Import all public keys associated with user account 'phamilton' on the
   GitHub service:

          juju import-ssh-key gh:phamilton

   Multiple identities may be specified in a space delimited list:

          juju import-ssh-key rheinlein lp:iasmiov gh:hharrison


   **See also:**

   [add-ssh-key](#add-ssh-key)

   [list-ssh-keys](#list-ssh-keys)

   **Aliases:**

   _import-ssh-keys_


 

^# import-ssh-keys

   **Usage:** ` juju import-ssh-key [options] <lp|gh>:<user identity> ...`

   **Summary:**

   Adds a public SSH key from a trusted identity source to a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju can add SSH keys to its cache from reliable public sources (currently
   Launchpad and GitHub), allowing those users SSH access to Juju machines.
   The user identity supplied is the username on the respective service given
   by 'lp:' or 'gh:'.

   If the user has multiple keys on the service, all the keys will be added.
   Once the keys are imported, they can be viewed with the `juju list-ssh-
   keys` command, where comments will indicate which ones were imported in
   this way.

   An alternative to this command is the more manual `juju add-ssh-key`.


   **Examples:**

   Import all public keys associated with user account 'phamilton' on the
   GitHub service:

          juju import-ssh-key gh:phamilton

   Multiple identities may be specified in a space delimited list:

          juju import-ssh-key rheinlein lp:iasmiov gh:hharrison


   **See also:**

   [add-ssh-key](#add-ssh-key)

   [list-ssh-keys](#list-ssh-keys)

   **Aliases:**

   _import-ssh-keys_


 

^# kill-controller

   **Usage:** ` juju kill-controller [options] <controller name>`

   **Summary:**

   forcibly terminate all machines and other associated resources for a juju controller

   **Options:**

   _-y, --yes  (= false)_

   do not ask for confirmation

   
   **Details:**


   Forcibly destroy the specified controller.  If the API server is accessible,
   this command will attempt to destroy the controller model and all
   hosted models and their resources.

   If the API server is unreachable, the machines of the controller model
   will be destroyed through the cloud provisioner.  If there are additional
   machines, including machines within hosted models, these machines will
   not be destroyed and will never be reconnected to the Juju controller being
   destroyed.



 

^# list-actions

   **Usage:** ` juju list-actions [options] <service name>`

   **Summary:**

   list actions defined for a service

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--schema  (= false)_

   display the full action schema

   
   **Details:**


   List the actions available to run on the target service, with a short
   description.  To show the full schema for the actions, use --schema.

   For more information, see also the 'run-ation' command, which executes actions.

   **Aliases:**

   _actions_


 

^# list-agreements

   **Usage:** ` juju list-agreements [options]`

   **Summary:**

   list user's agreements

   **Options:**

   _--format  (= json)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   list-agreements is used to list terms the user has agreed to.



 

^# list-all-blocks

   **Usage:** ` juju list-all-blocks [options]`

   **Summary:**

   list all blocks within the controller

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List all blocks for models within the specified controller


 

^# list-backups

   **Usage:** ` juju list-backups [options]`

   **Summary:**

   get all metadata

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   list-backups provides the metadata associated with all backups.


   **Aliases:**

   _backups_


 

^# list-budgets

   **Usage:** ` juju list-budgets [options]`

   **Summary:**

   list budgets

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List the available budgets.

   Example:

          juju list-budgets


 

^# list-cached-images

   **Usage:** ` juju list-cached-images [options]`

   **Summary:**

   shows cached os images

   **Options:**

   _--arch (= "")_

   the architecture of the image to list eg amd64

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _--kind (= "")_

   the image kind to list eg lxd

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--series (= "")_

   the series of the image to list eg xenial

   
   **Details:**


   List cached os images in the Juju model.

   Images can be filtered on:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"
   
   The filter attributes are optional.


   **Examples:**


        # List all cached images.
        juju list-cache-images
        # List cached images for xenial.
        juju list-cache-images --series xenial 
        # List all cached lxd images for xenial amd64.
        juju list-cache-images --kind lxd --series xenial --arch amd64


   **Aliases:**

   _cached-images_


 

^# list-clouds

   **Usage:** ` juju list-clouds [options]`

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


          juju list-clouds


   **See also:**

   [how-cloud](#how-cloud)

   [update-clouds](#update-clouds)

   [add-cloud](#add-cloud)


 

^# list-controllers

   **Usage:** ` juju list-controllers [options]`

   **Summary:**

   Lists all controllers.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   The output format may be selected with the '--format' option. In the
   default tabular output, the current controller is marked with an asterisk.

   **Examples:**


          juju list-controllers
          juju list-controllers --format json --output ~/tmp/controllers.json


   **See also:**

   [list-models](#list-models)

   [show-controller](#show-controller)


 

^# list-credentials

   **Usage:** ` juju list-credentials [options] [<cloud name>]`

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


          juju list-credentials
          juju list-credentials aws
          juju list-credentials --format yaml --show-secrets


   **See also:**

   [add-credential](#add-credential)

   [remove-credential](#remove-credential)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)


 

^# list-machine

   **Usage:** ` juju list-machines [options]`

   **Summary:**

   Lists machines in a model.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default, the tabular format is used.

   The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


           juju list-machines


   **See also:**

   [status](#status)

   **Aliases:**

   _machines,_

   _machine,_

   _list-machine_


 

^# list-machines

   **Usage:** ` juju list-machines [options]`

   **Summary:**

   Lists machines in a model.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default, the tabular format is used.

   The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


           juju list-machines


   **See also:**

   [status](#status)

   **Aliases:**

   _machines,_

   _machine,_

   _list-machine_


 

^# list-models

   **Usage:** ` juju list-models [options]`

   **Summary:**

   Lists models a user can access on a controller.

   **Options:**

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


          juju list-models
          juju list-models --user bob


   **See also:**

   [dd-model](#dd-model)

   [share-model](#share-model)

   [unshare-model](#unshare-model)


 

^# list-payloads

   **Usage:** ` juju list-payloads [options] [pattern ...]`

   **Summary:**

   display status information about known payloads

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

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


 

^# list-plans

   **Usage:** ` juju list-plans [options]`

   **Summary:**

   list plans

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|smart|summary|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List plans available for the specified charm.

   Example:

          juju list-plans cs:webapp


 

^# list-resources

   **Usage:** ` juju list-resources [options] service-or-unit`

   **Summary:**

   show the resources for a service or unit

   **Options:**

   _--details  (= false)_

   show detailed information about resources used by each unit.

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command shows the resources required by and those in use by an existing
   service or unit in your model.  When run for a service, it will also show any
   updates available for resources from the charmstore.


   **Aliases:**

   _resources_


 

^# list-shares

   **Usage:** ` juju list-shares [options]`

   **Summary:**

   Shows all users with access to a model for the current controller.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   By default, the model is the current model.


   **Examples:**


          juju list-shares
          juju list-shares -m mymodel


   **See also:**

   [grant](#grant)


 

^# list-spaces

   **Usage:** ` juju list-spaces [options] [--short] [--format yaml|json] [--output <path>]`

   **Summary:**

   List known spaces, including associated subnets

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

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

   _spaces_


 

^# list-ssh-key

   **Usage:** ` juju list-ssh-keys [options]`

   **Summary:**

   Lists the currently known SSH keys for the current (or specified) model.

   **Options:**

   _--full  (= false)_

   Show full key instead of just the fingerprint

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju maintains a per-model cache of SSH keys which it copies to each newly
   created unit.

   This command will display a list of all the keys currently used by Juju in
   the current model (or the model specified, if the '-m' option is used).
   By default a minimal list is returned, showing only the fingerprint of
   each key and its text identifier. By using the '--full' option, the entire
   key may be displayed.


   **Examples:**


          juju list-ssh-keys

   To examine the full key, use the '--full' option:

          juju list-keys -m jujutest --full


   **Aliases:**

   _ssh-key,_

   _ssh-keys,_

   _list-ssh-key_


 

^# list-ssh-keys

   **Usage:** ` juju list-ssh-keys [options]`

   **Summary:**

   Lists the currently known SSH keys for the current (or specified) model.

   **Options:**

   _--full  (= false)_

   Show full key instead of just the fingerprint

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju maintains a per-model cache of SSH keys which it copies to each newly
   created unit.

   This command will display a list of all the keys currently used by Juju in
   the current model (or the model specified, if the '-m' option is used).
   By default a minimal list is returned, showing only the fingerprint of
   each key and its text identifier. By using the '--full' option, the entire
   key may be displayed.


   **Examples:**


          juju list-ssh-keys

   To examine the full key, use the '--full' option:

          juju list-keys -m jujutest --full


   **Aliases:**

   _ssh-key,_

   _ssh-keys,_

   _list-ssh-key_


 

^# list-storage

   **Usage:** ` juju list-storage [options] <machineID> ...`

   **Summary:**

   lists storage details

   **Options:**

   _--filesystem  (= false)_

   list filesystem storage

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--volume  (= false)_

   list volume storage

   
   **Details:**


   List information about storage instances.

   options:

   -m, --model (= "")
            juju model to operate in
   
   -o, --output (= "")
            specify an output file
   
   --format (= tabular)
            specify output format (json|tabular|yaml)

   **Aliases:**

   _storage_


 

^# list-storage-pools

   **Usage:** ` juju list-storage-pools [options]`

   **Summary:**

   list storage pools

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--name  (= )_

   only show pools with these names

   _-o, --output (= "")_

   Specify an output file

   _--provider  (= )_

   only show pools of these provider types

   
   **Details:**


   Lists storage pools.

   The user can filter on pool type, name.

   If no filter is specified, all current pools are listed.

   If at least 1 name and type is specified, only pools that match both a name
   AND a type from criteria are listed.

   If only names are specified, only mentioned pools will be listed.

   If only types are specified, all pools of the specified types will be listed.
   Both pool types and names must be valid.

   Valid pool types are pool types that are registered for Juju model.

   options:

   -m, --model (= "")
            juju model to operate in
   
   -o, --output (= "")
            specify an output file
   
   --format (= yaml)
            specify output format (json|tabular|yaml)
   
   --provider
            pool provider type
   
   --name
            pool name


 

^# list-subnets

   **Usage:** ` juju list-subnets [options] [--space <name>] [--zone <name>] [--format yaml|json] [--output <path>]`

   **Summary:**

   list subnets known to Juju

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--space (= "")_

   filter results by space name

   _--zone (= "")_

   filter results by zone name

   
   **Details:**


   Displays a list of all subnets known to Juju. Results can be filtered
   using the optional --space and/or --zone arguments to only display
   subnets associated with a given network space and/or availability zone.
   Like with other Juju commands, the output and its format can be changed
   using the --format and --output (or -o) optional arguments. Supported
   output formats include "yaml" (default) and "json". To redirect the
   output to a file, use --output.


   **Aliases:**

   _subnets_


 

^# list-users

   **Usage:** ` juju list-users [options]`

   **Summary:**

   Lists Juju users allowed to connect to a controller.

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


   By default, the tabular format is used.


   **Examples:**


          juju list-users


   **See also:**

   [add-user](#add-user)

   [register](#register)

   [show-user](#show-user)

   [disable-user](#disable-user)

   [enable-user](#enable-user)


 

^# login

   **Usage:** ` juju login [options] [username]`

   **Summary:**

   logs in to the controller

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Log in to the controller.

   After logging in successfully, the client system will
   be updated such that any previously recorded password
   will be removed from disk, and a temporary, time-limited
   credential written in its place. Once the credential
   expires, you will be prompted to run "juju login" again.


   **Examples:**


        # Log in as the current user for the controller.
        juju login
        # Log in as the user "bob".
        juju login bob



 

^# logout

   **Usage:** ` juju logout [options]`

   **Summary:**

   logs out of the controller

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   _--force  (= false)_

   force logout when a locally recorded password is detected

   
   **Details:**


   Log out of the controller.

   This command will remove the user credentials for the current
   or specified controller from the client system. This command
   will fail if you have not previously logged in with a password;
   you can override this behavior by passing --force.

   If another client has logged in as the same user, they will
   remain logged in. This command only affects the local client.



 

^# machine

   **Usage:** ` juju list-machines [options]`

   **Summary:**

   Lists machines in a model.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default, the tabular format is used.

   The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


           juju list-machines


   **See also:**

   [status](#status)

   **Aliases:**

   _machines,_

   _machine,_

   _list-machine_


 

^# machines

   **Usage:** ` juju list-machines [options]`

   **Summary:**

   Lists machines in a model.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default, the tabular format is used.

   The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


           juju list-machines


   **See also:**

   [status](#status)

   **Aliases:**

   _machines,_

   _machine,_

   _list-machine_


 

^# publish

   **Usage:** ` juju publish [options] [<charm url>]`

   **Summary:**

   publish charm to the store

   **Options:**

   _--from (= ".")_

   path for charm to be published

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   <charm url> can be a charm URL, or an unambiguously condensed form of it;
   the following forms are accepted:

   For cs:precise/mysql
           cs:precise/mysql
           precise/mysql
   
   For cs:~user/precise/mysql
           cs:~user/precise/mysql
   
   There is no default series, so one must be provided explicitly when
   informing a charm URL. If the URL isn't provided, an attempt will be
   made to infer it from the current branch push URL.



 

^# register

   **Usage:** ` juju register <string>`

   **Summary:**

   Registers a Juju user to a controller.


   
   **Details:**


   Connects to a controller and completes the user registration process that
   began with the `juju add-user` command. The latter prints out the 'string'
   that is referred to in Usage.

   The user will be prompted for a password, which, once set, causes the 
   registration string to be voided. In order to start using Juju the user 
   can now either add a model or wait for a model to be shared with them.
   Some machine providers will require the user to be in possession of 
   certain credentials in order to add a model.


   **Examples:**


          juju register MFATA3JvZDAnExMxMDQuMTU0LjQyLjQ0OjE3MDcwExAxMC4xMjguMC4yOjE3MDcw
          BCBEFCaXerhNImkKKabuX5ULWf2Bp4AzPNJEbXVWgraLrAA=


   **See also:**

   [add-user](#add-user)

   [change-user-password](#change-user-password)


 

^# remove-all-blocks

   **Usage:** ` juju remove-all-blocks [options]`

   **Summary:**

   remove all blocks in the Juju controller

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Remove all blocks in the Juju controller.

   A controller administrator is able to remove all the blocks that have been added
   in a Juju controller.


   **See also:**

   [juju help block](#juju help block)

   [juju help unblock](#juju help unblock)


 

^# remove-backup

   **Usage:** ` juju remove-backup [options] <ID>`

   **Summary:**

   delete a backup

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   remove-backup removes a backup from remote storage.



 

^# remove-cached-images

   **Usage:** ` juju remove-cached-images [options]`

   **Summary:**

   remove cached os images

   **Options:**

   _--arch (= "")_

   the architecture of the image to remove eg amd64

   _--kind (= "")_

   the image kind to remove eg lxd

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--series (= "")_

   the series of the image to remove eg xenial

   
   **Details:**


   Remove cached os images in the Juju model.

   Images are identified by:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"

   **Examples:**


        # Remove cached lxd image for xenial amd64.
        juju remove-cached-images --kind lxd --series xenial --arch amd64



 

^# remove-credential

   **Usage:** ` juju remove-credential <cloud name> <credential name>`

   **Summary:**

   Removes credentials for a cloud.


   
   **Details:**


   The credentials to be removed are specified by a "credential name".

   Credential names, and optionally the corresponding authentication
   material, can be listed with `juju list-credentials`.


   **Examples:**


          juju remove-credential rackspace credential_name


   **See also:**

   [add-credential](#add-credential)

   [list-credentials](#list-credentials)

   [set-default-credential](#set-default-credential)

   [autoload-credentials](#autoload-credentials)


 

^# remove-machine

   **Usage:** ` juju remove-machine [options] <machineID[s]> ...`

   **Summary:**

   remove machines from the model

   **Options:**

   _--force  (= false)_

   completely remove machine and all dependencies

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Machines that are responsible for the model cannot be removed. Machines
   running units or containers can only be removed with the --force flag; doing
   so will also remove all those units and containers without giving them any
   opportunity to shut down cleanly.


   **Examples:**

   	# Remove machine number 5 which has no running units or containers
   	$ juju remove-machine 5
   	# Remove machine 6 and any running units or containers
   	$ juju remove-machine 6 --force


   **Aliases:**

   _remove-machines_


 

^# remove-machines

   **Usage:** ` juju remove-machine [options] <machineID[s]> ...`

   **Summary:**

   remove machines from the model

   **Options:**

   _--force  (= false)_

   completely remove machine and all dependencies

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Machines that are responsible for the model cannot be removed. Machines
   running units or containers can only be removed with the --force flag; doing
   so will also remove all those units and containers without giving them any
   opportunity to shut down cleanly.


   **Examples:**

   	# Remove machine number 5 which has no running units or containers
   	$ juju remove-machine 5
   	# Remove machine 6 and any running units or containers
   	$ juju remove-machine 6 --force


   **Aliases:**

   _remove-machines_


 

^# remove-relation

   **Usage:** ` juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]`

   **Summary:**

   Removes an existing relation between two services.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   An existing relation between the two specified services will be removed. 
   This should not result in either of the services entering an error state,
   but may result in either or both of the services being unable to continue
   normal operation. In the case that there is more than one relation between
   two services it is necessary to specify which is to be removed (see
   examples). Relations will automatically be removed when using the`juju
   remove-service` command.


   **Examples:**


          juju remove-relation mysql wordpress

   In the case of multiple relations, the relation name should be specified
   at least once - the following examples will all have the same effect:

          juju remove-relation mediawiki:db mariadb:db
          juju remove-relation mediawiki mariadb:db
          juju remove-relation mediawiki:db mariadb
       


   **See also:**

   [add-relation](#add-relation)

   [remove-service](#remove-service)

   **Aliases:**

   _destroy-relation_


 

^# remove-service

   **Usage:** ` juju remove-service [options] <service>`

   **Summary:**

   Remove a service from the model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Removing a service will terminate any relations that service has, remove
   all units of the service, and in the case that this leaves machines with
   no running services, Juju will also remove the machine. For this reason,
   you should retrieve any logs or data required from services and units 
   before removing them. Removing units which are co-located with units of
   other charms or a Juju controller will not result in the removal of the
   machine.


   **Examples:**


          juju remove-service hadoop
          juju remove-service -m test-model mariadb


   **Aliases:**

   _destroy-service_


 

^# remove-ssh-key

   **Usage:** ` juju remove-ssh-key [options] <ssh key id> ...`

   **Summary:**

   Removes a public SSH key (or keys) from a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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

   [list-ssh-key](#list-ssh-key)

   [add-ssh-key](#add-ssh-key)

   [import-ssh-key](#import-ssh-key)

   **Aliases:**

   _remove-ssh-keys_


 

^# remove-ssh-keys

   **Usage:** ` juju remove-ssh-key [options] <ssh key id> ...`

   **Summary:**

   Removes a public SSH key (or keys) from a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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

   [list-ssh-key](#list-ssh-key)

   [add-ssh-key](#add-ssh-key)

   [import-ssh-key](#import-ssh-key)

   **Aliases:**

   _remove-ssh-keys_


 

^# remove-unit

   **Usage:** ` juju remove-unit [options] <unit> [...]`

   **Summary:**

   remove service units from the model

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Remove service units from the model.

   If this is the only unit running, the machine on which
   the unit is hosted will also be destroyed, if possible.

   The machine will be destroyed if:

   - it is not a controller
   - it is not hosting any Juju managed containers

   **Aliases:**

   _destroy-unit_


 

^# resolved

   **Usage:** ` juju resolved [options] <unit>`

   **Summary:**

   marks unit errors resolved

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-r, --retry  (= false)_

   re-execute failed hooks


 

^# resources

   **Usage:** ` juju list-resources [options] service-or-unit`

   **Summary:**

   show the resources for a service or unit

   **Options:**

   _--details  (= false)_

   show detailed information about resources used by each unit.

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command shows the resources required by and those in use by an existing
   service or unit in your model.  When run for a service, it will also show any
   updates available for resources from the charmstore.


   **Aliases:**

   _resources_


 

^# restore-backup

   **Usage:** ` juju restore-backup [options]`

   **Summary:**

   restore from a backup archive to a new controller

   **Options:**

   _-b  (= false)_

   bootstrap a new state machine

   _--constraints  (= )_

   set model constraints

   _--file (= "")_

   provide a file to be used as the backup.

   _--id (= "")_

   provide the name of the backup to be restored.

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--upload-tools  (= false)_

   upload tools if bootstraping a new machine.

   
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

   retries provisioning for failed machines

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>


 

^# revoke

   **Usage:** ` juju revoke [options] <user> <model name> ...`

   **Summary:**

   Revokes access from a Juju user for a model.

   **Options:**

   _--acl (= "read")_

   Access control ('read' or 'write')

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   By default, the controller is the current controller.

   Revoking write access, from a user who has that permission, will leave
   that user with read access. Revoking read access, however, also revokes
   write access.


   **Examples:**

   Revoke read (and write) access from user 'joe' for model 'mymodel':

          juju revoke joe mymodel

   Revoke write access from user 'sam' for models 'model1' and 'model2':

          juju revoke --acl=write sam model1 model2


   **See also:**

   [grant](#grant)


 

^# run

   **Usage:** ` juju run [options] <commands>`

   **Summary:**

   run the commands on the remote targets specified

   **Options:**

   _--all  (= false)_

   run the commands on all the machines

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--machine  (= )_

   one or more machine ids

   _-o, --output (= "")_

   Specify an output file

   _--service  (= )_

   one or more service names

   _--timeout  (= 5m0s)_

   how long to wait before the remote command is considered to have failed

   _--unit  (= )_

   one or more unit ids

   
   **Details:**


   Run the commands on the specified targets.

   Targets are specified using either machine ids, service names or unit
   names.  At least one target specifier is needed.

   Multiple values can be set for --machine, --service, and --unit by using
   comma separated values.

   If the target is a machine, the command is run as the "ubuntu" user on
   the remote machine.

   If the target is a service, the command is run on all units for that
   service. For example, if there was a service "mysql" and that service
   had two units, "mysql/0" and "mysql/1", then
           --service mysql
   
   is equivalent to
           --unit mysql/0,mysql/1
   
   Commands run for services or units are executed in a 'hook context' for
   the unit.

   --all is provided as a simple way to run the command on all the machines
   in the model.  If you specify --all you cannot provide additional
   targets.

   Since juju run creates actions, you can query for the status of commands
   started with juju run by calling "juju show-action-status --name juju-run".


 

^# run-action

   **Usage:** ` juju run-action [options] <unit> <action name> [key.key.key...=value]`

   **Summary:**

   queue an action for execution

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--params  (= )_

   path to yaml-formatted params file

   _--string-args  (= false)_

   use raw string values of CLI args

   
   **Details:**


   Queue an Action for execution on a given unit, with a given set of params.
   Displays the ID of the Action for use with 'juju kill', 'juju status', etc.
   Params are validated according to the charm for the unit's service.  The 
   valid params can be seen using "juju action defined <service> --schema".
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

   **Usage:** ` juju scp [options] <file> [<user>@]<target>:[<path>]`

   **Summary:**

   Transfers files to/from a Juju machine.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= true)_

   Enable pseudo-tty allocation

   
   **Details:**


   The usage is for transferring files from the client to a Juju machine. To
   do the reverse:

   juju scp [options] [<user>@]<target>:<file> <path>
   and use quotes when multiple files are involved.

   The machine is identified by the <target> argument which is either a 'unit
   name' or a 'machine id'. Both are obtained in the output from `juju 
   status`: unit name in the [Units] section and machine id in the [Machines]
   section.

   If 'user' is specified then the connection is made to that user account;
   otherwise, the 'ubuntu' account is used.

   'file' can be single or multiple files or directories. For directories,
   you must use the scp option of '-r'.

   Options specific to scp can be inserted between 'scp' and '[options]' with
   '-- <scp-options>'. Refer to the scp(1) man page for an explanation of
   those options.


   **Examples:**

   Copy file /var/log/syslog from machine 2 to the client's current working
   directory:

          juju scp 2:/var/log/syslog .

   Copy directory /var/log/mongodb, recursively, from a mongodb unit
   to the client's local directory remote-logs:

          juju scp -- -r mongodb/0:/var/log/mongodb/ remote-logs

   Copy file foo.txt, in verbose mode, from the client's current working
   directory to an apache2 unit of model "mymodel":

          juju scp -- -v -m mymodel foo.txt apache2/1:

   Copy multiple files from the client's current working directory to machine
   2:

          juju scp file1 file2 2:

   Copy multiple files from the bob user account on machine 3 to the client's
   current working directory:

          juju scp bob@3:'file1 file2' .


   **See also:**

   [ssh](#ssh)


 

^# set-budget

   **Usage:** ` juju set-budget`

   **Summary:**

   set the budget limit


   
   **Details:**


   Set the monthly budget limit.

   Example:

          juju set-budget personal 96
              Sets the monthly limit for budget named 'personal' to 96.



 

^# set-config

   **Usage:** ` juju set-config [options] <service name> <service key>=<value> ...`

   **Summary:**

   Sets configuration options for a service.

   **Options:**

   _--config  (= )_

   path to yaml-formatted service config

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--to-default  (= false)_

   set service option values to default

   
   **Details:**


   Charms may, and frequently do, expose a number of configuration settings
   for a service to the user. These can be set at deploy time, but may be set
   at any time by using the `juju set-config` command. The actual options
   vary per charm (you can check the charm documentation, or use `juju get-
   config` to check which options may be set).

   If ‘value’ begins with the ‘@’ character, it is interpreted as a filename
   and the actual value is read from it. The maximum size of the filename is
   5M.

   Values may be any UTF-8 encoded string. UTF-8 is accepted on the command
   line and in referenced files.

   See `juju status` for service names.


   **Examples:**


          juju set-config mysql dataset-size=80% backup_dir=/vol1/mysql/backups
          juju set-config apache2 --model mymodel --config /home/ubuntu/mysql.yaml


   **See also:**

   [get-config](#get-config)

   [deploy](#deploy)

   [status](#status)

   **Aliases:**

   _set-configs_


 

^# set-configs

   **Usage:** ` juju set-config [options] <service name> <service key>=<value> ...`

   **Summary:**

   Sets configuration options for a service.

   **Options:**

   _--config  (= )_

   path to yaml-formatted service config

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--to-default  (= false)_

   set service option values to default

   
   **Details:**


   Charms may, and frequently do, expose a number of configuration settings
   for a service to the user. These can be set at deploy time, but may be set
   at any time by using the `juju set-config` command. The actual options
   vary per charm (you can check the charm documentation, or use `juju get-
   config` to check which options may be set).

   If ‘value’ begins with the ‘@’ character, it is interpreted as a filename
   and the actual value is read from it. The maximum size of the filename is
   5M.

   Values may be any UTF-8 encoded string. UTF-8 is accepted on the command
   line and in referenced files.

   See `juju status` for service names.


   **Examples:**


          juju set-config mysql dataset-size=80% backup_dir=/vol1/mysql/backups
          juju set-config apache2 --model mymodel --config /home/ubuntu/mysql.yaml


   **See also:**

   [get-config](#get-config)

   [deploy](#deploy)

   [status](#status)

   **Aliases:**

   _set-configs_


 

^# set-constraints

   **Usage:** ` juju set-constraints [options] <service> <constraint>=<value> ...`

   **Summary:**

   Sets machine constraints for a service.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Sets constraints for a service, which are used for all new machines 
   provisioned for that service. They can be viewed with `juju get-
   constraints`.

   By default, the model is the current model.

   Service constraints are combined with model constraints, set with `juju 
   set-model-constraints`, for commands (such as 'juju deploy') that 
   provision machines for services. Where model and service constraints
   overlap, the service constraints take precedence.

   Constraints for a specific model can be viewed with `juju get-model-
   constraints`.

   This command requires that the service to have at least one unit. To apply 
   constraints to
   the first unit set them at the model level or pass them as an argument
   when deploying.


   **Examples:**


          juju set-constraints mysql mem=8G cpu-cores=4
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
   can be listed with `juju list-credentials`.

   Default credentials avoid the need to specify a particular set of 
   credentials when more than one are available for a given cloud.


   **Examples:**


          juju set-default-credential google credential_name


   **See also:**

   [add-credential](#add-credential)

   [remove-credential](#remove-credential)

   [list-credentials](#list-credentials)

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

   **Usage:** ` juju set-meter-status [options] [service or unit] status`

   **Summary:**

   sets the meter status on a service or unit

   **Options:**

   _--info (= "")_

   Set the meter status info to this string

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Set meter status on the given service or unit. This command is used to test the meter-status-changed hook for charms in development.

   **Examples:**


        juju set-meter-status myapp RED # Set Red meter status on all units of myapp
        juju set-meter-status myapp/0 AMBER --info "my message" # Set AMBER meter status with "my message" as info on unit myapp/0



 

^# set-model-config

   **Usage:** ` juju set-model-config [options] <model key>=<value> ...`

   **Summary:**

   Sets configuration keys on a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Model configuration consists of a collection of keys and their respective values.
   By default, the model is the current model.

   Consult the online documentation for a list of keys and possible values.

   **Examples:**


          juju set-model-config logging-config='<root>=WARNING;unit=INFO'
          juju set-model-config -m mymodel api-port=17071 default-series=xenial


   **See also:**

   [ist-models](#ist-models)

   [get-model-config](#get-model-config)

   [unset-model-config](#unset-model-config)


 

^# set-model-constraints

   **Usage:** ` juju set-model-constraints [options] <constraint>=<value> ...`

   **Summary:**

   Sets machine constraints on a model.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Sets machine constraints on the model that can be viewed with
   `juju get-model-constraints`.  By default, the model is the current model.
   Model constraints are combined with constraints set for a service with
   `juju set-constraints` for commands (such as 'deploy') that provision
   machines for services. Where model and service constraints overlap, the
   service constraints take precedence.

   Constraints for a specific service can be viewed with `juju get-constraints`.

   **Examples:**


          juju set-model-constraints cpu-cores=8 mem=16G
          juju set-model-constraints -m mymodel root-disk=64G


   **See also:**

   [ist-models](#ist-models)

   [get-model-constraints](#get-model-constraints)

   [set-constraints](#set-constraints)

   [get-constraints](#get-constraints)


 

^# set-plan

   **Usage:** ` juju set-plan [options] <service name> <plan>`

   **Summary:**

   set the plan for a service

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Set the plan for the deployed service, effective immediately.

   The specified plan name must be a valid plan that is offered for this particular charm. Use "juju list-plans <charm>" for more information.
   	
   Usage:

          juju set-plan [options] <service name> <plan name>
   
   Example:

          juju set-plan myapp example/uptime


 

^# show-action-output

   **Usage:** ` juju show-action-output [options] <action ID>`

   **Summary:**

   show results of an action by ID

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--wait (= "-1s")_

   wait for results

   
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

   show results of all actions filtered by optional ID prefix

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--name (= "")_

   an action name

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show the status of Actions matching given ID, partial ID prefix, or all Actions if no ID is supplied.
   If --name <name> is provided the search will be done by name rather than by ID.


 

^# show-backup

   **Usage:** ` juju show-backup [options] <ID>`

   **Summary:**

   get metadata

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   show-backup provides the metadata associated with a backup.



 

^# show-budget

   **Usage:** ` juju show-budget [options]`

   **Summary:**

   show budget usage

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Display budget usage information.

   Example:

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

   [ist-clouds](#ist-clouds)

   [update-clouds](#update-clouds)


 

^# show-controller

   **Usage:** ` juju show-controller [options] [<controller name> ...]`

   **Summary:**

   Shows detailed information of a controller.

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-passwords  (= false)_

   Show passwords for displayed accounts

   
   **Details:**


   Shows extended information about a controller(s) as well as related models
   and accounts. The active model and user accounts are also displayed.


   **Examples:**


          juju show-controller
          juju show-controller aws google
          


   **See also:**

   [list-controllers](#list-controllers)

   **Aliases:**

   _show-controllers_


 

^# show-controllers

   **Usage:** ` juju show-controller [options] [<controller name> ...]`

   **Summary:**

   Shows detailed information of a controller.

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-passwords  (= false)_

   Show passwords for displayed accounts

   
   **Details:**


   Shows extended information about a controller(s) as well as related models
   and accounts. The active model and user accounts are also displayed.


   **Examples:**


          juju show-controller
          juju show-controller aws google
          


   **See also:**

   [list-controllers](#list-controllers)

   **Aliases:**

   _show-controllers_


 

^# show-machine

   **Usage:** ` juju show-machine [options] <machineID> ...`

   **Summary:**

   show a machines status

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   Show a specified machine on a model:

   juju show-machine <machineID> ...

   For example:

   juju show-machine 0
   or for multiple machines
   (the following will display status for machines 1, 2 & 3):

   juju show-machine 1 2 3
   Default format is in yaml, other formats can be specified
   with the "--format" option.  Available formats are yaml,
   tabular, and json

   **Aliases:**

   _show-machines_


 

^# show-machines

   **Usage:** ` juju show-machine [options] <machineID> ...`

   **Summary:**

   show a machines status

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   Show a specified machine on a model:

   juju show-machine <machineID> ...

   For example:

   juju show-machine 0
   or for multiple machines
   (the following will display status for machines 1, 2 & 3):

   juju show-machine 1 2 3
   Default format is in yaml, other formats can be specified
   with the "--format" option.  Available formats are yaml,
   tabular, and json

   **Aliases:**

   _show-machines_


 

^# show-model

   **Usage:** ` juju show-model [options]`

   **Summary:**

   shows information about the current or specified model

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show information about the current or specified model


 

^# show-status

   **Usage:** ` juju status [options] [filter pattern ...]`

   **Summary:**

   Displays the current status of Juju, services, and units.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|line|oneline|short|summary|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default (without argument), the status of Juju and all services and all
   units will be displayed. 
   Service or unit names may be used as output filters (the '*' can be used
   as a wildcard character).  
   In addition to matched services and units, related machines, services, and
   units will also be displayed. If a subordinate unit is matched, then its
   principal unit will be displayed. If a principal unit is matched, then all
   of its subordinates will be displayed. 
   Explanation of the different formats:

   - {short|line|oneline}: List units and their subordinates. For each
                    unit, the IP address and agent status are listed.

   
   - summary: Displays the subnet(s) and port(s) the model utilises.

                    Also displays aggregate information about:

                    - MACHINES: total #, and # in each state.

                    - UNITS: total #, and # in each state.

                    - SERVICES: total #, and # exposed of each service.

   
   - tabular (default): Displays information in a tabular format in these sections:
                    - Machines: ID, STATE, DNS, INS-ID, SERIES, AZ
                    - Services: NAME, EXPOSED, CHARM
                    - Units: ID, STATE, VERSION, MACHINE, PORTS, PUBLIC-ADDRESS
                      - Also displays subordinate units.

   
   - yaml: Displays information on machines, services, and units in yaml format.
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


          juju status
          juju status mysql
          juju status nova-*


   **Aliases:**

   _show-status_


 

^# show-storage

   **Usage:** ` juju show-storage [options]`

   **Summary:**

   shows storage instance

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|smart|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show extended information about storage instances.

   Storage instances to display are specified by storage ids.

   * note use of positional arguments
   options:

   -m, --model (= "")
            juju model to operate in
   
   -o, --output (= "")
            specify an output file
   
   --format (= yaml)
            specify output format (json|yaml)
   
   [space separated storage ids]


 

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

   Specify output format (json|smart|yaml)

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

   [list-users](#list-users)


 

^# spaces

   **Usage:** ` juju list-spaces [options] [--short] [--format yaml|json] [--output <path>]`

   **Summary:**

   List known spaces, including associated subnets

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

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

   _spaces_


 

^# ssh

   **Usage:** ` juju ssh [options] <[user@]target> [command]`

   **Summary:**

   Initiates an SSH session or executes a command on a Juju machine.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= true)_

   Enable pseudo-tty allocation

   
   **Details:**


   The machine is identified by the <target> argument which is either a 'unit
   name' or a 'machine id'. Both are obtained in the output to `juju status`.
   If 'user' is specified then the connection is made to that user account;
   otherwise, the default 'ubuntu' account, created by Juju, is used.

   The optional command is executed on the remote machine. Any output is sent
   back to the user. Screen-based programs require the default of '--pty=true'.

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


 

^# ssh-key

   **Usage:** ` juju list-ssh-keys [options]`

   **Summary:**

   Lists the currently known SSH keys for the current (or specified) model.

   **Options:**

   _--full  (= false)_

   Show full key instead of just the fingerprint

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju maintains a per-model cache of SSH keys which it copies to each newly
   created unit.

   This command will display a list of all the keys currently used by Juju in
   the current model (or the model specified, if the '-m' option is used).
   By default a minimal list is returned, showing only the fingerprint of
   each key and its text identifier. By using the '--full' option, the entire
   key may be displayed.


   **Examples:**


          juju list-ssh-keys

   To examine the full key, use the '--full' option:

          juju list-keys -m jujutest --full


   **Aliases:**

   _ssh-key,_

   _ssh-keys,_

   _list-ssh-key_


 

^# ssh-keys

   **Usage:** ` juju list-ssh-keys [options]`

   **Summary:**

   Lists the currently known SSH keys for the current (or specified) model.

   **Options:**

   _--full  (= false)_

   Show full key instead of just the fingerprint

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju maintains a per-model cache of SSH keys which it copies to each newly
   created unit.

   This command will display a list of all the keys currently used by Juju in
   the current model (or the model specified, if the '-m' option is used).
   By default a minimal list is returned, showing only the fingerprint of
   each key and its text identifier. By using the '--full' option, the entire
   key may be displayed.


   **Examples:**


          juju list-ssh-keys

   To examine the full key, use the '--full' option:

          juju list-keys -m jujutest --full


   **Aliases:**

   _ssh-key,_

   _ssh-keys,_

   _list-ssh-key_


 

^# status

   **Usage:** ` juju status [options] [filter pattern ...]`

   **Summary:**

   Displays the current status of Juju, services, and units.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|line|oneline|short|summary|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   By default (without argument), the status of Juju and all services and all
   units will be displayed. 
   Service or unit names may be used as output filters (the '*' can be used
   as a wildcard character).  
   In addition to matched services and units, related machines, services, and
   units will also be displayed. If a subordinate unit is matched, then its
   principal unit will be displayed. If a principal unit is matched, then all
   of its subordinates will be displayed. 
   Explanation of the different formats:

   - {short|line|oneline}: List units and their subordinates. For each
                    unit, the IP address and agent status are listed.

   
   - summary: Displays the subnet(s) and port(s) the model utilises.

                    Also displays aggregate information about:

                    - MACHINES: total #, and # in each state.

                    - UNITS: total #, and # in each state.

                    - SERVICES: total #, and # exposed of each service.

   
   - tabular (default): Displays information in a tabular format in these sections:
                    - Machines: ID, STATE, DNS, INS-ID, SERIES, AZ
                    - Services: NAME, EXPOSED, CHARM
                    - Units: ID, STATE, VERSION, MACHINE, PORTS, PUBLIC-ADDRESS
                      - Also displays subordinate units.

   
   - yaml: Displays information on machines, services, and units in yaml format.
   Note: AZ above is the cloud region's availability zone.


   **Examples:**


          juju status
          juju status mysql
          juju status nova-*


   **Aliases:**

   _show-status_


 

^# status-history

   **Usage:** ` juju status-history [options] [-n N] [--type T] [--utc] <entity name>`

   **Summary:**

   output past statuses for the passed entity

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-n  (= 20)_

   size of logs backlog.

   _--type (= "unit")_

   type of statuses to be displayed [agent|workload|combined|machine|machineInstance|container|containerinstance].

   _--utc  (= false)_

   display time as UTC in RFC3339 format

   
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



 

^# storage

   **Usage:** ` juju list-storage [options] <machineID> ...`

   **Summary:**

   lists storage details

   **Options:**

   _--filesystem  (= false)_

   list filesystem storage

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--volume  (= false)_

   list volume storage

   
   **Details:**


   List information about storage instances.

   options:

   -m, --model (= "")
            juju model to operate in
   
   -o, --output (= "")
            specify an output file
   
   --format (= tabular)
            specify output format (json|tabular|yaml)

   **Aliases:**

   _storage_


 

^# subnets

   **Usage:** ` juju list-subnets [options] [--space <name>] [--zone <name>] [--format yaml|json] [--output <path>]`

   **Summary:**

   list subnets known to Juju

   **Options:**

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _-o, --output (= "")_

   Specify an output file

   _--space (= "")_

   filter results by space name

   _--zone (= "")_

   filter results by zone name

   
   **Details:**


   Displays a list of all subnets known to Juju. Results can be filtered
   using the optional --space and/or --zone arguments to only display
   subnets associated with a given network space and/or availability zone.
   Like with other Juju commands, the output and its format can be changed
   using the --format and --output (or -o) optional arguments. Supported
   output formats include "yaml" (default) and "json". To redirect the
   output to a file, use --output.


   **Aliases:**

   _subnets_


 

^# switch

   **Usage:** ` juju switch [<controller>|<model>|<controller>:<model>]`

   **Summary:**

   Selects or identifies the current controller and model.


   
   **Details:**


   When used without an argument, the command shows the current controller 
   and its active model. 
   When switching by controller name alone, the model
   you get is the active model for that controller. If you want a different
   model then you must switch using controller:model notation or switch to 
   the controller and then to the model. 
   The `juju list-models` command can be used to determine the active model
   (of any controller). An asterisk denotes it.


   **Examples:**


          juju switch
          juju switch mymodel
          juju switch mycontroller
          juju switch mycontroller:mymodel


   **See also:**

   [list-controllers](#list-controllers)

   [list-models](#list-models)

   [show-controller](#show-controller)


 

^# sync-tools

   **Usage:** ` juju sync-tools [options]`

   **Summary:**

   copy tools from the official tool store into a local model

   **Options:**

   _--all  (= false)_

   copy all versions, not just the latest

   _--destination (= "")_

   local destination directory

   _--dev  (= false)_

   consider development versions as well as released ones

   DEPRECATED: use --stream instead

   _--dry-run  (= false)_

   don't copy, just print what would be copied

   _--local-dir (= "")_

   local destination directory

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--public  (= false)_

   tools are for a public cloud, so generate mirrors information

   _--source (= "")_

   local source directory

   _--stream (= "")_

   simplestreams stream for which to sync metadata

   _--version (= "")_

   copy a specific major[.minor] version

   
   **Details:**


   This copies the Juju tools tarball from the official tools store (located
   at https://streams.canonical.com/juju) into your model.

   This is generally done when you want Juju to be able to run without having to
   access the Internet. Alternatively you can specify a local directory as source.
   Sometimes this is because the model does not have public access,
   and sometimes you just want to avoid having to access data outside of
   the local cloud.



 

^# unblock

   **Usage:** ` juju unblock [options] destroy-model | remove-object | all-changes`

   **Summary:**

   unblock an operation that would alter a running model

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Juju allows to safeguard deployed models from unintentional damage by preventing
   execution of operations that could alter model.

   This is done by blocking certain commands from successful execution. Blocked commands
   must be manually unblocked to proceed.

   Some commands offer a --force option that can be used to bypass a block.
   Commands that can be unblocked are grouped based on logical operations as follows:
   destroy-model includes command:

             destroy-model
   
   remove-object includes termination commands:

             destroy-model
             remove-machine
             remove-relation
             remove-service
             remove-unit
   
   all-changes includes all alteration commands
             add-machine
             add-relation
             add-unit
             authorised-keys add
             authorised-keys delete
             authorised-keys import
             deploy
             destroy-model
             enable-ha
             expose
             remove-machine
             remove-relation
             remove-service
             remove-unit
             resolved
             retry-provisioning
             run
             set
             set-constraints
             set-model-config
             sync-tools
             unexpose
             unset
             unset-model-config
             upgrade-charm
             upgrade-juju
             add-user
             change-user-password
             disable-user
             enable-user

   **Examples:**


         To allow the model to be destroyed:
         juju unblock destroy-model
         To allow the machines, services, units and relations to be removed:
         juju unblock remove-object
         To allow changes to the model:
         juju unblock all-changes


   **See also:**

   [juju help block](#juju help block)


 

^# unexpose

   **Usage:** ` juju unexpose [options] <service name>`

   **Summary:**

   Removes public availability over the network for a service.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Adjusts the firewall rules and any relevant security mechanisms of the
   cloud to deny public access to the service.

   A service is unexposed by default when it gets created.


   **Examples:**


          juju unexpose wordpress


   **See also:**

   [expose](#expose)


 

^# unset-model-config

   **Usage:** ` juju unset-model-config [options] <model key> ...`

   **Summary:**

   Unsets model configuration.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   A model key is reset to its default value. If it does not have such a
   value defined then it is removed.

   Attempting to remove a required key with no default value will result
   in an error.

   By default, the model is the current model.

   Model configuration key values can be viewed with `juju get-model-config`.

   **Examples:**


          juju unset-model-config api-port test-mode


   **See also:**

   [et-model-config](#et-model-config)

   [get-model-config](#get-model-config)


 

^# update-allocation

   **Usage:** ` juju update-allocation [options]`

   **Summary:**

   update an allocation

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   Updates an existing allocation on a service.

   Example:

          juju update-allocation wordpress 10
              Sets the allocation for the wordpress service to 10.



 

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

   [ist-clouds](#ist-clouds)


 

^# upgrade-charm

   **Usage:** ` juju upgrade-charm [options] <service>`

   **Summary:**

   upgrade a service's charm

   **Options:**

   _--channel (= "")_

   channel to use when getting the charm or bundle from the charm store

   _--force-series  (= false)_

   upgrade even if series of deployed services are not supported by the new charm

   _--force-units  (= false)_

   upgrade all units immediately, even if in error state

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--path (= "")_

   upgrade to a charm located at path

   _--resource  (= )_

   resource to be uploaded to the controller

   _--revision  (= -1)_

   explicit revision of current charm

   _--switch (= "")_

   crossgrade to a different charm

   
   **Details:**


   When no flags are set, the service's charm will be upgraded to the latest
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
   If the new version of a charm does not explicitly support the service's series, the
   upgrade is disallowed unless the --force-series flag is used. This option should be
   used with caution since using a charm on a machine running an unsupported series may
   cause unexpected behavior.

   The --switch flag allows you to replace the charm with an entirely different one.
   The new charm's URL and revision are inferred as they would be when running a
   deploy command.

   Please note that --switch is dangerous, because juju only has limited
   information with which to determine compatibility; the operation will succeed,
   regardless of potential havoc, so long as the following conditions hold:
   - The new charm must declare all relations that the service is currently
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

   upgrade to a new Juju GUI version

   **Options:**

   _--list  (= false)_

   list available Juju GUI release versions without upgrading

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
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

   _--dry-run  (= false)_

   Don't change anything, just report what would be changed

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   _--reset-previous-upgrade  (= false)_

   Clear the previous (incomplete) upgrade status (use with care)

   _--upload-tools  (= false)_

   Upload local version of tools; for development use only

   _--version (= "")_

   Upgrade to specific version

   _-y, --yes  (= false)_

   Answer 'yes' to confirmation prompts

   
   **Details:**


   Juju provides agent software to every machine it creates. This command
   upgrades that software across an entire model, which is, by default, the
   current model.

   A model's agent version can be shown with `juju get-model-config agent-
   version`.

   A version is denoted by: major.minor.patch
   The upgrade candidate will be auto-selected if '--version' is not
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
          juju upgrade-juju --version 2.0.1
          


   **See also:**

   [sync-tools](#sync-tools)


 

^# upload-backup

   **Usage:** ` juju upload-backup [options] <filename>`

   **Summary:**

   store a backup archive file remotely in juju

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [<controller name>:]<model name>

   
   **Details:**


   upload-backup sends a backup archive file to remote storage.



 

^# version

   **Usage:** ` juju version [options]`

   **Summary:**

   print the current version

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-o, --output (= "")_

   Specify an output file


 

