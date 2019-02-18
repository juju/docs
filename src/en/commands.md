Title: Command reference

# Command reference

You can get a list of all Juju commands by invoking `juju help commands` in a
terminal.

To drill down into each command use `juju help <command name>`.

This same information is also provided below. Click on a command to view
information on it.

^# actions

   **Usage:** ` juju actions [options] <application name>`

   **Summary:**

   List actions defined for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= default)_

   Specify output format (default|json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--schema  (= false)_

   Display the full action schema

   
   **Details:**


   List the actions available to run on the target application, with a short
   description.  To show the full schema for the actions, use --schema.

   For more information, see also the 'run-action' command, which executes actions.

   **Aliases:**

   `list-actions`



^# add-cloud

   **Usage:** ` juju add-cloud [options] <cloud name> <cloud definition file>`

   **Summary:**

   Adds a cloud definition to Juju.

   **Options:**

   _-f (= "")_

   The path to a cloud definition file

   _--replace  (= false)_

   Overwrite any existing cloud information for &lt;cloud name>

   
   **Details:**


   Juju needs to know how to connect to clouds. A cloud definition 
   describes a cloud's endpoints and authentication requirements. Each
   definition is stored and accessed later as <cloud name>.

   If you are accessing a public cloud, running add-cloud unlikely to be 
   necessary.  Juju already contains definitions for the public cloud 
   providers it supports.

   add-cloud operates in two modes:

             juju add-cloud
             juju add-cloud <cloud name> <cloud definition file>
   
   When invoked without arguments, add-cloud begins an interactive session
   designed for working with private clouds.  The session will enable you 
   to instruct Juju how to connect to your private cloud.

   When <cloud definition file> is provided with <cloud name>, 
   Juju stores that definition its internal cache directly after 
   validating the contents.

   If <cloud name> already exists in Juju's cache, then the `--replace` 
   option is required.

   A cloud definition file has the following YAML format:

   clouds:                           # mandatory
           mycloud:                        # <cloud name> argument
             type: openstack               # <cloud type>, see below
             auth-types: [ userpass ]
             regions:

               london:

                 endpoint: https://london.mycloud.com:35574/v3.0/
   
   <cloud types> for private clouds: 
          - lxd
          - maas
          - manual
          - openstack
          - vsphere
   
   <cloud types> for public clouds:

          - azure
          - cloudsigma
          - ec2
          - gce
          - joyent
          - oci

   **Examples:**

       juju add-cloud
       juju add-cloud mycloud ~/mycloud.yaml
       juju add-cloud --replace mycloud ~/mycloud2.yaml



   **See also:**

   [clouds](#clouds)  



^# add-credential

   **Usage:** ` juju add-credential [options] <cloud name>`

   **Summary:**

   Adds or replaces credentials for a cloud, stored locally on this client.

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

               auth-type: service-principal-secret
               application-id: <uuid1>
               application-password: <password>
               subscription-id: <uuid2>
           lxd:

             <credential name>:

               auth-type: interactive
               trust-password: <password>
   
   A "credential name" is arbitrary and is used solely to represent a set of
   credentials, of which there may be multiple per cloud.

   The `--replace` option is required if credential information for the named
   cloud already exists locally. All such information will be overwritten.
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

   [credentials](#credentials) , 
   [remove-credential](#remove-credential) , 
   [set-default-credential](#set-default-credential) , 
   [autoload-credentials](#autoload-credentials)  



^# add-k8s

   **Usage:** ` juju add-k8s [options] <k8s name>`

   **Summary:**

   Adds a k8s endpoint and credential to Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--cluster-name (= "")_

   Specify the k8s cluster to import

   
   **Details:**


   Creates a user-defined cloud and populate the selected controller with the k8s
   cloud details. Speficify non default kubeconfig file location using $KUBECONFIG
   environment variable or pipe in file content from stdin. The config file
   can contain definitions for different k8s clusters, use --cluster-name to pick
   which one to use.


   **Examples:**

       juju add-k8s myk8scloud
       KUBECONFIG=path-to-kubuconfig-file juju add-k8s myk8scloud --cluster-name=my_cluster_name
       kubectl config view --raw | juju add-k8s myk8scloud --cluster-name=my_cluster_name



   **See also:**

   [remove-k8s](#remove-k8s)  



^# add-machine

   **Usage:** ` juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | winrm:[user@]host | placement]`

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   **Examples:**

      juju add-machine                      (starts a new machine)
      juju add-machine -n 2                 (starts 2 new machines)
      juju add-machine lxd                  (starts a new machine with an lxd container)
      juju add-machine lxd -n 2             (starts 2 new machines with an lxd container)
      juju add-machine lxd:4                (starts a new lxd container on machine 4)
      juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
      juju add-machine ssh:user@10.10.0.3   (manually provisions machine with ssh)
      juju add-machine winrm:user@10.10.0.3 (manually provisions machine with winrm)
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

   _--no-switch  (= false)_

   Do not switch to the newly created model

   _--owner (= "")_

   The owner of the new model if not the current user

   
   **Details:**


   Adding a model is typically done in order to run a specific workload.

   To add a model, you must specify a model name. Model names can be duplicated 
   across controllers but must be unique per user for any given controller. 
   In other words, Alice and Bob can each have their own model called "secret" but 
   Alice can have only one model called "secret" in a controller.

   Model names may only contain lowercase letters, digits and hyphens, and 
   may not start with a hyphen.

   To add a model, Juju requires a credential:

             * if you have a default (or just one) credential defined at client
              (i.e. in credentials.yaml), then juju will use that;
             * if you have no default (and multiple) credentials defined at the client, 
              then you must specify one using --credential;
             * as the admin user you can omit the credential, 
              and the credential used to bootstrap will be used.

   
   To add a credential for add-model, use one of the "juju add-credential" or 
   "juju autoload-credentials" commands. These will add credentials 
   to the Juju client, which "juju add-model" will upload to the controller 
   as necessary.

   You may also supply model-specific configuration as well as a
   cloud/region to which this model will be deployed. The cloud/region and credentials
   are the ones used to create any future resources within the model.

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

   **Usage:** ` juju add-relation [options] <application1>[:<endpoint name1>] <application2>[:<endpoint name2>]`

   **Summary:**

   Add a relation between two application endpoints.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--via (= "")_

   for cross model relations, specify the egress subnets for outbound traffic

   
   **Details:**


   Add a relation between 2 local application endpoints or a local endpoint and a remote application endpoint.
   Adding a relation between two remote application endpoints is not supported.
   Application endpoints can be identified either by:

             <application name>[:<relation name>]
                 where application name supplied without relation will be internally expanded to be well-formed
   
   or
             <model name>.<application name>[:<relation name>]
                 where the application is hosted in another model owned by the current user, in the same controller
   
   or
             <user name>/<model name>.<application name>[:<relation name>]
                 where user/model is another model in the same controller
   
   For a cross model relation, if the consuming side is behind a firewall and/or NAT is used for outbound traffic,
   it is possible to use the --via option to inform the offering side the source of traffic so that any required
   firewall ports may be opened.


   **Examples:**

       $ juju add-relation wordpress mysql
           where "wordpress" and "mysql" will be internally expanded to "wordpress:db" and "mysql:server" respectively

       $ juju add-relation wordpress someone/prod.mysql
           where "wordpress" will be internally expanded to "wordpress:db"

       $ juju add-relation wordpress someone/prod.mysql --via 192.168.0.0/16
       
       $ juju add-relation wordpress someone/prod.mysql --via 192.168.0.0/16,10.0.0.0/8



   **Aliases:**

   `relate`



^# add-space

   **Usage:** ` juju add-space [options] <name> [<CIDR1> <CIDR2> ...]`

   **Summary:**

   Add a new network space.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   [ssh-keys](#ssh-keys) , 
   [remove-ssh-key](#remove-ssh-key) , 
   [import-ssh-key](#import-ssh-key)  



^# add-storage

    **Usage:** ` juju add-storage [options] <unit name> <charm storage name>[=<storage constraints>] ... `

   **Summary:**

   Adds unit storage dynamically.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   
   Storage constraints can be optionally omitted.

   Model default values will be used for all omitted constraint values.

   There is no need to comma-separate omitted constraints. 

   **Examples:**

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

   Add an existing subnet to Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Adds an existing subnet to Juju, making it available for use. Unlike
   "juju add-subnet", this command does not create a new subnet, so it
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

   _--attach-storage  (= )_

   Existing storage to attach to the deployed unit (not available on kubernetes models)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-n, --num-units  (= 1)_

   Number of units to add

   _--to (= "")_

   The machine and/or container to deploy the unit in (bypasses constraints)

   
   **Details:**


   The add-unit is used to scale out an application for improved performance or
   availability.

   The usage of this command differs depending on whether it is being used on a
   Kubernetes or cloud model.

   Many charms will seamlessly support horizontal scaling while others may need
   an additional application support (e.g. a separate load balancer). See the
   documentation for specific charms to check how scale-out is supported.
   For Kubernetes models the only valid argument is -n, --num-units.

   Anything additional will result in an error.

   Example:

   Add five units of mysql:

             juju add-unit mysql --num-units 5
   
   For cloud models, by default, units are deployed to newly provisioned machines
   in accordance with any application or model constraints.

   This command also supports the placement directive ("--to") for targeting
   specific machines or containers, which will bypass application and model
   constraints.


   **Examples:**

   Add five units of mysql on five new machines:

       juju add-unit mysql -n 5

   Add a unit of mysql to machine 23 (which already exists):

       juju add-unit mysql --to 23

   Add two units of mysql to existing machines 3 and 4:

      juju add-unit mysql -n 2 --to 3,4

   Add three units of mysql, one to machine 3 and the others to new
   machines:

       juju add-unit mysql -n 3 --to 3

   Add a unit of mysql into a new LXD container on machine 7:

       juju add-unit mysql --to lxd:7

   Add two units of mysql into two new LXD containers on machine 7:

       juju add-unit mysql -n 2 --to lxd:7,lxd:7

   Add a unit of mysql to LXD container number 3 on machine 24:

       juju add-unit mysql --to 24/lxd/3

   Add a unit of mysql to LXD container on a new machine:

       juju add-unit mysql --to lxd



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


   The user's details are stored within the controller and
   will be removed when the controller is destroyed.

   A user unique registration string will be printed. This registration string 
   must be used by the newly added user as supplied to 
   complete the registration process. 
   Some machine providers will require the user to be in possession of certain
   credentials in order to create a model.


   **Examples:**

       juju add-user bob
       juju add-user --controller mycontroller bob



   **See also:**

   [register](#register) , 
   [grant](#grant) , 
   [users](#users) , 
   [show-user](#show-user) , 
   [disable-user](#disable-user) , 
   [enable-user](#enable-user) , 
   [change-user-password](#change-user-password) , 
   [remove-user](#remove-user)  



^# agree

   **Usage:** ` juju agree [options] <term>`

   **Summary:**

   Agree to terms.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--yes  (= false)_

   Agree to terms non interactively

   
   **Details:**


   Agree to the terms required by a charm.

   When deploying a charm that requires agreement to terms, use 'juju agree' to
   view the terms and agree to them. Then the charm may be deployed.

   Once you have agreed to terms, you will not be prompted to view them again.

   **Examples:**

   Displays terms for somePlan revision 1 and prompts for agreement.

       juju agree somePlan/1

   Displays the terms for revision 1 of somePlan, revision 2 of otherPlan,
   and prompts for agreement.

       juju agree somePlan/1 otherPlan/2

   Agrees to the terms without prompting.

       juju agree somePlan/1 otherPlan/2 --yes





^# agreements

   **Usage:** ` juju agreements [options]`

   **Summary:**

   List user's agreements.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Charms may require a user to accept its terms in order for it to be deployed.
   In other words, some applications may only be installed if a user agrees to 
   accept some terms defined by the charm. 
   This command lists the terms that the user has agreed to.


   **See also:**

   [agree](#agree)  

   **Aliases:**

   `list-agreements`



^# attach

   **Usage:** ` juju attach-resource [options] application name=file`

   **Summary:**

   Upload a file as a resource for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   This command uploads a file from your local disk to the juju controller to be
   used as a resource for an application.


   **Aliases:**

   `attach`



^# attach-resource

   **Usage:** ` juju attach-resource [options] application name=file`

   **Summary:**

   Upload a file as a resource for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   This command uploads a file from your local disk to the juju controller to be
   used as a resource for an application.


   **Aliases:**

   `attach`



^# attach-storage

   **Usage:** ` juju attach-storage [options] <unit> <storage> [<storage> ...]`

   **Summary:**

   Attaches existing storage to a unit.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Attach existing storage to a unit. Specify a unit
   and one or more storage IDs to attach to it.


   **Examples:**

       juju attach-storage postgresql/1 pgdata/0





^# autoload-credentials

   **Usage:** ` juju autoload-credentials`

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

             1. On Linux, $HOME/.aws/credentials and $HOME/.aws/config
             2. Environment variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
   
   GCE
           Credentials:

             1. A JSON file whose path is specified by the
                GOOGLE_APPLICATION_CREDENTIALS environment variable
             2. On Linux, $HOME/.config/gcloud/application_default_credentials.json
                Default region is specified by the CLOUDSDK_COMPUTE_REGION environment
                variable.

             3. On Windows, %APPDATA%\\gcloud\\application_default_credentials.json
   
   OpenStack
           Credentials:

             1. On Linux, $HOME/.novarc
             2. Environment variables OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME,
   
   	   OS_DOMAIN_NAME
   LXD
           Credentials:

             1. On Linux, $HOME/.config/lxc/config.yml
   
   Example:

             juju autoload-credentials
            

   **See also:**

   [list-credentials](#list-credentials) , 
   [remove-credential](#remove-credential) , 
   [set-default-credential](#set-default-credential) , 
   [add-credential](#add-credential)  



^# backups

   **Usage:** ` juju backups [options]`

   **Summary:**

   Displays information about all backups.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   backups provides the metadata associated with all backups.


   **Aliases:**

   `list-backups`



^# bootstrap

   **Usage:** ` juju bootstrap [options] [<cloud name>[/region] [<controller name>]]`

   **Summary:**

   Initializes a cloud environment.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--agent-version (= "")_

   Version of agent binaries to use for Juju agents

   _--auto-upgrade  (= false)_

   After bootstrap, upgrade to the latest patch release

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

   Local path to use as agent and/or image metadata source

   _--model-default  (= )_

   Specify a configuration file, or one or more configuration

   options to be set for all models, unless otherwise specified

   (--model-default config.yaml [--model-default key=value ...])

   _--no-gui  (= false)_

   Do not install the Juju GUI in the controller when bootstrapping

   _--no-switch  (= false)_

   Do not switch to the newly created controller

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

   Available keys for use with --config can be found here:

             https://jujucharms.com/stable/controllers-config
             https://jujucharms.com/stable/models-config
   
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
   By default, the Juju version of the agent binary that is downloaded and
   installed on all models for the new controller will be the same as that
   of the Juju client used to perform the bootstrap.

   However, a user can specify a different agent version via '--agent-version'
   option to bootstrap command. Juju will use this version for models' agents
   as long as the client's version is from the same Juju release series.

   In other words, a 2.2.1 client can bootstrap any 2.2.x agents but cannot
   bootstrap any 2.0.x or 2.1.x agents.

   The agent version can be specified a simple numeric version, e.g. 2.2.4.
   For example, at the time when 2.3.0, 2.3.1 and 2.3.2 are released and your
   agent stream is 'released' (default), then a 2.3.1 client can bootstrap:
             * 2.3.0 controller by running '... bootstrap --agent-version=2.3.0 ...';
             * 2.3.1 controller by running '... bootstrap ...';
             * 2.3.2 controller by running 'bootstrap --auto-upgrade'.

   
   However, if this client has a copy of codebase, then a local copy of Juju
   will be built and bootstrapped - 2.3.1.1.


   **Examples:**

       juju bootstrap
       juju bootstrap --clouds
       juju bootstrap --regions aws
       juju bootstrap aws
       juju bootstrap aws/us-east-1
       juju bootstrap google joe-us-east1
       juju bootstrap --config=~/config-rs.yaml rackspace joe-syd
       juju bootstrap --agent-version=2.2.4 aws joe-us-east-1
       juju bootstrap --config bootstrap-timeout=1200 azure joe-eastus



   **See also:**

   [add-credentials](#add-credentials) , 
   [add-model](#add-model) , 
   [controller-config](#controller-config) , 
   [model-config](#model-config) , 
   [set-constraints](#set-constraints) , 
   [show-cloud](#show-cloud)  



^# budget

   **Usage:** ` juju budget [options] [<wallet>:]<limit>`

   **Summary:**

   Update a budget.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--model-uuid (= "")_

   Model uuid to set budget for.

   
   **Details:**


   Updates an existing budget for a model.


   **Examples:**

   Sets the budget for the current model to 10.

       juju budget 10
   Moves the budget for the current model to wallet 'personal' and sets the limit to 10.

       juju budget personal:10





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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   List all cached images.

     juju cached-images

   List cached images for xenial.

     juju cached-images --series xenial

   List all cached lxd images for xenial amd64.

     juju cached-images --kind lxd --series xenial --arch amd64



   **Aliases:**

   `list-cached-images`



^# cancel-action

   **Usage:** ` juju cancel-action [options] <<action ID | action ID prefix>...>`

   **Summary:**

   Cancel pending actions.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Cancel actions matching given IDs or partial ID prefixes.




^# change-user-password

   **Usage:** ` juju change-user-password [options] [username]`

   **Summary:**

   Changes the password for the current or specified Juju user.

   **Options:**

   _-c, --controller (= "")_

   Controller to operate in

   _--reset  (= false)_

   Reset user password

   
   **Details:**


   The user is, by default, the current user. The latter can be confirmed with
   the `juju show-user` command.

   If no controller is specified, the current controller will be used.

   A controller administrator can change the password for another user 
   by providing desired username as an argument. 
   A controller administrator can also reset the password with a --reset option. 
   This will invalidate any passwords that were previously set 
   and registration strings that were previously issued for a user.

   This option will issue a new registration string to be used with
   `juju register`.  

   **Examples:**

       juju change-user-password
       juju change-user-password bob
       juju change-user-password bob --reset
       juju change-user-password -c another-known-controller
       juju change-user-password bob --controller another-known-controller



   **See also:**

   [add-user](#add-user) , 
   [register](#register)  



^# charm

   **Usage:** ` juju charm [flags] <command> ...`

   **Summary:**

   DEPRECATED: Interact with charms.

   **Options:**

   _--description  (= false)_

   Show short description of plugin, if any

   _-h, --help  (= false)_

   Show help on a command or other topic.

   
   **Details:**


   This command is DEPRECATED since Juju 2.3.x. Use the `charm-resources`
   command instead. `juju charm` is the Juju CLI equivalent of the `charm`
   command used by charm authors, though only applicable functionality is
   mirrored. The `charm` command is available via Charm Tools.

   Sub-commands:

      help           - Show help on a command or other topic.
      list-resources - Alias for 'resources'.
      resources      - DEPRECATED: Display the resources for a charm in the Charm Store.


^# charm-resources

   **Usage:** ` juju charm-resources [options] <charm>`

   **Summary:**

   Display the resources for a charm in the charm store.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--channel (= "stable")_

   the charmstore channel of the charm

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command will report the resources for a charm in the charm store.
   <charm> can be a charm URL, or an unambiguously condensed form of it,
   just like the deploy command. So the following forms will be accepted:
   For cs:trusty/mysql
           mysql
           trusty/mysql
   
   For cs:~user/trusty/mysql
           cs:~user/mysql
   
   Where the series is not supplied, the series from your local host is used.
   Thus the above examples imply that the local series is trusty.


   **Aliases:**

   `list-charm-resources`



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


   Output includes fundamental properties for each cloud known to the
   current Juju client: name, number of regions, default region, type,
   and description.

   The default output shows public clouds known to Juju out of the box.

   These may change between Juju versions. In addition to these public
   clouds, the 'localhost' cloud (local LXD) is also listed.

   This command's default output format is 'tabular'.

   Cloud metadata sometimes changes, e.g. AWS adds a new region. Use the
   `update-clouds` command to update the current Juju client accordingly.
   Use the `add-cloud` command to add a private cloud to the list of
   clouds known to the current Juju client.

   Use the `regions` command to list a cloud's regions. Use the
   `show-cloud` command to get more detail, such as regions and endpoints.
   Further reading: https://docs.jujucharms.com/stable/clouds

   **Examples:**

       juju clouds
       juju clouds --format yaml



   **See also:**

   [add-cloud](#add-cloud) , 
   [regions](#regions) , 
   [show-cloud](#show-cloud) , 
   [update-clouds](#update-clouds)  

   **Aliases:**

   `list-clouds`



^# collect-metrics

   **Usage:** ` juju collect-metrics [options] [application or unit]`

   **Summary:**

   Collect metrics on the given unit/application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Trigger metrics collection
   This command waits for the metric collection to finish before returning.
   You may abort this command and it will continue to run asynchronously.
   Results may be checked by 'juju show-action-status'.




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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   When only one configuration value is desired, the command will ignore --format
   option and will output the value unformatted. This is provided to support 
   scripts where the output of "juju config <application name> <setting name>" 
   can be used as an input to an expression or a function.


   **Examples:**

       juju config apache2
       juju config --format=json apache2
       juju config mysql dataset-size
       juju config mysql --reset dataset-size,backup_dir
       juju config apache2 --file path/to/config.yaml
       juju config mysql dataset-size=80% backup_dir=/vol1/mysql/backups
       juju config apache2 --model mymodel --file /home/ubuntu/mysql.yaml



   **See also:**

   [deploy](#deploy) , 
   [status](#status)  



^# consume

   **Usage:** ` juju consume [options] <remote offer path> [<local application name>]`

   **Summary:**

   Add a remote offer to the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Adds a remote offer to the model. Relations can be created later using "juju relate".
   The remote offer is identified by providing a path to the offer:

             [<model owner>/]<model name>.<application name>
                 for an application in another model in this controller (if owner isn't specified it's assumed to be the logged-in user)

   **Examples:**

       $ juju consume othermodel.mysql
       $ juju consume owner/othermodel.mysql
       $ juju consume anothercontroller:owner/othermodel.mysql



   **See also:**

   [add-relation](#add-relation) , 
   [offer](#offer)  



^# controller-config

   **Usage:** ` juju controller-config [options] [<attribute key>[=<value>] ...]`

   **Summary:**

   Displays or sets configuration settings for a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   By default, all configuration (keys and values) for the controller are
   displayed if a key is not specified. Supplying one key name returns
   only the value for that key.

   Supplying key=value will set the supplied key to the supplied value;
   this can be repeated for multiple keys. You can also specify a yaml
   file containing key values. Not all keys can be updated after
   bootstrap time.

   Available keys and values can be found here:

   https://jujucharms.com/stable/controllers-config

   **Examples:**

       juju controller-config
       juju controller-config api-port
       juju controller-config -c mycontroller
       juju controller-config auditing-enabled=true audit-log-max-backups=5
       juju controller-config auditing-enabled=true path/to/file.yaml
       juju controller-config path/to/file.yaml



   **See also:**

   [controllers](#controllers) , 
   [model-config](#model-config) , 
   [show-cloud](#show-cloud)  



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

   [models](#models) , 
   [show-controller](#show-controller)  

   **Aliases:**

   `list-controllers`



^# create-backup

   **Usage:** ` juju create-backup [options] [<notes>]`

   **Summary:**

   Create a backup.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--filename (= "juju-backup-&lt;date>-&lt;time>.tar.gz")_

   Download to this file

   _--keep-copy  (= false)_

   Keep a copy of the archive on the controller

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-download  (= false)_

   Do not download the archive, implies keep-copy

   
   **Details:**


   This command requests that Juju creates a backup of its state and prints the
   backup's unique ID.  You may provide a note to associate with the backup.
   By default, the backup archive and associated metadata are downloaded 
   without keeping a copy remotely on the controller.

   Use --no-download to avoid getting a local copy of the backup downloaded 
   at the end of the backup process.

   Use --keep-copy option to store a copy of backup remotely on the controller.
   Use --verbose to see extra information about backup.

   To access remote backups stored on the controller, see 'juju download-backup'.

   **Examples:**

       juju create-backup 
       juju create-backup --no-download
       juju create-backup --no-download --keep-copy=false // ignores --keep-copy
       juju create-backup --keep-copy
       juju create-backup --verbose



   **See also:**

   [backups](#backups) , 
   [download-backup](#download-backup)  



^# create-storage-pool

   **Usage:** ` juju create-storage-pool [options] <name> <provider> [<key>=<value> [<key>=<value>...]]`

   **Summary:**

   Create or define a storage pool.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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




^# create-wallet

   **Usage:** ` juju create-wallet [options]`

   **Summary:**

   Create a new wallet.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Create a new wallet with monthly limit.


   **Examples:**

   Creates a wallet named 'qa' with a limit of 42.

       juju create-wallet qa 42





^# credentials

   **Usage:** ` juju credentials [options] [<cloud name>]`

   **Summary:**

   Lists locally stored credentials for a cloud.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-secrets  (= false)_

   Show secrets

   
   **Details:**


   Locally stored credentials are used with `juju bootstrap`  
   and `juju add-model`.

   An arbitrary "credential name" is used to represent credentials, which are 
   added either via `juju add-credential` or `juju autoload-credentials`.
   Note that there can be multiple sets of credentials and, thus, multiple 
   names.

   Actual authentication material is exposed with the '--show-secrets' 
   option.

   A controller, and subsequently created models, can be created with a 
   different set of credentials but any action taken within the model (e.g.:
   `juju deploy`; `juju add-unit`) applies the credentail used 
   to create that model. This model credential is stored on the controller. 
   A credential for 'controller' model is determined at bootstrap time and
   will be stored on the controller. It is considered to be controller default.
   Recall that when a controller is created a 'default' model is also 
   created. This model will use the controller default credential. To see all your
   credentials on the controller use "juju show-credentials" command.

   When adding a new model, Juju will reuse the controller default credential.
   To add a model that uses a different credential, specify a locally
   stored credential using --credential option. See `juju help add-model` 
   for more information.

   Credentials denoted with an asterisk '*' are currently set as the local default
   for the given cloud.


   **Examples:**

       juju credentials
       juju credentials aws
       juju credentials --format yaml --show-secrets



   **See also:**

   [add-credential](#add-credential) , 
   [remove-credential](#remove-credential) , 
   [set-default-credential](#set-default-credential) , 
   [autoload-credentials](#autoload-credentials) , 
   [show-credentials](#show-credentials)  

   **Aliases:**

   `list-credentials`



^# debug-hooks

   **Usage:** ` juju debug-hooks [options] <unit name> [hook or action names]`

   **Summary:**

   Launch a tmux session to debug hooks and/or actions.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-host-key-checks  (= false)_

   Skip host key checking (INSECURE)

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= &lt;auto>)_

   Enable pseudo-tty allocation

   
   **Details:**


   Interactively debug hooks or actions remotely on an application unit.

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   The '--include' and '--exclude' options filter by entity. The entity can be
   a machine, unit, or application.

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

   [status](#status) , 
   [ssh](#ssh)  



^# deploy

   **Usage:** ` juju deploy [options] <charm or bundle> [<application name>]`

   **Summary:**

   Deploys a new application or bundle.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--attach-storage  (= )_

   Existing storage to attach to the deployed unit (not available on kubernetes models)

   _--bind (= "")_

   Configure application endpoint bindings to spaces

   _--channel (= "")_

   Channel to use when getting the charm or bundle from the charm store

   _--config  (= )_

   Either a path to yaml-formatted application config file or a key=value pair

   _--constraints (= "")_

   Set application constraints

   _--device  (= )_

   Charm device constraints

   _--dry-run  (= false)_

   Just show what the bundle deploy would do

   _--force  (= false)_

   Allow a charm to be deployed which bypasses checks such as supported series or LXD profile allow list

   _--increase-budget  (= 0)_

   increase model budget allocation by this amount

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--map-machines (= "")_

   Specify the existing machines to use for bundle deployments

   _-n, --num-units  (= 1)_

   Number of application units to deploy for principal charms

   _--overlay  (= )_

   Bundles to overlay on the primary bundle, applied in order

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

   _--trust  (= false)_

   Allows charm to run hooks that require access credentials

   
   **Details:**


   A charm can be referred to by its simple name and a series can optionally be
   specified:

           juju deploy postgresql
           juju deploy xenial/postgresql
           juju deploy cs:postgresql
           juju deploy cs:xenial/postgresql
           juju deploy postgresql --series xenial
   
   All the above deployments use remote charms found in the Charm Store (denoted
   by 'cs') and therefore also make use of "charm URLs".

   A versioned charm URL will be expanded as expected. For example, 'mysql-56'
   becomes 'cs:xenial/mysql-56'.

   A local charm may be deployed by giving the path to its directory:

           juju deploy /path/to/charm
           juju deploy /path/to/charm --series xenial
   
   You will need to be explicit if there is an ambiguity between a local and a
   remote charm:

           juju deploy ./pig
           juju deploy cs:pig
   
   An error is emitted if the determined series is not supported by the charm. Use
   the '--force' option to override this check:

           juju deploy charm --series xenial --force
   
   A bundle can be expressed similarly to a charm, but not by series:
           juju deploy mediawiki-single
           juju deploy bundle/mediawiki-single
           juju deploy cs:bundle/mediawiki-single
   
   A local bundle may be deployed by specifying the path to its YAML file:
           juju deploy /path/to/bundle.yaml
   
   The final charm/machine series is determined using an order of precedence (most
   preferred to least):

          - the '--series' command option
          - the series stated in the charm URL
          - for a bundle, the series stated in each charm URL (in the bundle file)
          - for a bundle, the series given at the top level (in the bundle file)
          - the 'default-series' model key
          - the top-most series specified in the charm's metadata file
            (this sets the charm's 'preferred series' in the Charm Store)
   
   An 'application name' provides an alternate name for the application. It works
   only for charms; it is silently ignored for bundles (although the same can be
   done at the bundle file level). Such a name must consist only of lower-case
   letters (a-z), numbers (0-9), and single hyphens (-). The name must begin with
   a letter and not have a group of all numbers follow a hyphen:

           Valid:   myappname, custom-app, app2-scat-23skidoo
           Invalid: myAppName, custom--app, app2-scat-23, areacode-555-info
   
   Use the '--constraints' option to specify hardware requirements for new machines.
   These become the application's default constraints (i.e. they are used if the
   application is later scaled out with the `add-unit` command). To overcome this
   behaviour use the `set-constraints` command to change the application's default
   constraints or add a machine (`add-machine`) with a certain constraint and then
   target that machine with `add-unit` by using the '--to' option.

   Use the '--device' option to specify GPU device requirements (with Kubernetes).
   The below format is used for this option's value, where the 'label' is named in
   the charm metadata file:

           <label>=[<count>,]<device-class>|<vendor/type>[,<attributes>]
   
   Use the '--config' option to specify application configuration values. This
   option accepts either a path to a YAML-formatted file or a key=value pair. A
   file should be of this format:

   ```
   <charm name>:
     <option name>: <option value>
     ...
   ```

   For example, to deploy 'mediawiki' with file 'mycfg.yaml' that contains:

   ```
   mediawiki:
     name: my media wiki
     admins: me:pwdOne
     debug: true
   ```

   use

           juju deploy mediawiki --config mycfg.yaml
   
   Key=value pairs can also be passed directly in the command. For example, to
   declare the 'name' key:

           juju deploy mediawiki --config name='my media wiki'
   
   To define multiple keys:

           juju deploy mediawiki --config name='my media wiki' --config debug=true
   
   If a key gets defined multiple times the last value will override any earlier
   values. For example,

           juju deploy mediawiki --config name='my media wiki' --config mycfg.yaml
   
   if mycfg.yaml contains a value for 'name', it will override the earlier 'my
   media wiki' value. The same applies to single value options. For example,

           juju deploy mediawiki --config name='a media wiki' --config name='my wiki'
   
   the value of 'my wiki' will be used.

   Use the '--resource' option to upload resources needed by the charm. This
   option may be repeated if multiple resources are needed:

           juju deploy foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml
   
   Where 'bar' and 'baz' are named in the metadata file for charm 'foo'.
   Use the '--to' option to deploy to an existing machine or container by
   specifying a "placement directive". The `status` command should be used for
   guidance on how to refer to machines. A few placement directives are
   provider-dependent (e.g.: 'zone').

   In more complex scenarios, "network spaces" are used to partition the cloud
   networking layer into sets of subnets. Instances hosting units inside the same
   space can communicate with each other without any firewalls. Traffic crossing
   space boundaries could be subject to firewall and access restrictions. Using
   spaces as deployment targets, rather than their individual subnets, allows Juju
   to perform automatic distribution of units across availability zones to support
   high availability for applications. Spaces help isolate applications and their
   units, both for security purposes and to manage both traffic segregation and
   congestion.

   When deploying an application or adding machines, the 'spaces' constraint can
   be used to define a comma-delimited list of required and forbidden spaces (the
   latter prefixed with '^', similar to the 'tags' constraint).

   When deploying bundles, machines specified in the bundle are added to the model
   as new machines. Use the '--map-machines=existing' option to make use of any
   existing machines. To map particular existing machines to machines defined in
   the bundle, multiple comma separated values of the form 'bundle-id=existing-id'
   can be passed. For example, for a bundle that specifies machines 1, 2, and 3;
   and a model that has existing machines 1, 2, 3, and 4, the below deployment
   would have existing machines 1 and 2 assigned to machines 1 and 2 defined in
   the bundle and have existing machine 4 assigned to machine 3 defined in the
   bundle.

           juju deploy mybundle --map-machines=existing,3=4
   
   Only top level machines can be mapped in this way, just as only top level
   machines can be defined in the machines section of the bundle.

   When charms that include LXD profiles are deployed the profiles are validated
   for security purposes by allowing only certain configurations and devices. Use
   the '--force' option to bypass this check. Doing so is not recommended as it
   can lead to unexpected behaviour.

   Further reading: https://docs.jujucharms.com/stable/charms-deploying

   **Examples:**

   Deploy to a new machine:

       juju deploy apache2

   Deploy to machine 23:

       juju deploy mysql --to 23

   Deploy to a new LXD container on a new machine:

       juju deploy mysql --to lxd

   Deploy to a new LXD container on machine 25:

       juju deploy mysql --to lxd:25

   Deploy to LXD container 3 on machine 24:

       juju deploy mysql --to 24/lxd/3

   Deploy 2 units, one on machine 3 and one to a new LXD container on machine 5:

       juju deploy mysql -n 2 --to 3,lxd:5

   Deploy 3 units, one on machine 3 and the remaining two on new machines:

       juju deploy mysql -n 3 --to 3

   Deploy to a machine with at least 8 GiB of memory:

       juju deploy postgresql --constraints mem=8G

   Deploy to a specific availability zone (provider-dependent):

       juju deploy mysql --to zone=us-east-1a

   Deploy to a specific MAAS node:

       juju deploy mysql --to host.maas

   Deploy to a machine that is in the 'dmz' network space but not in either the
   'cms' nor the 'database' spaces:

       juju deploy haproxy -n 2 --constraints spaces=dmz,^cms,^database

   Deploy a Kubernetes charm that requires a single Nvidia GPU:

       juju deploy mycharm --device miner=1,nvidia.com/gpu

   Deploy a Kubernetes charm that requires two Nvidia GPUs that have an
   attribute of 'gpu=nvidia-tesla-p100':

       juju deploy mycharm --device \
          twingpu=2,nvidia.com/gpu,gpu=nvidia-tesla-p100



   **See also:**

   [add-relation](#add-relation) , 
   [add-unit](#add-unit) , 
   [config](#config) , 
   [expose](#expose) , 
   [get-constraints](#get-constraints) , 
   [set-constraints](#set-constraints) , 
   [spaces](#spaces)  



^# destroy-controller

   **Usage:** ` juju destroy-controller [options] <controller name>`

   **Summary:**

   Destroys a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--destroy-all-models  (= false)_

   Destroy all hosted models in the controller

   _--destroy-storage  (= false)_

   Destroy all storage instances managed by the controller

   _--release-storage  (= false)_

   Release all storage instances from management of the controller, without destroying them

   _-y, --yes  (= false)_

   Do not ask for confirmation

   
   **Details:**


   All models (initial model plus all workload/hosted) associated with the
   controller will first need to be destroyed, either in advance, or by
   specifying `--destroy-all-models`.

   If there is persistent storage in any of the models managed by the
   controller, then you must choose to either destroy or release the
   storage, using `--destroy-storage` or `--release-storage` respectively.

   **Examples:**

   Destroy the controller and all hosted models. If there is
   persistent storage remaining in any of the models, then
   this will prompt you to choose to either destroy or release
   the storage.

       juju destroy-controller --destroy-all-models mycontroller

   Destroy the controller and all hosted models, destroying
   any remaining persistent storage.

       juju destroy-controller --destroy-all-models --destroy-storage

   Destroy the controller and all hosted models, releasing
   any remaining persistent storage from Juju's control.

       juju destroy-controller --destroy-all-models --release-storage



   **See also:**

   [kill-controller](#kill-controller) , 
   [unregister](#unregister)  



^# destroy-model

   **Usage:** ` juju destroy-model [options] [<controller name>:]<model name>`

   **Summary:**

   Terminate all machines/containers and resources for a non-controller model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--destroy-storage  (= false)_

   Destroy all storage instances in the model

   _--release-storage  (= false)_

   Release all storage instances from the model, and management of the controller, without destroying them

   _-t, --timeout  (= 30m0s)_

   Timeout before model destruction is aborted

   _-y, --yes  (= false)_

   Do not prompt for confirmation

   
   **Details:**


   Destroys the specified model. This will result in the non-recoverable
   removal of all the units operating in the model and any resources stored
   there. Due to the irreversible nature of the command, it will prompt for
   confirmation (unless overridden with the '-y' option) before taking any
   action.

   If there is persistent storage in any of the models managed by the
   controller, then you must choose to either destroy or release the
   storage, using --destroy-storage or --release-storage respectively.


   **Examples:**

       juju destroy-model test
       juju destroy-model -y mymodel
       juju destroy-model -y mymodel --destroy-storage
       juju destroy-model -y mymodel --release-storage



   **See also:**

   [destroy-controller](#destroy-controller)  



^# detach-storage

   **Usage:** ` juju detach-storage [options] <storage> [<storage> ...]`

   **Summary:**

   Detaches storage from units.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Detaches storage from units. Specify one or more unit/application storage IDs,
   as output by "juju storage". The storage will remain in the model until it is
   removed by an operator.


   **Examples:**

       juju detach-storage pgdata/0





^# diff-bundle

   **Usage:** ` juju diff-bundle [options] <bundle file or name>`

   **Summary:**

   Compares a bundle with a model and reports any differences.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--annotations  (= false)_

   Include differences in annotations

   _--channel (= "")_

   Channel to use when getting the bundle from the charm store

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--map-machines (= "")_

   Indicates how existing machines correspond to bundle machines

   _--overlay  (= )_

   Bundles to overlay on the primary bundle, applied in order

   
   **Details:**


   Bundle can be a local bundle file or the name of a bundle in
   the charm store. The bundle can also be combined with overlays (in the
   same way as the deploy command) before comparing with the model.

   The map-machines option works similarly as for the deploy command, but
   existing is always assumed, so it doesn't need to be specified.


   **Examples:**

       juju diff-bundle localbundle.yaml
       juju diff-bundle canonical-kubernetes
       juju diff-bundle -m othermodel hadoop-spark
       juju diff-bundle mongodb-cluster --channel beta
       juju diff-bundle canonical-kubernetes --overlay local-config.yaml --overlay extra.yaml
       juju diff-bundle localbundle.yaml --map-machines 3=4



   **See also:**

   [deploy](#deploy)  



^# disable-command

   **Usage:** ` juju disable-command [options] <command set> [message...]`

   **Summary:**

   Disable commands for the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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
             config
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             model-config
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-constraints
             sync-agents
             unexpose
             upgrade-charm
             upgrade-model
   
   	

   **Examples:**

   To prevent the model from being destroyed:

       juju disable-command destroy-model "Check with SA before destruction."

   To prevent the machines, applications, units and relations from being removed:

       juju disable-command remove-object

   To prevent changes to the model:

       juju disable-command all "Model locked down"



   **See also:**

   [disabled-commands](#disabled-commands) , 
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

   [users](#users) , 
   [enable-user](#enable-user) , 
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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
             config
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             model-config
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-constraints
             sync-agents
             unexpose
             upgrade-charm
             upgrade-model
   
   	

   **See also:**

   [disable-command](#disable-command) , 
   [enable-command](#enable-command)  

   **Aliases:**

   `list-disabled-commands`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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
             config
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             model-config
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-constraints
             sync-agents
             unexpose
             upgrade-charm
             upgrade-model
   
   	

   **Examples:**

   To allow the model to be destroyed:

       juju enable-command destroy-model

   To allow the machines, applications, units and relations to be removed:

       juju enable-command remove-object

   To allow changes to the model:

       juju enable-command all



   **See also:**

   [disable-command](#disable-command) , 
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

   [disable-command](#disable-command) , 
   [disabled-commands](#disabled-commands) , 
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

   Ensure that the controller is still in highly available mode. If
   there is only 1 controller running, this will ensure there
   are 3 running. If you have previously requested more than 3,
   then that number will be ensured.

       juju enable-ha

   Ensure that 5 controllers are available.

       juju enable-ha -n 5 

   Ensure that 7 controllers are available, with newly created
   controller machines having at least 8GB RAM.

       juju enable-ha -n 7 --constraints mem=8G

   Ensure that 7 controllers are available, with machines server1 and
   server2 used first, and if necessary, newly created controller
   machines having at least 8GB RAM.

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

   [users](#users) , 
   [disable-user](#disable-user) , 
   [login](#login)  



^# export-bundle

   **Usage:** ` juju export-bundle [options]`

   **Summary:**

   Exports the current model configuration as a reusable bundle.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--filename (= "")_

   Bundle file

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Exports the current model configuration as a reusable bundle.

   If --filename is not used, the configuration is printed to stdout.

          --filename specifies an output file.


   **Examples:**

       juju export-bundle
   	juju export-bundle --filename mymodel.yaml





^# expose

   **Usage:** ` juju expose [options] <application name>`

   **Summary:**

   Makes an application publicly available over the network.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Adjusts the firewall rules and any relevant security mechanisms of the
   cloud to allow public access to the application.


   **Examples:**

       juju expose wordpress



   **See also:**

   [unexpose](#unexpose)  



^# find-offers

   **Usage:** ` juju find-offers [options]`

   **Summary:**

   Find offered application endpoints.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _--interface (= "")_

   return results matching the interface name

   _-o, --output (= "")_

   Specify an output file

   _--offer (= "")_

   return results matching the offer name

   _--url (= "")_

   return results matching the offer URL

   
   **Details:**


   Find which offered application endpoints are available to the current user.
   This command is aimed for a user who wants to discover what endpoints are available to them.

   **Examples:**

      $ juju find-offers
      $ juju find-offers mycontroller:

      $ juju find-offers fred/prod
      $ juju find-offers --interface mysql
      $ juju find-offers --url fred/prod.db2
      $ juju find-offers --offer db2
      



   **See also:**

   [show-offer](#show-offer)  



^# firewall-rules

   **Usage:** ` juju list-firewall-rules [options]`

   **Summary:**

   Prints the firewall rules.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Lists the firewall rules which control ingress to well known services
   within a Juju model.


   **Examples:**

       juju list-firewall-rules
       juju firewall-rules



   **See also:**

   [set-firewall-rule](#set-firewall-rule)  

   **Aliases:**

   `firewall-rules`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   [set-constraints](#set-constraints) , 
   [get-model-constraints](#get-model-constraints) , 
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   [models](#models) , 
   [get-constraints](#get-constraints) , 
   [set-constraints](#set-constraints) , 
   [set-model-constraints](#set-model-constraints)  



^# grant

   **Usage:** ` juju grant [options] <user name> <permission> [<model name> ... | <offer url> ...]`

   **Summary:**

   Grants access level to a Juju user for a model, controller, or application offer.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   By default, the controller is the current controller.

   Users with read access are limited in what they can do with models:

   `juju models`, `juju machines`, and `juju status`
   Valid access levels for models are:

             read
             write
             admin
   
   Valid access levels for controllers are:

             login
             superuser
   
   Valid access levels for application offers are:

             read
             consume
             admin

   **Examples:**

   Grant user 'joe' 'read' access to model 'mymodel':

       juju grant joe read mymodel

   Grant user 'jim' 'write' access to model 'mymodel':

       juju grant jim write mymodel

   Grant user 'sam' 'read' access to models 'model1' and 'model2':

       juju grant sam read model1 model2

   Grant user 'joe' 'read' access to application offer 'fred/prod.hosted-mysql':

       juju grant joe read fred/prod.hosted-mysql

   Grant user 'jim' 'consume' access to application offer 'fred/prod.hosted-mysql':

       juju grant jim consume fred/prod.hosted-mysql

   Grant user 'sam' 'read' access to application offers 'fred/prod.hosted-mysql' and 'mary/test.hosted-mysql':

       juju grant sam read fred/prod.hosted-mysql mary/test.hosted-mysql



   **See also:**

   [revoke](#revoke) , 
   [add-user](#add-user)  



^# grant-cloud

   **Usage:** ` juju grant-cloud [options] <user name> <permission> <cloud name> ...`

   **Summary:**

   Grants access level to a Juju user for a cloud.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Valid access levels are:

             add-model
             admin

   **Examples:**

   Grant user 'joe' 'add-model' access to cloud 'fluffy':

       juju grant-cloud joe add-model fluffy



   **See also:**

   [revoke-cloud](#revoke-cloud) , 
   [add-user](#add-user)  



^# gui

   **Usage:** ` juju gui [options]`

   **Summary:**

   Print the Juju GUI URL, or open the Juju GUI in the default browser.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--browser  (= false)_

   Open the web browser, instead of just printing the Juju GUI URL

   _--hide-credential  (= false)_

   Do not show admin credential to use for logging into the Juju GUI

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-browser  (= true)_

   DEPRECATED. --no-browser is now the default. Use --browser to open the web browser

   _--show-credentials  (= true)_

   DEPRECATED. Show admin credential to use for logging into the Juju GUI

   
   **Details:**


   Print the Juju GUI URL and show admin credential to use to log into it:
   	juju gui
   Print the Juju GUI URL only:

   	juju gui --hide-credential
   Open the Juju GUI in the default browser and show admin credential to use to log into it:
   	juju gui --browser
   Open the Juju GUI in the default browser without printing the login credential:
   	juju gui --hide-credential --browser
   An error is returned if the Juju GUI is not available in the controller.



^# help

   **Usage:** ` juju help [topic]`

   **Summary:**

   Show help on a command or other topic.


   
   **Details:**


   See also: topics



^# help-tool

   **Usage:** ` juju hook-tool [tool]`

   **Summary:**

   Show help on a Juju charm hook tool.


   
   **Details:**


   Juju charms can access a series of built-in helpers called 'hook-tools'.
   These are useful for the charm to be able to inspect its running environment.
   Currently available charm hook tools are:

             action-fail              set action fail status with message
             action-get               get action parameters
             action-set               set action results
             add-metric               add metrics
             application-version-set  specify which version of the application is deployed
             close-port               ensure a port or range is always closed
             config-get               print application configuration
             credential-get           access cloud credentials
             goal-state               print the status of the charm's peers and related units
             is-leader                print application leadership status
             juju-log                 write a message to the juju log
             juju-reboot              Reboot the host machine
             leader-get               print application leadership settings
             leader-set               write application leadership settings
             network-get              get network config
             open-port                register a port or range to open
             opened-ports             lists all ports or ranges opened by the unit
             pod-spec-set             set pod spec information
             relation-get             get relation settings
             relation-ids             list all relation ids with the given relation name
             relation-list            list relation units
             relation-set             set relation settings
             status-get               print status information
             status-set               set status information
             storage-add              add storage instances
             storage-get              print information for storage instance with specified id
             storage-list             list storage attached to the unit
             unit-get                 print public-address or private-address

   **Examples:**

       For help on a specific tool, supply the name of that tool, for example:

           juju hook-tool unit-get



   **Aliases:**

   `help-tool,`

   `hook-tools`



^# hook-tool

   **Usage:** ` juju hook-tool [tool]`

   **Summary:**

   Show help on a Juju charm hook tool.


   
   **Details:**


   Juju charms can access a series of built-in helpers called 'hook-tools'.
   These are useful for the charm to be able to inspect its running environment.
   Currently available charm hook tools are:

             action-fail              set action fail status with message
             action-get               get action parameters
             action-set               set action results
             add-metric               add metrics
             application-version-set  specify which version of the application is deployed
             close-port               ensure a port or range is always closed
             config-get               print application configuration
             credential-get           access cloud credentials
             goal-state               print the status of the charm's peers and related units
             is-leader                print application leadership status
             juju-log                 write a message to the juju log
             juju-reboot              Reboot the host machine
             leader-get               print application leadership settings
             leader-set               write application leadership settings
             network-get              get network config
             open-port                register a port or range to open
             opened-ports             lists all ports or ranges opened by the unit
             pod-spec-set             set pod spec information
             relation-get             get relation settings
             relation-ids             list all relation ids with the given relation name
             relation-list            list relation units
             relation-set             set relation settings
             status-get               print status information
             status-set               set status information
             storage-add              add storage instances
             storage-get              print information for storage instance with specified id
             storage-list             list storage attached to the unit
             unit-get                 print public-address or private-address

   **Examples:**

       For help on a specific tool, supply the name of that tool, for example:

           juju hook-tool unit-get



   **Aliases:**

   `help-tool,`

   `hook-tools`



^# hook-tools

   **Usage:** ` juju hook-tool [tool]`

   **Summary:**

   Show help on a Juju charm hook tool.


   
   **Details:**


   Juju charms can access a series of built-in helpers called 'hook-tools'.
   These are useful for the charm to be able to inspect its running environment.
   Currently available charm hook tools are:

             action-fail              set action fail status with message
             action-get               get action parameters
             action-set               set action results
             add-metric               add metrics
             application-version-set  specify which version of the application is deployed
             close-port               ensure a port or range is always closed
             config-get               print application configuration
             credential-get           access cloud credentials
             goal-state               print the status of the charm's peers and related units
             is-leader                print application leadership status
             juju-log                 write a message to the juju log
             juju-reboot              Reboot the host machine
             leader-get               print application leadership settings
             leader-set               write application leadership settings
             network-get              get network config
             open-port                register a port or range to open
             opened-ports             lists all ports or ranges opened by the unit
             pod-spec-set             set pod spec information
             relation-get             get relation settings
             relation-ids             list all relation ids with the given relation name
             relation-list            list relation units
             relation-set             set relation settings
             status-get               print status information
             status-set               set status information
             storage-add              add storage instances
             storage-get              print information for storage instance with specified id
             storage-list             list storage attached to the unit
             unit-get                 print public-address or private-address

   **Examples:**

       For help on a specific tool, supply the name of that tool, for example:

           juju hook-tool unit-get



   **Aliases:**

   `help-tool,`

   `hook-tools`



^# import-filesystem

   **Usage:** ` juju import-filesystem [options] <storage-provider> <provider-id> <storage-name>

   **Summary:**

   Imports a filesystem into the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Import an existing filesystem into the model. This will lead to the model
   taking ownership of the storage, so you must take care not to import storage
   that is in use by another Juju model.

   To import a filesystem, you must specify three things:

   - the storage provider that manages the storage, and with which the storage
     will be associated
   - the storage provider ID for the filesystem, or volume that backs the
     filesystem
   - the storage name to assign to the filesystem, corresponding to the storage
     name used by a charm
   
   Once a filesystem is imported, Juju will create an associated storage
   instance using the given storage name.


   **Examples:**

   Import an existing filesystem backed by an EBS volume, and assign it the
   "pgdata" storage name. Juju will associate a storage instance ID like
   "pgdata/0" with the volume and filesystem contained within:

       juju import-filesystem ebs vol-123456 pgdata



^# import-ssh-key

   **Usage:** ` juju import-ssh-key [options] <lp|gh>:<user identity> ...`

   **Summary:**

   Adds a public SSH key from a trusted identity source to a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   [add-ssh-key](#add-ssh-key) , 
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

   [destroy-controller](#destroy-controller) , 
   [unregister](#unregister)  



^# list-actions

   **Usage:** ` juju actions [options] <application name>`

   **Summary:**

   List actions defined for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= default)_

   Specify output format (default|json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--schema  (= false)_

   Display the full action schema

   
   **Details:**


   List the actions available to run on the target application, with a short
   description.  To show the full schema for the actions, use --schema.

   For more information, see also the 'run-action' command, which executes actions.

   **Aliases:**

   `list-actions`



^# list-agreements

   **Usage:** ` juju agreements [options]`

   **Summary:**

   List user's agreements.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Charms may require a user to accept its terms in order for it to be deployed.
   In other words, some applications may only be installed if a user agrees to 
   accept some terms defined by the charm. 
   This command lists the terms that the user has agreed to.


   **See also:**

   [agree](#agree)  

   **Aliases:**

   `list-agreements`



^# list-backups

   **Usage:** ` juju backups [options]`

   **Summary:**

   Displays information about all backups.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   backups provides the metadata associated with all backups.


   **Aliases:**

   `list-backups`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   List all cached images.

     juju cached-images

   List cached images for xenial.

     juju cached-images --series xenial

   List all cached lxd images for xenial amd64.

     juju cached-images --kind lxd --series xenial --arch amd64



   **Aliases:**

   `list-cached-images`



^# list-charm-resources

   **Usage:** ` juju charm-resources [options] <charm>`

   **Summary:**

   Display the resources for a charm in the charm store.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--channel (= "stable")_

   the charmstore channel of the charm

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command will report the resources for a charm in the charm store.
   <charm> can be a charm URL, or an unambiguously condensed form of it,
   just like the deploy command. So the following forms will be accepted:
   For cs:trusty/mysql
           mysql
           trusty/mysql
   
   For cs:~user/trusty/mysql
           cs:~user/mysql
   
   Where the series is not supplied, the series from your local host is used.
   Thus the above examples imply that the local series is trusty.


   **Aliases:**

   `list-charm-resources`



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


   Output includes fundamental properties for each cloud known to the
   current Juju client: name, number of regions, default region, type,
   and description.

   The default output shows public clouds known to Juju out of the box.

   These may change between Juju versions. In addition to these public
   clouds, the 'localhost' cloud (local LXD) is also listed.

   This command's default output format is 'tabular'.

   Cloud metadata sometimes changes, e.g. AWS adds a new region. Use the
   `update-clouds` command to update the current Juju client accordingly.
   Use the `add-cloud` command to add a private cloud to the list of
   clouds known to the current Juju client.

   Use the `regions` command to list a cloud's regions. Use the
   `show-cloud` command to get more detail, such as regions and endpoints.
   Further reading: https://docs.jujucharms.com/stable/clouds

   **Examples:**

       juju clouds
       juju clouds --format yaml



   **See also:**

   [add-cloud](#add-cloud) , 
   [regions](#regions) , 
   [show-cloud](#show-cloud) , 
   [update-clouds](#update-clouds)  

   **Aliases:**

   `list-clouds`



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

   [models](#models) , 
   [show-controller](#show-controller)  

   **Aliases:**

   `list-controllers`



^# list-credentials

   **Usage:** ` juju credentials [options] [<cloud name>]`

   **Summary:**

   Lists locally stored credentials for a cloud.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-secrets  (= false)_

   Show secrets

   
   **Details:**


   Locally stored credentials are used with `juju bootstrap`  
   and `juju add-model`.

   An arbitrary "credential name" is used to represent credentials, which are 
   added either via `juju add-credential` or `juju autoload-credentials`.
   Note that there can be multiple sets of credentials and, thus, multiple 
   names.

   Actual authentication material is exposed with the '--show-secrets' 
   option.

   A controller, and subsequently created models, can be created with a 
   different set of credentials but any action taken within the model (e.g.:
   `juju deploy`; `juju add-unit`) applies the credentail used 
   to create that model. This model credential is stored on the controller. 
   A credential for 'controller' model is determined at bootstrap time and
   will be stored on the controller. It is considered to be controller default.
   Recall that when a controller is created a 'default' model is also 
   created. This model will use the controller default credential. To see all your
   credentials on the controller use "juju show-credentials" command.

   When adding a new model, Juju will reuse the controller default credential.
   To add a model that uses a different credential, specify a locally
   stored credential using --credential option. See `juju help add-model` 
   for more information.

   Credentials denoted with an asterisk '*' are currently set as the local default
   for the given cloud.


   **Examples:**

       juju credentials
       juju credentials aws
       juju credentials --format yaml --show-secrets



   **See also:**

   [add-credential](#add-credential) , 
   [remove-credential](#remove-credential) , 
   [set-default-credential](#set-default-credential) , 
   [autoload-credentials](#autoload-credentials) , 
   [show-credentials](#show-credentials)  

   **Aliases:**

   `list-credentials`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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
             config
             deploy
             disable-user
             destroy-controller
             destroy-model
             enable-ha
             enable-user
             expose
             import-ssh-key
             model-config
             remove-application
             remove-machine
             remove-relation
             remove-ssh-key
             remove-unit
             resolved
             retry-provisioning
             run
             set-constraints
             sync-agents
             unexpose
             upgrade-charm
             upgrade-model
   
   	

   **See also:**

   [disable-command](#disable-command) , 
   [enable-command](#enable-command)  

   **Aliases:**

   `list-disabled-commands`



^# list-firewall-rules

   **Usage:** ` juju list-firewall-rules [options]`

   **Summary:**

   Prints the firewall rules.

   **Options:**

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Lists the firewall rules which control ingress to well known services
   within a Juju model.


   **Examples:**

       juju list-firewall-rules
       juju firewall-rules



   **See also:**

   [set-firewall-rule](#set-firewall-rule)  

   **Aliases:**

   `firewall-rules`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-machines`



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

   [add-model](#add-model) , 
   [share-model](#share-model) , 
   [unshare-model](#unshare-model)  

   **Aliases:**

   `list-models`



^# list-offers

   **Usage:** ` juju offers [options] [<offer-name>]`

   **Summary:**

   Lists shared endpoints.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--active-only  (= false)_

   only return results where the offer is in use

   _--allowed-consumer (= "")_

   return results where the user is allowed to consume the offer

   _--application (= "")_

   return results matching the application

   _--connected-user (= "")_

   return results where the user has a connection to the offer

   _--format  (= tabular)_

   Specify output format (json|summary|tabular|yaml)

   _--interface (= "")_

   return results matching the interface name

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List information about applications' endpoints that have been shared and who is connected.
   The default tabular output shows each user connected (relating to) the offer, and the 
   relation id of the relation.

   The summary output shows one row per offer, with a count of active/total relations.
   The YAML output shows additional information about the source of connections, including
   the source model UUID.

   The output can be filtered by:

          - interface: the interface name of the endpoint
          - application: the name of the offered application
          - connected user: the name of a user who has a relation to the offer
          - allowed consumer: the name of a user allowed to consume the offer
          - active only: only show offers which are in use (are related to)

   **Examples:**

       $ juju offers
       $ juju offers -m model
       $ juju offers --interface db2
       $ juju offers --application mysql
       $ juju offers --connected-user fred
       $ juju offers --allowed-consumer mary
       $ juju offers hosted-mysql
       $ juju offers hosted-mysql --active-only



   **See also:**

   [find-offers](#find-offers) , 
   [show-offer](#show-offer)  

   **Aliases:**

   `list-offers`



^# list-payloads

   **Usage:** ` juju payloads [options] [pattern ...]`

   **Summary:**

   Display status information about known payloads.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-payloads`



^# list-plans

   **Usage:** ` juju plans [options]`

   **Summary:**

   List plans.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|smart|summary|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List plans available for the specified charm.


   **Examples:**

       juju plans cs:webapp



   **Aliases:**

   `list-plans`



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

   [add-cloud](#add-cloud) , 
   [clouds](#clouds) , 
   [show-cloud](#show-cloud) , 
   [update-clouds](#update-clouds)  

   **Aliases:**

   `list-regions`



^# list-resources

   **Usage:** ` juju resources [options] <application or unit>`

   **Summary:**

   Show the resources for an application or unit.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--details  (= false)_

   show detailed information about resources used by each unit.

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command shows the resources required by and those in use by an existing
   application or unit in your model.  When run for an application, it will also show any
   updates available for resources from the charmstore.


   **Aliases:**

   `list-resources`



^# list-spaces

   **Usage:** ` juju spaces [options] [--short] [--format yaml|json] [--output <path>]`

   **Summary:**

   List known spaces, including associated subnets.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-spaces`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   `list-ssh-keys`



^# list-storage

   **Usage:** ` juju storage [options] <filesystem|volume> ...`

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--volume  (= false)_

   List volume storage

   
   **Details:**


   List information about storage.


   **Aliases:**

   `list-storage`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-storage-pools`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-subnets`



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

   [add-user](#add-user) , 
   [register](#register) , 
   [show-user](#show-user) , 
   [disable-user](#disable-user) , 
   [enable-user](#enable-user)  

   **Aliases:**

   `list-users`



^# list-wallets

   **Usage:** ` juju wallets [options]`

   **Summary:**

   List wallets.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List the available wallets.


   **Examples:**

       juju wallets



   **Aliases:**

   `list-wallets`



^# login

   **Usage:** ` juju login [options] [controller host name or alias]`

   **Summary:**

   Logs a user in to a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _-u, --user (= "")_

   log in as this local user

   
   **Details:**


   By default, the juju login command logs the user into a controller.

   The argument to the command can be a public controller
   host name or alias (see Aliases below).

   If no argument is provided, the controller specified with
   the -c argument will be used, or the current controller
   if that's not provided.

   On success, the current controller is switched to the logged-in
   controller.

   If the user is already logged in, the juju login command does nothing
   except verify that fact.

   If the -u option is provided, the juju login command will attempt to log
   into the controller as that user.

   After login, a token ("macaroon") will become active. It has an expiration
   time of 24 hours. Upon expiration, no further Juju commands can be issued
   and the user will be prompted to log in again.

   Aliases
   -------
   Public controller aliases are provided by a directory service
   that is queried to find the host name for a given alias.

   The URL for the directory service may be configured
   by setting the environment variable JUJU_DIRECTORY.


   **Examples:**

       juju login somepubliccontroller
       juju login jimm.jujucharms.com
       juju login -u bob



   **See also:**

   [disable-user](#disable-user) , 
   [enable-user](#enable-user) , 
   [logout](#logout) , 
   [register](#register) , 
   [unregister](#unregister)  



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

   [change-user-password](#change-user-password) , 
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-machines`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Display recently collected metrics.




^# migrate

   **Usage:** ` juju migrate [options] <model-name> <target-controller-name>`

   **Summary:**

   Migrate a hosted model to another controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   
   **Details:**


   migrate begins the migration of a model from its current controller to
   a new controller. This is useful for load balancing when a controller
   is too busy, or as a way to upgrade a model's controller to a newer
   Juju version. Once complete, the model's machine and and unit agents
   will be connected to the new controller. The model will no longer be
   available at the source controller.

   Note that only hosted models can be migrated. Controller models can
   not be migrated.

   If the migration fails for some reason, the model be returned to its
   original state with the model being managed by the original
   controller.

   In order to start a migration, the target controller must be in the
   juju client's local configuration cache. See the juju "login" command
   for details of how to do this.

   This command only starts a model migration - it does not wait for its
   completion. The progress of a migration can be tracked using the
   "status" command and by consulting the logs.


   **See also:**

   [login](#login) , 
   [controllers](#controllers) , 
   [status](#status)  



^# model-config

   **Usage:** ` juju model-config [options] [<model-key>[=<value>] ...]`

   **Summary:**

   Displays or sets configuration values on a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--reset  (= )_

   Reset the provided comma delimited keys

   
   **Details:**


   By default, all configuration (keys, source, and values) for the current model
   are displayed.

   Supplying one key name returns only the value for the key. Supplying key=value
   will set the supplied key to the supplied value, this can be repeated for
   multiple keys. You can also specify a yaml file containing key values.
   The following keys are available:

   agent-metadata-url:

           type: string
           description: URL of private stream
   
   agent-stream:

           type: string
           description: Version of Juju to use for deploy/upgrades.

   
   apt-ftp-proxy:

           type: string
           description: The APT FTP proxy for the model
   
   apt-http-proxy:

           type: string
           description: The APT HTTP proxy for the model
   
   apt-https-proxy:

           type: string
           description: The APT HTTPS proxy for the model
   
   apt-mirror:

           type: string
           description: The APT mirror for the model
   
   apt-no-proxy:

           type: string
           description: List of domain addresses not to be proxied for APT (comma-separated)
   
   authorized-keys:

           type: string
           description: Any authorized SSH public keys for the model, as found in a ~/.ssh/authorized_keys
             file
   
   automatically-retry-hooks:

           type: bool
           description: Determines whether the uniter should automatically retry failed hooks
   
   backup-dir:

           type: string
           description: Directory used to store the backup working directory
   
   cloudinit-userdata:

           type: string
           description: Cloud-init user-data (in yaml format) to be added to userdata for new
             machines created in this model
   
   container-image-metadata-url:

           type: string
           description: The URL at which the metadata used to locate container OS image ids
             is located
   
   container-image-stream:

           type: string
           description: The simplestreams stream used to identify which image ids to search
             when starting a container.

   
   container-inherit-properties:

           type: string
           description: List of properties to be copied from the host machine to new containers
             created in this model (comma-separated)
   
   container-networking-method:

           type: string
           description: Method of container networking setup - one of fan, provider, local
   
   default-series:

           type: string
           description: The default series of Ubuntu to use for deploying charms
   
   development:

           type: bool
           description: Whether the model is in development mode
   
   disable-network-management:

           type: bool
           description: Whether the provider should control networks (on MAAS models, set to
             true for MAAS to control networks
   
   egress-subnets:

           type: string
           description: Source address(es) for traffic originating from this model
   
   enable-os-refresh-update:

           type: bool
           description: Whether newly provisioned instances should run their respective OS's
             update capability.

   
   enable-os-upgrade:

           type: bool
           description: Whether newly provisioned instances should run their respective OS's
             upgrade capability.

   
   extra-info:

           type: string
           description: Arbitrary user specified string data that is stored against the model.
   
   fan-config:

           type: string
           description: Configuration for fan networking for this model
   
   firewall-mode:

           type: string
           description: |-
             The mode to use for network firewalling.

             'instance' requests the use of an individual firewall per instance.
             'global' uses a single firewall for all instances (access
             for a network port is enabled to one instance if any instance requires
             that port).

             'none' requests that no firewalling should be performed
             inside the model. It's useful for clouds without support for either
             global or per instance security groups.

   
   ftp-proxy:

           type: string
           description: The FTP proxy value to configure on instances, in the FTP_PROXY environment
             variable
   
   http-proxy:

           type: string
           description: The HTTP proxy value to configure on instances, in the HTTP_PROXY environment
             variable
   
   https-proxy:

           type: string
           description: The HTTPS proxy value to configure on instances, in the HTTPS_PROXY
             environment variable
   
   ignore-machine-addresses:

           type: bool
           description: Whether the machine worker should discover machine addresses on startup
   
   image-metadata-url:

           type: string
           description: The URL at which the metadata used to locate OS image ids is located
   
   image-stream:

           type: string
           description: The simplestreams stream used to identify which image ids to search
             when starting an instance.

   
   juju-ftp-proxy:

           type: string
           description: The FTP proxy value to pass to charms in the JUJU_CHARM_FTP_PROXY environment
             variable
   
   juju-http-proxy:

           type: string
           description: The HTTP proxy value to pass to charms in the JUJU_CHARM_HTTP_PROXY
             environment variable
   
   juju-https-proxy:

           type: string
           description: The HTTPS proxy value to pass to charms in the JUJU_CHARM_HTTPS_PROXY
             environment variable
   
   juju-no-proxy:

           type: string
           description: List of domain addresses not to be proxied (comma-separated), may contain
             CIDRs. Passed to charms in the JUJU_CHARM_NO_PROXY environment variable
   
   logforward-enabled:

           type: bool
           description: Whether syslog forwarding is enabled.

   
   logging-config:

           type: string
           description: The configuration string to use when configuring Juju agent logging
             (see http://godoc.org/github.com/juju/loggo#ParseConfigurationString for details)
   
   max-action-results-age:

           type: string
           description: The maximum age for action entries before they are pruned, in human-readable
             time format
   
   max-action-results-size:

           type: string
           description: The maximum size for the action collection, in human-readable memory
             format
   
   max-status-history-age:

           type: string
           description: The maximum age for status history entries before they are pruned,
             in human-readable time format
   
   max-status-history-size:

           type: string
           description: The maximum size for the status history collection, in human-readable
             memory format
   
   net-bond-reconfigure-delay:

           type: int
           description: The amount of time in seconds to sleep between ifdown and ifup when
             bridging
   
   no-proxy:

           type: string
           description: List of domain addresses not to be proxied (comma-separated)
   
   provisioner-harvest-mode:

           type: string
           description: What to do with unknown machines. See https://jujucharms.com/stable/config-general#juju-lifecycle-and-harvesting
             (default destroyed)
   
   proxy-ssh:

           type: bool
           description: Whether SSH commands should be proxied through the API server
   
   resource-tags:

           type: attrs
           description: resource tags
   
   snap-http-proxy:

           type: string
           description: The HTTP proxy value to for installing snaps
   
   snap-https-proxy:

           type: string
           description: The HTTPS proxy value to for installing snaps
   
   snap-store-assertions:

           type: string
           description: The assertions for the defined snap store proxy
   
   snap-store-proxy:

           type: string
           description: The snap store proxy for installing snaps
   
   ssl-hostname-verification:

           type: bool
           description: Whether SSL hostname verification is enabled (default true)
   
   storage-default-block-source:

           type: string
           description: The default block storage source for the model
   
   storage-default-filesystem-source:

           type: string
           description: The default filesystem storage source for the model
   
   syslog-ca-cert:

           type: string
           description: The certificate of the CA that signed the syslog server certificate,
             in PEM format.

   
   syslog-client-cert:

           type: string
           description: The syslog client certificate in PEM format.

   
   syslog-client-key:

           type: string
           description: The syslog client key in PEM format.

   
   syslog-host:

           type: string
           description: The hostname:port of the syslog server.

   
   test-mode:

           type: bool
           description: |-
             Whether the model is intended for testing.

             If true, accessing the charm store does not affect statistical
             data of the store. (default false)
   
   transmit-vendor-metrics:

           type: bool
           description: Determines whether metrics declared by charms deployed into this model
             are sent for anonymized aggregate analytics
   
   update-status-hook-interval:

           type: string
           description: How often to run the charm update-status hook, in human-readable time
             format (default 5m, range 1-60m)

   **Examples:**

       juju model-config default-series
       juju model-config -m mycontroller:mymodel
       juju model-config ftp-proxy=10.0.0.1:8000
       juju model-config ftp-proxy=10.0.0.1:8000 path/to/file.yaml
       juju model-config path/to/file.yaml
       juju model-config -m othercontroller:mymodel default-series=yakkety test-mode=false
       juju model-config --reset default-series test-mode



   **See also:**

   [models](#models) , 
   [model-defaults](#model-defaults) , 
   [show-cloud](#show-cloud) , 
   [controller-config](#controller-config)  



^# model-default

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
   You can also specify a yaml file containing key values.

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
       juju model-defaults us-east-1 ftp-proxy=10.0.0.1:8000 path/to/file.yaml
       juju model-defaults us-east-1 path/to/file.yaml    
       juju model-defaults -m othercontroller:mymodel default-series=yakkety test-mode=false
       juju model-defaults --reset default-series test-mode
       juju model-defaults aws/us-east-1 --reset http-proxy
       juju model-defaults us-east-1 --reset http-proxy



   **See also:**

   [models](#models) , 
   [model-config](#model-config)  

   **Aliases:**

   `model-default`



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
   You can also specify a yaml file containing key values.

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
       juju model-defaults us-east-1 ftp-proxy=10.0.0.1:8000 path/to/file.yaml
       juju model-defaults us-east-1 path/to/file.yaml    
       juju model-defaults -m othercontroller:mymodel default-series=yakkety test-mode=false
       juju model-defaults --reset default-series test-mode
       juju model-defaults aws/us-east-1 --reset http-proxy
       juju model-defaults us-east-1 --reset http-proxy



   **See also:**

   [models](#models) , 
   [model-config](#model-config)  

   **Aliases:**

   `model-default`



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

   [add-model](#add-model) , 
   [share-model](#share-model) , 
   [unshare-model](#unshare-model)  

   **Aliases:**

   `list-models`



^# offer

   **Usage:** ` juju offer [options] [model-name.]<application-name>:<endpoint-name>[,...] [offer-name]`

   **Summary:**

   Offer application endpoints for use in other models.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Deployed application endpoints are offered for use by consumers.

   By default, the offer is named after the application, unless
   an offer name is explicitly specified.


   **Examples:**

   $ juju offer mysql:db
   $ juju offer mymodel.mysql:db
   $ juju offer db2:db hosted-db2
   $ juju offer db2:db,log hosted-db2



   **See also:**

   [consume](#consume) , 
   [relate](#relate)  



^# offers

   **Usage:** ` juju offers [options] [<offer-name>]`

   **Summary:**

   Lists shared endpoints.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--active-only  (= false)_

   only return results where the offer is in use

   _--allowed-consumer (= "")_

   return results where the user is allowed to consume the offer

   _--application (= "")_

   return results matching the application

   _--connected-user (= "")_

   return results where the user has a connection to the offer

   _--format  (= tabular)_

   Specify output format (json|summary|tabular|yaml)

   _--interface (= "")_

   return results matching the interface name

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List information about applications' endpoints that have been shared and who is connected.
   The default tabular output shows each user connected (relating to) the offer, and the 
   relation id of the relation.

   The summary output shows one row per offer, with a count of active/total relations.
   The YAML output shows additional information about the source of connections, including
   the source model UUID.

   The output can be filtered by:

          - interface: the interface name of the endpoint
          - application: the name of the offered application
          - connected user: the name of a user who has a relation to the offer
          - allowed consumer: the name of a user allowed to consume the offer
          - active only: only show offers which are in use (are related to)

   **Examples:**

       $ juju offers
       $ juju offers -m model
       $ juju offers --interface db2
       $ juju offers --application mysql
       $ juju offers --connected-user fred
       $ juju offers --allowed-consumer mary
       $ juju offers hosted-mysql
       $ juju offers hosted-mysql --active-only



   **See also:**

   [find-offers](#find-offers) , 
   [show-offer](#show-offer)  

   **Aliases:**

   `list-offers`



^# payloads

   **Usage:** ` juju payloads [options] [pattern ...]`

   **Summary:**

   Display status information about known payloads.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-payloads`



^# plans

   **Usage:** ` juju plans [options]`

   **Summary:**

   List plans.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|smart|summary|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List plans available for the specified charm.


   **Examples:**

       juju plans cs:webapp



   **Aliases:**

   `list-plans`



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

   [add-cloud](#add-cloud) , 
   [clouds](#clouds) , 
   [show-cloud](#show-cloud) , 
   [update-clouds](#update-clouds)  

   **Aliases:**

   `list-regions`



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

   [add-user](#add-user) , 
   [change-user-password](#change-user-password) , 
   [unregister](#unregister)  



^# relate

   **Usage:** ` juju add-relation [options] <application1>[:<endpoint name1>] <application2>[:<endpoint name2>]`

   **Summary:**

   Add a relation between two application endpoints.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--via (= "")_

   for cross model relations, specify the egress subnets for outbound traffic

   
   **Details:**


   Add a relation between 2 local application endpoints or a local endpoint and a remote application endpoint.
   Adding a relation between two remote application endpoints is not supported.
   Application endpoints can be identified either by:

             <application name>[:<relation name>]
                 where application name supplied without relation will be internally expanded to be well-formed
   
   or
             <model name>.<application name>[:<relation name>]
                 where the application is hosted in another model owned by the current user, in the same controller
   
   or
             <user name>/<model name>.<application name>[:<relation name>]
                 where user/model is another model in the same controller
   
   For a cross model relation, if the consuming side is behind a firewall and/or NAT is used for outbound traffic,
   it is possible to use the --via option to inform the offering side the source of traffic so that any required
   firewall ports may be opened.


   **Examples:**

       $ juju add-relation wordpress mysql
           where "wordpress" and "mysql" will be internally expanded to "wordpress:db" and "mysql:server" respectively

       $ juju add-relation wordpress someone/prod.mysql
           where "wordpress" will be internally expanded to "wordpress:db"

       $ juju add-relation wordpress someone/prod.mysql --via 192.168.0.0/16
       
       $ juju add-relation wordpress someone/prod.mysql --via 192.168.0.0/16,10.0.0.0/8



   **Aliases:**

   `relate`



^# reload-spaces

   **Usage:** ` juju reload-spaces [options]`

   **Summary:**

   Reloads spaces and subnets from substrate.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Reloades spaces and subnets from substrate



^# remove-application

   **Usage:** ` juju remove-application [options] <application> [<application>...]`

   **Summary:**

   Remove applications from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--destroy-storage  (= false)_

   Destroy storage attached to application units

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   **Usage:** ` juju remove-backup [options] [--keep-latest|<ID>]`

   **Summary:**

   Remove the specified backup from remote storage.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--keep-latest  (= false)_

   Remove all backups on remote storage except for the latest.

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--series (= "")_

   The series of the image to remove eg xenial

   
   **Details:**


   Remove cached os images in the Juju model.

   Images are identified by:

           Kind         eg "lxd"
           Series       eg "xenial"
           Architecture eg "amd64"

   **Examples:**

   Remove cached lxd image for xenial amd64.

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

   [add-cloud](#add-cloud) , 
   [list-clouds](#list-clouds)  



^# remove-consumed-application

   **Usage:** ` juju remove-saas [options] <saas-application-name> [<saas-application-name>...]`

   **Summary:**

   Remove consumed applications (SAAS) from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Removing a consumed (SAAS) application will terminate any relations that
   application has, potentially leaving any related local applications
   in a non-functional state.


   **Examples:**

       juju remove-saas hosted-mysql
       juju remove-saas -m test-model hosted-mariadb



   **Aliases:**

   `remove-consumed-application`



^# remove-credential

   **Usage:** ` juju remove-credential <cloud name> <credential name>`

   **Summary:**

   Removes locally stored credentials for a cloud.


   
   **Details:**


   The credentials to be removed are specified by a "credential name".

   Credential names, and optionally the corresponding authentication
   material, can be listed with `juju credentials`.


   **Examples:**

       juju remove-credential rackspace credential_name



   **See also:**

   [credentials](#credentials) , 
   [add-credential](#add-credential) , 
   [set-default-credential](#set-default-credential) , 
   [autoload-credentials](#autoload-credentials)  



^# remove-k8s

   **Usage:** ` juju remove-k8s [options] <k8s name>`

   **Summary:**

   Removes a k8s endpoint from Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Removes the specified k8s cloud from the controller (if it is not in use),
   and user-defined cloud details from this client.


   **Examples:**

       juju remove-k8s myk8scloud
       



   **See also:**

   [add-k8s](#add-k8s)  



^# remove-machine

   **Usage:** ` juju remove-machine [options] <machine number> ...`

   **Summary:**

   Removes one or more machines from a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--force  (= false)_

   Completely remove a machine and all its dependencies

   _--keep-instance  (= false)_

   Do not stop the running cloud instance

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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
       
   Remove machine 7 from the Juju model but do not stop 
   the corresponding cloud instance:

       juju remove-machine 7 --keep-instance



   **See also:**

   [add-machine](#add-machine)  



^# remove-offer

   **Usage:** ` juju remove-offer [options] <offer-url> ...`

   **Summary:**

   Removes one or more offers specified by their URL.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--force  (= false)_

   remove the offer as well as any relations to the offer

   _-y, --yes  (= false)_

   Do not prompt for confirmation

   
   **Details:**


   Remove one or more application offers.

   If the --force option is specified, any existing relations to the
   offer will also be removed.

   Offers to remove are normally specified by their URL.

   It's also possible to specify just the offer name, in which case
   the offer is considered to reside in the current model.


   **Examples:**

       juju remove-offer prod.model/hosted-mysql
       juju remove-offer prod.model/hosted-mysql --force
       juju remove-offer hosted-mysql



   **See also:**

   [find-offers](#find-offers) , 
   [offer](#offer)  



^# remove-relation

   **Usage:** ` juju remove-relation [options] <application1>[:<relation name1>] <application2>[:<relation name2>] | <relation-id>`

   **Summary:**

   Removes an existing relation between two applications.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   An existing relation between the two specified applications will be removed. 
   This should not result in either of the applications entering an error state,
   but may result in either or both of the applications being unable to continue
   normal operation. In the case that there is more than one relation between
   two applications it is necessary to specify which is to be removed (see
   examples). Relations will automatically be removed when using the`juju
   remove-application` command.

   The relation is specified using the relation endpoint names, eg
           mysql wordpress, or
           mediawiki:db mariadb:db
   
   It is also possible to specify the relation ID, if known. This is useful to
   terminate a relation originating from a different model, where only the ID is known. 

   **Examples:**

       juju remove-relation mysql wordpress
       juju remove-relation 4

   In the case of multiple relations, the relation name should be specified
   at least once - the following examples will all have the same effect:

       juju remove-relation mediawiki:db mariadb:db
       juju remove-relation mediawiki mariadb:db
       juju remove-relation mediawiki:db mariadb
    



   **See also:**

   [add-relation](#add-relation) , 
   [remove-application](#remove-application)  



^# remove-saas

   **Usage:** ` juju remove-saas [options] <saas-application-name> [<saas-application-name>...]`

   **Summary:**

   Remove consumed applications (SAAS) from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Removing a consumed (SAAS) application will terminate any relations that
   application has, potentially leaving any related local applications
   in a non-functional state.


   **Examples:**

       juju remove-saas hosted-mysql
       juju remove-saas -m test-model hosted-mariadb



   **Aliases:**

   `remove-consumed-application`



^# remove-ssh-key

   **Usage:** ` juju remove-ssh-key [options] <ssh key id> ...`

   **Summary:**

   Removes a public SSH key (or keys) from a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   [ssh-keys](#ssh-keys) , 
   [add-ssh-key](#add-ssh-key) , 
   [import-ssh-key](#import-ssh-key)  



^# remove-storage

   **Usage:** ` juju remove-storage [options] <storage> [<storage> ...]`

   **Summary:**

   Removes storage from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--force  (= false)_

   Remove storage even if it is currently attached

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-destroy  (= false)_

   Remove the storage without destroying it

   
   **Details:**


   Removes storage from the model. Specify one or more
   storage IDs, as output by "juju storage".

   By default, remove-storage will fail if the storage
   is attached to any units. To override this behaviour,
   you can use "juju remove-storage --force".


   **Examples:**

   Remove the detached storage pgdata/0.

       juju remove-storage pgdata/0

   Remove the possibly attached storage pgdata/0.

       juju remove-storage --force pgdata/0

   Remove the storage pgdata/0, without destroying
   the corresponding cloud storage.

       juju remove-storage --no-destroy pgdata/0





^# remove-unit

   **Usage:** ` juju remove-unit [options] <unit> [...] | <application>`

   **Summary:**

   Remove application units from the model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--destroy-storage  (= false)_

   Destroy storage attached to the unit

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--num-units  (= 0)_

   Number of units to remove (kubernetes models only)

   
   **Details:**


   Remove application units from the model.

   The usage of this command differs depending on whether it is being used on a
   Kubernetes or cloud model.

   Removing all units of a application is not equivalent to removing the
   application itself; for that, the `juju remove-application` command
   is used.

   For Kubernetes models only a single application can be supplied and only the
   --num-units argument supported.

   Specific units cannot be targeted for removal as that is handled by Kubernetes,
   instead the total number of units to be removed is specified.


   **Examples:**

       juju remove-unit wordpress --num-units 2

   For cloud models specific units can be targeted for removal.

   Units of a application are numbered in sequence upon creation. For example, the
   fourth unit of wordpress will be designated "wordpress/3". These identifiers
   can be supplied in a space delimited list to remove unwanted units from the
   model.

   Juju will also remove the machine if the removed unit was the only unit left
   on that machine (including units in containers).

   Examples:

       juju remove-unit wordpress/2 wordpress/3 wordpress/4

       juju remove-unit wordpress/2 --destroy-storage



   **See also:**

   [remove-application](#remove-application) , 
   [scale-application](#scale-application)  



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

   [unregister](#unregister) , 
   [revoke](#revoke) , 
   [show-user](#show-user) , 
   [list-users](#list-users) , 
   [switch-user](#switch-user) , 
   [disable-user](#disable-user) , 
   [enable-user](#enable-user) , 
   [change-user-password](#change-user-password)  



^# resolve

   **Usage:** ` juju resolved [options] [<unit> ...]`

   **Summary:**

   Marks unit errors resolved and re-executes failed hooks.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Marks all units in error as resolved

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-retry  (= false)_

   Do not re-execute failed hooks on the unit

   **Aliases:**

   `resolve`



^# resolved

   **Usage:** ` juju resolved [options] [<unit> ...]`

   **Summary:**

   Marks unit errors resolved and re-executes failed hooks.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--all  (= false)_

   Marks all units in error as resolved

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-retry  (= false)_

   Do not re-execute failed hooks on the unit

   **Aliases:**

   `resolve`



^# resources

   **Usage:** ` juju resources [options] <application or unit>`

   **Summary:**

   Show the resources for an application or unit.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--details  (= false)_

   show detailed information about resources used by each unit.

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command shows the resources required by and those in use by an existing
   application or unit in your model.  When run for an application, it will also show any
   updates available for resources from the charmstore.


   **Aliases:**

   `list-resources`



^# restore-backup

   **Usage:** ` juju restore-backup [options]`

   **Summary:**

   Restore from a backup archive to the existing controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--file (= "")_

   Provide a file to be used as the backup

   _--id (= "")_

   Provide the name of the backup to be restored

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Restores the Juju state database backup that was previously created with
   "juju create-backup", returning an existing controller to a previous state.
   Note: Only the database will be restored.  Juju will not change the existing
   environment to match the restored database, e.g. no units, relations, nor
   machines will be added or removed during the restore process.

   Note: Extra care is needed to restore in an HA environment, please see
   https://docs.jujucharms.com/stable/controllers-backup for more information.
   If the provided state cannot be restored, this command will fail with
   an explanation.




^# resume-relation

   **Usage:** ` juju resume-relation [options] <relation-id>[,<relation-id>]`

   **Summary:**

   Resumes a suspended relation to an application offer.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   A relation between an application in another model and an offer in this model will be resumed. 
   The relation-joined and relation-changed hooks will be run for the relation, and the relation
   status will be set to joined. The relation is specified using its id.


   **Examples:**

       juju resume-relation 123
       juju resume-relation 123 456



   **See also:**

   [add-relation](#add-relation) , 
   [offers](#offers) , 
   [remove-relation](#remove-relation) , 
   [suspend-relation](#suspend-relation)  



^# retry-provisioning

   **Usage:** ` juju retry-provisioning [options] <machine> [...]`

   **Summary:**

   Retries provisioning for failed machines.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>



^# revoke

   **Usage:** ` juju revoke [options] <user name> <permission> [<model name> ... | <offer url> ...]`

   **Summary:**

   Revokes access from a Juju user for a model, controller, or application offer.

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

   Revoke 'read' (and 'write') access from user 'joe' for application offer 'fred/prod.hosted-mysql':

       juju revoke joe read fred/prod.hosted-mysql

   Revoke 'consume' access from user 'sam' for models 'fred/prod.hosted-mysql' and 'mary/test.hosted-mysql':

       juju revoke sam consume fred/prod.hosted-mysql mary/test.hosted-mysql



   **See also:**

   [grant](#grant)  



^# revoke-cloud

   **Usage:** ` juju revoke-cloud [options] <user name> <permission> <cloud name> ...`

   **Summary:**

   Revokes access from a Juju user for a cloud.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Revoking admin access, from a user who has that permission, will leave
   that user with add-model access. Revoking add-model access, however, also revokes
   admin access.


   **Examples:**

   Revoke 'add-model' (and 'admin') access from user 'joe' for cloud 'fluffy':

       juju revoke-cloud joe add-model fluffy

   Revoke 'admin' access from user 'sam' for clouds 'fluffy' and 'rainy':

       juju revoke-cloud sam admin fluffy rainy



   **See also:**

   [grant-cloud](#grant-cloud)  



^# run

   **Usage:** ` juju run [options] <commands>`

   **Summary:**

   Run the commands on the remote targets specified.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-a, --app, --application  (= )_

   One or more application names

   _--all  (= false)_

   Run the commands on all the machines

   _--format  (= default)_

   Specify output format (default|json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--machine  (= )_

   One or more machine ids

   _-o, --output (= "")_

   Specify an output file

   _--timeout  (= 5m0s)_

   How long to wait before the remote command is considered to have failed

   _-u, --unit  (= )_

   One or more unit ids

   
   **Details:**


   Run a shell command on the specified targets. Only admin users of a model
   are able to use this command.

   Targets are specified using either machine ids, application names or unit
   names.  At least one target specifier is needed.

   Multiple values can be set for --machine, --application, and --unit by using
   comma separated values.

   If the target is a machine, the command is run as the "root" user on
   the remote machine.

   Some options are shortened for usabilty purpose in CLI
   --application can also be specified as --app and -a
   --unit can also be specified as -u
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
   If you need to pass options to the command being run, you must precede the
   command and its arguments with "--", to tell "juju run" to stop processing
   those arguments. For example:

             juju run --all -- hostname -f



^# run-action

   **Usage:** ` juju run-action [options] <unit> [<unit> ...] <action name> [key.key.key...=value]`

   **Summary:**

   Queue an action for execution.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (json|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--params  (= )_

   Path to yaml-formatted params file

   _--string-args  (= false)_

   Use raw string values of CLI args

   _--wait  (= )_

   Wait for results, with optional timeout

   
   **Details:**


   Queue an Action for execution on a given unit, with a given set of params.
   The Action ID is returned for use with 'juju show-action-output <ID>' or
   'juju show-action-status <ID>'.

   Valid unit identifiers are: 
           a standard unit ID, such as mysql/0 or;
           leader syntax of the form <application>/leader, such as mysql/leader.
   
   If the leader syntax is used, the leader unit for the application will be
   resolved before the action is enqueued.

   Params are validated according to the charm for the unit's application.  The
   valid params can be seen using "juju actions <application> --schema".

   Params may be in a yaml file which is passed with the --params option, or they
   may be specified by a key.key.key...=value format (see examples below.)
   Params given in the CLI invocation will be parsed as YAML unless the
   --string-args option is set.  This can be helpful for values such as 'y', which
   is a boolean true in YAML.

   If --params is passed, along with key.key...=value explicit arguments, the
   explicit arguments will override the parameter file.


   **Examples:**

   $ juju run-action mysql/3 backup --wait
   action-id: <ID>
   result:

     status: success
     file:

       size: 873.2
       units: GB
       name: foo.sql

   $ juju run-action mysql/3 backup
   action: <ID>

   $ juju run-action mysql/leader backup
   resolved leader: mysql/0
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





^# scale-application

   **Usage:** ` juju scale-application [options] <application> <scale>`

   **Summary:**

   Set the desired number of application units.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Scale a Kubernetes application by specifying how many units there should be.
   The new number of units can be greater or less than the current number, thus
   allowing both scale up and scale down.


   **Examples:**

       juju scale-application mariadb 2





^# scp

   **Usage:** ` juju scp [options] <source> <destination>`

   **Summary:**

   Transfers files to/from a Juju machine.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-host-key-checks  (= false)_

   Skip host key checking (INSECURE)

   _--proxy  (= false)_

   Proxy through the API server

   
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



^# set-constraints

   **Usage:** ` juju set-constraints [options] <application> <constraint>=<value> ...`

   **Summary:**

   Sets machine constraints for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   [get-constraints](#get-constraints) , 
   [get-model-constraints](#get-model-constraints) , 
   [set-model-constraints](#set-model-constraints)  



^# set-credential

   **Usage:** ` juju set-credential [options] <cloud name> <credential name>`

   **Summary:**

   Relates a remote credential to a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   This command relates a credential cached on a controller to a specific model.
   It does not change/update the contents of an existing active credential. See
   command `update-credential` for that.

   The credential specified may exist locally (on the client), remotely (on the
   controller), or both. The command will error out if the credential is stored
   neither remotely nor locally.

   When remote, the credential will be related to the specified model.

   When local and not remote, the credential will first be uploaded to the
   controller and then related.

   This command does not affect an existing relation between the specified
   credential and another model. If the credential is already related to a model
   this operation will result in that credential being related to two models.
   Use the `show-credential` command to see how remote credentials are related
   to models.


   **Examples:**

   For cloud 'aws', relate remote credential 'bob' to model 'trinity':

       juju set-credential -m trinity aws bob



   **See also:**

   [credentials](#credentials) , 
   [show-credential](#show-credential) , 
   [update-credential](#update-credential)  



^# set-default-credential

   **Usage:** ` juju set-default-credential <cloud name> <credential name>`

   **Summary:**

   Sets local default credentials for a cloud.


   
   **Details:**


   The default credentials are specified with a "credential name". 
   A credential name is created during the process of adding credentials either 
   via `juju add-credential` or `juju autoload-credentials`. 
   Credential names can be listed with `juju credentials`.

   This command sets a locally stored credential to be used as a default.
   Default credentials avoid the need to specify a particular set of 
   credentials when more than one are available for a given cloud.


   **Examples:**

       juju set-default-credential google credential_name



   **See also:**

   [credentials](#credentials) , 
   [add-credential](#add-credential) , 
   [remove-credential](#remove-credential) , 
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



^# set-firewall-rule

   **Usage:** ` juju set-firewall-rule [options] <service-name>, --whitelist <cidr>[,<cidr>...]`

   **Summary:**

   Sets a firewall rule.

   **Options:**

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--whitelist (= "")_

   list of subnets to whitelist

   
   **Details:**


   Firewall rules control ingress to a well known services
   within a Juju model. A rule consists of the service name
   and a whitelist of allowed ingress subnets.

   The currently supported services are:

          -ssh
          -juju-controller
          -juju-application-offer

   **Examples:**

       juju set-firewall-rule ssh --whitelist 192.168.1.0/16
       juju set-firewall-rule juju-controller --whitelist 192.168.1.0/16
       juju set-firewall-rule juju-application-offer --whitelist 192.168.1.0/16



   **See also:**

   [list-firewall-rules](#list-firewall-rules)  



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Set meter status on the given application or unit. This command is used
   to test the meter-status-changed hook for charms in development.


   **Examples:**

   Set Red meter status on all units of myapp
       juju set-meter-status myapp RED

   Set AMBER meter status with "my message" as info on unit myapp/0
       juju set-meter-status myapp/0 AMBER --info "my message"





^# set-model-constraints

   **Usage:** ` juju set-model-constraints [options] <constraint>=<value> ...`

   **Summary:**

   Sets machine constraints on a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   [models](#models) , 
   [get-model-constraints](#get-model-constraints) , 
   [get-constraints](#get-constraints) , 
   [set-constraints](#set-constraints)  



^# set-plan

   **Usage:** ` juju set-plan [options] <application name> <plan>`

   **Summary:**

   Set the plan for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   Set the plan for the deployed application, effective immediately.

   The specified plan name must be a valid plan that is offered for this
   particular charm. Use "juju list-plans <charm>" for more information.


   **Examples:**

       juju set-plan myapp example/uptime





^# set-series

   **Usage:** ` juju set-series [options] <application> <series>`

   **Summary:**

   Set an application's series.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--force  (= false)_

   Set even if the series is not supported by the charm and/or related subordinate charms.

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   When no options are set, an application series value will be set within juju.
   The update is disallowed unless the --force option is used if the requested
   series is not explicitly supported by the application's charm and all
   subordinates, as well as any other charms which may be deployed to the same
   machine.


   **Examples:**

   	juju set-series <application> <series>
   	juju set-series <application> <series> --force



   **See also:**

   [status](#status) , 
   [upgrade-charm](#upgrade-charm)  



^# set-wallet

   **Usage:** ` juju set-wallet [options] <wallet name> <value>`

   **Summary:**

   Set the wallet limit.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   
   **Details:**


   Set the monthly wallet limit.


   **Examples:**

   Sets the monthly limit for wallet named 'personal' to 96.

       juju set-wallet personal 96





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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--wait (= "-1s")_

   Wait for results

   
   **Details:**


   Show the results returned by an action with the given ID.  A partial ID may
   also be used.  To block until the result is known completed or failed, use
   the --wait option with a duration, as in --wait 5s or --wait 1h.  Use --wait 0
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
   **Details:**


   show-backup provides the metadata associated with a backup.




^# show-cloud

   **Usage:** ` juju show-cloud [options] <cloud name>`

   **Summary:**

   Shows detailed information on a cloud.

   **Options:**

   _--format  (= yaml)_

   Specify output format (yaml)

   _--include-config  (= false)_

   Print available config option details specific to the specified cloud

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Provided information includes 'defined' (public, built-in), 'type',
   'auth-type', 'regions', 'endpoints', and cloud specific configuration
   options.

   If ‘--include-config’ is used, additional configuration (key, type, and
   description) specific to the cloud are displayed if available.


   **Examples:**

       juju show-cloud google
       juju show-cloud azure-china --output ~/azure_cloud_details.txt



   **See also:**

   [clouds](#clouds) , 
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



^# show-credential

   **Usage:** ` juju show-credential [options] [<cloud name> <credential name>]`

   **Summary:**

   Shows credential information on a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-secrets  (= false)_

   Display credential secret attributes

   
   **Details:**


   This command displays information about credential(s) stored on the controller
   for this user.

   To see the contents of a specific credential, supply its cloud and name.
   To see all credentials stored for you, supply no arguments.

   To see secrets, content attributes marked as hidden, use --show-secrets option.
   To see locally stored credentials, use "juju credentials' command.


   **Examples:**

       juju show-credential google my-admin-credential
       juju show-credentials 
       juju show-credentials --show-secrets



   **See also:**

   [credentials](#credentials)  

   **Aliases:**

   `show-credentials`



^# show-credentials

   **Usage:** ` juju show-credential [options] [<cloud name> <credential name>]`

   **Summary:**

   Shows credential information on a controller.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= yaml)_

   Specify output format (yaml)

   _-o, --output (= "")_

   Specify an output file

   _--show-secrets  (= false)_

   Display credential secret attributes

   
   **Details:**


   This command displays information about credential(s) stored on the controller
   for this user.

   To see the contents of a specific credential, supply its cloud and name.
   To see all credentials stored for you, supply no arguments.

   To see secrets, content attributes marked as hidden, use --show-secrets option.
   To see locally stored credentials, use "juju credentials' command.


   **Examples:**

       juju show-credential google my-admin-credential
       juju show-credentials 
       juju show-credentials --show-secrets



   **See also:**

   [credentials](#credentials)  

   **Aliases:**

   `show-credentials`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   Show a specified machine on a model.  Default format is in yaml,
   other formats can be specified with the "--format" option.

   Available formats are yaml, tabular, and json

   **Examples:**

   Display status for machine 0
       juju show-machine 0

   Display status for machines 1, 2 & 3
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


   Show information about the current or specified model.




^# show-offer

   **Usage:** ` juju show-offer [options] [<controller>:]<offer url>`

   **Summary:**

   Shows extended information about the offered application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   This command is intended to enable users to learn more about the
   application offered from a particular URL. In addition to the URL of
   the offer, extra information is provided from the readme file of the
   charm being offered.


   **Examples:**

   To show the extended information for the application 'prod' offered
   from the model 'default' on the same Juju controller:

        juju show-offer default.prod

   The supplied URL can also include a username where offers require them. 
   This will be given as part of the URL retrieved from the
   'juju find-offers' command. To show information for the application
   'prod' from the model 'default' from the user 'admin':

       juju show-offer admin/default.prod

   To show the information regarding the application 'prod' offered from
   the model 'default' on an accessible controller named 'controller':

       juju show-offer controller:default.prod



   **See also:**

   [find-offers](#find-offers)  



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--relations  (= false)_

   Show 'relations' section

   _--retry-count  (= 3)_

   Number of times to retry API failures

   _--retry-delay  (= 100ms)_

   Time to wait between retry attempts

   _--storage  (= false)_

   Show 'storage' section

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

   Machine numbers may also be used as output filters. This will only display data 
   in each section relevant to the specified machines. For example, application 
   section will only contain the applications that have units on these machines, etc.
   The available output formats are:

   - tabular (default): Displays status in a tabular format with a separate table
   	  for the model, machines, applications, relations (if any), storage (if any) 
   	  and units.

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

               
   
   In tabular format, 'Relations' section is not displayed by default. 
   Use --relations option to see this section. This option is ignored in all other 
   formats.


   **Examples:**

       juju show-status
       juju show-status mysql
       juju show-status nova-*
       juju show-status --relations
       juju show-status --storage



   **See also:**

   [machines](#machines) , 
   [show-model](#show-model) , 
   [show-status-log](#show-status-log) , 
   [storage](#storage)  

   **Aliases:**

   `status`



^# show-status-log

   **Usage:** ` juju show-status-log [options] <entity name>`

   **Summary:**

   Output past statuses for the specified entity.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--days  (= 0)_

   Returns the logs for the past &lt;days> days (cannot be combined with -n or --date)

   _--from-date (= "")_

   Returns logs for any date after the passed one, the expected date format is YYYY-MM-DD (cannot be combined with -n or --days)

   _--include-status-updates  (= false)_

   Deprecated, has no effect for 2.3+ controllers: Include update status hook messages in the returned logs

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-n  (= 0)_

   Returns the last N logs (cannot be combined with --days or --date)

   _--type (= "unit")_

   Type of statuses to be displayed [container|juju-container|juju-machine|juju-unit|machine|unit|workload]

   _--utc  (= false)_

   Display time as UTC in RFC3339 format

   
   **Details:**


   This command will report the history of status changes for
   a given entity.

   The statuses are available for the following types.

   -type supports:

             container:  statuses from the agent that is managing containers
             juju-container:  statuses from the containers only and not their host machines
             juju-machine:  status of the agent that is managing a machine
             juju-unit:  statuses from the agent that is managing a unit
             machine:  statuses that occur due to provisioning of a machine
             unit:  statuses for specified unit and its workload
             workload:  statuses for unit's workload
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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Show extended information about storage instances.

   Storage instances to display are specified by storage ids. 
   Storage ids are positional arguments to the command and do not need to be comma
   separated when more than one id is desired.




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

   [add-user](#add-user) , 
   [register](#register) , 
   [users](#users)  



^# show-wallet

   **Usage:** ` juju show-wallet [options] <wallet>`

   **Summary:**

   Show details about a wallet.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Display wallet usage information.


   **Examples:**

       juju show-wallet personal





^# sla

   **Usage:** ` juju sla [options] <level>`

   **Summary:**

   Set the SLA level for a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--budget (= "")_

   the maximum spend for the model

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   Set the support level for the model, effective immediately.


   **Examples:**

   set the support level to essential
       juju sla essential

   set the support level to essential with a maximum budget of $1000 in wallet 'personal'
       juju sla standard --budget personal:1000

   display the current support level for the model.

       juju sla





^# spaces

   **Usage:** ` juju spaces [options] [--short] [--format yaml|json] [--output <path>]`

   **Summary:**

   List known spaces, including associated subnets.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--format  (= tabular)_

   Specify output format (json|tabular|yaml)

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-spaces`



^# ssh

   **Usage:** ` juju ssh [options] <[user@]target> [openssh options] [command]`

   **Summary:**

   Initiates an SSH session or executes a command on a Juju machine.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--no-host-key-checks  (= false)_

   Skip host key checking (INSECURE)

   _--proxy  (= false)_

   Proxy through the API server

   _--pty  (= &lt;auto>)_

   Enable pseudo-tty allocation

   
   **Details:**


   The machine is identified by the <target> argument which is either a 'unit
   name' or a 'machine id'. Both are obtained in the output to "juju status". If
   'user' is specified then the connection is made to that user account;
   otherwise, the default 'ubuntu' account, created by Juju, is used.

   The optional command is executed on the remote machine, and any output is sent
   back to the user. If no command is specified, then an interactive shell session
   will be initiated.

   When "juju ssh" is executed without a terminal attached, e.g. when piping the
   output of another command into it, then the default behavior is to not allocate
   a pseudo-terminal (pty) for the ssh session; otherwise a pty is allocated. This
   behavior can be overridden by explicitly specifying the behavior with
   "--pty=true" or "--pty=false".

   The SSH host keys of the target are verified. The --no-host-key-checks option
   can be used to disable these checks. Use of this option is not recommended as
   it opens up the possibility of a man-in-the-middle attack.

   The default identity known to Juju and used by this command is ~/.ssh/id_rsa
   Options can be passed to the local OpenSSH client (ssh) on platforms 
   where it is available. This is done by inserting them between the target and 
   a possible remote command. Refer to the ssh man page for an explanation 
   of those options.


   **Examples:**

   Connect to machine 0:

       juju ssh 0

   Connect to machine 1 and run command 'uname -a':

       juju ssh 1 uname -a

   Connect to a mysql unit:

       juju ssh mysql/0

   Connect to a jenkins unit as user jenkins:

       juju ssh jenkins@jenkins/0

   Connect to a mysql unit with an identity not known to juju (ssh option -i):

       juju ssh mysql/0 -i ~/.ssh/my_private_key echo hello



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   `list-ssh-keys`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--relations  (= false)_

   Show 'relations' section

   _--retry-count  (= 3)_

   Number of times to retry API failures

   _--retry-delay  (= 100ms)_

   Time to wait between retry attempts

   _--storage  (= false)_

   Show 'storage' section

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

   Machine numbers may also be used as output filters. This will only display data 
   in each section relevant to the specified machines. For example, application 
   section will only contain the applications that have units on these machines, etc.
   The available output formats are:

   - tabular (default): Displays status in a tabular format with a separate table
   	  for the model, machines, applications, relations (if any), storage (if any) 
   	  and units.

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

               
   
   In tabular format, 'Relations' section is not displayed by default. 
   Use --relations option to see this section. This option is ignored in all other 
   formats.


   **Examples:**

       juju show-status
       juju show-status mysql
       juju show-status nova-*
       juju show-status --relations
       juju show-status --storage



   **See also:**

   [machines](#machines) , 
   [show-model](#show-model) , 
   [show-status-log](#show-status-log) , 
   [storage](#storage)  

   **Aliases:**

   `status`



^# storage

   **Usage:** ` juju storage [options] <filesystem|volume> ...`

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-o, --output (= "")_

   Specify an output file

   _--volume  (= false)_

   List volume storage

   
   **Details:**


   List information about storage.


   **Aliases:**

   `list-storage`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-storage-pools`



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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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

   `list-subnets`



^# suspend-relation

   **Usage:** ` juju suspend-relation [options] <relation-id>[ <relation-id>...]`

   **Summary:**

   Suspends a relation to an application offer.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--message (= "")_

   reason for suspension

   
   **Details:**


   A relation between an application in another model and an offer in this model will be suspended. 
   The relation-departed and relation-broken hooks will be run for the relation, and the relation
   status will be set to suspended. The relation is specified using its id.

   **Examples:**

       juju suspend-relation 123
       juju suspend-relation 123 --message "reason for suspending"
       juju suspend-relation 123 456 --message "reason for suspending"



   **See also:**

   [add-relation](#add-relation) , 
   [offers](#offers) , 
   [remove-relation](#remove-relation) , 
   [resume-relation](#resume-relation)  



^# switch

   **Usage:** ` juju switch [options] [<controller>|<model>|<controller>:|:<model>|<controller>:<model>]`

   **Summary:**

   Selects or identifies the current controller and model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   
   **Details:**


   When used without an argument, the command shows the current controller 
   and its active model. 
   When a single argument without a colon is provided juju first looks for a
   controller by that name and switches to it, and if it's not found it tries
   to switch to a model within current controller. mycontroller: switches to
   default model in mycontroller, :mymodel switches to mymodel in current
   controller and mycontroller:mymodel switches to mymodel on mycontroller.
   The `juju models` command can be used to determine the active model
   (of any controller). An asterisk denotes it.


   **Examples:**

       juju switch
       juju switch mymodel
       juju switch mycontroller
       juju switch mycontroller:mymodel
       juju switch mycontroller:

       juju switch :mymodel



   **See also:**

   [controllers](#controllers) , 
   [models](#models) , 
   [show-controller](#show-controller)  



^# sync-agent-binaries

   **Usage:** ` juju sync-agent-binaries [options]`

   **Summary:**

   Copy agent binaries from the official agent store into a local model.

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--public  (= false)_

   Tools are for a public cloud, so generate mirrors information

   _--source (= "")_

   Local source directory

   _--stream (= "")_

   Simplestreams stream for which to sync metadata

   _--version (= "")_

   Copy a specific major[.minor] version

   
   **Details:**


   This copies the Juju agent software from the official agent binaries store 
   (located at https://streams.canonical.com/juju) into a model. 
   It is generally done when the model is without Internet access.

   Instead of the above site, a local directory can be specified as source.
   The online store will, of course, need to be contacted at some point to get
   the software.


   **Examples:**

   Download the software (version auto-selected) to the model:

       juju sync-agent-binaries --debug

   Download a specific version of the software locally:

       juju sync-agent-binaries --debug --version 2.0 --local-dir=/home/ubuntu/sync-agent-binaries

   Get locally available software to the model:

       juju sync-agent-binaries --debug --source=/home/ubuntu/sync-agent-binaries



   **See also:**

   [upgrade-model](#upgrade-model)  

   **Aliases:**

   `sync-tools`



^# sync-tools

   **Usage:** ` juju sync-agent-binaries [options]`

   **Summary:**

   Copy agent binaries from the official agent store into a local model.

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

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--public  (= false)_

   Tools are for a public cloud, so generate mirrors information

   _--source (= "")_

   Local source directory

   _--stream (= "")_

   Simplestreams stream for which to sync metadata

   _--version (= "")_

   Copy a specific major[.minor] version

   
   **Details:**


   This copies the Juju agent software from the official agent binaries store 
   (located at https://streams.canonical.com/juju) into a model. 
   It is generally done when the model is without Internet access.

   Instead of the above site, a local directory can be specified as source.
   The online store will, of course, need to be contacted at some point to get
   the software.


   **Examples:**

   Download the software (version auto-selected) to the model:

       juju sync-agent-binaries --debug

   Download a specific version of the software locally:

       juju sync-agent-binaries --debug --version 2.0 --local-dir=/home/ubuntu/sync-agent-binaries

   Get locally available software to the model:

       juju sync-agent-binaries --debug --source=/home/ubuntu/sync-agent-binaries



   **See also:**

   [upgrade-model](#upgrade-model)  

   **Aliases:**

   `sync-tools`



^# trust

   **Usage:** ` juju trust [options] <application name>`

   **Summary:**

   Sets the trust status of a deployed application to true.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _--remove  (= false)_

   Remove trusted access from a trusted application

   
   **Details:**


   Sets the trust configuration value to true.


   **Examples:**

       juju trust media-wiki



   **See also:**

   [config](#config)  



^# unexpose

   **Usage:** ` juju unexpose [options] <application name>`

   **Summary:**

   Removes public availability over the network for an application.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   Unregisters a Juju controller.

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

   [destroy-controller](#destroy-controller) , 
   [kill-controller](#kill-controller) , 
   [register](#register)  



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

   Updates a controller credential for a cloud.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--credential (= "")_

   Name of credential to update

   
   **Details:**


   Cloud credentials for controller are used for model operations and manipulations.
   Since it is common to have long-running models, it is also common to 
   have these cloud credentials become invalid during models' lifetime.

   When this happens, a user must update the cloud credential that 
   a model was created with to the new and valid details on controller.

   This command allows to update an existing, already-stored, named,
   cloud-specific controller credential.

   NOTE: 
   This is the only command that will allow you to manipulate cloud
   credential for a controller. 
   All other credential related commands, such as 
   `add-credential`, `remove-credential` and  `credentials`
   deal with credentials stored locally on the client not on the controller.

   **Examples:**

       juju update-credential aws mysecrets



   **See also:**

   [add-credential](#add-credential) , 
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

   _--force  (= false)_

   Allow a charm to be upgraded which bypasses LXD profile allow list

   _--force-series  (= false)_

   Upgrade even if series of deployed applications are not supported by the new charm

   _--force-units  (= false)_

   Upgrade all units immediately, even if in error state

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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


   When no options are set, the application's charm will be upgraded to the latest
   revision available in the repository from which it was originally deployed. An
   explicit revision can be chosen with the --revision option.

   A path will need to be supplied to allow an updated copy of the charm
   to be located.

   Deploying from a path is intended to suit the workflow of a charm author working
   on a single client machine; use of this deployment method from multiple clients
   is not supported and may lead to confusing behaviour. Each local charm gets
   uploaded with the revision specified in the charm, if possible, otherwise it
   gets a unique revision (highest in state + 1).

   When deploying from a path, the --path option is used to specify the location from
   which to load the updated charm. Note that the directory containing the charm must
   match what was originally used to deploy the charm as a superficial check that the
   updated charm is compatible.

   Resources may be uploaded at upgrade time by specifying the --resource option.
   Following the resource option should be name=filepath pair.  This option may be
   repeated more than once to upload more than one resource.

           juju upgrade-charm foo --resource bar=/some/file.tgz --resource baz=./docs/cfg.xml
   
   Where bar and baz are resources named in the metadata for the foo charm.
   Storage constraints may be added or updated at upgrade time by specifying
   the --storage option, with the same format as specified in "juju deploy".
   If new required storage is added by the new charm revision, then you must
   specify constraints or the defaults will be applied.

           juju upgrade-charm foo --storage cache=ssd,10G
   
   Charm settings may be added or updated at upgrade time by specifying the
   --config option, pointing to a YAML-encoded application config file.

           juju upgrade-charm foo --config config.yaml
   
   If the new version of a charm does not explicitly support the application's series, the
   upgrade is disallowed unless the --force-series option is used. This option should be
   used with caution since using a charm on a machine running an unsupported series may
   cause unexpected behavior.

   The --switch option allows you to replace the charm with an entirely different one.
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

   Use of the --force-units option is not generally recommended; units upgraded while in an
   error state will not have upgrade-charm hooks executed, and may cause unexpected
   behavior.

   --force option for LXD Profiles is not generally recommended when upgrading an 
   application; overriding profiles on the container may cause unexpected 
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

   **Usage:** ` juju upgrade-model [options]`

   **Summary:**

   Upgrades Juju on all machines in a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--agent-stream (= "")_

   Check this agent stream for upgrades

   _--agent-version (= "")_

   Upgrade to specific version

   _--build-agent  (= false)_

   Build a local version of the agent binary; for development use only

   _--dry-run  (= false)_

   Don't change anything, just report what would be changed

   _--ignore-agent-versions  (= false)_

   Don't check if all agents have already reached the current version

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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
   the software to the controller's cache via the `juju sync-agent-binaries` command.
   The command will abort if an upgrade is in progress. It will also abort if
   a previous upgrade was not fully completed (e.g.: if one of the
   controllers in a high availability model failed to upgrade).

   When looking for an agent to upgrade to Juju will check the currently
   configured agent stream for that model. It's possible to overwrite this for
   the lifetime of this upgrade using --agent-stream
   If a failed upgrade has been resolved, '--reset-previous-upgrade' can be
   used to allow the upgrade to proceed.

   Backups are recommended prior to upgrading.


   **Examples:**

       juju upgrade-model --dry-run
       juju upgrade-model --agent-version 2.0.1
       juju upgrade-model --agent-stream proposed
       



   **See also:**

   [sync-agent-binaries](#sync-agent-binaries)  

   **Aliases:**

   `upgrade-juju`



^# upgrade-model

   **Usage:** ` juju upgrade-model [options]`

   **Summary:**

   Upgrades Juju on all machines in a model.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--agent-stream (= "")_

   Check this agent stream for upgrades

   _--agent-version (= "")_

   Upgrade to specific version

   _--build-agent  (= false)_

   Build a local version of the agent binary; for development use only

   _--dry-run  (= false)_

   Don't change anything, just report what would be changed

   _--ignore-agent-versions  (= false)_

   Don't check if all agents have already reached the current version

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

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
   the software to the controller's cache via the `juju sync-agent-binaries` command.
   The command will abort if an upgrade is in progress. It will also abort if
   a previous upgrade was not fully completed (e.g.: if one of the
   controllers in a high availability model failed to upgrade).

   When looking for an agent to upgrade to Juju will check the currently
   configured agent stream for that model. It's possible to overwrite this for
   the lifetime of this upgrade using --agent-stream
   If a failed upgrade has been resolved, '--reset-previous-upgrade' can be
   used to allow the upgrade to proceed.

   Backups are recommended prior to upgrading.


   **Examples:**

       juju upgrade-model --dry-run
       juju upgrade-model --agent-version 2.0.1
       juju upgrade-model --agent-stream proposed
       



   **See also:**

   [sync-agent-binaries](#sync-agent-binaries)  

   **Aliases:**

   `upgrade-juju`



^# upgrade-series

   **Usage:** ` juju upgrade-series [options] <machine> <command> [args]`

   **Summary:**

   Upgrades the Ubuntu series of a machine.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _--force  (= false)_

   Upgrade even if the series is not supported by the charm and/or related subordinate charms.

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   _-y, --yes  (= false)_

   Agree that the operation cannot be reverted or canceled once started without being prompted.

   
   **Details:**


   Upgrade a machine's operating system series.

   This command allows users to perform a managed upgrade of the operating
   system series of a machine. This command is performed in two steps: prepare
   and complete. The "prepare" step notifies Juju that a series upgrade is
   taking place for a given machine and as such Juju guards that machine
   against operations that would interfere with the upgrade process.

   The "complete" step notifies Juju that the managed upgrade has been
   successfully completed. It should be noted that once the prepare command is
   issued there is no way to cancel or abort the process. Once you commit to
   prepare you must complete the process or you will end up with an unusable
   machine!  The requested series must be explicitly supported by all charms
   deployed to the specified machine. To override this constraint the
   `--force` option may be used. The `--force` option should be used with
   caution since using a charm on a machine running an unsupported series may
   cause unexpected behaviour. Alternately, if the requested series is
   supported in later revisions of the charm, `upgrade-charm` can run
   beforehand.


   **Examples:**

   Prepare machine 3 for upgrade to series "bionic"":

       juju upgrade-series 3 prepare bionic

   Prepare machine 4 for upgrade to series "cosmic" even if there are
   applications running units that do not support the target series:

       juju upgrade-series 4 prepare cosmic --force

   Complete upgrade of machine 5, indicating that all automatic and any
   necessary manual upgrade steps have completed successfully:

       juju upgrade-series 5 complete



   **See also:**

   [machines](#machines) , 
   [status](#status) , 
   [upgrade-charm](#upgrade-charm) , 
   [set-series](#set-series)  



^# upload-backup

   **Usage:** ` juju upload-backup [options] <filename>`

   **Summary:**

   Store a backup archive file remotely in Juju.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-m, --model (= "")_

   Model to operate in. Accepts [&lt;controller name>:]&lt;model name>

   
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

   [add-user](#add-user) , 
   [register](#register) , 
   [show-user](#show-user) , 
   [disable-user](#disable-user) , 
   [enable-user](#enable-user)  

   **Aliases:**

   `list-users`



^# version

   **Usage:** ` juju version [options]`

   **Summary:**

   Print the current version.

   **Options:**

   _--format  (= smart)_

   Specify output format (json|smart|yaml)

   _-o, --output (= "")_

   Specify an output file



^# wallets

   **Usage:** ` juju wallets [options]`

   **Summary:**

   List wallets.

   **Options:**

   _-B, --no-browser-login  (= false)_

   Do not use web browser for authentication

   _-c, --controller (= "")_

   Controller to operate in

   _--format  (= tabular)_

   Specify output format (json|tabular)

   _-o, --output (= "")_

   Specify an output file

   
   **Details:**


   List the available wallets.


   **Examples:**

       juju wallets



   **Aliases:**

   `list-wallets`



^# whoami

   **Usage:** ` juju whoami [options]`

   **Summary:**

   Print current login details.

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

   [controllers](#controllers) , 
   [login](#login) , 
   [logout](#logout) , 
   [models](#models) , 
   [users](#users)  



