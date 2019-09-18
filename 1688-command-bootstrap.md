**Usage:** `juju bootstrap [options] [<cloud name>[/region] [<controller name>]]`

**Summary:**

Initializes a cloud environment.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--agent-version (= "")`

Version of agent binaries to use for Juju agents

`--auto-upgrade (= false)`

After bootstrap, upgrade to the latest patch release

`--bootstrap-constraints (= "")`

Specify bootstrap machine constraints

`--bootstrap-series (= "")`

Specify the series of the bootstrap machine

`--build-agent (= false)`

Build local version of agent binary before bootstrapping

`--clouds (= false)`

Print the available clouds which can be used to bootstrap a Juju environment

`--config (= )`

Specify a controller configuration file, or one or more configuration

options

`(--config config.yaml [--config key=value ...])`

`--constraints (= "")`

Set model constraints

`--credential (= "")`

Credentials to use when bootstrapping

`-d, --default-model (= "default")`

Name of the default hosted model for the controller

`--keep-broken (= false)`

Do not destroy the model if bootstrap fails

`--metadata-source (= "")`

Local path to use as agent and/or image metadata source

`--model-default (= )`

Specify a configuration file, or one or more configuration

options to be set for all models, unless otherwise specified

`(--model-default config.yaml [--model-default key=value ...])`

`--no-gui (= false)`

Do not install the Juju GUI in the controller when bootstrapping

`--no-switch (= false)`

Do not switch to the newly created controller

`--regions (= "")`

Print the available regions for the specified cloud

`--to (= "")`

Placement directive indicating an instance to bootstrap

**Details:**

Used without arguments, bootstrap will step you through the process of initializing a Juju cloud environment. Initialization consists of creating a 'controller' model and provisioning a machine to act as controller.

We recommend you call your controller ‘username-region’ e.g. ‘fred-us-east-1’ See `--clouds` for a list of clouds and credentials.

See `--regions` for a list of available regions for a given cloud. Credentials are set beforehand and are distinct from any other configuration (see `juju add-credential`).

The 'controller' model typically does not run workloads. It should remain pristine to run and manage Juju's own infrastructure for the corresponding cloud. Additional (hosted) models should be created with `juju create- model` for workload purposes.

Note that a 'default' model is also created and becomes the current model of the environment once the command completes. It can be discarded if other models are created.

If `--bootstrap-constraints` is used, its values will also apply to any future controllers provisioned for high availability (HA).

If `--constraints` is used, its values will be set as the default constraints for all future workload machines in the model, exactly as if the constraints were set with juju set-model-constraints.

It is possible to override constraints and the automatic machine selection algorithm by assigning a "placement directive" via the `--to` option. This dictates what machine to use for the controller. This would typically be used with the MAAS provider (`--to .maas`).

Available keys for use with `--config` can be found here:

         https://jujucharms.com/stable/controllers-config
          https://jujucharms.com/stable/models-config
You can change the default timeout and retry delays used during the bootstrap by changing the following settings in your configuration (all values represent number of seconds):

         # How long to wait for a connection to the controller
          bootstrap-timeout: 600 # default: 10 minutes
          # How long to wait between connection attempts to a controller address.

         bootstrap-retry-delay: 5 # default: 5 seconds
          # How often to refresh controller addresses from the API server.
          bootstrap-addresses-delay: 10 # default: 10 seconds
Private clouds may need to specify their own custom image metadata and tools/agent. Use `--metadata-source` whose value is a local directory. By default, the Juju version of the agent binary that is downloaded and installed on all models for the new controller will be the same as that of the Juju client used to perform the bootstrap.

However, a user can specify a different agent version via `--agent-version` option to bootstrap command. Juju will use this version for models' agents as long as the client's version is from the same Juju release series.

In other words, a 2.2.1 client can bootstrap any 2.2.x agents but cannot bootstrap any 2.0.x or 2.1.x agents.

The agent version can be specified a simple numeric version, e.g. 2.2.4. For example, at the time when 2.3.0, 2.3.1 and 2.3.2 are released and your agent stream is 'released' (default), then a 2.3.1 client can bootstrap: * 2.3.0 controller by running `... bootstrap --agent-version=2.3.0 ...`; * 2.3.1 controller by running `... bootstrap ...`; * 2.3.2 controller by running `bootstrap --auto-upgrade`.

However, if this client has a copy of codebase, then a local copy of Juju will be built and bootstrapped - 2.3.1.1.

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

[add-credentials](https://discourse.jujucharms.com/t/command-add-credential/1670), [add-model](https://discourse.jujucharms.com/t/command-add-model/1673), [controller-config](https://discourse.jujucharms.com/t/command-controller-config/1699), [model-config](https://discourse.jujucharms.com/t/command-model-config/1768), [set-constraints](https://discourse.jujucharms.com/t/command-set-constraints/1807), [show-cloud](https://discourse.jujucharms.com/t/command-show-cloud/1820)
