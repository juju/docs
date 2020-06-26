**Usage:** `juju show-status [options] [filter pattern ...]`

**Summary:**

Reports the current status of the model, machines, applications and units.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--color (= false)`

Force use of ANSI color codes

`--format (= tabular)`

Specify output format (`json|line|oneline|short|summary|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--relations (= false)`

Show 'relations' section

`--retry-count (= 3)`

Number of times to retry API failures

`--retry-delay (= 100ms)`

Time to wait between retry attempts

`--storage (= false)`

Show 'storage' section

`--utc (= false)`

Display time as UTC in RFC3339 format

**Details:**

By default (without argument), the status of the model, including all applications and units will be output.

Application or unit names may be used as output filters (the '*' can be used as a wildcard character). In addition to matched applications and units, related machines, applications, and units will also be displayed. If a subordinate unit is matched, then its principal unit will be displayed. If a principal unit is matched, then all of its subordinates will be displayed.

Machine numbers may also be used as output filters. This will only display data in each section relevant to the specified machines. For example, application section will only contain the applications that have units on these machines, etc. The available output formats are:

* tabular (default): Displays status in a tabular format with a separate table for the model, machines, applications, relations (if any), storage (if any) and units.

            Note: in this format, the AZ column refers to the cloud region's
            availability zone.
* {short|line|oneline}: List units and their subordinates. For each unit, the IP address and agent status are listed.

* summary: Displays the subnet(s) and port(s) the model utilises. Also displays aggregate information about:

            - Machines: total #, and # in each state.

             - Units: total #, and # in each state.

             - Applications: total #, and # exposed of each application.
* yaml: Displays information about the model, machines, applications, and units in structured YAML format.

* json: Displays information about the model, machines, applications, and units in structured JSON format.

In tabular format, 'Relations' section is not displayed by default. Use `--relations` option to see this section. This option is ignored in all other formats.

**Examples:**

       juju show-status
        juju show-status mysql
        juju show-status nova-*
        juju show-status --relations
        juju show-status --storage
**See also:**

[machines](https://discourse.jujucharms.com/t/command-machines/1765), [show-model](https://discourse.jujucharms.com/t/command-show-model/1825), [show-status-log](https://discourse.jujucharms.com/t/command-show-status-log/1828), [storage](https://discourse.jujucharms.com/t/command-storage/1837)

**Aliases:**

status


<!--
Interpreting output

This section explains the tabular format's output. To replicate this model,
use the following commands:

	juju deploy -n3 etcd
	juju deploy easyrsa
	juju relate etcd easyrsa
	juju deploy ntp
	juju relate etcd ntp


Interpreting output: model section

The first section reported relates to the overall model. Here is an example
output:

	Model  Controller  Cloud/Region   Version  SLA          Timestamp
	live   docs        aws/us-east-1  2.8.0    unsupported  14:58:41+2:00

Each heading has the following meaning: 

	Model
		The model's name, as defined by the 'add model' command.
	
	Controller
		The controller's name, as defined by the 'juju bootstrap' command.
	
	Cloud/Region
		The cloud and region selected during 'juju bootstrap'. Valid clouds
		are listed by the 'juju clouds' command. Each cloud's regions are
		listed by the 'juju regions' command.
	
	Version
		The version of Juju that is being run by the Juju agents within the 
		model. Newer versions of the Juju client will always inter-operable 
		with older versions of Juju. Use 'juju upgrade-model' to upgrade to 
		a newer version.
	
	SLA
		The "Support Level Agreement" for this model. The "Managed Solutions"
		link in the Further Reading section contains information about SLAs.
	
	Timestamp
		The time when the controller gathered the information for the report.


Interpreting output: branches section (not visible on all models)

When a model makes use of branches for making progressive changes to units
within an application (known as blue-green deployment), the output will contain
a section detailing the current branches that are live.

	Branch
		The branch name that can be tracked by units, as created by the 
		'juju add-branch' command.
	
	Ref
		The branch's revision number.
	
	Created
		The time that the revision has been available for.
	
	Created by
		The user account that created the branch.



Interpreting output: remote application section (not visible on all models)

When a model contains cross-model relations, 'juju status' includes an extra
section.

The meanings of each of the headings:

	SAAS
		The name of the remote application.
	
	Status
		The status code of the remote application. 
	
	Store
		Describes the source of the application. Will report "unknown" when
		Juju is unable to determine its source.
	
	URL
		The "offer URL" that describes how the Juju controller can connect
		with remote applications.


Interpreting output: application section

The application section aggregates information that applicable to all units of
each application. This include the details about the charm(s) that are deployed 
and an overall status code.  

The meanings of each of the headings:

	App
		The application name, as provided during 'juju deploy'. Can differ from
		the charm's default to enable multiple logical services running the 
		same underlying application.

	Version
		The version number of the application itself, not the charm.

	Status
		May be "active", "blocked", "error", "maintenance", "waiting". The 
		"blocked" state implies that manual intervention is required. Normally,
		"blocked" can resolved be adding a relation or setting configuration 
		values. "error" indicates that the charm's code itself has encountered
		an error. To resolve this, contact the charm's author. 

	Scale
		Number of units of this application. Indicates a difference between 
		the desired units and the actual count with a fraction.

	Charm
		The charm's name.

	Store
		Where the charm's source code originates from. When charms are deployed
		from the file system, the term "local" is used.

	Rev
		The charm's revision number.

	OS
		The operating system that this charm is designed to run.

	Notes
		Any messages that are applicable to all units within the application.


Interpreting output: units section

The units section provides a view of the units deployed within the model.
The section contains two status columns. One presents a view of the 
"unit agents" status and the other contains the "workload" status. The unit
agent is a software agent responsible for running the unit's charm code and 
executing 




Interpreting output: agent status

Interpreting output: workload status

Interpreting output: machine status

Interpreting output: network connectivity

The output from 'juju status' indicates whether machines are accessible from
the Internet.

	App      ... Notes
	etcd     ... exposed 

	Unit     ... Public address  Ports     ...
	etcd/0*  ... 3.236.75.170    2379/tcp  ...

An application does not contain "exposed" in the notes section may not be 
accessible from the Internet. This depends on the cloud's defaults. Use the
'juju expose' command to allow access from the Internet.


Interpreting output: leadership

The application leader is denoted with an asterisk (*) next to the unit's name.
This asterisk appears once per application.

In this example, the etcd application is comprised of 3 units. Leadership is 
currently held by etcd/0.

	Unit     Workload  ...
	etcd/0*  active    ...
	etcd/1   active    ...
	etcd/2   active    ...


Interpreting output: subordinate applications

Units of subordinate applications are listed underneath of, but indented from,
their principal units. 

    Unit      Workload  ...
    etcd/0*   active    ...
      ntp/2   active    ...
    etcd/1    active    ...
      ntp/0   active    ...
    etcd/2    active    ...
      ntp/1*  active    ...


-->
