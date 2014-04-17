# Juju Command reference

You can get a list of the currently used commands by entering `juju help
commands` from the commandline. The currently understood commands are listed
here, with some examples.

  - **add-machine:** start a new, empty machine and optionally a container, or add a container to a machine
  - **add-relation:** add a relation between two services
  - **add-unit:** add one or more units of an already-deployed service
  - **api-endpoints:** print the API server addresses
  - **authorised-keys:** manage authorised ssh keys
  - **bootstrap:** start up an environment from scratch
  - **debug-hooks:** launch a tmux session to debug a hook
  - **debug-log:** display the consolidated log file
  - **deploy:** deploy a new service
  - **destroy-environment:** terminate all machines and other associated resources for an environment
  - **env:** alias for switch
  - **expose:** expose a service
  - **generate-config:** generate boilerplate configuration for juju environments
  - **get:** get service configuration options
  - **get-constraints:** view constraints on the environment or a service
  - **get-env:** alias for get-environment
  - **get-environment:** view environment values
  - **help:** show help on a command or other topic
  - **help-tool:** show help on a juju charm tool
  - **publish:** publish charm to the store
  - **remove-machine:** removes a machine
  - **remove-relation:** breaks a relation between two running services
  - **remove-service:** terminates and removes a deployed service
  - **remove-unit:** removes a unit
  - **resolved:** marks unit errors resolved
  - **retry-provisioning:** retries provisioning for failed machines
  - **run:** run the commands on the remote targets specified
  - **scp:** launch a scp command to copy files to/from remote machine(s)
  - **set:** set service config options
  - **set-constraints:** set constraints on the environment or a service
  - **set-env:** alias for set-environment
  - **set-environment:** replace environment values
  - **ssh:** launch an ssh shell on a given unit or machine
  - **stat:** alias for status
  - **status:** output status information about an environment
  - **switch:** show or change the default juju environment name
  - **sync-tools:** copy tools from the official tool store into a local environment
  - **terminate-machine:** alias for destroy-machine
  - **unexpose:** unexpose a service
  - **unset:** set service config options back to their default
  - **unset-env:** alias for unset-environment
  - **unset-environment:** unset environment values
  - **upgrade-charm:** upgrade a service's charm
  - **upgrade-juju:** upgrade the tools in a juju environment
  - **version:** print the current version