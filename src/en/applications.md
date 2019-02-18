Title: Applications

# Applications

An *application* in Juju is a collection of identical application *units* that
are installed via a *charm*.

## Application management

Common application management tasks are summarised below.

The most important ones are [Deploying applications][charms-deploying] and
[Managing relations][charms-relations].


^# Application groups
   
   Application groups allow an operator to manage groups of the same
   application by providing custom application names during deployment.
   
   See the [Application groups][charms-groups] page for details.


^# Application high availability
   
   Application high availability pertains to the distribution of units over
   availability zones.
   
   See the [Application high availability][charms-ha] page for full
   information.


^# Application metrics

   Metrics for applications can be collected for the purposes of model-level
   assessment of application utilisation and capacity planning.
   
   See the [Application metrics][charms-metrics] page to learn more.


^# Configure applications
   
   Applications can have their configuration options set during, or after,
   deployment.

   The [Configuring applications][charms-config] page explains how this is
   done.


^# Deploy applications
  
   The [Deploying applications][charms-deploying] page covers an array of
   methods for getting your applications deployed.
  
   The [Deploying applications - advanced][charms-deploying] page contains more
   advanced use cases.
  
   See the [Deploying charms offline][charms-offline-deploying] page for
   guidance when deploying in a network-restricted environment.

   Applications can be deployed and configured as a collection of charms. This
   subject is treated on the [Charm bundles][charms-bundles] page.
 

^# Relate applications
  
   When an application requires another application in order to fulfil its
   purpose they need to be logically linked together. In Juju, such a link
   is called a *relation*.
   
   The [Managing relations][charms-relations] page explains this important
   concept.


^# Scale applications
   
   Juju horizontally scales applications up and down by adding and removing
   application units.
   
   The [Scaling applications][charms-scaling] page for details.
  

^# Upgrade an application
   
   Upgrading an application in Juju means to upgrade the application's charm.

   See the [Upgrading applications][charms-upgrading] page for in-depth
   coverage.


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.md
[charms-deploying-advanced]: ./charms-deploying-advanced.md
[charms-offline-deploying]: ./charms-offline-deploying.md
[charms-upgrading]: ./charms-upgrading.md
[charms-config]: ./charms-config.md
[charms-scaling]: ./charms-scaling.md
[charms-bundles]: ./charms-bundles.md
[charms-metrics]: ./charms-metrics.md
[charms-groups]: ./charms-service-groups.md
[charms-ha]: ./charms-ha.md
[charms-relations]: ./charms-relations.md
