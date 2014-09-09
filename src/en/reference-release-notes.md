Title: Juju Release Notes

# History

This section details all the available release notes for the stable series of
`juju-core`.

The versions covered here are:

^# juju-core 1.20.6

  A new stable release of Juju, juju-core 1.20.6, is now available.
  This release replaces 1.20.5.


  ## Getting Juju

  juju-core 1.20.6 is available for utopic and backported to earlier
  series in the following PPA:

  ```
  https://launchpad.net/~juju/+archive/stable
  ```


  ## Noteworthy

  This releases addresses stability issues, particularly with LXC.


  ### Resolved issues

  * Arguments no longer passed to plugins if you don't have an environment set
    Lp 1359170

  * ERROR Nonce already used
    Lp 1190986

  * Juju status returns private IP in 'public-ip' field.
    Lp 1348287

  * Juju status <unit> nil pointer reference.
    Lp 1357482

  * LXC containers created, juju can't seen or communicate with them
    Lp 1357552

  * Cannot get tools from machine for lxc container
    Lp 1359800

  * Tools download can fail and is not always retried
    Lp 1360994

  * Containers not starting on machine
    Lp 1362360

  * Update the add machine api to accept both environment name and UUID
    Lp 1360063


^# juju-core 1.20.5

  A new stable release of Juju, juju-core 1.20.5, is now available.
  This release replaces 1.20.1.


  ## Getting Juju

  juju-core 1.20.5 is available for utopic and backported to earlier
  series in the following PPA:

  ```
  https://launchpad.net/~juju/+archive/stable
  ```


  ## Noteworthy

  This releases addresses stability and performance issues.


  ### Resolved issues

  * Juju is stripping underscore from options
    Lp 1243827

  * Juju api-endpoints cannot distinguish public and private addresses
    Lp 1311227

  * API server inaccessible for roughly 5 seconds after bootstrap
    Lp 1351083

  * Juju bootstrap in an existing environment destroys the environment
    Lp 1340893

  * The jujud on state server panic misses transaction in queue
    Lp 1318366

  * Juju machine agents suiciding
    Lp 1345014

  * Juju state server database is overly large
    Lp 1344940

  * Jujud rewrites /etc/init/juju-db.conf constantly
    Lp 1349969

  * Juju writes to mongo without an actual change occurring
    Lp 1345832

  * Talking to mongo can fail with "TCP i/o timeout"
    Lp 1307434

  * Bootstrap fails if /usr/lib/juju/bin/mongod doesn't already exist
    Lp 1350700

  * Support the new v4 signing format used by the new China region
    Lp 1319475

  * Azure: secondary state servers do not load balance API server port
    Lp 1347371

  * Network error causes tools download to fail
    Lp 1349989

  * Maas provider: allow users to specify network bridge interface.
    Lp 1337091

  * ppc64 architecture miss match for MAAS ppc64el
    Lp 1349771

  * MAAS provider uses dead instance address
    Lp 1353442

  * Juju bootstrap fails if kvm-ok not in path
    Lp 1342747

  * Juju-local needs new dep dbus -- specifically to work in lxc
    Lp 1343301

  * LXC clonetemplate lock can be left stale
    Lp 1311668

  * LXC deploys broken on precise
    Lp 1350011

  * LXC template fails to stop
    Lp 1348386

  * Distribution tarball has licensing problems that prevent 
    redistribution
    Lp 1341589


^# juju-core 1.20.1

  A new stable release of Juju, juju-core 1.20.1, is now available.
  This release replaces 1.20.0.


  ## Getting Juju

  juju-core 1.20.1 is available for utopic and backported to earlier
  series in the following PPA:
  
  ```
  https://launchpad.net/~juju/+archive/stable
  ```

  ## Noteworthy

  This release fixes several issues seen in slower environments. The
  performance improvements also improved reliability. Juju CI saw a 35%
  speed improvement in the test suite.  While we had planned to release
  1.20.1 on 2014-07-17, the performance improvements were just too good to
  delay a whole week.


  ### Resolved issues

  * Juju 1.20 consistently fails to bootstrap a MAAS environment
  Lp 1339240

  * Juju bootstrap fails because mongodb is unreachable
  Lp 1337340

  * Juju 1.20.x slow bootstrap
  Lp 1338179

  * API-endpoints fails if run just after bootstrap
  Lp 1338511

  * Machines are killed if mongo fails
  Lp 1339770

  * Restore doesn't
  Lp 1336967


^# juju-core 1.20.0

  A new stable release of Juju, juju-core 1.20.0, is now available.

  ## Getting Juju

  juju-core 1.20.0 is available for utopic and backported to earlier
  series in the following PPA:

  ```
  https://launchpad.net/~juju/+archive/stable
  ```


  ### New and Notable

    * High Availability
    * Availability Zone Placement
    * Azure Availability Sets
    * Juju debug-log Command Supports Filtering and Works with LXC
    * Constraints Support instance-type
    * The lxc-use-clone Option Makes LXC Faster for Non-Local Providers
    * Support for Multiple NICs with the Same MAC
    * MaaS Network Constraints and Deploy Argument
    * MAAS Provider Supports Placement and add-machine
    * Server-Side API Versioning


  ### Resolved issues

  * Juju client is not using the floating ip to connect to the
  state server
  `Lp 1308767`

  * Juju help promotes the 'wrong' versions of commands
  `Lp 1299120`

  * Juju backup command fails against trusty bootstrap node
  `Lp 1305780`

  * The root-disk constraint is broken on ec2
  Lp 1324729

  * Bootstrapping juju from within a juju deployed unit fails
  Lp 1285256

  * Images are not found if endpoint and region are inherited from
  the top level in simplestreams metadata
  Lp 1329805

  * Missing @ syntax for reading config setting from file content
  Lp 1216967

  * Deploy --config assumes relative path if it starts with a tilde (~)
  Lp 1271819

  * local charm deployment fails with symlinks
  Lp 1330919

  * Git usage can trigger disk space/memory issues for charms with blobs
  Lp 1232304

  * Juju upgrade-charm fails because of git
  Lp 1297559

  * .pyc files caused upgrade-charm to fail with merge conflicts
  Lp 1191028

  * Juju debug-hooks should display a start message
  Lp 1270856

  * Can't determine which relation is in error from status
  Lp 1194481

  * Dying units departure is reported late
  Lp 1192433

  * Juju upgrade-juju needs a dry run mode
  Lp 1272544

  * Restarting API server with lots of agents gets hung
  Lp 1290843

  * Juju destroy-environment >=256 nodes fails
  Lp 1316272

  * Azure destroy-environment does not complete
  Lp 1324910

  * Azure bootstrap dies with xml schema validation error
  Lp 1259947

  * Azure provider stat output does not show machine hardware info
  Lp 1215177

  * Bootstrapping azure causes memory to fill
  Lp 1250007

  * Juju destroy-environment on openstack should remove sec groups
  Lp 1227574

  * Floating IPs are not recycled in OpenStack Havana
  Lp 1247500

  * LXC cloning should be default behaviour
  Lp 1318485

  * Nasty worrying output using local provider
  Lp 1304132

  * Intermittent error destroying local provider environments
  Lp 1307290

  * Default bootstrap timeout is too low for MAAS environments
  Lp 1314665

  * MAAS provider cannot provision named instance
  Lp 1237709

  * Manual provisioning requires target hostname to be directly resolvable
  Lp 1300264

  * Manual provider specify bash as shell for ubuntu user
  Lp 1303195


  ### High Availability

  The juju state-server (bootstrap node) can be placed into high
  availability mode. Juju will automatically recover when one or more the
  state-servers fail. You can use the 'ensure-availability' command to
  create the additional state-servers:

  ```
  juju ensure-availability
  ```

  The 'ensure-availability' command creates 3 state servers by default,
  but you may use the '-n' option to specify a larger number. The number
  of state servers must be odd. The command supports the 'series' and
  'constraints' options like the 'bootstrap' command. You can learn more
  details by running 'juju ensure-availability --help'


  ### Availability Zone Placement

  Juju supports explicit placement of machines to availability zones
  (AZs), and implicitly spreads units across the available zones.

  When bootstrapping or adding a machine, you can specify the availability
  zone explicitly as a placement directive. e.g.

  ```
    juju bootstrap --to zone=us-east-1b
    juju add-machine zone=us-east-1c
  ```
  
  If you don't specify a zone explicitly, Juju will automatically and
  uniformly distribute units across the available zones within the region.
  Assuming the charm and the charm's service are well written, you can
  rest assured that IaaS downtime will not affect your application.
  Commands you already use will ensure your services are always available.
  e.g.

  
  ```
    juju deploy -n 10 <service>
  ```
  
  When adding machines without an AZ explicitly specified, or when adding
  units to a service, the ec2 and openstack providers will now
  automatically spread instances across all available AZs in the region.
  The spread is based on density of instance "distribution groups".

  State servers compose a distribution group: when running 'juju
  ensure-availability', state servers will be spread across AZs. Each
  deployed service (e.g. mysql, redis, whatever) composes a separate
  distribution group; the AZ spread of one service does not affect the AZ
  spread of another service.

  Amazon's EC2 and OpenStack Havana-based clouds and newer are supported.
  This includes HP Cloud. Older versions of OpenStack are not supported.


  ### Azure availability sets

  Azure environments can be configured to use availability sets. This
  feature ensures services are distributed for high availability; as long
  as at least two units are deployed, Azure guarantees 99.95% availability
  of the service overall. Exposed ports will be automatically load
  balanced across all units within the service.

  New Azure environments will have support for availability sets by
  default. To revert to the previous behaviour, the
  'availability-sets-enabled' option must be set in environments.yaml like
  so:
  
  ```
    availability-sets-enabled: false
  ```
  
  Placement is disabled when 'availability-sets-enabled' is true. The
  option cannot be disabled after the environment is bootstrapped.


  ### Juju debug-log Command Supports Filtering and Works with LXC

  The 'debug-log' command shows the consolidate logs of all juju agents
  running on all machines in the environment. The command operates like
  'tail -f' to stream the logs to the your terminal. The feature now
  support local-provider LXC environments. Several options are available
  to select which log lines to display.

  The 'lines' and 'limit' options allow you to select the starting log
  line and how many additional lines to display. The default behaviour is
  to show the last 10 lines of the log. The 'lines' option selects the
  starting line from the end of the log. The 'limit' option restricts the
  number of lines to show. For example, you can see just 20 lines from
  last 100 lines of the log like this:

      juju debug-log --lines 100 --limit 20

  There are many ways to filter the juju log to see just the pertinent
  information. A juju log line is written in this format:

      <entity> <timestamp> <log-level> <module>:<line-no> <message>

  The 'include' and 'exclude' options select the entity that logged the
  message. An entity is a juju machine or unit agent. The entity names are
  similar to the names shown by 'juju status'. You can exclude all the log
  messages from the bootstrap machine that hosts the state-server like
  this:

      juju debug-log --exclude machine-0

  The options can be used multiple times to select the log messages. This
  example selects all the message from a unit and its machine as reported
  by status:

      juju debug-log --include unit-mysql-0 --include machine-1

  The 'level' option restricts messages to the specified log-level or
  greater. The levels from lowest to highest are TRACE, DEBUG, INFO,
  WARNING, and ERROR. The WARNING and ERROR messages from the log can seen
  thusly:

      juju debug-log --level WARNING

  The 'include-module' and 'exclude-module' are used to select the kind of
  message displayed. The module name is dotted. You can specify all or
  some of a module name to include or exclude messages from the log. This
  example progressively excludes more content from the logs
 
  ```
  juju debug-log --exclude-module juju.state.apiserver
  juju debug-log --exclude-module juju.state
  juju debug-log --exclude-module juju
  ```
  
  The 'include-module' and 'exclude-module' options can be used multiple
  times to select the modules you are interested in. For example, you can
  see the juju.cmd and juju.worker messages like this:

      juju debug-log --include-module juju.cmd --include-module juju.worker

  The 'debug-log' command output can be piped to grep to filter the
  message like this:

      juju debug-log --lines 500 | grep amd64

  You can learn more by running 'juju debug-log --help' and 'juju help
  logging'


  ### Constraints Support instance-type

  You can specify 'instance-type' with the 'constraints' option to
  select a specific image defined by the cloud provider. The
  'instance-type' constraint can be used with Azure, EC2, HP Cloud, and
  all OpenStack-based clouds. For example, when creating an EC2
  environment, you can specify 'm1.small':

    juju bootstrap --constraints instance-type=m1.small

  Constraints are validated by all providers to ensure values conflicts
  and unsupported options are rejected. Previously, juju would reconcile
  such problems and select an image, possibly one that didn't meet the
  needs of the service.


  ### The lxc-use-clone Option Makes LXC Faster for Non-Local Providers

  When 'lxc-use-clone' is set to true, the LXC provisioner will be
  configured to use cloning regardless of provider type. This option
  cannot be changed once it is set. You can set the option to true in
  environments.yaml like this:

      lxc-use-clone: true

  This speeds up LXC provisioning when using placement with any provider.
  For example, deploying mysql to a new LXC container on machine 0 will
  start faster:

      juju deploy --to lxc:0 mysql


  ### Support for Multiple NICs with the Same MAC

  Juju now supports multiple physical and virtual network interfaces with
  the same MAC address on the same machine. Juju takes care of this
  automatically, there is nothing you need to do.

  Caution, network settings are not upgraded from 1.18.x to 1.20.x. If you
  used juju 1.18.x to deploy an environment with specified networks, you
  must redeploy your environment instead of upgrading to 1.20.0.

  The output of 'juju status'  will include information about networks
  when there is more than one. The networks will be presented in this
  manner:

    machines: ...
    services: ...
    networks:
      net1:
        provider-id: foo
        cidr: 0.1.2.0/24
        vlan-tag: 42


  ### MaaS Network Constraints and Deploy Argument

  You can specify which networks to include or exclude as a constraint to
  the deploy command. The constraint is used to select a machine to deploy
  the service's units too. The value of 'networks' is a comma-delimited
  list of juju network names (provided by MaaS). Excluded networks are
  prefixed with a "^". For example, this command specify the service
  requires the "logging" and "storage" networks and conflicts with the
  "db" and "dmz" networks.

    juju deploy mongodb --constraints networks=logging,storage,^db,^dmz

  The network constraint does not enable the network for the service. It
  only defines what machine to pick.

  Use the 'deploy' command's 'networks' option to specify service-specific
  network requirements. The 'networks' option takes a comma-delimited list
  of juju-specific network names. Juju will enable the networks on the
  machines that host service units.

  Juju networking support is still experimental and under development,
  currently only supported with the MaaS provider.

  juju deploy mongodb --networks=logging,storage

  The 'exclude-network' option was removed from the deploy command as it
  is superseded by the constraint option.

  There are plans to add support for network constraint and argument with
  Amazon EC2, Azure, and OpenStack Havana-based clouds like HP Cloud in
  the future.


  ### MAAS Provider Supports Placement and add-machine

  You can specify which MAAS host to place the juju state-server on with
  the 'to' option. To bootstrap on a host named 'fnord', run this:

    juju bootstrap --to fnord

  The MAAS provider support the add-machine command now. You can provision
  an existing host in the MAAS-based Juju environment. For example, you
  can  add running machine named fnord like this:

    juju add-machine fnord


  ### Server Side API Versioning

  The Juju API server now has support for a Version field in requests that
  are made. For this release, there are no RPC calls that require anything
  other than 'version=0' which is the default when no Version is supplied.
  This should have limited impact on existing CLI or API users, since it
  allows us to maintain exact compatibility with existing requests. New
  features and APIs should be exposed under versioned requests.

  For details on the internals (for people writing API clients), see:
   [this document](https://docs.google.com/document/d/1fPOSUu7Dc_23pil1HGNTSpdFRhkMHGxe4o6jBghZZ1A/edit?usp=sharing)


  ### Finally

  We encourage everyone to subscribe the mailing list at
  juju-dev@lists.canonical.com, or join us on #juju-dev on freenode.




^# juju-core 1.18.3

  A new stable release of Juju, juju-core 1.18.3, is now available.
  This release replaces 1.18.2.

  ###Getting Juju

  juju-core 1.18.3 is available in trusty and backported to earlier
  series in the following PPA
  `https://launchpad.net/~juju/+archive/stable`

  If you use the local provider, be sure to install the juju-local package
  if it is not already installed. Juju's local requirements have changed.
  Upgrading local juju environments without the juju-local package is not
  advised.

  ###Resolved issues
  
  * juju sync-tools destroys the environment when given an invalid source Lp 1316869
  * Local provider behaves poorly when juju-mongodb is not installed
  on trusty Lp 1301538
  * Juju bootstrap defaults to i386 Lp 1304407
  * LXC local provider fails to provision precise instances from a trusty host Lp 1306537
  * LXC nested within kvm machines do not use lxc-clone Lp 1315216

^# juju-core 1.18.2

  A new stable release of Juju, juju-core 1.18.2, is now available.
  This release replaces 1.18.1.

  ###Getting Juju

  juju-core 1.18.2 is available in trusty and backported to earlier
  series in the following PPA
    https://launchpad.net/~juju/+archive/stable
  
  If you use the local provider, be sure to install the juju-local package
  if it is not already installed. Juju's local requirements have changed.
  Upgrading local juju environments without the juju-local package is not
  advised.
  
  ###Resolved issues

  * Manual provisioned systems stuck in pending on arm64 Lp 1302205
  * Version reports "armhf" on arm64  Lp 1304742
  * Juju deploy --to lxc:0 cs:trusty/ubuntu creates precise container Lp 1302820
  * If the provisioner fails to find tools for one machine it fails
    to provision the others LP 1311676
  * Juju status panic() when unable to parse .jenv Lp 1312136
  * Juju authorised-keys should have an authorized-keys alias Lp 1312537
  * Race condition on bootstrap machine addresses with manual provider Lp 1314430


^# juju-core 1.18.1
  A new stable release of Juju, juju-core 1.18.1, is now available. This release
  replaces 1.18.0.

  ### Getting Juju

  juju-core 1.18.1 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launchpad.net/%7Ejuju/+archive/stable)

  If you use the local provider, be sure to install the juju-local package if it
  is not already installed. Juju's local requirements have changed. Upgrading
  local juju environments without the juju-local package is not advised.

  ### Notable

    * Working with Ubuntu 12.04 Precise and 14.04 Trusty

  ### Resolved issues

    * Juju upgrade-juju 1.16.6 -> 1.18 (tip) fails Lp 1299802
    * Peer relation disappears during upgrade of juju Lp 303697
    * The public-address changed to internal bridge after juju-upgrade Lp 1303735
    * juju cannot downgrade to same major.minor version with earlier patch number Lp 1306296
    * Juju 1.18.0, can not deploy local charms without series Lp 1303880
    * Juju scp no longer allows multiple extra arguments to pass through Lp 1306208
    * Juju tests fail with release version number 1.18.0 Lp 1302313
    * Charm store tests do not pass with juju-mongodb Lp 1304770

  ### Working with Ubuntu 12.04 Precise and 14.04 Trusty

  Juju 1.18.x is the first Juju that is aware of two Ubuntu LTS releases. In the
  past, when bootstrapping the state-server or deploying a charm, Juju selected
  Ubuntu 12.04 Precise when the serie was not specified. If you care about the
  version of Ubuntu used, then you want to specify the series

  You can specify the series of the state-server and set the default charm
  series by adding "default-series" to environments.yaml. Setting "default-
  series" is the only way to specify the series of the state-server (bootstrap
  node). For example, if your local machine is Ubuntu 14.04 trusty, but your
  organisation only supports Ubuntu 12.04 Precise in the cloud, you can add this
  to your environment in environments.yaml:

      default-series: precise

  There are many ways to specify the series to deploy with a charm. In most
  cases you don't need to. When you don't specify a series, Juju checks the
  environment's `default-series`, and if that isn't set, Juju asks the charm
  store to select the best series to deploy with the charm. The series of the
  state-server does not restrict the series of the charm. You can use the best
  series for a charm when deploying a service.

  When working with local charms, Juju cannot fall back to the charm store, it
  falls back to the environment's `default-series`. You must specify the series
  in the environment or when deploying the charm. If your environment is
  running, you can add `default-series` like so:

      juju set-environment default-series=precise

  These commands choose Ubuntu 12.04 Precise when `default-series` is set to
  "precise" in the environment:

      juju deploy cs:precise/mysql
      juju deploy precise/mysql
      juju deploy mysql
      juju deploy local:precise/mysql
      juju deploy loca:mysql

^# juju-core 1.18.0
  A new stable release of Juju, juju-core 1.18.0, is now available. This release
  replaces 1.16.6.

  ### Getting Juju

  juju-core 1.18.0 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launch
  pad.net/%7Ejuju/+archive/stable)

  If you use the local provider, be sure to install the juju-local package if it
  is not already installed. Juju’s local requirements have changed. Upgrading
  local juju environments without the juju-local package is not advised.

  ### New and Notable

    * Support for proxies
    * Managing authorised ssh keys
    * Backup and restore the state-server (bootstrap node)
    * Run arbitrary commands on some or all instances
    * Use metadata generate-tools instead of sync-tools to generated simple streams metadata
    * The bootstrap --source option was replaced with --metadata-source
    * Timeouts for bootstrap are configurable for environments
    * Bootstrapping the local provider for lxc no longer requires sudo
    * Juju local provider can use clone for faster LXC
    * Juju now supports juju-mongodb, a mongodb tuned for juju’s needs
    * The "null" provider is now called "manual" in the juju config.
    * The destroy-environment command requires the environment name
    * Juju unset-env
    * Juju retry-provisioning
    * Bash completions include flags, machines, services, and units

  ### Resolved issues

    * --upload-tools failure preventing bootstrap completing. Lp 1239558
    * Invalid SSL certificate after rebootstrapping. Lp 1130255
    * Killing instance outside of juju, doesn't get noticed. Lp 1205451
    * Juju bootstrap fails with openstack provider (failed unmarshaling the response body) Lp 1209003
    * Manual provider bootstrap fails with error about sftp scheme. Lp 1235717
    * Manual provider doesn't install mongo from the cloud archive. Lp 1238934
    * Manual provider uses reverse-lookup result instead of "bootstrap-host" Lp 1246905
    * Manual provider requires that machines have DNS records. Lp 1254629
    * Juju broken with OpenStack Havana for tenants with multiple networks. Lp 1241674
    * Juju destroy-environment no longer returns error when no environment exists Lp 1225238
    * Local provider isn't usable after an old environment has been destroyed Lp 1238541
    * Manual provider client cache prevents reuse of env by name Lp 1238948
    * destroy-environment no longer removes .jenv Lp 1246343
    * Manual bootstrap / provisioning does not add the ubuntu user Lp 1261343
    * Concurrent charm deployments corrupts deployments Lp 1067979
    * Juju status reports 'missing' instance-state when not run as root Lp 1237259
    * Juju uses tools for the wrong architecture when unable to find correct tools Lp 1227722
    * Call to relation-get failing with 'permission denied' Lp 1239681

  ### Support for proxies

  Proxies can now be configured for the providers in the environments.yaml file,
  or added to an existing environment using "juju set-env" The configuration
  options are:

      - http-proxy
      - https-proxy
      - ftp-proxy
      - no-proxy

  The protocol-specific options accept a URL. The "no-proxy" option accepts a
  comma-separated list of host names or addresses.

  The proxy options are exported in all hook execution contexts, and also
  available in the shell through "juju ssh" or "juju run".

  There are three additional proxy options specific for apt. These are set to be
  the same as the non-apt proxy values, but can be overridden independently:

      - apt-http-proxy
      - apt-https-proxy
      - apt-ftp-proxy

  For example, with a squid-deb-proxy running on a laptop, you can specify the
  apt-http-proxy to use it for the containers by specifying the host machine’s
  network-bridge:

      apt-http-proxy: http://10.0.3.1:8000

  ### Managing authorised ssh keys

  Juju's ssh key management allows people other than the person who bootstrapped
  an environment to ssh into Juju machines/nodes. The authorised-keys command
  accepts 4 subcommands:

   * add - add ssh keys for a Juju user
   * delete - delete ssh keys for a Juju user
   * list - list ssh keys for a Juju user
   * import - import Launchpad or Github ssh keys

  `import` can be used in clouds with open networks to pull ssh keys from
  Launchpad or Github. For example:

      juju authorised-keys import lp:wallyworld

  `add` can be used to import the provided key, which is necessary for clouds
  that do not have internet access.

  Use the key fingerprint or comment to specify which key to delete. You can
  find the fingerprint for a key using `ssh-keygen`.

  Juju cannot not manage existing keys on manually provisioned machines. Juju
  will prepend "Juju:" to the comments of all keys that it adds to a machine.
  These are the only keys it can "list" or "delete".

  Note that keys are global and grant access to all machines. When a key is
  added, it is propagated to all machines in the environment. When a key is
  deleted, it is removed from all machines. You can learn more details by
  running `juju authorised-keys --help`.

  ### Backup and restore state-server (bootstrap node)

  Juju provides backup and restore commands to recover the juju state-server in
  case or failure. The juju backup command creates a tarball of the state-
  server’s configuration, keys, and environment data.

      juju switch my-env
      juju backup

  The juju restore command creates a new juju bootstrap instance using a backup
  file. It updates the existing instances in the environment to recognise the
  new state-server. The command ensures the state-server is not running before
  it creates the replacement. As with the normal bootstrap command, you can pass
  `--constraints` to setup the new state-server.

      juju switch my-env
      juju restore juju-backup-2014-02-21.tgz

  You can learn more details by running "juju restore --help".

  ### Run arbitrary commands on some or all instances

  The run command can be used by devops or scripts to inspect or do work on
  services, units, or machines. Commands for services or units are executed in a
  hook context. Charm authors can use the run command to develop and debug
  scripts that run in hooks.

  For example, to run `uname` on every instance:

      juju run "uname -a" --all

  Or to run uptime on some instances:

      juju run "uptime" --machine=2
      juju run "uptime" --service=mysql

  You can learn more details by running `juju run --help`.

  ### Use metadata generate-tools instead of sync-tools to generate
  simplestreams metadata

  The `sync-tools` command previously generated simple streams metadata for
  local juju tools when provided with the `--destination` option. This is no
  longer the case. You can create the simple streams metadata for tools thusly:

      mkdir -p $MY_DIR/tools/streams/v1
      mkdir -p $MY_DIR/tools/releases
      cp $PUBLIC_TOOLS/*tgz $MY_DIR/tools/releases
      juju metadata generate-tools -d $MY_DIR

  Upload the tools directory to your private cloud. Set the tools-metadata-url
  option in the environment’s yaml to point to the tools URL. For more details,
  run "juju metadata --help".

  The bootstrap --source option was replaced with --metadata-source

  The juju bootstrap command previously accepted the `--source` option which was
  the local path to a directory of juju tools. The bootstrap command now has a
  `--metadata-source` option that accepts the local path to simple streams
  metadata and tools. If your workflow previously was to download the juju tools
  to a local directory, then bootstrap with the `--source` option to upload the
  tools to your environment, you need to run `juju metadata generate-tools` per
  the previous section. For more details, run `juju bootstrap --help`.

  ### Timeouts for bootstrap are configurable for environments.

  Environments that need more time to provision an instance can configure 3
  options the environments.yaml. MAAS environments often need to set bootstrap-
  timeout to 1800.

   * bootstrap-timeout (default: 600s)
   * bootstrap-retry-delay (default: 5s)
   * bootstrap-addresses-delay (default: 10s)

  ### Bootstrapping the local-provider for lxc no longer requires sudo

  The Juju bootstrap command cannot be run as root. Bootstrap will prompt for a
  password to use sudo as needed to set up the environment. This addresses
  several issues that arose because the owner and permissions of the local
  environment files were different from the owner of the process. The juju
  status command for example now reports the status of the machines without the
  need to run it with sudo.

  If you have used the local provider before, you may need to manually clean up
  some files that are still owned by root. The environment’s jenv file commonly
  needs to be removed. If your local environment is named "local" then there may
  be a local.jenv owned by root with the JUJU_HOME directory (~/.juju). After
  the local environment is destroyed, you can remove the file like this

      sudo rm ~/.juju/environments/local.jenv

  Juju local provider can use clone for faster LXC

  The local provider can use lxc-clone to create the containers used as
  machines. This feature is controlled by the "lxc-clone" option. The default is
  "true" for Trusty and above, and "false" for earlier Ubuntu releases. You can
  try to use lxc-clone on earlier releases, but it is not a supported. It may
  well work. You can enable lxc-clone in environments.yaml thusly:

      lxc-clone: true

  The local provider is btrfs-aware. If your LXC directory is on a btrfs
  filesystem, the clones use snapshots and are much faster to create and take up
  much less space. There is also support for using aufs as a backing-store for
  the LXC clones, but there are some situations where aufs doesn’t entirely
  behave as intuitively as one might expect, so this must be turned on
  explicitly.

      lxc-clone-aufs: true

  When using clone, the first machine to be created will create a "template"
  machine that is used as the basis for the clones. This will be called
  `juju-[series]-template`, so for a precise image, the name is "juju-precise-
  template". Do not modify or start this image while a local provider
  environment is running because you cannot clone a running lxc machine.

  ### Juju now supports juju-mongodb, a mongodb tuned for juju’s needs

  The Juju state-server (bootstrap node) prefers juju-mongodb. The package is
  available in Ubuntu Trusty, the new db will be used when a Trusty environment
  is bootstrapped. The juju-local package on Trusty will install juju-mongodb if
  it is not already installed. Upgrades of the juju-local package will continue
  to use mongodb-server to preserve continuity with existing local environments.

  ### Destroying environments

  The destroy-environment command requires you to specify the environment name:

      juju destroy-environment my-press-site

  Previously, destroy-environment would destroy the current environment, which
  might not be the one you want to destroy.

  ### Juju unset-env

  The unset-env command allows you to reset one or more the environment
  configuration attributes to its default value in a running Juju instance.
  Attributes without defaults are removed. Attempting to remove a required
  attribute with no default will result in an error. Multiple attributes may be
  removed at once; keys are space-separated.

      juju unset-env

  ### Juju retry-provisioning

  You can use the retry-provisioning command in cases where deploying services,
  adding units, or adding machines fails. The command allows you to specify
  machines which should be retried to resolve errors reported in status.

  For example, after you deployed 100 units and machines, status reports that
  machines 3, 27 and 57 could not be provisioned because of a rate limit
  exceeded error. You can ask juju to retry:

      juju retry-provisioning 3 27 5

  ### Bash completions include flags, machines, services, and units

  Bash command line completions are improved. Pressing the TAB key will complete
  juju commands and their flags. Completion will also look up the machines,
  services, and units in an environment and suggest them.

  We encourage everyone to subscribe the mailing list at [juju-
  dev@lists.canonical.com](mailto:juju-dev@lists.canonical.com), or join us on
  #juju-dev on freenode.

^# juju-core 1.16.6
  A new stable release of Juju, juju-core 1.16.6, is now available. This release
  replaces 1.16.5.

  ### Getting Juju

  juju-core 1.16.6 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launchpad.net/%7Ejuju/+archive/stable)

  ### Resolved issues

    * Azure provider handles 307 temporary redirects poorly Lp 1269835
    * Loading state on bootstrap ignores ssl-hostname-verification setting Lp 1268913
    * Provide remove-* aliases for destroy-service and destroy-machine Lp 1261628

  ### Notable Changes

  This release addresses intermittent failures observed in recent weeks in
  Azure. Users may have seen “(request failed...307: Temporary Redirect)” when
  issuing juju commands.

  The destroy-service and destroy-machine commands were renamed to remove-
  service and remove-machine respectively. The commands are still available
  under their old names; no scripts were harmed in the making of this release.

^# juju-core 1.16.5
  A new stable release of Juju, juju-core 1.16.5, is now available. This release
  replaces 1.16.4.

  ### Getting Juju

  juju-core 1.16.5 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launchpad.net/%7Ejuju/+archive/stable)

  ### Resolved issues

   * service with no units stuck in lifecycle dying Lp 1233457
   * destroy-machine --force Lp 089291
   * destroy-machine --force plays badly with provisioner-safe-mode Lp 1259473
   * API incompatibility: ERROR no such request "DestroyMachines" on Client Lp 1252469
   * juju destroy-machine is incompatible in trunk vs 1.16 Lp 1253643
   * juju get give a "panic: index out of range" error Lp 1227952
   * [maas] juju set-env fails after upgrading to 1.16.2+ Lp 1256179
   * juju destroy-environment destroys other environments Lp 1257481

  ### Notable Changes

  Juju may report the status of a service and machine that was terminated
  outside of Juju. Juju did not notice that the machine is gone. This release
  provides minor fixes to identify the case, and a feature to explicitly tell
  juju that the machine is gone.

      juju destroy-machine --force

  The destroy-machine command will destroy the machine as needed, and remove it
  from its list of available machines. Machines that are responsible for the
  environment cannot be destroyed. Machines running units or containers can only
  be destroyed with the --force flag; doing so will also destroy all those units
  and containers without giving them any opportunity to shut down cleanly.

  Future version of Juju will notice when machines _disappear_ without the need
  of `destroy-machine --force`.

^# juju-core 1.16.4
  A new stable release of Juju, juju-core 1.16.4, is now available. This release
  replaces 1.16.3.

  ### Getting Juju

  juju-core 1.16.4 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launch
  pad.net/%7Ejuju/+archive/stable)

  ### Resolved issues

    * Update Juju to make a "safe mode" for the provisioner Lp 1254729
    * juju set-env fails for boolean attributes Lp 1254938
    * juju-update-bootstrap-address plugin Lp 1254579

^# juju-core 1.16.3

  A new stable release of Juju, juju-core 1.16.3, is now available. This release
  replaces 1.16.0.

  ### Getting Juju

  juju-core 1.16.3 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launch
  pad.net/%7Ejuju/+archive/stable)

  ### Resolved issues

    * local provider deploys fail with 'install hook failed' Lp 247299

^# juju-core 1.16.2

  A new stable release of Juju, juju-core 1.16.2, is now available. This release
  replaces 1.16.0.

  ### Getting Juju

  juju-core 1.16.2 is available in trusty and backported to earlier series in
  the following PPA [https://launchpad.net/~juju/+archive/stable](https://launch
  pad.net/%7Ejuju/+archive/stable)

  ### Resolved issues

    * Azure bootstrap fails, versioning header is not specified. All versions of juju deploying to Azure experienced this bug when Azure updated its API on 2013-10-28. This release restores service. Lp 1246320.
    * Local provider fails to start; connection refused or machines stuck in pending. Local deploys (LXC) are now given storage. Container information is now provided for MaaS config. Lp 1240709 and Lp 1246556
    * Running destroy-environment with juju on MaaS must only destroy nodes that juju controls. Lp 1081247 and Lp 1081247
    * Ensure the cloud-archive key is installed so that downloads work without additional verification. Lp 1243861.
    * Relation names can contain underscores. Lp 1245004

^# juju core 1.16.1

  Released:2013-10-31

^# juju-core 1.16.0
  A new stable release of Juju, juju-core 1.16.0, is now available.

  ### Getting Juju

  juju-core 1.16.0 is available in Saucy and backported to earlier series in the
  following PPA [https://launchpad.net/~juju/+archive/stable](https://launchpad.
  net/%7Ejuju/+archive/stable)

  ### New and Notable

    * bootstrap now matches on major and minor version numbers when locating tools
    * public-bucket-url is deprecated, use tools-url and/or image-metadata-url instead
    * users running from source no longer need to manually specify --upload-tools in order to have tools available for bootstrapping
    * tools retrieval is now handled using simplestreams metadata, similar to how image id lookup works
    * tools no longer have to be located in a publicly readable cloud storage instance; they can be served by any HTTP server eg apache
    * new constraint: tags. This constraint is currently only supported by MaaS environments, and allows you to specify nodes by tags applied to them in MaaS. Example: juju deploy mysql --constraints tags=foo,bar will deploy mysql to a node that is tagged with both the "foo" tag and the "bar" tag.
    * the "null" provider is now available, for creating environments with existing machines.
    * admin-secret is now chosen automatically if omitted from the configuration of a new environment.
    * control-bucket is now chosen automatically if omitted from the configuration for new ec2 and openstack environments.
    * Logging has changed. You can specify an environment variable "JUJU_LOGGING_CONFIG", or you can specify --logging-config on the command line. To show the log on the command line, now use --show-log. The --debug has been kept to be short-hand for `--logging-config==DEBUG --show-log`, and --verbose has been deprecated with its current meaning.

  ### Resolved issues

    * "juju add-machine ssh:..." no longer fails when an IP address is specified instead of a hostname. LP #1225825
    * Bootstrap nodes will now only run one copy of Mongodb, this will result in lower resource utilisation and faster startup of the bootstrap node. Closes LP #1210407
    * EC2 accounts in default VPC mode now work with juju. LP #1221868
    * The unset command is now available from the command line. LP #1237929 Configuration changes
    * tools-url is a new configuration option used to specify the location where the tools tarballs may be found. If specified, this overrides the default tools repository.
    * image-metadata-url is a new configuration option used to specify the location where image metadata may be found. This is only normally required for private Openstack deployments.
    * public-bucket-url is deprecated - use tools-url to specify where tools are located (if not handled automatically by your cloud provider).

  ### Testing on Canonistack and HP Cloud

  Starting with this release, there is no longer any requirement to use a
  public-bucket-url configuration attribute when bootstrapping Canonistack or HP
  Cloud environments. The public-bucket-url attribute is deprecated and you are
  advised to remove it from your environment configuration.

  ### Bootstrapping and tools

  When Juju bootstraps an environment, it searches for a tools tarball matching
  the version of the Juju client used to run the bootstrap. Prior to this
  release, any tools with the same major version number as the Juju client were
  considered a match. Starting with this release, both the major and minor
  version numbers must match. This is to prevent any subtle and hard to find
  bugs due to version mismatch from manifesting themselves.

  For users of Juju on EC2, HP Cloud, Azure, and Canonistack, where the tools
  are maintained by Canonical in the cloud itself, and MASS, with access to the
  web to download the tools, there will be no noticeable change. For private
  cloud setups, more care will be needed to ensure all the required tools
  tarballs are available.

  ### Configuring tools

  A focus of this release is to make bootstrapping a Juju environment work
  better out of the box, eliminating the need for manual configuration steps. To
  this end, the following improvements are delivered:

    1. HP Cloud and Canonistack users no longer need any special configuration over and above what goes into any generic Openstack setup for Juju.
    2. Users who compile and run Juju from source can bootstrap without manually having to tell Juju to upload a custom tools tarball. The upload-tools bootstrap option is still available to force a tools upgrade, but it is no longer required just to bootstrap the first time or when starting again after an environment has been destroyed.

  Users who wish to run Juju in HP Cloud from scratch can now just follow the
  same steps as used for EC2:

    1. run juju init
    2. source a credentials file containing username, password, region etc, or edit the newly created `~/.juju/environments.yaml` file to add username, password, region etc to the hpcloud environment block
    3. run juju bootstrap -e hpcloud

  HP Cloud users can run juju switch hpcloud to make the default environment
  hpcloud and remove the need to use the -e parameter with each Juju command.

  ### Private Openstack deployments

  Tools can now be served by any http server, or from a shared mounted directory
  accessible from the cloud, removing the requirement to place the tools in a
  cloud storage instance. Using a cloud storage instance is still possible of
  course, but this option may be more desirable for users who wish to set up a
  private cloud without outgoing web access. The steps are as follows:

    1. Copy the tools tarballs for a given Juju version to a directory named like: /tools/releases
    2. run juju sync-tools --all --source= --destination=
    3. Configure your http server to serve to contents of under http://
    4. Add tools-url: http:// to your environments.yaml file.

  An alternative to using http is to copy the tools directory itself, from , to
  a shared drive which is accessible to client machines and cloud instances via
  a common mounted directory. In that case, add an entry like this to your
  environments.yaml:


      tools-url: file://mounted_dir

  Users who still wish to place the tools in a cloud instance should copy the
  tools directory itself to a publicly readable storage instance. Thenadd the
  tools-url entry to environments.yml:


      tools-url: https:///tools

  A final alternative for locating tools is to copy the entire tools directory
  created above to the cloud’s control bucket, as specified in the
  environments.yaml file. No tools-url configuration is required, but note that
  these tools will only be visible to that one particular Juju environment.

  ### Configuring image metadata

  Just as private Openstack deployments need to configure where tools are
  located, so too does the location of the image metadata need to be specified.
  This is not applicable for supported openstack clouds like HP Cloud and
  Canonistack, only private deployments. Prior to this release, the public-
  bucket-url was used to point to the location of the metadata. Now, configure
  the image-metadata-url as follows:


      image-metadata-url: /juju-dist

  Note that the image metadata no longer has to be kept in a cloud storage
  instance. The above example simply assumes the metadata will be kept in the
  same location as prior to this release. But as with tools, the image metadata
  may be server from any http url or even a directory using `file://`

^# juju-core 1.14.1
  A new stable release of Juju, juju-core 1.14.1, is now available.

  This release replaces juju-core 1.14.0. It reconciles differences between juju
  clients.

  ### Getting Juju

  juju-core 1.14.1 is available in Saucy and backported to earlier series in the
  following PPA

  [https://launchpad.net/~juju/+archive/stable](https://launchpad.net/%7Ejuju/+archive/stable)

  ### New and Notable

    * The Microsoft Azure provider is now considered ready for use.
    * lp # 1184786 juju cli now gives a clearer error message when the deprecated default-image-id key is found.
    * When debugging hooks, juju will set the $PS1 value to $JUJU_UNIT_NAME:$JUJU_HOOK_NAME %. This results in a shorter and more useful prompt. Closes ##1212903
    * Juju plugins no longer required the caller to escape all arguments passed to the plugin.
    * The new command “juju unset …” allows a configuration setting for a service to be removed. Removing the configuration setting will revert it to the charm default. This is the first step in solving #1194945.
    * The Windows Azure provider now defines a public storage container for tools. No configuration changes are required. Closes #1216770.
    * The debug-hooks subcommand is now implemented. Closed issue #1027876
    * The status subcommand now accepts service/unit filters, to limit output; see “juju help status” for more information. Partially addresses issue #1121916
    * The juju cli command now returns a better error message when run against an environment that has not been bootstrapped. Closes issue #1028053.

  ### Resolved issues

    * The destroy-environment subcommand now requests confirmation before running, with an option to quietly proceed (-y/--yes). Closed issue #1121914.
    * The cost calculation for the openstack provider was updated to bias towards the lowest number of CPU cores when choosing a machine type matching the provided instance constraints. This closes issue #1210086.
    * The unit agent now removes stale sockets when restarting. Closes #1212916
    * A bug relating to the formatting of tool versions has been resolved. This formatting error was only visible when using the -v or --debug flag. Closes #1216285.
    * lp #1206628 a bug related to the name of an upstart job created for a service unit has been corrected.
    * lp # 1207230 a bug related specifying the type of local provider container has been corrected.

  ### Known issues

    * The JUJU_ENV environment variable is not being passed down to plugins. LP #1216254.

  ### Testing on Canonistack and HP Cloud

  A publicly readable bucket has been created for holding the Juju tools on
  Canonistack. To use it, put this in your ~/.juju/environments.yaml (all on one
  line):

      public-bucket-url: https://swift.canonistack.canonical.com/v1/AUTH_526ad877f3e3464589dc1145dfeaac60

  For HP Cloud the public bucket is available at:

      public-bucket-url: https://region-a.geo-1.objects.hpcloudsvc.com/v1/60502529753910

^# juju-core 1.14.0
  A new stable release of Juju, juju-core 1.14.0, is now available.

  ### Getting Juju

  juju-core 1.14.0 is available in Saucy and backported to earlier series in the
  following PPA

  [https://launchpad.net/~juju/+archive/stable](https://launchpad.net/%7Ejuju/+archive/stable)

  ### New and Notable

    * The Microsoft Azure provider is now considered ready for use.
    * lp # 1184786 juju cli now gives a clearer error message when the deprecated default-image-id key is found.
    * When debugging hooks, juju will set the $PS1 value to $JUJU_UNIT_NAME:$JUJU_HOOK_NAME %. This results in a shorter and more useful prompt. Closes ##1212903
    * Juju plugins no longer required the caller to escape all arguments passed to the plugin.
    * The new command “juju unset …” allows a configuration setting for a service to be removed. Removing the configuration setting will revert it to the charm default. This is the first step in solving #1194945.
    * The Windows Azure provider now defines a public storage container for tools. No configuration changes are required. Closes #1216770.
    * The debug-hooks subcommand is now implemented. Closed issue #1027876
    * The status subcommand now accepts service/unit filters, to limit output; see “juju help status” for more information. Partially addresses issue #1121916
    * The juju cli command now returns a better error message when run against an environment that has not been bootstrapped. Closes issue #1028053.

  ### Resolved issues

    * The destroy-environment subcommand now requests confirmation before running, with an option to quietly proceed (-y/--yes). Closed issue #1121914.
    * The cost calculation for the openstack provider was updated to bias towards the lowest number of CPU cores when choosing a machine type matching the provided instance constraints. This closes issue #1210086.
    * The unit agent now removes stale sockets when restarting. Closes #1212916
    * A bug relating to the formatting of tool versions has been resolved. This formatting error was only visible when using the -v or --debug flag. Closes #1216285.
    * lp #1206628 a bug related to the name of an upstart job created for a service unit has been corrected.
    * lp # 1207230 a bug related specifying the type of local provider container has been corrected.

  ### Known issues

    * The JUJU_ENV environment variable is not being passed down to plugins. LP #1216254.

  ### Testing on Canonistack and HP Cloud

  A publicly readable bucket has been created for holding the Juju tools on
  Canonistack. To use it, put this in your ~/.juju/environments.yaml (all on one
  line):

      public-bucket-url: https://swift.canonistack.canonical.com/v1/AUTH_526ad877f3e3464589dc1145dfeaac60

  For HP Cloud the public bucket is available at:

      public-bucket-url: https://region-a.geo-1.objects.hpcloudsvc.com/v1/60502529753910
