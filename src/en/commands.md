Title:Juju commands and usage

# Juju Command reference

You can get a list of the currently used commands by entering
```juju help commands``` from the commandline. The currently understood commands
are listed here, with usage and examples.

Click on the expander to see details for each command. 

^# add-machine


  #### usage:

  ```
  juju add-machine [options] [<container>:machine | <container> | ssh:[user@]host | placement]
  ```

  #### purpose:

   start a new, empty machine and optionally a container, or add a container to a machine


  
  #### options:



  _--constraints  (= )_  additional machine constraints


  _-e, --environment (= "")_  juju environment to operate in


  _-n  (= 1)_  The number of machines to add


  _--series (= "")_  the charm series
  
  Juju supports adding machines using provider-specific machine instances
  (EC2 instances, OpenStack servers, MAAS nodes, etc.); existing machines
  running a supported operating system (see "manual provisioning" below),
  and containers on machines. Machines are created in a clean state and
  ready to have units deployed.
  
  Without any parameters, add-machine will allocate a new provider-specific
  machine (multiple, if "-n" is provided). When adding a new machine, you
  may specify constraints for the machine to be provisioned; the provider
  will interpret these constraints in order to decide what kind of machine
  to allocate.
  
  If a container type is specified (e.g. "lxc"), then add-machine will
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
  "placement directives" with "--to"; these give the provider additional
  information about how to allocate the machine. For example, one can direct the
  MAAS provider to acquire a particular node by specifying its hostname with
  "--to". For more information on placement directives, see "juju help placement".
  
  #### Examples: 

      juju add-machine                      (starts a new machine)
      juju add-machine -n 2                 (starts 2 new machines)
      juju add-machine lxc                  (starts a new machine with an lxc container)
      juju add-machine lxc -n 2             (starts 2 new machines with an lxc container)
      juju add-machine lxc:4                (starts a new lxc container on machine 4)
      juju add-machine --constraints mem=8G (starts a machine with at least 8GB RAM)
      juju add-machine ssh:user@10.10.0.3   (manually provisions a machine with ssh)
      juju add-machine zone=us-east-1a


  See Also:

    - juju help constraints
    - juju help placement


^# add-relation


  #### usage:

  ```
  juju add-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  ```

  #### purpose:

   add a relation between two services


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


^# add-unit


  #### usage:

  ```
  juju add-unit [options] <service name>
  ```

  #### purpose:

   add one or more units of an already-deployed service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _-n, --num-units  (= 1)_  number of service units to add


  _--to (= "")_  the machine or container to deploy the unit in, bypasses constraints
  
  Adding units to an existing service is a way to scale out an environment by
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


^# api-endpoints


  #### usage:

  ```
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

  ```
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

  ```
  juju authorized-keys [options] <command> ...
  ```

  #### purpose:

   manage authorized ssh keys


  
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


  list   - list authorized ssh keys for a specified user


  


  aliases: authorised-keys




^# authorized-keys


  #### usage:

  ```
  juju authorized-keys [options] <command> ...
  ```

  #### purpose:

   manage authorized ssh keys


  
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


  list   - list authorized ssh keys for a specified user


  


  aliases: authorised-keys




^# bootstrap


  #### usage:

  ```
  juju bootstrap [options]
  ```

  #### purpose:

   start up an environment from scratch


  
  #### options:



  _--constraints  (= )_  set environment constraints


  _-e, --environment (= "")_  juju environment to operate in


  _--keep-broken  (= false)_  do not destroy the environment if bootstrap fails


  _--metadata-source (= "")_  local path to use as tools and/or metadata source


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
  
  Bootstrap initializes the cloud environment synchronously and displays information
  about the current installation steps.  The time for bootstrap to complete varies
  across cloud providers from a few seconds to several minutes.  Once bootstrap has
  completed, you can run other juju commands against your environment. You can change
  the default timeout and retry delays used during the bootstrap by changing the
  following settings in your environments.yaml (all values represent number of seconds):
  
  
      # How long to wait for a connection to the state server:
      bootstrap-timeout: 600 # default: 10 minutes
      # How long to wait between connection attempts to a state server address:
      bootstrap-retry-delay: 5 # default: 5 seconds
      # How often to refresh state server addresses from the API server.
      bootstrap-addresses-delay: 10 # default: 10 seconds
  
  Private clouds may need to specify their own custom image metadata, and possibly upload
  Juju tools to cloud storage if no outgoing Internet access is available. In this case,
  use the --metadata-source parameter to tell bootstrap a local directory from which to
  upload tools and/or image metadata.
  
  See Also:

    - juju help switch
    - juju help constraints
    - juju help set-constraints
    - juju help placement


^# debug-hooks


  #### usage:

  ```
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

  ```
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

  ```
  juju deploy [options] <charm name> [<service name>]
  ```

  #### purpose:

   deploy a new service


  
  #### options:



  _--config  (= )_  path to yaml-formatted service config


  _--constraints  (= )_  set service constraints


  _-e, --environment (= "")_  juju environment to operate in


  _-n, --num-units  (= 1)_  number of service units to deploy for principal charms


  _--networks (= "")_  bind the service to specific networks


  _--repository (= "")_  local charm repository


  _--to (= "")_  the machine or container to deploy the unit in, bypasses constraints


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
  ```lxc-clone: false```
  
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
      juju deploy mysql -n 5 --constraints mem=8G (deploy 5 instances of mysql with at least 8 GB of RAM each)
      juju deploy mysql --networks=storage,mynet --constraints networks=^logging,db (deploy mysql on machines with "storage", "mynet" and "db" networks,
  but not on machines with "logging" network, also configure "storage" and "mynet" networks)
  
  Like constraints, service-specific network requirements can be
  specified with the --networks argument, which takes a comma-delimited
  list of juju-specific network names. Networks can also be specified with
  constraints, but they only define what machine to pick, not what networks
  to configure on it. The --networks argument instructs juju to add all the
  networks specified with it to all new machines deployed to host units of
  the service. Not supported on all providers.
  
  See Also:

    - juju help constraints
    - juju help set-constraints
    - juju help get-constraints


^# destroy-environment


  #### usage:

  ```
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

  ```
  juju remove-machine [options] <machine> ...
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
      $ juju remove-machine 5


      # Remove machine 6 and any running units or containers
      $ juju remove-machine 6 --force
  
  aliases: destroy-machine, terminate-machine


^# destroy-relation


  #### usage:

  ```
  juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  ```

  #### purpose:

   remove a relation between two services


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  aliases: destroy-relation


^# destroy-service


  #### usage:

  ```
  juju remove-service [options] <service>
  ```

  #### purpose:

   remove a service from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Removing a service will remove all its units and relations.
  
  aliases: destroy-service


^# destroy-unit


  #### usage:

  ```
  juju remove-unit [options] <unit> [...]
  ```

  #### purpose:

   remove service units from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  aliases: destroy-unit


^# ensure-availability


  #### usage:

  ```
  juju ensure-availability [options]
  ```

  #### purpose:

   ensure the availability of Juju state servers


  
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

  ```
  juju switch [options] [environment name]
  ```

  #### purpose:

   show or change the default juju environment name


  
  #### options:



  _-l, --list  (= false)_  list the environment names
  
  Show or change the default juju environment name.
  
  If no command line parameters are passed, switch will output the current
  environment as defined by the file $JUJU_HOME/current-environment.
  
  If a command line parameter is passed in, that value will is stored in the
  current environment file if it represents a valid environment name as
  specified in the environments.yaml file.
  
  aliases: env


^# expose


  #### usage:

  ```
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

  ```
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

  ```
  juju get [options] <service>
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
  
      $ juju get wordpress
  
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

  ```
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

    - juju help constraints
    - juju help set-constraints


^# get-env


  #### usage:

  ```
  juju get-environment [options] [<environment key>]
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

      juju get-environment default-series  (returns the default series for the environment)
  
  aliases: get-env


^# get-environment


  #### usage:

  ```
  juju get-environment [options] [<environment key>]
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

      juju get-environment default-series  (returns the default series for the environment)
  
  aliases: get-env


^# help


  #### usage:

  ```
  juju help [topic]
  ```

  #### purpose:

   show help on a command or other topic


  
  See also: topics


^# help-tool


  #### usage:

  ```
  juju help-tool [tool]
  ```

  #### purpose:

   show help on a juju charm tool




^# init


  #### usage:

  ```
  juju init [options]
  ```

  #### purpose:

   generate boilerplate configuration for juju environments


  
  #### options:



  _-f  (= false)_  force overwriting environments.yaml file even if it exists (ignored if --show flag specified)


  _--show  (= false)_  print the generated configuration data to stdout instead of writing it to a file
  
  aliases: generate-config


^# publish


  #### usage:

  ```
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

  ```
  juju remove-machine [options] <machine> ...
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
      juju remove-machine 5
      # Remove machine 6 and any running units or containers
      juju remove-machine 6 --force
  
  aliases: destroy-machine, terminate-machine


^# remove-relation


  #### usage:

  ```
  juju remove-relation [options] <service1>[:<relation name1>] <service2>[:<relation name2>]
  ```

  #### purpose:

   remove a relation between two services


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  aliases: destroy-relation


^# remove-service


  #### usage:

  ```
  juju remove-service [options] <service>
  ```

  #### purpose:

   remove a service from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Removing a service will remove all its units and relations.
  
  aliases: destroy-service


^# remove-unit


  #### usage:

  ```
  juju remove-unit [options] <unit> [...]
  ```

  #### purpose:

   remove service units from the environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  aliases: destroy-unit


^# resolved


  #### usage:

  ```
  juju resolved [options] <unit>
  ```

  #### purpose:

   marks unit errors resolved


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _-r, --retry  (= false)_  re-execute failed hooks


^# retry-provisioning


  #### usage:

  ```
  juju retry-provisioning [options] <machine> [...]
  ```

  #### purpose:

   retries provisioning for failed machines


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


^# run


  #### usage:

  ```
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

  ```
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


^# set


  #### usage:

  ```
  juju set [options] <service> name=value ...
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

  ```
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

    - juju help constraints
    - juju help get-constraints
    - juju help deploy
    - juju help add-machine
    - juju help add-unit


^# set-env


  #### usage:

  ```
  juju set-environment [options] key=[value] ...
  ```

  #### purpose:

   replace environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Updates the environment of a running Juju instance.  Multiple key/value pairs
  can be passed on as command line arguments.
  
  aliases: set-env


^# set-environment


  #### usage:

  ```
  juju set-environment [options] key=[value] ...
  ```

  #### purpose:

   replace environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Updates the environment of a running Juju instance.  Multiple key/value pairs
  can be passed on as command line arguments.
  
  aliases: set-env


^# ssh


  #### usage:

  ```
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
  Any extra parameters are passsed as extra parameters to the ssh command.
  
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

  ```
  juju stat [options] [pattern ...]
  ```

  #### purpose:

   output status information about an environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= yaml)_  specify output format (json|oneline|summary|tabular|yaml)


  _-o, --output (= "")_  specify an output file
  
  This command will report on the runtime state of various system entities.
  
  There are a number of ways to format the status output:
  


  _- oneline: List units and their subordinates. For each unit, the IP_  address and agent status are listed.


  _- summary: Displays the subnet(s) and port(s) the environment utilizes._  Also displays aggregate information about:


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

  ```
  juju status [options] [pattern ...]
  ```

  #### purpose:

   output status information about an environment


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


  _--format  (= yaml)_  specify output format (json|oneline|summary|tabular|yaml)


  _-o, --output (= "")_  specify an output file
  
  This command will report on the runtime state of various system entities.
  
  There are a number of ways to format the status output:
  


  _- oneline: List units and their subordinates. For each unit, the IP_  address and agent status are listed.


  _- summary: Displays the subnet(s) and port(s) the environment utilizes._  Also displays aggregate information about:


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


^# switch


  #### usage:

  ```
  juju switch [options] [environment name]
  ```

  #### purpose:

   show or change the default juju environment name


  
  #### options:



  _-l, --list  (= false)_  list the environment names
  
  Show or change the default juju environment name.
  
  If no command line parameters are passed, switch will output the current
  environment as defined by the file $JUJU_HOME/current-environment.
  
  If a command line parameter is passed in, that value will is stored in the
  current environment file if it represents a valid environment name as
  specified in the environments.yaml file.
  
  aliases: env


^# sync-tools


  #### usage:

  ```
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

  ```
  juju remove-machine [options] <machine> ...
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
      juju remove-machine 5

      # Remove machine 6 and any running units or containers
      juju remove-machine 6 --force
  
  aliases: destroy-machine, terminate-machine


^# unexpose


  #### usage:

  ```
  juju unexpose [options] <service>
  ```

  #### purpose:

   unexpose a service


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in


^# unset


  #### usage:

  ```
  juju unset [options] <service> name ...
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

  ```
  juju unset-environment [options] <environment key> ...
  ```

  #### purpose:

   unset environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Reset one or more the environment configuration attributes to its default
  value in a running Juju instance.  Attributes without defaults are removed,
  and attempting to remove a required attribute with no default will result
  in an error.
  
  Multiple attributes may be removed at once; keys are space-separated.
  
  aliases: unset-env


^# unset-environment


  #### usage:

  ```
  juju unset-environment [options] <environment key> ...
  ```

  #### purpose:

   unset environment values


  
  #### options:



  _-e, --environment (= "")_  juju environment to operate in
  
  Reset one or more the environment configuration attributes to its default
  value in a running Juju instance.  Attributes without defaults are removed,
  and attempting to remove a required attribute with no default will result
  in an error.
  
  Multiple attributes may be removed at once; keys are space-separated.
  
  aliases: unset-env


^# upgrade-charm


  #### usage:

  ```
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

  ```
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
  outgoing Internet access) and provider types (such as maas) require that
  you manage yourself; see the documentation for "sync-tools".
  
  The upgrade-juju command will abort if an upgrade is already in
  progress. It will also abort if a previous upgrade was partially
  completed - this can happen if one of the state servers in a high
  availability environment failed to upgrade. If a failed upgrade has
  been resolved, the --reset-previous-upgrade flag can be used to reset
  the environment's upgrade tracking state, allowing further upgrades.


^# user


  #### usage:

  ```
  juju user [options] <command> ...
  ```

  #### purpose:

   manage user accounts and access control


  
  #### options:



  _--description  (= false)_  


  _-h, --help  (= false)_  show help on a command or other topic
  
  "juju user" is used to manage the user accounts and access control in
  the Juju environment.
  
  #### subcommands:

  add             - adds a user


  change-password - changes the password for a user


  disable         - disable a user to stop the user logging in


  enable          - reenables a disabled user to allow the user to log in


  help            - show help on a command or other topic


  info            - shows information on a user


  list            - shows all users




^# version


  #### usage:

  ```
  juju version [options]
  ```

  #### purpose:

   print the current version


  
  #### options:



  _--format  (= smart)_  specify output format (json|smart|yaml)


  _-o, --output (= "")_  specify an output file


