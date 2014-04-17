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

# Charm Features

People demand quality out of their tools, and the Charm Store is no different.
So what does a good charm look like? These are some guidelines on what we think
an ideal charm provides users. So we rate charms by the following criteria.
These features are shown to users in the charm store so that they can see what
features a charm provides at a glance.

**Note: **This is an ideal list of what we'd like charms to be. Most charms today do not offer every feature; it's a target we set for ourselves so we can determine how we can improve individual charms. It also gives contributors a general idea of where they can spend their time to fix something.

## Data Handling

  - Handles the service's user data - Gracefully handle the service's user data so that the user doesn't have to manage it seperately.
  - Provides backup mechanism - Provide a backup mechanism to the service's user data, such as a relationship to a backup subordinate charm, snapshots to a bucket, or other means of getting the data off of the instance.
  - Provides a restore mechanism - Provide a restore mechanism to the service's user data, such as a relationship to a backup subordinate charm, restoring from a bucket, or other means of getting data onto the instance.
  - Provides encryption - Provides encryption of service user data.

## Secure

  - Contains a well tested [AppArmor profile](https://help.ubuntu.com/12.04/serverguide/apparmor.html) - These can be provided by the package itself.
  - Doesn't run as root - the service should not run as root. Refer to the [Upstart documentation](http://upstart.ubuntu.com/cookbook/#run-a-job-as-a-different-user) for tips on how to do this.
  - Per instance or service access control - Accept relationships only from trusted instances and/or services.
  - Defaults to secure communication - default to secure channels when communicating with other services and/or multiple units of the same service.

## Reliable

  - Fails gracefully if upstream source goes missing - Sometimes URLs change or upstream services are not available.
  - Contains a suite of integration tests with the charm that pass - We provide [Amulet](howto-amulet.html) to help you do this.
  - Configuration options have safe defaults

## Scaleable

  - Responds to add-unit based on the service's needs - Users should be able to `juju add-unit` to your service and have it scale horizontally.
  - Responds to remove-unit based on the service's needs - Users should be able to `juju remove-unit` to your service and have it scale down.
  - Reuses existing charms for supporting services - If the service needs relationships to other services it should reuse existing charms from the charm store instead of bundling its own.
  - Monitoring - has relationships to allow the service to be monitored by any existing monitoring charm.
  - Remote Logging - has relationships to allow the service to remote log.
  - ## Upstream Friendly

  - Follow deployment recommendations from upstream best practices - Most services have a known-good recommendation from the project itself, these should be available for users
  - Provide up to date versions of the upstream release - Provide a config option to allow the user to run newer versions of the service.

## Flexible

  - Exposes version of service as a config option to allow easy upgrades - this allows users to maintain their deployments without having to redeploy.
  - Adheres to the coding guidelines of the language your charm is written in
  - Exposed configurations are subsets of opinionated deployments - Don't expose every service option as config. Make sets of decisions and expose those as one config option. For example "fast" vs. "default" vs. "slow-and-safer".
  - Allow installation from the Ubuntu repository - this should be the default if the service is in Ubuntu.
  - Allow installation from pure upstream source - Sometimes people prefer to deploy from pure upstream
  - Allow installation from your local source - Sometimes people prefer to deploy from their vetted local source.
  - Allow installation from PPA or other repository - if available. Some upstreams run their own repositories that they gate and support, users should have an option of using these.

## Easy to Deploy

These will move to policy soon, so consider this a temporary category.

  - README with examples of use for a typical workload
  - README with examples of use for workloads at scale
  - README with examples of use recommend best-practice relationships

  - ## [Juju](/)

    - [Charms](/charms/)
    - [Features](/features/)
    - [Deployment](/deployment/)
  - ## [Resources](/resources/)

    - [Overview](/resources/overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/juju-gui/)
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
    - [Juju Labs](/communiy/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013-2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://www.canonical.com).

