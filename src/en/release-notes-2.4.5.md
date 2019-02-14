Title: 2.4.5 Release Notes 

# 2.4.5 Release Notes

This is primarily a bugfix release for the 2.4 series but comes with one new
feature and several improvements.

The `export-bundle` feature is cleared from the feature flag. Many of the
bugs involve helping Juju deal better at scale with thousands of units
running in models on a single controller. On restart Juju is now smarter
about retrying randomization and backing off retries along with other scale
based improvements.

## Enhancements

**New `export-bundle` command**

Juju now has an `export-bundle` command that generates a bundle from a given
model. In any model use this command to output a reusable description of the
model to deploy a second time, to backup and check for differences, or to
submit to the Charm Store.

**Controller API port configuration key**

The new configuration key 'controller-api-port' allows controller connections
to occur on a separate port than that used by other agent connections, and
the standard port won't accept connections until the controllers are
connected. This can be of use when the number of units is very large
(thousands). When the controller agent restarts it helps make sure the HA
controllers are all up and synchronised before handling connection requests
from the units.

    juju bootstrap --config controller-api-port=17071 cloud-name controller-name

This feature can be implemented in real time (i.e. post-bootstrap):

    juju controller-config controller-api-port=17071

This feature is disabled by setting the port to zero:

    juju controller-config controller-api-port=0

In a future release this key will become required and immutable like the
normal 'api-port' key.

**Scale improvements**

Several improvements have been made to deal with the load caused by a large
number of agents. Each agent's workers now have an exponential backoff on
failure. Additionally, agent requests are now more evenly distributed over
controllers.

## Other fixes

This release also includes the following important fixes:

- [LP #1793245](https://bugs.launchpad.net/juju/2.4/+bug/1793245) - addresses agents randomizing their connections and exponential backoff
- [LP #1795499](https://bugs.launchpad.net/juju/2.4/+bug/1795499) - cross model relation breaks after removing relation
- [LP #1796106](https://bugs.launchpad.net/juju/2.4/+bug/1796106) - can’t bring up containers on a manually provisioned machine

For the full list of fixes and additions, see the
[2.4.5 milestone](https://launchpad.net/juju/+milestone/2.4.5).

## Get Juju

The easiest way to install Juju is by using the `snap` package:

	  sudo snap install juju --classic

Those already using the 'stable' snap channel (the default as per the above
command) should be upgraded automatically. Other packages are available for a
variety of platforms (see the [install documentation][reference-install]).

## Feedback appreciated

Let us know how you're using Juju or of any questions you may have. You can
join us on [Discourse][juju-discourse-forum], send us a message on Twitter
(hashtag `#jujucharms`), or talk to us in the `#juju` IRC channel on
freenode.

## More information

To learn more about Juju visit our home page at 
[https://jujucharms.com][upstream-juju].


<!-- LINKS -->

[reference-install]: ./reference-install.md
[juju-discourse-forum]: https://discourse.jujucharms.com/
[upstream-juju]: https://jujucharms.com
