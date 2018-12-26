Title: Upgrading
TODO:  Provide specific examples of how one component upgrade influence another component upgrade

# Upgrading

There are a number of software components in the Juju universe that can be
upgraded. Please visit the page dedicated to the task you're interested in.

 - [Upgrading a machine series][upgrade-series]  
   This affects the series (release) of the underlying operating system of a
   Juju machine, including a controller.
 - [Upgrading models][upgrade-models]  
   This affects the version of Juju running on a Juju machine in the form of
   machine agents and unit agents.
 - [Upgrading applications][upgrade-applications]  
   This affects the version of an already deployed charm.
 - [Upgrading the client][upgrade-client]  
   This affects the version of the Juju client.

There is no inherent reason to upgrade components at the same time or to
upgrade components in a specific order. What often dictates an upgrade is a
desired feature in a new version of one component. This may, either before or
after, necessitate the upgrade of another component.


 <!-- LINKS -->

[upgrade-series]: ./upgrade-series.md
[upgrade-models]: ./models-upgrade.md
[upgrade-applications]: ./charms-upgrading.md
[upgrade-client]: ./client.md#client-upgrades
