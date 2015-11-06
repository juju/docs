Title: Juju command reference


# Juju command reference

You can get a list of the currently used commands by entering
```juju help commands``` from the command line. The currently understood commands
are listed here, with usage and examples. (If you are looking for the commands 
which can be run by charms inside a hook environment, please see
[the Hook Environment documentation.](authors-hook-environment#hook-tools)
)

Click on the expander to see details for each command. 

^# action


  #### usage:

  ```
  juju action [options] <command> ...
  ```

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

  ```no-highlight
  juju machine add [options] [<container>:machine | <container> | ssh:[user@]host | placement]
  ```

  #### purpose:

   start a new, empty machine and optionally a container, or add a container to a machine


  
  #### options:



  _--constraints  (= )_  additional machine constraints


  _--disks  (= )_  constraints for disks to attach to the machine


  _-e, --environment (= "")_  juju environment to operate in


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

      juju machine add                      (starts a new machine)
      juju machine add -n 2                 (starts 2 new machines)
      juju machine add lxc                  (starts a new machine with an lxc container)
      juju machine add lxc -n 2             (starts 2 new machines with an lxc container)
      juju machine add lxc:4                (starts a new lxc container on machine 4)
      juju machine add --constraints mem=8G (starts a machine with at least 8GB RAM)
      juju machine add ssh:user@10.10.0.3   (manually provisions a machine with ssh)
      juju machine add zone=us-east-1a      (start a machine in zone us-east-1a on AWS)
      juju machine add maas2.name           (acquire machine maas2.name on MAAS)


  See Also:
  juju help constraints
  juju help placement


^# add-relation


  #### usage:

  ```no-highlight
  juju add-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  ```

  #### purpose:

   add a relation between two services


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


^# add-unit


  #### usage:

  ```no-highlight
  juju service add-unit [options] <service name>
  ```

  #### purpose:

   add one or more units of an already-deployed service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _-n, --num-units  (= 1)_  number of service units to add


  _--to (= "")_  the machine, container or placement directive to deploy the unit in, bypasses constraints
  
  Adding units to an existing service is a way to scale out an environment by
  deploying more instances of a service.  Add-unit must be called on services that
  have already been deployed via juju deploy.
  
  By default, services are deployed to newly provisioned machines.  Alternatively,
  service units can be added to a specific existing machine using the --to
  argument.
  
  #### Examples: 

      juju service add-unit mysql -n 5          (Add 5 mysql units on 5 new machines)
      juju service add-unit mysql --to 23       (Add a mysql unit to machine 23)
      juju service add-unit mysql --to 24/lxc/3 (Add unit to lxc container 3 on host machine 24)
      juju service add-unit mysql --to lxc:25   (Add unit to a new lxc container on host machine 25)


^# api-endpoints


  #### usage:

  ```no-highlight
  juju api-endpoints [options]
  ```

  #### purpose:

   print the API server address(es)


  
  #### options:



  _--all  (= false)_  display all known endpoints, not just the first one


  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file


  _--refresh  (= false)_  connect to the API to ensure an up-to-date endpoint location
  
  Returns the address(es) of the current API server formatted as host:port.
  
  Without arguments apt-endpoints returns the last endpoint used to successfully
  connect to the API server. If a cached endpoints information is available from
  the current environment's .jenv file, it is returned without trying to connect
  to the API server. When no cache is available or --refresh is given, api-endpoints
  connects to the API server, retrieves all known endpoints and updates the .jenv
  file before returning the first one. Example:
  $ juju api-endpoints
  10.0.3.1:17070
  
  If --all is given, api-endpoints returns all known endpoints. Example:
  $ juju api-endpoints --all
  10.0.3.1:17070
  localhost:170170
  
  The first endpoint is guaranteed to be an IP address and port. If a single endpoint
  is available and it's a hostname, juju tries to resolve it locally first.
  
  Additionally, you can use the --format argument to specify the output format.
  Supported formats are: "yaml", "json", or "smart" (default - host:port, one per line).


^# api-info


  #### usage:

  ```no-highlight
  juju api-info [options] [field ...]
  ```

  #### purpose:

   print the field values used to connect to the environment's API servers


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= default)_  specify output format (default|json|yaml)


  _-o, --output (= "")_  specify an output file


  _--password  (= false)_  include the password in the output fields


  _--refresh  (= false)_  connect to the API to ensure an up-to-date endpoint location
  
  Print the field values used to connect to the environment's API servers"
  
  The exact fields to output can be specified on the command line.  The
  available fields are:
  user
  password
  environ-uuid
  state-servers
  ca-cert
  
  If "password" is included as a field, or the --password option is given, the
  password value will be shown.
  
  
  #### Examples: 

      $ juju api-info
      user: admin
      environ-uuid: 373b309b-4a86-4f13-88e2-c213d97075b8
      state-servers:


  _- localhost:17070_

  _- 10.0.3.1:17070_

  _- 192.168.2.21:17070_      ca-cert: '-----BEGIN CERTIFICATE-----
      ...


  _-----END CERTIFICATE-----_      '


  $ juju api-info user
  admin
  
  $ juju api-info user password
  user: admin
  password: sekrit


^# authorised-keys


  #### usage:

  ```no-highlight
  juju authorized-keys [options] <command> ...
  ```

  #### purpose:

   manage authorised ssh keys


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju authorized-keys" is used to manage the ssh keys allowed to log on to
  nodes in the Juju environment.
  
  #### subcommands:

  add    - add new authorized ssh keys for a Juju user


  delete - delete authorized ssh keys for a Juju user


  help   - show help on a command or other topic


  import - using ssh-import-id, import new authorized ssh keys for a Juju user


  list   - list authorised ssh keys for a specified user


  


  aliases: authorised-keys




^# authorized-keys


  #### usage:

  ```no-highlight
  juju authorized-keys [options] <command> ...
  ```

  #### purpose:

   manage authorised ssh keys


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju authorized-keys" is used to manage the ssh keys allowed to log on to
  nodes in the Juju environment.
  
  #### subcommands:

  add    - add new authorized ssh keys for a Juju user


  delete - delete authorized ssh keys for a Juju user


  help   - show help on a command or other topic


  import - using ssh-import-id, import new authorized ssh keys for a Juju user


  list   - list authorised ssh keys for a specified user


  


  aliases: authorised-keys




^# backups


  #### usage:

  ```no-highlight
  juju backups [options] <command> ...
  ```

  #### purpose:

   create, manage, and restore backups of juju's state


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju backups" is used to manage backups of the state of a juju environment.
  
  #### subcommands:

  create   - create a backup


  download - get an archive file


  help     - show help on a command or other topic


  info     - get metadata


  list     - get all metadata


  remove   - delete a backup


  restore  - restore from a backup archive to a new state server


  upload   - store a backup archive file remotely in juju




^# block


  #### usage:

  ```no-highlight
  juju block [options] <command> ...
  ```

  #### purpose:

   list and enable environment blocks


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  Juju allows to safeguard deployed environments from unintentional damage by preventing
  execution of operations that could alter environment.
  
  This is done by blocking certain commands from successful execution. Blocked commands
  must be manually unblocked to proceed.
  
  "juju block" is used to list or to enable environment blocks in
  the Juju environment.
  
  #### subcommands:

  all-changes         - block operations that could change Juju environment


  destroy-environment - block an operation that would destroy Juju environment


  help                - show help on a command or other topic


  list                - list juju blocks


  remove-object       - block an operation that would remove an object




^# bootstrap


  #### usage:

  ```no-highlight
  juju bootstrap [options]
  ```

  #### purpose:

   start up an environment from scratch


  
  #### options:



  _--agent-version (= "")_  the version of tools to initially use for Juju agents


  _--constraints  (= )_  set environment constraints


  _-e, --environment (= "")_  juju environment to operate in


  _--keep-broken  (= false)_  do not destroy the environment if bootstrap fails


  _--metadata-source (= "")_  local path to use as tools and/or metadata source


  _--no-auto-upgrade  (= false)_  do not upgrade to newer tools on first bootstrap


  _--series  (= )_  see --upload-series (OBSOLETE)


  _--to (= "")_  a placement directive indicating an instance to bootstrap


  _--upload-series  (= )_  upload tools for supplied comma-separated series list (OBSOLETE)


  _--upload-tools  (= false)_  upload local version of tools before bootstrapping
  
  bootstrap starts a new environment of the current type (it will return an error
  if the environment has already been bootstrapped).  Bootstrapping an environment
  will provision a new machine in the environment and run the juju state server on
  that machine.
  
  If constraints are specified in the bootstrap command, they will apply to the
  machine provisioned for the juju state server.  They will also be set as default
  constraints on the environment for all future machines, exactly as if the
  constraints were set with juju set-constraints.
  
  It is possible to override constraints and the automatic machine selection
  algorithm by using the "--to" flag. The value associated with "--to" is a
  "placement directive", which tells Juju how to identify the first machine to use.
  For more information on placement directives, see "juju help placement".
  
  Bootstrap initialises the cloud environment synchronously and displays information
  about the current installation steps.  The time for bootstrap to complete varies
  across cloud providers from a few seconds to several minutes.  Once bootstrap has
  completed, you can run other juju commands against your environment. You can change
  the default timeout and retry delays used during the bootstrap by changing the
  following settings in your environments.yaml (all values represent number of seconds):
  
  # How long to wait for a connection to the state server.
  bootstrap-timeout: 600 # default: 10 minutes
  # How long to wait between connection attempts to a state server address.
  bootstrap-retry-delay: 5 # default: 5 seconds
  # How often to refresh state server addresses from the API server.
  bootstrap-addresses-delay: 10 # default: 10 seconds
  
  Private clouds may need to specify their own custom image metadata, and
  possibly upload Juju tools to cloud storage if no outgoing Internet access is
  available. In this case, use the --metadata-source parameter to point
  bootstrap to a local directory from which to upload tools and/or image
  metadata.
  
  If agent-version is specifed, this is the default tools version to use when running the Juju agents.
  Only the numeric version is relevant. To enable ease of scripting, the full binary version
  is accepted (eg 1.24.4-trusty-amd64) but only the numeric version (eg 1.24.4) is used.
  An alias for bootstrapping Juju with the exact same version as the client is to use the


  _--no-auto-upgrade parameter._  
  See Also:
  juju help switch
  juju help constraints
  juju help set-constraints
  juju help placement


^# cached-images


  #### usage:

  ```no-highlight
  juju cached-images [options] <command> ...
  ```

  #### purpose:

   manage cached os images


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju cached-images" is used to manage the cached os images in
  the Juju environment.
  
  #### subcommands:

  delete - delete cached os images


  help   - show help on a command or other topic


  list   - shows cached os images




^# debug-hooks


  #### usage:

  ```no-highlight
  juju debug-hooks [options] <unit name> [hook names]
  ```

  #### purpose:

   launch a tmux session to debug a hook


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--proxy  (= true)_  proxy through the API server


  _--pty  (= true)_  enable pseudo-tty allocation
  
  Interactively debug a hook remotely on a service unit.


^# debug-log


  #### usage:

  ```no-highlight
  juju debug-log [options]
  ```

  #### purpose:

   display the consolidated log file


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--exclude-module  (= )_  do not show log messages for these logging modules


  _-i, --include  (= )_  only show log messages for these entities


  _--include-module  (= )_  only show log messages for these logging modules


  _-l, --level (= "")_  log level to show, one of [TRACE, DEBUG, INFO, WARNING, ERROR]


  _--limit  (= 0)_  show at most this many lines


  _-n, --lines  (= 10)_  go back this many lines from the end before starting to filter


  _--replay  (= false)_  start filtering from the start


  _-x, --exclude  (= )_  do not show log messages for these entities
  
  Stream the consolidated debug log file. This file contains the log messages
  from all nodes in the environment.


^# deploy


  #### usage:

  ```no-highlight
  juju deploy [options] <charm name> [<service name>]
  ```

  #### purpose:

   deploy a new service


  
  #### options:



  _--config  (= )_  path to yaml-formatted service config


  _--constraints  (= )_  set service constraints


  _-e, --environment (= "")_  juju environment to operate in


  _-n, --num-units  (= 1)_  number of service units to deploy for principal charms


  _--networks (= "")_  deprecated and ignored: use space constraints instead.


  _--repository (= "")_  local charm repository


  _--storage  (= )_  charm storage constraints


  _--to (= "")_  the machine, container or placement directive to deploy the unit in, bypasses constraints


  _-u, --upgrade  (= false)_  increment local charm directory revision (DEPRECATED)
  
  <charm name> can be a charm URL, or an unambiguously condensed form of it;
  assuming a current series of "precise", the following forms will be accepted:
  
  For cs:precise/mysql
  mysql
  precise/mysql
  
  For cs:~user/precise/mysql
  cs:~user/mysql
  
  The current series is determined first by the default-series environment
  setting, followed by the preferred series for the charm in the charm store.
  
  In these cases, a versioned charm URL will be expanded as expected (for example,
  mysql-33 becomes cs:precise/mysql-33).
  
  However, for local charms, when the default-series is not specified in the
  environment, one must specify the series. For example:
  local:precise/mysql
  
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


^# destroy-environment


  #### usage:

  ```no-highlight
  juju destroy-environment [options] <environment name>
  ```

  #### purpose:

   terminate all machines and other associated resources for an environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--force  (= false)_  Forcefully destroy the environment, directly through the environment provider


  _-y, --yes  (= false)_  Do not ask for confirmation


^# destroy-machine


  #### usage:

  ```no-highlight
  juju machine remove [options] <machine> ...
  ```

  #### purpose:

   remove machines from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--force  (= false)_  completely remove machine and all dependencies
  
  Machines that are responsible for the environment cannot be removed. Machines
  running units or containers can only be removed with the --force flag; doing
  so will also remove all those units and containers without giving them any
  opportunity to shut down cleanly.
  
  #### Examples: 

      # Remove machine number 5 which has no running units or containers
      $ juju machine remove 5


  # Remove machine 6 and any running units or containers
  $ juju machine remove 6 --force


^# destroy-relation


  #### usage:

  ```no-highlight
  juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  ```

  #### purpose:

   remove a relation between two services


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  aliases: destroy-relation


^# destroy-service


  #### usage:

  ```no-highlight
  juju remove-service [options] <service>
  ```

  #### purpose:

   remove a service from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Removing a service will remove all its units and relations.
  
  If this is the only service running, the machine on which
  the service is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a state server_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-service


^# destroy-unit


  #### usage:

  ```no-highlight
  juju remove-unit [options] <unit> [...]
  ```

  #### purpose:

   remove service units from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Remove service units from the environment.
  
  If this is the only unit running, the machine on which
  the unit is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a state server_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-unit


^# ensure-availability


  #### usage:

  ```no-highlight
  juju ensure-availability [options]
  ```

  #### purpose:

   ensure that sufficient state servers exist to provide redundancy


  
  #### options:



  _--constraints  (= )_  additional machine constraints


  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= simple)_  specify output format (json|simple|yaml)


  _-n  (= 0)_  number of state servers to make available


  _-o, --output (= "")_  specify an output file


  _--series (= "")_  the charm series


  _--to (= "")_  the machine(s) to become state servers, bypasses constraints
  
  To ensure availability of deployed services, the Juju infrastructure
  must itself be highly available.  Ensure-availability must be called
  to ensure that the specified number of state servers are made available.
  
  An odd number of state servers is required.
  
  #### Examples: 

      juju ensure-availability
      Ensure that the system is still in highly available mode. If
      there is only 1 state server running, this will ensure there
      are 3 running. If you have previously requested more than 3,
      then that number will be ensured.
      juju ensure-availability -n 5 --series=trusty
      Ensure that 5 state servers are available, with newly created
      state server machines having the "trusty" series.
      juju ensure-availability -n 7 --constraints mem=8G
      Ensure that 7 state servers are available, with newly created
      state server machines having the default series, and at least
      8GB RAM.
      juju ensure-availability -n 7 --to server1,server2 --constraints mem=8G
      Ensure that 7 state servers are available, with machines server1 and
      server2 used first, and if necessary, newly created state server
      machines having the default series, and at least 8GB RAM.


^# env


  #### usage:

  ```no-highlight
  juju switch [options] [environment name]
  ```

  #### purpose:

   show or change the default juju environment or system name


  
  #### options:



  _-l, --list  (= false)_  list the environment names
  
  Show or change the default juju environment or system name.
  
  If no command line parameters are passed, switch will output the current
  environment as defined by the file $JUJU_HOME/current-environment.
  
  If a command line parameter is passed in, that value will is stored in the
  current environment file if it represents a valid environment name as
  specified in the environments.yaml file.
  
  aliases: env


^# environment


  #### usage:

  ```no-highlight
  juju environment [options] <command> ...
  ```

  #### purpose:

   manage environments


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju environment" provides commands to interact with the Juju environment.
  
  #### subcommands:

  get                - view environment values


  get-constraints    - view constraints on the environment


  help               - show help on a command or other topic


  jenv               - import previously generated Juju environment files


  retry-provisioning - retries provisioning for failed machines


  set                - replace environment values


  set-constraints    - set constraints on the environment


  unset              - unset environment values




^# expose


  #### usage:

  ```no-highlight
  juju expose [options] <service>
  ```

  #### purpose:

   expose a service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Adjusts firewall rules and similar security mechanisms of the provider, to
  allow the service to be accessed on its public address.


^# generate-config


  #### usage:

  ```no-highlight
  juju init [options]
  ```

  #### purpose:

   generate boilerplate configuration for juju environments


  
  #### options:



  _-f  (= false)_  force overwriting environments.yaml file even if it exists (ignored if --show flag specified)


  _--show  (= false)_  print the generated configuration data to stdout instead of writing it to a file
  
  aliases: generate-config


^# get


  #### usage:

  ```no-highlight
  juju service get [options] <service>
  ```

  #### purpose:

   get service configuration options


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= yaml)_  specify output format (yaml)


  _-o, --output (= "")_  specify an output file
  
  The command output includes the service and charm names, a detailed list of all config
  settings for <service>, including the setting name, whether it uses the default value
  or not ("default: true"), description (if set), type, and current value. Example:
  
  $ juju service get wordpress
  
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
  
  NOTE: In the example above the descriptions and most other settings were omitted for
  brevity. The "engine" setting was left at its default value ("nginx"), while the
  "tuning" setting was set to "optimized" (the default value is "single").


^# get-constraints


  #### usage:

  ```no-highlight
  juju get-constraints [options] [<service>]
  ```

  #### purpose:

   view constraints on the environment or a service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= constraints)_  specify output format (constraints|json|yaml)


  _-o, --output (= "")_  specify an output file
  
  get-constraints returns a list of constraints that have been set on
  the environment using juju set-constraints.  You can also view constraints set
  for a specific service by using juju get-constraints <service>.
  
  See Also:
  juju help constraints
  juju help set-constraints


^# get-env


  #### usage:

  ```no-highlight
  juju environment get [options] [<environment key>]
  ```

  #### purpose:

   view environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file
  
  If no extra args passed on the command line, all configuration keys and values
  for the environment are output using the selected formatter.
  
  A single environment value can be output by adding the environment key name to
  the end of the command line.
  
  #### Example: 



  juju environment get default-series  (returns the default series for the environment)


^# get-environment


  #### usage:

  ```no-highlight
  juju environment get [options] [<environment key>]
  ```

  #### purpose:

   view environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file
  
  If no extra args passed on the command line, all configuration keys and values
  for the environment are output using the selected formatter.
  
  A single environment value can be output by adding the environment key name to
  the end of the command line.
  
  #### Example: 



  juju environment get default-series  (returns the default series for the environment)


^# help


  #### usage:

  ```no-highlight
  juju help [topic]
  ```

  #### purpose:

   show help on a command or other topic


  
  See also: topics


^# help-tool


  #### usage:

  ```no-highlight
  juju help-tool [tool]
  ```

  #### purpose:

   show help on a juju charm tool




^# init


  #### usage:

  ```no-highlight
  juju init [options]
  ```

  #### purpose:

   generate boilerplate configuration for juju environments


  
  #### options:



  _-f  (= false)_  force overwriting environments.yaml file even if it exists (ignored if --show flag specified)


  _--show  (= false)_  print the generated configuration data to stdout instead of writing it to a file
  
  aliases: generate-config


^# list-payloads


  #### usage:

  ```no-highlight
  juju list-payloads [options] [pattern ...]
  ```

  #### purpose:

   display status information about known payloads


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= tabular)_  specify output format (json|tabular|yaml)


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

^# machine


  #### usage:

  ```no-highlight
  juju machine [options] <command> ...
  ```

  #### purpose:

   manage machines


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju machine" provides commands to add and remove machines in the Juju environment.
  
  #### subcommands:

  add    - start a new, empty machine and optionally a container, or add a container to a machine


  help   - show help on a command or other topic


  remove - remove machines from the environment




^# publish


  #### usage:

  ```no-highlight
  juju publish [options] [<charm url>]
  ```

  #### purpose:

   publish charm to the store


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--from (= ".")_  path for charm to be published
  
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


^# remove-machine


  #### usage:

  ```no-highlight
  juju machine remove [options] <machine> ...
  ```

  #### purpose:

   remove machines from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--force  (= false)_  completely remove machine and all dependencies
  
  Machines that are responsible for the environment cannot be removed. Machines
  running units or containers can only be removed with the --force flag; doing
  so will also remove all those units and containers without giving them any
  opportunity to shut down cleanly.
  
  #### Examples: 

      # Remove machine number 5 which has no running units or containers
      $ juju machine remove 5


  # Remove machine 6 and any running units or containers
  $ juju machine remove 6 --force


^# remove-relation


  #### usage:

  ```no-highlight
  juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  ```

  #### purpose:

   remove a relation between two services


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  aliases: destroy-relation


^# remove-service


  #### usage:

  ```no-highlight
  juju remove-service [options] <service>
  ```

  #### purpose:

   remove a service from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Removing a service will remove all its units and relations.
  
  If this is the only service running, the machine on which
  the service is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a state server_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-service


^# remove-unit


  #### usage:

  ```no-highlight
  juju remove-unit [options] <unit> [...]
  ```

  #### purpose:

   remove service units from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Remove service units from the environment.
  
  If this is the only unit running, the machine on which
  the unit is hosted will also be destroyed, if possible.
  The machine will be destroyed if:


  _- it is not a state server_

  _- it is not hosting any Juju managed containers_  
  aliases: destroy-unit


^# resolved


  #### usage:

  ```no-highlight
  juju resolved [options] <unit>
  ```

  #### purpose:

   marks unit errors resolved


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _-r, --retry  (= false)_  re-execute failed hooks


^# retry-provisioning


  #### usage:

  ```no-highlight
  juju environment retry-provisioning [options] <machine> [...]
  ```

  #### purpose:

   retries provisioning for failed machines


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


^# run


  #### usage:

  ```no-highlight
  juju run [options] <commands>
  ```

  #### purpose:

   run the commands on the remote targets specified


  
  #### options:



  _--all  (= false)_  run the commands on all the machines


  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= smart)_  specify output format (json|smart|yaml)


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
  


  _--all is provided as a simple way to run the command on all the machines_  in the environment.  If you specify --all you cannot provide additional
  targets.


^# scp


  #### usage:

  ```no-highlight
  juju scp [options] <file1> ... <file2> [scp-option...]
  ```

  #### purpose:

   launch a scp command to copy files to/from remote machine(s)


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


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
  
  Copy a local file to the second apache unit of the environment "testing":
  
  juju scp -e testing foo.txt apache2/1:


^# service


  #### usage:

  ```no-highlight
  juju service [options] <command> ...
  ```

  #### purpose:

   manage services


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju service" provides commands to manage Juju services.
  
  #### subcommands:

  add-unit        - add one or more units of an already-deployed service


  get             - get service configuration options


  get-constraints - view constraints on a service


  help            - show help on a command or other topic


  set             - set service config options


  set-constraints - set constraints on a service


  unset           - set service config options back to their default




^# set


  #### usage:

  ```no-highlight
  juju service set [options] <service> name=value ...
  ```

  #### purpose:

   set service config options


  
  #### options:



  _--config  (= )_  path to yaml-formatted service config


  _-e, --environment (= "")_  juju environment to operate in
  
  Set one or more configuration options for the specified service. See also the
  unset command which sets one or more configuration options for a specified
  service to their default value.
  
  In case a value starts with an at sign (@) the rest of the value is interpreted
  as a filename. The value itself is then read out of the named file. The maximum
  size of this value is 5M.
  
  Option values may be any UTF-8 encoded string. UTF-8 is accepted on the command
  line and in configuration files.


^# set-constraints


  #### usage:

  ```no-highlight
  juju set-constraints [options] [key=[value] ...]
  ```

  #### purpose:

   set constraints on the environment or a service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _-s, --service (= "")_  set service constraints
  
  set-constraints sets machine constraints on the system, which are used as the
  default constraints for all new machines provisioned in the environment (unless
  overridden).  You can also set constraints on a specific service by using juju
  set-constraints <service>.
  
  Constraints set on a service are combined with environment constraints for
  commands (such as juju deploy) that provision machines for services.  Where
  environment and service constraints overlap, the service constraints take
  precedence.
  
  #### Examples: 



  set-constraints mem=8G                         (all new machines in the environment must have at least 8GB of RAM)
  set-constraints --service wordpress mem=4G     (all new wordpress machines can ignore the 8G constraint above, and require only 4G)
  
  See Also:
  juju help constraints
  juju help get-constraints
  juju help deploy
  juju help add-machine
  juju help add-unit


^# set-env


  #### usage:

  ```no-highlight
  juju environment set [options] key=[value] ...
  ```

  #### purpose:

   replace environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Updates the environment of a running Juju instance.  Multiple key/value pairs
  can be passed on as command line arguments.


^# set-environment


  #### usage:

  ```no-highlight
  juju environment set [options] key=[value] ...
  ```

  #### purpose:

   replace environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Updates the environment of a running Juju instance.  Multiple key/value pairs
  can be passed on as command line arguments.


^# space


  #### usage:

  ```no-highlight
  juju space [options] <command> ...
  ```

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
  bootstrapping a new environment using shared credentials (multiple
  users or roles, same substrate).
  
  #### subcommands:

  create - create a new network space


  help   - show help on a command or other topic


  list   - list spaces known to Juju, including associated subnets




^# ssh


  #### usage:

  ```no-highlight
  juju ssh [options] <target> [<ssh args>...]
  ```

  #### purpose:

   launch an ssh shell on a given unit or machine


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


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


^# stat


  #### usage:

  ```no-highlight
  juju status [options] [pattern ...]
  ```

  #### purpose:

   output status information about an environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= yaml)_  specify output format (json|line|oneline|short|summary|tabular|yaml)


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  This command will report on the runtime state of various system entities.
  
  There are a number of ways to format the status output:
  


  _- {short|line|oneline}: List units and their subordinates. For each_  unit, the IP address and agent status are listed.


  _- summary: Displays the subnet(s) and port(s) the environment utilises._  Also displays aggregate information about:


  _- MACHINES: total #, and # in each state._

  _- UNITS: total #, and # in each state._

  _- SERVICES: total #, and # exposed of each service._

  _- tabular: Displays information in a tabular format in these sections:_

  _- Machines: ID, STATE, VERSION, DNS, INS-ID, SERIES, HARDWARE_

  _- Services: NAME, EXPOSED, CHARM_

  _- Units: ID, STATE, VERSION, MACHINE, PORTS, PUBLIC-ADDRESS_

  _- Also displays subordinate units._

  _- yaml (DEFAULT): Displays information on machines, services, and units_  in the yaml format.
  
  Service or unit names may be specified to filter the status to only those
  services and units that match, along with the related machines, services
  and units. If a subordinate unit is matched, then its principal unit will
  be displayed. If a principal unit is matched, then all of its subordinates
  will be displayed.
  
  Wildcards ('*') may be specified in service/unit names to match any sequence
  of characters. For example, 'nova-*' will match any service whose name begins
  with 'nova-': 'nova-compute', 'nova-volume', etc.
  
  aliases: stat


^# status


  #### usage:

  ```no-highlight
  juju status [options] [pattern ...]
  ```

  #### purpose:

   output status information about an environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= yaml)_  specify output format (json|line|oneline|short|summary|tabular|yaml)


  _-o, --output (= "")_  specify an output file


  _--utc  (= false)_  display time as UTC in RFC3339 format
  
  This command will report on the runtime state of various system entities.
  
  There are a number of ways to format the status output:
  


  _- {short|line|oneline}: List units and their subordinates. For each_  unit, the IP address and agent status are listed.


  _- summary: Displays the subnet(s) and port(s) the environment utilises._  Also displays aggregate information about:


  _- MACHINES: total #, and # in each state._

  _- UNITS: total #, and # in each state._

  _- SERVICES: total #, and # exposed of each service._

  _- tabular: Displays information in a tabular format in these sections:_

  _- Machines: ID, STATE, VERSION, DNS, INS-ID, SERIES, HARDWARE_

  _- Services: NAME, EXPOSED, CHARM_

  _- Units: ID, STATE, VERSION, MACHINE, PORTS, PUBLIC-ADDRESS_

  _- Also displays subordinate units._

  _- yaml (DEFAULT): Displays information on machines, services, and units_  in the yaml format.
  
  Service or unit names may be specified to filter the status to only those
  services and units that match, along with the related machines, services
  and units. If a subordinate unit is matched, then its principal unit will
  be displayed. If a principal unit is matched, then all of its subordinates
  will be displayed.
  
  Wildcards ('*') may be specified in service/unit names to match any sequence
  of characters. For example, 'nova-*' will match any service whose name begins
  with 'nova-': 'nova-compute', 'nova-volume', etc.
  
  aliases: stat


^# status-history


  #### usage:

  ```no-highlight
  juju status-history [options] [-n N] <unit>
  ```

  #### purpose:

   output past statuses for a unit


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


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

  ```no-highlight
  juju storage [options] <command> ...
  ```

  #### purpose:

   manage storage instances


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju storage" is used to manage storage instances in
  the Juju environment.
  
  #### subcommands:

  add    - adds unit storage dynamically


  help   - show help on a command or other topic


  list   - lists storage


  pool   - manage storage pools


  show   - shows storage instance


  volume - manage storage volumes




^# subnet


  #### usage:

  ```no-highlight
  juju subnet [options] <command> ...
  ```

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

  ```no-highlight
  juju switch [options] [environment name]
  ```

  #### purpose:

   show or change the default juju environment or system name


  
  #### options:



  _-l, --list  (= false)_  list the environment names
  
  Show or change the default juju environment or system name.
  
  If no command line parameters are passed, switch will output the current
  environment as defined by the file $JUJU_HOME/current-environment.
  
  If a command line parameter is passed in, that value will is stored in the
  current environment file if it represents a valid environment name as
  specified in the environments.yaml file.
  
  aliases: env


^# sync-tools


  #### usage:

  ```no-highlight
  juju sync-tools [options]
  ```

  #### purpose:

   copy tools from the official tool store into a local environment


  
  #### options:



  _--all  (= false)_  copy all versions, not just the latest


  _--destination (= "")_  local destination directory


  _--dev  (= false)_  consider development versions as well as released ones
  DEPRECATED: use --stream instead


  _--dry-run  (= false)_  don't copy, just print what would be copied


  _-e, --environment (= "")_  juju environment to operate in


  _--local-dir (= "")_  local destination directory


  _--public  (= false)_  tools are for a public cloud, so generate mirrors information


  _--source (= "")_  local source directory


  _--stream (= "")_  simplestreams stream for which to sync metadata


  _--version (= "")_  copy a specific major[.minor] version
  
  This copies the Juju tools tarball from the official tools store (located
  at https://streams.canonical.com/juju) into your environment.
  This is generally done when you want Juju to be able to run without having to
  access the Internet. Alternatively you can specify a local directory as source.
  
  Sometimes this is because the environment does not have public access,
  and sometimes you just want to avoid having to access data outside of
  the local cloud.


^# terminate-machine


  #### usage:

  ```no-highlight
  juju machine remove [options] <machine> ...
  ```

  #### purpose:

   remove machines from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--force  (= false)_  completely remove machine and all dependencies
  
  Machines that are responsible for the environment cannot be removed. Machines
  running units or containers can only be removed with the --force flag; doing
  so will also remove all those units and containers without giving them any
  opportunity to shut down cleanly.
  
  #### Examples: 

      # Remove machine number 5 which has no running units or containers
      $ juju machine remove 5


  # Remove machine 6 and any running units or containers
  $ juju machine remove 6 --force


^# unblock


  #### usage:

  ```no-highlight
  juju unblock [options] destroy-environment | remove-object | all-changes
  ```

  #### purpose:

   unblock an operation that would alter a running environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Juju allows to safeguard deployed environments from unintentional damage by preventing
  execution of operations that could alter environment.
  
  This is done by blocking certain commands from successful execution. Blocked commands
  must be manually unblocked to proceed.
  
  Some commands offer a --force option that can be used to bypass a block.
  
  Commands that can be unblocked are grouped based on logical operations as follows:
  
  destroy-environment includes command:
  destroy-environment
  
  remove-object includes termination commands:
  destroy-environment
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
  destroy-environment
  ensure-availability
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
  set-env
  sync-tools
  unexpose
  unset
  unset-env
  upgrade-charm
  upgrade-juju
  user add
  user change-password
  user disable
  user enable
  
  #### Examples: 

      To allow the environment to be destroyed:
      juju unblock destroy-environment


  To allow the machines, services, units and relations to be removed:
  juju unblock remove-object
  
  To allow changes to the environment:
  juju unblock all-changes
  
  See Also:
  juju help block


^# unexpose


  #### usage:

  ```no-highlight
  juju unexpose [options] <service>
  ```

  #### purpose:

   unexpose a service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


^# unset


  #### usage:

  ```no-highlight
  juju service unset [options] <service> name ...
  ```

  #### purpose:

   set service config options back to their default


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Set one or more configuration options for the specified service to their
  default. See also the set command to set one or more configuration options for
  a specified service.


^# unset-env


  #### usage:

  ```no-highlight
  juju environment unset [options] <environment key> ...
  ```

  #### purpose:

   unset environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Reset one or more the environment configuration attributes to its default
  value in a running Juju instance.  Attributes without defaults are removed,
  and attempting to remove a required attribute with no default will result
  in an error.
  
  Multiple attributes may be removed at once; keys should be space-separated.


^# unset-environment


  #### usage:

  ```no-highlight
  juju environment unset [options] <environment key> ...
  ```

  #### purpose:

   unset environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Reset one or more the environment configuration attributes to its default
  value in a running Juju instance.  Attributes without defaults are removed,
  and attempting to remove a required attribute with no default will result
  in an error.
  
  Multiple attributes may be removed at once; keys should be space-separated.


^# upgrade-charm


  #### usage:

  ```no-highlight
  juju upgrade-charm [options] <service>
  ```

  #### purpose:

   upgrade a service's charm


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--force  (= false)_  upgrade all units immediately, even if in error state


  _--repository (= "")_  local charm repository path


  _--revision  (= -1)_  explicit revision of current charm


  _--switch (= "")_  crossgrade to a different charm
  
  When no flags are set, the service's charm will be upgraded to the latest
  revision available in the repository from which it was originally deployed. An
  explicit revision can be chosen with the --revision flag.
  
  If the charm came from a local repository, its path will be assumed to be
  $JUJU_REPOSITORY unless overridden by --repository.
  
  The local repository behaviour is tuned specifically to the workflow of a charm
  author working on a single client machine; use of local repositories from
  multiple clients is not supported and may lead to confusing behaviour. Each
  local charm gets uploaded with the revision specified in the charm, if possible,
  otherwise it gets a unique revision (highest in state + 1).
  
  The --switch flag allows you to replace the charm with an entirely different
  one. The new charm's URL and revision are inferred as they would be when running
  a deploy command.
  
  Please note that --switch is dangerous, because juju only has limited
  information with which to determine compatibility; the operation will succeed,
  regardless of potential havoc, so long as the following conditions hold:
  


  _- The new charm must declare all relations that the service is currently_  participating in.


  _- All config settings shared by the old and new charms must_  have the same types.
  
  The new charm may add new relations and configuration settings.
  


  _--switch and --revision are mutually exclusive. To specify a given revision_  number with --switch, give it in the charm URL, for instance "cs:wordpress-5"
  would specify revision number 5 of the wordpress charm.
  
  Use of the --force flag is not generally recommended; units upgraded while in an
  error state will not have upgrade-charm hooks executed, and may cause unexpected
  behavior.


^# upgrade-juju


  #### usage:

  ```no-highlight
  juju upgrade-juju [options]
  ```

  #### purpose:

   upgrade the tools in a juju environment


  
  #### options:



  _--dry-run  (= false)_  don't change anything, just report what would change


  _-e, --environment (= "")_  juju environment to operate in


  _--reset-previous-upgrade  (= false)_  clear the previous (incomplete) upgrade status (use with care)


  _--series  (= )_  upload tools for supplied comma-separated series list (OBSOLETE)


  _--upload-tools  (= false)_  upload local version of tools


  _--version (= "")_  upgrade to specific version


  _-y, --yes  (= false)_  answer 'yes' to confirmation prompts
  
  The upgrade-juju command upgrades a running environment by setting a version
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
  value of the environment's agent-version setting:
  


  _- The highest patch.build version of the *next* stable major.minor version._

  _- The highest patch.build version of the *current* major.minor version._  
  Both of these depend on tools availability, which some situations (no
  outgoing internet access) and provider types (such as maas) require that
  you manage yourself; see the documentation for "sync-tools".
  
  The upgrade-juju command will abort if an upgrade is already in
  progress. It will also abort if a previous upgrade was partially
  completed - this can happen if one of the state servers in a high
  availability environment failed to upgrade. If a failed upgrade has
  been resolved, the --reset-previous-upgrade flag can be used to reset
  the environment's upgrade tracking state, allowing further upgrades.


^# user


  #### usage:

  ```no-highlight
  juju user [options] <command> ...
  ```

  #### purpose:

   manage user accounts and access control


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju user" is used to manage the user accounts and access control in
  the Juju environment.
  
  See Also:
  juju help users
  
  #### subcommands:

  add             - adds a user


  change-password - changes the password for a user


  credentials     - save the credentials and server details to a file


  disable         - disable a user to stop the user logging in


  enable          - reenables a disabled user to allow the user to log in


  help            - show help on a command or other topic


  info            - shows information on a user


  list            - shows all users




^# version


  #### usage:

  ```no-highlight
  juju version [options]
  ```

  #### purpose:

   print the current version


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file

