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

