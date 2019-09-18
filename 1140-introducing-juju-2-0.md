<!--
Todo:
- Add extra changes as required
- Critical: review required
-->
If you are familiar with Juju, you are no doubt excited to get started with the wealth of powerful new features introduced in the new 2.0 release (and if you haven't tried Juju before, see [this introduction](/t/what-is-juju/1032)). But what are the new features? What has changed?

This page will give you an overview of the significant changes that you really need to know about before you do anything else. You can also review the [complete release notes here](/t/release-notes/1166).

-   **Commands:** Probably the most immediate change you will come across is that practically every command has changed! Really! Significant work has been done to make the commands more consistent, logical and easy to understand. For example, instead of `juju authorised-keys add <xxxx>` you will now use the command `juju add-ssh-key <xxxx>`. It reads better, is more straightforward, and works really well with tab completion! The documentation has been updated to include all these new commands, so you can check relevant pages for guides to the new commands, or browse through the [reference guide](./commands.md). There is also a handy [crib sheet](/t/command-changes-from-1-25-to-2-0/1101) to show you the new versions of old commands.

-   **Terminology:** You are probably used to thinking of Juju in terms of the bootstrap node (state server) and environments. You will now find that the documentation talks about "Controllers" and "models" instead. Why? Part of this is to do with the way Juju organises itself - now multiple models (environments) can be driven from one controller (state-server). This means that for a given cloud you only need one controller, but can drive several models.

-   **Providers:** As well as updates to the Azure provider and the new Rackspace provider, Juju now makes extensive use of LXD. This makes 'local' models leaner and faster and also brings benefits to placing containers within models. Find out more by reading the [Using LXD with Juju](/t/using-lxd-with-juju/1093) page.

-   **Configless clouds:** Why fill out loads of configuration info about public clouds when you don't have to? Juju now ships with 'baked-in' knowledge of a range of clouds - just provide your credentials (with the help of all-new interactive tools) and you're off!

-   **Users and sharing:** Don't keep it to yourself - Juju 2.0 supports multi-user access to controllers and models. [Follow the tutorial](/t/a-multi-user-cloud/1190) or read up on all the related commands [here](/t/user-types-and-abilities/1201)

<h2 id="heading--upgrading-from-earlier-versions">Upgrading from earlier versions</h2>

At the current time, there is no upgrade path from Juju 1.x to Juju 2.x

However, both versions of Juju can co-exist on Ubuntu, so you can continue to operate legacy systems and still use the powerful new features of 2.0. Please see the [additional information](/t/running-multiple-versions-of-juju/1143) on running multiple versions of Juju.

<!-- LINKS -->
