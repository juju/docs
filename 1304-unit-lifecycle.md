What happens during juju deploy foo?

(Assume not a bundle and we know what 'foo' is in terms of charm series)

General process (not actual internal function calls)

AddCharm()
Deploy()
AddApplication()
AddUnit()
AssignToMachine()

Explanation

Deploy()
Am I subordinates
Metadata

AddCharm()
Metadata
Charm Zip 	
LXD profile


Add unit()
Application
Unit object

Note: this process is currently synchronous: downloads from the charm store

Provisioning Machine
To a cloud, e.g. AWS we send it some cloud-init data. There are provider-specific methods to deliver data to cloud-init.

StartInstance()
	Download jujud binary		curl jujud (juju agent) from controller
	Place agent.conf in known place	/var/lib/juju/agent.conf
Configure the init system 		systemd jujud-machine-X
	Start machine agent (via systemd)

	machine.WatchAllUnits()
		worker/deployer
	(?) 

	Deployer
		Wakes up
			systemd jujud-unit-<app>-X agent
		
(?) Stuff about downloading machine agent

	Hooks
		Unit agent loop
			(...)
		Install
		Upgrade
Resolver loop - what hook do I need to fire now?
	Hooks (rough priority) 

	storage-attached
install
start
leader-elected
leader-settings-changed (unless currently leader)
	config-changed
			relation-joined	(may be more than 1, non-deterministic)
			relation-changed
			update-status (periodic approx. 5min, model config key) 


Upgrading charms

	juju upgrade-charm <charm name>

Unit agent
	download .zip
	unpack to /var/lib/juju
	run upgrade-charm
Definitions
Local state		uniter has locally
Remote state 		controller’s view / desired state 

Remotestatewatcher		Checks the controller for a change in the “remote state” 
Notes
Charms would historically use config-change to restart services.

Uniter has a state file that includes a note to describe where it currently is.

The install hook can be vulnerable to storage not being provisioned (quota storage)

There is a single Jujud binary (jujud). It can perform every function - unit agent, machine agent, application agent (not sure if there is an application agent (CaaS/Kubernetes environment))… - depending on command line arguments. Typically this is arg 0.

Possible future work - Controller - may be moved into its own binary. Only the controller needs its own binary. 

Bootstrapping. Only “supported” on Ubuntu.
 
Agent.conf
	Passwords
	Certs
	Identity
	Feature flags
	Env override

Broker - simply there for provisioning new instances 

Charms “used to be bad” at placing their data within a common charm directory.
