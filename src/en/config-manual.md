[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Manual Provisioning

## Introduction

Juju provides a feature called "manual provisioning" that enables you to deploy
Juju, and charms, to existing systems. This is useful if you have groups of
machines that you want to use for Juju but don't want to add the complexity of a
new OpenStack or MAAS setup. It is also useful as a means of deploying workloads
to VPS providers and other cheap hosting options. We will describe in this
section how to configure an environment using this feature.

## Prerequisites

Manual provisioning enables you to run Juju on systems that have a supported
operating system installed. You will need to ensure that you have both SSH
access and sudo rights. It is not necessary to [have a password-less
login](https://help.ubuntu.com/community/SSH/OpenSSH/Keys), however it will
improve the experience by reducing the need for repeated logins.

## Configuration

You should start by generating a generic configuration file for Juju and then
switching to the Manual provider by using the command:

    
    
    juju generate-config
    juju switch manual
    

This will generate a file, __environments.yaml__ (if it doesn't already exist),
which will live in your __~/.juju/__ directory (and will create the directory if
it doesn't already exist).

__Note:__ If you have an existing configuration, you can use `juju generate-
config --show` to output the new config file, then copy and paste relevant areas
in a text editor etc.

The generic configuration sections generated for the manual provider will look
something like this, though Juju will generate this automatically you usually
don't need to edit it:

    
    
    ## https://juju.ubuntu.com/docs/config-manual.html
        manual:
            type: manual
            # bootstrap-host holds the host name of the machine where the
            # bootstrap machine agent will be started.
            bootstrap-host: somehost.example.com
    
            # bootstrap-user specifies the user to authenticate as when
            # connecting to the bootstrap machine. If defaults to
            # the current user.
            # bootstrap-user: joebloggs
    
            # storage-listen-ip specifies the IP address that the
            # bootstrap machine's Juju storage server will listen
            # on. By default, storage will be served on all
            # network interfaces.
            # storage-listen-ip:
    
            # storage-port specifes the TCP port that the
            # bootstrap machine's Juju storage server will listen
            # on. It defaults to 8040
            # storage-port: 8040
    

When bootstrapped, tools storage will be served from the `bootstrap-host` on the
specified `storage-listen-ip` and `storage-port`.

The manual provider does not perform automatic machine provisioning like other
providers; instead, you must manually provision machines into the environment.
Provisioning machines is described in the following sections.

## Bootstrapping

To bootstrap a manual environment, you must specify the `bootstrap-host`
configuration, and optionally the `bootstrap-user` configuration. If `bootstrap-
user` is not specified, then Juju will ssh to the bootstrap host as the current
user. Once the configuration is specified, you bootstrap as usual:

    
    
    juju bootstrap
    

The `juju bootstrap` command will connect to `bootstrap-host` via SSH, and copy
across and install the Juju agent.

__Note:__ Automated destruction of manual environments is currently
unimplemented. To remove Juju from the `bootstrap-host`, you will need to
manually stop and remove the upstart jobs (`/etc/init/juju*`).

## Adding machines

To add another machine into a manual environment, you must use a variant of the
`juju add-machine` command, such as follows:

    
    
    juju add-machine ssh:juju.ubuntu.com
    juju add-machine ssh:10.1.1.2
    juju add-machine ssh:otheruser@10.1.1.3
    

As with bootstrapping, `juju add-machine ssh:...` will connect to the machine
via SSH to install the Juju agent. Machines added in this way may be removed in
the usual manner, with `juju destroy-machine`.

## Considerations and caveats

As is implied by its name, the manual provider does not attempt to control all
aspects of the environment, and leaves much to the user. There are several
additional things to consider:

  - All machines added with `juju add-machine ssh:...` must be able to address and communicate directly with the `bootstrap-host`, and vice-versa.
  - Sudo access is required on all manually provisioned machines, to install the Juju upstart services.
  - Manually provisioned machines must be running a supported version of Ubuntu (12.04+).
  - It is not currently possible to manually provision machines into non-manual provider environments.
  - Since adding machines is a manual step, using the manual provider doesn't have the "instant elasticity" benefits of using a proper provider; if you're an IaaS provider and want to help us natively support you, [please contact us](https://juju.ubuntu.com/community/).

  - ## [Juju](/)

    - [Charms](/charms)
    - [Features](/features)
    - [Deployment](/deployment)
  - ## [Resources](/resources)

    - [Overview](/resources/juju-overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/the-juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://canonical.com).

