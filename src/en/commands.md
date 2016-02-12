Title:Juju commands and usage

# Juju Command reference

You can get a list of the currently used commands by entering
```juju help commands``` from the commandline. The currently understood commands
are listed here, with usage and examples.

Click on the expander to see details for each command. 

^# action


  #### usage:

  
        juju action [options] <command> ...
  
  #### purpose:

   execute, manage, monitor, and retrieve results of actions
  
  #### options:
    
  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju action" executes and manages actions on units; it queues up new actions,
  monitors the status of running actions, and retrieves the results of completed
  actions.
  
  #### subcommands:

  defined - show actions defined for a service
  do      - queue an action for execution
  fetch   - show results of an action by ID
  help    - show help on a command or other topic
  status  - show results of all actions filtered by optional ID prefix




^# add-machine


  #### usage:

  
        juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | placement]
  

  #### purpose:

   start a new, empty machine and optionally a container, or add a container to a machine

  #### options:

  _--constraints  (= )_  additional machine constraints

  _--disks  (= )_  constraints for disks to attach to the machine

  _-m, --model (= "")_  juju model to operate in

  _-n  (= 1)_  The number of machines to add

  _--series (= "")_  the charm series
  
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
  container types are: lxc, kvm.
  
  Manual provisioning is the process of installing Juju on an existing machine
  and bringing it under Juju's management; currently this requires that the
  machine be running Ubuntu, that it be accessible via SSH, and be running on
  the same network as the API server.
  
  It is possible to override or augment constraints by passing provider-specific
  "placement directives" as an argument; these give the provider additional
  information about how to allocate the machine. For example, one can direct the
  MAAS provider to acquire a particular node by specifying its hostname.
  For more information on placement directives, see "juju help placement".
  
  #### Examples: 

        juju add-machine                      (starts a new machine)
        juju add-machine -n 2                 (starts 2 new machines)
        juju add-machine lxc                  (starts a new machine with an lxc container)
        juju add-machine lxc -n 2             (starts 2 new machines with an lxc container)
        juju add-machine lxc:4                (starts a new lxc container on machine 4)
        juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
        juju add-machine ssh:user@10.10.0.3   (manually provisions a machine with ssh)
        juju add-machine zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
        juju add-machine maas2.name           (acquire machine maas2.name on MAAS)


  See Also:
  juju help constraints
  juju help placement
  juju help remove-machine
  
  aliases: add-machines


^# add-machines


  #### usage:

  
        juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | placement]
  

  #### purpose:

   start a new, empty machine and optionally a container, or add a container to a machine


  
  #### options:



  _--constraints  (= )_  additional machine constraints


  _--disks  (= )_  constraints for disks to attach to the machine


  _-m, --model (= "")_  juju model to operate in


  _-n  (= 1)_  The number of machines to add


  _--series (= "")_  the charm series
  
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
  container types are: lxc, kvm.
  
  Manual provisioning is the process of installing Juju on an existing machine
  and bringing it under Juju's management; currently this requires that the
  machine be running Ubuntu, that it be accessible via SSH, and be running on
  the same network as the API server.
  
  It is possible to override or augment constraints by passing provider-specific
  "placement directives" as an argument; these give the provider additional
  information about how to allocate the machine. For example, one can direct the
  MAAS provider to acquire a particular node by specifying its hostname.
  For more information on placement directives, see "juju help placement".
  
  #### Examples: 

      juju add-machine                      (starts a new machine)
      juju add-machine -n 2                 (starts 2 new machines)
      juju add-machine lxc                  (starts a new machine with an lxc container)
      juju add-machine lxc -n 2             (starts 2 new machines with an lxc container)
      juju add-machine lxc:4                (starts a new lxc container on machine 4)
      juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
      juju add-machine ssh:user@10.10.0.3   (manually provisions a machine with ssh)
      juju add-machine zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
      juju add-machine maas2.name           (acquire machine maas2.name on MAAS)


  See Also:
  juju help constraints
  juju help placement
  juju help remove-machine
  
  aliases: add-machines


^# add-relation


  #### usage:

  
        juju add-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  

  #### purpose:

   add a relation between two services


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


^# add-space


  #### usage:

  
        juju space create [options] <name> [<CIDR1> <CIDR2> ...]
  

  #### purpose:

   create a new network space


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Creates a new space with the given name and associates the given
  (optional) list of existing subnet CIDRs with it.


^# add-ssh-key


  #### usage:

  
        juju add-ssh-key [options] <ssh key> ...
  

  #### purpose:

   add new authorized ssh key to a Juju model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Add new authorized ssh keys to allow the holder of those keys to log on to Juju nodes or machines.
  
  aliases: add-ssh-keys


^# add-ssh-keys


  #### usage:

  
        juju add-ssh-key [options] <ssh key> ...
  

  #### purpose:

   add new authorized ssh key to a Juju model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Add new authorized ssh keys to allow the holder of those keys to log on to Juju nodes or machines.
  
  aliases: add-ssh-keys


^# add-storage


  #### usage:

  
        juju storage add [options] 
  

  <unit name> <storage directive> ...
  where storage directive is 
  <charm storage name>=<storage constraints> 
  or
  <charm storage name>
  
  #### purpose:

   adds unit storage dynamically


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
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
  
  #### Example: 

      Add 3 ebs storage instances for "data" storage to unit u/0:     

        juju storage add u/0 data=ebs,1024,3 
  or
        juju storage add u/0 data=ebs,3
  or
        juju storage add u/0 data=ebs,,3 
  
  
  Add 1 storage instances for "data" storage to unit u/0 
  using default model provider pool:
  
        juju storage add u/0 data=1 
  or
        juju storage add u/0 data
 

^# add-subnet


  #### usage:

  
        juju subnet add [options] <CIDR>|<provider-id> <space> [<zone1> <zone2> ...]
  

  #### purpose:

   add an existing subnet to Juju


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Adds an existing subnet to Juju, making it available for use. Unlike
  "juju subnet create", this command does not create a new subnet, so it
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


  #### usage:

  
        juju add-unit [options] <service name>
  

  #### purpose:

   add one or more units of an already-deployed service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _-n, --num-units  (= 1)_  number of service units to add


  _--to (= "")_  the machine, container or placement directive to deploy the unit in, bypasses constraints
  
  Adding units to an existing service is a way to scale out a model by
  deploying more instances of a service.  Add-unit must be called on services that
  have already been deployed via juju deploy.
  
  By default, services are deployed to newly provisioned machines.  Alternatively,
  service units can be added to a specific existing machine using the --to
  argument.
  
  #### Examples: 

        juju add-unit mysql -n 5          (Add 5 mysql units on 5 new machines)
        juju add-unit mysql --to 23       (Add a mysql unit to machine 23)
        juju add-unit mysql --to 24/lxc/3 (Add unit to lxc container 3 on host machine 24)
        juju add-unit mysql --to lxc:25   (Add unit to a new lxc container on host machine 25)


  aliases: add-units


^# add-units


  #### usage:

  
        juju add-unit [options] <service name>
  

  #### purpose:

   add one or more units of an already-deployed service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _-n, --num-units  (= 1)_  number of service units to add


  _--to (= "")_  the machine, container or placement directive to deploy the unit in, bypasses constraints
  
  Adding units to an existing service is a way to scale out a model by
  deploying more instances of a service.  Add-unit must be called on services that
  have already been deployed via juju deploy.
  
  By default, services are deployed to newly provisioned machines.  Alternatively,
  service units can be added to a specific existing machine using the --to
  argument.
  
  #### Examples: 

        juju add-unit mysql -n 5          (Add 5 mysql units on 5 new machines)
        juju add-unit mysql --to 23       (Add a mysql unit to machine 23)
        juju add-unit mysql --to 24/lxc/3 (Add unit to lxc container 3 on host machine 24)
        juju add-unit mysql --to lxc:25   (Add unit to a new lxc container on host machine 25)


  aliases: add-units


^# add-user


  #### usage:

  
        juju add-user [options] <username> [<display name>]
  

  #### purpose:

   adds a user


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _-o, --output (= "")_  specify the model file for new user
  
  Add users to an existing model.
  
  The user information is stored within an existing model, and will be
  lost when the model is destroyed.  A server file will be written out in
  the current directory.  You can control the name and location of this file
  using the --output option.
  
  #### Examples: 

      # Add user "foobar" with a strong random password is generated.
        juju add-user foobar


  
  See Also:
  juju help change-user-password


^# agree


  #### usage:

  
        juju agree [options] <term>
  

  #### purpose:

   agree to terms


  
  #### options:



  _--format  (= json)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file


  _--yes  (= false)_  agree to terms non interactively
  
  Agree to the terms required by a charm.
  
  When deploying a charm that requires agreement to terms, use 'juju agree' to
  view the terms and agree to them. Then the charm may be deployed.
  
  Once you have agreed to terms, you will not be prompted to view them again.
  
  #### Examples: 



        juju agree somePlan/1
  Displays terms for somePlan revision 1 and prompts for agreement.
        juju agree somePlan/1 otherPlan/2
  Displays the terms for revision 1 of somePlan, revision 2 of otherPlan,
  and prompts for agreement.
        juju agree somePlan/1 otherPlan/2 --yes
  Agrees to the terms without prompting.


^# allocate


  #### usage:

  
        juju allocate [options]
  

  #### purpose:

   allocate budget to services


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Allocate budget for the specified services, replacing any prior allocations
  made for the specified services.
  
  Usage:
  
        juju allocate <budget>:<value> <service> [<service2> ...]
  
  #### Example: 



        juju allocate somebudget:42 db
  Assigns service "db" to an allocation on budget "somebudget" with the limit "42".


^# api-endpoints


  #### usage:

  
        juju api-endpoints [options]
  

  #### purpose:

   print the API server address(es)


  
  #### options:



  _--all  (= false)_  display all known endpoints, not just the first one


  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--refresh  (= false)_  connect to the API to ensure an up-to-date endpoint location
  
  Returns the address(es) of the current API server formatted as host:port.
  
  Without arguments apt-endpoints returns the last endpoint used to successfully
  connect to the API server. If a cached endpoints information is available from
  the current model's .jenv file, it is returned without trying to connect
  to the API server. When no cache is available or --refresh is given, api-endpoints
  connects to the API server, retrieves all known endpoints and updates the .jenv
  file before returning the first one. Example:
        juju api-endpoints
  10.0.3.1:17070
  
  If --all is given, api-endpoints returns all known endpoints. Example:
        juju api-endpoints --all
  10.0.3.1:17070
  localhost:170170
  
  The first endpoint is guaranteed to be an IP address and port. If a single endpoint
  is available and it's a hostname, juju tries to resolve it locally first.
  
  Additionally, you can use the --format argument to specify the output format.
  Supported formats are: "yaml", "json", or "smart" (default - host:port, one per line).


^# api-info


  #### usage:

  
        juju api-info [options] [field ...]
  

  #### purpose:

   print the field values used to connect to the model's API servers


  
  #### options:



  _--format  (= default)_  specify output format (default|json|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--password  (= false)_  include the password in the output fields


  _--refresh  (= false)_  connect to the API to ensure an up-to-date endpoint location
  
  Print the field values used to connect to the model's API servers"
  
  The exact fields to output can be specified on the command line.  The
  available fields are:
  user
  password
  environ-uuid
  controllers
  ca-cert
  
  If "password" is included as a field, or the --password option is given, the
  password value will be shown.
  
  
  #### Examples: 

        juju api-info
        user: admin
        environ-uuid: 373b309b-4a86-4f13-88e2-c213d97075b8
        controllers:
          - localhost:17070_
          - 10.0.3.1:17070_
          - 192.168.2.21:17070_      
        ca-cert: '-----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----_      '



        juju api-info user
        admin
  
        juju api-info user password
        user: admin
        password: sekrit


^# backups


  #### usage:

  
        juju backups [options] <command> ...
  

  #### purpose:

   create, manage, and restore backups of juju's state


  
  #### options:



  _--debug  (= false)_  equivalent to --show-log --log-config=<root>=DEBUG


  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic


  _--log-file (= "")_  path to write log to


  _--logging-config (= "")_  specify log levels for modules


  _-q, --quiet  (= false)_  show no informational output


  _--show-log  (= false)_  if set, write the log file to stderr


  _-v, --verbose  (= false)_  show more verbose output
  
  "juju backups" is used to manage backups of the state of a juju controller.
  Backups are only supported on juju controllers, not hosted models.  For
  more information on juju controllers, see:
  
      jujuhelp juju-controllers
  
  #### subcommands:

  create   - create a backup


  download - get an archive file


  help     - show help on a command or other topic


  info     - get metadata


  list     - get all metadata


  remove   - delete a backup


  restore  - restore from a backup archive to a new controller


  upload   - store a backup archive file remotely in juju




^# block


  #### usage:

  
        juju block [options] <command> ...
  

  #### purpose:

   list and enable model blocks


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  Juju allows to safeguard deployed models from unintentional damage by preventing
  execution of operations that could alter model.
  
  This is done by blocking certain commands from successful execution. Blocked commands
  must be manually unblocked to proceed.
  
  "juju block" is used to list or to enable model blocks in
  the Juju model.
  
  #### subcommands:

  all-changes   - block operations that could change Juju model


  destroy-model - block an operation that would destroy Juju model


  help          - show help on a command or other topic


  list          - list juju blocks


  remove-object - block an operation that would remove an object




^# bootstrap


  #### usage:

  
        juju bootstrap [options]
  

  #### purpose:

   start up an environment from scratch


  
  #### options:



  _--agent-version (= "")_  the version of tools to use for Juju agents


  _--auto-upgrade  (= false)_  upgrade to the latest patch release tools on first bootstrap


  _--bootstrap-constraints  (= )_  specify bootstrap machine constraints


  _--bootstrap-series (= "")_  specify the series of the bootstrap machine


  _--constraints  (= )_  set model constraints


  _--keep-broken  (= false)_  do not destroy the model if bootstrap fails


  _-m, --model (= "")_  juju model to operate in


  _--metadata-source (= "")_  local path to use as tools and/or metadata source


  _--to (= "")_  a placement directive indicating an instance to bootstrap


  _--upload-tools  (= false)_  upload local version of tools before bootstrapping
  
  bootstrap starts a new model of the current type (it will return an error
  if the model has already been bootstrapped).  Bootstrapping a model
  will provision a new machine in the model and run the juju controller on
  that machine.
  
  If boostrap-constraints are specified in the bootstrap command, 
  they will apply to the machine provisioned for the juju controller, 
  and any future controllers provisioned for HA.
  
  If constraints are specified, they will be set as the default constraints 
  on the model for all future workload machines, 
  exactly as if the constraints were set with juju set-constraints.
  
  It is possible to override constraints and the automatic machine selection
  algorithm by using the "--to" flag. The value associated with "--to" is a
  "placement directive", which tells Juju how to identify the first machine to use.
  For more information on placement directives, see "juju help placement".
  
  Bootstrap initialises the cloud environment synchronously and displays information
  about the current installation steps.  The time for bootstrap to complete varies
  across cloud providers from a few seconds to several minutes.  Once bootstrap has
  completed, you can run other juju commands against your model. You can change
  the default timeout and retry delays used during the bootstrap by changing the
  following settings in your environments.yaml (all values represent number of seconds):
  
  # How long to wait for a connection to the controller
  bootstrap-timeout: 600 # default: 10 minutes
  # How long to wait between connection attempts to a controller address.
  bootstrap-retry-delay: 5 # default: 5 seconds
  # How often to refresh controller addresses from the API server.
  bootstrap-addresses-delay: 10 # default: 10 seconds
  
  Private clouds may need to specify their own custom image metadata, and
  possibly upload Juju tools to cloud storage if no outgoing Internet access is
  available. In this case, use the --metadata-source parameter to point
  bootstrap to a local directory from which to upload tools and/or image
  metadata.
  
  If agent-version is specifed, this is the default tools version to use when running the Juju agents.
  Only the numeric version is relevant. To enable ease of scripting, the full binary version
  is accepted (eg 1.24.4-trusty-amd64) but only the numeric version (eg 1.24.4) is used.
  By default, Juju will bootstrap using the exact same version as the client.
  
  See Also:
  juju help switch
  juju help constraints
  juju help set-constraints
  juju help placement


^# cached-images


  #### usage:

  
        juju cached-images [options] <command> ...
  

  #### purpose:

   manage cached os images


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju cached-images" is used to manage the cached os images in
  the Juju model.
  
  #### subcommands:

  delete - delete cached os images


  help   - show help on a command or other topic


  list   - shows cached os images




^# change-user-password


  #### usage:

  
        juju change-user-password [options] [username]
  

  #### purpose:

   changes the password for a user


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _--generate  (= false)_  generate a new strong password


  _-o, --output (= "")_  specifies the path of the generated user model file
  
  Change the password for the user you are currently logged in as,
  or as an admin, change the password for another user.
  
  #### Examples: 

      # You will be prompted to enter a password.
      juju change-user-password


  # Change the password to a random strong password.
      jujuchange-user-password --generate
  
  # Change the password for bob, this always uses a random password
      jujuchange-user-password bob


^# collect-metrics


  #### usage:

  
        juju collect-metrics [options] [service or unit]
  

  #### purpose:

   collect metrics on the given unit/service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  collect-metrics
  trigger metrics collection


^# create-backup


  #### usage:

  
        juju backups create [options] [<notes>]
  

  #### purpose:

   create a backup


  
  #### options:



  _--filename (= "juju-backup-<date>-<time>.tar.gz")_  download to this file


  _-m, --model (= "")_  juju model to operate in


  _--no-download  (= false)_  do not download the archive
  
  "create" requests that juju create a backup of its state and print the
  backup's unique ID.  You may provide a note to associate with the backup.
  
  The backup archive and associated metadata are stored remotely by juju.
  
  The --download option may be used without the --filename option.  In
  that case, the backup archive will be stored in the current working
  directory with a name matching juju-backup-<date>-<time>.tar.gz.
  
  WARNING: Remotely stored backups will be lost when the model is
  destroyed.  Furthermore, the remotely backup is not guaranteed to be
  available.
  
  Therefore, you should use the --download or --filename options, or use
  "juju backups download", to get a local copy of the backup archive.
  This local copy can then be used to restore an model even if that
  model was already destroyed or is otherwise unavailable.


^# create-budget


  #### usage:

  
        juju create-budget
  

  #### purpose:

   create a new budget


  
  Create a new budget with monthly limit.
  
  #### Example: 

        juju create-budget qa 42
    
   Creates a budget named 'qa' with a limit of 42.


^# create-model


  #### usage:

  
        juju create-model [options] <name> [key=[value] ...]
  

  #### purpose:

   create an model within the Juju Model Server


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _--config  (= )_  path to yaml-formatted file containing model config values


  _--owner (= "")_  the owner of the new model if not the current user
  
  This command will create another model within the current Juju
  Controller. The provider has to match, and the model config must
  specify all the required configuration values for the provider. In the cases
  of ‘ec2’ and ‘openstack’, the same model variables are checked for the
  access and secret keys.
  
  If configuration values are passed by both extra command line arguments and
  the --config option, the command line args take priority.
  
  #### Examples: 



        juju create-model new-model
  
        juju create-model new-model --config=aws-creds.yaml
  
  See Also:
  juju help model share


^# debug-hooks


  #### usage:

  
        juju debug-hooks [options] <unit name> [hook names]
  

  #### purpose:

   launch a tmux session to debug a hook


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _--proxy  (= true)_  proxy through the API server


  _--pty  (= true)_  enable pseudo-tty allocation
  
  Interactively debug a hook remotely on a service unit.


^# debug-log


  #### usage:

  
        juju debug-log [options]
  

  #### purpose:

   display the consolidated log file


  
  #### options:



  _-T, --no-tail  (= false)_  stop after returning existing log messages


  _--exclude-module  (= )_  do not show log messages for these logging modules


  _-i, --include  (= )_  only show log messages for these entities


  _--include-module  (= )_  only show log messages for these logging modules


  _-l, --level (= "")_  log level to show, one of [TRACE, DEBUG, INFO, WARNING, ERROR]


  _--limit  (= 0)_  show at most this many lines


  _-m, --model (= "")_  juju model to operate in


  _-n, --lines  (= 10)_  go back this many lines from the end before starting to filter


  _--replay  (= false)_  start filtering from the start


  _-x, --exclude  (= )_  do not show log messages for these entities
  
  Stream the consolidated debug log file. This file contains the log messages
  from all nodes in the model.


^# debug-metrics


  #### usage:

  
        juju debug-metrics [options] [service or unit]
  

  #### purpose:

   retrieve metrics collected by the given unit/service


  
  #### options:



  _--json  (= false)_  output metrics as json


  _-m, --model (= "")_  juju model to operate in


  _-n  (= 0)_  number of metrics to retrieve
  
  debug-metrics
  display recently collected metrics and exit


^# deploy


  #### usage:

  
        juju deploy [options] <charm or bundle> [<service name>]
  

  #### purpose:

   deploy a new service or bundle


  
  #### options:



  _--budget (= "personal:0")_  budget and allocation limit


  _--config  (= )_  path to yaml-formatted service config


  _--constraints  (= )_  set service constraints


  _--force  (= false)_  allow a charm to be deployed to a machine running an unsupported series


  _-m, --model (= "")_  juju model to operate in


  _-n, --num-units  (= 1)_  number of service units to deploy for principal charms


  _--networks (= "")_  deprecated and ignored: use space constraints instead.


  _--plan (= "")_  plan to deploy charm under


  _--repository (= "")_  local charm repository


  _--series (= "")_  the series on which to deploy


  _--storage  (= )_  charm storage constraints


  _--to (= "")_  the machine, container or placement directive to deploy the unit in, bypasses constraints


  _-u, --upgrade  (= false)_  increment local charm directory revision (DEPRECATED)
  
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
  
  Deploying using a local repository is supported but deprecated.
  In this case, when the default-series is not specified in the
  model, one must specify the series. For example:

        local:precise/mysql
  
  Local bundles can be specified either with a local:bundle/<name> URL, which is
  interpreted relative to $JUJU_REPOSITORY, or with a direct path to a
  bundle.yaml file. For example, to deploy the bundle in
  $JUJU_REPOSITORY/bundle/openstack:
  
        juju deploy local:bundle/openstack
  
  To deploy this using a direct path:
  
        juju deploy $JUJU_REPOSITORY/bundle/openstack/bundle.yaml
  
  <service name>, if omitted, will be derived from <charm name>.
  
  Constraints can be specified when using deploy by specifying the --constraints
  flag.  When used with deploy, service-specific constraints are set so that later
  machines provisioned with add-unit will use the same constraints (unless changed
  by set-constraints).
  
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
  
  #### Examples: 

        juju deploy mysql --to 23       (deploy to machine 23)
        juju deploy mysql --to 24/lxc/3 (deploy to lxc container 3 on host machine 24)
        juju deploy mysql --to lxc:25   (deploy to a new lxc container on host machine 25)


        juju deploy mysql -n 5 --constraints mem=8G
  (deploy 5 instances of mysql with at least 8 GB of RAM each)
  
        juju deploy haproxy -n 2 --constraints spaces=dmz,^cms,^database
  (deploy 2 instances of haproxy on cloud instances being part of the dmz
  space but not of the cmd and the database space)
  
  See Also:
  juju help spaces
  juju help constraints
  juju help set-constraints
  juju help get-constraints


^# destroy-controller


  #### usage:

  
        juju destroy-controller [options] <controller name>
  

  #### purpose:

   terminate all machines and other associated resources for the juju controller


  
  #### options:



  _--destroy-all-models  (= false)_  destroy all hosted models in the controller


  _-y, --yes  (= false)_  Do not ask for confirmation
  
  Destroys the specified controller


^# destroy-model


  #### usage:

  
        juju destroy-model [options] <model name>
  

  #### purpose:

   terminate all machines and other associated resources for a non-controller model


  
  #### options:



  _-y, --yes  (= false)_  Do not ask for confirmation
  
  Destroys the specified model


^# destroy-relation


  #### usage:

  
        juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  

  #### purpose:

   remove a relation between two services


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  aliases: destroy-relation


^# destroy-service


  #### usage:

  
        juju remove-service [options] <service>
  

  #### purpose:

   remove a service from the model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Removing a service will remove all its units and relations.
  
  If this is the only service running, the machine on which
  the service is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a controller_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-service


^# destroy-unit


  #### usage:

  
        juju remove-unit [options] <unit> [...]
  

  #### purpose:

   remove service units from the model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Remove service units from the model.
  
  If this is the only unit running, the machine on which
  the unit is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a controller_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-unit


^# disable-user


  #### usage:

  
        juju disable-user [options] <username>
  

  #### purpose:

   disable a user to stop the user logging in


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in
  
  Disabling a user stops that user from being able to log in. The user still
  exists and can be reenabled using the "juju enable-user" command.  If the user is
  already disabled, this command succeeds silently.
  
  #### Examples: 

        juju disable-user foobar


  See Also:
  juju help enable-user


^# enable-ha


  #### usage:

  
        juju enable-ha [options]
  

  #### purpose:

   ensure that sufficient controllers exist to provide redundancy


  
  #### options:



  _--constraints  (= )_  additional machine constraints


  _--format  (= simple)_  specify output format (json|simple|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-n  (= 0)_  number of controllers to make available


  _-o, --output (= "")_  specify an output file


  _--series (= "")_  the charm series


  _--to (= "")_  the machine(s) to become controllers, bypasses constraints
  
  To ensure availability of deployed services, the Juju infrastructure
  must itself be highly available.  enable-ha must be called
  to ensure that the specified number of controllers are made available.
  
  An odd number of controllers is required.
  
  #### Examples: 

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


  #### usage:

  
        juju enable-user [options] <username>
  

  #### purpose:

   reenables a disabled user to allow the user to log in


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in
  
  Enabling a user that is disabled allows that user to log in again. The user
  still exists and can be reenabled using the "juju enable-user" command.  If the
  user is already enabled, this command succeeds silently.
  
  #### Examples: 

        juju enable-user foobar


  See Also:
  juju disable-user


^# expose


  #### usage:

  
        juju expose [options] <service>
  

  #### purpose:

   expose a service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Adjusts firewall rules and similar security mechanisms of the provider, to
  allow the service to be accessed on its public address.


^# generate-config


  #### usage:

  
        juju init [options]
  

  #### purpose:

   generate boilerplate configuration for juju models


  
  #### options:



  _-f  (= false)_  force overwriting environments.yaml file even if it exists (ignored if --show flag specified)


  _--show  (= false)_  print the generated configuration data to stdout instead of writing it to a file
  
  aliases: generate-config


^# get-config


  #### usage:

  
        juju get-config [options] <service>
  

  #### purpose:

   get service configuration options


  
  #### options:



  _--format  (= yaml)_  specify output format (yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  The command output includes the service and charm names, a detailed list of all config
  settings for <service>, including the setting name, whether it uses the default value
  or not ("default: true"), description (if set), type, and current value. Example:
  
        juju get-config wordpress
  
  might return:

        charm: wordpress
        service: wordpress
        settings:
          engine:
            default: true
            description: 'Currently two ...'
            type: string
            value: nginx
          tuning:
            description: "This is the tuning level..."
            type: string
            value: optimized
  
  NOTE: In the example above the descriptions and most other settings were omitted or
  truncated for brevity. The "engine" setting was left at its default value ("nginx"),
  while the "tuning" setting was set to "optimized" (the default value is "single").
  
  Note that the "default" field indicates whether a configuration setting is at its
  default value. It does not indicate the default value for the setting.
  
  aliases: get-configs


^# get-configs


  #### usage:

  
        juju get-config [options] <service>
  

  #### purpose:

   get service configuration options


  
  #### options:



  _--format  (= yaml)_  specify output format (yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  The command output includes the service and charm names, a detailed list of all config
  settings for <service>, including the setting name, whether it uses the default value
  or not ("default: true"), description (if set), type, and current value. Example:
  
  $ juju get-config wordpress
  
  charm: wordpress
  service: wordpress
  settings:
  engine:
  default: true
  description: 'Currently two ...'
  type: string
  value: nginx
  tuning:
  description: "This is the tuning level..."
  type: string
  value: optimized
  
  NOTE: In the example above the descriptions and most other settings were omitted or
  truncated for brevity. The "engine" setting was left at its default value ("nginx"),
  while the "tuning" setting was set to "optimized" (the default value is "single").
  
  Note that the "default" field indicates whether a configuration setting is at its
  default value. It does not indicate the default value for the setting.
  
  aliases: get-configs


^# get-constraints


  #### usage:

  
        juju get-constraints [options] <service>
  

  #### purpose:

   view constraints on a service


  
  #### options:



  _--format  (= constraints)_  specify output format (constraints|json|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  Shows the list of constraints that have been set on the specified service
  using juju service set-constraints.  You can also view constraints
  set for a model by using juju model get-constraints.
  
  Constraints set on a service are combined with model constraints for
  commands (such as juju deploy) that provision machines for services.  Where
  model and service constraints overlap, the service constraints take
  precedence.
  
  #### Example: 



        juju get-constraints wordpress
  
  See Also:
  juju help constraints
  juju help set-constraints
  juju help deploy
  juju help machine add
  juju help add-unit


^# get-model-config


  #### usage:

  
        juju get-model-config [options] [<model key>]
  

  #### purpose:

   view model values


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  If no extra args passed on the command line, all configuration keys and values
  for the environment are output using the selected formatter.
  
  A single model value can be output by adding the model key name to
  the end of the command line.
  
  #### Example: 



        juju get-model-config default-series  (returns the default series for the model)


^# get-model-constraints


  #### usage:

  
        juju get-model-constraints [options]
  

  #### purpose:

   view constraints on the model


  
  #### options:



  _--format  (= constraints)_  specify output format (constraints|json|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  Shows a list of constraints that have been set on the model
  using juju set-model-constraints.  You can also view constraints
  set for a specific service by using juju get-constraints <service>.
  
  Constraints set on a service are combined with model constraints for
  commands (such as juju deploy) that provision machines for services.  Where
  model and service constraints overlap, the service constraints take
  precedence.
  
  See Also:
  juju help constraints
  juju help set-model-constraints
  juju help deploy
  juju help machine add
  juju help add-unit


^# get-user-credentials


  #### usage:

  
        juju get-user-credentials [options]
  

  #### purpose:

   save the credentials and server details to a file


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _-o, --output (= "")_  specifies the path of the generated file
  
  Writes out the current user and credentials to a file that can be used
  with 'juju controller login' to allow the user to access the same models
  as the same user from another machine.
  
  #### Examples: 



        juju get-user-credentials --output staging.creds
  
  # copy the staging.creds file to another machine
  
        juju login staging --server staging.creds --keep-password
  
  
  See Also:
  juju help login


^# help


  #### usage:

  
        juju help [topic]
  

  #### purpose:

   show help on a command or other topic


  
  See also: topics


^# help-tool


  #### usage:

  
        juju help-tool [tool]
  

  #### purpose:

   show help on a juju charm tool




^# import-ssh-key


  #### usage:

  
        juju import-ssh-key [options] <ssh key id> ...
  

  #### purpose:

   using ssh-import-id, import new authorized ssh keys to a Juju model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Import new authorised ssh keys to allow the holder of those keys to log on to Juju nodes or machines.
  The keys are imported using ssh-import-id.
  
  aliases: import-ssh-keys


^# import-ssh-keys


  #### usage:

  
        juju import-ssh-key [options] <ssh key id> ...
  

  #### purpose:

   using ssh-import-id, import new authorized ssh keys to a Juju model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Import new authorised ssh keys to allow the holder of those keys to log on to Juju nodes or machines.
  The keys are imported using ssh-import-id.
  
  aliases: import-ssh-keys


^# init


  #### usage:

  
        juju init [options]
  

  #### purpose:

   generate boilerplate configuration for juju models


  
  #### options:



  _-f  (= false)_  force overwriting environments.yaml file even if it exists (ignored if --show flag specified)


  _--show  (= false)_  print the generated configuration data to stdout instead of writing it to a file
  
  aliases: generate-config


^# kill-controller


  #### usage:

  
        juju kill-controller [options] <controller name>
  

  #### purpose:

   forcibly terminate all machines and other associated resources for a juju controller


  
  #### options:



  _-y, --yes  (= false)_  do not ask for confirmation
  
  Forcibly destroy the specified controller.  If the API server is accessible,
  this command will attempt to destroy the controller model and all
  hosted models and their resources.
  
  If the API server is unreachable, the machines of the controller model
  will be destroyed through the cloud provisioner.  If there are additional
  machines, including machines within hosted models, these machines will
  not be destroyed and will never be reconnected to the Juju controller being
  destroyed.


^# list-actions


  #### usage:

  
        juju action defined [options] <service name>
  

  #### purpose:

   show actions defined for a service


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--schema  (= false)_  display the full action schema
  
  Show the actions available to run on the target service, with a short
  description.  To show the full schema for the actions, use --schema.
  
  For more information, see also the 'do' subcommand, which executes actions.


^# list-all-blocks


  #### usage:

  
        juju list-all-blocks [options]
  

  #### purpose:

   list all blocks within the controller


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-o, --output (= "")_  specify an output file
  
  List all blocks for models within the specified controller


^# list-budgets


  #### usage:

  
        juju list-budgets [options]
  

  #### purpose:

   list budgets


  
  #### options:



  _--format  (= tabular)_  specify output format (tabular)


  _-o, --output (= "")_  specify an output file
  
  List the available budgets.
  
  #### Example: 

          juju list-budgets


^# list-controllers


  #### usage:

  
        juju list-controllers
  

  #### purpose:

   list all controllers logged in to on the current machine


  
  List all the Juju controllers logged in to on the current machine.
  
  A controller refers to a Juju Controller that runs and manages the Juju API
  server and the underlying database used by Juju. A controller may host
  multiple models.
  
  See Also:
  juju help controllers
  juju help list-models
  juju help create-model
  juju help use-model


^# list-machine


  #### usage:

  
        juju list-machines [options]
  

  #### purpose:

   list machines in a model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  List all the machines in a juju model.
  Default display is in tabular format with the following sections:
  ID, STATE, DNS, INS-ID, SERIES, AZ
  
  Note: AZ above is the cloud region's availability zone.
  
  aliases: machines, machine, list-machine


^# list-machines


  #### usage:

  
        juju list-machines [options]
  

  #### purpose:

   list machines in a model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  List all the machines in a juju model.
  Default display is in tabular format with the following sections:
  ID, STATE, DNS, INS-ID, SERIES, AZ
  
  Note: AZ above is the cloud region's availability zone.
  
  aliases: machines, machine, list-machine


^# list-models


  #### usage:

  
        juju list-models [options]
  

  #### purpose:

   list all models the user can access on the current controller


  
  #### options:



  _--all  (= false)_  show all models  (administrative users only)


  _-c, --controller (= "")_  juju controller to operate in


  _--exact-time  (= false)_  use full timestamp precision


  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-o, --output (= "")_  specify an output file


  _--user (= "")_  the user to list models for (administrative users only)


  _--uuid  (= false)_  display UUID for models
  
  List all the models the user can access on the current controller.
  
  The models listed here are either models you have created
  yourself, or models which have been shared with you.
  
  See Also:
  juju help controllers
  juju help model users
  juju help model share
  juju help model unshare


^# list-payloads


  #### usage:

  
        juju list-payloads [options] [pattern ...]
  

  #### purpose:

   display status information about known payloads


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  This command will report on the runtime state of defined payloads.
  
  When one or more pattern is given, Juju will limit the results to only
  those payloads which match *any* of the provided patterns. Each pattern
  will be checked against the following info in Juju:
  


  _- unit name_

  _- machine id_

  _- payload type_

  _- payload class_

  _- payload id_

  _- payload tag_

  _- payload status_

^# list-plans


  #### usage:

  
        juju list-plans [options]
  

  #### purpose:

   list plans


  
  #### options:



  _--format  (= yaml)_  specify output format (json|smart|summary|tabular|yaml)


  _-o, --output (= "")_  specify an output file
  
  List plans available for the specified charm.
  
  #### Example: 

         juju list-plans cs:webapp


^# list-shares


  #### usage:

  
        juju list-shares [options]
  

  #### purpose:

   shows all users with access to the current model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  List all users with access to the current model


^# list-spaces


  #### usage:

  
        juju space list [options] [--short] [--format yaml|json] [--output <path>]
  

  #### purpose:

   list spaces known to Juju, including associated subnets


  
  #### options:



  _--format  (= yaml)_  specify output format (json|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--short  (= false)_  only display spaces.
  
  Displays all defined spaces. If --short is not given both spaces and
  their subnets are displayed, otherwise just a list of spaces. The


  _--format argument has the same semantics as in other CLI commands -_  "yaml" is the default. The --output argument allows the command
  output to be redirected to a file.


^# list-ssh-key


  #### usage:

  
        juju list-ssh-keys [options]
  

  #### purpose:

   list authorised ssh keys in a model


  
  #### options:



  _--full  (= false)_  show full key instead of just the key fingerprint


  _-m, --model (= "")_  juju model to operate in
  
  List the authorized ssh keys in the model, allowing the holders of those keys to log on to Juju nodes.
  By default, just the key fingerprint is printed. Use --full to display the entire key.
  
  aliases: ssh-key, ssh-keys, list-ssh-key


^# list-ssh-keys


  #### usage:

  
        juju list-ssh-keys [options]
  

  #### purpose:

   list authorised ssh keys in a model


  
  #### options:



  _--full  (= false)_  show full key instead of just the key fingerprint


  _-m, --model (= "")_  juju model to operate in
  
  List the authorized ssh keys in the model, allowing the holders of those keys to log on to Juju nodes.
  By default, just the key fingerprint is printed. Use --full to display the entire key.
  
  aliases: ssh-key, ssh-keys, list-ssh-key


^# list-storage


  #### usage:

  
        juju storage list [options]
  

  #### purpose:

   lists storage


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  List information about storage instances.
  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--format (= tabular)_  specify output format (json|tabular|yaml)


^# list-users


  #### usage:

  
        juju list-users [options]
  

  #### purpose:

   shows all users


  
  #### options:



  _--all  (= false)_  include disabled users in the listing


  _-c, --controller (= "")_  juju controller to operate in


  _--exact-time  (= false)_  use full timestamp precision


  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-o, --output (= "")_  specify an output file
  
  List all the current users in the Juju server.
  
  See Also:
  juju help show-user


^# login


  #### usage:

  
        juju login [options] <name>
  

  #### purpose:

   login to a Juju Controller


  
  #### options:



  _--keep-password  (= false)_  do not generate a new random password


  _--server  (= )_  path to yaml-formatted server file
  
  login connects to a juju controller and caches the information that juju
  needs to connect to the api server in the $(JUJU_DATA)/models directory.
  
  In order to login to a controller, you need to have a user already created for you
  in that controller. The way that this occurs is for an existing user on the controller
  to create you as a user. This will generate a file that contains the
  information needed to connect.
  
  If you have been sent one of these server files, you can login by doing the
  following:
  
  if you have saved the server file as ~/erica.server
        jujulogin --server=~/erica.server test-controller
  
  A new strong random password is generated to replace the password defined in
  the server file. The 'test-controller' will also become the current controller that
  the juju command will talk to by default.
  
  If you have used the 'api-info' command to generate a copy of your current
  credentials for a controller, you should use the --keep-password option as it will
  mean that you will still be able to connect to the api server from the
  computer where you ran api-info.
  
  See Also:
  juju help list-models
  juju help use-model
  juju help create-model
  juju help add-user
  juju help switch


^# machine


  #### usage:

  
        juju list-machines [options]
  

  #### purpose:

   list machines in a model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  List all the machines in a juju model.
  Default display is in tabular format with the following sections:
  ID, STATE, DNS, INS-ID, SERIES, AZ
  
  Note: AZ above is the cloud region's availability zone.
  
  aliases: machines, machine, list-machine


^# machines


  #### usage:

  
        juju list-machines [options]
  

  #### purpose:

   list machines in a model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  List all the machines in a juju model.
  Default display is in tabular format with the following sections:
  ID, STATE, DNS, INS-ID, SERIES, AZ
  
  Note: AZ above is the cloud region's availability zone.
  
  aliases: machines, machine, list-machine


^# publish


  #### usage:

  
        juju publish [options] [<charm url>]
  

  #### purpose:

   publish charm to the store


  
  #### options:



  _--from (= ".")_  path for charm to be published


  _-m, --model (= "")_  juju model to operate in
  
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


^# remove-all-blocks


  #### usage:

  
        juju remove-all-blocks [options]
  

  #### purpose:

   remove all blocks in the Juju controller


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in
  
  Remove all blocks in the Juju controller.
  
  A controller administrator is able to remove all the blocks that have been added
  in a Juju controller.
  
  See Also:
  juju help block
  juju help unblock


^# remove-machine


  #### usage:

  
        juju remove-machine [options] <machineID[s]> ...
  

  #### purpose:

   remove machines from the model


  
  #### options:



  _--force  (= false)_  completely remove machine and all dependencies


  _-m, --model (= "")_  juju model to operate in
  
  Machines that are responsible for the model cannot be removed. Machines
  running units or containers can only be removed with the --force flag; doing
  so will also remove all those units and containers without giving them any
  opportunity to shut down cleanly.
  
  #### Examples: 

        # Remove machine number 5 which has no running units or containers
        juju remove-machine 5


        # Remove machine 6 and any running units or containers
        $ juju remove-machine 6 --force
  
  aliases: remove-machines


^# remove-machines


  #### usage:

  
        juju remove-machine [options] <machineID[s]> ...
  

  #### purpose:

   remove machines from the model


  
  #### options:



  _--force  (= false)_  completely remove machine and all dependencies


  _-m, --model (= "")_  juju model to operate in
  
  Machines that are responsible for the model cannot be removed. Machines
  running units or containers can only be removed with the --force flag; doing
  so will also remove all those units and containers without giving them any
  opportunity to shut down cleanly.
  
  #### Examples: 

        # Remove machine number 5 which has no running units or containers
        $ juju remove-machine 5


        # Remove machine 6 and any running units or containers
        $ juju remove-machine 6 --force
  
  aliases: remove-machines


^# remove-relation


  #### usage:

  
        juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  

  #### purpose:

   remove a relation between two services


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  aliases: destroy-relation


^# remove-service


  #### usage:

  
        juju remove-service [options] <service>
  

  #### purpose:

   remove a service from the model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Removing a service will remove all its units and relations.
  
  If this is the only service running, the machine on which
  the service is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a controller_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-service


^# remove-ssh-key


  #### usage:

  
        juju remove-ssh-key [options] <ssh key id> ...
  

  #### purpose:

   remove authorized ssh keys from a Juju model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Remove existing authorized ssh keys to remove ssh access for the holder of those keys.
  The keys to delete are found by specifying either the "comment" portion of the ssh key,
  typically something like "user@host", or the key fingerprint.
  
  aliases: remove-ssh-keys


^# remove-ssh-keys


  #### usage:

  
        juju remove-ssh-key [options] <ssh key id> ...
  

  #### purpose:

   remove authorized ssh keys from a Juju model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Remove existing authorized ssh keys to remove ssh access for the holder of those keys.
  The keys to delete are found by specifying either the "comment" portion of the ssh key,
  typically something like "user@host", or the key fingerprint.
  
  aliases: remove-ssh-keys


^# remove-unit


  #### usage:

  
        juju remove-unit [options] <unit> [...]
  

  #### purpose:

   remove service units from the model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Remove service units from the model.
  
  If this is the only unit running, the machine on which
  the unit is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a controller_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-unit


^# resolved


  #### usage:

  
        juju resolved [options] <unit>
  

  #### purpose:

   marks unit errors resolved


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _-r, --retry  (= false)_  re-execute failed hooks


^# restore-backup


  #### usage:

  
        juju backups restore [options]
  

  #### purpose:

   restore from a backup archive to a new controller


  
  #### options:



  _-b  (= false)_  bootstrap a new state machine


  _--constraints  (= )_  set model constraints


  _--file (= "")_  provide a file to be used as the backup.


  _--id (= "")_  provide the name of the backup to be restored.


  _-m, --model (= "")_  juju model to operate in


  _--upload-tools  (= false)_  upload tools if bootstraping a new machine.
  
  Restores a backup that was previously created with "juju backup" and
  "juju backups create".
  
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


  #### usage:

  
        juju retry-provisioning [options] <machine> [...]
  

  #### purpose:

   retries provisioning for failed machines


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


^# run


  #### usage:

  
        juju run [options] <commands>
  

  #### purpose:

   run the commands on the remote targets specified


  
  #### options:



  _--all  (= false)_  run the commands on all the machines


  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _--machine  (= )_  one or more machine ids


  _-o, --output (= "")_  specify an output file


  _--service  (= )_  one or more service names


  _--timeout  (= 5m0s)_  how long to wait before the remote command is considered to have failed


  _--unit  (= )_  one or more unit ids
  
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


  _--service mysql_  is equivalent to


  _--unit mysql/0,mysql/1_  
  Commands run for services or units are executed in a 'hook context' for
  the unit.
  


  _--all is provided as a simple way to run the command on all the machines_  in the model.  If you specify --all you cannot provide additional
  targets.


^# run-action


  #### usage:

  
        juju action do [options] <unit> <action name> [key.key.key...=value]
  

  #### purpose:

   queue an action for execution


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--params  (= )_  path to yaml-formatted params file


  _--string-args  (= false)_  use raw string values of CLI args
  
  Queue an Action for execution on a given unit, with a given set of params.
  Displays the ID of the Action for use with 'juju kill', 'juju status', etc.
  
  Params are validated according to the charm for the unit's service.  The 
  valid params can be seen using "juju action defined <service> --schema".
  Params may be in a yaml file which is passed with the --params flag, or they
  may be specified by a key.key.key...=value format (see examples below.)
  
  Params given in the CLI invocation will be parsed as YAML unless the


  _--string-args flag is set.  This can be helpful for values such as 'y', which_  is a boolean true in YAML.
  
  If --params is passed, along with key.key...=value explicit arguments, the
  explicit arguments will override the parameter file.
  
  #### Examples: 



        $ juju action do mysql/3 backup 
        action: <ID>
  
         $ juju action fetch <ID>
         result:
         status: success
         file:
         size: 873.2
         units: GB
        name: foo.sql
  
        $ juju action do mysql/3 backup --params parameters.yml
        ...
        Params sent will be the contents of parameters.yml.
        ...
  
        $ juju action do mysql/3 backup out=out.tar.bz2 file.kind=xz file.quality=high
        ...
        Params sent will be:
  
        out: out.tar.bz2
        file:
        kind: xz
        quality: high
        ...
  
        $ juju action do mysql/3 backup --params p.yml file.kind=xz file.quality=high
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
  
        $ juju action do sleeper/0 pause time=1000
        ...
  
        $ juju action do sleeper/0 pause --string-args time=1000
        ...
  The value for the "time" param will be the string literal "1000".


^# scp


  #### usage:

  
        juju scp [options] <file1> ... <file2> [scp-option...]
  

  #### purpose:

   launch a scp command to copy files to/from remote machine(s)


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _--proxy  (= true)_  proxy through the API server


  _--pty  (= true)_  enable pseudo-tty allocation
  
  Launch an scp command to copy files. Each argument <file1> ... <file2>
  is either local file path or remote locations of the form [<user>@]<target>:<path>,
  where <target> can be either a machine id as listed by "juju status" in the
  "machines" section or a unit name as listed in the "services" section. If a
  username is not specified, the username "ubuntu" will be used.
  
  To pass additional flags to "scp", separate "juju scp" from the options with
  "--" to prevent Juju from attempting to interpret the flags. This is only
  supported if the scp command can be found in the system PATH. Please refer to
  the man page of scp(1) for the supported extra arguments.
  
  #### Examples: 



  Copy a single file from machine 2 to the local machine:
  
        juju scp 2:/var/log/syslog .
  
  Copy 2 files from two units to the local backup/ directory, passing -v
  to scp as an extra argument:
  
        juju scp -- -v ubuntu/0:/path/file1 ubuntu/1:/path/file2 backup/
  
  Recursively copy the directory /var/log/mongodb/ on the first mongodb
  server to the local directory remote-logs:
  
        juju scp -- -r mongodb/0:/var/log/mongodb/ remote-logs/
  
  Copy a local file to the second apache unit of the model "testing":
  
        juju scp -m testing foo.txt apache2/1:


^# set-budget


  #### usage:

  
        juju set-budget
  

  #### purpose:

   set the budget limit


  
  Set the monthly budget limit.
  
  #### Example: 

        juju set-budget personal 96
  
  Sets the monthly limit for budget named 'personal' to 96.


^# set-config


  #### usage:

  
        juju set-config [options] <service> name=value ...
  

  #### purpose:

   set service config options


  
  #### options:



  _--config  (= )_  path to yaml-formatted service config


  _-m, --model (= "")_  juju model to operate in


  _--to-default  (= false)_  set service option values to default
  
  Set one or more configuration options for the specified service.
  
  In case a value starts with an at sign (@) the rest of the value is interpreted
  as a filename. The value itself is then read out of the named file. The maximum
  size of this value is 5M.
  
  Option values may be any UTF-8 encoded string. UTF-8 is accepted on the command
  line and in configuration files.
  
  aliases: set-configs


^# set-configs


  #### usage:

  
        juju set-config [options] <service> name=value ...
  

  #### purpose:

   set service config options


  
  #### options:



  _--config  (= )_  path to yaml-formatted service config


  _-m, --model (= "")_  juju model to operate in


  _--to-default  (= false)_  set service option values to default
  
  Set one or more configuration options for the specified service.
  
  In case a value starts with an at sign (@) the rest of the value is interpreted
  as a filename. The value itself is then read out of the named file. The maximum
  size of this value is 5M.
  
  Option values may be any UTF-8 encoded string. UTF-8 is accepted on the command
  line and in configuration files.
  
  aliases: set-configs


^# set-constraints


  #### usage:

  
      
        juju set-constraints [options] <service> [key=[value] ...]
  

  #### purpose:

   set constraints on a service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Sets machine constraints on specific service, which are used as the
  default constraints for all new machines provisioned by that service.
  You can also set constraints on a model by using
      jujumodel set-constraints.
  
  Constraints set on a service are combined with model constraints for
  commands (such as juju deploy) that provision machines for services.  Where
  model and service constraints overlap, the service constraints take
  precedence.
  
  #### Example: 



        juju set-constraints wordpress mem=4G     (all new wordpress machines must have at least 4GB of RAM)
  
  See Also:
  juju help constraints
  juju help get-constraints
  juju help deploy
  juju help machine add
  juju help add-unit


^# set-meter-status


  #### usage:

  
      
      juju set-meter-status [options] [service or unit] status
  

  #### purpose:

   sets the meter status on a service or unit


  
  #### options:



  _--info (= "")_  Set the meter status info to this string


  _-m, --model (= "")_  juju model to operate in
  
  Set meter status on the given service or unit. This command is used to test the meter-status-changed hook for charms in development.
  #### Examples: 

      juju set-meter-status myapp RED # Set Red meter status on all units of myapp
      juju set-meter-status myapp/0 AMBER --info "my message" # Set AMBER meter status with "my message" as info on unit myapp/0


^# set-model-config


  #### usage:

  
      
        juju set-model-config [options] key=[value] ...
  

  #### purpose:

   replace model values


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Updates the model of a running Juju instance.  Multiple key/value pairs
  can be passed on as command line arguments.


^# set-model-constraints


  #### usage:

  
        juju set-model-constraints [options] [key=[value] ...]
  

  #### purpose:

   set constraints on the model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Sets machine constraints on the model, which are used as the default
  constraints for all new machines provisioned in the model (unless
  overridden).  You can also set constraints on a specific service by using
      juju set-constraints.
  
  Constraints set on a service are combined with model constraints for
  commands (such as juju deploy) that provision machines for services.  Where
  model and service constraints overlap, the service constraints take
  precedence.
  
  #### Example: 

        juju model set-constraints mem=8G
  
  (all new machines in the model must have at least 8GB of RAM)
  
  See Also:
  juju help constraints
  juju help get-model-constraints
  juju help deploy
  juju help machine add
  juju help add-unit


^# set-plan


  #### usage:

  
        juju set-plan [options] <service name> <plan>
  

  #### purpose:

   set the plan for a service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Set the plan for the deployed service, effective immediately.
  
  The specified plan name must be a valid plan that is offered for this particular charm. Use "juju list-plans <charm>" for more information.
  
  Usage:
  
        juju set-plan [options] <service name> <plan name>
  
  #### Example: 



        juju set-plan myapp example/uptime


^# share-model


  #### usage:

  
        juju share-model [options] <user> ...
  

  #### purpose:

   share the current model with another user


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Share the current model with another user.
  
  #### Examples: 

        juju share-model joe
  Give local user "joe" access to the current model


        juju share-model user1 user2 user3@ubuntuone
  Give two local users and one remote user access to the current model
  
        juju share-model sam --model myenv
  Give local user "sam" access to the model named "myenv"


^# show-action-output


  #### usage:

  
        juju action fetch [options] <action ID>
  

  #### purpose:

   show results of an action by ID


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--wait (= "-1s")_  wait for results
  
  Show the results returned by an action with the given ID.  A partial ID may
  also be used.  To block until the result is known completed or failed, use
  the --wait flag with a duration, as in --wait 5s or --wait 1h.  Use --wait 0
  to wait indefinitely.  If units are left off, seconds are assumed.
  
  The default behavior without --wait is to immediately check and return; if
  the results are "pending" then only the available information will be
  displayed.  This is also the behavior when any negative time is given.


^# show-action-status


  #### usage:

  
        juju action status [options] [<action ID>|<action ID prefix>]
  

  #### purpose:

   show results of all actions filtered by optional ID prefix


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  Show the status of Actions matching given ID, partial ID prefix, or all Actions if no ID is supplied.


^# show-budget


  #### usage:

  
        juju show-budget [options]
  

  #### purpose:

   show budget usage


  
  #### options:



  _--format  (= tabular)_  specify output format (tabular)


  _-o, --output (= "")_  specify an output file
  
  Display budget usage information.
  
  #### Example: 

         juju show-budget personal


^# show-machine


  #### usage:

  
        juju show-machine [options] <machineID> ...
  

  #### purpose:

   show a machines status


  
  #### options:



  _--format  (= yaml)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
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
  
  aliases: show-machines


^# show-machines


  #### usage:

  
        juju show-machine [options] <machineID> ...
  

  #### purpose:

   show a machines status


  
  #### options:



  _--format  (= yaml)_  specify output format (json|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
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
  
  aliases: show-machines


^# show-status


  #### usage:

  
        juju status [options] [pattern ...]
  

  #### purpose:

   output status information about a model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|line|oneline|short|summary|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  This command will report on the runtime state of various system entities.
  
  There are a number of ways to format the status output:
  


  _- {short|line|oneline}: List units and their subordinates. For each_  unit, the IP address and agent status are listed.


  _- summary: Displays the subnet(s) and port(s) the model utilises._  Also displays aggregate information about:


  _- MACHINES: total #, and # in each state._

  _- UNITS: total #, and # in each state._

  _- SERVICES: total #, and # exposed of each service._

  _- tabular (DEFAULT): Displays information in a tabular format in these sections:_

  _- Machines: ID, STATE, DNS, INS-ID, SERIES, AZ_

  _- Services: NAME, EXPOSED, CHARM_

  _- Units: ID, STATE, VERSION, MACHINE, PORTS, PUBLIC-ADDRESS_

  _- Also displays subordinate units._

  _- yaml: Displays information on machines, services, and units_  in the yaml format.
  
  Note: AZ above is the cloud region's availability zone.
  
  Service or unit names may be specified to filter the status to only those
  services and units that match, along with the related machines, services
  and units. If a subordinate unit is matched, then its principal unit will
  be displayed. If a principal unit is matched, then all of its subordinates
  will be displayed.
  
  Wildcards ('*') may be specified in service/unit names to match any sequence
  of characters. For example, 'nova-*' will match any service whose name begins
  with 'nova-': 'nova-compute', 'nova-volume', etc.
  
  aliases: show-status


^# show-storage


  #### usage:

  
        juju storage show [options]
  

  #### purpose:

   shows storage instance


  
  #### options:



  _--format  (= yaml)_  specify output format (json|smart|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file
  
  Show extended information about storage instances.
  Storage instances to display are specified by storage ids.
  
  * note use of positional arguments
  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--format (= yaml)_  specify output format (json|yaml)
  [space separated storage ids]


^# show-user


  #### usage:

  
        juju show-user [options] <username>
  

  #### purpose:

   shows information on a user


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _--exact-time  (= false)_  use full timestamp precision


  _--format  (= yaml)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file
  
  Display infomation on a user.
  
  #### Examples: 

      # Show information on the current user
      $ juju show-user
      user-name: foobar
      display-name: Foo Bar
      date-created : 1981-02-27 16:10:05 +0000 UTC
      last-connection: 2014-01-01 00:00:00 +0000 UTC


      # Show information on a user with the given username
      $ juju show-user jsmith
      user-name: jsmith
      display-name: John Smith
      date-created : 1981-02-27 16:10:05 +0000 UTC
      last-connection: 2014-01-01 00:00:00 +0000 UTC
  
      # Show information on the current user in JSON format
      $ juju show-user --format json
      {"user-name":"foobar",
      "display-name":"Foo Bar",
      "date-created": "1981-02-27 16:10:05 +0000 UTC",
      "last-connection": "2014-01-01 00:00:00 +0000 UTC"}
  
      # Show information on the current user in YAML format
      $ juju show-user --format yaml
      user-name: foobar
      display-name: Foo Bar
      date-created : 1981-02-27 16:10:05 +0000 UTC
      last-connection: 2014-01-01 00:00:00 +0000 UTC


^# space


  #### usage:

  
        juju space [options] <command> ...
  

  #### purpose:

   manage network spaces


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju space" provides commands to manage Juju network spaces.
  
  A space is a security subdivision of a network.
  
  In practice, a space is a collection of related subnets that have no
  firewalls between each other, and that have the same ingress and
  egress policies. Common examples in company networks are “the dmz” or
  “the pci compliant space”. The name of the space suggests that it is a
  logical network area which has some specific security characteristics


  _- hence the “common ingress and egress policy” definition._  
  All of the addresses in all the subnets in a given space are assumed
  to be equally able to connect to one another, and all of them are
  assumed to go through the same firewalls (or through the same firewall
  rules) for connections into or out of the space. For allocation
  purposes, then, putting a service on any address in a space is equally
  secure - all the addresses in the space have the same firewall rules
  applied to them.
  
  Users create spaces to describe relevant areas of their network (i.e.
  DMZ, internal, etc.).
  
  Spaces can be specified via constraints when deploying a service
  and/or at add-relation time. Since all subnets in a space are
  considered equal, placement of services in a space means placement on
  any of the subnets in that space. A machine bound to a space could be
  on any one of the subnets, and routable to any other machine in the
  space because any subnet in the space can access any other in the same
  space.
  
  Initially, there is one space (named "default") which always exists
  and "contains" all subnets not associated with another space. However,
  since the spaces are defined on the cloud substrate (e.g. using tags
  in EC2), there could be pre-existing spaces that get discovered after
  bootstrapping a new model using shared credentials (multiple
  users or roles, same substrate).
  
  #### subcommands:

  create - create a new network space


  help   - show help on a command or other topic


  list   - list spaces known to Juju, including associated subnets




^# ssh


  #### usage:

  
        juju ssh [options] <target> [<ssh args>...]
  

  #### purpose:

   launch an ssh shell on a given unit or machine


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _--proxy  (= true)_  proxy through the API server


  _--pty  (= true)_  enable pseudo-tty allocation
  
  Launch an ssh shell on the machine identified by the <target> parameter.
  <target> can be either a machine id  as listed by "juju status" in the
  "machines" section or a unit name as listed in the "services" section.
  Any extra parameters are passed as extra parameters to the ssh command.
  
  #### Examples: 



  Connect to machine 0:
  
      juju ssh 0
  
  Connect to machine 1 and run 'uname -a':
  
      juju ssh 1 uname -a
  
  Connect to the first mysql unit:
  
      juju ssh mysql/0
  
  Connect to the first mysql unit and run 'ls -la /var/log/juju':
  
      juju ssh mysql/0 ls -la /var/log/juju
  
  Connect to the first jenkins unit as the user jenkins:
  
      juju ssh jenkins@jenkins/0


^# ssh-key


  #### usage:

  
        juju list-ssh-keys [options]
  

  #### purpose:

   list authorised ssh keys in a model


  
  #### options:



  _--full  (= false)_  show full key instead of just the key fingerprint


  _-m, --model (= "")_  juju model to operate in
  
  List the authorized ssh keys in the model, allowing the holders of those keys to log on to Juju nodes.
  By default, just the key fingerprint is printed. Use --full to display the entire key.
  
  aliases: ssh-key, ssh-keys, list-ssh-key


^# ssh-keys


  #### usage:

  
        juju list-ssh-keys [options]
  

  #### purpose:

   list authorised ssh keys in a model


  
  #### options:



  _--full  (= false)_  show full key instead of just the key fingerprint


  _-m, --model (= "")_  juju model to operate in
  
  List the authorized ssh keys in the model, allowing the holders of those keys to log on to Juju nodes.
  By default, just the key fingerprint is printed. Use --full to display the entire key.
  
  aliases: ssh-key, ssh-keys, list-ssh-key


^# status


  #### usage:

  
        juju status [options] [pattern ...]
  

  #### purpose:

   output status information about a model


  
  #### options:



  _--format  (= tabular)_  specify output format (json|line|oneline|short|summary|tabular|yaml)


  _-m, --model (= "")_  juju model to operate in


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  This command will report on the runtime state of various system entities.
  
  There are a number of ways to format the status output:
  


  _- {short|line|oneline}: List units and their subordinates. For each_  unit, the IP address and agent status are listed.


  _- summary: Displays the subnet(s) and port(s) the model utilises._  Also displays aggregate information about:


  _- MACHINES: total #, and # in each state._

  _- UNITS: total #, and # in each state._

  _- SERVICES: total #, and # exposed of each service._

  _- tabular (DEFAULT): Displays information in a tabular format in these sections:_

  _- Machines: ID, STATE, DNS, INS-ID, SERIES, AZ_

  _- Services: NAME, EXPOSED, CHARM_

  _- Units: ID, STATE, VERSION, MACHINE, PORTS, PUBLIC-ADDRESS_

  _- Also displays subordinate units._

  _- yaml: Displays information on machines, services, and units_  in the yaml format.
  
  Note: AZ above is the cloud region's availability zone.
  
  Service or unit names may be specified to filter the status to only those
  services and units that match, along with the related machines, services
  and units. If a subordinate unit is matched, then its principal unit will
  be displayed. If a principal unit is matched, then all of its subordinates
  will be displayed.
  
  Wildcards ('*') may be specified in service/unit names to match any sequence
  of characters. For example, 'nova-*' will match any service whose name begins
  with 'nova-': 'nova-compute', 'nova-volume', etc.
  
  aliases: show-status


^# status-history


  #### usage:

  
        juju status-history [options] [-n N] <unit>
  

  #### purpose:

   output past statuses for a unit


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


  _-n  (= 20)_  size of logs backlog.


  _--type (= "combined")_  type of statuses to be displayed [agent|workload|combined].


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  This command will report the history of status changes for
  a given unit.
  The statuses for the unit workload and/or agent are available.


  _-type supports:_  agent: will show statuses for the unit's agent
  workload: will show statuses for the unit's workload
  combined: will show agent and workload statuses combined
  and sorted by time of occurrence.


^# storage


  #### usage:

  
        juju storage [options] <command> ...
  

  #### purpose:

   manage storage instances


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju storage" is used to manage storage instances in
  the Juju model.
  
  #### subcommands:

  add        - adds unit storage dynamically


  filesystem - manage storage filesystems


  help       - show help on a command or other topic


  list       - lists storage


  pool       - manage storage pools


  show       - shows storage instance


  volume     - manage storage volumes




^# subnet


  #### usage:

  
        juju subnet [options] <command> ...
  

  #### purpose:

   manage subnets


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju subnet" provides commands to manage Juju subnets. In Juju, a
  subnet is a logical address range, a subdivision of a network, defined
  by the subnet's Classless Inter-Domain Routing (CIDR) range, like
  10.10.0.0/24 or 2001:db8::/32. Alternatively, subnets can be
  identified uniquely by their provider-specific identifier
  (ProviderId), if the provider supports that. Subnets have two kinds of
  supported access: "public" (using shadow addresses) or "private"
  (using cloud-local addresses, this is the default). For more
  information about subnets and shadow addresses, please refer to Juju's
  glossary help topics ("juju help glossary").
  
  #### subcommands:

  add  - add an existing subnet to Juju


  help - show help on a command or other topic


  list - list subnets known to Juju




^# switch


  #### usage:

  
        juju switch [options] [model name]
  

  #### purpose:

   show or change the default juju model or controller name


  
  #### options:



  _-l, --list  (= false)_  list the model names
  
  Show or change the default juju model or controller name.
  
  If no command line parameters are passed, switch will output the current
  model as defined by the file $JUJU_DATA/current-model.
  
  If a command line parameter is passed in, that value will is stored in the
  current model file if it represents a valid model name as
  specified in the environments.yaml file.


^# sync-tools


  #### usage:

  
        juju sync-tools [options]
  

  #### purpose:

   copy tools from the official tool store into a local model


  
  #### options:



  _--all  (= false)_  copy all versions, not just the latest


  _--destination (= "")_  local destination directory


  _--dev  (= false)_  consider development versions as well as released ones
  DEPRECATED: use --stream instead


  _--dry-run  (= false)_  don't copy, just print what would be copied


  _--local-dir (= "")_  local destination directory


  _-m, --model (= "")_  juju model to operate in


  _--public  (= false)_  tools are for a public cloud, so generate mirrors information


  _--source (= "")_  local source directory


  _--stream (= "")_  simplestreams stream for which to sync metadata


  _--version (= "")_  copy a specific major[.minor] version
  
  This copies the Juju tools tarball from the official tools store (located
  at https://streams.canonical.com/juju) into your model.
  This is generally done when you want Juju to be able to run without having to
  access the Internet. Alternatively you can specify a local directory as source.
  
  Sometimes this is because the model does not have public access,
  and sometimes you just want to avoid having to access data outside of
  the local cloud.


^# unblock


  #### usage:

  
        juju unblock [options] destroy-model | remove-object | all-changes
  

  #### purpose:

   unblock an operation that would alter a running model


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Juju allows to safeguard deployed models from unintentional damage by preventing
  execution of operations that could alter model.
  
  This is done by blocking certain commands from successful execution. Blocked commands
  must be manually unblocked to proceed.
  
  Some commands offer a --force option that can be used to bypass a block.
  
  Commands that can be unblocked are grouped based on logical operations as follows:
  
  destroy-model includes command:
   - destroy-model
  
  remove-object includes termination commands:
   - destroy-model
   - remove-machine
   - remove-relation
   - remove-service
   - remove-unit
  
  all-changes includes all alteration commands
   - add-machine
   - add-relation
   - add-unit
   - authorised-keys add
   - authorised-keys delete
   - authorised-keys import
   - deploy
   - destroy-model
   - enable-ha
   - expose
   - remove-machine
   - remove-relation
   - remove-service
   - remove-unit
   - resolved
   - retry-provisioning
   - run
   - set
   - set-constraints
   - set-model-config
   - sync-tools
   - unexpose
   - unset
   - unset-model-config
   - upgrade-charm
   - upgrade-juju
   - add-user
   - change-user-password
   - disable-user
   - enable-user
  
  #### Examples: 

   To allow the model to be destroyed:
        juju unblock destroy-model


  To allow the machines, services, units and relations to be removed:
        juju unblock remove-object
  
  To allow changes to the model:
        juju unblock all-changes
  
  See Also:
  juju help block


^# unexpose


  #### usage:

  
        juju unexpose [options] <service>
  

  #### purpose:

   unexpose a service


  
  #### options:



  _-m, --model (= "")_  juju model to operate in


^# unset-model-config


  #### usage:

  
        juju unset-model-config [options] <model key> ...
  

  #### purpose:

   unset model values


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Reset one or more the model configuration attributes to its default
  value in a running Juju instance.  Attributes without defaults are removed,
  and attempting to remove a required attribute with no default will result
  in an error.
  
  Multiple attributes may be removed at once; keys should be space-separated.


^# unshare-model


  #### usage:

  
        juju unshare-model [options] <user> ...
  

  #### purpose:

   unshare the current model with a user


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Deny a user access to an model that was previously shared with them.
  
  #### Examples: 

        juju unshare-model joe
  Deny local user "joe" access to the current model

        juju unshare-model user1 user2 user3@ubuntuone
  
  Deny two local users and one remote user access to the current model
  
        juju unshare-model sam -m/--model myenv
  
  Deny local user "sam" access to the model named "mymodel"


^# update-allocation


  #### usage:

  
        juju update-allocation [options]
  

  #### purpose:

   update an allocation


  
  #### options:



  _-m, --model (= "")_  juju model to operate in
  
  Updates an existing allocation on a service.
  
  #### Example: 

        juju update-allocation wordpress 10
  Sets the allocation for the wordpress service to 10.


^# upgrade-charm


  #### usage:

  
        juju upgrade-charm [options] <service>
  

  #### purpose:

   upgrade a service's charm


  
  #### options:



  _--force-series  (= false)_  upgrade even if series of deployed services are not supported by the new charm


  _--force-units  (= false)_  upgrade all units immediately, even if in error state


  _-m, --model (= "")_  juju model to operate in


  _--path (= "")_  upgrade to a charm located at path


  _--repository (= "")_  local charm repository path


  _--revision  (= -1)_  explicit revision of current charm


  _--switch (= "")_  crossgrade to a different charm
  
  When no flags are set, the service's charm will be upgraded to the latest
  revision available in the repository from which it was originally deployed. An
  explicit revision can be chosen with the --revision flag.
  
  If the charm was not originally deployed from a repository, but from a path,
  then a path will need to be supplied to allow an updated copy of the charm
  to be located.
  
  If the charm came from a local repository, its path will be assumed to be
  $JUJU_REPOSITORY unless overridden by --repository. Note that deploying from
  a local repository is deprecated in favour of deploying from a path.
  
  Deploying from a path or local repository is intended to suit the workflow of a charm
  author working on a single client machine; use of this deployment method from
  multiple clients is not supported and may lead to confusing behaviour. Each
  local charm gets uploaded with the revision specified in the charm, if possible,
  otherwise it gets a unique revision (highest in state + 1).
  
  When deploying from a path, the --path flag is used to specify the location from
  which to load the updated charm. Note that the directory containing the charm must
  match what was originally used to deploy the charm as a superficial check that the
  updated charm is compatible.
  
  If the new version of a charm does not explicitly support the service's series, the
  upgrade is disallowed unless the --force-series flag is used. This option should be
  used with caution since using a charm on a machine running an unsupported series may
  cause unexpected behavior.
  
  When using a local repository, the --switch flag allows you to replace the charm
  with an entirely different one. The new charm's URL and revision are inferred as
  they would be when running a deploy command.
  
  Please note that --switch is dangerous, because juju only has limited
  information with which to determine compatibility; the operation will succeed,
  regardless of potential havoc, so long as the following conditions hold:
  


  _- The new charm must declare all relations that the service is currently_  participating in.


  _- All config settings shared by the old and new charms must_  have the same types.
  
  The new charm may add new relations and configuration settings.
  


  _--switch and --path are mutually exclusive._  


  _--path and --revision are mutually exclusive. The revision of the updated charm_  is determined by the contents of the charm at the specified path.
  


  _--switch and --revision are mutually exclusive. To specify a given revision_  number with --switch, give it in the charm URL, for instance "cs:wordpress-5"
  would specify revision number 5 of the wordpress charm.
  
  Use of the --force-units flag is not generally recommended; units upgraded while in an
  error state will not have upgrade-charm hooks executed, and may cause unexpected
  behavior.


^# upgrade-juju


  #### usage:

  
        juju upgrade-juju [options]
  

  #### purpose:

   upgrade the tools in a juju model


  
  #### options:



  _--dry-run  (= false)_  don't change anything, just report what would change


  _-m, --model (= "")_  juju model to operate in


  _--reset-previous-upgrade  (= false)_  clear the previous (incomplete) upgrade status (use with care)


  _--upload-tools  (= false)_  upload local version of tools


  _--version (= "")_  upgrade to specific version


  _-y, --yes  (= false)_  answer 'yes' to confirmation prompts
  
  The upgrade-juju command upgrades a running model by setting a version
  number for all juju agents to run. By default, it chooses the most recent
  supported version compatible with the command-line tools version.
  
  A development version is defined to be any version with an odd minor
  version or a nonzero build component (for example version 2.1.1, 3.3.0
  and 2.0.0.1 are development versions; 2.0.3 and 3.4.1 are not). A
  development version may be chosen in two cases:
  


  _- when the current agent version is a development one and there is_  a more recent version available with the same major.minor numbers;


  _- when an explicit --version major.minor is given (e.g. --version 1.17,_  or 1.17.2, but not just 1)
  
  For development use, the --upload-tools flag specifies that the juju tools will
  packaged (or compiled locally, if no jujud binaries exists, for which you will
  need the golang packages installed) and uploaded before the version is set.
  Currently the tools will be uploaded as if they had the version of the current
  juju tool, unless specified otherwise by the --version flag.
  
  When run without arguments. upgrade-juju will try to upgrade to the
  following versions, in order of preference, depending on the current
  value of the model's agent-version setting:
  


  _- The highest patch.build version of the *next* stable major.minor version._

  _- The highest patch.build version of the *current* major.minor version._  
  Both of these depend on tools availability, which some situations (no
  outgoing internet access) and provider types (such as maas) require that
  you manage yourself; see the documentation for "sync-tools".
  
  The upgrade-juju command will abort if an upgrade is already in
  progress. It will also abort if a previous upgrade was partially
  completed - this can happen if one of the controllers in a high
  availability model failed to upgrade. If a failed upgrade has
  been resolved, the --reset-previous-upgrade flag can be used to reset
  the model's upgrade tracking state, allowing further upgrades.


^# use-model


  #### usage:

  
        juju use-model [options]
  

  #### purpose:

   use an model that you have access to on the controller


  
  #### options:



  _-c, --controller (= "")_  juju controller to operate in


  _--name (= "")_  the local name for this model
  
  use-model caches the necessary information about the specified
  model on the current machine. This allows you to switch between
  models.
  
  By default, the local names for the model are based on the name that the
  owner of the model gave it when they created it.  If you are the owner
  of the model, then the local name is just the name of the model.
  If you are not the owner, the name is prefixed by the name of the owner and a
  dash.
  
  If there is just one model called "test" in the current controller that you
  have access to, then you can just specify the name.
  
        $ juju use-model test
  
  If however there are multiple models called "test" that are owned
  
   
        $ juju use-model test
  
        Multiple models matched name "test":
        cb4b94e8-29bb-44ae-820c-adac21194395, owned by bob@local
        ae673c19-73ef-437f-8224-4842a1772bdf, owned by mary@local
        Please specify either the model UUID or the owner to disambiguate.
        ERROR multiple models matched
  
  You can specify either the model UUID like this:
  
        $ juju use-model cb4b94e8-29bb-44ae-820c-adac21194395
  
  Or, specify the owner:
  
        $ juju use-model mary@local/test
  
  Since '@local' is the default for users, this can be shortened to:
  
        $ juju use-model mary/test
  
  
  See Also:
  juju help controllers
  juju help create-model
  juju help model share
  juju help model unshare
  juju help switch
  juju help add-user


^# version


  #### usage:

  
        juju version [options]
  

  #### purpose:

   print the current version


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file



