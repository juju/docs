Title: 2.4.4 Release Notes 

# 2.4.4 Release Notes

The Juju team is pleased to announce the release of Juju 2.4.4.

This is a minor update to the 2.4.3 release. In particular, it fixes a
regression of goal-state in the individual related unit status, along with
allowing opening/closing ports without an external network.

- [LP #1789211](https://bugs.launchpad.net/juju/2.4/+bug/1789211) - opening/closing ports without external network
- [LP #1790647](https://bugs.launchpad.net/juju/2.4/+bug/1790647) - refreshing AWS instance types
- [LP #1713239](https://bugs.launchpad.net/juju/2.4/+bug/1713239) - supporting partition tagging
- [LP #1794739](https://bugs.launchpad.net/juju/2.4/+bug/1794739) - output individual related goal-state in unit status

For the full list of fixes and additions, see the
[2.4.4 milestone](https://launchpad.net/juju/+milestone/2.4.4).

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
