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

# The Juju Charm Store

Juju includes a collection of what we call `Charms` that let you deploy whatever
services you want in Juju. A collection of charms that are designed to work
together is called a `Bundle`. Since charms and bundles are open and worked on
by the community, they represent a distilled set of best practices for deploying
these services. Both charms and bundles are included in what we collectively
call The Charm Store.

  - The main project page is here: [https://launchpad.net/charms](https://launchpad.net/charms)
  - There are useful tools for downloading, modifying, and contributing here: [https://launchpad.net/charm-tools](https://launchpad.net/charm-tools)
  - Here is the official tutorial for charm authors: [https://juju.ubuntu.com/docs/write-charm.html](https://juju.ubuntu.com/docs/write-charm.html)
  - Here is the official tutorial for bundle authors: [https://juju.ubuntu.com/docs/charms-bundles.html](https://juju.ubuntu.com/docs/charms-bundles.html)

## Charm Store Process

This process is designed to allow prospective developers to have their charms
reviewed and updated in the [Charm Store](http://jujucharms.com) in a timely
manner that ensures peer reviews and quality.

## Submitting a new Charm

  1. Install juju and charm-tools.
  2. Create a repository, something like `mkdir -p ~/charms/precise`, precise is the release code name for the [release of Ubuntu](http://releases.ubuntu.com) you wish to target your charm at.
  3. If you haven't created your charm yet, you can use `charm create ubuntu-package-name` which will fill in some basic metadata info for you. You can check to see if it already exists at [http://jujucharms.com/](http://jujucharms.com/). Also make sure to [check the list of open charms](http://goo.gl/mvtPh) to see if anybody is already working on a charm for the service you want to work on. Bugs which have had no activity by the assignee for more than 30 days are fair game and should be unassigned.
  4. Once your charm is working and tested with any compatible charms, make sure it passes `charm proof path/to/your/charm`
  5. `bzr init` in your charm's root directory
  6. `bzr add` to add all files.
  7. `bzr ci -m'Initial charm'`
  8. `bzr push lp:~your-launchpad-username/charms/precise/your-charms-name/trunk`
  9. File a bug against charms at [https://launchpad.net/charms/+filebug](https://launchpad.net/charms/+filebug) This is used to track the progress of your charm.
  10. Now you just need to attach your branch to the bug report, go to [your code page](https://code.launchpad.net/people/+me), find your branch, and click on it. Then click on "Link a bug report", and put in the number of the bug you filed.
  11. Subscribe the `charmers` team by clicking "Subscribe someone else" on the right side of the launchpad page. This is important as it gets your charm in the review queue!

Your charm should then be looked at in a timely manner.

## Submitting a fix to an existing Charm

  1. Grab the charm you want to fix, we'll use Nagios as an example: `bzr branch lp:charms/precise/nagios`
  2. Modify it to meet your needs.
  3. Commit your fixes `bzr commit -m'Your changelog entry goes here'`
  4. `bzr push lp:~your-launchpad-username/charms/precise/nagios/fixed-charms-name`
  5. Submit a [merge proposal](https://help.launchpad.net/BranchMergeProposals) by going to your branch's code page: `https://code.launchpad.net/~charmers/charms/precise/nagios/trunk` and clicking "Propose for merging"
  6. In the merge proposal form select the charm's lp name: `~lp:charms/nagios`
  7. For the reviewer field put the `charmers` team, this will get your code into the review queue!

## Submitting bundles to the Charm Store

Refer to the [Bundles page](charms-bundles.html) for instructions on how to
create bundles of charms and submit them to the store.

## Getting Help

Inspired by [Bazaar's Patch Pilot
programme](http://wiki.bazaar.canonical.com/PatchPilot) there will be patch
pilots in #juju who can help you get your patch accepted. Check the topic to see
who's on duty. Still need help? Contact us on [the Juju mailing
list](https://lists.ubuntu.com/mailman/listinfo/juju) ; if you're from an
upstream project who wants more detailed help/tutoring, then contact [Jorge
Castro](http://launchpad.net/~jorge) and we'd be more than happy to get a charm
expert to help you out or help you run a Charm School.

Some notes:

  - Please respect that these people might have a few other charms in their queue already.
  - The package you have a question about might not necessarily be part of the patch pilot's area of expertise. They will still try to help you get your fix in and probably get you in touch with the 'right' people.

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

