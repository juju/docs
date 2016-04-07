Title: Using the local provider  

# Using the Local Provider

The purpose of the "local provider" is to provide a testing ground or sandbox
for users to experiment with Juju and to speed up the process of writing
charms. Although Juju is intended to work on bare metal (via
[MAAS](http://maas.io)) or through a variety of cloud providers or your
own private cloud, it can also be configured to run solely on a local machine
by means of containers or virtualisation.

Currently, the only stable implementation of this is using Linux containers,
LXD ([see linuxcontainers.org](http://www.ubuntu.com/cloud/lxd)). However, this
option isn't available to those running Juju on Mac and Windows systems so
further methods of containerisation and virtualisation are intended to be
added. These are collectively referred to as using "the local provider", even
though the actual underlying technology may be very different. Whichever method
you use, ultimately it should be largely transparent to the user.

The following pages cover the different local providers available:

  - [LXD (Linux)](./config-LXD.html)
  - [Vagrant (Linux/Mac/Windows)](./config-vagrant.html) `Beta!`
  - Running Juju with virtualised containers. `Coming Soon!`
