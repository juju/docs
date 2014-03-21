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

# Using the Local Provider

The purpose of the "local provider" is to provide a testing ground or sandbox
for users to experiment with Juju and speed up the process of writing charms.
Although Juju is intended to work on bare metal (via
[MAAS](http://maas.ubuntu.com)) or through a variety of cloud providers or your
own private cloud, it can also be configured to run solely on a local machine by
means of containers or virtualisation.

Currently, the only stable implementation of this is using the Linux containers
system, LXC ([see linuxcontainers.org](http://linuxcontainers.org/)). However,
this option isn't available to those running Juju on Mac and Windows systems.
Therefore, further methods of containerisation and virtualisation are being
added. These are collectively referred to as using "the local provider", even
though the actual underlying technology may be very different. Whichever method
you use, ultimately it should be largely transparent to the user.

The following pages cover the different local providers available:

  - [Installing and configuring Juju for LXC (Linux)](./config-LXC.html)
  - [Using Juju with Vagrant(Linux/Mac/Windows)](./config-vagrant.html)`Beta!`
  - Running Juju with virtualised containers. `Coming Soon!`

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

