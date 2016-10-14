Title: Introducing Juju 2.0
TODO: Add extra changes as required
      Test upgrade instructions

# Introducing Juju 2.0

If you are familiar with Juju, you are no doubt excited to get started with the
wealth of powerful new features introduced in the new 2.0 release (and if you 
haven't tried Juju before, see [this introduction][aboutjuju]). But 
what are the new features? What has changed? 
This page will give you an overview of the significant changes that you really
need to know about before you do anything else, followed by a short guide to 
upgrading your existing Juju client and deployments to the very latest version.
You can also review the [complete release notes here][releasenotes].

 - **Commands:** Probably the most immediate change you will come across is that
practically every command has changed! Really! Significant work has been done to
make the commands more consistent, logical and easy to understand. For example, 
instead of ```juju authorised-keys add <xxxx>``` you will now use the command
   ```juju add-ssh-key <xxxx>```
   It reads better, is more straightforward, and 
works really well with tab completion! The documentation has been updated to
include all these new commands, so you can check relevant pages for guides to
the new commands, or browse through the [reference guide][referenceguide].
There is also a handy [crib sheet][commandchanges] to show you the new
versions of old commands.

 - **Terminology:** You are probably used to thinking of Juju in terms of the 
bootstrap node (state server) and environments. You will now find that the 
documentation talks about "Controllers" and "models" instead. Why? Part of this
is to do with the way Juju organises itself - now multiple models (environments)
can be driven from one controller (state-server). This means that for a given
cloud you only need one controller, but can drive several models. You should 
also check through our [tutorial about sharing clouds with users][users]
to understand how these models can be shared.

  - **Providers:** As well as updates to the Azure provider and the new 
Rackspace provider, Juju now makes extensive use of LXD. This makes 'local' 
models leaner and faster and also brings benefits to placing containers within 
models. You can find out more about setting up 
[LXD for Juju here][lxd].

## Juju and MAAS

Juju supports MAAS 1.9, 2.0 and 2.1.

## Upgrading from earlier versions

At the current time, there is no upgrade path from Juju 1.x to Juju 2.x

Both versions of Juju can co-exist, however. We will be adding documentation
to explain how to manage both versions, and how to upgrade when it does become
available


[lxd]: ./clouds-LXD.html
[users]: ./tut-users.html
[aboutjuju]: ./about-juju.html
[releasenotes]: ./reference-release-notes.html
[referenceguide]: ./commands.html
[commandchanges]: ./command-changes.html
