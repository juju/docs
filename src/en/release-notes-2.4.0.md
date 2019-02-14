Title: 2.4.0 Release Notes 

# 2.4.0 Release Notes

The Juju team is proud to release version 2.4. This release greatly improves
running and operating production infrastructure at scale. Improvements to
`juju status` output, easier maintenance of Controller high availability, and
guiding Juju to the correct management network all aid in keeping your
infrastructure running smoothly.  

For highlights of this release, please see the
[What's new in 2.4](https://docs.jujucharms.com/2.4/en/whats-new) page in the
documentation. Further details are below.

## New and improved.

**Bionic support**  
Juju 2.4 fully supports running controllers and workloads on Ubuntu 18.04 LTS
(Bionic), including leveraging `netplan` for network management. 

**LXD enhancements**  

- LXD functionality has been updated to support the latest LXD 3.0.

- Juju supports LXD installed as a Snap and defaults to Snap-installed
  LXD by default if it is present. 

- A basic model of LXD clustering is now supported with the following
  conditions:

    - The juju bootstrap of the localhost cloud must be performed on a
      cluster member.

    - Bridge networking on clustered machines must be set up to allow
      egress traffic to the controller container(s).

**Improvements to `juju status` output**  

- The 'Relations' section

    - When filtering by application name, only direct relations are shown.

    - In tabular format, the 'Relations' section is no longer visible by
    default.  Use the `--relations` option to see it (
    [LP 1633972](https://bugs.launchpad.net/juju/+bug/1633972)).

    - Clarifying empty output - whether it is due to a model being empty
      or because a provided filter did not match anything on the model
  (
  [LP 1255786](https://bugs.launchpad.net/juju/+bug/1255786),
  [LP 1696245](https://bugs.launchpad.net/juju/+bug/1696245), and
  [LP 1594883](https://bugs.launchpad.net/juju/+bug/1594883)).

- Addition of a (controller) timestamp (
  [LP 1765404](https://bugs.launchpad.net/juju/+bug/1765404)).

- Reordering of the status model table to improve consistency between
  model updates. 

- Inclusion of application endpoint binding information (in YAML and JSON
  formats). For each endpoint, the space to which it is bound is
  provided.

**Controller configuration options for spaces**  
Two new controller configuration settings have been introduced. These are:

- juju-mgmt-space
- juju-ha-space

'juju-mgmt-space' is the name of the network space used by agents to
communicate with controllers. Setting a value for this item limits the IP
addresses of controller API endpoints in agent config, to those in the space.
If the value is misconfigured so as to expose no addresses to agents, then a
fallback to all available addresses results. Juju client communication with
controllers is unaffected by this value.

'juju-ha-space' is the name of the network space used for MongoDB replica-set
communication in high availability (HA) setups. This replaces the previously
auto-detected space used for such communication. When enabling HA, this value
must be set where member machines in a HA set have more than one IP address
available for MongoDB use, otherwise an error will be reported. Existing HA
replica sets with multiple available addresses will report a warning instead
of an error provided the members and addresses remain unchanged.

Using either of these options during `bootstrap` or `enable-ha` effectively
adds constraints to machine provisioning. The commands will fail with an
error if such constraints can not be satisfied.

**Rework of `juju enable-ha`**  
In Juju 2.4 you can no longer use `juju enable-ha` to demote controllers.
Instead you can now use the usual `juju remove-machine` command, targeting
a controller machine. This will gracefully remove the machine as a controller
and from the database replica set. This method does allow you to end up with
an even number of controllers, which is not a recommended configuration.
After removing a controller it is therefore recommended to run
`juju enable-ha` to bring back proper redundancy. When the machine is gone
and not available to run its own teardown and cleanup processes
`juju remove-machine --force` should be used. See
[Controller high availability](./controllers-ha).

**Model owner changes**  
The concept of model owner is becoming obsolete. Model owner is just another
model user with administrative access. We are working to remove any special
access that the model owner has, and move to having the models in a namespace
rather than grouped by owner.

**Charm goal state**  
Charm goal state allows charms to discover relevant information about their
deployment. The key pieces of information a charm needs to discover are:

 - what other peer units have been deployed and their status
 - what remote units exist on the other end of each endpoint, and their status

Charms use a new goal-state hook command to query the information about their
deployment. This hook command will print only YAML or JSON output (default
yaml):

	  goal-state --format yaml

The output will be a subset of that produced by the juju status command. There
will be output for sibling (peer) units and relation state per unit.

The unit status values are the workload status of the (sibling) peer units. We
also use a unit status value of dying when the unit's life becomes dying. Thus
unit status is one of:

 - allocating
 - active
 - waiting
 - blocked
 - error
 - dying

The relation status values are determined per unit and depend on whether the
unit has entered or left scope. The possible values are:

 - joining (relation created but unit not yet entered scope)
 - joined (unit has entered scope and relation is active)
 - broken (unit has left, or is preparing to leave scope)
 - suspended (parent cross model relation is suspended)
 - error

By reporting error state, the charm has a chance to determine that goal state
may not be reached due to some external cause. As with status, we will report
the time since the status changed to allow the charm to empirically guess that
a peer may have become stuck if it has not yet reached active state.

**Cloud credential changes**  
Cloud credentials are used by models to authenticate communications with the
underlying provider as well as to perform authorised operations on this
provider. 

Juju has always dealt with both cloud credentials stored locally on a user’s
client machine as well as the cloud credentials stored remotely on a
controller. The distinction has not been made clear previously and this
release addresses these ambiguities:

 - Basic cloud credential information such as its name and owner have been
   added to the `show-model` command output. 

 - The new `show-credential` command shows a logged on user their remotely
   stored cloud credentials along with models that use them.

**New proxy configuration settings**  
There are four new model configuration keys affecting proxy behaviour that
have a Juju-only scope (i.e. not system-wide). Existing model configuration
for proxies remain unchanged, and any existing model or controller should not
notice any changes. The new keys are:

`juju-http-proxy`  
`juju-https-proxy`  
`juju-ftp-proxy`  
`juju-no-proxy`

These Juju-specific proxy settings are incompatible with the four
corresponding legacy proxy settings and data validation is enabled to prevent
collisions from occurring.

The `juju-no-proxy` key can and should contain CIDR-formatted values for
subnets. The controller machines are not added automatically to this key, so
the internal network that is used should appear within it if there are other
proxies set.

The new proxy values are passed to the charm hook contexts as the following
environment variables, respectively:

`JUJU_CHARM_HTTP_PROXY`  
`JUJU_CHARM_HTTPS_PROXY`  
`JUJU_CHARM_FTP_PROXY`  
`JUJU_CHARM_NO_PROXY`

The rationale behind this change is to better support proxies in situations
where there are larger subnets, or multiple subnets, that should not be
proxied. The traditional 'no_proxy' values cannot have CIDR values as they
are not understood by many tools.

Work is also underway to introduce further granularity that will allow
specific libraries (e.g. `charm-helpers`) to enable a proxy setting on a
per-call basis. This is still under development.

**Upgrading models across release streams**  
The `upgrade-model` command now supports upgrading to a different agent
stream ('devel', 'proposed', 'released') via the `--agent-stream` option.
Note that this is different from `--agent-version`.

**Backup and restore behaviour changes**  
Backups are no longer stored on the controller by default. The `--keep-copy`
option has been added to provide that behaviour. The `--no-download` option
prevents a locally stored backup and implies `--keep-copy`.

The `restore-backup` command loses the `-b` option (to create a new
controller). A new controller should now be created in the usual way
(`bootstrap`) and then restore to it.

## Get Juju.

The easiest way to get Juju is by using the `snap` package.

	  sudo snap install juju --classic

## Fixes.

Some important fixes include:

- `network-get` can return incorrect CIDRs (
[LP 1770127](https://bugs.launchpad.net/bugs/1770127)).

- Change in behaviour in status output: 'Relations' section is not visible by
default in tabular format (
[LP 1633972](https://bugs.launchpad.net/bugs/1633972)).

- Fixes for when /var, /etc, /tmp are on different partitions (
[LP 1634390](https://bugs.launchpad.net/bugs/1634390) and
[LP 1751291](https://bugs.launchpad.net/bugs/1751291)).

- networking related fixes (
[LP 1733266](https://bugs.launchpad.net/bugs/1733266),
[LP 1764735](https://bugs.launchpad.net/bugs/1764735), and
[LP 1771120](https://bugs.launchpad.net/bugs/1771120)).

- juju resolve fix / improvement (
[LP 1755141](https://bugs.launchpad.net/bugs/1755141) and
[LP 1762979](https://bugs.launchpad.net/bugs/1762979)).

- support for st1 and sc1 volume types on AWS (
[LP 1753593](https://bugs.launchpad.net/bugs/1753593)).

- support for new AWS instance types (
[LP 1754735](https://bugs.launchpad.net/bugs/1754735)).

For a detailed breakdown of fixed bugs:

[https://launchpad.net/juju/+milestone/2.4.0](https://launchpad.net/juju/+milestone/2.4.0)  
[https://launchpad.net/juju/+milestone/2.4-rc3](https://launchpad.net/juju/+milestone/2.4-rc3)  
[https://launchpad.net/juju/+milestone/2.4-rc2](https://launchpad.net/juju/+milestone/2.4-rc2)  
[https://launchpad.net/juju/+milestone/2.4-rc1](https://launchpad.net/juju/+milestone/2.4-rc1)  
[https://launchpad.net/juju/+milestone/2.4-beta3](https://launchpad.net/juju/+milestone/2.4-beta3)  
[https://launchpad.net/juju/+milestone/2.4-beta2](https://launchpad.net/juju/+milestone/2.4-beta2)  
[https://launchpad.net/juju/+milestone/2.4-beta1](https://launchpad.net/juju/+milestone/2.4-beta1)

If you were affected by any of the bugs fixed in this release, your feedback
is appreciated. Please contact the Juju team using the communication channels
specified in the feedback section.

## Feedback appreciated.

We encourage everyone to let us know how you're using Juju. You can send us a
message on Twitter using `#jujucharms`, join us in the freenode IRC channel
`#juju`, or subscribe to the [Juju Discourse forum][juju-discourse-forum].

## More information.

To learn more about Juju visit our home page at 
[https://jujucharms.com][upstream-juju].


<!-- LINKS -->

[reference-install]: ./reference-install.md
[juju-discourse-forum]: https://discourse.jujucharms.com/
[upstream-juju]: https://jujucharms.com
