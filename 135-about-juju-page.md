# About Juju

This is the proposed front-facing introduction to Juju. Feedback requested.
 
---

Juju is an open source application modeling tool. With it, you can deploy, configure, scale, and operate your software on public and private clouds.

Application modeling is a concise way of describing what software should actually do, specified from the top down (services and how they relate) rather than built from the bottom up. This allows for a clean and portable expression of intent rather than a complicated recipe.

The fundamental purpose of Juju is to deploy and manage software applications in a way that is fast, easy, and repeatable. All this is done with the help of "charms", which are bits of code that contain all the necessary intelligence to do these things.

The central online Charm Store provides an easy means for the distribution of charms. The store contains charms maintained both by Canonical and the community. Charms can be free or commercial. Although most charms on the store are public, charms can also be private or restricted to a group of users.

Juju supports the following clouds:

Amazon AWS
Microsoft Azure
Google GCE
Oracle Compute
Rackspace
Joyent
VMware vSphere
OpenStack
MAAS
LXD
Manual

Many of these clouds are even known to Juju out of the box. For these, all you need to do is tell Juju what your cloud credentials are and you're good to go: you can start deploying services! For the other clouds, it is a simple matter of adding them to Juju's list of known clouds.
